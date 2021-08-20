// gmp_test.v
import gmp
import os

fn test_new_big() {
	n := gmp.new()
	assert n.str_base (16) == '0'
}

fn test_from_i64() {
	assert gmp.from_i64(255).str_base (16) == 'ff'
	assert gmp.from_i64(127).str_base (16) == '7f'
	assert gmp.from_i64(1024).str_base (16) == '400'
	assert gmp.from_i64(2147483647).str_base (16) == '7fffffff'
	assert gmp.from_i64(-1).str_base (16) == '-1'
}

fn test_from_u64() {
	assert gmp.from_u64(255).str_base (16) == 'ff'
	assert gmp.from_u64(127).str_base (16) == '7f'
	assert gmp.from_u64(1024).str_base (16) == '400'
	assert gmp.from_u64(4294967295).str_base (16) == 'ffffffff'
	assert gmp.from_u64(4398046511104).str_base (16) == '40000000000'
	assert gmp.from_u64(-1).str_base (16) == 'ffffffffffffffff'
}

fn test_from_str() {
	mut a := gmp.from_str('9870123') or {panic('Invalid number')}
	assert a.str() == '9870123'
	a = gmp.from_str('0') or {panic('Invalid number')}
	assert a.str() == '0'
	a = gmp.from_str('1') or {panic('Invalid number')}
	assert a.str() == '1'
	for i := 1; i < 307; i += 61 {
		input := '9'.repeat(i)
		out := gmp.from_str(input) or {panic('Invalid number')}
		out_str := out.str()
		// eprintln('>> i: $i input: $input.str()')
		// eprintln('>> i: $i   out: $out.str()')
		assert input == out_str
	}
}

fn test_invalid_str() ? {
	if x := gmp.from_str('str') {
		println(x.str())
		assert false
	} else {
		assert true
	}
	if x := gmp.from_str('') {
		println(x.str())
		assert false
	} else {
		assert true
	}
	if x := gmp.from_str('NaN') {
		println(x.str())
		assert false
	} else {
		assert true
	}
	if x := gmp.from_str_base('1498', 8) { // illegal character
		println(x.str())
		assert false
	} else {
		assert true
	}
	if x := gmp.from_str_base('49bed82g', 16) { // id
		println(x.str())
		assert false
	} else {
		assert true
	}
}

fn test_from_hex_str() {
	// use base 0 to interpret 0x, 0b and 0 for hexa, binary and octal
	mut a := gmp.from_str_base('0x123', 0) or {panic('Invalid number')}
	assert a.str_base (16) == '123'
	a = gmp.from_str_base('0b110011', 0) or {panic('Invalid number')}
	assert a.str_base (2) == '110011'
	a = gmp.from_str_base('0123', 0) or {panic('Invalid number')}
	assert a.str_base (8) == '123'
	for i in 1 .. 33 {
		input := 'e'.repeat(i)
		out := gmp.from_str_base(input, 16) or {panic('Invalid number')}
		out_str := out.str_base (16)
		assert input == out_str
	}
	a = gmp.from_str('0') or {panic('Invalid number')}
	assert a.str_base (16) == '0'
}

fn test_str() {
	assert gmp.from_u64(255).str() == '255'
	assert gmp.from_u64(127).str() == '127'
	assert gmp.from_u64(1024).str() == '1024'
	assert gmp.from_u64(4294967295).str() == '4294967295'
	assert gmp.from_u64(4398046511104).str() == '4398046511104'
	// assert gmp.from_i64(int(4294967295)).str() == '18446744073709551615'
	// assert gmp.from_i64(-1).str() == '18446744073709551615'
	a := gmp.from_str_base('e'.repeat(80), 16) or {panic('Invalid number')}
	assert a.str() == '1993587900192849410235353592424915306962524220866209251950572167300738410728597846688097947807470'
}

