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

struct C.__mpq_struct
{
	_mp_num  C.__mpz_struct 
	_mp_den  C.__mpz_struct 
}

type Bigrational = C.__mpq_struct

struct C.__mpf_struct
{
	_mp_prec int		/* Max precision, in number of `mp_limb_t's.
					Set by mpf_init and modified by
					mpf_set_prec.  The area pointed to by the
					_mp_d field contains `prec' + 1 limbs.  */
	_mp_size int			/* abs(_mp_size) is the number of limbs the
					last field points to.  If _mp_size is
					negative this is a negative number.  */
	_mp_exp i64		/* Exponent, in the base of `mp_limb_t'.  */
	_mp_d &u64		/* Pointer to the limbs.  */
} 

/* typedef __mpf_struct MP_FLOAT; */
type Bigfloat = C.__mpf_struct

// #define _mpz_realloc __gmpz_realloc
// #define mpz_realloc __gmpz_realloc
// C.*_mpz_realloc (Bigint, mp_size_t)

fn C.mp_set_memory_functions (fn (u64) voidptr,
				      fn (voidptr, u64, u64) voidptr,
				      fn (voidptr, u64) voidptr)

/* void *(*alloc_func_ptr)(size t),
void *(*realloc_func_ptr)(void *, size t, size t),
void (*free_func_ptr)(void *, size t)) */
pub fn mp_set_memory_functions (alloc_func_ptr fn (u64) voidptr,
				     realloc_func_ptr fn (voidptr, u64, u64) voidptr,
				     free_func_ptr fn (voidptr, u64) voidptr) {
	C.mp_set_memory_functions (alloc_func_ptr, realloc_func_ptr, free_func_ptr)
}


fn my_realloc (ptr &byte, old_size u64, new_size u64) &byte {
	unsafe { return v_realloc (ptr, int(new_size)) }
}

fn my_free (ptr &byte, size u64) {
	unsafe{ free (ptr) }
}

fn my_malloc(size u64) voidptr {
	return unsafe { malloc(int(size)) }
}

