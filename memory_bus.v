module main

const addr_io_if = 0xff0f // interrupt flag
const addr_io_ie = 0xffff // interrupt enable

@[heap; noinit]
struct MemoryBus {
mut:
	memory              &u8
	timer               Timer
	eram                [1024 * 8 * 4]u8
	rom_bank_num        u8
	ram_bank_num        u8
	ram_enabled         bool
	rom_ram_mode_select bool
	cart_header         CartHeader
	// Debug
	serial_capture bool
	serial_buffer  []u8
}

fn MemoryBus.new() &MemoryBus {
	memory := unsafe { C.malloc(1024 * 64 * 8) }
	return &MemoryBus{
		memory:         memory
		serial_capture: false
		serial_buffer:  []u8{}
		timer:          Timer{
			r:     unsafe { &TimerRegisters(&u8(memory) + 0xff04) }
			iflag: unsafe { &u8(memory) + 0xff0f }
			ly:    unsafe { &u8(memory) + 0xff44 }
			lcdc:  unsafe { &u8(memory) + 0xff40 }
		}
	}
}

fn (mut mb MemoryBus) interrupt_enable_write(value u8) {
	unsafe { mb.memory[addr_io_ie] = value }
}

fn (mut mb MemoryBus) interrupt_flag_write(value u8) {
	unsafe { mb.memory[addr_io_if] = value }
}

fn (mut mb MemoryBus) interrupt_raise_flag(flag u8) {
	unsafe { mb.memory[addr_io_if] |= flag }
}

fn (mb MemoryBus) read(data []u8, addr u16) u8 {
	cart_info := cart_type_data[mb.cart_header.cartridge_type]

	return match addr {
		0x0000...0x3FFF { // ROM Bank 00
			data[addr]
		}
		0x4000...0x7FFF { // ROM Bank 01
			match cart_info.type {
				.no_mbc {
					data[addr]
				}
				.mbc1 {
					rom_bank_size := 0x4000
					rom_bank := if mb.rom_bank_num > 0 { mb.rom_bank_num } else { u8(1) }
					offset := rom_bank_size * (rom_bank - 1)
					data[offset + addr]
				}
				else {
					panic('Unhandled cart_info.type for ROM Bank 01: ${cart_info.type}')
				}
			}
		}
		0x8000...0x9FFF { // VRAM
			unsafe { mb.memory[addr] }
		}
		0xA000...0xBFFF { // External RAM
			match cart_info.type {
				.no_mbc {
					mb.eram[addr - 0xA000]
				}
				.mbc1 {
					bank_offset := mb.ram_bank_num * 0x2000
					eram_addr := (addr - 0xA000) + bank_offset
					mb.eram[eram_addr]
				}
				else {
					panic('TODO: read ERAM, ${cart_info.type}')
				}
			}
		}
		0xC000...0xCFFF { // WRAM 1
			unsafe { mb.memory[addr] }
		}
		0xD000...0xDFFF { // WRAM 2
			unsafe { mb.memory[addr] }
		}
		0xE000...0xFDFF { // Echo RAM
			unsafe { mb.memory[addr - 0x2000] }
		}
		0xFE00...0xFE9F { // Object Attribute Memory
			// TODO: if PPU mode == 2 return 0xFF
			unsafe { mb.memory[addr] }
		}
		0xFEA0...0xFEFF { // Unused
			// TODO: if PPU mode == 3 return 0xFF
			0x00
		}
		0xFF00...0xFF7F { // I/O Registers
			if addr == addr_io_if {
				unsafe { mb.memory[addr] | 0xE0 }
			} else {
				unsafe { mb.memory[addr] }
			}
		}
		0xFF80...0xFFFE { // High RAM
			unsafe { mb.memory[addr] }
		}
		0xFFFF { // Interrupt Enable Register
			unsafe { mb.memory[addr] }
		}
		else {
			unsafe { mb.memory[addr] }
		}
	}
}

fn (mut mb MemoryBus) write(data []u8, addr u16, val u8) {
	cart_info := cart_type_data[mb.cart_header.cartridge_type]
	if cart_info.type == .mbc1 {
		match addr {
			0x0000...0x1FFF { // RAM Enable
				mb.ram_enabled = (val & 0xF0) == 0x0A
			}
			0x2000...0x3FFF { // Set ROM Bank num
				mb.rom_bank_num = val & 0b00011111
				rom_size := 32 * (1 << mb.cart_header.rom_size)
				num_rom_banks := u8(rom_size / 16)
				mb.rom_bank_num %= num_rom_banks
			}
			0x4000...0x5FFF { // ROM/RAM Bank write
				if mb.rom_ram_mode_select {
					mb.ram_bank_num = val & 0x00000011
				} else {
					mb.rom_bank_num = (mb.rom_bank_num & 0b00011111) | ((val & 0b00000011) << 5)
				}
			}
			0x6000...0x7FFF { // Set ROM/RAM Bank mode select
				mb.rom_ram_mode_select = val & 1 != 0
			}
			else {}
		}
	}

	match addr {
		0x8000...0x9FFF { // VRAM
			unsafe { mb.memory[addr] = val }
		}
		0xA000...0xBFFF { // ERAM
			match cart_info.type {
				.no_mbc {
					mb.eram[addr - 0xA000] = val
				}
				.mbc1 {
					ram_bank_size := 0x2000
					offset := ram_bank_size * mb.ram_bank_num
					eram_addr := offset + (addr - 0xA000)
					mb.eram[eram_addr] = val
				}
				else {
					panic('TODO: write ERAM, ${cart_info.type}')
				}
			}
		}
		0xC000...0xCFFF { // WRAM 1
			unsafe { mb.memory[addr] = val }
		}
		0xD000...0xDFFF { // WRAM 2
			unsafe { mb.memory[addr] = val }
		}
		0xE000...0xFDFF { // Echo RAM
			unsafe { mb.memory[addr - 0x2000] = val }
		}
		0xFE00...0xFE9F { // Object Attribute Memory
			// TODO: if PPU mode is 2 or 3, cannot access OAM
			unsafe { mb.memory[addr] = val }
		}
		0xFEA0...0xFEFF {} // Unused
		0xFF00...0xFF7F { // I/O Registers
			match addr {
				0xFF02 {
					// Blargg serial output
					if val == 0x81 && mb.serial_capture {
						mb.serial_buffer << unsafe { mb.memory[0xff01] }
					}
				}
				0xFF04 { // Timer DIV
					mb.timer.on_div_write(val)
				}
				0xFF07 { // Timer Control
					unsafe { mb.memory[addr] = val & 0b00000111 }
				}
				0xFF46 { // OEM DMA
					source_addr := u16(val * 0x100)
					dest := 0xFE00
					for i in 0 .. 160 {
						unsafe {
							mb.memory[dest + i] = mb.read(data, source_addr + i)
						}
					}
				}
				else {
					unsafe { mb.memory[addr] = val }
				}
			}
		}
		0xFF80...0xFFFE { // HRAM
			unsafe { mb.memory[addr] = val }
		}
		0xFFFF { // Interrupt Enable
			mb.interrupt_enable_write(val)
		}
		else {
			unsafe { mb.memory[addr] = val }
		}
	}
}
