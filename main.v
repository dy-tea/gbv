module main

import gg

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
	mbus := MemoryBus.new()
	mut app := &App{
		cpu: CPU{
			mbus: mbus
			timer: Timer{
				r: unsafe { &TimerRegisters(mbus.memory + 0xff04) }
			}
		}
		data: cart_load('./tetris.gb')!
	}

	app.gg = gg.new_context(
		bg_color: gg.rgb(0, 0, 0)
		width: 600
		height: 400
		window_title: 'GBV'
		frame_fn: frame
		user_data: app
	)

	app.cpu.reset()
	app.cpu.timer.reset()

	app.gg.run()
}
