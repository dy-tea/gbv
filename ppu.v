module main

const lcd_pixels_width = 160
const lcd_pixels_height = 144
const ppu_render_scale = 3

const object_attribute_address = 0xfe00

struct ObjectAttributeData {
	pos_y   u8
	pos_x   u8
	tile_id u8
	flags   u8
}

struct OAMBufferData {
mut:
	oam_id u8
	drawn  bool
}

struct PixelFIFOData {
mut:
	color       u8
	from_sprite bool
}

struct PPU {
mut:
	r                            &LCDRegisters
	mbus                         &MemoryBus
	frame_pixels                 [lcd_pixels_width * lcd_pixels_height]u8
	sprite_palette_0             [4]u8 = [..]u8[0, 1, 2, 3]
	sprite_palette_1             [4]u8 = [..]u8[0, 1, 2, 3]
	background_palette           [4]u8 = [..]u8[0, 1, 2, 3]
	scanline_dot                 u16
	pixel_data                   [8]u8
	first_frame_after_lcd_enable bool
	oam_buffer_count             u8
	oam_search_index             u8
	oam_buffer                   [10]OAMBufferData
	fetcher_internal_clock       u8
	fetcher_sprite_active        bool
	oam_sprite_fetcher_index     u8
	fetcher_tile_no              u8
	fetcher_window_pixels        bool
	fetcher_internal_x_pos       u8
	fetcher_window_line_counter  u8
	fetcher_tile_data            [2]u8
	fetcher_first_scanline_steps bool
	pixel_fifo_cursor            u8
	pixel_fifo                   [16]PixelFIFOData
	pixel_fifo_occupancy         u8
	shifter_pixel_x              i16
	discard_pixels               u8
	frame_ready                  bool
}

fn PPU.new(mbus &MemoryBus) &PPU {
	return &PPU{
		mbus: mbus
		r:    unsafe { &LCDRegisters(&u8(mbus.memory) + 0xFF40) }
	}
}

fn (mut p PPU) reset() {
	p.r.control = 0x91
	p.r.status = 0x85
	p.r.ly = 0
	p.r.lyc = 0
	p.r.oam_daa = 0xff
	p.r.bgp = 0xfc
	p.r.obp0 = 0
	p.r.obp1 = 0
	p.r.wx = 0
	p.r.wy = 0
	p.scanline_dot = 0
	p.first_frame_after_lcd_enable = false
}

fn (mut p PPU) advance_clocks(clocks u8) {
	if !p.r.lcdc_enable_lcd() {
		return
	}

	for c in 0 .. clocks {
		ppu_mode := LCDSMode.new(p.r.lcds_ppu_mode())

		match ppu_mode {
			.oam_search {
				p.oam_search_tick()
				if p.scanline_dot == 79 {
					p.set_lcd_mode(.drawing)
					p.discard_pixels = p.r.scx % 8
				}
			}
			.drawing {
				p.fetcher_tick()
				p.shifter_tick()
				if !LCDSMode.drawing.eq(p.r.lcds_ppu_mode()) {
					continue
				}
			}
			.h_blank {
				if p.first_frame_after_lcd_enable && p.r.ly == 0 {
					match p.scanline_dot {
						79 {
							p.set_lcd_mode(.drawing)
						}
						451 {
							p.scanline_dot = 0
							p.r.ly++
							p.check_ly_compare()
							continue
						}
						else {}
					}
				}

				if p.scanline_dot == 455 {
					p.scanline_dot = 0
					p.r.ly++
					p.check_ly_compare()
					if p.r.ly == 144 {
						p.set_lcd_mode(.v_blank)
						p.mbus.interrupt_raise_flag(.vblank)
					} else {
						p.set_lcd_mode(.oam_search)
					}
					continue
				}
			}
			.v_blank {
				if p.scanline_dot == 455 {
					p.scanline_dot = 0
					p.r.ly++
					p.check_ly_compare()
					if p.r.ly == 154 {
						p.r.ly = 0
						p.render_frame()
						p.set_lcd_mode(.oam_search)
						p.first_frame_after_lcd_enable = false
					}
					p.check_ly_compare()
					continue
				}
			}
			else {}
		}

		p.scanline_dot++
	}
}

fn (mut p PPU) check_ly_compare() {
	p.r.status = if p.r.lcdc_enable_lcd() && p.r.ly == p.r.lyc {
		change_bit(p.r.status, 1, 2)
	} else {
		change_bit(p.r.status, 0, 2)
	}
}

