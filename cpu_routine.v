module main

fn (mut cpu CPU) routine_ld_n8(data []u8) u8 {
	cpu.advance_clocks(4)
	val := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.advance_clocks(4)
	return val
}

fn (mut cpu CPU) routine_ld_n16(data []u8) u16 {
	cpu.advance_clocks(4)
	lo := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.advance_clocks(4)
	hi := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.advance_clocks(4)
	return u16(hi) << 8 | u16(lo)
}

fn (mut cpu CPU) routine_ld_ptr8(data []u8, reg16 u16, reg8 u8) {
	cpu.advance_clocks(4)
	cpu.mbus.write(data, reg16, reg8)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_ld_ptr16(data []u8, reg16 u16) u8 {
	cpu.advance_clocks(4)
	reg8 := cpu.mbus.read(data, reg16)
	cpu.advance_clocks(4)
	return reg8
}

fn (mut cpu CPU) routine_inc_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry((reg & 0xf) == 0xf)
	reg8 := reg + 1
	cpu.set_flag_zero(reg8 == 0)
	cpu.advance_clocks(4)
	return reg8
}

fn (mut cpu CPU) routine_dec_n8(reg u8) u8 {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry((reg & 0xf) == 0x0)
	reg8 := reg - 1
	cpu.set_flag_zero(reg8 == 0)
	cpu.advance_clocks(4)
	return reg8
}

fn (mut cpu CPU) routine_inc_n16(reg u16) u16 {
	cpu.advance_clocks(4)
	reg16 := reg + 1
	cpu.advance_clocks(4)
	return reg16
}

fn (mut cpu CPU) routine_dec_n16(reg u16) u16 {
	cpu.advance_clocks(4)
	reg16 := reg - 1
	cpu.advance_clocks(4)
	return reg16
}

