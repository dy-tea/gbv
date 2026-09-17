module main

// 0x00
fn inst_rlc_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_rlc_n8(cpu.r.bc.hi()))
}

// 0x01
fn inst_rlc_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_rlc_n8(cpu.r.bc.lo()))
}

// 0x02
fn inst_rlc_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_rlc_n8(cpu.r.de.hi()))
}

// 0x03
fn inst_rlc_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_rlc_n8(cpu.r.de.lo()))
}

// 0x04
fn inst_rlc_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_rlc_n8(cpu.r.hl.hi()))
}

// 0x05
fn inst_rlc_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_rlc_n8(cpu.r.hl.lo()))
}

// 0x06
fn inst_rlc_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(tmp & 0x80 != 0)
	tmp = tmp << 1 | u8(cpu.get_flag_carry())
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x07
fn inst_rlc_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_rlc_n8(cpu.r.af.hi()))
}

// 0x08
fn inst_rrc_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_rrc_n8(cpu.r.bc.hi()))
}

// 0x09
fn inst_rrc_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_rrc_n8(cpu.r.bc.lo()))
}

// 0x0A
fn inst_rrc_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_rrc_n8(cpu.r.de.hi()))
}

// 0x0B
fn inst_rrc_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_rrc_n8(cpu.r.de.lo()))
}

// 0x0C
fn inst_rrc_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_rrc_n8(cpu.r.hl.hi()))
}

// 0x0D
fn inst_rrc_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_rrc_n8(cpu.r.hl.lo()))
}

// 0x0E
fn inst_rrc_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(tmp & 0x01 != 0)
	tmp = tmp << 1 | u8(cpu.get_flag_carry()) << 7
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x0F
fn inst_rrc_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_rrc_n8(cpu.r.af.hi()))
}

// 0x10
fn inst_rl_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_rl_n8(cpu.r.bc.hi()))
}

// 0x11
fn inst_rl_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_rl_n8(cpu.r.bc.lo()))
}

// 0x12
fn inst_rl_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_rl_n8(cpu.r.de.hi()))
}

// 0x13
fn inst_rl_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_rl_n8(cpu.r.de.lo()))
}

// 0x14
fn inst_rl_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_rl_n8(cpu.r.hl.hi()))
}

// 0x15
fn inst_rl_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_rl_n8(cpu.r.hl.lo()))
}

// 0x16
fn inst_rl_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	c := cpu.get_flag_carry()
	cpu.set_flag_carry(tmp & 0x80 != 0)
	tmp = (tmp << 1 | u8(c)) & 0xff
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x17
fn inst_rl_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_rl_n8(cpu.r.af.hi()))
}

// 0x18
fn inst_rr_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_rr_n8(cpu.r.bc.hi()))
}

// 0x19
fn inst_rr_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_rr_n8(cpu.r.bc.lo()))
}

// 0x1A
fn inst_rr_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_rr_n8(cpu.r.de.hi()))
}

// 0x1B
fn inst_rr_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_rr_n8(cpu.r.de.lo()))
}

// 0x1C
fn inst_rr_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_rr_n8(cpu.r.hl.hi()))
}

// 0x1D
fn inst_rr_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_rr_n8(cpu.r.hl.lo()))
}

// 0x1E
fn inst_rr_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	c := cpu.get_flag_carry()
	cpu.set_flag_carry(tmp & 0x01 != 0)
	tmp = tmp >> 1 | u8(c) << 7
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x1F
fn inst_rr_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_rr_n8(cpu.r.af.hi()))
}

// 0x20
fn inst_sla_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_sla_n8(cpu.r.bc.hi()))
}

// 0x21
fn inst_sla_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_sla_n8(cpu.r.bc.lo()))
}

// 0x22
fn inst_sla_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_sla_n8(cpu.r.de.hi()))
}

// 0x23
fn inst_sla_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_sla_n8(cpu.r.de.lo()))
}

// 0x24
fn inst_sla_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_sla_n8(cpu.r.hl.hi()))
}

