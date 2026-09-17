module main

enum CartType {
	no_mbc
	mbc1
	mbc2
	mbc3
	mbc5
	mbc6
	mbc7
	mmm01
	pocket_camera
	bandai_tama5
	huc3
	huc1
	unused
}

struct CartTypeInfo {
	type              CartType
	has_ram           bool
	has_battery       bool
	has_timer         bool
	has_rumble        bool
	has_accelerometer bool
	readable_name     string
}

// vfmt off
const cart_type_data = [
//              |      type     | ram  | batt | timr | rmbl | accl |                  name                  || hex
// ================================================================================================================
	CartTypeInfo{.no_mbc,        false, false, false, false, false, 'No MBC, ROM Only'}                     // 0x00
	CartTypeInfo{.mbc1,          false, false, false, false, false, 'MBC1'}                                 // 0x01
	CartTypeInfo{.mbc1,          true,  false, false, false, false, 'MBC1 + RAM'}                           // 0x02
	CartTypeInfo{.mbc1,          true,  true,  false, false, false, 'MBC1 + RAM + Battery'}                 // 0x03
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x04
	CartTypeInfo{.mbc2,          false, false, false, false, false, 'MBC2'}                                 // 0x05
	CartTypeInfo{.mbc2,          true,  true,  false, false, false, 'MBC2 + RAM + Battery'}                 // 0x06
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x07
	CartTypeInfo{.no_mbc,        true,  false, false, false, false, 'ROM + RAM'}                            // 0x08
	CartTypeInfo{.no_mbc,        true,  true,  false, false, false, 'ROM + RAM + Battery'}                  // 0x09
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x0A
	CartTypeInfo{.mmm01,         false, false, false, false, false, 'MMM01'}                                // 0x0B
	CartTypeInfo{.mmm01,         true,  false, false, false, false, 'MMM01 + RAM'}                          // 0x0C
	CartTypeInfo{.mmm01,         true,  true,  false, false, false, 'MMM01 + RAM + Battery'}                // 0x0D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x0E
	CartTypeInfo{.mbc3,          false, true,  true,  false, false, 'MBC3 + Timer + Battery'}               // 0x0F
	CartTypeInfo{.mbc3,          true,  true,  true,  false, false, 'MBC3 + RAM + Timer + Battery'}         // 0x10
	CartTypeInfo{.mbc3,          false, false, false, false, false, 'MBC3'}                                 // 0x11
	CartTypeInfo{.mbc3,          true,  false, false, false, false, 'MBC3 + RAM'}                           // 0x12
	CartTypeInfo{.mbc3,          true,  true,  false, false, false, 'MBC3 + RAM + Battery'}                 // 0x13
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x14
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x15
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x16
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x17
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x18
	CartTypeInfo{.mbc5,          false, false, false, false, false, 'MBC5'}                                 // 0x19
	CartTypeInfo{.mbc5,          true,  false, false, false, false, 'MBC5 + RAM'}                           // 0x1A
	CartTypeInfo{.mbc5,          true,  true,  false, false, false, 'MBC5 + RAM + Battery'}                 // 0x1B
	CartTypeInfo{.mbc5,          false, false, false, true,  false, 'MBC5 + Rumble'}                        // 0x1C
	CartTypeInfo{.mbc5,          true,  false, false, true,  false, 'MBC5 + RAM + Rumble'}                  // 0x1D
	CartTypeInfo{.mbc5,          true,  true,  false, true,  false, 'MBC5 + RAM + Battery + Rumble'}        // 0x1E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x1F
	CartTypeInfo{.mbc6,          true,  true,  false, false, false, 'MBC6 + RAM + Battery'}                 // 0x20
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x21
	CartTypeInfo{.mbc7,          true,  true,  false, false, true,  'MBC7 + RAM + Battery + Accelerometer'} // 0x22
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x23
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x24
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x25
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x26
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x27
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x28
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x29
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x2F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x30
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x31
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x32
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x33
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x34
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x35
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x36
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x37
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x38
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x39
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x3F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x40
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x41
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x42
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x43
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x44
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x45
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x46
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x47
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x48
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x49
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x4F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x50
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x51
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x52
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x53
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x54
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x55
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x56
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x57
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x58
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x59
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x5F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x60
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x61
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x62
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x63
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x64
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x65
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x66
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x67
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x68
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x69
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x6F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x70
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x71
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x72
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x73
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x74
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x75
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x76
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x77
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x78
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x79
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x7F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x80
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x81
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x82
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x83
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x84
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x85
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x86
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x87
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x88
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x89
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x8F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x90
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x91
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x92
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x93
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x94
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x95
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x96
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x97
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x98
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x99
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9A
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9B
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9C
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9D
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9E
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0x9F
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xA9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAB
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAC
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAD
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAE
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xAF
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xB9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBB
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBC
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBD
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBE
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xBF
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xC9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCB
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCC
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCD
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCE
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xCF
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xD9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDB
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDC
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDD
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDE
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xDF
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xE9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xEA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xEB
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xEC
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xED
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xEE
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xEF
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF0
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF1
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF2
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF3
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF4
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF5
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF6
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF7
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF8
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xF9
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xFA
	CartTypeInfo{.unused,        false, false, false, false, false, 'Unused'}                               // 0xFB
	CartTypeInfo{.pocket_camera, false, false, false, false, false, 'Pocket Camera'}                        // 0xFC
	CartTypeInfo{.bandai_tama5,  false, false, false, false, false, 'Banda Tama5'}                          // 0xFD
	CartTypeInfo{.huc3,          false, false, false, false, false, 'HuC3'}                                 // 0xFE
	CartTypeInfo{.huc1,          true,  true,  false, false, false, 'HuC1 + RAM + Battery'}                 // 0xFF
]
// vfmt on
