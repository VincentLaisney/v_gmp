module gmp
// MIT License

// Copyright (c) 2021 Vincent Laisney

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// Porting of gmp multiprecision library to the V programming language (vlang)
// Module for [V (Vlang)](https://vlang.io/) with most of the bindings of 
// [gmp](https://gmplib.org/) for the BigIntegers. Functions beginning in mpz_

#flag -lgmp
#flag -I @VMODROOT
#include "gmp.h"

// typedef struct
// {
//   C. int _mp_alloc;		/* Number of *limbs* allocated and pointed
// 				   to by the _mp_d field.  */
//   C. int _mp_size;			/* abs(_mp_size) is the number of limbs the
// 				   last field points to.  If _mp_size is
// 				   negative this is a negative number.  */
//   mp_limb_t *_mp_d;		/* Pointer to the limbs.  */
// } __mpz_struct;

// typedef __mpz_struct mpz_t[1];
type Mp_limb_t = u64

struct C.__mpz_struct {
mut:
   	_mp_alloc u16		/* Number of *limbs* allocated and pointed
				   to by the _mp_d field.  */
   	_mp_size u16			/* abs(_mp_size) is the number of limbs the
				   last field points to.  If _mp_size is
				   negative this is a negative number.  */
   	_mp_d voidptr		/* Pointer to the limbs.  */
}
// type C.mpz_t = [1]C.__mpz_struct

type Bigint = C.__mpz_struct

fn C.mp_set_memory_functions (fn (u64) voidptr,
				      fn (voidptr, u64, u64) voidptr,
				      fn (voidptr, u64) voidptr)

fn my_realloc (ptr &byte, old_size u64, new_size u64) &byte {
	unsafe { return v_realloc (ptr, int(new_size)) }
}

fn my_free (ptr &byte, size u64) {
	unsafe{ free (ptr) }
}

fn init() {
	C.mp_set_memory_functions(malloc, my_realloc, my_free)
}

[unsafe]
fn (mut b Bigint) free() {
	clear(mut b)
}

// type Bigint = &C.bigint_struct

// #define _mpz_realloc __gmpz_realloc
// #define mpz_realloc __gmpz_realloc
// C.*_mpz_realloc (Bigint, mp_size_t)

/**************** Random number routines.  ****************/

/* Random state struct.  */
struct C.__gmp_randstate_struct
{
//   mpz_t _mp_seed;	  /* _mp_d member points to state of the generator. */
//   gmp_randalg_t _mp_alg;  /* Currently unused. */
//   union {
//     void *_mp_lc;         /* Pointer to function pointers structure.  */
//   } _mp_algdata;
} 
pub type Randstate = C.__gmp_randstate_struct 

[unsafe]
fn (mut b Randstate) free() {
	randclear(mut b)
}

/* obsolete */
// #define gmp_randinit __gmp_randinit
// fn C.gmp_randinit (gmp_randstate_t, gmp_randalg_t, ...)

// pub fn gmp_randinit (gmp_randstate_t, gmp_randalg_t, ...) {}

// #define gmp_randinit_default __gmp_randinit_default
fn C.gmp_randinit_default (&Randstate)

/// randinit_default is binding to gmp_randinit_default
pub fn randinit_default (mut s Randstate) {
	C.gmp_randinit_default (&s)
}

// #define gmp_randinit_lc_2exp __gmp_randinit_lc_2exp
fn C.gmp_randinit_lc_2exp (&Randstate, &Bigint, u64, u64)

/// randinit_lc_2exp is binding to gmp_randinit_lc_2exp
pub fn randinit_lc_2exp (mut s Randstate, a Bigint, c u64, m u64) {
	C.gmp_randinit_lc_2exp (&s, &a, c, m)
}

// #define gmp_randinit_lc_2exp_size __gmp_randinit_lc_2exp_size
fn C.gmp_randinit_lc_2exp_size (&Randstate, u64) int 

//// randinit_lc_2exp_size is binding to gmp_randinit_lc_2exp_size
pub fn randinit_lc_2exp_size (mut s Randstate, n u64) int  {
	return C.gmp_randinit_lc_2exp_size (&s, n)
}

// #define gmp_randinit_mt __gmp_randinit_mt
fn C.gmp_randinit_mt (&Randstate)

//// randinit_mt is binding to gmp_randinit_mt
pub fn randinit_mt (mut s Randstate) {
	C.gmp_randinit_mt (&s)
}

// #define gmp_randinit_set __gmp_randinit_set
fn C.gmp_randinit_set (&Randstate, &Randstate)

//// randinit_set is binding to gmp_randinit_set
pub fn randinit_set (mut d Randstate, s Randstate) {
	C.gmp_randinit_set (&d, &s)
}

// #define gmp_randseed __gmp_randseed
fn C.gmp_randseed (&Randstate, &Bigint)

//// randseed is binding to gmp_randseed
pub fn randseed (mut s Randstate, b Bigint) {
	C.gmp_randseed (&s, &b)
}

// #define gmp_randseed_ui __gmp_randseed_ui
fn C.gmp_randseed_ui (&Randstate, u64)

//// randseed_ui is binding to gmp_randseed_ui
pub fn randseed_ui (mut s Randstate, n u64) {
	C.gmp_randseed_ui (&s, n)
}

// #define gmp_randclear __gmp_randclear
fn C.gmp_randclear (&Randstate)

//// randclear is binding to gmp_randclear
pub fn randclear (mut s Randstate) {
	C.gmp_randclear (&s)
}

// #define gmp_urandomb_ui __gmp_urandomb_ui
fn C.gmp_urandomb_ui (&Randstate, u64) u64

//// urandomb_ui is binding to gmp_urandomb_ui
pub fn urandomb_ui (mut s Randstate, n u64) u64 {
	return C.gmp_urandomb_ui (&s, n)
}

// #define gmp_urandomm_ui __gmp_urandomm_ui
fn C.gmp_urandomm_ui (&Randstate, u64) u64

//// urandomm_ui is binding to gmp_urandomm_ui
pub fn urandomm_ui (mut s Randstate, n u64) u64 {
	return C.gmp_urandomm_ui (&s, n)
}

//  *** Integer Routines MPZ ***

fn C.mpz_abs(d &Bigint, s &Bigint)

//// abs is binding to mpz_abs
pub fn abs(d &Bigint, s &Bigint) {}

// #define mpz_add __gmpz_add
fn C.mpz_add (d &Bigint, a &Bigint, b &Bigint)

//// + is binding to mpz_add
pub fn (a Bigint) + (b Bigint) Bigint {
	mut d := new()
	C.mpz_add (&d, &a, &b)
	return d
}

[inline]
pub fn (mut a Bigint) inc () {
	b := a + from_u64(1)
	set(mut a, b)
}

[inline]
pub fn (mut a Bigint) dec () {
	b := a - from_u64(1)
	set(mut a, b)
}

// #define mpz_add_ui __gmpz_add_ui
fn C.mpz_add_ui (&Bigint, &Bigint, u64)