fn init() {
	C.mp_set_memory_functions(my_malloc, my_realloc, my_free)
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

/**************** Formatted output routines.  ****************/

// #define gmp_asprintf __gmp_asprintf

// fn int C.gmp_asprintf (char **, const char *, ...);

// // #define gmp_fprintf __gmp_fprintf
// #ifdef _GMP_H_HAVE_FILE

// fn int C.gmp_fprintf (FILE *, const char *, ...);
// #endif

// // #define gmp_obstack_printf __gmp_obstack_printf
// #if defined (_GMP_H_HAVE_OBSTACK)

// fn int C.gmp_obstack_printf (struct obstack *, const char *, ...);
// #endif

// // #define gmp_obstack_vprintf __gmp_obstack_vprintf
// #if defined (_GMP_H_HAVE_OBSTACK) && defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_obstack_vprintf (struct obstack *, const char *, va_list);
// #endif

// // #define gmp_printf __gmp_printf

// fn int C.gmp_printf (const char *, ...);

// // #define gmp_snprintf __gmp_snprintf

// fn int C.gmp_snprintf (char *, size_t, const char *, ...);

// // #define gmp_sprintf __gmp_sprintf

// fn int C.gmp_sprintf (char *, const char *, ...);

// // #define gmp_vasprintf __gmp_vasprintf
// #if defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_vasprintf (char **, const char *, va_list);
// #endif

// // #define gmp_vfprintf __gmp_vfprintf
// #if defined (_GMP_H_HAVE_FILE) && defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_vfprintf (FILE *, const char *, va_list);
// #endif

// // #define gmp_vprintf __gmp_vprintf
// #if defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_vprintf (const char *, va_list);
// #endif

// // #define gmp_vsnprintf __gmp_vsnprintf
// #if defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_vsnprintf (char *, size_t, const char *, va_list);
// #endif

// // #define gmp_vsprintf __gmp_vsprintf
// #if defined (_GMP_H_HAVE_VA_LIST)

// fn int C.gmp_vsprintf (char *, const char *, va_list);
// #endif

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
fn C.mpz_export (voidptr, &u64, int, u64, int, u64, &Bigint) voidptr

pub fn export (ret &byte, count &u64, order int, size u64, endian int, nails u64, a Bigint) voidptr {
	return C.mpz_export (ret, count, order, size, endian, nails, &a)
}

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
fn C.mpz_import (&Bigint, u64, int, u64, int, u64, voidptr)

pub fn mpz_import (count u64, order int, size u64, endian int, nails u64, buf &byte) Bigint {
	a := new()
	C.mpz_import (&a, count, order, size, endian, nails, buf)
	return a
}

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
pub fn from_str_base (s string, base int) ?Bigint  {
	d := Bigint{}
	if C.mpz_init_set_str (&d, &char(s.str), base) == 0 {
		return d
	} else {
		return error('Invalid number string')
	}
}

// from_str is binding to mpz_init_set_str with default decimal base
[inline]
pub fn from_str (s string) ?Bigint  {
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
pub fn set_str (mut a Bigint, s string, base int) int  {
	return C.mpz_set_str (&a, &char(s.str), base)
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

/**************** Rational (i.e. Q) routines.  ****************/

/**************** Float (i.e. F) routines.  ****************/

// #define mpf_abs __gmpf_abs
fn C.mpf_abs (&Bigfloat, &Bigfloat)

pub fn f_abs (b Bigfloat) Bigfloat {
	a := f_new()
	C.mpf_abs (&a, &b)
	return a 
}

// #define mpf_add __gmpf_add
fn C.mpf_add (&Bigfloat, &Bigfloat, &Bigfloat)

pub fn (a Bigfloat) + (b Bigfloat) Bigfloat {
	r := f_new()
	C.mpf_add (&r, &a, &b)
	return r
}

// #define mpf_add_ui __gmpf_add_ui
fn C.mpf_add_ui (&Bigfloat, &Bigfloat, u64)

pub fn f_add_u64 (a Bigfloat, b u64) Bigfloat {
	r := f_new()
	C.mpf_add_ui (&r, &a, b)
	return r 
}
// #define mpf_ceil __gmpf_ceil
fn C.mpf_ceil (&Bigfloat, &Bigfloat)

pub fn f_ceil (a Bigfloat) Bigfloat {
	r := f_new()
	C.mpf_ceil (&r, &a)
	return r 
}

// #define mpf_clear __gmpf_clear
fn C.mpf_clear (&Bigfloat)

pub fn f_clear (mut a Bigfloat) {
	C.mpf_clear (&a)
}

// #define mpf_clears __gmpf_clears
// fn C.mpf_clears (&Bigfloat, ...)

// #define mpf_cmp __gmpf_cmp
fn C.mpf_cmp (&Bigfloat, &Bigfloat) int

pub fn f_cmp (a Bigfloat, b Bigfloat) int {
	return C.mpf_cmp (&a, &b)
}

// #define mpf_cmp_z __gmpf_cmp_z
fn C.mpf_cmp_z (&Bigfloat, &Bigint) int

pub fn f_cmp_z (a Bigfloat, b Bigint) int {
	return C.mpf_cmp_z (&a, &b)
}

// #define mpf_cmp_d __gmpf_cmp_d
fn C.mpf_cmp_d (&Bigfloat, f64) int

pub fn f_cmp_d (a Bigfloat, b f64) int {
	return C.mpf_cmp_d (&a, b)
}

// #define mpf_cmp_si __gmpf_cmp_si
fn C.mpf_cmp_si (&Bigfloat, i64) int

pub fn f_cmp_i64 (a Bigfloat, b i64) int {
	return C.mpf_cmp_si (&a, b)
}

// #define mpf_cmp_ui __gmpf_cmp_ui
fn C.mpf_cmp_ui (&Bigfloat, u64) int

pub fn f_cmp_u64 (a Bigfloat, b u64) int {
	return C.mpf_cmp_ui (&a, b)
}

// #define mpf_div __gmpf_div
fn C.mpf_div (&Bigfloat, &Bigfloat, &Bigfloat)

pub fn (a Bigfloat) / (b Bigfloat) Bigfloat {
	r := f_new()
	C.mpf_div (&r, &a, &b)
	return r
}

// #define mpf_div_2exp __gmpf_div_2exp
fn C.mpf_div_2exp (&Bigfloat, &Bigfloat, u64)

pub fn f_div_2exp (a Bigfloat, e u64) Bigfloat {
	r := f_new()
	C.mpf_div_2exp (&r, &a, e)
	return r 
}

// #define mpf_div_ui __gmpf_div_ui
fn C.mpf_div_ui (&Bigfloat, &Bigfloat, u64)

pub fn f_div_u64 (a Bigfloat, b u64) Bigfloat {
	r := f_new()
	C.mpf_div_ui (&r, &a, b)
	return r 
}

// // #define mpf_dump __gmpf_dump
// fn C.mpf_dump (&Bigfloat)

// pub fn f_dump (&Bigfloat) {

// }

// #define mpf_eq __gmpf_eq
// fn C.mpf_eq (&Bigfloat, &Bigfloat, u64) int

// pub fn f_eq (&Bigfloat, &Bigfloat, u64) int {
// 	return C.mpf_eq (&Bigfloat, &Bigfloat, u64
// }

// #define mpf_fits_sint_p __gmpf_fits_sint_p
fn C.mpf_fits_sint_p (&Bigfloat) int

pub fn f_fits_int_p (a Bigfloat) int {
	return C.mpf_fits_sint_p (&a)
}

// #define mpf_fits_slong_p __gmpf_fits_slong_p
fn C.mpf_fits_slong_p (&Bigfloat) int

pub fn f_fits_i64_p (a Bigfloat) int {
	return C.mpf_fits_slong_p (&a)
}

// #define mpf_fits_sshort_p __gmpf_fits_sshort_p
fn C.mpf_fits_sshort_p (&Bigfloat) int

pub fn f_fits_i16_p (a Bigfloat) int {
	return C.mpf_fits_sshort_p (&a)
}

// #define mpf_fits_uint_p __gmpf_fits_uint_p
fn C.mpf_fits_uint_p (&Bigfloat) int

pub fn f_fits_u32_p (a Bigfloat) int {
	return C.mpf_fits_uint_p (&a)
}

// #define mpf_fits_ulong_p __gmpf_fits_ulong_p
fn C.mpf_fits_ulong_p (&Bigfloat) int

pub fn f_fits_u64_p (a Bigfloat) int {
	return C.mpf_fits_ulong_p (&a)
}

// #define mpf_fits_ushort_p __gmpf_fits_ushort_p
fn C.mpf_fits_ushort_p (&Bigfloat) int

pub fn f_fits_u16_p (a Bigfloat) int {
	return C.mpf_fits_ushort_p (&a)
}

// #define mpf_floor __gmpf_floor
fn C.mpf_floor (&Bigfloat, &Bigfloat)

pub fn f_floor (b Bigfloat) Bigfloat {
	a := f_new()
	C.mpf_floor (&a, &b)
	return a 
}

// #define mpf_get_d __gmpf_get_d
fn C.mpf_get_d (&Bigfloat) f64

pub fn f_get_f64 (a Bigfloat) f64 {
	return C.mpf_get_d (&a)
}

// #define mpf_get_d_2exp __gmpf_get_d_2exp
fn C.mpf_get_d_2exp (&i64, &Bigfloat) f64

pub fn f_get_f64_2exp (e_ptr &i64, a Bigfloat) f64 {
	return C.mpf_get_d_2exp (e_ptr, &a)
}

// #define mpf_get_default_prec __gmpf_get_default_prec
fn C.mpf_get_default_prec () u64

pub fn f_get_default_prec () u64 {
	return C.mpf_get_default_prec ()
}

// #define mpf_get_prec __gmpf_get_prec
fn C.mpf_get_prec (&Bigfloat) u64

pub fn f_get_prec (a Bigfloat) u64 {
	return C.mpf_get_prec (&a)
}

// #define mpf_get_si __gmpf_get_si
fn C.mpf_get_si (&Bigfloat) i64

pub fn f_get_i64 (a Bigfloat) i64 {
	return C.mpf_get_si (&a)
}

// #define mpf_get_str __gmpf_get_str
fn C.mpf_get_str (&char, &int, int, u64, &Bigfloat) &char 

pub fn (a Bigfloat) str_base_digits (base int, n_digits u64) string {
	mut t_str := ''
	exp := int(0)
	c_str := C.mpf_get_str (0, &exp, base, n_digits, &a)
	unsafe {
		c_str.vstring()
		t_str = tos_clone(c_str)
	}
	// println('$t_str: $exp')
	mut iexp := int(exp)
	mut e_sign := '@'
	if base == 10 {
		e_sign = 'e'
	} else if base == 2 {
		e_sign = 'p'
	}
	mut t_sign := ''
	if t_str.len == 0 {
	return '0'
	}
	if t_str.len > 0 && t_str[0] == `-`{
		t_sign = '-'
		t_str = t_str[1..]
	}
	mut add_exp := false
	mut n_digits2 := n_digits
	if n_digits2 <= 0 {
		n_digits2 = 17
	}
	n_zeros := int(n_digits2) - t_str.len
	if n_zeros > 0 {
		t_str = t_str + '0'.repeat(n_zeros)
	}
	// println('with zeroes: $t_str')
	if iexp > n_digits2 {
		t_str = t_str[0..1] + '.' + t_str[1..]
		add_exp = true
	} else if iexp > 0 {
		t_str = t_str[0..iexp] + '.' + t_str[iexp..]
	} else if iexp == 0 {
		t_str = '0.' + t_str
	} else if iexp > - n_zeros {
		t_str = '0.' + '0'.repeat(-iexp) + t_str
	} else /* iexp <= - n_zeros */ {
		t_str = t_str[0..1] + '.' + t_str[1..]
		add_exp = true
	}
	t_str = t_str.trim_right("0")
	t_str = t_str.trim_suffix('.')
	if add_exp {
		t_str += '${e_sign}${iexp - 1}'
	}
	// println('result: ${t_sign + t_str}')
	return t_sign + t_str
}

pub fn (a Bigfloat) str_base(b int) string {
	return a.str_base_digits(b, 0)
}

pub fn (a Bigfloat) str_digits(d u64) string {
	return a.str_base_digits(10, d)
}

pub fn (a Bigfloat) str() string {
	return a.str_base_digits(10, 0)
}

// #define mpf_get_ui __gmpf_get_ui
fn  C.mpf_get_ui (&Bigfloat) u64

pub fn f_get_u64 (a Bigfloat) u64 {
	return C.mpf_get_ui (&a)
}

// #define mpf_init __gmpf_init
fn C.mpf_init (&Bigfloat)

pub fn f_new () Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init (&r)
	return r
}

// #define mpf_init2 __gmpf_init2
fn C.mpf_init2 (&Bigfloat, u64)

pub fn f_new_w_prec (prec u64) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init2 (&r, prec)
	return r
}

// #define mpf_inits __gmpf_inits
// fn C.mpf_inits (&Bigfloat, ...)

// #define mpf_init_set __gmpf_init_set
fn C.mpf_init_set (&Bigfloat, &Bigfloat)

pub fn f_clone (a Bigfloat) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init_set (&r, &a)
	return r
}

