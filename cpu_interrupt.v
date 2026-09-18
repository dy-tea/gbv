module main

fn (mut cpu CPU) interrupt_jump_to(addr u16) {
	cpu.advance_clocks(4)
	pchi := cpu.r.pc.hi()
	pclo := cpu.r.pc.lo()
	cpu.r.sp--
	cpu.advance_clocks(4)
	cpu.mbus.write(cpu.r.sp, pchi)
	cpu.r.sp--
	cpu.advance_clocks(4)
	cpu.mbus.write(cpu.r.sp, pclo)
	cpu.advance_clocks(4)
	cpu.r.pc = addr
	cpu.advance_clocks(4)
	cpu.interrupt_data.master_enable = false
}

fn (mut cpu CPU) interrupt_service_routine() {
	interrupt_enable := unsafe { cpu.mbus.memory[addr_io_ie] }
	interrupt_flag := unsafe { cpu.mbus.memory[addr_io_if] }
	interrupt_pending := (interrupt_enable & interrupt_flag) & 0x1F != 0

	if interrupt_pending {
		if cpu.halt_type == .halt {
			if !cpu.interrupt_data.master_enable {
				cpu.advance_clocks(4)
			}
			cpu.halt_type = .none
		}

		if !cpu.interrupt_data.master_enable {
			return
		}

		enable_vblank := check_bit(interrupt_enable, 0)
		enable_lcd_stat := check_bit(interrupt_enable, 1)
		enable_timer := check_bit(interrupt_enable, 2)
		enable_serial := check_bit(interrupt_enable, 3)
		enable_joypad := check_bit(interrupt_enable, 4)

		flag_vblank := check_bit(interrupt_flag, 0)
		flag_lcd_stat := check_bit(interrupt_flag, 1)
		flag_timer := check_bit(interrupt_flag, 2)
		flag_serial := check_bit(interrupt_flag, 3)
		flag_joypad := check_bit(interrupt_flag, 4)

		if enable_vblank && flag_vblank {
			cpu.mbus.interrupt_flag_write(clear_bit(unsafe { cpu.mbus.memory[addr_io_if] }, 0))
			cpu.interrupt_jump_to(interrupt_handler_vblank)
		} else if enable_lcd_stat && flag_lcd_stat {
			cpu.mbus.interrupt_flag_write(clear_bit(unsafe { cpu.mbus.memory[addr_io_if] }, 1))
			cpu.interrupt_jump_to(interrupt_handler_lcd_stat)
		} else if enable_timer && flag_timer {
			cpu.mbus.interrupt_flag_write(clear_bit(unsafe { cpu.mbus.memory[addr_io_if] }, 2))
			cpu.interrupt_jump_to(interrupt_handler_timer)
		} else if enable_serial && flag_serial {
			cpu.mbus.interrupt_flag_write(clear_bit(unsafe { cpu.mbus.memory[addr_io_if] }, 3))
			cpu.interrupt_jump_to(interrupt_handler_serial)
		} else if enable_joypad && flag_joypad {
			cpu.mbus.interrupt_flag_write(clear_bit(unsafe { cpu.mbus.memory[addr_io_if] }, 4))
			cpu.interrupt_jump_to(interrupt_handler_joypad)
		}
	}
}
