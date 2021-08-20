import gmp

fn test_init() {
	a := gmp.f_new()
	assert a.str_base_digits(10, 17) == ''
}

fn test_str() {
	a := gmp.f_from_u64(0)
	assert a.str_base_digits(10, 0) == ''
	b := gmp.f_from_u64(45302927)
	assert b.str() == '45302927'
	assert b.str_digits(5) == '45303'
}