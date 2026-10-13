module main

import os

const test_max_instructions = u32(30_000_000)
const test_finish_grace = u32(200_000)
const test_max_ticks = u32(500_000_000)

fn run_cpu_tests(path string, max_inst u32) {
	max := if max_inst > 0 { max_inst } else { test_max_instructions }
	if os.is_dir(path) {
		for rom in os.ls(path) or { [] } {
			if os.file_ext(rom) == '.gb' {
				run_one(os.join_path(path, rom), max)
			}
		}
	} else {
		run_one(path, max)
	}
}

fn run_one(path string, max_inst u32) {
	data, cart_header := cart_load(path) or {
		eprintln('failed to load ${path}: ${err}')
		return
	}
	mut gb := GB.new(data, cart_header)
	gb.mbus.serial_capture = true
	gb.reset()

	mut finished := false
	mut out_len := 0
	mut eram_init_seen := false
	mut eram_result := -1
	mut ticks := u32(0)

	for gb.cpu.ic < max_inst && ticks < test_max_ticks {
		gb.cpu.tick()
		ticks++

		out := gb.mbus.serial_buffer
		if !finished && out.len != out_len {
			out_len = out.len
			if is_final_line(out.bytestr()) {
				finished = true
			}
		}
		if finished && gb.cpu.ic >= max_inst - test_finish_grace {
			break
		}
		finished = finished && out.len == out_len

		if !finished {
			eram0 := unsafe { gb.mbus.eram[0] }
			if eram0 == 0x80 {
				eram_init_seen = true
			} else if eram_init_seen && eram0 != 0x80 {
				eram_result = int(eram0)
				break
			}
		}
	}

	report(path, gb.cpu, gb.mbus, ticks, finished, eram_result)
}

fn capture_eram_output(mbus &MemoryBus) string {
	mut text := ''
	for offset in u16(0) .. 256 {
		c := mbus.read(0xA004 + offset)
		if c == 0 {
			break
		}
		text += rune(c).str()
	}
	return text
}

fn is_final_line(out string) bool {
	lines := out.split_into_lines().filter(|l| l.trim_space() != '')

	if lines.len == 0 {
		return false
	}

	last := lines[lines.len - 1].trim_space()

	return last == 'Passed' || last == 'Done' || last == 'Failed' || last == 'Passed all tests' || last.starts_with('Failed #')
}

fn report(path string, cpu CPU, mbus &MemoryBus, ticks u32, finished bool, eram_result int) {
	out := mbus.serial_buffer.bytestr()
	eram_text := if out.len == 0 {
		capture_eram_output(mbus)
	} else {
		''
	}

	status := if finished || eram_result >= 0 { 'DONE' } else { 'TIMEOUT' }
	println('')
	println('${os.file_name(path)} [${status}]')
	if out.len > 0 {
		println(out)
	} else if eram_text.len > 0 {
		println(eram_text)
	} else {
		println('(no serial output)')
	}
	println('instructions executed: ${cpu.ic}')
	println('cpu ticks: ${ticks}\n')

	lines := out.split_into_lines().filter(|l| l.trim_space() != '')
	if lines.len > 0 {
		last := lines[lines.len - 1].trim_space()
		if last == 'Passed' || last == 'Done' || last == 'Passed all tests' {
			println('RESULT: PASS')
		} else if last == 'Failed' || last.starts_with('Failed #') {
			println('RESULT: FAIL')
		} else {
			println('RESULT: UNKNOWN (${last})')
		}
		return
	}

	if eram_result >= 0 {
		if eram_result == 0 {
			println('RESULT: PASS')
		} else {
			println('RESULT: FAIL')
		}
	} else {
		println('RESULT: NO OUTPUT')
	}
}
