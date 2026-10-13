module main

import gg

const ppu_lcd_color_lit = gg.rgb(223, 230, 179)

const ppu_gb_colors = [
	gg.rgb(185, 200, 90)
	gg.rgb(131, 145, 0)
	gg.rgb(74, 82, 4)
	gg.rgb(40, 44, 4),
]!

fn present(ctx &gg.Context, p &PPU) {
	if !p.r.lcdc_enable_lcd() || p.first_frame_after_lcd_enable {
		return
	}

	for y in 0 .. lcd_pixels_height {
		for x in 0 .. lcd_pixels_width {
			index := y * lcd_pixels_width + x
			color := ppu_gb_colors[p.frame_pixels[index]]
			ctx.draw_pixel(f32(x * ppu_render_scale), f32(y * ppu_render_scale), color,
				size: f32(ppu_render_scale)
			)
		}
	}
}
