# v_gmp
## Porting of gmp multiprecision library to the V programming language (vlang)
Module for [V (Vlang)](https://vlang.io/) with most of the bindings of [gmp](https://gmplib.org/).

The suffix for the V types of numerical have been renamed according to the V names. The endings in _ui _si and _d are _u64 _i64 and _f64.

The conversion routines begin with from_ and the output routines are member functions: .i64() .u64() .f64() and .str().
This last routine get a 10-base representation. For the original mpz_get_str() there is .str_base(base int).

The operators + - * / % have been overloaded.

### Installation ###
Install the GMP on your system (for the libgmp.a file).

Create a gmp directory in your .vmodules and copy in it the gmp.v and *.h files.
These header files have been patched for tcc and are necessary.

### To do ###
Porting of Bigfloat and Bigrational of GMP
