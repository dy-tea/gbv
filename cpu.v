module main

union Register {
mut:
	half struct {
	mut:
		lo u8
		hi u8
	}
	full u16
}

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
	cpu.r.af.full = 0x01B0
	cpu.r.bc.full = 0x0013
	cpu.r.de.full = 0x00D8
	cpu.r.hl.full = 0x014D
	cpu.r.sp.full = 0xFFFE
	cpu.r.pc.full = 0x0100
}

fn (mut cpu CPU) fetch(program []u8) {
	unsafe {
		cpu.opcode = program[cpu.r.pc.full]
		cpu.r.pc.full++
	}
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
		unsafe {
			println('Unknown instruction at: 0x${cpu.r.pc.half.hi:x}${cpu.r.pc.half.lo:x}, count 0x${cpu.ic:x}')
		}
	}
}

fn (mut cpu CPU) pc_inc() {
	unsafe {
		cpu.r.pc.full++
		cpu.r.pc.full &= 0xFFFF
	}
}

fn (mut cpu CPU) routine_ld_8(data []u8, mut r8 &u8) {
	cpu.clocks += 4
	r8 = memory_bus_read(data, unsafe {cpu.r.pc.full})
	cpu.pc_inc()
	cpu.clocks += 4
}

fn (mut cpu CPU) routine_ld_16(data []u8, mut hi &u8, mut lo &u8) {
	cpu.clocks += 4
	lo = memory_bus_read(data, unsafe {cpu.r.pc.full})
	cpu.pc_inc()
	cpu.clocks += 4
	hi = memory_bus_read(data, unsafe {cpu.r.pc.full})
	cpu.pc_inc()
	cpu.clocks += 4
}

fn (mut cpu CPU) set_flag_zero(val bool) {
	unsafe {
		cpu.r.af.half.lo = u8((cpu.r.af.half.lo & ~(u32(1) << 7)) | (u32(val) << 7))
	}
}

fn (mut cpu CPU) get_flag_zero() bool {
	unsafe {
		return (cpu.r.af.half.lo & ~(u32(1) << 7)) >> 7 != 0
	}
}

fn (mut cpu CPU) set_flag_subtract(val bool) {
	unsafe {
		cpu.r.af.half.lo = u8((cpu.r.af.half.lo & ~(u32(1) << 6)) | (u32(val) << 6))
	}
}

fn (mut cpu CPU) get_flag_subtract() bool {
	unsafe {
		return (cpu.r.af.half.lo & ~(u32(1) << 6)) >> 6 != 0
	}
}

fn (mut cpu CPU) set_flag_half_carry(val bool) {
	unsafe {
		cpu.r.af.half.lo = u8((cpu.r.af.half.lo & ~(u32(1) << 5)) | (u32(val) << 5))
	}
}

fn (mut cpu CPU) get_flag_half_carry() bool {
	unsafe {
		return (cpu.r.af.half.lo & ~(u32(1) << 5)) >> 5 != 0
	}
}

fn (mut cpu CPU) set_flag_carry(val bool) {
	unsafe {
		cpu.r.af.half.lo = u8((cpu.r.af.half.lo & ~(u32(1) << 4)) | (u32(val) << 4))
	}
}

fn (mut cpu CPU) get_flag_carry() bool {
	unsafe {
		return (cpu.r.af.half.lo & ~(u32(1) << 4)) >> 4 != 0
	}
}