fn (mut p PPU) check_stat_signal() {
	if !p.r.lcdc_enable_lcd() {
		return
	}

	ppu_mode := p.r.lcds_ppu_mode()
	if (p.r.ly == p.r.lyc && p.r.lcds_lyc_equals_ly_interrupt_enable())
		|| ((LCDSMode.oam_search).eq(ppu_mode) && p.r.lcds_mode_2_stat_interrupt_enable())
		|| ((LCDSMode.h_blank).eq(ppu_mode) && p.r.lcds_mode_0_stat_interrupt_enable())
		|| ((LCDSMode.v_blank).eq(ppu_mode) && p.r.lcds_mode_1_stat_interrupt_enable()) {
		p.mbus.interrupt_raise_flag(.lcd_stat)
	}
}

fn (mut p PPU) on_lyc_write(value u8) {
	p.r.lyc = value

	if p.r.lcdc_enable_lcd() {
		p.check_ly_compare()
		p.check_stat_signal()
	}
}

fn (mut p PPU) set_lcd_mode(mode LCDSMode) {
	ppu_mode := p.r.lcds_ppu_mode()
	prev_lcd_status := p.r.status
	new_lcd_status := prev_lcd_status & 0b11111100 | u8(mode)
	p.r.status = new_lcd_status

	if u8(mode) != ppu_mode {
		p.check_stat_signal()
		match mode {
			.v_blank {
				p.fetcher_reset()
			}
			.oam_search {
				p.oam_search_index = 0
				p.oam_buffer_count = 0
			}
			.drawing {
				p.pixel_fifo = [16]PixelFIFOData{}
			}
			else {}
		}
	}
}

fn (mut p PPU) on_lcd_control_write(value u8) {
	prev_lcd_enabled := p.r.lcdc_enable_lcd()
	p.r.control = value
	new_lcd_enabled := p.r.lcdc_enable_lcd()

	if new_lcd_enabled != prev_lcd_enabled {
		p.scanline_dot = 0
		p.r.ly = 0
		p.set_lcd_mode(.h_blank)

		if new_lcd_enabled {
			p.first_frame_after_lcd_enable = true
		}

		p.check_stat_signal()
	}
}

fn (mut p PPU) on_lcd_status_write(value u8) {
	prev_value := p.r.status
	new_value := (prev_value & 0b10000111) | (value & 0b01111000)
	p.r.status = new_value
	p.check_stat_signal()
}

fn (mut p PPU) extract_palette(addr u16) [4]u8 {
	unsafe {
		pal := p.mbus.memory[addr]
		return [4]u8[
			pal & 0b00000011,
			(pal & 0b00001100) >> 2,
			(pal & 0b00110000) >> 4,
			(pal & 0b11000000) >> 6,
		]
	}
}

fn (mut p PPU) on_palette_write(addr u16) {
	if addr == 0xff47 {
		p.background_palette = p.extract_palette(addr)
	} else if addr == 0xff48 {
		p.sprite_palette_0 = p.extract_palette(addr)
	} else if addr == 0xff49 {
		p.sprite_palette_1 = p.extract_palette(addr)
	}
}

fn (mut p PPU) oam_search_tick() {
	if p.scanline_dot % 2 == 0 || p.oam_buffer_count == 10 {
		return
	}

	oam_sprite_data := unsafe { &u8(p.mbus.memory) + object_attribute_address }
	sprite_height := if p.r.lcdc_sprite_size() { 16 } else { 8 }
	attribute_data_index := p.oam_search_index * 4
	sprite := unsafe { &ObjectAttributeData(oam_sprite_data + attribute_data_index) }
	pos_y := sprite.pos_y
	ly := p.r.ly + 16
	if sprite.pos_x > 0 && ly >= pos_y && ly < pos_y + sprite_height {
		p.oam_buffer[p.oam_buffer_count] = OAMBufferData{
			oam_id: attribute_data_index
			drawn:  false
		}
		p.oam_buffer_count++
	}
	p.oam_search_index++
}

