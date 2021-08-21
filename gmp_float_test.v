import gmp

fn test_init() {
	a := gmp.f_new()
	assert a.str_base_digits(10, 17) == '0'
}

fn test_str() {
	a := gmp.f_from_u64(0)
	assert a.str_base_digits(10, 0) == '0'
	b := gmp.f_from_f64(4530.2927)
	assert b.str_digits(15) == '4530.2927'
	assert b.str_digits(5) == '4530.3'
	c := gmp.f_from_i64(-450000)
	assert c.str_digits(10) == '-450000'
	assert c.str() == '-4.5e5'
}