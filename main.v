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

	app.cpu.tick()

	app.gg.end()
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
	mut mbus := MemoryBus.new(data)
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