fn test_plus() {
	mut a := gmp.from_u64(2)
	mut b := gmp.from_u64(3)
	c := a + b
	assert c.str_base (16) == '5'
	assert (gmp.from_u64(1024) + gmp.from_u64(1024)).str_base (16) == '800'
	a += b
	assert a.str_base (16) == '5'
	a.inc()
	assert a.str_base (16) == '6'
	a.dec()
	a.dec()
	assert a.str_base (16) == '4'
	a = gmp.from_str('8337839423') or {panic('Invalid number')}
	b = gmp.from_str('9683495887') or {panic('Invalid number')}
	assert '${b + a}' == '18021335310'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('9683495887') or {panic('Invalid number')}
	assert '${b + a}' == '1345656464'
	a = gmp.from_str('8337839423') or {panic('Invalid number')}
	b = gmp.from_str('-9683495887') or {panic('Invalid number')}
	assert '${b + a}' == '-1345656464'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('-9683495887') or {panic('Invalid number')}
	assert '${b + a}' == '-18021335310'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('8337839423') or {panic('Invalid number')}
	assert '${b + a}' == '0'
	a = gmp.from_str('8337839423') or {panic('Invalid number')}
	b = gmp.from_str('-8337839423') or {panic('Invalid number')}
	assert '${b + a}' == '0'
}

fn test_minus() {
	mut a := gmp.from_u64(2)
	mut b := gmp.from_u64(3)
	c := b - a
	assert c.str_base (16) == '1'
	e := gmp.from_u64(1024)
	ee := e - e
	assert ee.str_base (16) == '0'
	b -= a
	assert b.str_base (16) == '1'
	a = gmp.from_str('8337839423') or {panic('Invalid number')}
	b = gmp.from_str('9683495887') or {panic('Invalid number')}
	assert '${b - a}' == '1345656464'
	assert '${a - b}' == '-1345656464'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('-9683495887') or {panic('Invalid number')}
	assert '${b - a}' == '-1345656464'
	assert '${a - b}' == '1345656464'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('9683495887') or {panic('Invalid number')}
	assert '${b - a}' == '18021335310'
	assert '${a - b}' == '-18021335310'
	a = gmp.from_str('-8337839423') or {panic('Invalid number')}
	b = gmp.from_str('-8337839423') or {panic('Invalid number')}
	assert '${b - a}' == '0'
	assert '${a - b}' == '0'
	a = gmp.from_str('8337839423') or {panic('Invalid number')}
	b = gmp.from_str('8337839423') or {panic('Invalid number')}
	assert '${b - a}' == '0'
	assert '${a - b}' == '0'
}

fn test_neg () {
	mut a := gmp.from_u64(3847)
	a = gmp.neg(a)
	assert '$a' == '-3847'
	a = gmp.from_i64(-951305)
	a = gmp.neg(a)
	assert '$a' == '951305'
}

fn test_cmp () {
	a := gmp.from_str('4758') or {panic('Invalid number')}
	b := gmp.from_str('3948') or {panic('Invalid number')}
	c := gmp.from_i64(4758)
	assert gmp.cmp(a, b) > 0
	assert gmp.cmp(b, c) < 0
	assert gmp.cmp(a, c) == 0
}

fn test_multiply() {
	mut a := gmp.from_u64(2)
	mut b := gmp.from_u64(3)
	c := b * a
	assert c.str_base (16) == '6'
	e := gmp.from_u64(1024)
	e2 := e * e
	e4 := e2 * e2
	e8 := e2 * e2 * e2 * e2
	e9 := e8 + gmp.from_u64(1)
	d := ((e9 * e9) + b) * c
	assert e4.str_base (16) == '10000000000'
	assert e8.str_base (16) == '100000000000000000000'
	assert e9.str_base (16) == '100000000000000000001'
	assert d.str_base (16) == '60000000000000000000c00000000000000000018'
	a *= b
	assert a.str_base (16) == '6'
	a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	b = gmp.from_str('98765432109876543210') or {panic('Invalid number')}
	assert '${a * b}' == '1219326311370217952237463801111263526900'
	a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	b = gmp.from_str('281474976710656') or {panic('Invalid number')}
	assert '${a * b}' == '3474999681202237152443873718435840'
	// a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	// gmp.mul_2exp(mut a, a, 48)
	// assert '${a}' == '3474999681202237152443873718435840'
	// a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	// gmp.mul_2exp(mut a, a, 2) // lshift(2)
	// b = gmp.from_str('281474976710656') or {panic('Invalid number')}
	// gmp.mul_2exp(mut b, b, 4)
	// assert '${a * b}' == '222399979596943177756407917979893760'
}