//// add_u64 is binding to mpz_add_ui
pub fn add_u64 (a Bigint, b u64) Bigint {
	d := new()
	C.mpz_add_ui (&d, &a, b)
	return d
}

// #define mpz_addmul __gmpz_addmul
fn C.mpz_addmul (&Bigint, &Bigint, &Bigint)

//// addmul is binding to mpz_addmul
pub fn addmul (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_addmul (&d, &a, &b)
	return d
}

// #define mpz_addmul_ui __gmpz_addmul_ui
fn C.mpz_addmul_ui (&Bigint, &Bigint, u64)

/// addmul_u64 is binding to mpz_addmul_ui
pub fn addmul_u64 (a Bigint, b u64) Bigint {
	d := new()
	C.mpz_addmul_ui (&d, &a, b)
	return d
}

// #define mpz_and __gmpz_and
fn C.mpz_and (d &Bigint, a &Bigint, b &Bigint)

/// and is binding to mpz_and
pub fn and (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_and (&d, &a, &b)
	return d
}

// #define mpz_array_init __gmpz_array_init
// Obsolete function don't use
// fn C.mpz_array_init (&Bigint, mp_size_t, mp_size_t)

// pub fn array_init (Bigint, mp_size_t, mp_size_t) {
	
// }

// #define mpz_bin_ui __gmpz_bin_ui
fn C.mpz_bin_ui (&Bigint, &Bigint, u64)

/// bin_u64 is binding to mpz_bin_ui
pub fn bin_u64 (n Bigint, k u64) Bigint {
	d := new()
	C.mpz_bin_ui (&d, &n, k)
	return d
}

// #define mpz_bin_uiui __gmpz_bin_uiui
fn C.mpz_bin_uiui (&Bigint, u64, u64)

/// bin_uiui is binding to mpz_bin_uiui
pub fn bin_uiui (n u64, k u64) Bigint {
	d := new()
	C.mpz_bin_uiui (&d, n, k)
	return d
}

// #define mpz_cdiv_q __gmpz_cdiv_q
fn C.mpz_cdiv_q (&Bigint, &Bigint, &Bigint)

/// cdiv_q is binding to mpz_cdiv_q
pub fn cdiv_q (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_cdiv_q (&d, &a, &b)
	return d
}

// #define mpz_cdiv_q_2exp __gmpz_cdiv_q_2exp
fn C.mpz_cdiv_q_2exp (&Bigint, &Bigint, u64)

/// cdiv_q_2exp is binding to mpz_cdiv_q_2exp
pub fn cdiv_q_2exp (a Bigint, e u64) Bigint {
	q := new()
	C.mpz_cdiv_q_2exp (&q, &a, e)
	return q
}

// #define mpz_cdiv_q_ui __gmpz_cdiv_q_ui
fn C.mpz_cdiv_q_ui (&Bigint, &Bigint, u64) u64

/// cdiv_q_u64 is binding to mpz_cdiv_q_ui
pub fn cdiv_q_u64 (a Bigint, b u64) (Bigint, u64) {
	q := new()
	res := C.mpz_cdiv_q_ui (&q, &a, b)
	return q, res
}

// #define mpz_cdiv_qr __gmpz_cdiv_qr
fn C.mpz_cdiv_qr (&Bigint, &Bigint, &Bigint, &Bigint)

/// cdiv_qr is binding to mpz_cdiv_qr
pub fn cdiv_qr (n Bigint, d Bigint) (Bigint, Bigint) {
	r := new()
	q := new()
	C.mpz_cdiv_qr (&q, &r, &n, &d)
	return q, r
}

// #define mpz_cdiv_qr_ui __gmpz_cdiv_qr_ui
fn C.mpz_cdiv_qr_ui (&Bigint, &Bigint, &Bigint, u64) u64

/// cdiv_qr_u64 is binding to mpz_cdiv_qr_ui
pub fn cdiv_qr_u64 (mut r Bigint, n Bigint, d u64) (Bigint, u64) {
	q := new()
	res := C.mpz_cdiv_qr_ui (&q, &r, &n, d)
	return q, res
}

// #define mpz_cdiv_r __gmpz_cdiv_r
fn C.mpz_cdiv_r (&Bigint, &Bigint, &Bigint)

/// cdiv_r is binding to mpz_cdiv_r
pub fn cdiv_r (n Bigint, d Bigint) Bigint {
	r := new()
	C.mpz_cdiv_r (&r, &n, &d)
	return r
}

// #define mpz_cdiv_r_2exp __gmpz_cdiv_r_2exp
fn C.mpz_cdiv_r_2exp (&Bigint, &Bigint, u64)

/// cdiv_r_2exp is binding to mpz_cdiv_r_2exp
pub fn cdiv_r_2exp (n Bigint, e u64) Bigint {
	r := new()
	C.mpz_cdiv_r_2exp (&r, &n, e)
	return r
}

// #define mpz_cdiv_r_ui __gmpz_cdiv_r_ui
fn C.mpz_cdiv_r_ui (&Bigint, &Bigint, u64) u64

/// cdiv_r_u64 is binding to mpz_cdiv_r_ui
pub fn cdiv_r_u64 (n Bigint, d u64) (Bigint, u64) {
	r := new()
	res := C.mpz_cdiv_r_ui (&r, &n, d)
	return r, res
}

// #define mpz_cdiv_ui __gmpz_cdiv_ui
fn C.mpz_cdiv_ui (&Bigint, u64) u64

/// cdiv_u64 is binding to mpz_cdiv_ui
pub fn cdiv_u64 (n Bigint, d u64) u64 {
	return C.mpz_cdiv_ui (&n, d)
}

// #define mpz_clear __gmpz_clear
fn C.mpz_clear (&Bigint)

/// clear is binding to mpz_clear
pub fn clear (mut a Bigint) {
	C.mpz_clear (&a)
}

// #define mpz_clears __gmpz_clears
// C.clears (Bigint, ...)

// #define mpz_clrbit __gmpz_clrbit
fn C.mpz_clrbit (&Bigint, u64)

/// clrbit is binding to mpz_clrbit
pub fn clrbit (mut a Bigint, b u64) {
	C.mpz_clrbit (&a, b)
}

// #define mpz_cmp __gmpz_cmp
fn C.mpz_cmp (a &Bigint, b &Bigint) int 

/// cmp is binding to mpz_cmp
pub fn cmp (a Bigint, b Bigint) int  {
	return C.mpz_cmp (&a, &b)
}

pub fn (a Bigint) == (b Bigint) bool {
	return C.mpz_cmp (&a, &b) == 0
}

pub fn (a Bigint) < (b Bigint) bool {
	return C.mpz_cmp (&a, &b) < 0
}

// #define mpz_cmp_d __gmpz_cmp_d
fn C.mpz_cmp_d (&Bigint, f64) int

/// cmp_f64 is binding to mpz_cmp_d
pub fn cmp_f64 (a Bigint, b f64) int {
	return C.mpz_cmp_d (&a, b)
}

// #define _mpz_cmp_si __gmpz_cmp_si
fn C.mpz_cmp_si (&Bigint, i64) int