// #define mpf_init_set_d __gmpf_init_set_d
fn C.mpf_init_set_d (&Bigfloat, f64)

pub fn f_from_f64 (f f64) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init_set_d (&r, f)
	return r
}

// #define mpf_init_set_si __gmpf_init_set_si
fn C.mpf_init_set_si (&Bigfloat, i64)

pub fn f_from_i64 (i i64) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init_set_si (&r, i)
	return r
}

// #define mpf_init_set_str __gmpf_init_set_str
fn C.mpf_init_set_str (&Bigfloat, &char, int) int

pub fn f_from_str_base (str string, base int) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init_set_str (&r, str.str, base)
	return r
}

pub fn f_from_str (s string) Bigfloat {
	return f_from_str_base(s, 10)
}

// #define mpf_init_set_ui __gmpf_init_set_ui
fn C.mpf_init_set_ui (&Bigfloat, u64)

pub fn f_from_u64 (u u64) Bigfloat {
	r := Bigfloat{ _mp_d: 0 }
	C.mpf_init_set_ui (&r, u)
	return r
}

// #define mpf_inp_str __gmpf_inp_str
// #ifdef _GMP_H_HAVE_FILE
// fn C.mpf_inp_str (&Bigfloat, FILE *, int) size_t
// #endif

// #define mpf_integer_p __gmpf_integer_p
fn C.mpf_integer_p (&Bigfloat) int

