module main

import os

const header_offset = 0x100
const max_cart_size = 1024 * 1024

@[packed]
struct CartHeader {
	entry_point             [4]u8
	nintendo_logo           [48]u8
	title                   [15]u8
	cgb_flag                u8
	new_licensee_code       [2]u8
	sgb_flag                u8
	cartridge_type          u8
	rom_size                u8
	ram_size                u8
	destination_code        u8
	old_license_code        u8
	mask_rom_version_number u8
	header_checksum         u8
	global_checksum_hi      u8
	global_checksum_lo      u8
}

fn (c CartHeader) str() string {
	title := c.title.map(|h| rune(h)).string()
	entry_point := c.entry_point.map(|c| c.hex()).join('')

	return 'Entry point: 0x${entry_point}
Title: ${title}
CGB Flag: 0x${c.cgb_flag:x}
New Licensee code: 0x${c.new_licensee_code[0]:x}${c.new_licensee_code[1]:x}
SGB Flag: 0x${c.sgb_flag:x}
Type: 0x${c.cartridge_type:x}
ROM Size: 0x${c.rom_size:x}
RAM Size: 0x${c.ram_size:x}
Destination code: 0x${c.destination_code:x}
Old License code: 0x${c.old_license_code:x}
Mask ROM Version Number: 0x${c.mask_rom_version_number:x}
Header Checksum: 0x${c.header_checksum:x}
Global Checksum: 0x${c.global_checksum_hi:x}${c.global_checksum_lo:x}'
}

fn cart_load(path string) !([]u8, CartHeader) {
	mut f := os.open(path)!
	cart_data := f.read_bytes(max_cart_size)
	f.seek(0, .start)!
	header := f.read_raw_at[CartHeader](header_offset)!
	println(header)
	return cart_data, header
}