/// cmp_i64 is binding to mpz_cmp_si
pub fn cmp_i64 (a Bigint, b i64) int {
	return C.mpz_cmp_si (&a, b)
}

// #define _mpz_cmp_ui __gmpz_cmp_ui
fn C.mpz_cmp_ui (&Bigint, u64) int

/// cmp_u64 is binding to mpz_cmp_ui
pub fn cmp_u64 (a Bigint, b u64) int {
	return C.mpz_cmp_ui (&a, b)
}

// #define mpz_cmpabs __gmpz_cmpabs
fn C.mpz_cmpabs (&Bigint, &Bigint) int

/// cmpabs is binding to mpz_cmpabs
pub fn cmpabs (a Bigint, b Bigint) int {
	return C.mpz_cmpabs (&a, &b)
}

// #define mpz_cmpabs_d __gmpz_cmpabs_d
fn C.mpz_cmpabs_d (&Bigint, f64) int

/// cmpabs_f64 is binding to mpz_cmpabs_d
pub fn cmpabs_f64 (a Bigint, b f64) int {
	return C.mpz_cmpabs_d (&a, b)
}

// #define mpz_cmpabs_ui __gmpz_cmpabs_ui
fn C.mpz_cmpabs_ui (&Bigint, u64) int

/// cmpabs_u64 is binding to mpz_cmpabs_ui
pub fn cmpabs_u64 (a Bigint, b u64) int {
	return C.mpz_cmpabs_ui (&a, b)
}

// #define mpz_com __gmpz_com
fn C.mpz_com (&Bigint, &Bigint)

/// com is binding to mpz_com
pub fn com (a Bigint) Bigint {
	r := new()
	C.mpz_com (&r, &a)
	return r
}

// #define mpz_combit __gmpz_combit
fn C.mpz_combit (&Bigint, u64)

/// combit is binding to mpz_combit
pub fn combit (mut r Bigint, b u64) {
	C.mpz_combit (&r, b)
}

// #define mpz_congruent_p __gmpz_congruent_p
fn C.mpz_congruent_p (&Bigint, &Bigint, &Bigint) int

/// congruent_p is binding to mpz_congruent_p
pub fn congruent_p (n Bigint, c Bigint, d Bigint) int {
	return C.mpz_congruent_p (&n, &c, &d)
}

// #define mpz_congruent_2exp_p __gmpz_congruent_2exp_p
fn C.mpz_congruent_2exp_p (&Bigint, &Bigint, u64) int

/// congruent_2exp_p is binding to mpz_congruent_2exp_p
pub fn congruent_2exp_p (n Bigint, c Bigint, b u64) int {
	return C.mpz_congruent_2exp_p (&n, &c, b)
}

// #define mpz_congruent_ui_p __gmpz_congruent_ui_p
fn C.mpz_congruent_ui_p (&Bigint, u64, u64) int

/// congruent_ui_p is binding to mpz_congruent_ui_p
pub fn congruent_ui_p (n Bigint, c u64, d u64) int {
	return C.mpz_congruent_ui_p (&n, c, d)
}

// #define mpz_divexact __gmpz_divexact
fn C.mpz_divexact (&Bigint, &Bigint, &Bigint)

/// divexact is binding to mpz_divexact
pub fn divexact (q Bigint, n Bigint, d Bigint) {
	C.mpz_divexact (&q, &n, &d)
}

// #define mpz_divexact_ui __gmpz_divexact_ui
fn C.mpz_divexact_ui (&Bigint, &Bigint, u64)

/// divexact_u64 is binding to mpz_divexact_ui
pub fn divexact_u64 (q Bigint, n Bigint, d u64) {
	C.mpz_divexact_ui (&q, &n, d)
}

// #define mpz_divisible_p __gmpz_divisible_p
fn C.mpz_divisible_p (&Bigint, &Bigint) int

/// divisible_p is binding to mpz_divisible_p
pub fn divisible_p (n Bigint, q Bigint) int {
	return C.mpz_divisible_p (&n, &q)
}

// #define mpz_divisible_ui_p __gmpz_divisible_ui_p
fn C.mpz_divisible_ui_p (&Bigint, u64) int

/// divisible_ui_p is binding to mpz_divisible_ui_p
pub fn divisible_ui_p (n Bigint, q u64) int {
	return C.mpz_divisible_ui_p (&n, &q)
}

// #define mpz_divisible_2exp_p __gmpz_divisible_2exp_p
fn C.mpz_divisible_2exp_p (&Bigint, u64) int

/// divisible_2exp_p is binding to mpz_divisible_2exp_p
pub fn divisible_2exp_p (n Bigint, b u64) int {
	return C.mpz_divisible_2exp_p (&n, b)
}

// #define mpz_dump __gmpz_dump
// fn C.dump (Bigint) void

// #define mpz_export __gmpz_export
// fn C.mpz_export (void *, size_t *, int, size_t, int, size_t, Bigint)

// #define mpz_fac_ui __gmpz_fac_ui
fn C.mpz_fac_ui (&Bigint, u64)

/// factorial is binding to mpz_fac_ui
pub fn factorial (n u64) Bigint {
	f := new()
	C.mpz_fac_ui (&f, n)
	return f
}

// #define mpz_2fac_ui __gmpz_2fac_ui
fn C.mpz_2fac_ui (&Bigint, u64)

/// double_factorial is binding to mpz_2fac_ui
pub fn double_factorial (n u64) Bigint {
	r := new()
	C.mpz_2fac_ui (&r, n)
	return r
}

// #define mpz_mfac_uiui __gmpz_mfac_uiui
fn C.mpz_mfac_uiui (&Bigint, u64, u64)

/// multi_factorial is binding to mpz_mfac_uiui
pub fn multi_factorial (n u64, m u64) Bigint {
	r := new()
	C.mpz_mfac_uiui (&r, n, m)
	return r
}

// #define mpz_primorial_ui __gmpz_primorial_ui
fn C.mpz_primorial_ui (&Bigint, u64)

/// primorial is binding to mpz_primorial_ui
pub fn primorial (n u64) Bigint {
	r := new()
	C.mpz_primorial_ui (&r, n)
	return r
}

// #define mpz_fdiv_q __gmpz_fdiv_q
fn C.mpz_fdiv_q (&Bigint, &Bigint, &Bigint)

/// fdiv_q is binding to mpz_fdiv_q
pub fn fdiv_q (n Bigint, d Bigint) Bigint {
	q := new()
	C.mpz_fdiv_q (&q, &n, &d)
	return q
}

// #define mpz_fdiv_q_2exp __gmpz_fdiv_q_2exp
fn C.mpz_fdiv_q_2exp (&Bigint, &Bigint, u64)

/// fdiv_q_2exp is binding to mpz_fdiv_q_2exp
pub fn fdiv_q_2exp (n Bigint, b u64) Bigint {
	q := new()
	C.mpz_fdiv_q_2exp (&q, &n, b)
	return q
}

