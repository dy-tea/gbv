module main

struct CPUInstructionUnprefixed {
	disassembly string
	bytes       u8
	function    ?fn (mut cpu CPU)
}

struct CPUInstructionPrefixed {
	disassembly string
	function    ?fn (mut cpu CPU)
}

type CPUInstruction = CPUInstructionUnprefixed | CPUInstructionPrefixed

const insts_unprefixed = [
	CPUInstructionUnprefixed{'NOP', 1, inst_nop}, // 0x00
	CPUInstructionUnprefixed{'LD BC, n16', 3, inst_ld_bc_n16}, // 0x01
	CPUInstructionUnprefixed{'LD BC, A', 1, inst_ld_bc_a}, // 0x02
	CPUInstructionUnprefixed{'INC BC', 1, inst_inc_bc}, // 0x03
	CPUInstructionUnprefixed{'INC B', 1, inst_inc_b}, // 0x04
	CPUInstructionUnprefixed{'DEC B', 1, inst_dec_b}, // 0x05
	CPUInstructionUnprefixed{'LD B, n8', 2, inst_ld_b_n8}, // 0x06
	CPUInstructionUnprefixed{'RLCA', 1, inst_rlca}, // 0x07
	CPUInstructionUnprefixed{'LD a16, SP', 3, inst_ld_a16_sp}, // 0x08
	CPUInstructionUnprefixed{'ADD HL, BC', 1, inst_add_hl_bc}, // 0x09
	CPUInstructionUnprefixed{'LD A, BC', 1, inst_ld_a_bc}, // 0x0A
	CPUInstructionUnprefixed{'DEC BC', 1, inst_dec_bc}, // 0x0B
	CPUInstructionUnprefixed{'INC C', 1, inst_inc_c}, // 0x0C
	CPUInstructionUnprefixed{'DEC C', 1, inst_dec_c}, // 0x0D
	CPUInstructionUnprefixed{'LD C, n8', 2, inst_ld_c_n8}, // 0x0E
	CPUInstructionUnprefixed{'RRCA', 1, inst_rrca}, // 0x0F
	CPUInstructionUnprefixed{'STOP', 2, inst_stop}, // 0x10
	CPUInstructionUnprefixed{'LD DE, n16', 3, inst_ld_de_n16}, // 0x11
	CPUInstructionUnprefixed{'LD DE, A', 1, inst_ld_de_a}, // 0x12
	CPUInstructionUnprefixed{'INC DE', 1, inst_inc_de}, // 0x13
	CPUInstructionUnprefixed{'INC D', 1, inst_inc_d}, // 0x14
	CPUInstructionUnprefixed{'DEC D', 1, inst_dec_d}, // 0x15
	CPUInstructionUnprefixed{'LD D, n8', 2, inst_ld_d_n8}, // 0x16
	CPUInstructionUnprefixed{'RLA', 1, inst_rla}, // 0x17
	CPUInstructionUnprefixed{'JR e8', 2, inst_jr_e8}, // 0x18
	CPUInstructionUnprefixed{'ADD HL, DE', 1, inst_add_hl_de}, // 0x19
	CPUInstructionUnprefixed{'LD A, DE', 1, inst_ld_a_de}, // 0x1A
	CPUInstructionUnprefixed{'DEC DE', 1, inst_dec_de}, // 0x1B
	CPUInstructionUnprefixed{'INC E', 1, inst_inc_e}, // 0x1C
	CPUInstructionUnprefixed{'DEC E', 1, inst_dec_e}, // 0x1D
	CPUInstructionUnprefixed{'LD E, n8', 2, inst_ld_e_n8}, // 0x1E
	CPUInstructionUnprefixed{'RRA', 1, inst_rra}, // 0x1F
	CPUInstructionUnprefixed{'JR NZ, e8', 2, inst_jr_nz_e8}, // 0x20
	CPUInstructionUnprefixed{'LD HL, n16', 3, inst_ld_hl_n16}, // 0x21
	CPUInstructionUnprefixed{'LDI HL, A', 1, inst_ldi_hl_a}, // 0x22
	CPUInstructionUnprefixed{'INC HL', 1, inst_inc_hl}, // 0x23
	CPUInstructionUnprefixed{'INC H', 1, inst_inc_h}, // 0x24
	CPUInstructionUnprefixed{'DEC H', 1, inst_dec_h}, // 0x25
	CPUInstructionUnprefixed{'LD H, n8', 2, inst_ld_h_n8}, // 0x26
	CPUInstructionUnprefixed{'DAA', 1, inst_daa}, // 0x27
	CPUInstructionUnprefixed{'JR Z, e8', 2, inst_jr_z_e8}, // 0x28
	CPUInstructionUnprefixed{'ADD HL, HL', 1, inst_add_hl_hl}, // 0x29
	CPUInstructionUnprefixed{'LDI A, HL', 1, inst_ldi_a_hl}, // 0x2A
	CPUInstructionUnprefixed{'DEC HL', 1, inst_dec_hl}, // 0x2B
	CPUInstructionUnprefixed{'INC L', 1, inst_inc_l}, // 0x2C
	CPUInstructionUnprefixed{'DEC L', 1, inst_dec_l}, // 0x2D
	CPUInstructionUnprefixed{'LD L, n8', 2, inst_ld_l_n8}, // 0x2E
	CPUInstructionUnprefixed{'CPL', 1, inst_cpl}, // 0x2F
	CPUInstructionUnprefixed{'JR NC, e8', 2, inst_jr_nc_e8}, // 0x30
	CPUInstructionUnprefixed{'LD SP, n16', 3, inst_ld_sp_n16}, // 0x31
	CPUInstructionUnprefixed{'LDD HL, A', 1, inst_ldd_hl_a}, // 0x32
	CPUInstructionUnprefixed{'INC SP', 1, inst_inc_sp}, // 0x33
	CPUInstructionUnprefixed{'INCI HL', 1, inst_inci_hl}, // 0x34
	CPUInstructionUnprefixed{'DECI HL', 1, inst_deci_hl}, // 0x35
	CPUInstructionUnprefixed{'LDI HL, n8', 2, inst_ldi_hl_n8}, // 0x36
	CPUInstructionUnprefixed{'SCF', 1, inst_scf}, // 0x37
	CPUInstructionUnprefixed{'JR C, e8', 2, inst_jr_c_e8}, // 0x38
	CPUInstructionUnprefixed{'ADD HL, SP', 1, inst_add_hl_sp}, // 0x39
	CPUInstructionUnprefixed{'LDD A, HL', 1, inst_ldd_a_hl}, // 0x3A
	CPUInstructionUnprefixed{'DEC SP', 1, inst_dec_sp}, // 0x3B
	CPUInstructionUnprefixed{'INC A', 1, inst_inc_a}, // 0x3C
	CPUInstructionUnprefixed{'DEC A', 1, inst_dec_a}, // 0x3D
	CPUInstructionUnprefixed{'LD A, n8', 2, inst_ld_a_n8}, // 0x3E
	CPUInstructionUnprefixed{'CCF', 1, inst_ccf}, // 0x3F
	CPUInstructionUnprefixed{'LD B, B', 1, inst_ld_b_b}, // 0x40
	CPUInstructionUnprefixed{'LD B, C', 1, inst_ld_b_c}, // 0x41
	CPUInstructionUnprefixed{'LD B, D', 1, inst_ld_b_d}, // 0x42
	CPUInstructionUnprefixed{'LD B, E', 1, inst_ld_b_e}, // 0x43
	CPUInstructionUnprefixed{'LD B, H', 1, inst_ld_b_h}, // 0x44
	CPUInstructionUnprefixed{'LD B, L', 1, inst_ld_b_l}, // 0x45
	CPUInstructionUnprefixed{'LD B, HL', 1, inst_ld_b_hl}, // 0x46
	CPUInstructionUnprefixed{'LD B, A', 1, inst_ld_b_a}, // 0x47
	CPUInstructionUnprefixed{'LD C, B', 1, inst_ld_c_b}, // 0x48
	CPUInstructionUnprefixed{'LD C, C', 1, inst_ld_c_c}, // 0x49
	CPUInstructionUnprefixed{'LD C, D', 1, inst_ld_c_d}, // 0x4A
	CPUInstructionUnprefixed{'LD C, E', 1, inst_ld_c_e}, // 0x4B
	CPUInstructionUnprefixed{'LD C, H', 1, inst_ld_c_h}, // 0x4C
	CPUInstructionUnprefixed{'LD C, L', 1, inst_ld_c_l}, // 0x4D
	CPUInstructionUnprefixed{'LD C, HL', 1, inst_ld_c_hl}, // 0x4E
	CPUInstructionUnprefixed{'LD C, A', 1, inst_ld_c_a}, // 0x4F
	CPUInstructionUnprefixed{'LD D, B', 1, inst_ld_d_b}, // 0x50
	CPUInstructionUnprefixed{'LD D, C', 1, inst_ld_d_c}, // 0x51
	CPUInstructionUnprefixed{'LD D, D', 1, inst_ld_d_d}, // 0x52
	CPUInstructionUnprefixed{'LD D, E', 1, inst_ld_d_e}, // 0x53
	CPUInstructionUnprefixed{'LD D, H', 1, inst_ld_d_h}, // 0x54
	CPUInstructionUnprefixed{'LD D, L', 1, inst_ld_d_l}, // 0x55
	CPUInstructionUnprefixed{'LD D, HL', 1, inst_ld_d_hl}, // 0x56
	CPUInstructionUnprefixed{'LD D, A', 1, inst_ld_d_a}, // 0x57
	CPUInstructionUnprefixed{'LD E, B', 1, inst_ld_e_b}, // 0x58
	CPUInstructionUnprefixed{'LD E, C', 1, inst_ld_e_c}, // 0x59
	CPUInstructionUnprefixed{'LD E, D', 1, inst_ld_e_d}, // 0x5A
	CPUInstructionUnprefixed{'LD E, E', 1, inst_ld_e_e}, // 0x5B
	CPUInstructionUnprefixed{'LD E, H', 1, inst_ld_e_h}, // 0x5C
	CPUInstructionUnprefixed{'LD E, L', 1, inst_ld_e_l}, // 0x5D
	CPUInstructionUnprefixed{'LD E, HL', 1, inst_ld_e_hl}, // 0x5E
	CPUInstructionUnprefixed{'LD E, A', 1, inst_ld_e_a}, // 0x5F
	CPUInstructionUnprefixed{'LD H, B', 1, inst_ld_h_b}, // 0x60
	CPUInstructionUnprefixed{'LD H, C', 1, inst_ld_h_c}, // 0x61
	CPUInstructionUnprefixed{'LD H, D', 1, inst_ld_h_d}, // 0x62
	CPUInstructionUnprefixed{'LD H, E', 1, inst_ld_h_e}, // 0x63
	CPUInstructionUnprefixed{'LD H, H', 1, inst_ld_h_h}, // 0x64
	CPUInstructionUnprefixed{'LD H, L', 1, inst_ld_h_l}, // 0x65
	CPUInstructionUnprefixed{'LD H, HL', 1, inst_ld_h_hl}, // 0x66
	CPUInstructionUnprefixed{'LD H, A', 1, inst_ld_h_a}, // 0x67
	CPUInstructionUnprefixed{'LD L, B', 1, inst_ld_l_b}, // 0x68
	CPUInstructionUnprefixed{'LD L, C', 1, inst_ld_l_c}, // 0x69
	CPUInstructionUnprefixed{'LD L, D', 1, inst_ld_l_d}, // 0x6A
	CPUInstructionUnprefixed{'LD L, E', 1, inst_ld_l_e}, // 0x6B
	CPUInstructionUnprefixed{'LD L, H', 1, inst_ld_l_h}, // 0x6C
	CPUInstructionUnprefixed{'LD L, L', 1, inst_ld_l_l}, // 0x6D
	CPUInstructionUnprefixed{'LD L, HL', 1, inst_ld_l_hl}, // 0x6E
	CPUInstructionUnprefixed{'LD L, A', 1, inst_ld_l_a}, // 0x6F
	CPUInstructionUnprefixed{'LD HL, B', 1, inst_ld_hl_b}, // 0x70
	CPUInstructionUnprefixed{'LD HL, C', 1, inst_ld_hl_c}, // 0x71
	CPUInstructionUnprefixed{'LD HL, D', 1, inst_ld_hl_d}, // 0x72
	CPUInstructionUnprefixed{'LD HL, E', 1, inst_ld_hl_e}, // 0x73
	CPUInstructionUnprefixed{'LD HL, H', 1, inst_ld_hl_h}, // 0x74
	CPUInstructionUnprefixed{'LD HL, L', 1, inst_ld_hl_l}, // 0x75
	CPUInstructionUnprefixed{'HALT', 1, inst_halt}, // 0x76
	CPUInstructionUnprefixed{'LD HL, A', 1, inst_ld_hl_a}, // 0x77
	CPUInstructionUnprefixed{'LD A, B', 1, inst_ld_a_b}, // 0x78
	CPUInstructionUnprefixed{'LD A, C', 1, inst_ld_a_c}, // 0x79
	CPUInstructionUnprefixed{'LD A, D', 1, inst_ld_a_d}, // 0x7A
	CPUInstructionUnprefixed{'LD A, E', 1, inst_ld_a_e}, // 0x7B
	CPUInstructionUnprefixed{'LD A, H', 1, inst_ld_a_h}, // 0x7C
	CPUInstructionUnprefixed{'LD A, L', 1, inst_ld_a_l}, // 0x7D
	CPUInstructionUnprefixed{'LD A, HL', 1, inst_ld_a_hl}, // 0x7E
	CPUInstructionUnprefixed{'LD A, A', 1, inst_ld_a_a}, // 0x7F
	CPUInstructionUnprefixed{'ADD A, B', 1, inst_add_a_b}, // 0x80
	CPUInstructionUnprefixed{'ADD A, C', 1, inst_add_a_c}, // 0x81
	CPUInstructionUnprefixed{'ADD A, D', 1, inst_add_a_d}, // 0x82
	CPUInstructionUnprefixed{'ADD A, E', 1, inst_add_a_e}, // 0x83
	CPUInstructionUnprefixed{'ADD A, H', 1, inst_add_a_h}, // 0x84
	CPUInstructionUnprefixed{'ADD A, L', 1, inst_add_a_l}, // 0x85
	CPUInstructionUnprefixed{'ADI A, HL', 1, inst_adi_a_hl}, // 0x86
	CPUInstructionUnprefixed{'ADD A, A', 1, inst_add_a_a}, // 0x87
	CPUInstructionUnprefixed{'ADC A, B', 1, inst_adc_a_b}, // 0x88
	CPUInstructionUnprefixed{'ADC A, C', 1, inst_adc_a_c}, // 0x89
	CPUInstructionUnprefixed{'ADC A, D', 1, inst_adc_a_d}, // 0x8A
	CPUInstructionUnprefixed{'ADC A, E', 1, inst_adc_a_e}, // 0x8B
	CPUInstructionUnprefixed{'ADC A, H', 1, inst_adc_a_h}, // 0x8C
	CPUInstructionUnprefixed{'ADC A, L', 1, inst_adc_a_l}, // 0x8D
	CPUInstructionUnprefixed{'ADC A, HL', 1, inst_adc_a_hl}, // 0x8E
	CPUInstructionUnprefixed{'ADC A, A', 1, inst_adc_a_a}, // 0x8F
	CPUInstructionUnprefixed{'SUB A, B', 1, inst_sub_a_b}, // 0x90
	CPUInstructionUnprefixed{'SUB A, C', 1, inst_sub_a_c}, // 0x91
	CPUInstructionUnprefixed{'SUB A, D', 1, inst_sub_a_d}, // 0x92
	CPUInstructionUnprefixed{'SUB A, E', 1, inst_sub_a_e}, // 0x93
	CPUInstructionUnprefixed{'SUB A, H', 1, inst_sub_a_h}, // 0x94
	CPUInstructionUnprefixed{'SUB A, L', 1, inst_sub_a_l}, // 0x95
	CPUInstructionUnprefixed{'SUB A, HL', 1, inst_sub_a_hl}, // 0x96
	CPUInstructionUnprefixed{'SUB A, A', 1, inst_sub_a_a}, // 0x97
	CPUInstructionUnprefixed{'SBC A, B', 1, inst_sbc_a_b}, // 0x98
	CPUInstructionUnprefixed{'SBC A, C', 1, inst_sbc_a_c}, // 0x99
	CPUInstructionUnprefixed{'SBC A, D', 1, inst_sbc_a_d}, // 0x9A
	CPUInstructionUnprefixed{'SBC A, E', 1, inst_sbc_a_e}, // 0x9B
	CPUInstructionUnprefixed{'SBC A, H', 1, inst_sbc_a_h}, // 0x9C
	CPUInstructionUnprefixed{'SBC A, L', 1, inst_sbc_a_l}, // 0x9D
	CPUInstructionUnprefixed{'SBC A, HL', 1, inst_sbc_a_hl}, // 0x9E
	CPUInstructionUnprefixed{'SBC A, A', 1, inst_sbc_a_a}, // 0x9F
	CPUInstructionUnprefixed{'AND A, B', 1, inst_and_a_b}, // 0xA0
	CPUInstructionUnprefixed{'AND A, C', 1, inst_and_a_c}, // 0xA1
	CPUInstructionUnprefixed{'AND A, D', 1, inst_and_a_d}, // 0xA2
	CPUInstructionUnprefixed{'AND A, E', 1, inst_and_a_e}, // 0xA3
	CPUInstructionUnprefixed{'AND A, H', 1, inst_and_a_h}, // 0xA4
	CPUInstructionUnprefixed{'AND A, L', 1, inst_and_a_l}, // 0xA5
	CPUInstructionUnprefixed{'AND A, HL', 1, inst_and_a_hl}, // 0xA6
	CPUInstructionUnprefixed{'AND A, A', 1, inst_and_a_a}, // 0xA7
	CPUInstructionUnprefixed{'XOR A, B', 1, inst_xor_a_b}, // 0xA8
	CPUInstructionUnprefixed{'XOR A, C', 1, inst_xor_a_c}, // 0xA9
	CPUInstructionUnprefixed{'XOR A, D', 1, inst_xor_a_d}, // 0xAA
	CPUInstructionUnprefixed{'XOR A, E', 1, inst_xor_a_e}, // 0xAB
	CPUInstructionUnprefixed{'XOR A, H', 1, inst_xor_a_h}, // 0xAC
	CPUInstructionUnprefixed{'XOR A, L', 1, inst_xor_a_l}, // 0xAD
	CPUInstructionUnprefixed{'XOR A, HL', 1, inst_xor_a_hl}, // 0xAE
	CPUInstructionUnprefixed{'XOR A, A', 1, inst_xor_a_a}, // 0xAF
	CPUInstructionUnprefixed{'OR A, B', 1, inst_or_a_b}, // 0xB0
	CPUInstructionUnprefixed{'OR A, C', 1, inst_or_a_c}, // 0xB1
	CPUInstructionUnprefixed{'OR A, D', 1, inst_or_a_d}, // 0xB2
	CPUInstructionUnprefixed{'OR A, E', 1, inst_or_a_e}, // 0xB3
	CPUInstructionUnprefixed{'OR A, H', 1, inst_or_a_h}, // 0xB4
	CPUInstructionUnprefixed{'OR A, L', 1, inst_or_a_l}, // 0xB5
	CPUInstructionUnprefixed{'OR A, HL', 1, inst_or_a_hl}, // 0xB6
	CPUInstructionUnprefixed{'OR A, A', 1, inst_or_a_a}, // 0xB7
	CPUInstructionUnprefixed{'CP A, B', 1, inst_cp_a_b}, // 0xB8
	CPUInstructionUnprefixed{'CP A, C', 1, inst_cp_a_c}, // 0xB9
	CPUInstructionUnprefixed{'CP A, D', 1, inst_cp_a_d}, // 0xBA
	CPUInstructionUnprefixed{'CP A, E', 1, inst_cp_a_e}, // 0xBB
	CPUInstructionUnprefixed{'CP A, H', 1, inst_cp_a_h}, // 0xBC
	CPUInstructionUnprefixed{'CP A, L', 1, inst_cp_a_l}, // 0xBD
	CPUInstructionUnprefixed{'CP A, HL', 1, inst_cp_a_hl}, // 0xBE
	CPUInstructionUnprefixed{'CP A, A', 1, inst_cp_a_a}, // 0xBF
	CPUInstructionUnprefixed{'RET NZ', 1, inst_ret_nz}, // 0xC0
	CPUInstructionUnprefixed{'POP BC', 1, inst_pop_bc}, // 0xC1
	CPUInstructionUnprefixed{'JP NZ, a16', 3, inst_jp_nz_a16}, // 0xC2
	CPUInstructionUnprefixed{'JP a16', 3, inst_jp_a16}, // 0xC3
	CPUInstructionUnprefixed{'CALL NZ, a16', 3, inst_call_nz_a16}, // 0xC4
	CPUInstructionUnprefixed{'PUSH BC', 1, inst_push_bc}, // 0xC5
	CPUInstructionUnprefixed{'ADD A, n8', 2, inst_add_a_n8}, // 0xC6
	CPUInstructionUnprefixed{'RST \$00', 1, inst_rst_00}, // 0xC7
	CPUInstructionUnprefixed{'RET Z', 1, inst_ret_z}, // 0xC8
	CPUInstructionUnprefixed{'RET', 1, inst_ret}, // 0xC9
	CPUInstructionUnprefixed{'JP Z, a16', 3, inst_jp_z_a16}, // 0xCA
	CPUInstructionUnprefixed{'PREFIX', 1, none}, // 0xCB
	CPUInstructionUnprefixed{'CALL Z, a16', 3, inst_call_z_a16}, // 0xCC
	CPUInstructionUnprefixed{'CALL a16', 3, inst_call_a16}, // 0xCD
	CPUInstructionUnprefixed{'ADC A, n8', 2, inst_adc_a_n8}, // 0xCE
	CPUInstructionUnprefixed{'RST \$08', 1, inst_rst_08}, // 0xCF
	CPUInstructionUnprefixed{'RET NC', 1, inst_ret_nc}, // 0xD0
	CPUInstructionUnprefixed{'POP DE', 1, inst_pop_de}, // 0xD1
	CPUInstructionUnprefixed{'JP NC, a16', 3, inst_jp_nc_a16}, // 0xD2
	CPUInstructionUnprefixed{'ILLEGAL_D3', 1, none}, // 0xD3
	CPUInstructionUnprefixed{'CALL NC, a16', 3, inst_call_nc_a16}, // 0xD4
	CPUInstructionUnprefixed{'PUSH DE', 1, inst_push_de}, // 0xD5
	CPUInstructionUnprefixed{'SUB A, n8', 2, inst_sub_a_n8}, // 0xD6
	CPUInstructionUnprefixed{'RST \$10', 1, inst_rst_10}, // 0xD7
	CPUInstructionUnprefixed{'RET C', 1, inst_ret_c}, // 0xD8
	CPUInstructionUnprefixed{'RETI', 1, inst_reti}, // 0xD9
	CPUInstructionUnprefixed{'JP C, a16', 3, inst_jp_c_a16}, // 0xDA
	CPUInstructionUnprefixed{'ILLEGAL_DB', 1, none}, // 0xDB
	CPUInstructionUnprefixed{'CALL C, a16', 3, inst_call_c_a16}, // 0xDC
	CPUInstructionUnprefixed{'ILLEGAL_DD', 1, none}, // 0xDD
	CPUInstructionUnprefixed{'SBC A, n8', 2, inst_sbc_a_n8}, // 0xDE
	CPUInstructionUnprefixed{'RST \$18', 1, inst_rst_18}, // 0xDF
	CPUInstructionUnprefixed{'LDH a8, A', 2, inst_ldh_a8_a}, // 0xE0
	CPUInstructionUnprefixed{'POP HL', 1, inst_pop_hl}, // 0xE1
	CPUInstructionUnprefixed{'LDH C, A', 1, inst_ldh_c_a}, // 0xE2
	CPUInstructionUnprefixed{'ILLEGAL_E3', 1, none}, // 0xE3
	CPUInstructionUnprefixed{'ILLEGAL_E4', 1, none}, // 0xE4
	CPUInstructionUnprefixed{'PUSH HL', 1, inst_push_hl}, // 0xE5
	CPUInstructionUnprefixed{'AND A, n8', 2, inst_and_a_n8}, // 0xE6
	CPUInstructionUnprefixed{'RST \$20', 1, inst_rst_20}, // 0xE7
	CPUInstructionUnprefixed{'ADD SP, e8', 2, inst_add_sp_e8}, // 0xE8
	CPUInstructionUnprefixed{'JP HL', 1, inst_jp_hl}, // 0xE9
	CPUInstructionUnprefixed{'LD a16, A', 3, inst_ld_a16_a}, // 0xEA
	CPUInstructionUnprefixed{'ILLEGAL_EB', 1, none}, // 0xEB
	CPUInstructionUnprefixed{'ILLEGAL_EC', 1, none}, // 0xEC
	CPUInstructionUnprefixed{'ILLEGAL_ED', 1, none}, // 0xED
	CPUInstructionUnprefixed{'XOR A, n8', 2, inst_xor_a_n8}, // 0xEE
	CPUInstructionUnprefixed{'RST \$28', 1, inst_rst_28}, // 0xEF
	CPUInstructionUnprefixed{'LDH A, a8', 2, inst_ldh_a_a8}, // 0xF0
	CPUInstructionUnprefixed{'POP AF', 1, inst_pop_af}, // 0xF1
	CPUInstructionUnprefixed{'LDH A, C', 1, inst_ldh_a_c}, // 0xF2
	CPUInstructionUnprefixed{'DI', 1, inst_di}, // 0xF3
	CPUInstructionUnprefixed{'ILLEGAL_F4', 1, none}, // 0xF4
	CPUInstructionUnprefixed{'PUSH AF', 1, inst_push_af}, // 0xF5
	CPUInstructionUnprefixed{'OR A, n8', 2, inst_or_a_n8}, // 0xF6
	CPUInstructionUnprefixed{'RST \$30', 1, inst_rst_30}, // 0xF7
	CPUInstructionUnprefixed{'LD HL, SP, e8', 2, inst_ld_hl_sp_e8}, // 0xF8
	CPUInstructionUnprefixed{'LD SP, HL', 1, inst_ld_sp_hl}, // 0xF9
	CPUInstructionUnprefixed{'LD A, a16', 3, inst_ld_a_a16}, // 0xFA
	CPUInstructionUnprefixed{'EI', 1, inst_ei}, // 0xFB
	CPUInstructionUnprefixed{'ILLEGAL_FC', 1, none}, // 0xFC
	CPUInstructionUnprefixed{'ILLEGAL_FD', 1, none}, // 0xFD
	CPUInstructionUnprefixed{'CP A, n8', 2, inst_cp_a_n8}, // 0xFE
	CPUInstructionUnprefixed{'RST \$38', 1, inst_rst_38}, // 0xFF
]

