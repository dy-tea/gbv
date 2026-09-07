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

fn (mut cpu CPU) pc_inc() {
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
}

fn (mut cpu CPU) routine_ld_8(data []u8) u8 {
	cpu.clocks += 4
	val := memory_bus_read(data, cpu.r.pc)
	cpu.pc_inc()
	cpu.clocks += 4
	return val
}

fn (mut cpu CPU) routine_ld_16(data []u8) u16 {
	cpu.clocks += 4
	lo := memory_bus_read(data, cpu.r.pc)
	cpu.pc_inc()
	cpu.clocks += 4
	hi := memory_bus_read(data, cpu.r.pc)
	cpu.pc_inc()
	cpu.clocks += 4
	return u16(hi) << 8 | u16(lo)
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