// #define mpz_fdiv_q_ui __gmpz_fdiv_q_ui
fn C.mpz_fdiv_q_ui (&Bigint, &Bigint, u64) u64

/// fdiv_q_u64 is binding to mpz_fdiv_q_ui
pub fn fdiv_q_u64 (n Bigint, d u64) (Bigint, u64) {
	q := new()
	res := C.mpz_fdiv_q_ui (&q, &n, d)
	return q, res
}

// #define mpz_fdiv_qr __gmpz_fdiv_qr
fn C.mpz_fdiv_qr (&Bigint, &Bigint, &Bigint, &Bigint)

/// fdiv_qr is binding to mpz_fdiv_qr
pub fn fdiv_qr (n Bigint, d Bigint) (Bigint, Bigint) {
	r := new()
	q := new()
	C.mpz_fdiv_qr (&q, &r, &n, &d)
	return q, r
}

// #define mpz_fdiv_qr_ui __gmpz_fdiv_qr_ui
fn C.mpz_fdiv_qr_ui (&Bigint, &Bigint, &Bigint, u64) u64

/// fdiv_qr_u64 is binding to mpz_fdiv_qr_ui
pub fn fdiv_qr_u64 (mut r Bigint, n Bigint, d u64) (Bigint, u64) {
	q := new()
	res := C.mpz_fdiv_qr_ui (&q, &r, &n, d)
	return q, res
}

// #define mpz_fdiv_r __gmpz_fdiv_r
fn C.mpz_fdiv_r (&Bigint, &Bigint, &Bigint)

/// fdiv_r is binding to mpz_fdiv_r
pub fn fdiv_r (n Bigint, d Bigint) Bigint {
	r := new()
	C.mpz_fdiv_r (&r, &n, &d)
	return r
}

// #define mpz_fdiv_r_2exp __gmpz_fdiv_r_2exp
fn C.mpz_fdiv_r_2exp (&Bigint, &Bigint, u64)

/// fdiv_r_2exp is binding to mpz_fdiv_r_2exp
pub fn fdiv_r_2exp (n Bigint, b u64) Bigint {
	r := new()
	C.mpz_fdiv_r_2exp (&r, &n, b)
	return r
}

// #define mpz_fdiv_r_ui __gmpz_fdiv_r_ui
fn C.mpz_fdiv_r_ui (&Bigint, &Bigint, u64) u64

/// fdiv_r_u64 is binding to mpz_fdiv_r_ui
pub fn fdiv_r_u64 (n Bigint, d u64) (Bigint, u64) {
	r := new()
	res := C.mpz_fdiv_r_ui (&r, &n, d)
	return r, res
}

// #define mpz_fdiv_ui __gmpz_fdiv_ui
fn C.mpz_fdiv_ui (&Bigint, u64) u64

/// fdiv_u64 is binding to mpz_fdiv_ui
pub fn fdiv_u64 (n Bigint, d u64) u64 {
	return C.mpz_fdiv_ui (&n, d)
}

// #define mpz_fib_ui __gmpz_fib_ui
fn C.mpz_fib_ui (&Bigint, u64)

/// fibonacci is binding to mpz_fib_ui
pub fn fibonacci (n u64) Bigint {
	f := new()
	C.mpz_fib_ui (&f, n)
	return f
}

// #define mpz_fib2_ui __gmpz_fib2_ui
fn C.mpz_fib2_ui (&Bigint, &Bigint, u64)

/// fib2_u64 is binding to mpz_fib2_ui
pub fn fibonacci2 (n u64) (Bigint, Bigint) {
	fnsub1 := new()
	f := new()
	C.mpz_fib2_ui (&f, &fnsub1, n)
	return f, fnsub1
}

// #define mpz_fits_sint_p __gmpz_fits_sint_p
fn C.mpz_fits_sint_p (&Bigint) int

/// fits_sint_p is binding to mpz_fits_sint_p
pub fn fits_sint_p (n Bigint) int {
	return C.mpz_fits_sint_p (&n)
}

// #define mpz_fits_slong_p __gmpz_fits_slong_p
fn C.mpz_fits_slong_p (&Bigint) int

/// fits_slong_p is binding to mpz_fits_slong_p
pub fn fits_slong_p (n Bigint) int {
	return C.mpz_fits_slong_p (&n)
}

// #define mpz_fits_sshort_p __gmpz_fits_sshort_p
fn C.mpz_fits_sshort_p (&Bigint) int

/// fits_sshort_p is binding to mpz_fits_sshort_p
pub fn fits_sshort_p (n Bigint) int {
	return C.mpz_fits_sshort_p (&n)
}

// #define mpz_fits_uint_p __gmpz_fits_uint_p
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_fits_uint_p)
fn C.mpz_fits_uint_p (&Bigint) int

/// fits_uint_p is binding to mpz_fits_uint_p
pub fn fits_uint_p (n Bigint) int {
	return C.mpz_fits_uint_p (&n)
}
// #endif

// #define mpz_fits_ulong_p __gmpz_fits_ulong_p
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_fits_ulong_p)
fn C.mpz_fits_ulong_p (&Bigint) int

/// fits_ulong_p is binding to mpz_fits_ulong_p
pub fn fits_ulong_p (n Bigint) int {
	return C.mpz_fits_ulong_p (&n)
}
// #endif

// #define mpz_fits_ushort_p __gmpz_fits_ushort_p
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_fits_ushort_p)
fn C.mpz_fits_ushort_p (&Bigint) int 

/// fits_ushort_p is binding to mpz_fits_ushort_p
pub fn fits_ushort_p (n Bigint) int  {
	return C.mpz_fits_ushort_p (&n)
}
// #endif

// #define mpz_gcd __gmpz_gcd
fn C.mpz_gcd (d &Bigint, a &Bigint, b &Bigint)

/// gcd is binding to mpz_gcd
pub fn gcd (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_gcd (&d, &a, &b)
	return d
}

// #define mpz_gcd_ui __gmpz_gcd_ui
fn C.mpz_gcd_ui (&Bigint, &Bigint, u64) u64

/// gcd_u64 is binding to mpz_gcd_ui
pub fn gcd_u64 (a Bigint, b u64) (Bigint, u64) {
	r := new()
	g := C.mpz_gcd_ui (&r, &a, b)
	return r, g
}

// #define mpz_gcdext __gmpz_gcdext
fn C.mpz_gcdext (&Bigint, &Bigint, &Bigint, &Bigint, &Bigint)

/// gcdext is binding to mpz_gcdext
pub fn gcdext (a Bigint, b Bigint) (Bigint, Bigint, Bigint) {
	t := new()
	s := new()
	g := new()
	C.mpz_gcdext (&g, &s, &t, &a, &b)
	return g, s, t
}

// #define mpz_get_d __gmpz_get_d
fn C.mpz_get_d (s &Bigint) f64

/// f64 is binding to mpz_get_d
pub fn (s Bigint) f64() f64 {
	return C.mpz_get_d(&s)
}

// #define mpz_get_d_2exp __gmpz_get_d_2exp
fn C.mpz_get_d_2exp (&i64, &Bigint) f64

