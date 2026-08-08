   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 13 void Debug_Init(void)
  44                     ; 14 {
  46                     	switch	.text
  47  0000               _Debug_Init:
  51                     ; 15     UART_Init();
  53  0000 cd0000        	call	_UART_Init
  55                     ; 17     Debug_Log("\r\n");
  57  0003 ae00cd        	ldw	x,#L12
  58  0006 ad10          	call	_Debug_Log
  60                     ; 18     Debug_Log("================================\r\n");
  62  0008 ae00aa        	ldw	x,#L32
  63  000b ad0b          	call	_Debug_Log
  65                     ; 19     Debug_Log(" QuickShifter Debug Console\r\n");
  67  000d ae008c        	ldw	x,#L52
  68  0010 ad06          	call	_Debug_Log
  70                     ; 20     Debug_Log("================================\r\n");
  72  0012 ae00aa        	ldw	x,#L32
  73  0015 ad01          	call	_Debug_Log
  75                     ; 21 }
  78  0017 81            	ret
 114                     ; 28 void Debug_Log(const char *message)
 114                     ; 29 {
 115                     	switch	.text
 116  0018               _Debug_Log:
 120                     ; 30     UART_SendString(message);
 122  0018 cd0000        	call	_UART_SendString
 124                     ; 31 }
 127  001b 81            	ret
 130                     .const:	section	.text
 131  0000               L54_hex:
 132  0000 303132333435  	dc.b	"0123456789ABCDEF",0
 175                     ; 33 void Debug_LogHex(uint8_t value)
 175                     ; 34 {
 176                     	switch	.text
 177  001c               _Debug_LogHex:
 179  001c 88            	push	a
 180  001d 5213          	subw	sp,#19
 181       00000013      OFST:	set	19
 184                     ; 35     char hex[] = "0123456789ABCDEF";
 186  001f 96            	ldw	x,sp
 187  0020 1c0003        	addw	x,#OFST-16
 188  0023 90ae0000      	ldw	y,#L54_hex
 189  0027 a611          	ld	a,#17
 190  0029 cd0000        	call	c_xymov
 192                     ; 37     UART_SendChar(hex[(value >> 4) & 0x0F]);
 194  002c 96            	ldw	x,sp
 195  002d 1c0003        	addw	x,#OFST-16
 196  0030 1f01          	ldw	(OFST-18,sp),x
 198  0032 7b14          	ld	a,(OFST+1,sp)
 199  0034 4e            	swap	a
 200  0035 a40f          	and	a,#15
 201  0037 5f            	clrw	x
 202  0038 97            	ld	xl,a
 203  0039 72fb01        	addw	x,(OFST-18,sp)
 204  003c f6            	ld	a,(x)
 205  003d cd0000        	call	_UART_SendChar
 207                     ; 38     UART_SendChar(hex[value & 0x0F]);
 209  0040 96            	ldw	x,sp
 210  0041 1c0003        	addw	x,#OFST-16
 211  0044 1f01          	ldw	(OFST-18,sp),x
 213  0046 7b14          	ld	a,(OFST+1,sp)
 214  0048 a40f          	and	a,#15
 215  004a 5f            	clrw	x
 216  004b 97            	ld	xl,a
 217  004c 72fb01        	addw	x,(OFST-18,sp)
 218  004f f6            	ld	a,(x)
 219  0050 cd0000        	call	_UART_SendChar
 221                     ; 39 }
 224  0053 5b14          	addw	sp,#20
 225  0055 81            	ret
 279                     ; 41 void Debug_LogDecimal(uint8_t value)
 279                     ; 42 {
 280                     	switch	.text
 281  0056               _Debug_LogDecimal:
 283  0056 88            	push	a
 284  0057 5207          	subw	sp,#7
 285       00000007      OFST:	set	7
 288                     ; 44     uint8_t i = 0;
 290  0059 0f07          	clr	(OFST+0,sp)
 292                     ; 46     if(value >= 100)
 294  005b a164          	cp	a,#100
 295  005d 2573          	jrult	L711
 296                     ; 48         buffer[i++] = '0' + (value / 100);
 298  005f 96            	ldw	x,sp
 299  0060 1c0003        	addw	x,#OFST-4
 300  0063 1f01          	ldw	(OFST-6,sp),x
 302  0065 7b07          	ld	a,(OFST+0,sp)
 303  0067 97            	ld	xl,a
 304  0068 0c07          	inc	(OFST+0,sp)
 306  006a 9f            	ld	a,xl
 307  006b 5f            	clrw	x
 308  006c 97            	ld	xl,a
 309  006d 72fb01        	addw	x,(OFST-6,sp)
 310  0070 7b08          	ld	a,(OFST+1,sp)
 311  0072 905f          	clrw	y
 312  0074 9097          	ld	yl,a
 313  0076 a664          	ld	a,#100
 314  0078 9062          	div	y,a
 315  007a 909f          	ld	a,yl
 316  007c ab30          	add	a,#48
 317  007e f7            	ld	(x),a
 318                     ; 49         value = value % 100;
 320  007f 7b08          	ld	a,(OFST+1,sp)
 321  0081 5f            	clrw	x
 322  0082 97            	ld	xl,a
 323  0083 a664          	ld	a,#100
 324  0085 62            	div	x,a
 325  0086 5f            	clrw	x
 326  0087 97            	ld	xl,a
 327  0088 01            	rrwa	x,a
 328  0089 6b08          	ld	(OFST+1,sp),a
 329  008b 02            	rlwa	x,a
 330                     ; 51         buffer[i++] = '0' + (value / 10);
 332  008c 96            	ldw	x,sp
 333  008d 1c0003        	addw	x,#OFST-4
 334  0090 1f01          	ldw	(OFST-6,sp),x
 336  0092 7b07          	ld	a,(OFST+0,sp)
 337  0094 97            	ld	xl,a
 338  0095 0c07          	inc	(OFST+0,sp)
 340  0097 9f            	ld	a,xl
 341  0098 5f            	clrw	x
 342  0099 97            	ld	xl,a
 343  009a 72fb01        	addw	x,(OFST-6,sp)
 344  009d 7b08          	ld	a,(OFST+1,sp)
 345  009f 905f          	clrw	y
 346  00a1 9097          	ld	yl,a
 347  00a3 a60a          	ld	a,#10
 348  00a5 9062          	div	y,a
 349  00a7 909f          	ld	a,yl
 350  00a9 ab30          	add	a,#48
 351  00ab f7            	ld	(x),a
 352                     ; 52         buffer[i++] = '0' + (value % 10);
 354  00ac 96            	ldw	x,sp
 355  00ad 1c0003        	addw	x,#OFST-4
 356  00b0 1f01          	ldw	(OFST-6,sp),x
 358  00b2 7b07          	ld	a,(OFST+0,sp)
 359  00b4 97            	ld	xl,a
 360  00b5 0c07          	inc	(OFST+0,sp)
 362  00b7 9f            	ld	a,xl
 363  00b8 5f            	clrw	x
 364  00b9 97            	ld	xl,a
 365  00ba 72fb01        	addw	x,(OFST-6,sp)
 366  00bd 7b08          	ld	a,(OFST+1,sp)
 367  00bf 905f          	clrw	y
 368  00c1 9097          	ld	yl,a
 369  00c3 a60a          	ld	a,#10
 370  00c5 9062          	div	y,a
 371  00c7 905f          	clrw	y
 372  00c9 9097          	ld	yl,a
 373  00cb 909f          	ld	a,yl
 374  00cd ab30          	add	a,#48
 375  00cf f7            	ld	(x),a
 377  00d0 2062          	jra	L121
 378  00d2               L711:
 379                     ; 54     else if(value >= 10)
 381  00d2 7b08          	ld	a,(OFST+1,sp)
 382  00d4 a10a          	cp	a,#10
 383  00d6 2546          	jrult	L321
 384                     ; 56         buffer[i++] = '0' + (value / 10);
 386  00d8 96            	ldw	x,sp
 387  00d9 1c0003        	addw	x,#OFST-4
 388  00dc 1f01          	ldw	(OFST-6,sp),x
 390  00de 7b07          	ld	a,(OFST+0,sp)
 391  00e0 97            	ld	xl,a
 392  00e1 0c07          	inc	(OFST+0,sp)
 394  00e3 9f            	ld	a,xl
 395  00e4 5f            	clrw	x
 396  00e5 97            	ld	xl,a
 397  00e6 72fb01        	addw	x,(OFST-6,sp)
 398  00e9 7b08          	ld	a,(OFST+1,sp)
 399  00eb 905f          	clrw	y
 400  00ed 9097          	ld	yl,a
 401  00ef a60a          	ld	a,#10
 402  00f1 9062          	div	y,a
 403  00f3 909f          	ld	a,yl
 404  00f5 ab30          	add	a,#48
 405  00f7 f7            	ld	(x),a
 406                     ; 57         buffer[i++] = '0' + (value % 10);
 408  00f8 96            	ldw	x,sp
 409  00f9 1c0003        	addw	x,#OFST-4
 410  00fc 1f01          	ldw	(OFST-6,sp),x
 412  00fe 7b07          	ld	a,(OFST+0,sp)
 413  0100 97            	ld	xl,a
 414  0101 0c07          	inc	(OFST+0,sp)
 416  0103 9f            	ld	a,xl
 417  0104 5f            	clrw	x
 418  0105 97            	ld	xl,a
 419  0106 72fb01        	addw	x,(OFST-6,sp)
 420  0109 7b08          	ld	a,(OFST+1,sp)
 421  010b 905f          	clrw	y
 422  010d 9097          	ld	yl,a
 423  010f a60a          	ld	a,#10
 424  0111 9062          	div	y,a
 425  0113 905f          	clrw	y
 426  0115 9097          	ld	yl,a
 427  0117 909f          	ld	a,yl
 428  0119 ab30          	add	a,#48
 429  011b f7            	ld	(x),a
 431  011c 2016          	jra	L121
 432  011e               L321:
 433                     ; 61         buffer[i++] = '0' + value;
 435  011e 96            	ldw	x,sp
 436  011f 1c0003        	addw	x,#OFST-4
 437  0122 1f01          	ldw	(OFST-6,sp),x
 439  0124 7b07          	ld	a,(OFST+0,sp)
 440  0126 97            	ld	xl,a
 441  0127 0c07          	inc	(OFST+0,sp)
 443  0129 9f            	ld	a,xl
 444  012a 5f            	clrw	x
 445  012b 97            	ld	xl,a
 446  012c 72fb01        	addw	x,(OFST-6,sp)
 447  012f 7b08          	ld	a,(OFST+1,sp)
 448  0131 ab30          	add	a,#48
 449  0133 f7            	ld	(x),a
 450  0134               L121:
 451                     ; 64     buffer[i] = '\0';
 453  0134 96            	ldw	x,sp
 454  0135 1c0003        	addw	x,#OFST-4
 455  0138 9f            	ld	a,xl
 456  0139 5e            	swapw	x
 457  013a 1b07          	add	a,(OFST+0,sp)
 458  013c 2401          	jrnc	L41
 459  013e 5c            	incw	x
 460  013f               L41:
 461  013f 02            	rlwa	x,a
 462  0140 7f            	clr	(x)
 463                     ; 66     Debug_Log(buffer);
 465  0141 96            	ldw	x,sp
 466  0142 1c0003        	addw	x,#OFST-4
 467  0145 cd0018        	call	_Debug_Log
 469                     ; 67 }
 472  0148 5b08          	addw	sp,#8
 473  014a 81            	ret
 508                     ; 73 void Debug_LogState(uint8_t state)
 508                     ; 74 {
 509                     	switch	.text
 510  014b               _Debug_LogState:
 514                     ; 75     switch(state)
 517                     ; 95             break;
 518  014b 4d            	tnz	a
 519  014c 2711          	jreq	L721
 520  014e 4a            	dec	a
 521  014f 2716          	jreq	L131
 522  0151 4a            	dec	a
 523  0152 271b          	jreq	L331
 524  0154 4a            	dec	a
 525  0155 2720          	jreq	L531
 526  0157               L731:
 527                     ; 93         default:
 527                     ; 94             Debug_Log("[QS] UNKNOWN STATE\r\n");
 529  0157 ae0035        	ldw	x,#L371
 530  015a cd0018        	call	_Debug_Log
 532                     ; 95             break;
 534  015d 201e          	jra	L161
 535  015f               L721:
 536                     ; 77         case 0:
 536                     ; 78             Debug_Log("[QS] IDLE\r\n");
 538  015f ae0080        	ldw	x,#L361
 539  0162 cd0018        	call	_Debug_Log
 541                     ; 79             break;
 543  0165 2016          	jra	L161
 544  0167               L131:
 545                     ; 81         case 1:
 545                     ; 82             Debug_Log("[QS] CUT_ACTIVE\r\n");
 547  0167 ae006e        	ldw	x,#L561
 548  016a cd0018        	call	_Debug_Log
 550                     ; 83             break;
 552  016d 200e          	jra	L161
 553  016f               L331:
 554                     ; 85         case 2:
 554                     ; 86             Debug_Log("[QS] COOLDOWN\r\n");
 556  016f ae005e        	ldw	x,#L761
 557  0172 cd0018        	call	_Debug_Log
 559                     ; 87             break;
 561  0175 2006          	jra	L161
 562  0177               L531:
 563                     ; 89         case 3:
 563                     ; 90             Debug_Log("[QS] WAIT_RELEASE\r\n");
 565  0177 ae004a        	ldw	x,#L171
 566  017a cd0018        	call	_Debug_Log
 568                     ; 91             break;
 570  017d               L161:
 571                     ; 97 }
 574  017d 81            	ret
 619                     ; 104 void Debug_LogMode(uint8_t mode, uint16_t cut_time)
 619                     ; 105 {
 620                     	switch	.text
 621  017e               _Debug_LogMode:
 623  017e 88            	push	a
 624       00000000      OFST:	set	0
 627                     ; 106     Debug_Log("[MODE] ");
 629  017f ae002d        	ldw	x,#L712
 630  0182 cd0018        	call	_Debug_Log
 632                     ; 108     UART_SendChar('1' + mode);
 634  0185 7b01          	ld	a,(OFST+1,sp)
 635  0187 ab31          	add	a,#49
 636  0189 cd0000        	call	_UART_SendChar
 638                     ; 110     Debug_Log(" | CUT = ");
 640  018c ae0023        	ldw	x,#L122
 641  018f cd0018        	call	_Debug_Log
 643                     ; 112     if(cut_time >= 100)
 645  0192 1e04          	ldw	x,(OFST+4,sp)
 646  0194 a30064        	cpw	x,#100
 647  0197 2515          	jrult	L322
 648                     ; 114         UART_SendChar('0' + (cut_time / 100));
 650  0199 1e04          	ldw	x,(OFST+4,sp)
 651  019b a664          	ld	a,#100
 652  019d 62            	div	x,a
 653  019e 1c0030        	addw	x,#48
 654  01a1 9f            	ld	a,xl
 655  01a2 cd0000        	call	_UART_SendChar
 657                     ; 116         cut_time = cut_time % 100;
 659  01a5 1e04          	ldw	x,(OFST+4,sp)
 660  01a7 a664          	ld	a,#100
 661  01a9 62            	div	x,a
 662  01aa 5f            	clrw	x
 663  01ab 97            	ld	xl,a
 664  01ac 1f04          	ldw	(OFST+4,sp),x
 665  01ae               L322:
 666                     ; 119     UART_SendChar('0' + (cut_time / 10));
 668  01ae 1e04          	ldw	x,(OFST+4,sp)
 669  01b0 a60a          	ld	a,#10
 670  01b2 62            	div	x,a
 671  01b3 1c0030        	addw	x,#48
 672  01b6 9f            	ld	a,xl
 673  01b7 cd0000        	call	_UART_SendChar
 675                     ; 121     UART_SendChar('0' + (cut_time % 10));
 677  01ba 1e04          	ldw	x,(OFST+4,sp)
 678  01bc a60a          	ld	a,#10
 679  01be 62            	div	x,a
 680  01bf 5f            	clrw	x
 681  01c0 97            	ld	xl,a
 682  01c1 1c0030        	addw	x,#48
 683  01c4 9f            	ld	a,xl
 684  01c5 cd0000        	call	_UART_SendChar
 686                     ; 123     Debug_Log(" ms\r\n");
 688  01c8 ae001d        	ldw	x,#L522
 689  01cb cd0018        	call	_Debug_Log
 691                     ; 124 }
 694  01ce 84            	pop	a
 695  01cf 81            	ret
 731                     ; 131 void Debug_LogShift(uint16_t shift_time)
 731                     ; 132 {
 732                     	switch	.text
 733  01d0               _Debug_LogShift:
 735  01d0 89            	pushw	x
 736       00000000      OFST:	set	0
 739                     ; 133     Debug_Log("[QS] CUT = ");
 741  01d1 ae0011        	ldw	x,#L542
 742  01d4 cd0018        	call	_Debug_Log
 744                     ; 135     if(shift_time >= 100)
 746  01d7 1e01          	ldw	x,(OFST+1,sp)
 747  01d9 a30064        	cpw	x,#100
 748  01dc 2515          	jrult	L742
 749                     ; 137         UART_SendChar('0' + (shift_time / 100));
 751  01de 1e01          	ldw	x,(OFST+1,sp)
 752  01e0 a664          	ld	a,#100
 753  01e2 62            	div	x,a
 754  01e3 1c0030        	addw	x,#48
 755  01e6 9f            	ld	a,xl
 756  01e7 cd0000        	call	_UART_SendChar
 758                     ; 139         shift_time = shift_time % 100;
 760  01ea 1e01          	ldw	x,(OFST+1,sp)
 761  01ec a664          	ld	a,#100
 762  01ee 62            	div	x,a
 763  01ef 5f            	clrw	x
 764  01f0 97            	ld	xl,a
 765  01f1 1f01          	ldw	(OFST+1,sp),x
 766  01f3               L742:
 767                     ; 142     UART_SendChar('0' + (shift_time / 10));
 769  01f3 1e01          	ldw	x,(OFST+1,sp)
 770  01f5 a60a          	ld	a,#10
 771  01f7 62            	div	x,a
 772  01f8 1c0030        	addw	x,#48
 773  01fb 9f            	ld	a,xl
 774  01fc cd0000        	call	_UART_SendChar
 776                     ; 144     UART_SendChar('0' + (shift_time % 10));
 778  01ff 1e01          	ldw	x,(OFST+1,sp)
 779  0201 a60a          	ld	a,#10
 780  0203 62            	div	x,a
 781  0204 5f            	clrw	x
 782  0205 97            	ld	xl,a
 783  0206 1c0030        	addw	x,#48
 784  0209 9f            	ld	a,xl
 785  020a cd0000        	call	_UART_SendChar
 787                     ; 146     Debug_Log(" ms\r\n");
 789  020d ae001d        	ldw	x,#L522
 790  0210 cd0018        	call	_Debug_Log
 792                     ; 147 }
 795  0213 85            	popw	x
 796  0214 81            	ret
 809                     	xref	_UART_SendString
 810                     	xref	_UART_SendChar
 811                     	xref	_UART_Init
 812                     	xdef	_Debug_LogMode
 813                     	xdef	_Debug_LogShift
 814                     	xdef	_Debug_LogState
 815                     	xdef	_Debug_LogDecimal
 816                     	xdef	_Debug_LogHex
 817                     	xdef	_Debug_Log
 818                     	xdef	_Debug_Init
 819                     	switch	.const
 820  0011               L542:
 821  0011 5b51535d2043  	dc.b	"[QS] CUT = ",0
 822  001d               L522:
 823  001d 206d730d      	dc.b	" ms",13
 824  0021 0a00          	dc.b	10,0
 825  0023               L122:
 826  0023 207c20435554  	dc.b	" | CUT = ",0
 827  002d               L712:
 828  002d 5b4d4f44455d  	dc.b	"[MODE] ",0
 829  0035               L371:
 830  0035 5b51535d2055  	dc.b	"[QS] UNKNOWN STATE"
 831  0047 0d0a00        	dc.b	13,10,0
 832  004a               L171:
 833  004a 5b51535d2057  	dc.b	"[QS] WAIT_RELEASE",13
 834  005c 0a00          	dc.b	10,0
 835  005e               L761:
 836  005e 5b51535d2043  	dc.b	"[QS] COOLDOWN",13
 837  006c 0a00          	dc.b	10,0
 838  006e               L561:
 839  006e 5b51535d2043  	dc.b	"[QS] CUT_ACTIVE",13
 840  007e 0a00          	dc.b	10,0
 841  0080               L361:
 842  0080 5b51535d2049  	dc.b	"[QS] IDLE",13
 843  008a 0a00          	dc.b	10,0
 844  008c               L52:
 845  008c 20517569636b  	dc.b	" QuickShifter Debu"
 846  009e 6720436f6e73  	dc.b	"g Console",13
 847  00a8 0a00          	dc.b	10,0
 848  00aa               L32:
 849  00aa 3d3d3d3d3d3d  	dc.b	"=================="
 850  00bc 3d3d3d3d3d3d  	dc.b	"==============",13
 851  00cb 0a00          	dc.b	10,0
 852  00cd               L12:
 853  00cd 0d0a00        	dc.b	13,10,0
 854                     	xref.b	c_x
 874                     	xref	c_xymov
 875                     	end
