module main

enum LCDSMode as u8 {
	h_blank    = 0
	v_blank    = 1
	oam_search = 2
	drawing    = 3
}

fn LCDSMode.new(val u8) LCDSMode {
	return match val {
		0 { .h_blank }
		1 { .v_blank }
		2 { .oam_search }
		3 { .drawing }
		else { panic('invalid LCDSMode: ${val}') }
	}
}

@[inline]
fn (l LCDSMode) eq(val u8) bool {
	return u8(l) == val
}

struct LCDRegisters {
mut:
	control u8
	status  u8
	scy     u8
	scx     u8
	ly      u8
	lyc     u8
	oam_daa u8
	bgp     u8
	obp0    u8
	obp1    u8
	wy      u8
	wx      u8
}

/* Control Flags */

@[inline]
fn (r LCDRegisters) lcdc_enable_lcd() bool {
	return check_bit(r.control, 7)
}

@[inline]
fn (r LCDRegisters) lcdc_window_tile_map_select() bool {
	return check_bit(r.control, 6)
}

@[inline]
fn (r LCDRegisters) lcdc_window_enable() bool {
	return check_bit(r.control, 5)
}

@[inline]
fn (r LCDRegisters) lcdc_tile_data_select() bool {
	return check_bit(r.control, 4)
}

@[inline]
fn (r LCDRegisters) lcdc_bg_tile_map_select() bool {
	return check_bit(r.control, 3)
}

@[inline]
fn (r LCDRegisters) lcdc_sprite_size() bool {
	return check_bit(r.control, 2)
}

@[inline]
fn (r LCDRegisters) lcdc_sprite_enable() bool {
	return check_bit(r.control, 1)
}

@[inline]
fn (r LCDRegisters) lcdc_bg_window_enable() bool {
	return check_bit(r.control, 0)
}

/* Status Flags */

@[inline]
fn (r LCDRegisters) lcds_lyc_equals_ly_interrupt_enable() bool {
	return check_bit(r.status, 6)
}

@[inline]
fn (r LCDRegisters) lcds_mode_2_stat_interrupt_enable() bool {
	return check_bit(r.status, 5)
}

@[inline]
fn (r LCDRegisters) lcds_mode_1_stat_interrupt_enable() bool {
	return check_bit(r.status, 4)
}

@[inline]
fn (r LCDRegisters) lcds_mode_0_stat_interrupt_enable() bool {
	return check_bit(r.status, 3)
}

@[inline]
fn (r LCDRegisters) lcds_coincedence_flag() bool {
	return check_bit(r.status, 2)
}

@[inline]
fn (r LCDRegisters) lcds_ppu_mode() u8 {
	return r.status & 0b00000011
}