pub fn f_integer_p (a Bigfloat) int {
	return C.mpf_integer_p (&a)
}

// #define mpf_mul __gmpf_mul
fn C.mpf_mul (&Bigfloat, &Bigfloat, &Bigfloat)

pub fn (a Bigfloat) * (b Bigfloat) Bigfloat {
	mut r := f_new()
	C.mpf_mul (&r, &a, &b)
	return r
}

// #define mpf_mul_2exp __gmpf_mul_2exp
fn C.mpf_mul_2exp (&Bigfloat, &Bigfloat, u64)

pub fn f_mul_2exp (a Bigfloat, e u64) Bigfloat {
	r := f_new()
	C.mpf_mul_2exp (&r, &a, e)
	return r 
}

// #define mpf_mul_ui __gmpf_mul_ui
fn C.mpf_mul_ui (&Bigfloat, &Bigfloat, u64)

pub fn f_mul_u64 (a Bigfloat, b u64) Bigfloat {
	r := f_new()
	C.mpf_mul_ui (&r, &a, b)
	return r 
}

// #define mpf_neg __gmpf_neg
fn C.mpf_neg (&Bigfloat, &Bigfloat)

pub fn (a Bigfloat) f_neg () Bigfloat {
	r := f_new()
	C.mpf_neg (&r, &a)
	return r
}

