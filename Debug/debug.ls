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
  57  0003 ae00bc        	ldw	x,#L12
  58  0006 ad10          	call	_Debug_Log
  60                     ; 18     Debug_Log("================================\r\n");
  62  0008 ae0099        	ldw	x,#L32
  63  000b ad0b          	call	_Debug_Log
  65                     ; 19     Debug_Log(" QuickShifter Debug Console\r\n");
  67  000d ae007b        	ldw	x,#L52
  68  0010 ad06          	call	_Debug_Log
  70                     ; 20     Debug_Log("================================\r\n");
  72  0012 ae0099        	ldw	x,#L32
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
 162                     ; 38 void Debug_LogState(uint8_t state)
 162                     ; 39 {
 163                     	switch	.text
 164  001c               _Debug_LogState:
 168                     ; 40     switch(state)
 171                     ; 60             break;
 172  001c 4d            	tnz	a
 173  001d 2710          	jreq	L54
 174  001f 4a            	dec	a
 175  0020 2714          	jreq	L74
 176  0022 4a            	dec	a
 177  0023 2718          	jreq	L15
 178  0025 4a            	dec	a
 179  0026 271c          	jreq	L35
 180  0028               L55:
 181                     ; 58         default:
 181                     ; 59             Debug_Log("[QS] UNKNOWN STATE\r\n");
 183  0028 ae0024        	ldw	x,#L111
 184  002b adeb          	call	_Debug_Log
 186                     ; 60             break;
 188  002d 201a          	jra	L77
 189  002f               L54:
 190                     ; 42         case 0:
 190                     ; 43             Debug_Log("[QS] IDLE\r\n");
 192  002f ae006f        	ldw	x,#L101
 193  0032 ade4          	call	_Debug_Log
 195                     ; 44             break;
 197  0034 2013          	jra	L77
 198  0036               L74:
 199                     ; 46         case 1:
 199                     ; 47             Debug_Log("[QS] CUT_ACTIVE\r\n");
 201  0036 ae005d        	ldw	x,#L301
 202  0039 addd          	call	_Debug_Log
 204                     ; 48             break;
 206  003b 200c          	jra	L77
 207  003d               L15:
 208                     ; 50         case 2:
 208                     ; 51             Debug_Log("[QS] COOLDOWN\r\n");
 210  003d ae004d        	ldw	x,#L501
 211  0040 add6          	call	_Debug_Log
 213                     ; 52             break;
 215  0042 2005          	jra	L77
 216  0044               L35:
 217                     ; 54         case 3:
 217                     ; 55             Debug_Log("[QS] WAIT_RELEASE\r\n");
 219  0044 ae0039        	ldw	x,#L701
 220  0047 adcf          	call	_Debug_Log
 222                     ; 56             break;
 224  0049               L77:
 225                     ; 62 }
 228  0049 81            	ret
 273                     ; 69 void Debug_LogMode(uint8_t mode, uint16_t cut_time)
 273                     ; 70 {
 274                     	switch	.text
 275  004a               _Debug_LogMode:
 277  004a 88            	push	a
 278       00000000      OFST:	set	0
 281                     ; 71     Debug_Log("[MODE] ");
 283  004b ae001c        	ldw	x,#L531
 284  004e adc8          	call	_Debug_Log
 286                     ; 73     UART_SendChar('1' + mode);
 288  0050 7b01          	ld	a,(OFST+1,sp)
 289  0052 ab31          	add	a,#49
 290  0054 cd0000        	call	_UART_SendChar
 292                     ; 75     Debug_Log(" | CUT = ");
 294  0057 ae0012        	ldw	x,#L731
 295  005a adbc          	call	_Debug_Log
 297                     ; 77     if(cut_time >= 100)
 299  005c 1e04          	ldw	x,(OFST+4,sp)
 300  005e a30064        	cpw	x,#100
 301  0061 2515          	jrult	L141
 302                     ; 79         UART_SendChar('0' + (cut_time / 100));
 304  0063 1e04          	ldw	x,(OFST+4,sp)
 305  0065 a664          	ld	a,#100
 306  0067 62            	div	x,a
 307  0068 1c0030        	addw	x,#48
 308  006b 9f            	ld	a,xl
 309  006c cd0000        	call	_UART_SendChar
 311                     ; 81         cut_time = cut_time % 100;
 313  006f 1e04          	ldw	x,(OFST+4,sp)
 314  0071 a664          	ld	a,#100
 315  0073 62            	div	x,a
 316  0074 5f            	clrw	x
 317  0075 97            	ld	xl,a
 318  0076 1f04          	ldw	(OFST+4,sp),x
 319  0078               L141:
 320                     ; 84     UART_SendChar('0' + (cut_time / 10));
 322  0078 1e04          	ldw	x,(OFST+4,sp)
 323  007a a60a          	ld	a,#10
 324  007c 62            	div	x,a
 325  007d 1c0030        	addw	x,#48
 326  0080 9f            	ld	a,xl
 327  0081 cd0000        	call	_UART_SendChar
 329                     ; 86     UART_SendChar('0' + (cut_time % 10));
 331  0084 1e04          	ldw	x,(OFST+4,sp)
 332  0086 a60a          	ld	a,#10
 333  0088 62            	div	x,a
 334  0089 5f            	clrw	x
 335  008a 97            	ld	xl,a
 336  008b 1c0030        	addw	x,#48
 337  008e 9f            	ld	a,xl
 338  008f cd0000        	call	_UART_SendChar
 340                     ; 88     Debug_Log(" ms\r\n");
 342  0092 ae000c        	ldw	x,#L341
 343  0095 ad81          	call	_Debug_Log
 345                     ; 89 }
 348  0097 84            	pop	a
 349  0098 81            	ret
 385                     ; 96 void Debug_LogShift(uint16_t shift_time)
 385                     ; 97 {
 386                     	switch	.text
 387  0099               _Debug_LogShift:
 389  0099 89            	pushw	x
 390       00000000      OFST:	set	0
 393                     ; 98     Debug_Log("[QS] CUT = ");
 395  009a ae0000        	ldw	x,#L361
 396  009d cd0018        	call	_Debug_Log
 398                     ; 100     if(shift_time >= 100)
 400  00a0 1e01          	ldw	x,(OFST+1,sp)
 401  00a2 a30064        	cpw	x,#100
 402  00a5 2515          	jrult	L561
 403                     ; 102         UART_SendChar('0' + (shift_time / 100));
 405  00a7 1e01          	ldw	x,(OFST+1,sp)
 406  00a9 a664          	ld	a,#100
 407  00ab 62            	div	x,a
 408  00ac 1c0030        	addw	x,#48
 409  00af 9f            	ld	a,xl
 410  00b0 cd0000        	call	_UART_SendChar
 412                     ; 104         shift_time = shift_time % 100;
 414  00b3 1e01          	ldw	x,(OFST+1,sp)
 415  00b5 a664          	ld	a,#100
 416  00b7 62            	div	x,a
 417  00b8 5f            	clrw	x
 418  00b9 97            	ld	xl,a
 419  00ba 1f01          	ldw	(OFST+1,sp),x
 420  00bc               L561:
 421                     ; 107     UART_SendChar('0' + (shift_time / 10));
 423  00bc 1e01          	ldw	x,(OFST+1,sp)
 424  00be a60a          	ld	a,#10
 425  00c0 62            	div	x,a
 426  00c1 1c0030        	addw	x,#48
 427  00c4 9f            	ld	a,xl
 428  00c5 cd0000        	call	_UART_SendChar
 430                     ; 109     UART_SendChar('0' + (shift_time % 10));
 432  00c8 1e01          	ldw	x,(OFST+1,sp)
 433  00ca a60a          	ld	a,#10
 434  00cc 62            	div	x,a
 435  00cd 5f            	clrw	x
 436  00ce 97            	ld	xl,a
 437  00cf 1c0030        	addw	x,#48
 438  00d2 9f            	ld	a,xl
 439  00d3 cd0000        	call	_UART_SendChar
 441                     ; 111     Debug_Log(" ms\r\n");
 443  00d6 ae000c        	ldw	x,#L341
 444  00d9 cd0018        	call	_Debug_Log
 446                     ; 112 }
 449  00dc 85            	popw	x
 450  00dd 81            	ret
 463                     	xref	_UART_SendString
 464                     	xref	_UART_SendChar
 465                     	xref	_UART_Init
 466                     	xdef	_Debug_LogMode
 467                     	xdef	_Debug_LogShift
 468                     	xdef	_Debug_LogState
 469                     	xdef	_Debug_Log
 470                     	xdef	_Debug_Init
 471                     .const:	section	.text
 472  0000               L361:
 473  0000 5b51535d2043  	dc.b	"[QS] CUT = ",0
 474  000c               L341:
 475  000c 206d730d      	dc.b	" ms",13
 476  0010 0a00          	dc.b	10,0
 477  0012               L731:
 478  0012 207c20435554  	dc.b	" | CUT = ",0
 479  001c               L531:
 480  001c 5b4d4f44455d  	dc.b	"[MODE] ",0
 481  0024               L111:
 482  0024 5b51535d2055  	dc.b	"[QS] UNKNOWN STATE"
 483  0036 0d0a00        	dc.b	13,10,0
 484  0039               L701:
 485  0039 5b51535d2057  	dc.b	"[QS] WAIT_RELEASE",13
 486  004b 0a00          	dc.b	10,0
 487  004d               L501:
 488  004d 5b51535d2043  	dc.b	"[QS] COOLDOWN",13
 489  005b 0a00          	dc.b	10,0
 490  005d               L301:
 491  005d 5b51535d2043  	dc.b	"[QS] CUT_ACTIVE",13
 492  006d 0a00          	dc.b	10,0
 493  006f               L101:
 494  006f 5b51535d2049  	dc.b	"[QS] IDLE",13
 495  0079 0a00          	dc.b	10,0
 496  007b               L52:
 497  007b 20517569636b  	dc.b	" QuickShifter Debu"
 498  008d 6720436f6e73  	dc.b	"g Console",13
 499  0097 0a00          	dc.b	10,0
 500  0099               L32:
 501  0099 3d3d3d3d3d3d  	dc.b	"=================="
 502  00ab 3d3d3d3d3d3d  	dc.b	"==============",13
 503  00ba 0a00          	dc.b	10,0
 504  00bc               L12:
 505  00bc 0d0a00        	dc.b	13,10,0
 525                     	end
