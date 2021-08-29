import gmp

fn test_init() {
	a := gmp.f_new()
	assert a.str_base_digits(10, 17) == '0'
}

fn test_from_str () {
	mut a := gmp.f_from_str('10')
	assert a.str() == '10'
	a = gmp.f_from_str('NaN')
	assert a.str() == '0'
	a = gmp.f_from_str('Inf')
	assert a.str() == '0'
}

fn test_str() {
	a := gmp.f_from_u64(0)
	assert a.str_base_digits(10, 0) == '0'
	b := gmp.f_from_f64(4530.2927)
	assert b.str_digits(15) == '4530.2927'
	assert b.str_digits(5) == '4530.3'
	c := gmp.f_from_i64(-450000)
	assert c.str_digits(10) == '-450000'
	assert c.str() == '-450000'
}

fn test_add () {
	a := gmp.f_from_i64(-12)
	b := gmp.f_from_u64(44)
	assert '${a + b}' == '32'
}

fn test_sub () {
	a := gmp.f_from_i64(-12)
	b := gmp.f_from_u64(44)
	assert '${a - b}' == '-56'
}

fn test_mul () {
	a := gmp.f_from_i64(-12)
	b := gmp.f_from_u64(44)
	assert '${a * b}' == '-528'
}

fn test_div () {
	a := gmp.f_from_i64(-12)
	b := gmp.f_from_u64(44)
	assert '${a / b}' == '-0.272727272727272727273' // best precision of the calculation with ndigits == 0
}

fn test_sqrt () {
	a := gmp.f_from_f64(492.2274)
	b := gmp.f_sqrt(a)
	assert b.str_digits(16) == '22.18619841252665'
	c := gmp.f_sqrt_ui(2)
	assert c.str_digits(20) == '1.4142135623730950488'
}

fn test_pow () {
	a := gmp.f_from_f64(3.45)
	b := gmp.f_pow_u64(a, 7)
	assert b.str_digits(19) == '5817.463478585158347'
}