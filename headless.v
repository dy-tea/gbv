module main

import os

const test_max_instructions = u32(30_000_000)
const test_finish_grace = u32(200_000)

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
	mut mbus := MemoryBus.new()
	mbus.cart_header = cart_header
	mbus.serial_capture = true
	mut cpu := CPU{
		mbus: mbus
	}
	cpu.reset()
	cpu.mbus.timer.reset()

	mut finished := false
	mut out_len := 0
	for cpu.ic < max_inst {
		cpu.tick(data)
		out := mbus.serial_buffer
		if !finished && out.len != out_len {
			out_len = out.len
			if is_final_line(out.bytestr()) {
				finished = true
			}
		}
		if finished && cpu.ic >= max_inst - test_finish_grace {
			break
		}
		finished = finished && out.len == out_len
	}

	report(path, cpu, finished)
}

fn is_final_line(out string) bool {
	lines := out.split_into_lines().filter(|l| l.trim_space() != '')
	if lines.len == 0 {
		return false
	}
	last := lines[lines.len - 1].trim_space()
	return last == 'Passed' || last == 'Done' || last == 'Failed' || last == 'Passed all tests' || last.starts_with('Failed #')
}

fn report(path string, cpu CPU, finished bool) {
	out := cpu.mbus.serial_buffer.bytestr()
	status := if finished { 'DONE' } else { 'TIMEOUT' }

	println('')
	println('${os.file_name(path)} [${status}]')
	if out.len > 0 {
		println(out)
	} else {
		println('(no serial output)')
	}
	println('instructions executed: ${cpu.ic}\n')

	lines := out.split_into_lines().filter(|l| l.trim_space() != '')
	if lines.len == 0 {
		println('RESULT: NO OUTPUT')
	} else {
		last := lines[lines.len - 1].trim_space()
		if last == 'Passed' || last == 'Done' || last == 'Passed all tests' {
			println('RESULT: PASS')
		} else if last == 'Failed' || last.starts_with('Failed #') {
			println('RESULT: FAIL')
		} else {
			println('RESULT: UNKNOWN (${last})')
		}
	}
}