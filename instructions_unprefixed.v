module main

// 0x00
fn inst_nop(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x01
fn inst_ld_bc_n16(mut cpu CPU, data []u8) {
	cpu.r.bc = cpu.routine_ld_n16(data)
}

// 0x02
fn inst_ld_bc_a(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.bc, cpu.r.af.hi())
}

// 0x03
fn inst_inc_bc(mut cpu CPU, _ []u8) {
	cpu.r.bc = cpu.routine_inc_n16(cpu.r.bc)
}

// 0x04
fn inst_inc_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_inc_n8(cpu.r.bc.hi()))
}

// 0x05
fn inst_dec_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_dec_n8(cpu.r.bc.hi()))
}

// 0x06
fn inst_ld_b_n8(mut cpu CPU, data []u8) {
	cpu.r.bc.set_hi(cpu.routine_ld_n8(data))
}

// 0x07
fn inst_rlca(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(cpu.r.af.hi() & 0x80 != 0)
	cpu.r.af.set_hi(cpu.r.af.hi() << 1 | u8(cpu.get_flag_carry()))
}

// 0x08
fn inst_ld_a16_sp(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, tmp, cpu.r.sp.lo())
	cpu.advance_clocks(4)
	cpu.mbus.write(data, tmp + 1, cpu.r.sp.hi())
}

// 0x09
fn inst_add_hl_bc(mut cpu CPU, _ []u8) {
	cpu.routine_add_hl16(cpu.r.bc)
}

// 0x0A
fn inst_ld_a_bc(mut cpu CPU, data []u8) {
	cpu.r.af.set_hi(cpu.routine_ld_ptr16(data, cpu.r.bc))
}

// 0x0B
fn inst_dec_bc(mut cpu CPU, _ []u8) {
	cpu.r.bc = cpu.routine_dec_n16(cpu.r.bc)
}

// 0x0C
fn inst_inc_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_inc_n8(cpu.r.bc.lo()))
}

// 0x0D
fn inst_dec_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_dec_n8(cpu.r.bc.lo()))
}

// 0x0E
fn inst_ld_c_n8(mut cpu CPU, data []u8) {
	cpu.r.bc.set_lo(cpu.routine_ld_n8(data))
}

// 0x0F
fn inst_rrca(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(cpu.r.af.hi() & 0x01 != 0)
	cpu.r.af.set_hi(cpu.r.af.hi() >> 1 | u8(cpu.get_flag_carry()) << 7)
}

// 0x10
fn inst_stop(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	r := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	if r != 0 {
		println('CPU: corrupted STOP at PC ${cpu.r.pc}, should have operand 0x00')
	}
	cpu.advance_clocks(4)
	cpu.mbus.timer.on_div_write(0)
	cpu.halt_type = .none
}

// 0x11
fn inst_ld_de_n16(mut cpu CPU, data []u8) {
	cpu.r.de = cpu.routine_ld_n16(data)
}

// 0x12
fn inst_ld_de_a(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.de, cpu.r.af.hi())
}

// 0x13
fn inst_inc_de(mut cpu CPU, _ []u8) {
	cpu.r.de = cpu.routine_inc_n16(cpu.r.de)
}

// 0x14
fn inst_inc_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_inc_n8(cpu.r.de.hi()))
}

// 0x15
fn inst_dec_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_dec_n8(cpu.r.de.hi()))
}

// 0x16
fn inst_ld_d_n8(mut cpu CPU, data []u8) {
	cpu.r.de.set_hi(cpu.routine_ld_n8(data))
}

// 0x17
fn inst_rla(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	tmp := cpu.get_flag_carry()
	cpu.set_flag_carry(cpu.r.af.hi() & 0x80 != 0)
	cpu.r.af.set_hi(cpu.r.af.hi() << 1 | u8(tmp))
}

// 0x18
fn inst_jr_e8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := i8(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.r.pc = (cpu.r.pc + u16(tmp)) & 0xffff
	cpu.advance_clocks(4)
}

// 0x19
fn inst_add_hl_de(mut cpu CPU, _ []u8) {
	cpu.routine_add_hl16(cpu.r.de)
}