fn (mut p PPU) fetcher_tick() {
	p.fetcher_internal_clock++
	match p.fetcher_internal_clock {
		2 {
			if p.fetcher_sprite_active {
				oam_sprite_data := unsafe { &u8(p.mbus.memory) + object_attribute_address }
				sprite := unsafe { &ObjectAttributeData(oam_sprite_data + p.oam_buffer[p.oam_sprite_fetcher_index].oam_id) }
				p.fetcher_tile_no = sprite.tile_id
			} else {
				if !p.fetcher_window_pixels || !p.r.lcdc_window_enable() {
					offset := if p.r.lcdc_bg_tile_map_select() {
						0x9C00
					} else {
						0x9800
					}
					tile_map_data := unsafe { &u8(p.mbus.memory + offset) }
					tile_x_offset := u16((p.fetcher_internal_x_pos + (p.r.scx / 8)) & 0x1f)
					tile_y_offset := u16(32 * (((p.r.ly + p.r.scy) & 0xff) / 8))
					tile_address := (tile_x_offset + tile_y_offset) & 0x3ff
					p.fetcher_tile_no = unsafe { tile_map_data[tile_address] }
				} else {
					offset := if p.r.lcdc_window_tile_map_select() {
						0x9C00
					} else {
						0x9800
					}
					tile_map_data := unsafe { &u8(p.mbus.memory + offset) }
					tile_x_offset := p.fetcher_internal_x_pos
					tile_y_offset := u16(32 * (p.fetcher_window_line_counter / 8))
					tile_address := (tile_x_offset + tile_y_offset) & 0x3ff
					p.fetcher_tile_no = unsafe { tile_map_data[tile_address] }
				}
			}
		}
		4, 6 {
			high_byte := p.fetcher_internal_clock == 6
			high_byte_offset := if high_byte { 1 } else { 0 }
			if p.fetcher_sprite_active {
				oam_sprite_data := unsafe { &u8(p.mbus.memory + object_attribute_address) }
				sprite := unsafe { &ObjectAttributeData(oam_sprite_data + p.oam_buffer[p.oam_sprite_fetcher_index].oam_id) }
				flip_y := check_bit(sprite.flags, 6)
				flip_offset := if p.r.lcdc_sprite_size() { 30 } else { 14 }
				vertical_offset := 2 * (p.r.ly - (sprite.pos_y - 16))
				offset := if flip_y {
					i32(flip_offset) - i32(vertical_offset)
				} else {
					i32(vertical_offset)
				}
				addr := 0x8000 + i32(p.fetcher_tile_no) * 16 + offset + high_byte_offset
				p.fetcher_tile_data[int(high_byte)] = unsafe { p.mbus.memory[addr] }
			} else {
				data_select_offset := if p.r.lcdc_tile_data_select() { 0x8000 } else { 0x9000 }
				tile_index := if p.r.lcdc_tile_data_select() {
					i32(p.fetcher_tile_no)
				} else {
					i32(i8(p.fetcher_tile_no))
				}
				row_offset := if !p.fetcher_window_pixels {
					i32(2 * ((p.r.ly + p.r.scy) % 8))
				} else {
					i32(2 * (p.fetcher_window_line_counter % 8))
				}
				addr := data_select_offset + tile_index * 16 + row_offset + high_byte_offset
				p.fetcher_tile_data[int(high_byte)] = unsafe { p.mbus.memory[addr] }
			}
		}
		else {}
	}
	if p.fetcher_internal_clock >= 6 {
		if p.fetcher_sprite_active {
			oam_sprite_data := unsafe { &u8(p.mbus.memory + object_attribute_address) }
			sprite := unsafe { &ObjectAttributeData(oam_sprite_data + p.oam_buffer[p.oam_sprite_fetcher_index].oam_id) }
			sprite_uses_palette_1 := check_bit(sprite.flags, 4)
			sprite_flip_x := check_bit(sprite.flags, 5)
			sprite_bg_priority := check_bit(sprite.flags, 7)
			for column in 0 .. 8 {
				right_bit := (p.fetcher_tile_data[0] & (0b10000000 >> column)) >> (7 - column)
				left_bit := (p.fetcher_tile_data[1] & (0b10000000 >> column)) >> (7 - column)
				pixel_value_sprite := u8((left_bit << 1) | right_bit)
				index := (p.pixel_fifo_cursor + (if sprite_flip_x { 7 - column } else { column })) % 16
				if pixel_value_sprite > 0 && !p.pixel_fifo[index].from_sprite && !(sprite_bg_priority && p.pixel_fifo[index].color > 0) {
					paletted_pixel_value_sprite := if sprite_uses_palette_1 {
						p.sprite_palette_1[pixel_value_sprite]
					} else {
						p.sprite_palette_0[pixel_value_sprite]
					}
					p.pixel_fifo[index].color = paletted_pixel_value_sprite
					p.pixel_fifo[index].from_sprite = true
				}
			}

			p.oam_buffer[p.oam_sprite_fetcher_index].drawn = true
			p.fetcher_internal_clock = 0
			p.fetcher_sprite_active = false
		} else if p.pixel_fifo_occupancy <= 8 {
			for column in 0 .. 8 {
				index := (p.pixel_fifo_cursor + p.pixel_fifo_occupancy) % 16
				right_bit := (p.fetcher_tile_data[0] & (0b10000000 >> column)) >> (7 - column)
				left_bit := (p.fetcher_tile_data[1] & (0b10000000 >> column)) >> (7 - column)
				pixel_value_bg := u8((left_bit << 1) | right_bit)
				p.pixel_fifo[index].color = if p.r.lcdc_bg_window_enable() {
					pixel_value_bg
				} else {
					0
				}
				p.pixel_fifo[index].from_sprite = false
				p.pixel_fifo_occupancy++
			}

			p.fetcher_internal_clock = 0
			if !p.fetcher_first_scanline_steps {
				p.fetcher_internal_x_pos++
			} else {
				p.fetcher_first_scanline_steps = false
			}
		}
	}
}

