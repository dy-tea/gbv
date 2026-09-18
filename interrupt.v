module main

enum InterruptFlag as u8 {
	vblank   = u8(1 << 0)
	lcd_stat = u8(1 << 1)
	timer    = u8(1 << 2)
	serial   = u8(1 << 3)
	joypad   = u8(1 << 4)
}

const interrupt_handler_vblank = u16(0x0040)
const interrupt_handler_lcd_stat = u16(0x0048)
const interrupt_handler_timer = u16(0x0050)
const interrupt_handler_serial = u16(0x0058)
const interrupt_handler_joypad = u16(0x0060)

struct InterruptData {
mut:
	master_enable    bool
	enable_ime_delay u8
}
