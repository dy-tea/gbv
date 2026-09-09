module main

const addr_io_if = 0xff0f // interrupt flag
const addr_io_ie = 0xffff // interrupt enable

@[noinit]
struct MemoryBus {
mut:
	memory &u8
}

fn MemoryBus.new() MemoryBus {
	unsafe {
		return MemoryBus{
			memory: C.malloc(1024 * 64 * 8)
		}
	}
}

fn (mb MemoryBus) read(data []u8, addr u16) u8 {
	return data[addr]
}

fn (mut mb MemoryBus) write(data []u8, addr u16, val u8) {
	println('TODO: implement memory_bus_write')
}
