// This file is dual licensed under the MIT and the University of Illinois Open
// Source Licenses. See LICENSE.TXT for details.

#include "assembly.h"

// long double __floatundixf(du_int a);16

#ifdef __i386__

#ifndef __ELF__
.const
#endif
.balign 4
twop52: .quad 0x4330000000000000
twop84_plus_twop52_neg:
		.quad 0xc530000000100000
twop84: .quad 0x4530000000000000

#define REL_ADDR(_a)	(_a)-0b(%eax)

.text
.balign 4
DEFINE_COMPILERRT_FUNCTION(__floatundixf)
	calll	0f
0:	popl	%eax
	movss	8(%esp),			%xmm0	// hi 32 bits of input
	movss	4(%esp),			%xmm1	// lo 32 bits of input
	orpd	REL_ADDR(twop84),	%xmm0	// 2^84 + hi (as a double)
	orpd	REL_ADDR(twop52),	%xmm1	// 2^52 + lo (as a double)
	addsd	REL_ADDR(twop84_plus_twop52_neg),	%xmm0	// hi - 2^52 (no rounding occurs)
	movsd	%xmm1,				4(%esp)
	fldl	4(%esp)
	movsd	%xmm0,				4(%esp)
	faddl	4(%esp)
	ret
END_COMPILERRT_FUNCTION(__floatundixf)

#endif // __i386__