// 0x1A
fn inst_ld_a_de(mut cpu CPU, data []u8) {
	cpu.r.af.set_hi(cpu.routine_ld_ptr16(data, cpu.r.de))
}

// 0x1B
fn inst_dec_de(mut cpu CPU, _ []u8) {
	cpu.r.de = cpu.routine_dec_n16(cpu.r.de)
}

// 0x1C
fn inst_inc_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_inc_n8(cpu.r.de.lo()))
}

// 0x1D
fn inst_dec_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_dec_n8(cpu.r.de.lo()))
}

// 0x1E
fn inst_ld_e_n8(mut cpu CPU, data []u8) {
	cpu.r.de.set_lo(cpu.routine_ld_n8(data))
}

// 0x1F
fn inst_rra(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	tmp := cpu.get_flag_carry()
	cpu.set_flag_carry(cpu.r.af.hi() & 0x01 != 0)
	cpu.r.af.set_hi(cpu.r.af.hi() >> 1 | u8(tmp) << 7)
}

// 0x20
fn inst_jr_nz_e8(mut cpu CPU, data []u8) {
	cpu.routine_jr_cond_e8(data, !cpu.get_flag_zero())
}

// 0x21
fn inst_ld_hl_n16(mut cpu CPU, data []u8) {
	cpu.r.hl = cpu.routine_ld_n16(data)
}

// 0x22
fn inst_ldi_hl_a(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, cpu.r.af.hi())
	cpu.r.hl = (cpu.r.hl + 1) & 0xffff
}

// 0x23
fn inst_inc_hl(mut cpu CPU, _ []u8) {
	cpu.r.hl = cpu.routine_inc_n16(cpu.r.hl)
}

// 0x24
fn inst_inc_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_inc_n8(cpu.r.hl.hi()))
}

// 0x25
fn inst_dec_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_dec_n8(cpu.r.hl.hi()))
}

// 0x26
fn inst_ld_h_n8(mut cpu CPU, data []u8) {
	cpu.r.hl.set_hi(cpu.routine_ld_n8(data))
}

// 0x27
fn inst_daa(mut cpu CPU, _ []u8) {
	if cpu.get_flag_subtract() {
		if cpu.get_flag_carry() {
			cpu.r.af.set_hi(cpu.r.af.hi() - 0x60)
		}
		if cpu.get_flag_half_carry() {
			cpu.r.af.set_hi(cpu.r.af.hi() - 0x6)
		}
	} else {
		if cpu.get_flag_carry() || cpu.r.af.hi() > 0x99 {
			cpu.r.af.set_hi(cpu.r.af.hi() + 0x60)
			cpu.set_flag_carry(true)
		}
		if cpu.get_flag_half_carry() || cpu.r.af.hi() & 0x0f > 0x09 {
			cpu.r.af.set_hi(cpu.r.af.hi() + 0x6)
		}
	}
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
}

// 0x28
fn inst_jr_z_e8(mut cpu CPU, data []u8) {
	cpu.routine_jr_cond_e8(data, cpu.get_flag_zero())
}

// 0x29
fn inst_add_hl_hl(mut cpu CPU, _ []u8) {
	cpu.routine_add_hl16(cpu.r.hl)
}

// 0x2A
fn inst_ldi_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.mbus.read(data, cpu.r.hl))
	cpu.r.hl = (cpu.r.hl + 1) & 0xffff
}

// 0x2B
fn inst_dec_hl(mut cpu CPU, _ []u8) {
	cpu.r.hl = cpu.routine_dec_n16(cpu.r.hl)
}

// 0x2C
fn inst_inc_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_inc_n8(cpu.r.hl.lo()))
}

// 0x2D
fn inst_dec_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_dec_n8(cpu.r.hl.lo()))
}

// 0x2E
fn inst_ld_l_n8(mut cpu CPU, data []u8) {
	cpu.r.hl.set_lo(cpu.routine_ld_n8(data))
}

// 0x2F
fn inst_cpl(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(true)
	cpu.r.af.set_hi(~cpu.r.af.hi())
}

