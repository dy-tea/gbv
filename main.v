module main

import gg
import os

struct App {
mut:
	gg gg.Context
	gb &GB
}

fn frame(mut app App) {
	app.gg.begin()
	app.gb.run_until_vblank()
	present(&app.gg, app.gb.ppu)
	app.gg.end()
}

fn on_key_down(key gg.KeyCode, _modifier gg.Modifier, data voidptr) {
	on_key(key, true, data)
}

fn on_key_up(key gg.KeyCode, _modifier gg.Modifier, data voidptr) {
	on_key(key, false, data)
}

fn on_key(key gg.KeyCode, pressed bool, data voidptr) {
	mut app := &App(data)
	mut joypad := app.gb.joypad
	match key {
		.a { joypad.on_button_a(pressed) }
		.s { joypad.on_button_b(pressed) }
		.enter { joypad.on_button_start(pressed) }
		.space { joypad.on_button_select(pressed) }
		.right { joypad.on_button_right(pressed) }
		.left { joypad.on_button_left(pressed) }
		.up { joypad.on_button_up(pressed) }
		.down { joypad.on_button_down(pressed) }
		else {}
	}
}

fn main() {
	if os.args.len >= 3 && os.args[1] == 'test' {
		mut max_inst := u32(0)
		if os.args.len >= 4 {
			max_inst = os.args[3].u32()
		}
		run_cpu_tests(os.args[2], max_inst)
		return
	}

	if os.args.len != 2 {
		println('Please pass rom file')
		return
	}
	data, cart_header := cart_load(os.args[1])!
	mut app := &App{
		gb: GB.new(data, cart_header)
	}

	app.gg = gg.new_context(
		bg_color:     ppu_lcd_color_lit
		width:        lcd_pixels_width * ppu_render_scale
		height:       lcd_pixels_height * ppu_render_scale
		window_title: 'GBV'
		frame_fn:     frame
		keydown_fn:   on_key_down
		keyup_fn:     on_key_up
		user_data:    app
	)

	app.gb.reset()

	app.gg.run()
}
