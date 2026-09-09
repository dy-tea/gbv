module main

struct CPUInstruction {
	disassembly string
	bytes       u8
	function    ?fn (mut cpu CPU, data []u8)
}

const insts_unprefixed = [
	CPUInstruction{'NOP', 1, inst_nop}, // 0x00
	CPUInstruction{'LD BC, n16', 3, inst_ld_bc_n16}, // 0x01
	CPUInstruction{'LD BC, A', 1, inst_ld_bc_a}, // 0x02
	CPUInstruction{'INC BC', 1, inst_inc_bc}, // 0x03
	CPUInstruction{'INC B', 1, inst_inc_b}, // 0x04
	CPUInstruction{'DEC B', 1, inst_dec_b}, // 0x05
	CPUInstruction{'LD B, n8', 2, inst_ld_b_n8}, // 0x06
	CPUInstruction{'RLCA', 1, inst_rlca}, // 0x07
	CPUInstruction{'LD a16, SP', 3, inst_ld_a16_sp}, // 0x08
	CPUInstruction{'ADD HL, BC', 1, inst_add_hl_bc}, // 0x09
	CPUInstruction{'LD A, BC', 1, inst_ld_a_bc}, // 0x0A
	CPUInstruction{'DEC BC', 1, inst_dec_bc}, // 0x0B
	CPUInstruction{'INC C', 1, inst_inc_c}, // 0x0C
	CPUInstruction{'DEC C', 1, inst_dec_c}, // 0x0D
	CPUInstruction{'LD C, n8', 2, inst_ld_c_n8}, // 0x0E
	CPUInstruction{'RRCA', 1, inst_rrca}, // 0x0F
	CPUInstruction{'STOP', 2, inst_stop}, // 0x10
	CPUInstruction{'LD DE, n16', 3, inst_ld_de_n16}, // 0x11
	CPUInstruction{'LD DE, A', 1, inst_ld_de_a}, // 0x12
	CPUInstruction{'INC DE', 1, inst_inc_de}, // 0x13
	CPUInstruction{'INC D', 1, inst_inc_d}, // 0x14
	CPUInstruction{'DEC D', 1, inst_dec_d}, // 0x15
	CPUInstruction{'LD D, n8', 2, inst_ld_d_n8}, // 0x16
	CPUInstruction{'RLA', 1, inst_rla}, // 0x17
	CPUInstruction{'JR e8', 2, inst_jr_e8}, // 0x18
	CPUInstruction{'ADD HL, DE', 1, inst_add_hl_de}, // 0x19
	CPUInstruction{'LD A, DE', 1, inst_ld_a_de}, // 0x1A
	CPUInstruction{'DEC DE', 1, inst_dec_de}, // 0x1B
	CPUInstruction{'INC E', 1, inst_inc_e}, // 0x1C
	CPUInstruction{'DEC E', 1, inst_dec_e}, // 0x1D
	CPUInstruction{'LD E, n8', 2, inst_ld_e_n8}, // 0x1E
	CPUInstruction{'RRA', 1, inst_rra}, // 0x1F
	CPUInstruction{'JR NZ, e8', 2, inst_jr_nz_e8}, // 0x20
	CPUInstruction{'LD HL, n16', 3, inst_ld_hl_n16}, // 0x21
	CPUInstruction{'LDI HL, A', 1, inst_ldi_hl_a}, // 0x22
	CPUInstruction{'INC HL', 1, inst_inc_hl}, // 0x23
	CPUInstruction{'INC H', 1, inst_inc_h}, // 0x24
	CPUInstruction{'DEC H', 1, inst_dec_h}, // 0x25
	CPUInstruction{'LD H, n8', 2, inst_ld_h_n8}, // 0x26
	CPUInstruction{'DAA', 1, inst_daa}, // 0x27
	CPUInstruction{'JR Z, e8', 2, inst_jr_z_e8}, // 0x28
	CPUInstruction{'ADD HL, HL', 1, inst_add_hl_hl}, // 0x29
	CPUInstruction{'LDI A, HL', 1, inst_ldi_a_hl}, // 0x2A
	CPUInstruction{'DEC HL', 1, inst_dec_hl}, // 0x2B
	CPUInstruction{'INC L', 1, inst_inc_l}, // 0x2C
	CPUInstruction{'DEC L', 1, inst_dec_l}, // 0x2D
	CPUInstruction{'LD L, n8', 2, inst_ld_l_n8}, // 0x2E
	CPUInstruction{'CPL', 1, inst_cpl}, // 0x2F
	CPUInstruction{'JR NC, e8', 2, inst_jr_nc_e8}, // 0x30
	CPUInstruction{'LD SP, n16', 3, inst_ld_sp_n16}, // 0x31
	CPUInstruction{'LDD HL, A', 1, inst_ldd_hl_a}, // 0x32
	CPUInstruction{'INC SP', 1, inst_inc_sp}, // 0x33
	CPUInstruction{'INCI HL', 1, inst_inci_hl}, // 0x34
	CPUInstruction{'DECI HL', 1, inst_deci_hl}, // 0x35
	CPUInstruction{'LDI HL, n8', 2, inst_ldi_hl_n8}, // 0x36
	CPUInstruction{'SCF', 1, inst_scf}, // 0x37
	CPUInstruction{'JR C, e8', 2, inst_jr_c_e8}, // 0x38
	CPUInstruction{'ADD HL, SP', 1, inst_add_hl_sp}, // 0x39
	CPUInstruction{'LDD A, HL', 1, inst_ldd_a_hl}, // 0x3A
	CPUInstruction{'DEC SP', 1, inst_dec_sp}, // 0x3B
	CPUInstruction{'INC A', 1, inst_inc_a}, // 0x3C
	CPUInstruction{'DEC A', 1, inst_dec_a}, // 0x3D
	CPUInstruction{'LD A, n8', 2, inst_ld_a_n8}, // 0x3E
	CPUInstruction{'CCF', 1, inst_ccf}, // 0x3F
	CPUInstruction{'LD B, B', 1, inst_ld_b_b}, // 0x40
	CPUInstruction{'LD B, C', 1, inst_ld_b_c}, // 0x41
	CPUInstruction{'LD B, D', 1, inst_ld_b_d}, // 0x42
	CPUInstruction{'LD B, E', 1, inst_ld_b_e}, // 0x43
	CPUInstruction{'LD B, H', 1, inst_ld_b_h}, // 0x44
	CPUInstruction{'LD B, L', 1, inst_ld_b_l}, // 0x45
	CPUInstruction{'LD B, HL', 1, inst_ld_b_hl}, // 0x46
	CPUInstruction{'LD B, A', 1, inst_ld_b_a}, // 0x47
	CPUInstruction{'LD C, B', 1, inst_ld_c_b}, // 0x48
	CPUInstruction{'LD C, C', 1, inst_ld_c_c}, // 0x49
	CPUInstruction{'LD C, D', 1, inst_ld_c_d}, // 0x4A
	CPUInstruction{'LD C, E', 1, inst_ld_c_e}, // 0x4B
	CPUInstruction{'LD C, H', 1, inst_ld_c_h}, // 0x4C
	CPUInstruction{'LD C, L', 1, inst_ld_c_l}, // 0x4D
	CPUInstruction{'LD C, HL', 1, inst_ld_c_hl}, // 0x4E
	CPUInstruction{'LD C, A', 1, inst_ld_c_a}, // 0x4F
	CPUInstruction{'LD D, B', 1, inst_ld_d_b}, // 0x50
	CPUInstruction{'LD D, C', 1, inst_ld_d_c}, // 0x51
	CPUInstruction{'LD D, D', 1, inst_ld_d_d}, // 0x52
	CPUInstruction{'LD D, E', 1, inst_ld_d_e}, // 0x53
	CPUInstruction{'LD D, H', 1, inst_ld_d_h}, // 0x54
	CPUInstruction{'LD D, L', 1, inst_ld_d_l}, // 0x55
	CPUInstruction{'LD D, HL', 1, inst_ld_d_hl}, // 0x56
	CPUInstruction{'LD D, A', 1, inst_ld_d_a}, // 0x57
	CPUInstruction{'LD E, B', 1, inst_ld_e_b}, // 0x58
	CPUInstruction{'LD E, C', 1, inst_ld_e_c}, // 0x59
	CPUInstruction{'LD E, D', 1, inst_ld_e_d}, // 0x5A
	CPUInstruction{'LD E, E', 1, inst_ld_e_e}, // 0x5B
	CPUInstruction{'LD E, H', 1, inst_ld_e_h}, // 0x5C
	CPUInstruction{'LD E, L', 1, inst_ld_e_l}, // 0x5D
	CPUInstruction{'LD E, HL', 1, inst_ld_e_hl}, // 0x5E
	CPUInstruction{'LD E, A', 1, inst_ld_e_a}, // 0x5F
	CPUInstruction{'LD H, B', 1, inst_ld_h_b}, // 0x60
	CPUInstruction{'LD H, C', 1, inst_ld_h_c}, // 0x61
	CPUInstruction{'LD H, D', 1, inst_ld_h_d}, // 0x62
	CPUInstruction{'LD H, E', 1, inst_ld_h_e}, // 0x63
	CPUInstruction{'LD H, H', 1, inst_ld_h_h}, // 0x64
	CPUInstruction{'LD H, L', 1, inst_ld_h_l}, // 0x65
	CPUInstruction{'LD H, HL', 1, inst_ld_h_hl}, // 0x66
	CPUInstruction{'LD H, A', 1, inst_ld_h_a}, // 0x67
	CPUInstruction{'LD L, B', 1, inst_ld_l_b}, // 0x68
	CPUInstruction{'LD L, C', 1, inst_ld_l_c}, // 0x69
	CPUInstruction{'LD L, D', 1, inst_ld_l_d}, // 0x6A
	CPUInstruction{'LD L, E', 1, inst_ld_l_e}, // 0x6B
	CPUInstruction{'LD L, H', 1, inst_ld_l_h}, // 0x6C
	CPUInstruction{'LD L, L', 1, inst_ld_l_l}, // 0x6D
	CPUInstruction{'LD L, HL', 1, inst_ld_l_hl}, // 0x6E
	CPUInstruction{'LD L, A', 1, inst_ld_l_a}, // 0x6F
	CPUInstruction{'LD HL, B', 1, inst_ld_hl_b}, // 0x70
	CPUInstruction{'LD HL, C', 1, inst_ld_hl_c}, // 0x71
	CPUInstruction{'LD HL, D', 1, inst_ld_hl_d}, // 0x72
	CPUInstruction{'LD HL, E', 1, inst_ld_hl_e}, // 0x73
	CPUInstruction{'LD HL, H', 1, inst_ld_hl_h}, // 0x74
	CPUInstruction{'LD HL, L', 1, inst_ld_hl_l}, // 0x75
	CPUInstruction{'HALT', 1, inst_halt}, // 0x76
	CPUInstruction{'LD HL, A', 1, inst_ld_hl_a}, // 0x77
	CPUInstruction{'LD A, B', 1, inst_ld_a_b}, // 0x78
	CPUInstruction{'LD A, C', 1, inst_ld_a_c}, // 0x79
	CPUInstruction{'LD A, D', 1, inst_ld_a_d}, // 0x7A
	CPUInstruction{'LD A, E', 1, inst_ld_a_e}, // 0x7B
	CPUInstruction{'LD A, H', 1, inst_ld_a_h}, // 0x7C
	CPUInstruction{'LD A, L', 1, inst_ld_a_l}, // 0x7D
	CPUInstruction{'LD A, HL', 1, inst_ld_a_hl}, // 0x7E
	CPUInstruction{'LD A, A', 1, inst_ld_a_a}, // 0x7F
	CPUInstruction{'ADD A, B', 1, inst_add_a_b}, // 0x80
	CPUInstruction{'ADD A, C', 1, inst_add_a_c}, // 0x81
	CPUInstruction{'ADD A, D', 1, inst_add_a_d}, // 0x82
	CPUInstruction{'ADD A, E', 1, inst_add_a_e}, // 0x83
	CPUInstruction{'ADD A, H', 1, inst_add_a_h}, // 0x84
	CPUInstruction{'ADD A, L', 1, inst_add_a_l}, // 0x85
	CPUInstruction{'ADI A, HL', 1, inst_adi_a_hl}, // 0x86
	CPUInstruction{'ADD A, A', 1, inst_add_a_a}, // 0x87
	CPUInstruction{'ADC A, B', 1, inst_adc_a_b}, // 0x88
	CPUInstruction{'ADC A, C', 1, inst_adc_a_c}, // 0x89
	CPUInstruction{'ADC A, D', 1, inst_adc_a_d}, // 0x8A
	CPUInstruction{'ADC A, E', 1, inst_adc_a_e}, // 0x8B
	CPUInstruction{'ADC A, H', 1, inst_adc_a_h}, // 0x8C
	CPUInstruction{'ADC A, L', 1, inst_adc_a_l}, // 0x8D
	CPUInstruction{'ADC A, HL', 1, inst_adc_a_hl}, // 0x8E
	CPUInstruction{'ADC A, A', 1, inst_adc_a_a}, // 0x8F
	CPUInstruction{'SUB A, B', 1, inst_sub_a_b}, // 0x90
	CPUInstruction{'SUB A, C', 1, inst_sub_a_c}, // 0x91
	CPUInstruction{'SUB A, D', 1, inst_sub_a_d}, // 0x92
	CPUInstruction{'SUB A, E', 1, inst_sub_a_e}, // 0x93
	CPUInstruction{'SUB A, H', 1, inst_sub_a_h}, // 0x94
	CPUInstruction{'SUB A, L', 1, inst_sub_a_l}, // 0x95
	CPUInstruction{'SUB A, HL', 1, inst_sub_a_hl}, // 0x96
	CPUInstruction{'SUB A, A', 1, inst_sub_a_a}, // 0x97
	CPUInstruction{'SBC A, B', 1, inst_sbc_a_b}, // 0x98
	CPUInstruction{'SBC A, C', 1, inst_sbc_a_c}, // 0x99
	CPUInstruction{'SBC A, D', 1, inst_sbc_a_d}, // 0x9A
	CPUInstruction{'SBC A, E', 1, inst_sbc_a_e}, // 0x9B
	CPUInstruction{'SBC A, H', 1, inst_sbc_a_h}, // 0x9C
	CPUInstruction{'SBC A, L', 1, inst_sbc_a_l}, // 0x9D
	CPUInstruction{'SBC A, HL', 1, inst_sbc_a_hl}, // 0x9E
	CPUInstruction{'SBC A, A', 1, inst_sbc_a_a}, // 0x9F
	CPUInstruction{'AND A, B', 1, inst_and_a_b}, // 0xA0
	CPUInstruction{'AND A, C', 1, inst_and_a_c}, // 0xA1
	CPUInstruction{'AND A, D', 1, inst_and_a_d}, // 0xA2
	CPUInstruction{'AND A, E', 1, inst_and_a_e}, // 0xA3
	CPUInstruction{'AND A, H', 1, inst_and_a_h}, // 0xA4
	CPUInstruction{'AND A, L', 1, inst_and_a_l}, // 0xA5
	CPUInstruction{'AND A, HL', 1, inst_and_a_hl}, // 0xA6
	CPUInstruction{'AND A, A', 1, inst_and_a_a}, // 0xA7
	CPUInstruction{'XOR A, B', 1, inst_xor_a_b}, // 0xA8
	CPUInstruction{'XOR A, C', 1, inst_xor_a_c}, // 0xA9
	CPUInstruction{'XOR A, D', 1, inst_xor_a_d}, // 0xAA
	CPUInstruction{'XOR A, E', 1, inst_xor_a_e}, // 0xAB
	CPUInstruction{'XOR A, H', 1, inst_xor_a_h}, // 0xAC
	CPUInstruction{'XOR A, L', 1, inst_xor_a_l}, // 0xAD
	CPUInstruction{'XOR A, HL', 1, inst_xor_a_hl}, // 0xAE
	CPUInstruction{'XOR A, A', 1, inst_xor_a_a}, // 0xAF
	CPUInstruction{'OR A, B', 1, inst_or_a_b}, // 0xB0
	CPUInstruction{'OR A, C', 1, inst_or_a_c}, // 0xB1
	CPUInstruction{'OR A, D', 1, inst_or_a_d}, // 0xB2
	CPUInstruction{'OR A, E', 1, inst_or_a_e}, // 0xB3
	CPUInstruction{'OR A, H', 1, inst_or_a_h}, // 0xB4
	CPUInstruction{'OR A, L', 1, inst_or_a_l}, // 0xB5
	CPUInstruction{'OR A, HL', 1, inst_or_a_hl}, // 0xB6
	CPUInstruction{'OR A, A', 1, inst_or_a_a}, // 0xB7
	CPUInstruction{'CP A, B', 1, inst_cp_a_b}, // 0xB8
	CPUInstruction{'CP A, C', 1, inst_cp_a_c}, // 0xB9
	CPUInstruction{'CP A, D', 1, inst_cp_a_d}, // 0xBA
	CPUInstruction{'CP A, E', 1, inst_cp_a_e}, // 0xBB
	CPUInstruction{'CP A, H', 1, inst_cp_a_h}, // 0xBC
	CPUInstruction{'CP A, L', 1, inst_cp_a_l}, // 0xBD
	CPUInstruction{'CP A, HL', 1, inst_cp_a_hl}, // 0xBE
	CPUInstruction{'CP A, A', 1, inst_cp_a_a}, // 0xBF
	CPUInstruction{'RET NZ', 1, inst_ret_nz}, // 0xC0
	CPUInstruction{'POP BC', 1, inst_pop_bc}, // 0xC1
	CPUInstruction{'JP NZ, a16', 3, inst_jp_nz_a16}, // 0xC2
	CPUInstruction{'JP a16', 3, inst_jp_a16}, // 0xC3
	CPUInstruction{'CALL NZ, a16', 3, inst_call_nz_a16}, // 0xC4
	CPUInstruction{'PUSH BC', 1, inst_push_bc}, // 0xC5
	CPUInstruction{'ADD A, n8', 2, inst_add_a_n8}, // 0xC6
	CPUInstruction{'RST \$00', 1, inst_rst_00}, // 0xC7
	CPUInstruction{'RET Z', 1, inst_ret_z}, // 0xC8
	CPUInstruction{'RET', 1, inst_ret}, // 0xC9
	CPUInstruction{'JP Z, a16', 3, inst_jp_z_a16}, // 0xCA
	CPUInstruction{'PREFIX', 1, none}, // 0xCB
	CPUInstruction{'CALL Z, a16', 3, inst_call_z_a16}, // 0xCC
	CPUInstruction{'CALL a16', 3, inst_call_a16}, // 0xCD
	CPUInstruction{'ADC A, n8', 2, inst_adc_a_n8}, // 0xCE
	CPUInstruction{'RST \$08', 1, inst_rst_08}, // 0xCF
	CPUInstruction{'RET NC', 1, inst_ret_nc}, // 0xD0
	CPUInstruction{'POP DE', 1, inst_pop_de}, // 0xD1
	CPUInstruction{'JP NC, a16', 3, inst_jp_nc_a16}, // 0xD2
	CPUInstruction{'ILLEGAL_D3', 1, none}, // 0xD3
	CPUInstruction{'CALL NC, a16', 3, inst_call_nc_a16}, // 0xD4
	CPUInstruction{'PUSH DE', 1, inst_push_de}, // 0xD5
	CPUInstruction{'SUB A, n8', 2, inst_sub_a_n8}, // 0xD6
	CPUInstruction{'RST \$10', 1, inst_rst_10}, // 0xD7
	CPUInstruction{'RET C', 1, inst_ret_c}, // 0xD8
	CPUInstruction{'RETI', 1, inst_reti}, // 0xD9
	CPUInstruction{'JP C, a16', 3, inst_jp_c_a16}, // 0xDA
	CPUInstruction{'ILLEGAL_DB', 1, none}, // 0xDB
	CPUInstruction{'CALL C, a16', 3, inst_call_c_a16}, // 0xDC
	CPUInstruction{'ILLEGAL_DD', 1, none}, // 0xDD
	CPUInstruction{'SBC A, n8', 2, inst_sbc_a_n8}, // 0xDE
	CPUInstruction{'RST \$18', 1, inst_rst_18}, // 0xDF
	CPUInstruction{'LDH a8, A', 2, inst_ldh_a8_a}, // 0xE0
	CPUInstruction{'POP HL', 1, inst_pop_hl}, // 0xE1
	CPUInstruction{'LDH C, A', 1, inst_ldh_c_a}, // 0xE2
	CPUInstruction{'ILLEGAL_E3', 1, none}, // 0xE3
	CPUInstruction{'ILLEGAL_E4', 1, none}, // 0xE4
	CPUInstruction{'PUSH HL', 1, inst_push_hl}, // 0xE5
	CPUInstruction{'AND A, n8', 2, inst_and_a_n8}, // 0xE6
	CPUInstruction{'RST \$20', 1, inst_rst_20}, // 0xE7
	CPUInstruction{'ADD SP, e8', 2, inst_add_sp_e8}, // 0xE8
	CPUInstruction{'JP HL', 1, inst_jp_hl}, // 0xE9
	CPUInstruction{'LD a16, A', 3, inst_ld_a16_a}, // 0xEA
	CPUInstruction{'ILLEGAL_EB', 1, none}, // 0xEB
	CPUInstruction{'ILLEGAL_EC', 1, none}, // 0xEC
	CPUInstruction{'ILLEGAL_ED', 1, none}, // 0xED
	CPUInstruction{'XOR A, n8', 2, inst_xor_a_n8}, // 0xEE
	CPUInstruction{'RST \$28', 1, inst_rst_28}, // 0xEF
	CPUInstruction{'LDH A, a8', 2, inst_ldh_a_a8}, // 0xF0
	CPUInstruction{'POP AF', 1, inst_pop_af}, // 0xF1
	CPUInstruction{'LDH A, C', 1, inst_ldh_a_c}, // 0xF2
	CPUInstruction{'DI', 1, inst_di}, // 0xF3
	CPUInstruction{'ILLEGAL_F4', 1, none}, // 0xF4
	CPUInstruction{'PUSH AF', 1, inst_push_af}, // 0xF5
	CPUInstruction{'OR A, n8', 2, inst_or_a_n8}, // 0xF6
	CPUInstruction{'RST \$30', 1, inst_rst_30}, // 0xF7
	CPUInstruction{'LD HL, SP, e8', 2, inst_ld_hl_sp_e8}, // 0xF8
	CPUInstruction{'LD SP, HL', 1, inst_ld_sp_hl}, // 0xF9
	CPUInstruction{'LD A, a16', 3, inst_ld_a_a16}, // 0xFA
	CPUInstruction{'EI', 1, inst_ei}, // 0xFB
	CPUInstruction{'ILLEGAL_FC', 1, none}, // 0xFC
	CPUInstruction{'ILLEGAL_FD', 1, none}, // 0xFD
	CPUInstruction{'CP A, n8', 2, inst_cp_a_n8}, // 0xFE
	CPUInstruction{'RST \$38', 1, inst_rst_38}, // 0xFF
]

fn inst(op u8) CPUInstruction {
	return insts_unprefixed[op]
}

fn inst_prefixed(op u8) CPUInstruction {
	dump('TODO: inst_prefixed')
	return CPUInstruction{}
}