// #define mpf_out_str __gmpf_out_str
// #ifdef _GMP_H_HAVE_FILE
// fn C.mpf_out_str (FILE *, int, size_t, &Bigfloat) size_t
// #endif

// #define mpf_pow_ui __gmpf_pow_ui
fn C.mpf_pow_ui (&Bigfloat, &Bigfloat, u64)

pub fn f_pow_u64 (a Bigfloat, b u64) Bigfloat {
	r := f_new()
	C.mpf_pow_ui (&r, &a, b)
	return r 
}

// #define mpf_random2 __gmpf_random2
fn C.mpf_random2 (&Bigfloat, int, int)

pub fn f_random2 (max_size int, exp int) Bigfloat {
	r := f_new()
	C.mpf_random2 (&r, max_size, exp)
	return r 
}

// #define mpf_reldiff __gmpf_reldiff
fn C.mpf_reldiff (&Bigfloat, &Bigfloat, &Bigfloat)

pub fn f_reldiff (op1 Bigfloat, op2 Bigfloat) Bigfloat {
	rop := f_new()
	C.mpf_reldiff (&rop, &op1, &op2)
	return rop 
}

// #define mpf_set __gmpf_set
fn C.mpf_set (&Bigfloat, &Bigfloat)

pub fn f_set (mut a Bigfloat, b Bigfloat) {
	C.mpf_set (&a, &b)
}

// #define mpf_set_d __gmpf_set_d
fn C.mpf_set_d (&Bigfloat, f64)

pub fn f_set_f64 (f f64) Bigfloat {
	a := f_new()
	C.mpf_set_d (&a, f)
	return a 
}

// #define mpf_set_default_prec __gmpf_set_default_prec
fn C.mpf_set_default_prec (u64)

pub fn f_set_default_prec (p u64) {
	C.mpf_set_default_prec (p)
}

// #define mpf_set_prec __gmpf_set_prec
fn C.mpf_set_prec (&Bigfloat, u64)

pub fn f_set_prec (p u64) Bigfloat {
	a := f_new()
	C.mpf_set_prec (&a, p)
	return a 
}

// #define mpf_set_prec_raw __gmpf_set_prec_raw
fn C.mpf_set_prec_raw (&Bigfloat, u64)

pub fn f_set_prec_raw (p u64) Bigfloat {
	a := f_new()
	C.mpf_set_prec_raw (&a, p)
	return a 
}