// 0x30
fn inst_jr_nc_e8(mut cpu CPU, data []u8) {
	cpu.routine_jr_cond_e8(data, !cpu.get_flag_carry())
}

// 0x31
fn inst_ld_sp_n16(mut cpu CPU, data []u8) {
	cpu.r.sp = cpu.routine_ld_n16(data)
}

// 0x32
fn inst_ldd_hl_a(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, cpu.r.af.hi())
	cpu.r.hl = (cpu.r.hl - 1) & 0xffff
}

// 0x33
fn inst_inc_sp(mut cpu CPU, _ []u8) {
	cpu.r.sp = cpu.routine_inc_n16(cpu.r.sp)
}

// 0x34
fn inst_inci_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(tmp & 0xf == 0xf)
	tmp = (tmp + 1) & 0xff
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x35
fn inst_deci_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(tmp & 0xf == 0)
	tmp = (tmp - 1) & 0xff
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x36
fn inst_ldi_hl_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x37
fn inst_scf(mut cpu CPU, _ []u8) {
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(true)
	cpu.advance_clocks(4)
}

// 0x38
fn inst_jr_c_e8(mut cpu CPU, data []u8) {
	cpu.routine_jr_cond_e8(data, cpu.get_flag_carry())
}

// 0x39
fn inst_add_hl_sp(mut cpu CPU, _ []u8) {
	cpu.routine_add_hl16(cpu.r.sp)
}

// 0x3A
fn inst_ldd_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.mbus.read(data, cpu.r.hl))
	cpu.r.hl = (cpu.r.hl - 1) & 0xffff
}

// 0x3B
fn inst_dec_sp(mut cpu CPU, _ []u8) {
	cpu.r.sp = cpu.routine_dec_n16(cpu.r.sp)
}

// 0x3C
fn inst_inc_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_inc_n8(cpu.r.af.hi()))
}

// 0x3D
fn inst_dec_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_dec_n8(cpu.r.af.hi()))
}

// 0x3E
fn inst_ld_a_n8(mut cpu CPU, data []u8) {
	cpu.r.af.set_hi(cpu.routine_ld_n8(data))
}

// 0x3F
fn inst_ccf(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_carry(!cpu.get_flag_carry())
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
}

// 0x40
fn inst_ld_b_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x41
fn inst_ld_b_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.bc.lo())
}

// 0x42
fn inst_ld_b_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.de.hi())
}

// 0x43
fn inst_ld_b_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.de.lo())
}

// 0x44
fn inst_ld_b_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.hl.hi())
}

// 0x45
fn inst_ld_b_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.hl.lo())
}

// 0x46
fn inst_ld_b_hl(mut cpu CPU, data []u8) {
	cpu.r.bc.set_hi(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x47
fn inst_ld_b_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_hi(cpu.r.af.hi())
}

// 0x48
fn inst_ld_c_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.bc.hi())
}

// 0x49
fn inst_ld_c_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x4A
fn inst_ld_c_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.de.hi())
}

// 0x4B
fn inst_ld_c_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.de.lo())
}

// 0x4C
fn inst_ld_c_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.hl.hi())
}

// 0x4C
fn inst_ld_c_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.hl.lo())
}

// 0x4E
fn inst_ld_c_hl(mut cpu CPU, data []u8) {
	cpu.r.bc.set_lo(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x4F
fn inst_ld_c_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.bc.set_lo(cpu.r.af.hi())
}

// 0x50
fn inst_ld_d_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.bc.hi())
}

// 0x51
fn inst_ld_d_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.bc.lo())
}

// 0x52
fn inst_ld_d_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x53
fn inst_ld_d_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.de.lo())
}

// 0x54
fn inst_ld_d_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.hl.hi())
}

// 0x55
fn inst_ld_d_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.hl.lo())
}

// 0x56
fn inst_ld_d_hl(mut cpu CPU, data []u8) {
	cpu.r.de.set_hi(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x57
fn inst_ld_d_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_hi(cpu.r.af.hi())
}

// 0x58
fn inst_ld_e_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.bc.hi())
}

