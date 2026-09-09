module main

const timer_tac_edge_bits = [u16(9), 3, 5, 7]

@[packed]
struct TimerRegisters {
mut:
	div  u8
	tima u8
	tma  u8
	tac  u8
}

enum TimerHaltType {
	none
	halt
	stop
}

struct Timer {
mut:
	r               &TimerRegisters
	sysclk          u16 = 0xabcc // after bootrom
	interrupt_delay u8
	halt_type       TimerHaltType = .none
}

fn (mut t Timer) reset() {
	t.sysclk = 0xabcc
	t.r.div = 0xab
	t.r.tima = 0
	t.r.tma = 0
	t.r.tac = 0
}

fn (mut t Timer) check_clock_edges(prev_sysclk u16) {
	div_prev := t.r.div
	div_bit_4_prev := check_bit(t.r.div, 4)

	t.r.div = u8(t.sysclk >> 8)

	div_bit_4_now := check_bit(t.r.div, 4)
	if div_bit_4_prev && !div_bit_4_now {
		// TODO: tick APU counter
	}

	tac_timer_enable := check_bit(t.r.tac, 2)
	if !tac_timer_enable {
		return
	}

	tac_clock_select := t.r.tac & 0b00000011
	tac_divider_bit := timer_tac_edge_bits[tac_clock_select]
	prev_edge := check_bit(prev_sysclk, tac_divider_bit)
	curr_edge := check_bit(t.sysclk, tac_divider_bit)
	if prev_edge && !curr_edge {
		t.tick_tima()
	}
}

fn (mut t Timer) increase_div(cycles u8) {
	for c in 0 .. cycles {
		prev_sysclk := t.sysclk
		t.sysclk++
		t.check_clock_edges(prev_sysclk)
	}
}

fn (mut t Timer) advance_clocks(mut cpu CPU, cycles u8) {
	if t.interrupt_delay > 0 {
		for c in 0 .. cycles {
			t.interrupt_delay--
			if t.interrupt_delay == 0 {
				cpu.interrupt_raise_flag(interrupt_flag_timer)
				break
			}
		}
	}
	if t.halt_type == .stop {
		return
	}
	t.increase_div(cycles)
}

fn (mut t Timer) on_div_write(_value u8) {
	prev_sysclk := t.sysclk
	t.sysclk = 0
	t.check_clock_edges(prev_sysclk)
}

fn (mut t Timer) tick_tima() {
	if t.r.tima < 255 {
		t.r.tima++
	} else {
		t.r.tima = t.r.tma
		t.interrupt_delay = 4
	}
}