/// get_d_2exp is binding to mpz_get_d_2exp
pub fn get_d_2exp (e &i64, n Bigint) f64 {
	return C.mpz_get_d_2exp (e, &n)
}

// #define mpz_get_si __gmpz_get_si
/* signed */ 
fn C.mpz_get_si (s &Bigint) i64

/// i64 is binding to mpz_get_si
pub fn (s Bigint) i64() i64 {
	return C.mpz_get_si(&s)
}

// #define mpz_get_str __gmpz_get_str
fn C.mpz_get_str (str &char , l int, s &Bigint) &char

/// str_base is binding to mpz_get_str
pub fn (s Bigint) str_base (base int) string {
	str_len := int(sizeinbase(&s, base)) + 2
	mut n_str := []byte{len: str_len}
	mut t_str := ''
unsafe {	
		c_str := C.mpz_get_str(&char(&n_str[0]), base, &s)
		(&char(c_str)).vstring() 
		t_str = tos_clone(c_str)
	}
	return t_str
}

// str is binding to mpz_get_str with default decimal base
[inline]
pub fn (s Bigint) str () string {
	return s.str_base(10)
}

// #define mpz_get_ui __gmpz_get_ui
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_get_ui)
fn C.mpz_get_ui (s &Bigint) u64
// #endif

/// u64 is binding to mpz_get_ui
pub fn (s Bigint) u64 () u64 {
	return C.mpz_get_ui(&s)
}

// #define mpz_getlimbn __gmpz_getlimbn
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_getlimbn)
//  mpz_getlimbn (Bigint, mp_size_t)mp_limb_t
// #endif

// #define mpz_hamdist __gmpz_hamdist
fn C.mpz_hamdist (&Bigint, &Bigint) u64

/// hamdist is binding to mpz_hamdist
pub fn hamdist (a Bigint, b Bigint) u64 {
	return C.mpz_hamdist (&a, &b)
}

// #define mpz_import __gmpz_import
// fn C.import (Bigint, size_t, int, size_t, int, size_t, const void *)

// #define mpz_init __gmpz_init
fn C.mpz_init (s &Bigint)

/// new is binding to mpz_init
pub fn new() Bigint {
	s := Bigint{} // C.__mpz_struct{ 0, 0, 0 }
	C.mpz_init(&s)
	return s
}
// #define mpz_init2 __gmpz_init2
// fn C.mpz_init2 (&Bigint, u64)

// pub fn init2 (&Bigint, u64) {
// 	C.mpz_init2 (&
// }

// #define mpz_inits __gmpz_inits
// fn C.inits (Bigint, ...)

// #define mpz_init_set __gmpz_init_set
fn C.mpz_init_set (d &Bigint, s &Bigint)

/// init_set is binding to mpz_init_set
pub fn init_set (d Bigint, s Bigint) {
	C.mpz_init_set (&d, &s)
}

// #define mpz_init_set_d __gmpz_init_set_d
fn C.mpz_init_set_d (d &Bigint, s f64)

/// from_f64 is binding to mpz_init_set_d
pub fn from_f64(f f64) Bigint {
	n := Bigint{} // C.__mpz_struct{ 0, 0, 0 }
	C.mpz_init_set_d(&n, f)
	return n
}

// #define mpz_init_set_si __gmpz_init_set_si
fn C.mpz_init_set_si (d &Bigint, s i64)

/// from_i64 is binding to mpz_init_set_si
pub fn from_i64(i i64) Bigint {
	n := Bigint{} // C.__mpz_struct{ 0, 0, 0 }
	C.mpz_init_set_si(&n, i)
	return n
}

// #define mpz_init_set_str __gmpz_init_set_str
fn C.mpz_init_set_str (d &Bigint, s &byte, l int) int 

/// from_str_base is binding to mpz_init_set_str
pub fn from_str_base (s string, base int) Bigint  {
	d := Bigint{}
	C.mpz_init_set_str (&d, &char(s.str), base)
	return d
}

// from_str is binding to mpz_init_set_str with default decimal base
[inline]
pub fn from_str (s string) Bigint  {
	return from_str_base(s, 10)
}

// #define mpz_init_set_ui __gmpz_init_set_ui
fn C.mpz_init_set_ui (d &Bigint, s u64)

/// from_u64 is binding to mpz_init_set_ui
pub fn from_u64 (s u64) Bigint {
	d := Bigint{}
	C.mpz_init_set_ui (&d, s)
	return d
}

// #define mpz_inp_raw __gmpz_inp_raw
// #ifdef _GMP_H_HAVE_FILE
// size_t mpz_inp_raw (Bigint, FILE *)
// #endif

// #define mpz_inp_str __gmpz_inp_str
// #ifdef _GMP_H_HAVE_FILE
// C.mpz_inp_str (Bigint, FILE *, int) size_t
// #endif

// #define mpz_invert __gmpz_invert
fn C.mpz_invert (&Bigint, &Bigint, &Bigint) int

/// invert is binding to mpz_invert
pub fn invert (a Bigint, m Bigint) (Bigint, int) {
	r := new()
	st := C.mpz_invert (&r, &a, &m)
	return r, st
}

// #define mpz_ior __gmpz_ior
fn C.mpz_ior (d &Bigint, a &Bigint, b &Bigint)

/// ior is binding to mpz_ior
pub fn ior (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_ior (&d, &a, &b)
	return d
}

// #define mpz_jacobi __gmpz_jacobi
fn C.mpz_jacobi (&Bigint, &Bigint) int 

/// jacobi is binding to mpz_jacobi
pub fn jacobi (a Bigint, b Bigint) int  {
	return C.mpz_jacobi (&a, &b)
}

// #define mpz_kronecker mpz_jacobi  /* alias */

// #define mpz_kronecker_si __gmpz_kronecker_si
fn C.mpz_kronecker_si (&Bigint, i64) int 

/// kronecker_i64 is binding to mpz_kronecker_si
pub fn kronecker_i64 (a Bigint, b i64) int  {
	return C.mpz_kronecker_si (&a, b)
}

// #define mpz_kronecker_ui __gmpz_kronecker_ui
fn C.mpz_kronecker_ui (&Bigint, u64) int 

/// kronecker_u64 is binding to mpz_kronecker_ui
pub fn kronecker_u64 (a Bigint, b u64) int  {
	return C.mpz_kronecker_ui (&a, b)
}

// #define mpz_si_kronecker __gmpz_si_kronecker
fn C.mpz_si_kronecker (i64, &Bigint) int 

/// si_kronecker is binding to mpz_si_kronecker
pub fn i64_kronecker (a i64, b Bigint) int  {
	return C.mpz_si_kronecker (a, &b)
}

// #define mpz_ui_kronecker __gmpz_ui_kronecker
fn C.mpz_ui_kronecker (u64, &Bigint) int 

/// ui_kronecker is binding to mpz_ui_kronecker
pub fn u64_kronecker (a u64, b Bigint) int  {
	return C.mpz_ui_kronecker (a, &b)
}