fn (mut cpu CPU) routine_add_hl16(reg u16) {
	cpu.set_flag_subtract(false)
	tmp := u32(cpu.r.hl) + u32(reg)
	cpu.set_flag_carry(tmp > 0xffff)
	cpu.set_flag_half_carry((cpu.r.hl & 0x0fff) + (reg & 0x0fff) > 0x0fff)
	cpu.advance_clocks(4)
	cpu.r.hl = u16(tmp & 0xffff)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_add_a8(reg u8) {
	cpu.set_flag_subtract(false)
	tmp := u32(cpu.r.af.hi())
	cpu.set_flag_half_carry((tmp & 0xf) + (u32(reg) & 0xf) > 0xf)
	cpu.r.af.set_hi(reg + cpu.r.af.hi())
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.set_flag_carry(tmp > cpu.r.af.hi())
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_sub_a8(reg u8) {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(cpu.r.af.hi() & 0xf < reg & 0xf)
	cpu.set_flag_carry(cpu.r.af.hi() < reg)
	cpu.r.af.set_hi(cpu.r.af.hi() - reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_adc_a8(reg u8) {
	cpu.set_flag_subtract(false)
	carry := u16(cpu.get_flag_carry())
	tmp := u16(cpu.r.af.hi()) + u16(reg) + carry
	cpu.set_flag_half_carry((u16(cpu.r.af.hi()) & 0xf) + (u16(reg) & 0xf) + carry > 0xf)
	cpu.set_flag_carry(tmp > 0xff)
	cpu.r.af.set_hi(u8(tmp & 0xff))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_sbc_a8(reg u8) {
	carry := u16(cpu.get_flag_carry())
	a := u16(cpu.r.af.hi())
	b := u16(reg) + carry
	cpu.set_flag_subtract(true)
	cpu.set_flag_carry(a < b)
	cpu.set_flag_half_carry((a & 0xf) < (u16(reg & 0xf) + carry))
	tmp := u8((a - b) & 0xff)
	cpu.r.af.set_hi(tmp)
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_and_a8(reg u8) {
	cpu.set_flag_half_carry(true)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() & reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_xor_a8(reg u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() ^ reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_or_a8(reg u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() | reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_cp_a8(reg u8) {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(cpu.r.af.hi() & 0xf < reg & 0xf)
	cpu.set_flag_carry(cpu.r.af.hi() < reg)
	cpu.set_flag_zero(cpu.r.af.hi() == reg)
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_rst_n16(data []u8, addr u16) {
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	pchi := cpu.r.pc.hi()
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.sp, pchi)
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.mbus.write(data, cpu.r.sp, cpu.r.pc.lo())
	cpu.r.pc = addr
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_push_n16(data []u8, reg Register) {
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.sp, reg.hi())
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.sp, reg.lo())
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_pop_n16(data []u8, reg u16) u16 {
	cpu.advance_clocks(4)
	lo := cpu.mbus.read(data, cpu.r.sp)
	cpu.r.sp++
	cpu.r.sp &= 0xffff
	cpu.advance_clocks(4)
	hi := cpu.mbus.read(data, cpu.r.sp)
	cpu.r.sp++
	cpu.r.sp &= 0xffff
	cpu.advance_clocks(4)
	return (u16(hi) << 8) | u16(lo)
}

fn (mut cpu CPU) routine_call_cond_a16(data []u8, cond bool) {
	cpu.advance_clocks(4)
	if cond {
		mut tmp := u32(cpu.mbus.read(data, cpu.r.pc))
		cpu.r.pc++
		cpu.advance_clocks(4)
		tmp |= u32(cpu.mbus.read(data, cpu.r.pc)) << 8
		cpu.r.pc++
		cpu.advance_clocks(4)
		cpu.r.sp--
		cpu.r.sp &= 0xffff
		pchi := cpu.r.pc.hi()
		cpu.advance_clocks(4)
		cpu.mbus.write(data, cpu.r.sp, pchi)
		cpu.advance_clocks(4)
		cpu.r.sp--
		cpu.r.sp &= 0xffff
		cpu.mbus.write(data, cpu.r.sp, cpu.r.pc.lo())
		cpu.r.pc = u16(tmp)
		cpu.advance_clocks(4)
	} else {
		cpu.r.pc++
		cpu.advance_clocks(4)
		cpu.r.pc++
		cpu.advance_clocks(4)
		cpu.r.pc &= 0xffff
	}
}

fn (mut cpu CPU) routine_ret_cond(data []u8, cond bool) {
	cpu.advance_clocks(4)
	if cond {
		mut tmp := u16(cpu.mbus.read(data, cpu.r.sp))
		cpu.r.sp++
		cpu.r.sp &= 0xffff
		cpu.advance_clocks(4)
		tmp |= u16(cpu.mbus.read(data, cpu.r.sp)) << 8
		cpu.r.sp++
		cpu.r.sp &= 0xffff
		cpu.advance_clocks(4)
		cpu.r.pc = tmp
		cpu.advance_clocks(4)
	} else {
		cpu.advance_clocks(4)
	}
}

fn (mut cpu CPU) routine_jp_cond_a16(data []u8, cond bool) {
	cpu.advance_clocks(4)
	if cond {
		mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
		cpu.r.pc++
		cpu.advance_clocks(4)
		tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
		cpu.advance_clocks(4)
		cpu.r.pc = tmp
		cpu.advance_clocks(4)
	} else {
		cpu.r.pc++
		cpu.advance_clocks(4)
		cpu.r.pc++
		cpu.advance_clocks(4)
	}
}

fn (mut cpu CPU) routine_jr_cond_e8(data []u8, cond bool) {
	cpu.advance_clocks(4)
	if cond {
		tmp := i8(cpu.mbus.read(data, cpu.r.pc))
		cpu.r.pc++
		cpu.advance_clocks(4)
		cpu.r.pc = (cpu.r.pc + u16(tmp)) & 0xffff
		cpu.advance_clocks(4)
	} else {
		cpu.r.pc++
		cpu.advance_clocks(4)
	}
}

fn (mut cpu CPU) routine_rlc_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(reg & 0x80 != 0)
	cpu.advance_clocks(4)
	r8 := reg << 1 | u8(cpu.get_flag_carry())
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_rrc_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(reg & 0x01 != 0)
	cpu.advance_clocks(4)
	r8 := reg >> 1 | u8(cpu.get_flag_carry()) << 7
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_rl_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	tmp := cpu.get_flag_carry()
	cpu.set_flag_carry(reg & 0x80 != 0)
	cpu.advance_clocks(4)
	r8 := reg << 1 | u8(tmp)
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_rr_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_zero(false)
	cpu.set_flag_half_carry(false)
	tmp := cpu.get_flag_carry()
	cpu.set_flag_carry(reg & 0x01 != 0)
	cpu.advance_clocks(4)
	r8 := reg >> 1 | u8(tmp) << 7
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_sla_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_zero(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(reg & 0x80 != 0)
	cpu.advance_clocks(4)
	r8 := reg << 1
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_sra_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_zero(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(reg & 0x01 != 0)
	cpu.advance_clocks(4)
	r8 := reg & 0x80 | reg >> 1
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_swap_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
	r8 := (reg >> 4) | (reg << 4)
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_srl_n8(reg u8) u8 {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(reg & 0x01 != 0)
	cpu.advance_clocks(4)
	r8 := reg >> 1
	cpu.set_flag_zero(r8 == 0)
	return r8
}

fn (mut cpu CPU) routine_bit_n_n8(bit u8, reg u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(true)
	cpu.set_flag_zero((reg & (1 << bit)) == 0)
}

fn (mut cpu CPU) routine_bit_n_ptrhl(data []u8, bit u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(true)
	cpu.advance_clocks(4)
	cpu.set_flag_zero((cpu.mbus.read(data, cpu.r.hl) & (1 << bit)) == 0)
}

fn (mut cpu CPU) routine_res_n_n8(bit u8, reg u8) u8 {
	cpu.advance_clocks(4)
	return reg & ~(1 << bit)
}

fn (mut cpu CPU) routine_res_n_ptrhl(data []u8, bit u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp & ~(1 << bit))
	cpu.advance_clocks(4)
}

fn (mut cpu CPU) routine_set_n_n8(bit u8, reg u8) u8 {
	cpu.advance_clocks(4)
	return reg | (1 << bit)
}

fn (mut cpu CPU) routine_set_n_ptrhl(data []u8, bit u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp | (1 << bit))
	cpu.advance_clocks(4)
}