// 0x59
fn inst_ld_e_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.bc.lo())
}

// 0x5A
fn inst_ld_e_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.de.hi())
}

// 0x5B
fn inst_ld_e_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x5C
fn inst_ld_e_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.hl.hi())
}

// 0x5D
fn inst_ld_e_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.hl.lo())
}

// 0x5E
fn inst_ld_e_hl(mut cpu CPU, data []u8) {
	cpu.r.de.set_lo(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x5F
fn inst_ld_e_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.de.set_lo(cpu.r.af.hi())
}

// 0x60
fn inst_ld_h_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.bc.hi())
}

// 0x61
fn inst_ld_h_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.bc.lo())
}

// 0x62
fn inst_ld_h_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.de.hi())
}

// 0x63
fn inst_ld_h_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.de.lo())
}

// 0x64
fn inst_ld_h_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x65
fn inst_ld_h_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.hl.lo())
}

// 0x66
fn inst_ld_h_hl(mut cpu CPU, data []u8) {
	cpu.r.hl.set_hi(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x67
fn inst_ld_h_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_hi(cpu.r.af.hi())
}

// 0x68
fn inst_ld_l_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.bc.hi())
}

// 0x69
fn inst_ld_l_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.bc.lo())
}

// 0x6A
fn inst_ld_l_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.de.hi())
}

// 0x6B
fn inst_ld_l_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.de.lo())
}

// 0x6C
fn inst_ld_l_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.hl.hi())
}

// 0x6D
fn inst_ld_l_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x6E
fn inst_ld_l_hl(mut cpu CPU, data []u8) {
	cpu.r.hl.set_lo(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x6F
fn inst_ld_l_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.hl.set_lo(cpu.r.af.hi())
}

// 0x70
fn inst_ld_hl_b(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.bc.hi())
}

// 0x71
fn inst_ld_hl_c(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.bc.lo())
}

// 0x72
fn inst_ld_hl_d(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.de.hi())
}

// 0x73
fn inst_ld_hl_e(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.de.lo())
}

// 0x74
fn inst_ld_hl_h(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.hl.hi())
}

// 0x75
fn inst_ld_hl_l(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.hl.lo())
}

// 0x76
fn inst_halt(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	interrupt_enable := cpu.mbus.read(data, addr_io_ie)
	interrupt_flag := cpu.mbus.read(data, addr_io_if)
	interrupt_pending := (interrupt_enable & interrupt_flag) & 0x1f != 0
	if interrupt_pending {
		if cpu.interrupt_data.master_enable {
			cpu.r.pc--
		} else {
			cpu.halt_bug = true
		}
	} else {
		cpu.halt_type = .halt
	}
}

// 0x77
fn inst_ld_hl_a(mut cpu CPU, data []u8) {
	cpu.routine_ld_ptr8(data, cpu.r.hl, cpu.r.af.hi())
}

// 0x78
fn inst_ld_a_b(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.bc.hi())
}

// 0x79
fn inst_ld_a_c(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.bc.lo())
}

// 0x7A
fn inst_ld_a_d(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.de.hi())
}

// 0x7B
fn inst_ld_a_e(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.de.lo())
}

// 0x7C
fn inst_ld_a_h(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.hl.hi())
}

// 0x7D
fn inst_ld_a_l(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.hl.lo())
}

// 0x7E
fn inst_ld_a_hl(mut cpu CPU, data []u8) {
	cpu.r.af.set_hi(cpu.routine_ld_ptr16(data, cpu.r.hl))
}

// 0x7F
fn inst_ld_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
}

// 0x80
fn inst_add_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.bc.hi())
}

// 0x81
fn inst_add_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.bc.lo())
}

// 0x82
fn inst_add_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.de.hi())
}

// 0x83
fn inst_add_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.de.lo())
}

// 0x84
fn inst_add_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.hl.hi())
}

// 0x85
fn inst_add_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.hl.lo())
}

