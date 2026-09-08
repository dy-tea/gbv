module main

struct CPURegisters {
mut:
	af Register
	bc Register
	de Register
	hl Register
	sp Register
	pc Register
}

struct CPU {
mut:
	r      CPURegisters
	opcode u8
	ic     u32
	inst   ?CPUInstruction
	clocks u32
}

fn (mut cpu CPU) reset() {
	cpu.r.af = 0x01B0
	cpu.r.bc = 0x0013
	cpu.r.de = 0x00D8
	cpu.r.hl = 0x014D
	cpu.r.sp = 0xFFFE
	cpu.r.pc = 0x0100
}

fn (mut cpu CPU) fetch(program []u8) {
	cpu.opcode = program[cpu.r.pc]
	cpu.r.pc++
	cpu.inst = inst(cpu.opcode)
}

fn (mut cpu CPU) execute(program []u8) {
	if inst := cpu.inst {
		println(inst)
		if f := inst.function {
			f(mut cpu, program)
		} else {
			panic('unimplemented: ${inst.disassembly}')
		}
	} else {
		println('Unknown instruction at: 0x${cpu.r.pc.hi():x}${cpu.r.pc.lo():x}, count 0x${cpu.ic:x}')
	}
}

fn (mut cpu CPU) routine_ld_n8(data []u8) u8 {
	cpu.clocks += 4
	val := memory_bus_read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.clocks += 4
	return val
}

fn (mut cpu CPU) routine_ld_n16(data []u8) u16 {
	cpu.clocks += 4
	lo := memory_bus_read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.clocks += 4
	hi := memory_bus_read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.clocks += 4
	return u16(hi) << 8 | u16(lo)
}

