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
	r              CPURegisters
	opcode         u8
	ic             u32
	inst           ?CPUInstruction
	clocks         u32
	mbus           &MemoryBus
	interrupt_data InterruptData
	halt_bug       bool
	halt_type      CPUHaltType = .none
}

fn (mut cpu CPU) reset() {
	cpu.r.af = 0x01B0
	cpu.r.bc = 0x0013
	cpu.r.de = 0x00D8
	cpu.r.hl = 0x014D
	cpu.r.sp = 0xFFFE
	cpu.r.pc = 0x0100
}

fn (mut cpu CPU) fetch() {
	$if debug_instructions ? {
		println(cpu.r)
	}

	cpu.opcode = cpu.mbus.read(cpu.r.pc)
	cpu.r.pc++
	is_extended_cb_inst := cpu.opcode == 0xCB

	if cpu.halt_bug {
		cpu.r.pc--
		cpu.halt_bug = false
	}

	if is_extended_cb_inst {
		cpu.advance_clocks(4)
		opcode_cb := cpu.mbus.read(cpu.r.pc)
		cpu.r.pc++
		cpu.inst = inst_prefixed(opcode_cb)
	} else {
		cpu.inst = inst(cpu.opcode)
	}
}

fn (mut cpu CPU) execute() {
	if inst := cpu.inst {
		if f := inst.function {
			f(mut cpu)
		} else {
			panic('unimplemented: ${inst.disassembly}')
		}
	} else {
		println('Unknown instruction at: 0x${cpu.r.pc.hi():x}${cpu.r.pc.lo():x}, count 0x${cpu.ic:x}')
	}
}

fn (mut cpu CPU) advance_clocks(clocks u8) {
	cpu.mbus.timer.advance_clocks(mut cpu, clocks)
	cpu.clocks += clocks

	if cpu.interrupt_data.enable_ime_delay > 0 {
		for _ in 0 .. clocks {
			cpu.interrupt_data.enable_ime_delay--
			if cpu.interrupt_data.enable_ime_delay == 0 {
				cpu.interrupt_data.master_enable = true
				break
			}
		}
	}
}

fn (mut cpu CPU) tick() {
	if cpu.halt_type == .none {
		cpu.fetch()
		cpu.execute()
		cpu.ic++
	} else {
		cpu.advance_clocks(4)
	}

	cpu.interrupt_service_routine()
}

@[inline]
fn (mut cpu CPU) set_flag_zero(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 7)) | (u32(val) << 7)))
}

@[inline]
fn (mut cpu CPU) get_flag_zero() bool {
	return (cpu.r.af.lo() & (u32(1) << 7)) >> 7 != 0
}

@[inline]
fn (mut cpu CPU) set_flag_subtract(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 6)) | (u32(val) << 6)))
}

@[inline]
fn (mut cpu CPU) get_flag_subtract() bool {
	return (cpu.r.af.lo() & (u32(1) << 6)) >> 6 != 0
}

@[inline]
fn (mut cpu CPU) set_flag_half_carry(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 5)) | (u32(val) << 5)))
}

@[inline]
fn (mut cpu CPU) get_flag_half_carry() bool {
	return (cpu.r.af.lo() & (u32(1) << 5)) >> 5 != 0
}

@[inline]
fn (mut cpu CPU) set_flag_carry(val bool) {
	cpu.r.af.set_lo(u8((cpu.r.af.lo() & ~(u32(1) << 4)) | (u32(val) << 4)))
}

@[inline]
fn (mut cpu CPU) get_flag_carry() bool {
	return (cpu.r.af.lo() & (u32(1) << 4)) >> 4 != 0
}
