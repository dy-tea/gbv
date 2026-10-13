module main

const joypad_register_address = 0xff00
const joypad_register_reset = 0xcf

struct Joypad {
mut:
	mbus &MemoryBus
	// Buttons
	a      bool
	b      bool
	select bool
	start  bool
	right  bool
	left   bool
	up     bool
	down   bool
}

fn Joypad.new(mbus &MemoryBus) &Joypad {
	return &Joypad{
		mbus: mbus
	}
}

fn (mut j Joypad) reset() {
	j.a = false
	j.b = false
	j.select = false
	j.start = false
	j.right = false
	j.left = false
	j.up = false
	j.down = false
	unsafe { j.mbus.memory[joypad_register_address] = joypad_register_reset }
}

fn (mut j Joypad) read_input() u8 {
	mut register := unsafe { u8(j.mbus.memory[joypad_register_address]) }
	register |= 0b11000000
	register &= 0xf0
	action_buttons := check_bit(register, 5)
	direction_buttons := check_bit(register, 4)
	if action_buttons && direction_buttons {
		register |= 0x0f
	} else if !action_buttons {
		register = change_bit(register, u8(!j.start), 3)
		register = change_bit(register, u8(!j.select), 2)
		register = change_bit(register, u8(!j.b), 1)
		register = change_bit(register, u8(!j.a), 0)
	} else if !direction_buttons {
		register = change_bit(register, u8(!j.down), 3)
		register = change_bit(register, u8(!j.up), 2)
		register = change_bit(register, u8(!j.left), 1)
		register = change_bit(register, u8(!j.right), 0)
	}
	unsafe { j.mbus.memory[joypad_register_address] = register }
	return register
}

fn (mut j Joypad) write_input(flags u8) {
	mut register := unsafe { u8(j.mbus.memory[joypad_register_address]) }
	action_buttons := check_bit(flags, 5)
	direction_buttons := check_bit(flags, 4)
	register = change_bit(register, u8(action_buttons), 5)
	register = change_bit(register, u8(direction_buttons), 4)
	unsafe { j.mbus.memory[joypad_register_address] = register }
}

fn (mut j Joypad) button_check(button bool, pressed bool, flag bool) bool {
	if button != pressed {
		if !flag && button && !pressed {
			j.mbus.interrupt_raise_flag(.joypad)
		}
		return pressed
	}
	return button
}

fn (mut j Joypad) on_action_button(button bool, pressed bool) bool {
	action_buttons_flag := check_bit(unsafe { j.mbus.memory[joypad_register_address] }, 5)
	return j.button_check(button, pressed, action_buttons_flag)
}

fn (mut j Joypad) on_direction_button(button bool, pressed bool) bool {
	direction_buttons_flag := check_bit(unsafe { j.mbus.memory[joypad_register_address] }, 4)
	return j.button_check(button, pressed, direction_buttons_flag)
}

fn (mut j Joypad) on_button_a(pressed bool) {
	j.a = j.on_action_button(j.a, pressed)
}

fn (mut j Joypad) on_button_b(pressed bool) {
	j.b = j.on_action_button(j.b, pressed)
}

fn (mut j Joypad) on_button_select(pressed bool) {
	j.select = j.on_action_button(j.select, pressed)
}

fn (mut j Joypad) on_button_start(pressed bool) {
	j.start = j.on_action_button(j.start, pressed)
}

fn (mut j Joypad) on_button_right(pressed bool) {
	j.right = j.on_direction_button(j.right, pressed)
}

fn (mut j Joypad) on_button_left(pressed bool) {
	j.left = j.on_direction_button(j.left, pressed)
}

fn (mut j Joypad) on_button_up(pressed bool) {
	j.up = j.on_direction_button(j.up, pressed)
}

fn (mut j Joypad) on_button_down(pressed bool) {
	j.down = j.on_direction_button(j.down, pressed)
}
