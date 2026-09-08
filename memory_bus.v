module main

fn memory_bus_read(data []u8, addr u16) u8 {
	return data[addr]
}

fn memory_bus_write(data []u8, addr u16, val u8) {
	println('TODO: implement memory_bus_write')
}
