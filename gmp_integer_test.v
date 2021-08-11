// gmp_test.v
import gmp

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
	a = gmp.from_str('8337839423')
	b = gmp.from_str('9683495887')
	assert '${b + a}' == '18021335310'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('9683495887')
	assert '${b + a}' == '1345656464'
	a = gmp.from_str('8337839423')
	b = gmp.from_str('-9683495887')
	assert '${b + a}' == '-1345656464'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('-9683495887')
	assert '${b + a}' == '-18021335310'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('8337839423')
	assert '${b + a}' == '0'
	a = gmp.from_str('8337839423')
	b = gmp.from_str('-8337839423')
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
	a = gmp.from_str('8337839423')
	b = gmp.from_str('9683495887')
	assert '${b - a}' == '1345656464'
	assert '${a - b}' == '-1345656464'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('-9683495887')
	assert '${b - a}' == '-1345656464'
	assert '${a - b}' == '1345656464'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('9683495887')
	assert '${b - a}' == '18021335310'
	assert '${a - b}' == '-18021335310'
	a = gmp.from_str('-8337839423')
	b = gmp.from_str('-8337839423')
	assert '${b - a}' == '0'
	assert '${a - b}' == '0'
	a = gmp.from_str('8337839423')
	b = gmp.from_str('8337839423')
	assert '${b - a}' == '0'
	assert '${a - b}' == '0'
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
	a = gmp.from_str('12345678901234567890')
	b = gmp.from_str('281474976710656')
	assert '${a / b}' == '43860'
	a = gmp.from_str('12345678901234567890')
	gmp.mul_2exp(mut a, a, -48)
	assert '${a}' == '43860'
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
	a = gmp.from_str('12345678901234567890')
	b = gmp.from_str('98765432109876543210')
	assert '${a * b}' == '1219326311370217952237463801111263526900'
	a = gmp.from_str('12345678901234567890')
	b = gmp.from_str('281474976710656')
	assert '${a * b}' == '3474999681202237152443873718435840'
	a = gmp.from_str('12345678901234567890')
	gmp.mul_2exp(mut a, a, 48)
	assert '${a}' == '3474999681202237152443873718435840'
	a = gmp.from_str('12345678901234567890')
	gmp.mul_2exp(mut a, a, 2) // lshift(2)
	b = gmp.from_str('281474976710656')
	gmp.mul_2exp(mut b, b, 4)
	assert '${a * b}' == '222399979596943177756407917979893760'
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
	a := gmp.from_str('987654312345678901234567890')
	b := gmp.from_str('98765432109876543210')

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

fn test_from_str() {
	assert gmp.from_str('9870123').str() == '9870123'
	assert gmp.from_str('').str() == '0'
	assert gmp.from_str('0').str() == '0'
	assert gmp.from_str('1').str() == '1'
	for i := 1; i < 307; i += 61 {
		input := '9'.repeat(i)
		out := gmp.from_str(input).str()
		// eprintln('>> i: $i input: $input.str()')
		// eprintln('>> i: $i   out: $out.str()')
		assert input == out
	}
}

fn test_from_hex_str() {
	// use base 0 to interpret 0x, 0b and 0 for hexa, binary and octal
	assert gmp.from_str_base('0x123', 0).str_base (16) == '123'
	assert gmp.from_str_base('0b110011', 0).str_base (2) == '110011'
	assert gmp.from_str_base('0123', 0).str_base (8) == '123'
	for i in 1 .. 33 {
		input := 'e'.repeat(i)
		out := gmp.from_str_base(input, 16).str_base (16)
		assert input == out
	}
	assert gmp.from_str('0').str_base (16) == '0'
}

fn test_str() {
	assert gmp.from_u64(255).str() == '255'
	assert gmp.from_u64(127).str() == '127'
	assert gmp.from_u64(1024).str() == '1024'
	assert gmp.from_u64(4294967295).str() == '4294967295'
	assert gmp.from_u64(4398046511104).str() == '4398046511104'
	// assert gmp.from_i64(int(4294967295)).str() == '18446744073709551615'
	// assert gmp.from_i64(-1).str() == '18446744073709551615'
	assert gmp.from_str_base('e'.repeat(80), 16).str() == '1993587900192849410235353592424915306962524220866209251950572167300738410728597846688097947807470'
}

fn test_factorial() {
	f5 := gmp.factorial(5)
	assert f5.str_base (16) == '78'
	f100 := gmp.factorial(100)
	assert f100.str_base (16) == '1b30964ec395dc24069528d54bbda40d16e966ef9a70eb21b5b2943a321cdf10391745570cca9420c6ecb3b72ed2ee8b02ea2735c61a000000000000000000000000'
}

// fn trimbytes(n int, x []byte) []byte {
// 	mut res := x.clone()
// 	res.trim(n)
// 	return res
// }

// fn test_bytes() {
// 	assert gmp.from_i64(0).bytes().len == 128
// 	assert gmp.from_hex_string('e'.repeat(100)).bytes().len == 128
// 	assert trimbytes(3, gmp.from_i64(1).bytes()) == [byte(0x01), 0x00, 0x00]
// 	assert trimbytes(3, gmp.from_i64(1024).bytes()) == [byte(0x00), 0x04, 0x00]
// 	assert trimbytes(3, gmp.from_i64(1048576).bytes()) == [byte(0x00), 0x00, 0x10]
// }

// fn test_bytes_trimmed() {
// 	assert gmp.from_i64(0).bytes_trimmed().len == 0
// 	assert gmp.from_hex_string('AB'.repeat(50)).bytes_trimmed().len == 50
// 	assert gmp.from_i64(1).bytes_trimmed() == [byte(0x01)]
// 	assert gmp.from_i64(1024).bytes_trimmed() == [byte(0x00), 0x04]
// 	assert gmp.from_i64(1048576).bytes_trimmed() == [byte(0x00), 0x00, 0x10]
// }