// 0x86
fn inst_adi_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	a := cpu.r.af.hi()
	cpu.advance_clocks(4)
	hl := cpu.mbus.read(data, cpu.r.hl)
	cpu.set_flag_half_carry((a & 0xf) + (hl & 0xf) > 0xf)
	cpu.r.af.set_hi(a + hl)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.set_flag_carry(a > cpu.r.af.hi())
}

// 0x87
fn inst_add_a_a(mut cpu CPU, _ []u8) {
	cpu.routine_add_a8(cpu.r.af.hi())
}

// 0x88
fn inst_adc_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.bc.hi())
}

// 0x89
fn inst_adc_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.bc.lo())
}

// 0x8A
fn inst_adc_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.de.hi())
}

// 0x8B
fn inst_adc_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.de.lo())
}

// 0x8C
fn inst_adc_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.hl.hi())
}

// 0x8D
fn inst_adc_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.hl.lo())
}

// 0x8E
fn inst_adc_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.advance_clocks(4)
	hl := cpu.mbus.read(data, cpu.r.hl)
	carry := u16(cpu.get_flag_carry())
	a := u16(cpu.r.af.hi()) + u16(hl) + carry
	cpu.set_flag_half_carry((u16(cpu.r.af.hi()) & 0xf) + (u16(hl) & 0xf) + carry > 0xf)
	cpu.set_flag_carry(a > 0xff)
	cpu.r.af.set_hi(u8(a & 0xff))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0x8F
fn inst_adc_a_a(mut cpu CPU, _ []u8) {
	cpu.routine_adc_a8(cpu.r.af.hi())
}

// 0x90
fn inst_sub_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.bc.hi())
}

// 0x91
fn inst_sub_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.bc.lo())
}

// 0x92
fn inst_sub_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.de.hi())
}

// 0x93
fn inst_sub_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.de.lo())
}

// 0x94
fn inst_sub_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.hl.hi())
}

// 0x95
fn inst_sub_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_sub_a8(cpu.r.hl.lo())
}

// 0x96
fn inst_sub_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry((cpu.r.af.hi() & 0xf) < (tmp & 0xf))
	cpu.set_flag_carry(cpu.r.af.hi() < tmp)
	cpu.r.af.set_hi(cpu.r.af.hi() - tmp)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0x97
fn inst_sub_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_zero(true)
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(false)
	cpu.r.af.set_hi(0)
}

// 0x98
fn inst_sbc_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.bc.hi())
}

// 0x99
fn inst_sbc_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.bc.lo())
}

// 0x9A
fn inst_sbc_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.de.hi())
}

// 0x9B
fn inst_sbc_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.de.lo())
}

// 0x9C
fn inst_sbc_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.hl.hi())
}

// 0x9D
fn inst_sbc_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_sbc_a8(cpu.r.hl.lo())
}

// 0x9E
fn inst_sbc_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	hl := cpu.mbus.read(data, cpu.r.hl)
	carry := u16(cpu.get_flag_carry())
	a := u16(cpu.r.af.hi())
	b := u16(hl) + carry
	cpu.set_flag_subtract(true)
	cpu.set_flag_carry(a < b)
	cpu.set_flag_half_carry((a & 0xf) < (u16(hl & 0xf) + carry))
	tmp := u8((a - b) & 0xff)
	cpu.r.af.set_hi(tmp)
	cpu.set_flag_zero(tmp == 0)
}

// 0x9F
fn inst_sbc_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	fc := cpu.get_flag_carry()
	cpu.r.af.set_hi(if fc { u8(0xff) } else { u8(0x00) })
	cpu.set_flag_carry(fc)
	cpu.set_flag_half_carry(fc)
	cpu.set_flag_zero(!fc)
	cpu.set_flag_subtract(true)
}

// 0xA0
fn inst_and_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.bc.hi())
}

// 0xA1
fn inst_and_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.bc.lo())
}

// 0xA2
fn inst_and_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.de.hi())
}

// 0xA3
fn inst_and_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.de.lo())
}

// 0xA4
fn inst_and_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.hl.hi())
}

// 0xA5
fn inst_and_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_and_a8(cpu.r.hl.lo())
}

