module main

type Register = u16

fn (r Register) hi() u8 {
	return u8(r >> 8)
}

fn (mut r Register) set_hi(hi u8) {
	r &= u16(hi) << 8
}

fn (r Register) lo() u8 {
	return u8(r & 0x00ff)
}

fn (mut r Register) set_lo(lo u8) {
	r &= u16(lo)
}