fn (mut p PPU) shifter_tick() {
	if p.fetcher_sprite_active || p.pixel_fifo_occupancy <= 8 {
		return
	}

	if p.r.lcdc_sprite_enable() && p.oam_buffer_count > 0 {
		oam_sprite_data := unsafe { &u8(p.mbus.memory + object_attribute_address) }
		for i in 0 .. 10 {
			if p.oam_buffer[i].drawn { continue }
			sprite := unsafe { &ObjectAttributeData(oam_sprite_data + p.oam_buffer[i].oam_id) }
			if sprite.pos_x <= p.shifter_pixel_x + 8 && sprite.pos_x > p.shifter_pixel_x {
				p.oam_sprite_fetcher_index = i
				p.fetcher_internal_clock = 0
				p.fetcher_sprite_active = true
				return
			}
		}
	}

	if p.discard_pixels > 0 && !p.fetcher_window_pixels {
		p.discard_pixels--
		p.pixel_fifo_occupancy--
		p.pixel_fifo_cursor++
		return
	}

	if p.shifter_pixel_x >= 0 {
		pixel_value := p.pixel_fifo[p.pixel_fifo_cursor].color
		screen_index := p.r.ly * lcd_pixels_width + p.shifter_pixel_x
		p.frame_pixels[screen_index] = if p.pixel_fifo[p.pixel_fifo_cursor].from_sprite {
			pixel_value
		} else {
			p.background_palette[pixel_value]
		}
	}

	p.shifter_pixel_x++
	p.pixel_fifo_occupancy--
	p.pixel_fifo_cursor = (p.pixel_fifo_cursor + 1) % 16
	if p.r.lcdc_window_enable() && p.r.wy == p.r.ly && p.shifter_pixel_x >= p.r.wx - 7 && !p.fetcher_window_pixels {
		p.fetcher_reset()
		p.fetcher_window_pixels = true
	}

	if p.shifter_pixel_x == lcd_pixels_width {
		p.shifter_pixel_x = -8
		p.pixel_fifo_cursor = 0
		p.pixel_fifo_occupancy = 0
		p.fetcher_internal_x_pos = 0
		p.fetcher_internal_clock = 0
		p.fetcher_first_scanline_steps = true
		if p.fetcher_window_pixels {
			p.fetcher_window_line_counter++
		}
		p.set_lcd_mode(.h_blank)
	}
}

fn (mut p PPU) fetcher_reset() {
	p.fetcher_sprite_active = false
	p.fetcher_internal_clock = 0
	p.fetcher_internal_x_pos = 0
	p.fetcher_window_pixels = false
	p.fetcher_window_line_counter = 0
	p.fetcher_tile_no = 0
	p.fetcher_tile_data = [2]u8{}
	p.pixel_fifo = [16]PixelFIFOData{}
	p.pixel_fifo_occupancy = 0
	p.pixel_fifo_cursor = 0
}

fn (mut p PPU) render_frame() {
	p.frame_ready = true
}
