module main

const interrupt_flag_vblank = u8(1 << 0)
const interrupt_flag_lcd_stat = u8(1 << 1)
const interrupt_flag_timer = u8(1 << 2)
const interrupt_flag_serial = u8(1 << 3)
const interrupt_flag_joypad = u8(1 << 4)

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