// #define mpz_lcm __gmpz_lcm
fn C.mpz_lcm (d &Bigint, a &Bigint, b &Bigint)

/// lcm is binding to mpz_lcm
pub fn lcm (a Bigint, b Bigint) Bigint {
	d := new()
	C.mpz_lcm (&d, &a, &b)
	return d
}

// #define mpz_lcm_ui __gmpz_lcm_ui
fn C.mpz_lcm_ui (&Bigint, &Bigint, u64)

/// lcm_u64 is binding to mpz_lcm_ui
pub fn lcm_u64 (a Bigint, b u64) Bigint {
	r := new()
	C.mpz_lcm_ui (&r, &a, &b)
	return r
}

// #define mpz_legendre mpz_jacobi  /* alias */

// #define mpz_lucnum_ui __gmpz_lucnum_ui
fn C.mpz_lucnum_ui (&Bigint, u64)

/// lucnum_u64 is binding to mpz_lucnum_ui
pub fn lucas_num (n u64) Bigint {
	l := new()
	C.mpz_lucnum_ui (&l, n)
	return l
}

// #define mpz_lucnum2_ui __gmpz_lucnum2_ui
fn C.mpz_lucnum2_ui (&Bigint, &Bigint, u64)

/// lucnum2_u64 is binding to mpz_lucnum2_ui
pub fn lucas_num2 (n u64) (Bigint, Bigint) {
	lsub1 := new()
	l := new()
	C.mpz_lucnum2_ui (&l, &lsub1, n)
	return l, lsub1
}

#define mpz_millerrabin __gmpz_millerrabin
fn C.mpz_millerrabin (&Bigint, int) int 

/// millerrabin is binding to mpz_millerrabin
pub fn millerrabin (m Bigint, n int) int  {
	return C.mpz_millerrabin (&m, n)
}

// #define mpz_mod __gmpz_mod
fn C.mpz_mod (&Bigint, &Bigint, &Bigint)

/// mod is binding to mpz_mod
pub fn mod (n Bigint, d Bigint) Bigint {
	r := new()
	C.mpz_mod (&r, &n, &d)
	return r
}

// #define mpz_mod_ui mpz_fdiv_r_ui /* same as fdiv_r because divisor unsigned */

// #define mpz_mul __gmpz_mul
fn C.mpz_mul (&Bigint, &Bigint, &Bigint)

/// * is binding to mpz_mul
pub fn (a Bigint) * (b Bigint) Bigint {
	d := new()
	C.mpz_mul (&d, &a, &b)
	return d
}

#define mpz_mul_2exp __gmpz_mul_2exp
fn C.mpz_mul_2exp (&Bigint, &Bigint, u64)

/// mul_2exp is binding to mpz_mul_2exp
pub fn mul_2exp (a Bigint, b u64) Bigint {
	r := new()
	C.mpz_mul_2exp (&r, &a, b)
	return r
}

// #define mpz_mul_si __gmpz_mul_si
fn C.mpz_mul_si (&Bigint, &Bigint, i64)

/// mul_i64 is binding to mpz_mul_si
pub fn mul_i64 (a Bigint, b i64) Bigint {
	r := new()
	C.mpz_mul_si (&r, &a, b)
	return r
}

// #define mpz_mul_ui __gmpz_mul_ui
fn C.mpz_mul_ui (&Bigint, &Bigint, u64)

/// mul_u64 is binding to mpz_mul_ui
pub fn mul_u64 (a Bigint, b u64) Bigint {
	r := new()
	C.mpz_mul_ui (&r, &a, b)
	return r
}

// #define mpz_neg __gmpz_neg
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_neg)
fn C.mpz_neg (&Bigint, &Bigint)

/// neg is binding to mpz_neg
pub fn neg (a Bigint) Bigint {
	r := new()
	C.mpz_neg (&r, &a)
	return r
}
// #endif

// #define mpz_nextprime __gmpz_nextprime
fn C.mpz_nextprime (&Bigint, &Bigint)

/// nextprime is binding to mpz_nextprime
pub fn nextprime (a Bigint) Bigint {
	r := new()
	C.mpz_nextprime (&r, &a)
	return r
}

// #define mpz_out_raw __gmpz_out_raw
// #ifdef _GMP_H_HAVE_FILE
// size_t mpz_out_raw (FILE *, Bigint)
// #endif

// #define mpz_out_str __gmpz_out_str
// #ifdef _GMP_H_HAVE_FILE
// size_t mpz_out_str (FILE *, int, Bigint)
// #endif

// #define mpz_perfect_power_p __gmpz_perfect_power_p
fn C.mpz_perfect_power_p (&Bigint) int 

/// perfect_power_p is binding to mpz_perfect_power_p
pub fn perfect_power_p (s Bigint) int  {
	return C.mpz_perfect_power_p (&s)
}

// #define mpz_perfect_square_p __gmpz_perfect_square_p
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_perfect_square_p)
fn C.mpz_perfect_square_p (&Bigint) int 

/// perfect_square_p is binding to mpz_perfect_square_p
pub fn perfect_square_p (s Bigint) int  {
	return C.mpz_perfect_square_p (&s)
}
// #endif

// #define mpz_popcount __gmpz_popcount
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_popcount)
fn C.mpz_popcount (&Bigint) u64 

/// popcount is binding to mpz_popcount
pub fn popcount (s Bigint) u64  {
	return C.mpz_popcount (&s)
}
// #endif

// #define mpz_pow_ui __gmpz_pow_ui
fn C.mpz_pow_ui (&Bigint, &Bigint, u64)

/// power is binding to mpz_pow_ui
pub fn (b Bigint) power (e u64) Bigint {
	r := new()
	C.mpz_pow_ui (&r, &b, e)
	return r
}

// #define mpz_powm __gmpz_powm
fn C.mpz_powm (&Bigint, &Bigint, &Bigint, &Bigint)

/// powm is binding to mpz_powm
pub fn powm (b Bigint, e Bigint, m Bigint) Bigint {
	r := new()
	C.mpz_powm (&r, &b, &e, &m)
	return r
}

// #define mpz_powm_sec __gmpz_powm_sec
fn C.mpz_powm_sec (&Bigint, &Bigint, &Bigint, &Bigint)

/// powm_sec is binding to mpz_powm_sec
pub fn powm_sec (b Bigint, e Bigint, m Bigint) Bigint {
	r := new()
	C.mpz_powm_sec (&r, &b, &e, &m)
	return r
}

// #define mpz_powm_ui __gmpz_powm_ui
fn C.mpz_powm_ui (&Bigint, &Bigint, u64, &Bigint)

/// powm_u64 is binding to mpz_powm_ui
pub fn powm_u64 (b Bigint, e u64, m Bigint) Bigint {
	r := new()
	C.mpz_powm_ui (&r, &b, e, &m)
	return r
}

// #define mpz_probab_prime_p __gmpz_probab_prime_p
fn C.mpz_probab_prime_p (&Bigint, int) int 

/// probab_prime_p is binding to mpz_probab_prime_p
pub fn probab_prime_p (s Bigint, n int) int  {
	return C.mpz_probab_prime_p (&s, n)
}

