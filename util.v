module main

@[inline]
fn check_bit[T](number T, bit usize) bool {
	return (number >> bit) & 1 != 0
}

@[inline]
fn clear_bit[T](number T, bit usize) T {
	return number & ~(1 << bit)
}

@[inline]
fn change_bit[T](number T, value T, bit usize) T {
	return number ^ ((-value ^ number) & (1 << bit))
}