fn test_divide() {
	mut a := gmp.from_u64(2)
	mut b := gmp.from_u64(3)
	c := b / a
	assert c.str_base (16) == '1'
	assert (b % a).str_base (16) == '1'
	e := gmp.from_u64(1024) // dec(1024) == hex(0x400)
	ee := e / e
	assert ee.str_base (16) == '1'
	assert (e / a).str_base (16) == '200'
	assert (e / (a * a)).str_base (16) == '100'
	b /= a
	assert b.str_base (16) == '1'
	a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	b = gmp.from_str('281474976710656') or {panic('Invalid number')}
	assert '${a / b}' == '43860'
	a = gmp.from_str('12345678901234567890') or {panic('Invalid number')}
	// gmp.mul_2exp(mut b, a, -48) // mul_2exp accept only unsigned shift
	// assert '${a}' == '43860'
}

fn test_div_zero () {
	vexe := os.getenv('VEXE')
	test_file := 'tests/gmp_div_zero_test.v'
	test := os.execute('$vexe $test_file')
	assert test.exit_code == 1
	// print(test.output)
	test.output.contains('V panic: Division by zero')
}

fn test_mod() {
	assert ((gmp.from_u64(13) % gmp.from_u64(10)).i64()) == 3
	assert ((gmp.from_u64(13) % gmp.from_u64(9)).i64()) == 4
	assert ((gmp.from_u64(7) % gmp.from_u64(5)).i64()) == 2
}

fn test_divmod() {
	x, y := gmp.divmod(gmp.from_u64(13), gmp.from_u64(10))
	assert x.i64() == 1
	assert y.i64() == 3
	p, q := gmp.divmod(gmp.from_u64(13), gmp.from_u64(9))
	assert p.i64() == 1
	assert q.i64() == 4
	c, d := gmp.divmod(gmp.from_u64(7), gmp.from_u64(5))
	assert c.i64() == 1
	assert d.i64() == 2
}

fn test_divide_mod_big() {
	a := gmp.from_str('987654312345678901234567890') or {panic('Invalid number')}
	b := gmp.from_str('98765432109876543210') or {panic('Invalid number')}

	assert '${a / b}' == '9999999'
	assert '${a % b}' == '90012345579011111100'
}

fn test_divide_mod() {
	divide_mod_inner(0, -3)
	divide_mod_inner(22, 3)
	divide_mod_inner(22, -3)
	divide_mod_inner(-22, 3)
	divide_mod_inner(-22, -3)
	divide_mod_inner(1, -3)
	divide_mod_inner(-1, 3)
	divide_mod_inner(-1, -3)
	divide_mod_inner(1 << 8, 1 << 8)
	divide_mod_inner(-1 << 8, 1 << 4)
}

fn divide_mod_inner(a int, b int) {
	a_big := gmp.from_i64(a)
	b_big := gmp.from_i64(b)

	assert '${a_big / b_big}' == '${a / b}'
	assert '${a_big % b_big}' == '${a % b}'
}


fn test_power () {
	mut a := gmp.from_u64(5)
	a = a.power(6)
	assert '$a' == '15625'
	
	a = gmp.from_i64(-43)
	a = a.power(5)
	assert '$a' == '-147008443'
}

fn test_ceil_div() {

	mut a := gmp.from_i64(495943893)
	mut b := gmp.from_i64(594837)
	mut c := gmp.cdiv_q(a, b)
	assert '${c}' == '834'
	a = gmp.from_i64(-938206328)
	b = gmp.from_i64(85943)
	c = gmp.cdiv_q(a, b)
	assert '${c}' == '-10916'
}

