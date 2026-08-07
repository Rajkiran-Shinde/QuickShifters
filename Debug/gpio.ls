   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 139                     ; 4 void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin)
 139                     ; 5 {
 141                     	switch	.text
 142  0000               _GPIO_Output_PP:
 144  0000 89            	pushw	x
 145       00000000      OFST:	set	0
 148                     ; 6     PD_DDR |= (1<<pin);
 150  0001 9f            	ld	a,xl
 151  0002 5f            	clrw	x
 152  0003 97            	ld	xl,a
 153  0004 a601          	ld	a,#1
 154  0006 5d            	tnzw	x
 155  0007 2704          	jreq	L6
 156  0009               L01:
 157  0009 48            	sll	a
 158  000a 5a            	decw	x
 159  000b 26fc          	jrne	L01
 160  000d               L6:
 161  000d ca5011        	or	a,20497
 162  0010 c75011        	ld	20497,a
 163                     ; 7     PD_CR1 |= (1<<pin);
 165  0013 7b02          	ld	a,(OFST+2,sp)
 166  0015 5f            	clrw	x
 167  0016 97            	ld	xl,a
 168  0017 a601          	ld	a,#1
 169  0019 5d            	tnzw	x
 170  001a 2704          	jreq	L21
 171  001c               L41:
 172  001c 48            	sll	a
 173  001d 5a            	decw	x
 174  001e 26fc          	jrne	L41
 175  0020               L21:
 176  0020 ca5012        	or	a,20498
 177  0023 c75012        	ld	20498,a
 178                     ; 8     PD_CR2 &= ~(1<<pin);
 180  0026 7b02          	ld	a,(OFST+2,sp)
 181  0028 5f            	clrw	x
 182  0029 97            	ld	xl,a
 183  002a a601          	ld	a,#1
 184  002c 5d            	tnzw	x
 185  002d 2704          	jreq	L61
 186  002f               L02:
 187  002f 48            	sll	a
 188  0030 5a            	decw	x
 189  0031 26fc          	jrne	L02
 190  0033               L61:
 191  0033 43            	cpl	a
 192  0034 c45013        	and	a,20499
 193  0037 c75013        	ld	20499,a
 194                     ; 9 }
 197  003a 85            	popw	x
 198  003b 81            	ret
 243                     ; 11 void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin)
 243                     ; 12 {
 244                     	switch	.text
 245  003c               _GPIO_Input_PU:
 247  003c 89            	pushw	x
 248       00000000      OFST:	set	0
 251                     ; 13     PD_DDR &= ~(1<<pin);
 253  003d 9f            	ld	a,xl
 254  003e 5f            	clrw	x
 255  003f 97            	ld	xl,a
 256  0040 a601          	ld	a,#1
 257  0042 5d            	tnzw	x
 258  0043 2704          	jreq	L42
 259  0045               L62:
 260  0045 48            	sll	a
 261  0046 5a            	decw	x
 262  0047 26fc          	jrne	L62
 263  0049               L42:
 264  0049 43            	cpl	a
 265  004a c45011        	and	a,20497
 266  004d c75011        	ld	20497,a
 267                     ; 14     PD_CR1 |= (1<<pin);
 269  0050 7b02          	ld	a,(OFST+2,sp)
 270  0052 5f            	clrw	x
 271  0053 97            	ld	xl,a
 272  0054 a601          	ld	a,#1
 273  0056 5d            	tnzw	x
 274  0057 2704          	jreq	L03
 275  0059               L23:
 276  0059 48            	sll	a
 277  005a 5a            	decw	x
 278  005b 26fc          	jrne	L23
 279  005d               L03:
 280  005d ca5012        	or	a,20498
 281  0060 c75012        	ld	20498,a
 282                     ; 15     PD_CR2 &= ~(1<<pin);
 284  0063 7b02          	ld	a,(OFST+2,sp)
 285  0065 5f            	clrw	x
 286  0066 97            	ld	xl,a
 287  0067 a601          	ld	a,#1
 288  0069 5d            	tnzw	x
 289  006a 2704          	jreq	L43
 290  006c               L63:
 291  006c 48            	sll	a
 292  006d 5a            	decw	x
 293  006e 26fc          	jrne	L63
 294  0070               L43:
 295  0070 43            	cpl	a
 296  0071 c45013        	and	a,20499
 297  0074 c75013        	ld	20499,a
 298                     ; 16 }
 301  0077 85            	popw	x
 302  0078 81            	ret
 347                     ; 18 void GPIO_Set(GPIO_Port port, GPIO_Pin pin)
 347                     ; 19 {
 348                     	switch	.text
 349  0079               _GPIO_Set:
 353                     ; 20     PD_ODR |= (1<<pin);
 355  0079 9f            	ld	a,xl
 356  007a 5f            	clrw	x
 357  007b 97            	ld	xl,a
 358  007c a601          	ld	a,#1
 359  007e 5d            	tnzw	x
 360  007f 2704          	jreq	L24
 361  0081               L44:
 362  0081 48            	sll	a
 363  0082 5a            	decw	x
 364  0083 26fc          	jrne	L44
 365  0085               L24:
 366  0085 ca500f        	or	a,20495
 367  0088 c7500f        	ld	20495,a
 368                     ; 21 }
 371  008b 81            	ret
 416                     ; 23 void GPIO_Clear(GPIO_Port port, GPIO_Pin pin)
 416                     ; 24 {
 417                     	switch	.text
 418  008c               _GPIO_Clear:
 422                     ; 25     PD_ODR &= ~(1<<pin);
 424  008c 9f            	ld	a,xl
 425  008d 5f            	clrw	x
 426  008e 97            	ld	xl,a
 427  008f a601          	ld	a,#1
 428  0091 5d            	tnzw	x
 429  0092 2704          	jreq	L05
 430  0094               L25:
 431  0094 48            	sll	a
 432  0095 5a            	decw	x
 433  0096 26fc          	jrne	L25
 434  0098               L05:
 435  0098 43            	cpl	a
 436  0099 c4500f        	and	a,20495
 437  009c c7500f        	ld	20495,a
 438                     ; 26 }
 441  009f 81            	ret
 486                     ; 28 void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin)
 486                     ; 29 {
 487                     	switch	.text
 488  00a0               _GPIO_Toggle:
 492                     ; 30     PD_ODR ^= (1<<pin);
 494  00a0 9f            	ld	a,xl
 495  00a1 5f            	clrw	x
 496  00a2 97            	ld	xl,a
 497  00a3 a601          	ld	a,#1
 498  00a5 5d            	tnzw	x
 499  00a6 2704          	jreq	L65
 500  00a8               L06:
 501  00a8 48            	sll	a
 502  00a9 5a            	decw	x
 503  00aa 26fc          	jrne	L06
 504  00ac               L65:
 505  00ac c8500f        	xor	a,20495
 506  00af c7500f        	ld	20495,a
 507                     ; 31 }
 510  00b2 81            	ret
 555                     ; 33 uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin)
 555                     ; 34 {
 556                     	switch	.text
 557  00b3               _GPIO_Read:
 559  00b3 89            	pushw	x
 560  00b4 89            	pushw	x
 561       00000002      OFST:	set	2
 564                     ; 35     return (PD_IDR & (1<<pin)) ? TRUE : FALSE;
 566  00b5 c65010        	ld	a,20496
 567  00b8 5f            	clrw	x
 568  00b9 97            	ld	xl,a
 569  00ba 1f01          	ldw	(OFST-1,sp),x
 571  00bc ae0001        	ldw	x,#1
 572  00bf 7b04          	ld	a,(OFST+2,sp)
 573  00c1 4d            	tnz	a
 574  00c2 2704          	jreq	L66
 575  00c4               L07:
 576  00c4 58            	sllw	x
 577  00c5 4a            	dec	a
 578  00c6 26fc          	jrne	L07
 579  00c8               L66:
 580  00c8 01            	rrwa	x,a
 581  00c9 1402          	and	a,(OFST+0,sp)
 582  00cb 01            	rrwa	x,a
 583  00cc 1401          	and	a,(OFST-1,sp)
 584  00ce 01            	rrwa	x,a
 585  00cf a30000        	cpw	x,#0
 586  00d2 2704          	jreq	L46
 587  00d4 a601          	ld	a,#1
 588  00d6 2001          	jra	L27
 589  00d8               L46:
 590  00d8 4f            	clr	a
 591  00d9               L27:
 594  00d9 5b04          	addw	sp,#4
 595  00db 81            	ret
 608                     	xdef	_GPIO_Read
 609                     	xdef	_GPIO_Toggle
 610                     	xdef	_GPIO_Clear
 611                     	xdef	_GPIO_Set
 612                     	xdef	_GPIO_Input_PU
 613                     	xdef	_GPIO_Output_PP
 632                     	end