@[direct_array_access]
fn inst(op u8) CPUInstruction {
	return insts_unprefixed[op]
}

const insts_prefixed = [
	CPUInstructionPrefixed{'RLC B', inst_rlc_b}, // 0x00
	CPUInstructionPrefixed{'RLC C', inst_rlc_c}, // 0x01
	CPUInstructionPrefixed{'RLC D', inst_rlc_d}, // 0x02
	CPUInstructionPrefixed{'RLC E', inst_rlc_e}, // 0x03
	CPUInstructionPrefixed{'RLC H', inst_rlc_h}, // 0x04
	CPUInstructionPrefixed{'RLC L', inst_rlc_l}, // 0x05
	CPUInstructionPrefixed{'RLC HL', inst_rlc_hl}, // 0x06
	CPUInstructionPrefixed{'RLC A', inst_rlc_a}, // 0x07
	CPUInstructionPrefixed{'RRC B', inst_rrc_b}, // 0x08
	CPUInstructionPrefixed{'RRC C', inst_rrc_c}, // 0x09
	CPUInstructionPrefixed{'RRC D', inst_rrc_d}, // 0x0A
	CPUInstructionPrefixed{'RRC E', inst_rrc_e}, // 0x0B
	CPUInstructionPrefixed{'RRC H', inst_rrc_h}, // 0x0C
	CPUInstructionPrefixed{'RRC L', inst_rrc_l}, // 0x0D
	CPUInstructionPrefixed{'RRC HL', inst_rrc_hl}, // 0x0E
	CPUInstructionPrefixed{'RRC A', inst_rrc_a}, // 0x0F
	CPUInstructionPrefixed{'RL B', inst_rl_b}, // 0x10
	CPUInstructionPrefixed{'RL C', inst_rl_c}, // 0x11
	CPUInstructionPrefixed{'RL D', inst_rl_d}, // 0x12
	CPUInstructionPrefixed{'RL E', inst_rl_e}, // 0x13
	CPUInstructionPrefixed{'RL H', inst_rl_h}, // 0x14
	CPUInstructionPrefixed{'RL L', inst_rl_l}, // 0x15
	CPUInstructionPrefixed{'RL HL', inst_rl_hl}, // 0x16
	CPUInstructionPrefixed{'RL A', inst_rl_a}, // 0x17
	CPUInstructionPrefixed{'RR B', inst_rr_b}, // 0x18
	CPUInstructionPrefixed{'RR C', inst_rr_c}, // 0x19
	CPUInstructionPrefixed{'RR D', inst_rr_d}, // 0x1A
	CPUInstructionPrefixed{'RR E', inst_rr_e}, // 0x1B
	CPUInstructionPrefixed{'RR H', inst_rr_h}, // 0x1C
	CPUInstructionPrefixed{'RR L', inst_rr_l}, // 0x1D
	CPUInstructionPrefixed{'RR HL', inst_rr_hl}, // 0x1E
	CPUInstructionPrefixed{'RR A', inst_rr_a}, // 0x1F
	CPUInstructionPrefixed{'SLA B', inst_sla_b}, // 0x20
	CPUInstructionPrefixed{'SLA C', inst_sla_c}, // 0x21
	CPUInstructionPrefixed{'SLA D', inst_sla_d}, // 0x22
	CPUInstructionPrefixed{'SLA E', inst_sla_e}, // 0x23
	CPUInstructionPrefixed{'SLA H', inst_sla_h}, // 0x24
	CPUInstructionPrefixed{'SLA L', inst_sla_l}, // 0x25
	CPUInstructionPrefixed{'SLA HL', inst_sla_hl}, // 0x26
	CPUInstructionPrefixed{'SLA A', inst_sla_a}, // 0x27
	CPUInstructionPrefixed{'SRA B', inst_sra_b}, // 0x28
	CPUInstructionPrefixed{'SRA C', inst_sra_c}, // 0x29
	CPUInstructionPrefixed{'SRA D', inst_sra_d}, // 0x2A
	CPUInstructionPrefixed{'SRA E', inst_sra_e}, // 0x2B
	CPUInstructionPrefixed{'SRA H', inst_sra_h}, // 0x2C
	CPUInstructionPrefixed{'SRA L', inst_sra_l}, // 0x2D
	CPUInstructionPrefixed{'SRA HL', inst_sra_hl}, // 0x2E
	CPUInstructionPrefixed{'SRA A', inst_sra_a}, // 0x2F
	CPUInstructionPrefixed{'SWAP B', inst_swap_b}, // 0x30
	CPUInstructionPrefixed{'SWAP C', inst_swap_c}, // 0x31
	CPUInstructionPrefixed{'SWAP D', inst_swap_d}, // 0x32
	CPUInstructionPrefixed{'SWAP E', inst_swap_e}, // 0x33
	CPUInstructionPrefixed{'SWAP H', inst_swap_h}, // 0x34
	CPUInstructionPrefixed{'SWAP L', inst_swap_l}, // 0x35
	CPUInstructionPrefixed{'SWAP HL', inst_swap_hl}, // 0x36
	CPUInstructionPrefixed{'SWAP A', inst_swap_a}, // 0x37
	CPUInstructionPrefixed{'SRL B', inst_srl_b}, // 0x38
	CPUInstructionPrefixed{'SRL C', inst_srl_c}, // 0x39
	CPUInstructionPrefixed{'SRL D', inst_srl_d}, // 0x3A
	CPUInstructionPrefixed{'SRL E', inst_srl_e}, // 0x3B
	CPUInstructionPrefixed{'SRL H', inst_srl_h}, // 0x3C
	CPUInstructionPrefixed{'SRL L', inst_srl_l}, // 0x3D
	CPUInstructionPrefixed{'SRL HL', inst_srl_hl}, // 0x3E
	CPUInstructionPrefixed{'SRL A', inst_srl_a}, // 0x3F
	CPUInstructionPrefixed{'BIT 0, B', inst_bit_0_b}, // 0x40
	CPUInstructionPrefixed{'BIT 0, C', inst_bit_0_c}, // 0x41
	CPUInstructionPrefixed{'BIT 0, D', inst_bit_0_d}, // 0x42
	CPUInstructionPrefixed{'BIT 0, E', inst_bit_0_e}, // 0x43
	CPUInstructionPrefixed{'BIT 0, H', inst_bit_0_h}, // 0x44
	CPUInstructionPrefixed{'BIT 0, L', inst_bit_0_l}, // 0x45
	CPUInstructionPrefixed{'BIT 0, HL', inst_bit_0_hl}, // 0x46
	CPUInstructionPrefixed{'BIT 0, A', inst_bit_0_a}, // 0x47
	CPUInstructionPrefixed{'BIT 1, B', inst_bit_1_b}, // 0x48
	CPUInstructionPrefixed{'BIT 1, C', inst_bit_1_c}, // 0x49
	CPUInstructionPrefixed{'BIT 1, D', inst_bit_1_d}, // 0x4A
	CPUInstructionPrefixed{'BIT 1, E', inst_bit_1_e}, // 0x4B
	CPUInstructionPrefixed{'BIT 1, H', inst_bit_1_h}, // 0x4C
	CPUInstructionPrefixed{'BIT 1, L', inst_bit_1_l}, // 0x4D
	CPUInstructionPrefixed{'BIT 1, HL', inst_bit_1_hl}, // 0x4E
	CPUInstructionPrefixed{'BIT 1, A', inst_bit_1_a}, // 0x4F
	CPUInstructionPrefixed{'BIT 2, B', inst_bit_2_b}, // 0x50
	CPUInstructionPrefixed{'BIT 2, C', inst_bit_2_c}, // 0x51
	CPUInstructionPrefixed{'BIT 2, D', inst_bit_2_d}, // 0x52
	CPUInstructionPrefixed{'BIT 2, E', inst_bit_2_e}, // 0x53
	CPUInstructionPrefixed{'BIT 2, H', inst_bit_2_h}, // 0x54
	CPUInstructionPrefixed{'BIT 2, L', inst_bit_2_l}, // 0x55
	CPUInstructionPrefixed{'BIT 2, HL', inst_bit_2_hl}, // 0x56
	CPUInstructionPrefixed{'BIT 2, A', inst_bit_2_a}, // 0x57
	CPUInstructionPrefixed{'BIT 3, B', inst_bit_3_b}, // 0x58
	CPUInstructionPrefixed{'BIT 3, C', inst_bit_3_c}, // 0x59
	CPUInstructionPrefixed{'BIT 3, D', inst_bit_3_d}, // 0x5A
	CPUInstructionPrefixed{'BIT 3, E', inst_bit_3_e}, // 0x5B
	CPUInstructionPrefixed{'BIT 3, H', inst_bit_3_h}, // 0x5C
	CPUInstructionPrefixed{'BIT 3, L', inst_bit_3_l}, // 0x5D
	CPUInstructionPrefixed{'BIT 3, HL', inst_bit_3_hl}, // 0x5E
	CPUInstructionPrefixed{'BIT 3, A', inst_bit_3_a}, // 0x5F
	CPUInstructionPrefixed{'BIT 4, B', inst_bit_4_b}, // 0x60
	CPUInstructionPrefixed{'BIT 4, C', inst_bit_4_c}, // 0x61
	CPUInstructionPrefixed{'BIT 4, D', inst_bit_4_d}, // 0x62
	CPUInstructionPrefixed{'BIT 4, E', inst_bit_4_e}, // 0x63
	CPUInstructionPrefixed{'BIT 4, H', inst_bit_4_h}, // 0x64
	CPUInstructionPrefixed{'BIT 4, L', inst_bit_4_l}, // 0x65
	CPUInstructionPrefixed{'BIT 4, HL', inst_bit_4_hl}, // 0x66
	CPUInstructionPrefixed{'BIT 4, A', inst_bit_4_a}, // 0x67
	CPUInstructionPrefixed{'BIT 5, B', inst_bit_5_b}, // 0x68
	CPUInstructionPrefixed{'BIT 5, C', inst_bit_5_c}, // 0x69
	CPUInstructionPrefixed{'BIT 5, D', inst_bit_5_d}, // 0x6A
	CPUInstructionPrefixed{'BIT 5, E', inst_bit_5_e}, // 0x6B
	CPUInstructionPrefixed{'BIT 5, H', inst_bit_5_h}, // 0x6C
	CPUInstructionPrefixed{'BIT 5, L', inst_bit_5_l}, // 0x6D
	CPUInstructionPrefixed{'BIT 5, HL', inst_bit_5_hl}, // 0x6E
	CPUInstructionPrefixed{'BIT 5, A', inst_bit_5_a}, // 0x6F
	CPUInstructionPrefixed{'BIT 6, B', inst_bit_6_b}, // 0x70
	CPUInstructionPrefixed{'BIT 6, C', inst_bit_6_c}, // 0x71
	CPUInstructionPrefixed{'BIT 6, D', inst_bit_6_d}, // 0x72
	CPUInstructionPrefixed{'BIT 6, E', inst_bit_6_e}, // 0x73
	CPUInstructionPrefixed{'BIT 6, H', inst_bit_6_h}, // 0x74
	CPUInstructionPrefixed{'BIT 6, L', inst_bit_6_l}, // 0x75
	CPUInstructionPrefixed{'BIT 6, HL', inst_bit_6_hl}, // 0x76
	CPUInstructionPrefixed{'BIT 6, A', inst_bit_6_a}, // 0x77
	CPUInstructionPrefixed{'BIT 7, B', inst_bit_7_b}, // 0x78
	CPUInstructionPrefixed{'BIT 7, C', inst_bit_7_c}, // 0x79
	CPUInstructionPrefixed{'BIT 7, D', inst_bit_7_d}, // 0x7A
	CPUInstructionPrefixed{'BIT 7, E', inst_bit_7_e}, // 0x7B
	CPUInstructionPrefixed{'BIT 7, H', inst_bit_7_h}, // 0x7C
	CPUInstructionPrefixed{'BIT 7, L', inst_bit_7_l}, // 0x7D
	CPUInstructionPrefixed{'BIT 7, HL', inst_bit_7_hl}, // 0x7E
	CPUInstructionPrefixed{'BIT 7, A', inst_bit_7_a}, // 0x7F
	CPUInstructionPrefixed{'RES 0, B', inst_res_0_b}, // 0x80
	CPUInstructionPrefixed{'RES 0, C', inst_res_0_c}, // 0x81
	CPUInstructionPrefixed{'RES 0, D', inst_res_0_d}, // 0x82
	CPUInstructionPrefixed{'RES 0, E', inst_res_0_e}, // 0x83
	CPUInstructionPrefixed{'RES 0, H', inst_res_0_h}, // 0x84
	CPUInstructionPrefixed{'RES 0, L', inst_res_0_l}, // 0x85
	CPUInstructionPrefixed{'RES 0, HL', inst_res_0_hl}, // 0x86
	CPUInstructionPrefixed{'RES 0, A', inst_res_0_a}, // 0x87
	CPUInstructionPrefixed{'RES 1, B', inst_res_1_b}, // 0x88
	CPUInstructionPrefixed{'RES 1, C', inst_res_1_c}, // 0x89
	CPUInstructionPrefixed{'RES 1, D', inst_res_1_d}, // 0x8A
	CPUInstructionPrefixed{'RES 1, E', inst_res_1_e}, // 0x8B
	CPUInstructionPrefixed{'RES 1, H', inst_res_1_h}, // 0x8C
	CPUInstructionPrefixed{'RES 1, L', inst_res_1_l}, // 0x8D
	CPUInstructionPrefixed{'RES 1, HL', inst_res_1_hl}, // 0x8E
	CPUInstructionPrefixed{'RES 1, A', inst_res_1_a}, // 0x8F
	CPUInstructionPrefixed{'RES 2, B', inst_res_2_b}, // 0x90
	CPUInstructionPrefixed{'RES 2, C', inst_res_2_c}, // 0x91
	CPUInstructionPrefixed{'RES 2, D', inst_res_2_d}, // 0x92
	CPUInstructionPrefixed{'RES 2, E', inst_res_2_e}, // 0x53
	CPUInstructionPrefixed{'RES 2, H', inst_res_2_h}, // 0x94
	CPUInstructionPrefixed{'RES 2, L', inst_res_2_l}, // 0x95
	CPUInstructionPrefixed{'RES 2, HL', inst_res_2_hl}, // 0x56
	CPUInstructionPrefixed{'RES 2, A', inst_res_2_a}, // 0x97
	CPUInstructionPrefixed{'RES 3, B', inst_res_3_b}, // 0x98
	CPUInstructionPrefixed{'RES 3, C', inst_res_3_c}, // 0x99
	CPUInstructionPrefixed{'RES 3, D', inst_res_3_d}, // 0x9A
	CPUInstructionPrefixed{'RES 3, E', inst_res_3_e}, // 0x9B
	CPUInstructionPrefixed{'RES 3, H', inst_res_3_h}, // 0x9C
	CPUInstructionPrefixed{'RES 3, L', inst_res_3_l}, // 0x9D
	CPUInstructionPrefixed{'RES 3, HL', inst_res_3_hl}, // 0x9E
	CPUInstructionPrefixed{'RES 3, A', inst_res_3_a}, // 0x9F
	CPUInstructionPrefixed{'RES 4, B', inst_res_4_b}, // 0xA0
	CPUInstructionPrefixed{'RES 4, C', inst_res_4_c}, // 0xA1
	CPUInstructionPrefixed{'RES 4, D', inst_res_4_d}, // 0xA2
	CPUInstructionPrefixed{'RES 4, E', inst_res_4_e}, // 0xA3
	CPUInstructionPrefixed{'RES 4, H', inst_res_4_h}, // 0xA4
	CPUInstructionPrefixed{'RES 4, L', inst_res_4_l}, // 0xA5
	CPUInstructionPrefixed{'RES 4, HL', inst_res_4_hl}, // 0xA6
	CPUInstructionPrefixed{'RES 4, A', inst_res_4_a}, // 0xA7
	CPUInstructionPrefixed{'RES 5, B', inst_res_5_b}, // 0xA8
	CPUInstructionPrefixed{'RES 5, C', inst_res_5_c}, // 0xA9
	CPUInstructionPrefixed{'RES 5, D', inst_res_5_d}, // 0xAA
	CPUInstructionPrefixed{'RES 5, E', inst_res_5_e}, // 0xAB
	CPUInstructionPrefixed{'RES 5, H', inst_res_5_h}, // 0xAC
	CPUInstructionPrefixed{'RES 5, L', inst_res_5_l}, // 0xAD
	CPUInstructionPrefixed{'RES 5, HL', inst_res_5_hl}, // 0xAE
	CPUInstructionPrefixed{'RES 5, A', inst_res_5_a}, // 0xAF
	CPUInstructionPrefixed{'RES 6, B', inst_res_6_b}, // 0xB0
	CPUInstructionPrefixed{'RES 6, C', inst_res_6_c}, // 0xB1
	CPUInstructionPrefixed{'RES 6, D', inst_res_6_d}, // 0xB2
	CPUInstructionPrefixed{'RES 6, E', inst_res_6_e}, // 0xB3
	CPUInstructionPrefixed{'RES 6, H', inst_res_6_h}, // 0xB4
	CPUInstructionPrefixed{'RES 6, L', inst_res_6_l}, // 0xB5
	CPUInstructionPrefixed{'RES 6, HL', inst_res_6_hl}, // 0xB6
	CPUInstructionPrefixed{'RES 6, A', inst_res_6_a}, // 0xB7
	CPUInstructionPrefixed{'BIT 7, B', inst_res_7_b}, // 0xB8
	CPUInstructionPrefixed{'RES 7, C', inst_res_7_c}, // 0xB9
	CPUInstructionPrefixed{'RES 7, D', inst_res_7_d}, // 0xBA
	CPUInstructionPrefixed{'RES 7, E', inst_res_7_e}, // 0xBB
	CPUInstructionPrefixed{'RES 7, H', inst_res_7_h}, // 0xBC
	CPUInstructionPrefixed{'RES 7, L', inst_res_7_l}, // 0xBD
	CPUInstructionPrefixed{'RES 7, HL', inst_res_7_hl}, // 0xBE
	CPUInstructionPrefixed{'RES 7, A', inst_res_7_a}, // 0xBF
	CPUInstructionPrefixed{'SET 0, B', inst_set_0_b}, // 0xC0
	CPUInstructionPrefixed{'SET 0, C', inst_set_0_c}, // 0xC1
	CPUInstructionPrefixed{'SET 0, D', inst_set_0_d}, // 0xC2
	CPUInstructionPrefixed{'SET 0, E', inst_set_0_e}, // 0xC3
	CPUInstructionPrefixed{'SET 0, H', inst_set_0_h}, // 0xC4
	CPUInstructionPrefixed{'SET 0, L', inst_set_0_l}, // 0xC5
	CPUInstructionPrefixed{'SET 0, HL', inst_set_0_hl}, // 0xC6
	CPUInstructionPrefixed{'SET 0, A', inst_set_0_a}, // 0xC7
	CPUInstructionPrefixed{'SET 1, B', inst_set_1_b}, // 0xC8
	CPUInstructionPrefixed{'SET 1, C', inst_set_1_c}, // 0xC9
	CPUInstructionPrefixed{'SET 1, D', inst_set_1_d}, // 0xCA
	CPUInstructionPrefixed{'SET 1, E', inst_set_1_e}, // 0xCB
	CPUInstructionPrefixed{'SET 1, H', inst_set_1_h}, // 0xCC
	CPUInstructionPrefixed{'SET 1, L', inst_set_1_l}, // 0xCD
	CPUInstructionPrefixed{'SET 1, HL', inst_set_1_hl}, // 0xCE
	CPUInstructionPrefixed{'SET 1, A', inst_set_1_a}, // 0xCF
	CPUInstructionPrefixed{'SET 2, B', inst_set_2_b}, // 0xD0
	CPUInstructionPrefixed{'SET 2, C', inst_set_2_c}, // 0xD1
	CPUInstructionPrefixed{'SET 2, D', inst_set_2_d}, // 0xD2
	CPUInstructionPrefixed{'SET 2, E', inst_set_2_e}, // 0x53
	CPUInstructionPrefixed{'SET 2, H', inst_set_2_h}, // 0xD4
	CPUInstructionPrefixed{'SET 2, L', inst_set_2_l}, // 0xD5
	CPUInstructionPrefixed{'SET 2, HL', inst_set_2_hl}, // 0x56
	CPUInstructionPrefixed{'SET 2, A', inst_set_2_a}, // 0xD7
	CPUInstructionPrefixed{'SET 3, B', inst_set_3_b}, // 0xD8
	CPUInstructionPrefixed{'SET 3, C', inst_set_3_c}, // 0xD9
	CPUInstructionPrefixed{'SET 3, D', inst_set_3_d}, // 0xDA
	CPUInstructionPrefixed{'SET 3, E', inst_set_3_e}, // 0xDB
	CPUInstructionPrefixed{'SET 3, H', inst_set_3_h}, // 0xDC
	CPUInstructionPrefixed{'SET 3, L', inst_set_3_l}, // 0xDD
	CPUInstructionPrefixed{'SET 3, HL', inst_set_3_hl}, // 0xDE
	CPUInstructionPrefixed{'SET 3, A', inst_set_3_a}, // 0xDF
	CPUInstructionPrefixed{'SET 4, B', inst_set_4_b}, // 0xE0
	CPUInstructionPrefixed{'SET 4, C', inst_set_4_c}, // 0xE1
	CPUInstructionPrefixed{'SET 4, D', inst_set_4_d}, // 0xE2
	CPUInstructionPrefixed{'SET 4, E', inst_set_4_e}, // 0xE3
	CPUInstructionPrefixed{'SET 4, H', inst_set_4_h}, // 0xE4
	CPUInstructionPrefixed{'SET 4, L', inst_set_4_l}, // 0xE5
	CPUInstructionPrefixed{'SET 4, HL', inst_set_4_hl}, // 0xE6
	CPUInstructionPrefixed{'SET 4, A', inst_set_4_a}, // 0xE7
	CPUInstructionPrefixed{'SET 5, B', inst_set_5_b}, // 0xE8
	CPUInstructionPrefixed{'SET 5, C', inst_set_5_c}, // 0xE9
	CPUInstructionPrefixed{'SET 5, D', inst_set_5_d}, // 0xEA
	CPUInstructionPrefixed{'SET 5, E', inst_set_5_e}, // 0xEB
	CPUInstructionPrefixed{'SET 5, H', inst_set_5_h}, // 0xEC
	CPUInstructionPrefixed{'SET 5, L', inst_set_5_l}, // 0xED
	CPUInstructionPrefixed{'SET 5, HL', inst_set_5_hl}, // 0xEE
	CPUInstructionPrefixed{'SET 5, A', inst_set_5_a}, // 0xEF
	CPUInstructionPrefixed{'SET 6, B', inst_set_6_b}, // 0xF0
	CPUInstructionPrefixed{'SET 6, C', inst_set_6_c}, // 0xF1
	CPUInstructionPrefixed{'SET 6, D', inst_set_6_d}, // 0xF2
	CPUInstructionPrefixed{'SET 6, E', inst_set_6_e}, // 0xF3
	CPUInstructionPrefixed{'SET 6, H', inst_set_6_h}, // 0xF4
	CPUInstructionPrefixed{'SET 6, L', inst_set_6_l}, // 0xF5
	CPUInstructionPrefixed{'SET 6, HL', inst_set_6_hl}, // 0xF6
	CPUInstructionPrefixed{'SET 6, A', inst_set_6_a}, // 0xF7
	CPUInstructionPrefixed{'BIT 7, B', inst_set_7_b}, // 0xF8
	CPUInstructionPrefixed{'SET 7, C', inst_set_7_c}, // 0xF9
	CPUInstructionPrefixed{'SET 7, D', inst_set_7_d}, // 0xFA
	CPUInstructionPrefixed{'SET 7, E', inst_set_7_e}, // 0xFB
	CPUInstructionPrefixed{'SET 7, H', inst_set_7_h}, // 0xFC
	CPUInstructionPrefixed{'SET 7, L', inst_set_7_l}, // 0xFD
	CPUInstructionPrefixed{'SET 7, HL', inst_set_7_hl}, // 0xFE
	CPUInstructionPrefixed{'SET 7, A', inst_set_7_a}, // 0xFF
]

@[direct_array_access]
fn inst_prefixed(op u8) CPUInstruction {
	return insts_prefixed[op]
}
