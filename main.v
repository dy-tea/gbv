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

	app.cpu.fetch(app.data)
	app.cpu.execute(app.data)

	app.gg.end()
}

fn main() {
	mut app := &App{
		cpu: CPU{}
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
	app.gg.run()
}