// 0x25
fn inst_sla_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_sla_n8(cpu.r.hl.lo()))
}

// 0x26
fn inst_sla_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(tmp & 0x80 != 0)
	tmp = (tmp << 1) & 0xff
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x27
fn inst_sla_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_sla_n8(cpu.r.af.hi()))
}

// 0x28
fn inst_sra_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_sra_n8(cpu.r.bc.hi()))
}

// 0x29
fn inst_sra_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_sra_n8(cpu.r.bc.lo()))
}

// 0x2A
fn inst_sra_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_sra_n8(cpu.r.de.hi()))
}

// 0x2B
fn inst_sra_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_sra_n8(cpu.r.de.lo()))
}

// 0x2C
fn inst_sra_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_sra_n8(cpu.r.hl.hi()))
}

// 0x2D
fn inst_sra_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_sra_n8(cpu.r.hl.lo()))
}

// 0x2E
fn inst_sra_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(tmp & 0x01 != 0)
	tmp = tmp & 0x80 | tmp >> 1
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x2F
fn inst_sra_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_sra_n8(cpu.r.af.hi()))
}

// 0x30
fn inst_swap_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_swap_n8(cpu.r.bc.hi()))
}

// 0x31
fn inst_swap_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_swap_n8(cpu.r.bc.lo()))
}

// 0x32
fn inst_swap_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_swap_n8(cpu.r.de.hi()))
}

// 0x33
fn inst_swap_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_swap_n8(cpu.r.de.lo()))
}

// 0x34
fn inst_swap_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_swap_n8(cpu.r.hl.hi()))
}

// 0x35
fn inst_swap_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_swap_n8(cpu.r.hl.lo()))
}

// 0x36
fn inst_swap_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(false)
	tmp = ((tmp << 4) | (tmp >> 4)) & 0xff
	cpu.set_flag_zero(false)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x37
fn inst_swap_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_swap_n8(cpu.r.af.hi()))
}

// 0x38
fn inst_srl_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_srl_n8(cpu.r.bc.hi()))
}

// 0x39
fn inst_srl_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_srl_n8(cpu.r.bc.lo()))
}

// 0x3A
fn inst_srl_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_srl_n8(cpu.r.de.hi()))
}

// 0x3B
fn inst_srl_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_srl_n8(cpu.r.de.lo()))
}

// 0x3C
fn inst_srl_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_srl_n8(cpu.r.hl.hi()))
}

// 0x3D
fn inst_srl_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_srl_n8(cpu.r.hl.lo()))
}

// 0x3E
fn inst_srl_hl(mut cpu CPU, data []u8) {
	cpu.advance_clocks(4)
	mut tmp := cpu.mbus.read(data, cpu.r.hl)
	cpu.advance_clocks(4)
	cpu.set_flag_subtract(false)
	cpu.set_flag_half_carry(false)
	cpu.set_flag_carry(tmp & 0x01 != 0)
	tmp = tmp >> 1
	cpu.set_flag_zero(tmp == 0)
	cpu.advance_clocks(4)
	cpu.mbus.write(data, cpu.r.hl, tmp)
}

// 0x3F
fn inst_srl_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_srl_n8(cpu.r.af.hi()))
}

// 0x40
fn inst_bit_0_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.bc.hi())
}

// 0x41
fn inst_bit_0_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.bc.lo())
}

// 0x42
fn inst_bit_0_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.de.hi())
}

// 0x43
fn inst_bit_0_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.de.lo())
}

// 0x44
fn inst_bit_0_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.hl.hi())
}

// 0x45
fn inst_bit_0_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.hl.lo())
}

// 0x46
fn inst_bit_0_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 0)
}

// 0x47
fn inst_bit_0_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(0, cpu.r.af.hi())
}

// 0x48
fn inst_bit_1_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.bc.hi())
}

// 0x49
fn inst_bit_1_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.bc.lo())
}

// 0x4A
fn inst_bit_1_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.de.hi())
}