// 0xA6
fn inst_and_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_half_carry(true)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() & cpu.mbus.read(data, cpu.r.hl))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xA7
fn inst_and_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_half_carry(true)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xA8
fn inst_xor_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.bc.hi())
}

// 0xA9
fn inst_xor_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.bc.lo())
}

// 0xAA
fn inst_xor_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.de.hi())
}

// 0xAB
fn inst_xor_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.de.lo())
}

// 0xAC
fn inst_xor_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.hl.hi())
}

// 0xAD
fn inst_xor_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_xor_a8(cpu.r.hl.lo())
}

// 0xAE
fn inst_xor_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() ^ cpu.mbus.read(data, cpu.r.hl))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xAF
fn inst_xor_a_a(mut cpu CPU, _ []u8) {
	cpu.r.af = 0
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_zero(true)
	cpu.advance_clocks(4)
}

// 0xB0
fn inst_or_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.bc.hi())
}

// 0xB1
fn inst_or_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.bc.lo())
}

// 0xB2
fn inst_or_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.de.hi())
}

// 0xB3
fn inst_or_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.de.lo())
}

// 0xB4
fn inst_or_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.hl.hi())
}

// 0xB5
fn inst_or_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_or_a8(cpu.r.hl.lo())
}

// 0xB6
fn inst_or_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_carry(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() | cpu.mbus.read(data, cpu.r.hl))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xB7
fn inst_or_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_carry(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xB8
fn inst_cp_a_b(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.bc.hi())
}

// 0xB9
fn inst_cp_a_c(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.bc.lo())
}

// 0xBA
fn inst_cp_a_d(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.de.hi())
}

// 0xBB
fn inst_cp_a_e(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.de.lo())
}

// 0xBC
fn inst_cp_a_h(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.hl.hi())
}

// 0xBD
fn inst_cp_a_l(mut cpu CPU, _ []u8) {
	cpu.routine_cp_a8(cpu.r.hl.lo())
}

// 0xBE
fn inst_cp_a_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry((cpu.r.af.hi() & 0xf) < (tmp & 0xf))
	cpu.set_flag_carry(cpu.r.af.hi() < tmp)
	cpu.set_flag_zero(cpu.r.af.hi() == tmp)
}

// 0xBF
fn inst_cp_a_a(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(true)
	cpu.set_flag_zero(true)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(false)
}

// 0xC0
fn inst_ret_nz(mut cpu CPU, data []u8) {
	cpu.routine_ret_cond(data, !cpu.get_flag_zero())
}

// 0xC1
fn inst_pop_bc(mut cpu CPU, data []u8) {
	cpu.r.bc = cpu.routine_pop_n16(data)
}

// 0xC2
fn inst_jp_nz_a16(mut cpu CPU, data []u8) {
	cpu.routine_jp_cond_a16(data, !cpu.get_flag_zero())
}

// 0xC3
fn inst_jp_a16(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
	cpu.r.pc++
	cpu.r.pc &= 0xFFFF
	cpu.advance_clocks(4)
	cpu.r.pc = u16(tmp)
	cpu.advance_clocks(4)
}

// 0xC4
fn inst_call_nz_a16(mut cpu CPU, data []u8) {
	cpu.routine_call_cond_a16(data, !cpu.get_flag_zero())
}

// 0xC5
fn inst_push_bc(mut cpu CPU, data []u8) {
	cpu.routine_push_n16(data, cpu.r.bc)
}

// 0xC6
fn inst_add_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	a := cpu.r.af.hi()
	op := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry((a & 0xf) + (op & 0xf) > 0xf)
	cpu.r.af.set_hi(cpu.r.af.hi() + op)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
	cpu.set_flag_carry(a > cpu.r.af.hi())
}

// 0xC7
fn inst_rst_00(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0000)
}

// 0xC8
fn inst_ret_z(mut cpu CPU, data []u8) {
	cpu.routine_ret_cond(data, cpu.get_flag_zero())
}

