module main

struct GB {
mut:
	mbus   &MemoryBus
	ppu    &PPU
	joypad &Joypad
	cpu    &CPU
}

const max_clocks_per_frame = u32(2_000_000)
const clocks_per_frame_when_blank = u32(70_224)

fn GB.new(data []u8, header CartHeader) &GB {
	mut mbus := MemoryBus.new(data, header)
	ppu := PPU.new(mbus)
	joypad := Joypad.new(mbus)
	cpu := CPU.new(mbus)
	mbus.ppu = ppu
	mbus.joypad = joypad
	return &GB{
		mbus:   mbus
		ppu:    ppu
		joypad: joypad
		cpu:    cpu
	}
}

fn (mut gb GB) reset() {
	gb.cpu.reset()
	gb.mbus.timer.reset()
	gb.ppu.reset()
	gb.joypad.reset()
}

fn (mut gb GB) run_until_vblank() {
	budget := if gb.ppu.r.lcdc_enable_lcd() {
		max_clocks_per_frame
	} else {
		clocks_per_frame_when_blank
	}

	clocks := gb.cpu.clocks
	for !gb.ppu.frame_ready && gb.cpu.clocks - clocks < budget {
		gb.cpu.tick()
	}
	gb.ppu.frame_ready = false
}