// 0x4B
fn inst_bit_1_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.de.lo())
}

// 0x4C
fn inst_bit_1_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.hl.hi())
}

// 0x4D
fn inst_bit_1_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.hl.lo())
}

// 0x4E
fn inst_bit_1_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 1)
}

// 0x4F
fn inst_bit_1_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(1, cpu.r.af.hi())
}

// 0x50
fn inst_bit_2_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.bc.hi())
}

// 0x51
fn inst_bit_2_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.bc.lo())
}

// 0x52
fn inst_bit_2_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.de.hi())
}

// 0x53
fn inst_bit_2_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.de.lo())
}

// 0x54
fn inst_bit_2_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.hl.hi())
}

// 0x55
fn inst_bit_2_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.hl.lo())
}

// 0x56
fn inst_bit_2_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 2)
}

// 0x57
fn inst_bit_2_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(2, cpu.r.af.hi())
}

// 0x58
fn inst_bit_3_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.bc.hi())
}

// 0x59
fn inst_bit_3_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.bc.lo())
}

// 0x5A
fn inst_bit_3_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.de.hi())
}

// 0x5B
fn inst_bit_3_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.de.lo())
}

// 0x5C
fn inst_bit_3_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.hl.hi())
}

// 0x5D
fn inst_bit_3_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.hl.lo())
}

// 0x5E
fn inst_bit_3_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 3)
}

// 0x5F
fn inst_bit_3_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(3, cpu.r.af.hi())
}

// 0x60
fn inst_bit_4_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.bc.hi())
}

// 0x61
fn inst_bit_4_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.bc.lo())
}

// 0x62
fn inst_bit_4_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.de.hi())
}

// 0x63
fn inst_bit_4_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.de.lo())
}

// 0x64
fn inst_bit_4_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.hl.hi())
}

// 0x65
fn inst_bit_4_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.hl.lo())
}

// 0x66
fn inst_bit_4_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 4)
}

// 0x67
fn inst_bit_4_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(4, cpu.r.af.hi())
}

// 0x68
fn inst_bit_5_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.bc.hi())
}

// 0x69
fn inst_bit_5_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.bc.lo())
}

// 0x6A
fn inst_bit_5_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.de.hi())
}

// 0x6B
fn inst_bit_5_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.de.lo())
}

// 0x6C
fn inst_bit_5_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.hl.hi())
}

// 0x6D
fn inst_bit_5_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.hl.lo())
}

// 0x6E
fn inst_bit_5_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 5)
}

// 0x6F
fn inst_bit_5_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(5, cpu.r.af.hi())
}

// 0x70
fn inst_bit_6_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.bc.hi())
}

// 0x71
fn inst_bit_6_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.bc.lo())
}

// 0x72
fn inst_bit_6_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.de.hi())
}

// 0x73
fn inst_bit_6_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.de.lo())
}

// 0x74
fn inst_bit_6_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.hl.hi())
}

// 0x75
fn inst_bit_6_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.hl.lo())
}

// 0x76
fn inst_bit_6_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 6)
}

// 0x77
fn inst_bit_6_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(6, cpu.r.af.hi())
}

// 0x78
fn inst_bit_7_b(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.bc.hi())
}

// 0x79
fn inst_bit_7_c(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.bc.lo())
}

// 0x7A
fn inst_bit_7_d(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.de.hi())
}

// 0x7B
fn inst_bit_7_e(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.de.lo())
}

// 0x7C
fn inst_bit_7_h(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.hl.hi())
}

// 0x7D
fn inst_bit_7_l(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.hl.lo())
}

// 0x7E
fn inst_bit_7_hl(mut cpu CPU, data []u8) {
	cpu.routine_bit_n_ptrhl(data, 7)
}

// 0x7F
fn inst_bit_7_a(mut cpu CPU, _ []u8) {
	cpu.routine_bit_n_n8(7, cpu.r.af.hi())
}