// #define mpz_random __gmpz_random
// fn C.mpz_random (&Bigint, u64)

// pub fn random (mut r Bigint, m u64) {
// 	C.mpz_random (&r, m)
// }

// #define mpz_random2 __gmpz_random2
// fn C.mpz_random2 (&Bigint, u64)
// 
// pub fn random2 (mut r Bigint, m u64) {
	// C.mpz_random2 (&r, m)
// }

// #define mpz_realloc2 __gmpz_realloc2
// fn C.mpz_realloc2 (&Bigint, u64)

// pub fn realloc2 (Bigint, u64) {}

// #define mpz_remove __gmpz_remove
fn C.mpz_remove (&Bigint, &Bigint, &Bigint) u64

/// remove is binding to mpz_remove
pub fn remove (o Bigint, f Bigint) (Bigint, u64) {
	r := new()
	nb_occ := C.mpz_remove (&r, &o, &f)
	return r, nb_occ
}

// #define mpz_root __gmpz_root
fn C.mpz_root (&Bigint, &Bigint, u64) int 

/// root is binding to mpz_root
pub fn root (o Bigint, n u64) (Bigint, int)  {
	r := new()
	ex := C.mpz_root (&r, &o, n)
	return r, ex
}

// #define mpz_rootrem __gmpz_rootrem
fn C.mpz_rootrem (&Bigint, &Bigint, &Bigint, u64)

/// rootrem is binding to mpz_rootrem
pub fn rootrem (u Bigint, n u64) (Bigint, Bigint) {
	rem := new()
	root := new()
	C.mpz_rootrem (&root, &rem, &u, n)
	return root, rem
}

// #define mpz_rrandomb __gmpz_rrandomb
fn C.mpz_rrandomb (&Bigint, &Randstate, u64)

/// rrandomb is binding to mpz_rrandomb
pub fn rrandomb (mut st Randstate, n u64) Bigint {
	r := new()
	C.mpz_rrandomb (&r, &st, n)
	return r
}

// #define mpz_scan0 __gmpz_scan0
fn C.mpz_scan0 (&Bigint, u64) u64

/// scan0 is binding to mpz_scan0
pub fn scan0 (s Bigint, n u64) u64 {
	return C.mpz_scan0 (&s, n)
}

// #define mpz_scan1 __gmpz_scan1
fn C.mpz_scan1 (&Bigint, u64) u64 

/// scan1 is binding to mpz_scan1
pub fn scan1 (s Bigint, n u64) u64  {
	return C.mpz_scan1 (&s, n)
}

// #define mpz_set __gmpz_set
fn C.mpz_set (&Bigint, &Bigint)

/// set is binding to mpz_set
pub fn set (mut a Bigint, b Bigint) {
	C.mpz_set (&a, &b)
}

pub fn (b Bigint) clone () Bigint {
	mut a := new()
	set (mut a, b)
	return a
}

// #define mpz_set_d __gmpz_set_d
fn C.mpz_set_d (&Bigint, f64)

/// set_d is binding to mpz_set_d
pub fn set_f64 (b f64) Bigint {
	a := new()
	C.mpz_set_d (&a, b)
	return a
}

// // #define mpz_set_f __gmpz_set_f
// fn C.mpz_set_f (&Bigint, mpf_srcptr)

// pub fn set_f (Bigint, mpf_srcptr) {
// 	C.mpz_set_f (&a, &b)
// }

// // #define mpz_set_q __gmpz_set_q
// // #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_set_q)
// fn C.mpz_set_q (&Bigint, mpq_srcptr)

// pub fn set_q (Bigint, mpq_srcptr) {}
// // #endif

// #define mpz_set_si __gmpz_set_si
fn C.mpz_set_si (&Bigint, i64)

/// set_i64 is binding to mpz_set_si
pub fn set_i64 (b i64) Bigint {
	a := new()
	C.mpz_set_si (&a, b)
	return a
}

// #define mpz_set_str __gmpz_set_str
fn C.mpz_set_str (&Bigint, &char, int) int 

/// set_str is binding to mpz_set_str
pub fn set_str (s string, base int) (Bigint, int)  {
	a := new()
	res := C.mpz_set_str (&a, &char(s.str), base)
	return a, res
}

// #define mpz_set_ui __gmpz_set_ui
fn C.mpz_set_ui (&Bigint, u64)

/// set_u64 is binding to mpz_set_ui
pub fn set_u64 (b u64) Bigint {
	a := new()
	C.mpz_set_ui (&a, b)
	return a
}

// #define mpz_setbit __gmpz_setbit
fn C.mpz_setbit (&Bigint, u64)

/// setbit is binding to mpz_setbit
pub fn setbit (mut a Bigint, b u64) {
	C.mpz_setbit (&a, b)
}

// #define mpz_size __gmpz_size
// #if __GMP_INLINE_PROTOTYPES || defined (__GMP_FORCE_mpz_size)
// size_t mpz_size (Bigint)
// #endif

// #define mpz_sizeinbase __gmpz_sizeinbase
fn C.mpz_sizeinbase (s &Bigint, b int) u64

/// sizeinbase is binding to mpz_sizeinbase
pub fn sizeinbase (s Bigint, b int) u64 {
	return C.mpz_sizeinbase (&s, b)
}

// #define mpz_sqrt __gmpz_sqrt
fn C.mpz_sqrt (&Bigint,&Bigint)

/// isqrt is binding to mpz_sqrt
pub fn isqrt (a Bigint) Bigint {
	s := new()
	C.mpz_sqrt (&s, &a)
	return s
}

// #define mpz_sqrtrem __gmpz_sqrtrem
fn C.mpz_sqrtrem (&Bigint, &Bigint, &Bigint)

/// sqrtrem is binding to mpz_sqrtrem
pub fn sqrt_rem (a Bigint) (Bigint, Bigint) {
	r := new()
	s := new()
	C.mpz_sqrtrem (&s, &r, &a)
	return s, r
}

// #define mpz_sub __gmpz_sub
fn C.mpz_sub (&Bigint, &Bigint, &Bigint)

/// - is binding to mpz_sub
pub fn (a Bigint) - (b Bigint) Bigint {
	mut d := new()
	C.mpz_sub (&d, &a, &b)
	return d
}

// #define mpz_sub_ui __gmpz_sub_ui
fn C.mpz_sub_ui (&Bigint, &Bigint, u64)

/// sub_u64 is binding to mpz_sub_ui
pub fn sub_u64 (a Bigint, b u64) Bigint {
	d := new()
	C.mpz_sub_ui (&d, &a, b)
	return d
}

// #define mpz_ui_sub __gmpz_ui_sub
fn C.mpz_ui_sub (&Bigint, u64, &Bigint)

/// ui_sub is binding to mpz_ui_sub
pub fn u64_sub (a u64, b Bigint) Bigint {
	d := new()
	C.mpz_ui_sub (&d, a, &b)
	return d
}

// #define mpz_submul __gmpz_submul
fn C.mpz_submul (&Bigint, &Bigint, &Bigint)

