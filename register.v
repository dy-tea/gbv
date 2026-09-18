module main

type Register = u16

fn (r Register) str() string {
	return '0x${u16(r):04X}'
}

@[inline]
fn (r Register) hi() u8 {
	return u8(r >> 8)
}

@[inline]
fn (mut r Register) set_hi(hi u8) {
	r &= 0x00ff
	r |= u16(hi) << 8
}

@[inline]
fn (r Register) lo() u8 {
	return u8(r & 0x00ff)
}

@[inline]
fn (mut r Register) set_lo(lo u8) {
	r &= 0xff00
	r |= u16(lo)
}
