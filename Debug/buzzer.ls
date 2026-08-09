   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     .const:	section	.text
  15  0000               L3_boot_melody:
  16  0000 0320          	dc.w	800
  17  0002 0064          	dc.w	100
  18  0004 03e8          	dc.w	1000
  19  0006 0064          	dc.w	100
  20  0008 04b0          	dc.w	1200
  21  000a 0078          	dc.w	120
  22  000c 03e8          	dc.w	1000
  23  000e 00fa          	dc.w	250
  24  0010 0000          	dc.w	0
  25  0012 0032          	dc.w	50
  26  0014 ffff          	dc.w	-1
  27  0016 0000          	dc.w	0
  28  0018               L5_mode_change_melody:
  29  0018 03e8          	dc.w	1000
  30  001a 0046          	dc.w	70
  31  001c 04b0          	dc.w	1200
  32  001e 006e          	dc.w	110
  33  0020 0000          	dc.w	0
  34  0022 001e          	dc.w	30
  35  0024 ffff          	dc.w	-1
  36  0026 0000          	dc.w	0
  37  0028               L7_shift_melody:
  38  0028 04b0          	dc.w	1200
  39  002a 002d          	dc.w	45
  40  002c ffff          	dc.w	-1
  41  002e 0000          	dc.w	0
  42  0030               L11_ready_melody:
  43  0030 03e8          	dc.w	1000
  44  0032 0064          	dc.w	100
  45  0034 04b0          	dc.w	1200
  46  0036 00b4          	dc.w	180
  47  0038 ffff          	dc.w	-1
  48  003a 0000          	dc.w	0
  49  003c               L31_fault_melody:
  50  003c 04b0          	dc.w	1200
  51  003e 0064          	dc.w	100
  52  0040 0000          	dc.w	0
  53  0042 0046          	dc.w	70
  54  0044 04b0          	dc.w	1200
  55  0046 0064          	dc.w	100
  56  0048 0000          	dc.w	0
  57  004a 0046          	dc.w	70
  58  004c 04b0          	dc.w	1200
  59  004e 0064          	dc.w	100
  60  0050 ffff          	dc.w	-1
  61  0052 0000          	dc.w	0
  62                     	bsct
  63  0000               L51_current_melody:
  64  0000 0000          	dc.w	0
  65  0002               L71_current_note:
  66  0002 00            	dc.b	0
  67  0003               L12_note_start_time:
  68  0003 00000000      	dc.l	0
  69  0007               L32_buzzer_busy:
  70  0007 00            	dc.b	0
 112                     ; 195 static void Buzzer_Output(uint8_t state)
 112                     ; 196 {
 114                     	switch	.text
 115  0000               L52_Buzzer_Output:
 119                     ; 197     if(state == TRUE)
 121  0000 a101          	cp	a,#1
 122  0002 2608          	jrne	L35
 123                     ; 199         GPIO_Set(
 123                     ; 200             BUZZER_PORT,
 123                     ; 201             BUZZER_PIN
 123                     ; 202         );
 125  0004 ae0003        	ldw	x,#3
 126  0007 cd0000        	call	_GPIO_Set
 129  000a 2006          	jra	L55
 130  000c               L35:
 131                     ; 206         GPIO_Clear(
 131                     ; 207             BUZZER_PORT,
 131                     ; 208             BUZZER_PIN
 131                     ; 209         );
 133  000c ae0003        	ldw	x,#3
 134  000f cd0000        	call	_GPIO_Clear
 136  0012               L55:
 137                     ; 211 }
 140  0012 81            	ret
 164                     ; 218 static void Buzzer_Timer_Stop(void)
 164                     ; 219 {
 165                     	switch	.text
 166  0013               L75_Buzzer_Timer_Stop:
 170                     ; 223     TIM2_CR1 &= (uint8_t)(~TIM2_CR1_CEN);
 172  0013 72115300      	bres	21248,#0
 173                     ; 229     TIM2_IER &= (uint8_t)(~TIM2_IER_UIE);
 175  0017 72115303      	bres	21251,#0
 176                     ; 235     Buzzer_Output(FALSE);
 178  001b 4f            	clr	a
 179  001c ade2          	call	L52_Buzzer_Output
 181                     ; 236 }
 184  001e 81            	ret
 229                     ; 243 static void Buzzer_SetFrequency(uint16_t frequency)
 229                     ; 244 {
 230                     	switch	.text
 231  001f               L17_Buzzer_SetFrequency:
 233  001f 89            	pushw	x
 234  0020 5206          	subw	sp,#6
 235       00000006      OFST:	set	6
 238                     ; 251     if(frequency == BUZZER_REST)
 240  0022 a30000        	cpw	x,#0
 241  0025 2604          	jrne	L511
 242                     ; 253         Buzzer_Timer_Stop();
 244  0027 adea          	call	L75_Buzzer_Timer_Stop
 246                     ; 255         return;
 248  0029 2058          	jra	L21
 249  002b               L511:
 250                     ; 273     reload = (uint16_t)(
 250                     ; 274         2000000UL / (2UL * frequency)
 250                     ; 275     );
 252  002b 1e07          	ldw	x,(OFST+1,sp)
 253  002d cd0000        	call	c_uitolx
 255  0030 3803          	sll	c_lreg+3
 256  0032 3902          	rlc	c_lreg+2
 257  0034 3901          	rlc	c_lreg+1
 258  0036 3900          	rlc	c_lreg
 259  0038 96            	ldw	x,sp
 260  0039 1c0001        	addw	x,#OFST-5
 261  003c cd0000        	call	c_rtol
 264  003f ae8480        	ldw	x,#33920
 265  0042 bf02          	ldw	c_lreg+2,x
 266  0044 ae001e        	ldw	x,#30
 267  0047 bf00          	ldw	c_lreg,x
 268  0049 96            	ldw	x,sp
 269  004a 1c0001        	addw	x,#OFST-5
 270  004d cd0000        	call	c_ludv
 272  0050 be02          	ldw	x,c_lreg+2
 273  0052 1f05          	ldw	(OFST-1,sp),x
 275                     ; 278     if(reload == 0)
 277  0054 1e05          	ldw	x,(OFST-1,sp)
 278  0056 2605          	jrne	L711
 279                     ; 280         reload = 1;
 281  0058 ae0001        	ldw	x,#1
 282  005b 1f05          	ldw	(OFST-1,sp),x
 284  005d               L711:
 285                     ; 287     Buzzer_Timer_Stop();
 287  005d adb4          	call	L75_Buzzer_Timer_Stop
 289                     ; 293     TIM2_PSCR = 3;
 291  005f 3503530e      	mov	21262,#3
 292                     ; 299     TIM2_ARRH = (uint8_t)(reload >> 8);
 294  0063 7b05          	ld	a,(OFST-1,sp)
 295  0065 c7530f        	ld	21263,a
 296                     ; 300     TIM2_ARRL = (uint8_t)(reload & 0xFF);
 298  0068 7b06          	ld	a,(OFST+0,sp)
 299  006a a4ff          	and	a,#255
 300  006c c75310        	ld	21264,a
 301                     ; 306     TIM2_CNTRH = 0;
 303  006f 725f530c      	clr	21260
 304                     ; 307     TIM2_CNTRL = 0;
 306  0073 725f530d      	clr	21261
 307                     ; 313     TIM2_SR1 &= (uint8_t)(~TIM2_SR_UIF);
 309  0077 72115304      	bres	21252,#0
 310                     ; 319     TIM2_IER |= TIM2_IER_UIE;
 312  007b 72105303      	bset	21251,#0
 313                     ; 325     TIM2_CR1 |= TIM2_CR1_CEN;
 315  007f 72105300      	bset	21248,#0
 316                     ; 326 }
 317  0083               L21:
 320  0083 5b08          	addw	sp,#8
 321  0085 81            	ret
 351                     ; 333 void Buzzer_Init(void)
 351                     ; 334 {
 352                     	switch	.text
 353  0086               _Buzzer_Init:
 357                     ; 342     GPIO_Output_PP(
 357                     ; 343         BUZZER_PORT,
 357                     ; 344         BUZZER_PIN
 357                     ; 345     );
 359  0086 ae0003        	ldw	x,#3
 360  0089 cd0000        	call	_GPIO_Output_PP
 362                     ; 351     Buzzer_Output(FALSE);
 364  008c 4f            	clr	a
 365  008d cd0000        	call	L52_Buzzer_Output
 367                     ; 357     current_melody = 0;
 369  0090 5f            	clrw	x
 370  0091 bf00          	ldw	L51_current_melody,x
 371                     ; 359     current_note = 0;
 373  0093 3f02          	clr	L71_current_note
 374                     ; 361     note_start_time = 0;
 376  0095 ae0000        	ldw	x,#0
 377  0098 bf05          	ldw	L12_note_start_time+2,x
 378  009a ae0000        	ldw	x,#0
 379  009d bf03          	ldw	L12_note_start_time,x
 380                     ; 363     buzzer_busy = FALSE;
 382  009f 3f07          	clr	L32_buzzer_busy
 383                     ; 369     Buzzer_Timer_Stop();
 385  00a1 cd0013        	call	L75_Buzzer_Timer_Stop
 387                     ; 370 }
 390  00a4 81            	ret
 478                     ; 377 void Buzzer_Play(BuzzerEvent event)
 478                     ; 378 {
 479                     	switch	.text
 480  00a5               _Buzzer_Play:
 484                     ; 382     switch(event)
 487                     ; 419         default:
 487                     ; 420 
 487                     ; 421             return;
 488  00a5 4d            	tnz	a
 489  00a6 270d          	jreq	L131
 490  00a8 4a            	dec	a
 491  00a9 2711          	jreq	L331
 492  00ab 4a            	dec	a
 493  00ac 2715          	jreq	L531
 494  00ae 4a            	dec	a
 495  00af 2719          	jreq	L731
 496  00b1 4a            	dec	a
 497  00b2 271d          	jreq	L141
 498  00b4               L341:
 502  00b4 81            	ret
 503  00b5               L131:
 504                     ; 384         case BUZZER_EVENT_BOOT:
 504                     ; 385 
 504                     ; 386             current_melody = boot_melody;
 506  00b5 ae0000        	ldw	x,#L3_boot_melody
 507  00b8 bf00          	ldw	L51_current_melody,x
 508                     ; 388             break;
 510  00ba 201a          	jra	L302
 511  00bc               L331:
 512                     ; 391         case BUZZER_EVENT_MODE_CHANGE:
 512                     ; 392 
 512                     ; 393             current_melody = mode_change_melody;
 514  00bc ae0018        	ldw	x,#L5_mode_change_melody
 515  00bf bf00          	ldw	L51_current_melody,x
 516                     ; 395             break;
 518  00c1 2013          	jra	L302
 519  00c3               L531:
 520                     ; 398         case BUZZER_EVENT_SHIFT:
 520                     ; 399 
 520                     ; 400             current_melody = shift_melody;
 522  00c3 ae0028        	ldw	x,#L7_shift_melody
 523  00c6 bf00          	ldw	L51_current_melody,x
 524                     ; 402             break;
 526  00c8 200c          	jra	L302
 527  00ca               L731:
 528                     ; 405         case BUZZER_EVENT_READY:
 528                     ; 406 
 528                     ; 407             current_melody = ready_melody;
 530  00ca ae0030        	ldw	x,#L11_ready_melody
 531  00cd bf00          	ldw	L51_current_melody,x
 532                     ; 409             break;
 534  00cf 2005          	jra	L302
 535  00d1               L141:
 536                     ; 412         case BUZZER_EVENT_FAULT:
 536                     ; 413 
 536                     ; 414             current_melody = fault_melody;
 538  00d1 ae003c        	ldw	x,#L31_fault_melody
 539  00d4 bf00          	ldw	L51_current_melody,x
 540                     ; 416             break;
 542  00d6               L302:
 543                     ; 428     current_note = 0;
 545  00d6 3f02          	clr	L71_current_note
 546                     ; 434     note_start_time = Timer_GetTick();
 548  00d8 cd0000        	call	_Timer_GetTick
 550  00db ae0003        	ldw	x,#L12_note_start_time
 551  00de cd0000        	call	c_rtol
 553                     ; 440     buzzer_busy = TRUE;
 555  00e1 35010007      	mov	L32_buzzer_busy,#1
 556                     ; 446     Buzzer_SetFrequency(
 556                     ; 447         current_melody[current_note].frequency
 556                     ; 448     );
 558  00e5 b602          	ld	a,L71_current_note
 559  00e7 97            	ld	xl,a
 560  00e8 a604          	ld	a,#4
 561  00ea 42            	mul	x,a
 562  00eb 92de00        	ldw	x,([L51_current_melody.w],x)
 563  00ee cd001f        	call	L17_Buzzer_SetFrequency
 565                     ; 449 }
 568  00f1 81            	ret
 633                     ; 460 void Buzzer_Task(void)
 633                     ; 461 {
 634                     	switch	.text
 635  00f2               _Buzzer_Task:
 637  00f2 5206          	subw	sp,#6
 638       00000006      OFST:	set	6
 641                     ; 468     if(buzzer_busy == FALSE)
 643  00f4 3d07          	tnz	L32_buzzer_busy
 644  00f6 271a          	jreq	L22
 645                     ; 470         return;
 647                     ; 477     note = &current_melody[current_note];
 649  00f8 b602          	ld	a,L71_current_note
 650  00fa 97            	ld	xl,a
 651  00fb a604          	ld	a,#4
 652  00fd 42            	mul	x,a
 653  00fe 72bb0000      	addw	x,L51_current_melody
 654  0102 1f05          	ldw	(OFST-1,sp),x
 656                     ; 483     if(note->frequency == BUZZER_MELODY_END)
 658  0104 1e05          	ldw	x,(OFST-1,sp)
 659  0106 9093          	ldw	y,x
 660  0108 90fe          	ldw	y,(y)
 661  010a 90a3ffff      	cpw	y,#65535
 662  010e 2605          	jrne	L732
 663                     ; 485         Buzzer_Stop();
 665  0110 ad3c          	call	_Buzzer_Stop
 667                     ; 487         return;
 668  0112               L22:
 671  0112 5b06          	addw	sp,#6
 672  0114 81            	ret
 673  0115               L732:
 674                     ; 494     if((Timer_GetTick() - note_start_time) < note->duration)
 676  0115 cd0000        	call	_Timer_GetTick
 678  0118 ae0003        	ldw	x,#L12_note_start_time
 679  011b cd0000        	call	c_lsub
 681  011e 96            	ldw	x,sp
 682  011f 1c0001        	addw	x,#OFST-5
 683  0122 cd0000        	call	c_rtol
 686  0125 1e05          	ldw	x,(OFST-1,sp)
 687  0127 ee02          	ldw	x,(2,x)
 688  0129 cd0000        	call	c_uitolx
 690  012c 96            	ldw	x,sp
 691  012d 1c0001        	addw	x,#OFST-5
 692  0130 cd0000        	call	c_lcmp
 694  0133 22dd          	jrugt	L22
 695                     ; 496         return;
 697                     ; 503     current_note++;
 699  0135 3c02          	inc	L71_current_note
 700                     ; 509     note_start_time = Timer_GetTick();
 702  0137 cd0000        	call	_Timer_GetTick
 704  013a ae0003        	ldw	x,#L12_note_start_time
 705  013d cd0000        	call	c_rtol
 707                     ; 515     Buzzer_SetFrequency(
 707                     ; 516         current_melody[current_note].frequency
 707                     ; 517     );
 709  0140 b602          	ld	a,L71_current_note
 710  0142 97            	ld	xl,a
 711  0143 a604          	ld	a,#4
 712  0145 42            	mul	x,a
 713  0146 92de00        	ldw	x,([L51_current_melody.w],x)
 714  0149 cd001f        	call	L17_Buzzer_SetFrequency
 716                     ; 518 }
 718  014c 20c4          	jra	L22
 746                     ; 525 void Buzzer_Stop(void)
 746                     ; 526 {
 747                     	switch	.text
 748  014e               _Buzzer_Stop:
 752                     ; 530     Buzzer_Timer_Stop();
 754  014e cd0013        	call	L75_Buzzer_Timer_Stop
 756                     ; 536     current_melody = 0;
 758  0151 5f            	clrw	x
 759  0152 bf00          	ldw	L51_current_melody,x
 760                     ; 538     current_note = 0;
 762  0154 3f02          	clr	L71_current_note
 763                     ; 540     note_start_time = 0;
 765  0156 ae0000        	ldw	x,#0
 766  0159 bf05          	ldw	L12_note_start_time+2,x
 767  015b ae0000        	ldw	x,#0
 768  015e bf03          	ldw	L12_note_start_time,x
 769                     ; 542     buzzer_busy = FALSE;
 771  0160 3f07          	clr	L32_buzzer_busy
 772                     ; 543 }
 775  0162 81            	ret
 799                     ; 550 uint8_t Buzzer_IsBusy(void)
 799                     ; 551 {
 800                     	switch	.text
 801  0163               _Buzzer_IsBusy:
 805                     ; 552     return buzzer_busy;
 807  0163 b607          	ld	a,L32_buzzer_busy
 810  0165 81            	ret
 834                     ; 566 void Buzzer_TickISR(void)
 834                     ; 567 {
 835                     	switch	.text
 836  0166               _Buzzer_TickISR:
 840                     ; 571     TIM2_SR1 &= (uint8_t)(~TIM2_SR_UIF);
 842  0166 72115304      	bres	21252,#0
 843                     ; 580     GPIO_Toggle(
 843                     ; 581         BUZZER_PORT,
 843                     ; 582         BUZZER_PIN
 843                     ; 583     );
 845  016a ae0003        	ldw	x,#3
 846  016d cd0000        	call	_GPIO_Toggle
 848                     ; 584 }
 851  0170 81            	ret
 965                     	xref	_Timer_GetTick
 966                     	xref	_GPIO_Toggle
 967                     	xref	_GPIO_Clear
 968                     	xref	_GPIO_Set
 969                     	xref	_GPIO_Output_PP
 970                     	xdef	_Buzzer_TickISR
 971                     	xdef	_Buzzer_IsBusy
 972                     	xdef	_Buzzer_Stop
 973                     	xdef	_Buzzer_Play
 974                     	xdef	_Buzzer_Task
 975                     	xdef	_Buzzer_Init
 976                     	xref.b	c_lreg
 977                     	xref.b	c_x
 996                     	xref	c_lcmp
 997                     	xref	c_lsub
 998                     	xref	c_ludv
 999                     	xref	c_rtol
1000                     	xref	c_uitolx
1001                     	end
