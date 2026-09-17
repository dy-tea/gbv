module main

import gg
import os

struct App {
	data []u8
mut:
	gg  gg.Context
	cpu CPU
}

fn frame(mut app App) {
	app.gg.begin()

	app.cpu.tick(app.data)

	app.gg.end()
}

fn main() {
	if os.args.len != 2 {
		println('Please pass rom file')
		return
	}
	data, cart_header := cart_load(os.args[1])!
	mut mbus := MemoryBus.new()
	mbus.cart_header = cart_header
	mut app := &App{
		cpu:  CPU{
			mbus: mbus
		}
		data: data
	}

	app.gg = gg.new_context(
		bg_color:     gg.rgb(0, 0, 0)
		width:        600
		height:       400
		window_title: 'GBV'
		frame_fn:     frame
		user_data:    app
	)

	app.cpu.reset()
	app.cpu.mbus.timer.reset()

	app.gg.run()
}