// 0x80
fn inst_res_0_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(0, cpu.r.bc.hi()))
}

// 0x81
fn inst_res_0_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(0, cpu.r.bc.lo()))
}

// 0x82
fn inst_res_0_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(0, cpu.r.de.hi()))
}

// 0x83
fn inst_res_0_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(0, cpu.r.de.lo()))
}

// 0x84
fn inst_res_0_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(0, cpu.r.hl.hi()))
}

// 0x85
fn inst_res_0_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(0, cpu.r.hl.lo()))
}

// 0x86
fn inst_res_0_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 0)
}

// 0x87
fn inst_res_0_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(0, cpu.r.af.hi()))
}

// 0x88
fn inst_res_1_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(1, cpu.r.bc.hi()))
}

// 0x89
fn inst_res_1_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(1, cpu.r.bc.lo()))
}

// 0x8A
fn inst_res_1_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(1, cpu.r.de.hi()))
}

// 0x8B
fn inst_res_1_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(1, cpu.r.de.lo()))
}

// 0x8C
fn inst_res_1_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(1, cpu.r.hl.hi()))
}

// 0x8D
fn inst_res_1_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(1, cpu.r.hl.lo()))
}

// 0x8E
fn inst_res_1_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 1)
}

// 0x8F
fn inst_res_1_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(1, cpu.r.af.hi()))
}

// 0x90
fn inst_res_2_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(2, cpu.r.bc.hi()))
}

// 0x91
fn inst_res_2_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(2, cpu.r.bc.lo()))
}

// 0x92
fn inst_res_2_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(2, cpu.r.de.hi()))
}

// 0x93
fn inst_res_2_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(2, cpu.r.de.lo()))
}

// 0x94
fn inst_res_2_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(2, cpu.r.hl.hi()))
}

// 0x95
fn inst_res_2_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(2, cpu.r.hl.lo()))
}

// 0x96
fn inst_res_2_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 2)
}

// 0x97
fn inst_res_2_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(2, cpu.r.af.hi()))
}

// 0x98
fn inst_res_3_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(3, cpu.r.bc.hi()))
}

// 0x99
fn inst_res_3_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(3, cpu.r.bc.lo()))
}

// 0x9A
fn inst_res_3_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(3, cpu.r.de.hi()))
}

// 0x9B
fn inst_res_3_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(3, cpu.r.de.lo()))
}

// 0x9C
fn inst_res_3_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(3, cpu.r.hl.hi()))
}

// 0x9D
fn inst_res_3_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(3, cpu.r.hl.lo()))
}

// 0x9E
fn inst_res_3_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 3)
}

// 0x9F
fn inst_res_3_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(3, cpu.r.af.hi()))
}

// 0xA0
fn inst_res_4_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(4, cpu.r.bc.hi()))
}

// 0xA1
fn inst_res_4_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(4, cpu.r.bc.lo()))
}

// 0xA2
fn inst_res_4_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(4, cpu.r.de.hi()))
}

// 0xA3
fn inst_res_4_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(4, cpu.r.de.lo()))
}

// 0xA4
fn inst_res_4_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(4, cpu.r.hl.hi()))
}

// 0xA5
fn inst_res_4_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(4, cpu.r.hl.lo()))
}

// 0xA6
fn inst_res_4_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 4)
}

// 0xA7
fn inst_res_4_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(4, cpu.r.af.hi()))
}

// 0xA8
fn inst_res_5_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(5, cpu.r.bc.hi()))
}

// 0xA9
fn inst_res_5_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(5, cpu.r.bc.lo()))
}

// 0xAA
fn inst_res_5_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(5, cpu.r.de.hi()))
}

// 0xAB
fn inst_res_5_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(5, cpu.r.de.lo()))
}

// 0xAC
fn inst_res_5_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(5, cpu.r.hl.hi()))
}

// 0xAD
fn inst_res_5_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(5, cpu.r.hl.lo()))
}

// 0xAE
fn inst_res_5_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 5)
}