// #define mpf_set_q __gmpf_set_q
// fn C.mpf_set_q (&Bigfloat, mpq_srcptr)

// pub fn f_set_q (&Bigfloat, mpq_srcptr) {}

// #define mpf_set_si __gmpf_set_si
fn C.mpf_set_si (&Bigfloat, i64)

pub fn f_set_i64 (b i64) Bigfloat {
	a := f_new()
	C.mpf_set_si (&a, b)
	return a 
}

// #define mpf_set_str __gmpf_set_str
fn C.mpf_set_str (&Bigfloat, &char, int) int

pub fn f_set_str (mut a Bigfloat, str string, base int) int {
	return C.mpf_set_str (&a, str.str, base)
}

// #define mpf_set_ui __gmpf_set_ui
fn C.mpf_set_ui (&Bigfloat, u64)

pub fn f_set_u64 (b u64) Bigfloat {
	a := f_new()
	C.mpf_set_ui (&a, b)
	return a 
}

// #define mpf_set_z __gmpf_set_z
fn C.mpf_set_z (&Bigfloat, &Bigint)

pub fn f_set_z (i Bigint) Bigfloat {
	f := f_new()
	C.mpf_set_z (&f, &i)
	return f 
}

// #define mpf_size __gmpf_size
fn C.mpf_size (&Bigfloat) u64

pub fn f_size (a Bigfloat) u64 {
	return C.mpf_size (&a) 
}

// #define mpf_sqrt __gmpf_sqrt
fn C.mpf_sqrt (&Bigfloat, &Bigfloat)

pub fn f_sqrt (b Bigfloat) Bigfloat {
	a := f_new()
	C.mpf_sqrt (&a, &b)
	return a 
}

// #define mpf_sqrt_ui __gmpf_sqrt_ui
fn C.mpf_sqrt_ui (&Bigfloat, u64)

pub fn f_sqrt_ui (b u64) Bigfloat {
	a := f_new()
	C.mpf_sqrt_ui (&a, b)
	return a 
}

// #define mpf_sub __gmpf_sub
fn C.mpf_sub (&Bigfloat, &Bigfloat, &Bigfloat)

pub fn (a Bigfloat) - (b Bigfloat) Bigfloat {
	mut r := f_new()
	C.mpf_sub (&r, &a, &b)
	return r
}

// #define mpf_sub_ui __gmpf_sub_ui
fn C.mpf_sub_ui (&Bigfloat, &Bigfloat, u64)

pub fn f_sub_ui (b Bigfloat, c u64) Bigfloat {
	a := f_new()
	C.mpf_sub_ui (&a, &b, c)
	return a 
}

// #define mpf_swap __gmpf_swap
fn C.mpf_swap (&Bigfloat, &Bigfloat)

pub fn f_swap (mut a Bigfloat, mut b Bigfloat) {
	C.mpf_swap (&a, &b)
}

// #define mpf_trunc __gmpf_trunc
fn C.mpf_trunc (&Bigfloat, &Bigfloat)

pub fn f_trunc (b Bigfloat) Bigfloat {
	a := f_new()
	C.mpf_trunc (&a, &b)
	return a 
}

// #define mpf_ui_div __gmpf_ui_div
fn C.mpf_ui_div (&Bigfloat, u64, &Bigfloat)

pub fn f_ui_div (b u64, c Bigfloat) Bigfloat {
	a := f_new()
	C.mpf_ui_div (&a, b, &c)
	return a 
}

// #define mpf_ui_sub __gmpf_ui_sub
fn C.mpf_ui_sub (&Bigfloat, u64, &Bigfloat)

pub fn f_ui_sub (a u64, b Bigfloat) Bigfloat {
	r := f_new()
	C.mpf_ui_sub (&r, a, &b)
	return r 
}

// #define mpf_urandomb __gmpf_urandomb
fn C.mpf_urandomb (&Bigfloat, &Randstate, u64)

pub fn f_urandomb (mut rnd_st Randstate, b u64) Bigfloat {
	r := f_new()
	C.mpf_urandomb (&r, &rnd_st, b)
	return r 
}