fn test_floor_div() {
	mut a := gmp.from_i64(495943893)
	mut b := gmp.from_i64(594837)
	mut c := gmp.fdiv_q(a, b)
	assert '${c}' == '833'
	a = gmp.from_i64(-938206328)
	b = gmp.from_i64(85943)
	c = gmp.fdiv_q(a, b)
	assert '${c}' == '-10917'
}
fn test_trunc_div() {
	mut a := gmp.from_i64(495943893)
	mut b := gmp.from_i64(594837)
	mut c := gmp.new()
	c = a / b // is mpz_tdiv_q
	assert '${c}' == '833'
	a = gmp.from_i64(-938206328)
	b = gmp.from_i64(85943)
	c = a / b // is mpz_tdiv_q
	assert '${c}' == '-10916'
}

fn test_sqrt() {
	a := gmp.from_str('9384755736203914') or {panic('Invalid number')}
	b := gmp.isqrt(a)
	assert '${b}' == '96874948'
}

fn test_sqrtrem() {
	a := gmp.from_str('9384755736203914') or {panic('Invalid number')}
	b, r := gmp.sqrt_rem(a)
	assert '${b} ${r}' == '96874948 186201210'

}

fn test_factorial() {
	f5 := gmp.factorial(5)
	assert f5.str_base (16) == '78'
	f100 := gmp.factorial(100)
	assert f100.str_base (16) == '1b30964ec395dc24069528d54bbda40d16e966ef9a70eb21b5b2943a321cdf10391745570cca9420c6ecb3b72ed2ee8b02ea2735c61a000000000000000000000000'
}

fn test_double_factorial()   {
	ff5 := gmp.double_factorial(94)
	assert ff5.str() == '36397985440595212848901395509362442575593829776487243652121231360000000000'
	ff10 := gmp.double_factorial(10)
	assert ff10.str() == '3840'
	assert '${gmp.double_factorial(134)}' == '5382185993533606831408011282180680789400284994444766970938526050778069191357422369838651827831177216000000000000000'
}

fn test_multifactorial() {
	r := gmp.multi_factorial(25, 4)
	assert '${r}' == '5221125'
	s := gmp.multi_factorial(120, 7)
	assert '${s}' == '133216545928064507382988800000'

}

fn test_fibonacci() {
	r := gmp.fibonacci(12) 
	assert '$r' == '144'
	s := gmp.fibonacci(131) 
	assert '$s' == '1066340417491710595814572169'
}

fn test_primorial() {
	p := gmp.primorial(147)
	assert '${p}' == '10014646650599190067509233131649940057366334653200433090'
}

fn test_lucas_num() {
	l := gmp.lucas_num(45)
	assert '${l}' == '2537720636'
}

fn test_lucas_num2() {
	l, m := gmp.lucas_num2(27)
	assert '${l} ${m}' == '439204 271443'
	n, o := gmp.lucas_num2(72)
	assert '${n} ${o}' == '1114577054219522 688846502588399'
}

fn test_export_import() {
	n := gmp.from_str('4773753683898985936405984512709') or {panic('export')}
	bits := gmp.sizeinbase(n, 2)
	// from mpz manual
	size := sizeof(byte) // 1
	numb := 8*size // - nail
	count := int((bits + numb-1) / numb)
	// p = malloc (count * size)
	buf := &[]byte{len:count}
	res_count := u64(0)
	res := gmp.export(buf.data, &res_count, 1, size, 0, 0, n)
	unsafe { assert res == buf.data }
	assert res_count == count
	// println(buf)
	// for i in buf {
	// 	print('0x${i.hex_full()}, ')
	// }
	// print('\n')

	m := gmp.mpz_import(res_count, 1, size, 0, 0, buf.data)
	assert gmp.cmp(m, n) == 0
	m_str := m.str()
	assert m_str == '4773753683898985936405984512709'
}