/// submul is binding to mpz_submul
pub fn submul (b Bigint, c Bigint) Bigint {
	a := new()
	C.mpz_submul (&a, &b, &c)
	return a
}

// #define mpz_submul_ui __gmpz_submul_ui
fn C.mpz_submul_ui (&Bigint, &Bigint, u64)

/// submul_u64 is binding to mpz_submul_ui
pub fn submul_u64 (b Bigint, c u64) Bigint {
	a := new()
	C.mpz_submul_ui (&a, &b, c)
	return a
}

// #define mpz_swap __gmpz_swap
fn C.mpz_swap (&Bigint, &Bigint)

/// swap is binding to mpz_swap
pub fn swap (mut a Bigint, mut b Bigint) {
	C.mpz_swap (&a, &b)
}

// #define mpz_tdiv_ui __gmpz_tdiv_ui
fn C.mpz_tdiv_ui (&Bigint, u64) u64

/// tdiv_u64 is binding to mpz_tdiv_ui
pub fn tdiv_u64 (n Bigint, d u64) u64 {
	return C.mpz_tdiv_ui (&n, d)
}

// #define mpz_tdiv_q __gmpz_tdiv_q
fn C.mpz_tdiv_q (&Bigint, &Bigint, &Bigint)

/// / is binding to mpz_tdiv_q
pub fn (n Bigint) / (d Bigint) Bigint {
	if cmp(d, from_u64(0)) == 0 {
		panic('Division by zero')
	}
	q := new()
	C.mpz_tdiv_q (&q, &n, &d)
	return q
}

// #define mpz_tdiv_q_2exp __gmpz_tdiv_q_2exp
fn C.mpz_tdiv_q_2exp (&Bigint, &Bigint, u64)

/// tdiv_q_2exp is binding to mpz_tdiv_q_2exp
pub fn tdiv_q_2exp (n Bigint, b u64) Bigint {
	q := new()
	C.mpz_tdiv_q_2exp (&q, &n, b)
	return q
}

// #define mpz_tdiv_q_ui __gmpz_tdiv_q_ui
fn C.mpz_tdiv_q_ui (&Bigint, &Bigint, u64) u64 

/// tdiv_q_u64 is binding to mpz_tdiv_q_ui
pub fn tdiv_q_u64 (n Bigint, d u64) (Bigint, u64)  {
	q := new()
	res := C.mpz_tdiv_q_ui (&q, &n, d)
	return q, res
}

// #define mpz_tdiv_qr __gmpz_tdiv_qr
fn C.mpz_tdiv_qr (&Bigint, &Bigint, &Bigint, &Bigint)

/// divmod is binding to mpz_tdiv_qr
pub fn divmod (n Bigint, d Bigint) (Bigint, Bigint) {
	q := new()
	r := new()
	C.mpz_tdiv_qr (&q, &r, &n, &d)
	return q, r
}

// #define mpz_tdiv_qr_ui __gmpz_tdiv_qr_ui
fn C.mpz_tdiv_qr_ui (&Bigint, &Bigint, &Bigint, u64) u64

/// tdiv_qr_u64 is binding to mpz_tdiv_qr_ui
pub fn tdiv_qr_u64 (n Bigint, d u64) (Bigint, Bigint, u64) {
	r := new()
	q := new()
	res := C.mpz_tdiv_qr_ui (&q, &r, &n, d)
	return q, r, res
}

// #define mpz_tdiv_r __gmpz_tdiv_r
fn C.mpz_tdiv_r (&Bigint, &Bigint, &Bigint)

/// % is binding to mpz_tdiv_r
pub fn (n Bigint) % (d Bigint) Bigint {
	r := new()
	C.mpz_tdiv_r (&r, &n, &d)
	return r
}

// #define mpz_tdiv_r_2exp __gmpz_tdiv_r_2exp
fn C.mpz_tdiv_r_2exp (&Bigint, &Bigint, u64)

/// tdiv_r_2exp is binding to mpz_tdiv_r_2exp
pub fn tdiv_r_2exp (n Bigint, d u64) Bigint {
	r := new()
	C.mpz_tdiv_r_2exp (&r, &n, d)
	return r
}

// #define mpz_tdiv_r_ui __gmpz_tdiv_r_ui
fn C.mpz_tdiv_r_ui (&Bigint, &Bigint, u64) u64

/// tdiv_r_u64 is binding to mpz_tdiv_r_ui
pub fn tdiv_r_u64 (n Bigint, d u64) (Bigint, u64) {
	r := new()
	res := C.mpz_tdiv_r_ui (&r, &n, d)
	return r, res
}

// #define mpz_tstbit __gmpz_tstbit
fn C.mpz_tstbit (&Bigint, u64) int 

/// tstbit is binding to mpz_tstbit
pub fn tstbit (a Bigint, b u64) int  {
	return C.mpz_tstbit (&a, b)
}

// #define mpz_ui_pow_ui __gmpz_ui_pow_ui
fn C.mpz_ui_pow_ui (&Bigint, u64, u64)

/// ui_pow_u64 is binding to mpz_ui_pow_ui
pub fn ui_pow_u64 (b u64, e u64) Bigint {
	r := new()
	C.mpz_ui_pow_ui (&r, b, e)
	return r
}

// #define mpz_urandomb __gmpz_urandomb
fn C.mpz_urandomb (&Bigint, &Randstate, u64)

/// urandomb is binding to mpz_urandomb
pub fn urandomb (mut s Randstate, n u64) Bigint {
	r := new()
	C.mpz_urandomb (&r, &s, n)
	return r
}

// #define mpz_urandomm __gmpz_urandomm
fn C.mpz_urandomm (&Bigint, &Randstate, &Bigint)

/// urandomm is binding to mpz_urandomm
pub fn urandomm ( mut s Randstate, n Bigint) Bigint {
	r := new()
	C.mpz_urandomm (&r, &s, &n)
	return r
}

// #define mpz_xor __gmpz_xor
// #define mpz_eor __gmpz_xor
fn C.mpz_xor (&Bigint, &Bigint, &Bigint)

/// xor is binding to mpz_xor
pub fn xor (a Bigint, b Bigint) Bigint {
	r := new()
	C.mpz_xor (&r, &a, &b)
	return r
}

// #define mpz_limbs_read __gmpz_limbs_read
// mp_srcptr mpz_limbs_read (Bigint)

// #define mpz_limbs_write __gmpz_limbs_write
// mp_ptr mpz_limbs_write (Bigint, mp_size_t)

// #define mpz_limbs_modify __gmpz_limbs_modify
// mp_ptr mpz_limbs_modify (Bigint, mp_size_t)

// #define mpz_limbs_finish __gmpz_limbs_finish
// fn C.limbs_finish (Bigint, mp_size_t)

// #define mpz_roinit_n __gmpz_roinit_n
// Bigint mpz_roinit_n (Bigint, mp_srcptr, mp_size_t)

// #define MPZ_ROINIT_N(xp, xs) {{0, (xs),(xp) }}