fn (mut cpu CPU) routine_ld_ptr8(data []u8, reg16 u16, reg8 u8) {
	cpu.clocks += 4
	memory_bus_write(data, reg16, reg8)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_ld_ptr16(data []u8, reg16 u16) u8 {
	cpu.clocks += 4
	reg8 := memory_bus_read(data, reg16)
	cpu.clocks += 4
	return reg8
}

fn (mut cpu CPU) routine_inc_n8(reg u8) u8 {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry((reg & 0xf) == 0x0)
	reg8 := reg + 1
	cpu.set_flag_zero(reg8 == 0)
	cpu.clocks += 4
	return reg8
}

fn (mut cpu CPU) routine_dec_n8(reg u8) u8 {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry((reg & 0xf) == 0x0)
	reg8 := reg - 1
	cpu.set_flag_zero(reg8 == 0)
	cpu.clocks += 4
	return reg8
}

fn (mut cpu CPU) routine_inc_n16(reg u16) u16 {
	cpu.clocks += 4
	reg16 := reg + 1
	cpu.clocks += 4
	return reg16
}

fn (mut cpu CPU) routine_dec_n16(reg u16) u16 {
	cpu.clocks += 4
	reg16 := reg - 1
	cpu.clocks += 4
	return reg16
}

fn (mut cpu CPU) routine_add_hl16(reg u16) {
	cpu.set_flag_subtract(false)
	tmp := cpu.r.hl + reg
	cpu.set_flag_carry(tmp > 0xffff)
	hc := cpu.r.hl & 0x0fff + reg & 0x0fff > 0x0fff
	cpu.set_flag_half_carry(hc)
	cpu.clocks += 4
	cpu.r.hl = tmp & 0xffff
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_add_a8(reg u8) {
	cpu.set_flag_subtract(false)
	tmp := u32(cpu.r.af.hi())
	cpu.set_flag_half_carry(tmp & 0xf + u32(reg) & 0xf > 0xf)
	cpu.r.af.set_hi(reg + cpu.r.af.hi())
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.set_flag_carry(tmp > cpu.r.af.hi())
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_sub_a8(reg u8) {
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(cpu.r.af.hi() & 0xf < reg & 0xf)
	cpu.set_flag_carry(cpu.r.af.hi() < reg)
	cpu.r.af.set_hi(cpu.r.af.hi() - reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_adc_a8(reg u8) {
	cpu.set_flag_subtract(false)
	carry := cpu.get_flag_carry()
	mut tmp := cpu.r.af.hi() + reg + u8(carry)
	hc := cpu.r.af.hi() & 0xf + reg & 0xf + u8(carry) > 0xf
	cpu.set_flag_half_carry(hc)
	cpu.set_flag_carry(tmp > 0xff)
	tmp &= 0xff
	cpu.r.af.set_hi(tmp)
	cpu.set_flag_zero(tmp == 0)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_sbc_a8(reg u8) {
	tmp := cpu.r.af.hi() - (reg + u8(cpu.get_flag_carry()))
	cpu.set_flag_subtract(true)
	cpu.set_flag_carry(tmp & ~0xff != 0)
	cpu.set_flag_half_carry((cpu.r.af.hi() ^ reg ^ tmp) & 0x10 != 0)
	cpu.r.af.set_hi(tmp)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_and_a8(reg u8) {
	cpu.set_flag_half_carry(true)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() & reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_xor_a8(reg u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() ^ reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_or_a8(reg u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.r.af.set_hi(cpu.r.af.hi() | reg)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_cp_a8(reg u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(cpu.r.af.hi() & 0xf < reg & 0xf)
	cpu.set_flag_carry(cpu.r.af.hi() < reg)
	cpu.set_flag_zero(cpu.r.af.hi() == reg)
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_rst_n16(data []u8, addr u16) {
	cpu.clocks += 4
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	pchi := cpu.r.pc.hi()
	cpu.clocks += 4
	memory_bus_write(data, cpu.r.sp, pchi)
	cpu.clocks += 4
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	memory_bus_write(data, cpu.r.sp, cpu.r.pc.lo())
	cpu.r.pc = addr
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_push_n16(data []u8, reg Register) {
	cpu.clocks += 4
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.clocks += 4
	memory_bus_write(data, cpu.r.sp, reg.hi())
	cpu.clocks += 4
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.clocks += 4
	memory_bus_write(data, cpu.r.sp, reg.lo())
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_pop_n16(data []u8, reg u16) u16 {
	cpu.clocks += 4
	lo := memory_bus_read(data, cpu.r.sp)
	cpu.r.sp++
	cpu.r.sp &= 0xffff
	cpu.clocks += 4
	hi := memory_bus_read(data, cpu.r.sp)
	cpu.r.sp++
	cpu.r.sp &= 0xffff
	cpu.clocks += 4
	return (u16(hi) << 8) & u16(lo)
}

fn (mut cpu CPU) routine_call_cond_a16(data []u8, cond bool) {
	cpu.clocks += 4
	if cond {
		mut tmp := u32(memory_bus_read(data, cpu.r.pc))
		cpu.r.pc++
		cpu.clocks += 4
		tmp |= u32(memory_bus_read(data, cpu.r.pc)) << 8
		cpu.r.pc++
		cpu.clocks += 4
		cpu.r.sp--
		cpu.r.sp &= 0xffff
		pchi := cpu.r.pc.hi()
		cpu.clocks += 4
		memory_bus_write(data, cpu.r.sp, pchi)
		cpu.clocks += 4
		cpu.r.sp--
		cpu.r.sp &= 0xffff
		memory_bus_write(data, cpu.r.sp, cpu.r.pc.lo())
		cpu.r.pc = u16(tmp)
		cpu.clocks += 4
	} else {
		cpu.r.pc++
		cpu.clocks += 4
		cpu.r.pc++
		cpu.clocks += 4
		cpu.r.pc &= 0xffff
	}
}

fn (mut cpu CPU) routine_ret_cond(data []u8, cond bool) {
	cpu.clocks += 4
	if cond {
		tmp := u16(memory_bus_read(data, cpu.r.sp))
		cpu.r.sp++
		cpu.r.sp &= 0xffff
		cpu.clocks += 4
		cpu.r.pc = tmp
		cpu.clocks += 4
		cpu.clocks += 4
	} else {
		cpu.clocks += 4
	}
}

fn (mut cpu CPU) routine_jp_cond_a16(data []u8, cond bool) {
	cpu.clocks += 4
	if cond {
		mut tmp := u16(memory_bus_read(data, cpu.r.pc))
		cpu.r.pc++
		cpu.clocks += 4
		tmp |= u16(memory_bus_read(data, cpu.r.pc)) << 8
		cpu.clocks += 4
		cpu.r.pc = tmp
		cpu.clocks += 4
	} else {
		cpu.r.pc++
		cpu.clocks += 4
		cpu.r.pc++
		cpu.clocks += 4
	}
}

fn (mut cpu CPU) routine_jr_cond_e8(data []u8, cond bool) {
	cpu.clocks += 4
	if cond {
		tmp := memory_bus_read(data, cpu.r.pc)
		cpu.r.pc++
		cpu.clocks += 4
		cpu.r.pc = (cpu.r.pc + tmp) & 0xffff
		cpu.clocks += 4
	} else {
		cpu.r.pc++
		cpu.clocks += 4
	}
}

fn (mut cpu CPU) set_flag_zero(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 7)) | (u32(val) << 7)))
}

fn (mut cpu CPU) get_flag_zero() bool {
	return (cpu.r.af.lo() & ~(u32(1) << 7)) >> 7 != 0
}

fn (mut cpu CPU) set_flag_subtract(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 6)) | (u32(val) << 6)))
}

fn (mut cpu CPU) get_flag_subtract() bool {
	return (cpu.r.af.lo() & ~(u32(1) << 6)) >> 6 != 0
}

fn (mut cpu CPU) set_flag_half_carry(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 5)) | (u32(val) << 5)))
}

fn (mut cpu CPU) get_flag_half_carry() bool {
	return (cpu.r.af.lo() & ~(u32(1) << 5)) >> 5 != 0
}

fn (mut cpu CPU) set_flag_carry(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 4)) | (u32(val) << 4)))
}

fn (mut cpu CPU) get_flag_carry() bool {
	return (cpu.r.af.lo() & ~(u32(1) << 4)) >> 4 != 0
}
