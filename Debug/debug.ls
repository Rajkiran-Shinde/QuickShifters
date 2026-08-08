   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  55                     ; 22 static void Debug_SendChar(char character)
  55                     ; 23 {
  57                     	switch	.text
  58  0000               L3_Debug_SendChar:
  62                     ; 24     UART_SendChar(character);
  64  0000 cd0000        	call	_UART_SendChar
  66                     ; 26     Watchdog_Refresh();
  68  0003 cd0000        	call	_Watchdog_Refresh
  70                     ; 27 }
  73  0006 81            	ret
  98                     ; 34 void Debug_Init(void)
  98                     ; 35 {
  99                     	switch	.text
 100  0007               _Debug_Init:
 104                     ; 36     UART_Init();
 106  0007 cd0000        	call	_UART_Init
 108                     ; 38     Debug_Log("\r\n");
 110  000a ae00da        	ldw	x,#L14
 111  000d ad10          	call	_Debug_Log
 113                     ; 40     Debug_Log("================================\r\n");
 115  000f ae00b7        	ldw	x,#L34
 116  0012 ad0b          	call	_Debug_Log
 118                     ; 42     Debug_Log(" QuickShifter Debug Console\r\n");
 120  0014 ae0099        	ldw	x,#L54
 121  0017 ad06          	call	_Debug_Log
 123                     ; 44     Debug_Log("================================\r\n");
 125  0019 ae00b7        	ldw	x,#L34
 126  001c ad01          	call	_Debug_Log
 128                     ; 45 }
 131  001e 81            	ret
 167                     ; 52 void Debug_Log(const char *message)
 167                     ; 53 {
 168                     	switch	.text
 169  001f               _Debug_Log:
 171  001f 89            	pushw	x
 172       00000000      OFST:	set	0
 175  0020 200c          	jra	L76
 176  0022               L56:
 177                     ; 56         Debug_SendChar(*message);
 179  0022 1e01          	ldw	x,(OFST+1,sp)
 180  0024 f6            	ld	a,(x)
 181  0025 add9          	call	L3_Debug_SendChar
 183                     ; 58         message++;
 185  0027 1e01          	ldw	x,(OFST+1,sp)
 186  0029 1c0001        	addw	x,#1
 187  002c 1f01          	ldw	(OFST+1,sp),x
 188  002e               L76:
 189                     ; 54     while(*message != '\0')
 191  002e 1e01          	ldw	x,(OFST+1,sp)
 192  0030 7d            	tnz	(x)
 193  0031 26ef          	jrne	L56
 194                     ; 60 }
 197  0033 85            	popw	x
 198  0034 81            	ret
 201                     .const:	section	.text
 202  0000               L37_hex:
 203  0000 303132333435  	dc.b	"0123456789ABCDEF",0
 246                     ; 67 void Debug_LogHex(uint8_t value)
 246                     ; 68 {
 247                     	switch	.text
 248  0035               _Debug_LogHex:
 250  0035 88            	push	a
 251  0036 5213          	subw	sp,#19
 252       00000013      OFST:	set	19
 255                     ; 69     char hex[] = "0123456789ABCDEF";
 257  0038 96            	ldw	x,sp
 258  0039 1c0003        	addw	x,#OFST-16
 259  003c 90ae0000      	ldw	y,#L37_hex
 260  0040 a611          	ld	a,#17
 261  0042 cd0000        	call	c_xymov
 263                     ; 71     Debug_SendChar(
 263                     ; 72         hex[(value >> 4) & 0x0F]
 263                     ; 73     );
 265  0045 96            	ldw	x,sp
 266  0046 1c0003        	addw	x,#OFST-16
 267  0049 1f01          	ldw	(OFST-18,sp),x
 269  004b 7b14          	ld	a,(OFST+1,sp)
 270  004d 4e            	swap	a
 271  004e a40f          	and	a,#15
 272  0050 5f            	clrw	x
 273  0051 97            	ld	xl,a
 274  0052 72fb01        	addw	x,(OFST-18,sp)
 275  0055 f6            	ld	a,(x)
 276  0056 ada8          	call	L3_Debug_SendChar
 278                     ; 75     Debug_SendChar(
 278                     ; 76         hex[value & 0x0F]
 278                     ; 77     );
 280  0058 96            	ldw	x,sp
 281  0059 1c0003        	addw	x,#OFST-16
 282  005c 1f01          	ldw	(OFST-18,sp),x
 284  005e 7b14          	ld	a,(OFST+1,sp)
 285  0060 a40f          	and	a,#15
 286  0062 5f            	clrw	x
 287  0063 97            	ld	xl,a
 288  0064 72fb01        	addw	x,(OFST-18,sp)
 289  0067 f6            	ld	a,(x)
 290  0068 ad96          	call	L3_Debug_SendChar
 292                     ; 78 }
 295  006a 5b14          	addw	sp,#20
 296  006c 81            	ret
 350                     ; 85 void Debug_LogDecimal(uint8_t value)
 350                     ; 86 {
 351                     	switch	.text
 352  006d               _Debug_LogDecimal:
 354  006d 88            	push	a
 355  006e 5207          	subw	sp,#7
 356       00000007      OFST:	set	7
 359                     ; 91     i = 0;
 361  0070 0f07          	clr	(OFST+0,sp)
 363                     ; 94     if(value >= 100)
 365  0072 a164          	cp	a,#100
 366  0074 2573          	jrult	L541
 367                     ; 96         buffer[i++] =
 367                     ; 97             '0' + (value / 100);
 369  0076 96            	ldw	x,sp
 370  0077 1c0003        	addw	x,#OFST-4
 371  007a 1f01          	ldw	(OFST-6,sp),x
 373  007c 7b07          	ld	a,(OFST+0,sp)
 374  007e 97            	ld	xl,a
 375  007f 0c07          	inc	(OFST+0,sp)
 377  0081 9f            	ld	a,xl
 378  0082 5f            	clrw	x
 379  0083 97            	ld	xl,a
 380  0084 72fb01        	addw	x,(OFST-6,sp)
 381  0087 7b08          	ld	a,(OFST+1,sp)
 382  0089 905f          	clrw	y
 383  008b 9097          	ld	yl,a
 384  008d a664          	ld	a,#100
 385  008f 9062          	div	y,a
 386  0091 909f          	ld	a,yl
 387  0093 ab30          	add	a,#48
 388  0095 f7            	ld	(x),a
 389                     ; 99         value =
 389                     ; 100             value % 100;
 391  0096 7b08          	ld	a,(OFST+1,sp)
 392  0098 5f            	clrw	x
 393  0099 97            	ld	xl,a
 394  009a a664          	ld	a,#100
 395  009c 62            	div	x,a
 396  009d 5f            	clrw	x
 397  009e 97            	ld	xl,a
 398  009f 01            	rrwa	x,a
 399  00a0 6b08          	ld	(OFST+1,sp),a
 400  00a2 02            	rlwa	x,a
 401                     ; 102         buffer[i++] =
 401                     ; 103             '0' + (value / 10);
 403  00a3 96            	ldw	x,sp
 404  00a4 1c0003        	addw	x,#OFST-4
 405  00a7 1f01          	ldw	(OFST-6,sp),x
 407  00a9 7b07          	ld	a,(OFST+0,sp)
 408  00ab 97            	ld	xl,a
 409  00ac 0c07          	inc	(OFST+0,sp)
 411  00ae 9f            	ld	a,xl
 412  00af 5f            	clrw	x
 413  00b0 97            	ld	xl,a
 414  00b1 72fb01        	addw	x,(OFST-6,sp)
 415  00b4 7b08          	ld	a,(OFST+1,sp)
 416  00b6 905f          	clrw	y
 417  00b8 9097          	ld	yl,a
 418  00ba a60a          	ld	a,#10
 419  00bc 9062          	div	y,a
 420  00be 909f          	ld	a,yl
 421  00c0 ab30          	add	a,#48
 422  00c2 f7            	ld	(x),a
 423                     ; 105         buffer[i++] =
 423                     ; 106             '0' + (value % 10);
 425  00c3 96            	ldw	x,sp
 426  00c4 1c0003        	addw	x,#OFST-4
 427  00c7 1f01          	ldw	(OFST-6,sp),x
 429  00c9 7b07          	ld	a,(OFST+0,sp)
 430  00cb 97            	ld	xl,a
 431  00cc 0c07          	inc	(OFST+0,sp)
 433  00ce 9f            	ld	a,xl
 434  00cf 5f            	clrw	x
 435  00d0 97            	ld	xl,a
 436  00d1 72fb01        	addw	x,(OFST-6,sp)
 437  00d4 7b08          	ld	a,(OFST+1,sp)
 438  00d6 905f          	clrw	y
 439  00d8 9097          	ld	yl,a
 440  00da a60a          	ld	a,#10
 441  00dc 9062          	div	y,a
 442  00de 905f          	clrw	y
 443  00e0 9097          	ld	yl,a
 444  00e2 909f          	ld	a,yl
 445  00e4 ab30          	add	a,#48
 446  00e6 f7            	ld	(x),a
 448  00e7 2062          	jra	L741
 449  00e9               L541:
 450                     ; 108     else if(value >= 10)
 452  00e9 7b08          	ld	a,(OFST+1,sp)
 453  00eb a10a          	cp	a,#10
 454  00ed 2546          	jrult	L151
 455                     ; 110         buffer[i++] =
 455                     ; 111             '0' + (value / 10);
 457  00ef 96            	ldw	x,sp
 458  00f0 1c0003        	addw	x,#OFST-4
 459  00f3 1f01          	ldw	(OFST-6,sp),x
 461  00f5 7b07          	ld	a,(OFST+0,sp)
 462  00f7 97            	ld	xl,a
 463  00f8 0c07          	inc	(OFST+0,sp)
 465  00fa 9f            	ld	a,xl
 466  00fb 5f            	clrw	x
 467  00fc 97            	ld	xl,a
 468  00fd 72fb01        	addw	x,(OFST-6,sp)
 469  0100 7b08          	ld	a,(OFST+1,sp)
 470  0102 905f          	clrw	y
 471  0104 9097          	ld	yl,a
 472  0106 a60a          	ld	a,#10
 473  0108 9062          	div	y,a
 474  010a 909f          	ld	a,yl
 475  010c ab30          	add	a,#48
 476  010e f7            	ld	(x),a
 477                     ; 113         buffer[i++] =
 477                     ; 114             '0' + (value % 10);
 479  010f 96            	ldw	x,sp
 480  0110 1c0003        	addw	x,#OFST-4
 481  0113 1f01          	ldw	(OFST-6,sp),x
 483  0115 7b07          	ld	a,(OFST+0,sp)
 484  0117 97            	ld	xl,a
 485  0118 0c07          	inc	(OFST+0,sp)
 487  011a 9f            	ld	a,xl
 488  011b 5f            	clrw	x
 489  011c 97            	ld	xl,a
 490  011d 72fb01        	addw	x,(OFST-6,sp)
 491  0120 7b08          	ld	a,(OFST+1,sp)
 492  0122 905f          	clrw	y
 493  0124 9097          	ld	yl,a
 494  0126 a60a          	ld	a,#10
 495  0128 9062          	div	y,a
 496  012a 905f          	clrw	y
 497  012c 9097          	ld	yl,a
 498  012e 909f          	ld	a,yl
 499  0130 ab30          	add	a,#48
 500  0132 f7            	ld	(x),a
 502  0133 2016          	jra	L741
 503  0135               L151:
 504                     ; 118         buffer[i++] =
 504                     ; 119             '0' + value;
 506  0135 96            	ldw	x,sp
 507  0136 1c0003        	addw	x,#OFST-4
 508  0139 1f01          	ldw	(OFST-6,sp),x
 510  013b 7b07          	ld	a,(OFST+0,sp)
 511  013d 97            	ld	xl,a
 512  013e 0c07          	inc	(OFST+0,sp)
 514  0140 9f            	ld	a,xl
 515  0141 5f            	clrw	x
 516  0142 97            	ld	xl,a
 517  0143 72fb01        	addw	x,(OFST-6,sp)
 518  0146 7b08          	ld	a,(OFST+1,sp)
 519  0148 ab30          	add	a,#48
 520  014a f7            	ld	(x),a
 521  014b               L741:
 522                     ; 123     buffer[i] = '\0';
 524  014b 96            	ldw	x,sp
 525  014c 1c0003        	addw	x,#OFST-4
 526  014f 9f            	ld	a,xl
 527  0150 5e            	swapw	x
 528  0151 1b07          	add	a,(OFST+0,sp)
 529  0153 2401          	jrnc	L61
 530  0155 5c            	incw	x
 531  0156               L61:
 532  0156 02            	rlwa	x,a
 533  0157 7f            	clr	(x)
 534                     ; 126     Debug_Log(buffer);
 536  0158 96            	ldw	x,sp
 537  0159 1c0003        	addw	x,#OFST-4
 538  015c cd001f        	call	_Debug_Log
 540                     ; 127 }
 543  015f 5b08          	addw	sp,#8
 544  0161 81            	ret
 579                     ; 134 void Debug_LogState(uint8_t state)
 579                     ; 135 {
 580                     	switch	.text
 581  0162               _Debug_LogState:
 585                     ; 136     switch(state)
 588                     ; 189             break;
 589  0162 4d            	tnz	a
 590  0163 2714          	jreq	L551
 591  0165 4a            	dec	a
 592  0166 2719          	jreq	L751
 593  0168 4a            	dec	a
 594  0169 271e          	jreq	L161
 595  016b 4a            	dec	a
 596  016c 2723          	jreq	L361
 597  016e 4a            	dec	a
 598  016f 2728          	jreq	L561
 599  0171               L761:
 600                     ; 183         default:
 600                     ; 184 
 600                     ; 185             Debug_Log(
 600                     ; 186                 "[QS] UNKNOWN STATE\r\n"
 600                     ; 187             );
 602  0171 ae0035        	ldw	x,#L522
 603  0174 cd001f        	call	_Debug_Log
 605                     ; 189             break;
 607  0177 2026          	jra	L112
 608  0179               L551:
 609                     ; 138         case 0:
 609                     ; 139 
 609                     ; 140             Debug_Log(
 609                     ; 141                 "[QS] IDLE\r\n"
 609                     ; 142             );
 611  0179 ae008d        	ldw	x,#L312
 612  017c cd001f        	call	_Debug_Log
 614                     ; 144             break;
 616  017f 201e          	jra	L112
 617  0181               L751:
 618                     ; 147         case 1:
 618                     ; 148 
 618                     ; 149             Debug_Log(
 618                     ; 150                 "[QS] CUT_ACTIVE\r\n"
 618                     ; 151             );
 620  0181 ae007b        	ldw	x,#L512
 621  0184 cd001f        	call	_Debug_Log
 623                     ; 153             break;
 625  0187 2016          	jra	L112
 626  0189               L161:
 627                     ; 156         case 2:
 627                     ; 157 
 627                     ; 158             Debug_Log(
 627                     ; 159                 "[QS] COOLDOWN\r\n"
 627                     ; 160             );
 629  0189 ae006b        	ldw	x,#L712
 630  018c cd001f        	call	_Debug_Log
 632                     ; 162             break;
 634  018f 200e          	jra	L112
 635  0191               L361:
 636                     ; 165         case 3:
 636                     ; 166 
 636                     ; 167             Debug_Log(
 636                     ; 168                 "[QS] WAIT_RELEASE\r\n"
 636                     ; 169             );
 638  0191 ae0057        	ldw	x,#L122
 639  0194 cd001f        	call	_Debug_Log
 641                     ; 171             break;
 643  0197 2006          	jra	L112
 644  0199               L561:
 645                     ; 174         case 4:
 645                     ; 175 
 645                     ; 176             Debug_Log(
 645                     ; 177                 "[QS] FAULT\r\n"
 645                     ; 178             );
 647  0199 ae004a        	ldw	x,#L322
 648  019c cd001f        	call	_Debug_Log
 650                     ; 180             break;
 652  019f               L112:
 653                     ; 191 }
 656  019f 81            	ret
 701                     ; 198 void Debug_LogMode(
 701                     ; 199     uint8_t mode,
 701                     ; 200     uint16_t cut_time
 701                     ; 201 )
 701                     ; 202 {
 702                     	switch	.text
 703  01a0               _Debug_LogMode:
 705  01a0 88            	push	a
 706       00000000      OFST:	set	0
 709                     ; 203     Debug_Log(
 709                     ; 204         "[MODE] "
 709                     ; 205     );
 711  01a1 ae002d        	ldw	x,#L152
 712  01a4 cd001f        	call	_Debug_Log
 714                     ; 218     Debug_SendChar(
 714                     ; 219         '1' + mode
 714                     ; 220     );
 716  01a7 7b01          	ld	a,(OFST+1,sp)
 717  01a9 ab31          	add	a,#49
 718  01ab cd0000        	call	L3_Debug_SendChar
 720                     ; 223     Debug_Log(
 720                     ; 224         " | CUT = "
 720                     ; 225     );
 722  01ae ae0023        	ldw	x,#L352
 723  01b1 cd001f        	call	_Debug_Log
 725                     ; 228     if(cut_time >= 100)
 727  01b4 1e04          	ldw	x,(OFST+4,sp)
 728  01b6 a30064        	cpw	x,#100
 729  01b9 2515          	jrult	L552
 730                     ; 230         Debug_SendChar(
 730                     ; 231             '0' + (cut_time / 100)
 730                     ; 232         );
 732  01bb 1e04          	ldw	x,(OFST+4,sp)
 733  01bd a664          	ld	a,#100
 734  01bf 62            	div	x,a
 735  01c0 1c0030        	addw	x,#48
 736  01c3 9f            	ld	a,xl
 737  01c4 cd0000        	call	L3_Debug_SendChar
 739                     ; 234         cut_time =
 739                     ; 235             cut_time % 100;
 741  01c7 1e04          	ldw	x,(OFST+4,sp)
 742  01c9 a664          	ld	a,#100
 743  01cb 62            	div	x,a
 744  01cc 5f            	clrw	x
 745  01cd 97            	ld	xl,a
 746  01ce 1f04          	ldw	(OFST+4,sp),x
 747  01d0               L552:
 748                     ; 239     Debug_SendChar(
 748                     ; 240         '0' + (cut_time / 10)
 748                     ; 241     );
 750  01d0 1e04          	ldw	x,(OFST+4,sp)
 751  01d2 a60a          	ld	a,#10
 752  01d4 62            	div	x,a
 753  01d5 1c0030        	addw	x,#48
 754  01d8 9f            	ld	a,xl
 755  01d9 cd0000        	call	L3_Debug_SendChar
 757                     ; 244     Debug_SendChar(
 757                     ; 245         '0' + (cut_time % 10)
 757                     ; 246     );
 759  01dc 1e04          	ldw	x,(OFST+4,sp)
 760  01de a60a          	ld	a,#10
 761  01e0 62            	div	x,a
 762  01e1 5f            	clrw	x
 763  01e2 97            	ld	xl,a
 764  01e3 1c0030        	addw	x,#48
 765  01e6 9f            	ld	a,xl
 766  01e7 cd0000        	call	L3_Debug_SendChar
 768                     ; 249     Debug_Log(
 768                     ; 250         " ms\r\n"
 768                     ; 251     );
 770  01ea ae001d        	ldw	x,#L752
 771  01ed cd001f        	call	_Debug_Log
 773                     ; 252 }
 776  01f0 84            	pop	a
 777  01f1 81            	ret
 813                     ; 259 void Debug_LogShift(uint16_t shift_time)
 813                     ; 260 {
 814                     	switch	.text
 815  01f2               _Debug_LogShift:
 817  01f2 89            	pushw	x
 818       00000000      OFST:	set	0
 821                     ; 261     Debug_Log(
 821                     ; 262         "[QS] CUT = "
 821                     ; 263     );
 823  01f3 ae0011        	ldw	x,#L772
 824  01f6 cd001f        	call	_Debug_Log
 826                     ; 266     if(shift_time >= 100)
 828  01f9 1e01          	ldw	x,(OFST+1,sp)
 829  01fb a30064        	cpw	x,#100
 830  01fe 2515          	jrult	L103
 831                     ; 268         Debug_SendChar(
 831                     ; 269             '0' + (shift_time / 100)
 831                     ; 270         );
 833  0200 1e01          	ldw	x,(OFST+1,sp)
 834  0202 a664          	ld	a,#100
 835  0204 62            	div	x,a
 836  0205 1c0030        	addw	x,#48
 837  0208 9f            	ld	a,xl
 838  0209 cd0000        	call	L3_Debug_SendChar
 840                     ; 272         shift_time =
 840                     ; 273             shift_time % 100;
 842  020c 1e01          	ldw	x,(OFST+1,sp)
 843  020e a664          	ld	a,#100
 844  0210 62            	div	x,a
 845  0211 5f            	clrw	x
 846  0212 97            	ld	xl,a
 847  0213 1f01          	ldw	(OFST+1,sp),x
 848  0215               L103:
 849                     ; 277     Debug_SendChar(
 849                     ; 278         '0' + (shift_time / 10)
 849                     ; 279     );
 851  0215 1e01          	ldw	x,(OFST+1,sp)
 852  0217 a60a          	ld	a,#10
 853  0219 62            	div	x,a
 854  021a 1c0030        	addw	x,#48
 855  021d 9f            	ld	a,xl
 856  021e cd0000        	call	L3_Debug_SendChar
 858                     ; 282     Debug_SendChar(
 858                     ; 283         '0' + (shift_time % 10)
 858                     ; 284     );
 860  0221 1e01          	ldw	x,(OFST+1,sp)
 861  0223 a60a          	ld	a,#10
 862  0225 62            	div	x,a
 863  0226 5f            	clrw	x
 864  0227 97            	ld	xl,a
 865  0228 1c0030        	addw	x,#48
 866  022b 9f            	ld	a,xl
 867  022c cd0000        	call	L3_Debug_SendChar
 869                     ; 287     Debug_Log(
 869                     ; 288         " ms\r\n"
 869                     ; 289     );
 871  022f ae001d        	ldw	x,#L752
 872  0232 cd001f        	call	_Debug_Log
 874                     ; 290 }
 877  0235 85            	popw	x
 878  0236 81            	ret
 891                     	xref	_UART_SendChar
 892                     	xref	_UART_Init
 893                     	xref	_Watchdog_Refresh
 894                     	xdef	_Debug_LogMode
 895                     	xdef	_Debug_LogShift
 896                     	xdef	_Debug_LogState
 897                     	xdef	_Debug_LogDecimal
 898                     	xdef	_Debug_LogHex
 899                     	xdef	_Debug_Log
 900                     	xdef	_Debug_Init
 901                     	switch	.const
 902  0011               L772:
 903  0011 5b51535d2043  	dc.b	"[QS] CUT = ",0
 904  001d               L752:
 905  001d 206d730d      	dc.b	" ms",13
 906  0021 0a00          	dc.b	10,0
 907  0023               L352:
 908  0023 207c20435554  	dc.b	" | CUT = ",0
 909  002d               L152:
 910  002d 5b4d4f44455d  	dc.b	"[MODE] ",0
 911  0035               L522:
 912  0035 5b51535d2055  	dc.b	"[QS] UNKNOWN STATE"
 913  0047 0d0a00        	dc.b	13,10,0
 914  004a               L322:
 915  004a 5b51535d2046  	dc.b	"[QS] FAULT",13
 916  0055 0a00          	dc.b	10,0
 917  0057               L122:
 918  0057 5b51535d2057  	dc.b	"[QS] WAIT_RELEASE",13
 919  0069 0a00          	dc.b	10,0
 920  006b               L712:
 921  006b 5b51535d2043  	dc.b	"[QS] COOLDOWN",13
 922  0079 0a00          	dc.b	10,0
 923  007b               L512:
 924  007b 5b51535d2043  	dc.b	"[QS] CUT_ACTIVE",13
 925  008b 0a00          	dc.b	10,0
 926  008d               L312:
 927  008d 5b51535d2049  	dc.b	"[QS] IDLE",13
 928  0097 0a00          	dc.b	10,0
 929  0099               L54:
 930  0099 20517569636b  	dc.b	" QuickShifter Debu"
 931  00ab 6720436f6e73  	dc.b	"g Console",13
 932  00b5 0a00          	dc.b	10,0
 933  00b7               L34:
 934  00b7 3d3d3d3d3d3d  	dc.b	"=================="
 935  00c9 3d3d3d3d3d3d  	dc.b	"==============",13
 936  00d8 0a00          	dc.b	10,0
 937  00da               L14:
 938  00da 0d0a00        	dc.b	13,10,0
 939                     	xref.b	c_x
 959                     	xref	c_xymov
 960                     	end