// 0xAF
fn inst_res_5_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(5, cpu.r.af.hi()))
}

// 0xB0
fn inst_res_6_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(6, cpu.r.bc.hi()))
}

// 0xB1
fn inst_res_6_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(6, cpu.r.bc.lo()))
}

// 0xB2
fn inst_res_6_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(6, cpu.r.de.hi()))
}

// 0xB3
fn inst_res_6_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(6, cpu.r.de.lo()))
}

// 0xB4
fn inst_res_6_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(6, cpu.r.hl.hi()))
}

// 0xB5
fn inst_res_6_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(6, cpu.r.hl.lo()))
}

// 0xB6
fn inst_res_6_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 6)
}

// 0xB7
fn inst_res_6_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(6, cpu.r.af.hi()))
}

// 0xB8
fn inst_res_7_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_res_n_n8(7, cpu.r.bc.hi()))
}

// 0xB9
fn inst_res_7_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_res_n_n8(7, cpu.r.bc.lo()))
}

// 0xBA
fn inst_res_7_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_res_n_n8(7, cpu.r.de.hi()))
}

// 0xBB
fn inst_res_7_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_res_n_n8(7, cpu.r.de.lo()))
}

// 0xBC
fn inst_res_7_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_res_n_n8(7, cpu.r.hl.hi()))
}

// 0xBD
fn inst_res_7_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_res_n_n8(7, cpu.r.hl.lo()))
}

// 0xBE
fn inst_res_7_hl(mut cpu CPU, data []u8) {
	cpu.routine_res_n_ptrhl(data, 7)
}

// 0xBF
fn inst_res_7_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_res_n_n8(7, cpu.r.af.hi()))
}

// 0xC0
fn inst_set_0_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(0, cpu.r.bc.hi()))
}

// 0xC1
fn inst_set_0_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(0, cpu.r.bc.lo()))
}

// 0xC2
fn inst_set_0_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(0, cpu.r.de.hi()))
}

// 0xC3
fn inst_set_0_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(0, cpu.r.de.lo()))
}

// 0xC4
fn inst_set_0_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(0, cpu.r.hl.hi()))
}

// 0xC5
fn inst_set_0_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(0, cpu.r.hl.lo()))
}

// 0xC6
fn inst_set_0_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 0)
}

// 0xC7
fn inst_set_0_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(0, cpu.r.af.hi()))
}

// 0xC8
fn inst_set_1_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(1, cpu.r.bc.hi()))
}

// 0xC9
fn inst_set_1_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(1, cpu.r.bc.lo()))
}

// 0xCA
fn inst_set_1_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(1, cpu.r.de.hi()))
}

// 0xCB
fn inst_set_1_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(1, cpu.r.de.lo()))
}

// 0xCC
fn inst_set_1_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(1, cpu.r.hl.hi()))
}

// 0xCD
fn inst_set_1_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(1, cpu.r.hl.lo()))
}

// 0xCE
fn inst_set_1_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 1)
}

// 0xCF
fn inst_set_1_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(1, cpu.r.af.hi()))
}

// 0xD0
fn inst_set_2_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(2, cpu.r.bc.hi()))
}

// 0xD1
fn inst_set_2_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(2, cpu.r.bc.lo()))
}

// 0xD2
fn inst_set_2_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(2, cpu.r.de.hi()))
}

// 0xD3
fn inst_set_2_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(2, cpu.r.de.lo()))
}

// 0xD4
fn inst_set_2_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(2, cpu.r.hl.hi()))
}

// 0xD5
fn inst_set_2_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(2, cpu.r.hl.lo()))
}

// 0xD6
fn inst_set_2_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 2)
}

// 0xD7
fn inst_set_2_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(2, cpu.r.af.hi()))
}

// 0xD8
fn inst_set_3_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(3, cpu.r.bc.hi()))
}

// 0xD9
fn inst_set_3_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(3, cpu.r.bc.lo()))
}

// 0xDA
fn inst_set_3_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(3, cpu.r.de.hi()))
}