// 0xC9
fn inst_ret(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.sp))
	cpu.r.sp++
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.sp)) << 8
	cpu.r.sp++
	cpu.advance_clocks(4)
	cpu.r.pc = tmp
	cpu.advance_clocks(4)
}

// 0xCA
fn inst_jp_z_a16(mut cpu CPU, data []u8) {
	cpu.routine_jp_cond_a16(data, cpu.get_flag_zero())
}

// 0xCC
fn inst_call_z_a16(mut cpu CPU, data []u8) {
	cpu.routine_call_cond_a16(data, cpu.get_flag_zero())
}

// 0xCD
fn inst_call_a16(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.mbus.write(data, cpu.r.sp, cpu.r.pc.hi())
	cpu.advance_clocks(4)
	cpu.r.sp--
	cpu.r.sp &= 0xffff
	cpu.mbus.write(data, cpu.r.sp, cpu.r.pc.lo())
	cpu.advance_clocks(4)
	cpu.r.pc = tmp
	cpu.advance_clocks(4)
}

// 0xCE
fn inst_adc_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	op := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	carry := u16(cpu.get_flag_carry())
	a := u16(cpu.r.af.hi()) + u16(op) + carry
	cpu.set_flag_half_carry((u16(cpu.r.af.hi()) & 0xf) + (u16(op) & 0xf) + carry > 0xf)
	cpu.set_flag_carry(a > 0xff)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(u8(a & 0xff))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xCF
fn inst_rst_08(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0008)
}

// 0xD0
fn inst_ret_nc(mut cpu CPU, data []u8) {
	cpu.routine_ret_cond(data, !cpu.get_flag_carry())
}

// 0xD1
fn inst_pop_de(mut cpu CPU, data []u8) {
	cpu.r.de = cpu.routine_pop_n16(data)
}

// 0xD2
fn inst_jp_nc_a16(mut cpu CPU, data []u8) {
	cpu.routine_jp_cond_a16(data, !cpu.get_flag_carry())
}

// 0xD4
fn inst_call_nc_a16(mut cpu CPU, data []u8) {
	cpu.routine_call_cond_a16(data, !cpu.get_flag_carry())
}

// 0xD5
fn inst_push_de(mut cpu CPU, data []u8) {
	cpu.routine_push_n16(data, cpu.r.de)
}

// 0xD6
fn inst_sub_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.set_flag_subtract(true)
	cpu.set_flag_half_carry(cpu.r.af.hi() & 0xf < tmp & 0xf)
	cpu.set_flag_carry(cpu.r.af.hi() < tmp)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() - tmp)
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xD7
fn inst_rst_10(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0010)
}

// 0xD8
fn inst_ret_c(mut cpu CPU, data []u8) {
	cpu.routine_ret_cond(data, cpu.get_flag_carry())
}

// 0xD9
fn inst_reti(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
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
	cpu.interrupt_data.master_enable = true
}

// 0xDA
fn inst_jp_c_a16(mut cpu CPU, data []u8) {
	cpu.routine_jp_cond_a16(data, cpu.get_flag_carry())
}

// 0xDC
fn inst_call_c_a16(mut cpu CPU, data []u8) {
	cpu.routine_call_cond_a16(data, cpu.get_flag_carry())
}

// 0xDE
fn inst_sbc_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	op := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	carry := u16(cpu.get_flag_carry())
	a := u16(cpu.r.af.hi())
	b := u16(op) + carry
	cpu.set_flag_subtract(true)
	cpu.set_flag_carry(a < b)
	cpu.set_flag_half_carry((a & 0xf) < (u16(op & 0xf) + carry))
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(u8((a - b) & 0xff))
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xDF
fn inst_rst_18(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0018)
}

// 0xE0
fn inst_ldh_a8_a(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := 0xff00 + u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, tmp, cpu.r.af.hi())
}

// 0xE1
fn inst_pop_hl(mut cpu CPU, data []u8) {
	cpu.r.hl = cpu.routine_pop_n16(data)
}

// 0xE2
fn inst_ldh_c_a(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, u16(0xff00 + cpu.r.bc.lo()), cpu.r.af.hi())
}

