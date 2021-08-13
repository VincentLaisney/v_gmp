// not used _test.v in the name to avoid crashes during general testing
module gmp

fn test_div_zero () {
	a := gmp.from_f64(541.3)
	assert '$a' == '541'
	b := gmp.new()
	assert '$b' == '0'
	c := a / b
	assert '$c' == '0'
}