// 0xDB
fn inst_set_3_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(3, cpu.r.de.lo()))
}

// 0xDC
fn inst_set_3_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(3, cpu.r.hl.hi()))
}

// 0xDD
fn inst_set_3_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(3, cpu.r.hl.lo()))
}

// 0xDE
fn inst_set_3_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 3)
}

// 0xDF
fn inst_set_3_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(3, cpu.r.af.hi()))
}

// 0xE0
fn inst_set_4_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(4, cpu.r.bc.hi()))
}

// 0xE1
fn inst_set_4_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(4, cpu.r.bc.lo()))
}

// 0xE2
fn inst_set_4_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(4, cpu.r.de.hi()))
}

// 0xE3
fn inst_set_4_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(4, cpu.r.de.lo()))
}

// 0xE4
fn inst_set_4_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(4, cpu.r.hl.hi()))
}

// 0xE5
fn inst_set_4_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(4, cpu.r.hl.lo()))
}

// 0xE6
fn inst_set_4_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 4)
}

// 0xE7
fn inst_set_4_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(4, cpu.r.af.hi()))
}

// 0xE8
fn inst_set_5_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(5, cpu.r.bc.hi()))
}

// 0xE9
fn inst_set_5_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(5, cpu.r.bc.lo()))
}

// 0xEA
fn inst_set_5_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(5, cpu.r.de.hi()))
}

// 0xEB
fn inst_set_5_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(5, cpu.r.de.lo()))
}

// 0xEC
fn inst_set_5_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(5, cpu.r.hl.hi()))
}

// 0xED
fn inst_set_5_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(5, cpu.r.hl.lo()))
}

// 0xEE
fn inst_set_5_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 5)
}

// 0xEF
fn inst_set_5_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(5, cpu.r.af.hi()))
}

// 0xF0
fn inst_set_6_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(6, cpu.r.bc.hi()))
}

// 0xF1
fn inst_set_6_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(6, cpu.r.bc.lo()))
}

// 0xF2
fn inst_set_6_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(6, cpu.r.de.hi()))
}

// 0xF3
fn inst_set_6_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(6, cpu.r.de.lo()))
}

// 0xF4
fn inst_set_6_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(6, cpu.r.hl.hi()))
}

// 0xF5
fn inst_set_6_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(6, cpu.r.hl.lo()))
}

// 0xF6
fn inst_set_6_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 6)
}

// 0xF7
fn inst_set_6_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(6, cpu.r.af.hi()))
}

// 0xF8
fn inst_set_7_b(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_hi(cpu.routine_set_n_n8(7, cpu.r.bc.hi()))
}

// 0xF9
fn inst_set_7_c(mut cpu CPU, _ []u8) {
	cpu.r.bc.set_lo(cpu.routine_set_n_n8(7, cpu.r.bc.lo()))
}

// 0xFA
fn inst_set_7_d(mut cpu CPU, _ []u8) {
	cpu.r.de.set_hi(cpu.routine_set_n_n8(7, cpu.r.de.hi()))
}

// 0xFB
fn inst_set_7_e(mut cpu CPU, _ []u8) {
	cpu.r.de.set_lo(cpu.routine_set_n_n8(7, cpu.r.de.lo()))
}

// 0xFC
fn inst_set_7_h(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_hi(cpu.routine_set_n_n8(7, cpu.r.hl.hi()))
}

// 0xFD
fn inst_set_7_l(mut cpu CPU, _ []u8) {
	cpu.r.hl.set_lo(cpu.routine_set_n_n8(7, cpu.r.hl.lo()))
}

// 0xFE
fn inst_set_7_hl(mut cpu CPU, data []u8) {
	cpu.routine_set_n_ptrhl(data, 7)
}

// 0xFF
fn inst_set_7_a(mut cpu CPU, _ []u8) {
	cpu.r.af.set_hi(cpu.routine_set_n_n8(7, cpu.r.af.hi()))
}