// 0xE5
fn inst_push_hl(mut cpu CPU, data []u8) {
	cpu.routine_push_n16(data, cpu.r.hl)
}

// 0xE6
fn inst_and_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(true)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() & cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xE7
fn inst_rst_20(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0020)
}

// 0xE8
fn inst_add_sp_e8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry((cpu.r.sp & 0xff) + u16(tmp) > 0xff)
	cpu.set_flag_half_carry((cpu.r.sp & 0xf) + u16(tmp & 0xf) > 0xf)
	cpu.advance_clocks(4)
	cpu.r.sp = (cpu.r.sp + u16(i8(tmp))) & 0xffff
	cpu.advance_clocks(4)
}

// 0xE9
fn inst_jp_hl(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.pc = cpu.r.hl
}

// 0xEA
fn inst_ld_a16_a(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.r.pc &= 0xffff
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
	cpu.r.pc++
	cpu.r.pc &= 0xffff
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, tmp, cpu.r.af.hi())
}

// 0xEE
fn inst_xor_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() ^ cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xEF
fn inst_rst_28(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0028)
}

// 0xF0
fn inst_ldh_a_a8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := 0xff00 + u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.mbus.read(data, tmp))
}

// 0xF1
fn inst_pop_af(mut cpu CPU, data []u8) {
	cpu.r.af = cpu.routine_pop_n16(data)
	cpu.r.af.set_lo(cpu.r.af.lo() & 0xF0)
}

// 0xF2
fn inst_ldh_a_c(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.mbus.read(data, u16(0xff00 + cpu.r.bc.lo())))
}

// 0xF3
fn inst_di(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.interrupt_data.master_enable = false
	cpu.interrupt_data.enable_ime_delay = 0
}

// 0xF5
fn inst_push_af(mut cpu CPU, data []u8) {
	cpu.routine_push_n16(data, cpu.r.af)
}

// 0xF6
fn inst_or_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_carry(false)
	cpu.set_flag_half_carry(false)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.r.af.hi() | cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.set_flag_zero(cpu.r.af.hi() == 0)
}

// 0xF7
fn inst_rst_30(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0030)
}

// 0xF8
fn inst_ld_hl_sp_e8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	tmp := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	cpu.r.pc &= 0xffff
	cpu.advance_clocks(4)
	res := (cpu.r.sp + u16(i8(tmp))) & 0xffff
	cpu.advance_clocks(4)
	cpu.r.hl = res
	cpu.set_flag_zero(false)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry((cpu.r.sp & 0xf) + u16(tmp & 0xf) > 0xf)
	cpu.set_flag_carry((cpu.r.sp & 0xff) + u16(tmp) > 0xff)
}

// 0xF9
fn inst_ld_sp_hl(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.r.sp = cpu.r.hl
	cpu.advance_clocks(4)
}

// 0xFA
fn inst_ld_a_a16(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := u16(cpu.mbus.read(data, cpu.r.pc))
	cpu.r.pc++
	cpu.r.pc &= 0xffff
	cpu.advance_clocks(4)
	tmp |= u16(cpu.mbus.read(data, cpu.r.pc)) << 8
	cpu.r.pc++
	cpu.r.pc &= 0xffff
	cpu.advance_clocks(4)
	cpu.advance_clocks(4)
	cpu.r.af.set_hi(cpu.mbus.read(data, tmp))
}

// 0xFB
fn inst_ei(mut cpu CPU, _ []u8) {
	cpu.advance_clocks(4)
	cpu.interrupt_data.enable_ime_delay = 1
}

// 0xFE
fn inst_cp_a_n8(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(true)
	op := cpu.mbus.read(data, cpu.r.pc)
	cpu.r.pc++
	a := cpu.r.af.hi()
	cpu.set_flag_half_carry(a & 0xf < op & 0xf)
	cpu.set_flag_carry(a < op)
	cpu.set_flag_zero(a == op)
	cpu.advance_clocks(4)
}

// 0xFF
fn inst_rst_38(mut cpu CPU, data []u8) {
	cpu.routine_rst_n16(data, 0x0038)
}
