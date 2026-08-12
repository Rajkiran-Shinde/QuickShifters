   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 171                     ; 5 static void LED_Write(GPIO_Port port, GPIO_Pin pin, uint8_t state)
 171                     ; 6 {
 173                     	switch	.text
 174  0000               L3_LED_Write:
 176  0000 89            	pushw	x
 177       00000000      OFST:	set	0
 180                     ; 7     if(state == TRUE)
 182  0001 7b05          	ld	a,(OFST+5,sp)
 183  0003 a101          	cp	a,#1
 184  0005 260a          	jrne	L101
 185                     ; 8         GPIO_Set(port, pin);
 187  0007 9f            	ld	a,xl
 188  0008 97            	ld	xl,a
 189  0009 7b01          	ld	a,(OFST+1,sp)
 190  000b 95            	ld	xh,a
 191  000c cd0000        	call	_GPIO_Set
 194  000f 2009          	jra	L301
 195  0011               L101:
 196                     ; 10         GPIO_Clear(port, pin);
 198  0011 7b02          	ld	a,(OFST+2,sp)
 199  0013 97            	ld	xl,a
 200  0014 7b01          	ld	a,(OFST+1,sp)
 201  0016 95            	ld	xh,a
 202  0017 cd0000        	call	_GPIO_Clear
 204  001a               L301:
 205                     ; 11 }
 208  001a 85            	popw	x
 209  001b 81            	ret
 235                     ; 13 void LED_Init(void)
 235                     ; 14 {
 236                     	switch	.text
 237  001c               _LED_Init:
 241                     ; 15     GPIO_Output_PP(MODE_LED1_PORT, MODE_LED1_PIN);
 243  001c ae0306        	ldw	x,#774
 244  001f cd0000        	call	_GPIO_Output_PP
 246                     ; 16     LED_Write(MODE_LED1_PORT, MODE_LED1_PIN, FALSE);
 248  0022 4b00          	push	#0
 249  0024 ae0306        	ldw	x,#774
 250  0027 add7          	call	L3_LED_Write
 252  0029 84            	pop	a
 253                     ; 18     GPIO_Output_PP(MODE_LED2_PORT, MODE_LED2_PIN);
 255  002a ae0001        	ldw	x,#1
 256  002d cd0000        	call	_GPIO_Output_PP
 258                     ; 19     LED_Write(MODE_LED2_PORT, MODE_LED2_PIN, FALSE);
 260  0030 4b00          	push	#0
 261  0032 ae0001        	ldw	x,#1
 262  0035 adc9          	call	L3_LED_Write
 264  0037 84            	pop	a
 265                     ; 21     GPIO_Output_PP(MODE_LED3_PORT, MODE_LED3_PIN);
 267  0038 ae0203        	ldw	x,#515
 268  003b cd0000        	call	_GPIO_Output_PP
 270                     ; 22     LED_Write(MODE_LED3_PORT, MODE_LED3_PIN, FALSE);
 272  003e 4b00          	push	#0
 273  0040 ae0203        	ldw	x,#515
 274  0043 adbb          	call	L3_LED_Write
 276  0045 84            	pop	a
 277                     ; 24     GPIO_Output_PP(MODE_LED4_PORT, MODE_LED4_PIN);
 279  0046 ae0204        	ldw	x,#516
 280  0049 cd0000        	call	_GPIO_Output_PP
 282                     ; 25     LED_Write(MODE_LED4_PORT, MODE_LED4_PIN, FALSE);
 284  004c 4b00          	push	#0
 285  004e ae0204        	ldw	x,#516
 286  0051 adad          	call	L3_LED_Write
 288  0053 84            	pop	a
 289                     ; 27     GPIO_Output_PP(MODE_LED5_PORT, MODE_LED5_PIN);
 291  0054 ae0205        	ldw	x,#517
 292  0057 cd0000        	call	_GPIO_Output_PP
 294                     ; 28     LED_Write(MODE_LED5_PORT, MODE_LED5_PIN, FALSE);
 296  005a 4b00          	push	#0
 297  005c ae0205        	ldw	x,#517
 298  005f ad9f          	call	L3_LED_Write
 300  0061 84            	pop	a
 301                     ; 32     GPIO_Output_PP(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
 303  0062 ae0206        	ldw	x,#518
 304  0065 cd0000        	call	_GPIO_Output_PP
 306                     ; 33     GPIO_Clear(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
 308  0068 ae0206        	ldw	x,#518
 309  006b cd0000        	call	_GPIO_Clear
 311                     ; 34 }
 314  006e 81            	ret
 338                     ; 36 void LED_System_On(void)
 338                     ; 37 {
 339                     	switch	.text
 340  006f               _LED_System_On:
 344                     ; 38     GPIO_Clear(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
 346  006f ae0206        	ldw	x,#518
 347  0072 cd0000        	call	_GPIO_Clear
 349                     ; 39 }
 352  0075 81            	ret
 376                     ; 41 void LED_System_Off(void)
 376                     ; 42 {
 377                     	switch	.text
 378  0076               _LED_System_Off:
 382                     ; 43     GPIO_Set(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
 384  0076 ae0206        	ldw	x,#518
 385  0079 cd0000        	call	_GPIO_Set
 387                     ; 44 }
 390  007c 81            	ret
 434                     ; 46 void LED_Mode_Set(uint8_t mode, uint8_t state)
 434                     ; 47 {
 435                     	switch	.text
 436  007d               _LED_Mode_Set:
 438  007d 89            	pushw	x
 439       00000000      OFST:	set	0
 442                     ; 48     switch(mode)
 444  007e 9e            	ld	a,xh
 446                     ; 65         default:
 446                     ; 66             break;
 447  007f 4a            	dec	a
 448  0080 270e          	jreq	L531
 449  0082 4a            	dec	a
 450  0083 2717          	jreq	L731
 451  0085 4a            	dec	a
 452  0086 2720          	jreq	L141
 453  0088 4a            	dec	a
 454  0089 2729          	jreq	L341
 455  008b 4a            	dec	a
 456  008c 2732          	jreq	L541
 457  008e 203a          	jra	L571
 458  0090               L531:
 459                     ; 50         case 1:
 459                     ; 51             LED_Write(MODE_LED1_PORT, MODE_LED1_PIN, state);
 461  0090 7b02          	ld	a,(OFST+2,sp)
 462  0092 88            	push	a
 463  0093 ae0306        	ldw	x,#774
 464  0096 cd0000        	call	L3_LED_Write
 466  0099 84            	pop	a
 467                     ; 52             break;
 469  009a 202e          	jra	L571
 470  009c               L731:
 471                     ; 53         case 2:
 471                     ; 54             LED_Write(MODE_LED2_PORT, MODE_LED2_PIN, state);
 473  009c 7b02          	ld	a,(OFST+2,sp)
 474  009e 88            	push	a
 475  009f ae0001        	ldw	x,#1
 476  00a2 cd0000        	call	L3_LED_Write
 478  00a5 84            	pop	a
 479                     ; 55             break;
 481  00a6 2022          	jra	L571
 482  00a8               L141:
 483                     ; 56         case 3:
 483                     ; 57             LED_Write(MODE_LED3_PORT, MODE_LED3_PIN, state);
 485  00a8 7b02          	ld	a,(OFST+2,sp)
 486  00aa 88            	push	a
 487  00ab ae0203        	ldw	x,#515
 488  00ae cd0000        	call	L3_LED_Write
 490  00b1 84            	pop	a
 491                     ; 58             break;
 493  00b2 2016          	jra	L571
 494  00b4               L341:
 495                     ; 59         case 4:
 495                     ; 60             LED_Write(MODE_LED4_PORT, MODE_LED4_PIN, state);
 497  00b4 7b02          	ld	a,(OFST+2,sp)
 498  00b6 88            	push	a
 499  00b7 ae0204        	ldw	x,#516
 500  00ba cd0000        	call	L3_LED_Write
 502  00bd 84            	pop	a
 503                     ; 61             break;
 505  00be 200a          	jra	L571
 506  00c0               L541:
 507                     ; 62         case 5:
 507                     ; 63             LED_Write(MODE_LED5_PORT, MODE_LED5_PIN, state);
 509  00c0 7b02          	ld	a,(OFST+2,sp)
 510  00c2 88            	push	a
 511  00c3 ae0205        	ldw	x,#517
 512  00c6 cd0000        	call	L3_LED_Write
 514  00c9 84            	pop	a
 515                     ; 64             break;
 517  00ca               L741:
 518                     ; 65         default:
 518                     ; 66             break;
 520  00ca               L571:
 521                     ; 68 }
 524  00ca 85            	popw	x
 525  00cb 81            	ret
 549                     ; 70 void LED_Mode_AllOff(void)
 549                     ; 71 {
 550                     	switch	.text
 551  00cc               _LED_Mode_AllOff:
 555                     ; 72     LED_Mode_Set(1, FALSE);
 557  00cc ae0100        	ldw	x,#256
 558  00cf adac          	call	_LED_Mode_Set
 560                     ; 73     LED_Mode_Set(2, FALSE);
 562  00d1 ae0200        	ldw	x,#512
 563  00d4 ada7          	call	_LED_Mode_Set
 565                     ; 74     LED_Mode_Set(3, FALSE);
 567  00d6 ae0300        	ldw	x,#768
 568  00d9 ada2          	call	_LED_Mode_Set
 570                     ; 75     LED_Mode_Set(4, FALSE);
 572  00db ae0400        	ldw	x,#1024
 573  00de ad9d          	call	_LED_Mode_Set
 575                     ; 76     LED_Mode_Set(5, FALSE);
 577  00e0 ae0500        	ldw	x,#1280
 578  00e3 ad98          	call	_LED_Mode_Set
 580                     ; 77 }
 583  00e5 81            	ret
 627                     ; 79 void LED_Mode_Display(uint8_t mode)
 627                     ; 80 {
 628                     	switch	.text
 629  00e6               _LED_Mode_Display:
 631  00e6 88            	push	a
 632  00e7 88            	push	a
 633       00000001      OFST:	set	1
 636                     ; 83     if(mode < 1)
 638  00e8 4d            	tnz	a
 639  00e9 2604          	jrne	L132
 640                     ; 84         mode = 1;
 642  00eb a601          	ld	a,#1
 643  00ed 6b02          	ld	(OFST+1,sp),a
 644  00ef               L132:
 645                     ; 86     if(mode > 5)
 647  00ef 7b02          	ld	a,(OFST+1,sp)
 648  00f1 a106          	cp	a,#6
 649  00f3 2504          	jrult	L332
 650                     ; 87         mode = 5;
 652  00f5 a605          	ld	a,#5
 653  00f7 6b02          	ld	(OFST+1,sp),a
 654  00f9               L332:
 655                     ; 95     for(i = 1; i <= 5; i++)
 657  00f9 a601          	ld	a,#1
 658  00fb 6b01          	ld	(OFST+0,sp),a
 660  00fd               L532:
 661                     ; 97         LED_Mode_Set(i, (i <= mode) ? TRUE : FALSE);
 663  00fd 7b01          	ld	a,(OFST+0,sp)
 664  00ff 1102          	cp	a,(OFST+1,sp)
 665  0101 2204          	jrugt	L22
 666  0103 a601          	ld	a,#1
 667  0105 2001          	jra	L42
 668  0107               L22:
 669  0107 4f            	clr	a
 670  0108               L42:
 671  0108 97            	ld	xl,a
 672  0109 7b01          	ld	a,(OFST+0,sp)
 673  010b 95            	ld	xh,a
 674  010c cd007d        	call	_LED_Mode_Set
 676                     ; 95     for(i = 1; i <= 5; i++)
 678  010f 0c01          	inc	(OFST+0,sp)
 682  0111 7b01          	ld	a,(OFST+0,sp)
 683  0113 a106          	cp	a,#6
 684  0115 25e6          	jrult	L532
 685                     ; 99 }
 688  0117 85            	popw	x
 689  0118 81            	ret
 702                     	xref	_GPIO_Clear
 703                     	xref	_GPIO_Set
 704                     	xref	_GPIO_Output_PP
 705                     	xdef	_LED_Mode_Display
 706                     	xdef	_LED_Mode_AllOff
 707                     	xdef	_LED_Mode_Set
 708                     	xdef	_LED_System_Off
 709                     	xdef	_LED_System_On
 710                     	xdef	_LED_Init
 729                     	end
