   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     	bsct
  15  0000               _system_tick:
  16  0000 00000000      	dc.l	0
  45                     ; 34 void Timer_Init(void)
  45                     ; 35 {
  47                     	switch	.text
  48  0000               _Timer_Init:
  52                     ; 37     TIM4_CR1 = 0x00;
  54  0000 725f5340      	clr	21312
  55                     ; 51     TIM4_PSCR = 0x07;     // Divide by 128
  57  0004 35075347      	mov	21319,#7
  58                     ; 52     TIM4_ARR  = 124;
  60  0008 357c5348      	mov	21320,#124
  61                     ; 54     TIM4_CNTR = 0;
  63  000c 725f5346      	clr	21318
  64                     ; 57     TIM4_SR &= (uint8_t)(~TIM4_SR_UIF);
  66  0010 72115344      	bres	21316,#0
  67                     ; 60     TIM4_IER |= TIM4_IER_UIE;
  69  0014 72105343      	bset	21315,#0
  70                     ; 63     TIM4_CR1 |= TIM4_CR1_CEN;
  72  0018 72105340      	bset	21312,#0
  73                     ; 64 }
  76  001c 81            	ret
 100                     ; 70 void Timer_TickISR(void)
 100                     ; 71 {
 101                     	switch	.text
 102  001d               _Timer_TickISR:
 106                     ; 72     system_tick++;
 108  001d ae0000        	ldw	x,#_system_tick
 109  0020 a601          	ld	a,#1
 110  0022 cd0000        	call	c_lgadc
 112                     ; 73 }
 115  0025 81            	ret
 152                     ; 79 uint32_t Timer_GetTick(void)
 152                     ; 80 {
 153                     	switch	.text
 154  0026               _Timer_GetTick:
 156  0026 5204          	subw	sp,#4
 157       00000004      OFST:	set	4
 160                     ; 83     __asm("sim");
 163  0028 9b            sim
 165                     ; 85     tick = system_tick;
 167  0029 be02          	ldw	x,_system_tick+2
 168  002b 1f03          	ldw	(OFST-1,sp),x
 169  002d be00          	ldw	x,_system_tick
 170  002f 1f01          	ldw	(OFST-3,sp),x
 172                     ; 87     __asm("rim");
 175  0031 9a            rim
 177                     ; 89     return tick;
 179  0032 96            	ldw	x,sp
 180  0033 1c0001        	addw	x,#OFST-3
 181  0036 cd0000        	call	c_ltor
 185  0039 5b04          	addw	sp,#4
 186  003b 81            	ret
 230                     ; 96 void Timer_Delay(uint32_t ms)
 230                     ; 97 {
 231                     	switch	.text
 232  003c               _Timer_Delay:
 234  003c 5204          	subw	sp,#4
 235       00000004      OFST:	set	4
 238                     ; 98     uint32_t start = Timer_GetTick();
 240  003e ade6          	call	_Timer_GetTick
 242  0040 96            	ldw	x,sp
 243  0041 1c0001        	addw	x,#OFST-3
 244  0044 cd0000        	call	c_rtol
 248  0047               L57:
 249                     ; 100     while((Timer_GetTick() - start) < ms)
 251  0047 addd          	call	_Timer_GetTick
 253  0049 96            	ldw	x,sp
 254  004a 1c0001        	addw	x,#OFST-3
 255  004d cd0000        	call	c_lsub
 257  0050 96            	ldw	x,sp
 258  0051 1c0007        	addw	x,#OFST+3
 259  0054 cd0000        	call	c_lcmp
 261  0057 25ee          	jrult	L57
 262                     ; 104 }
 265  0059 5b04          	addw	sp,#4
 266  005b 81            	ret
 290                     	xdef	_system_tick
 291                     	xdef	_Timer_TickISR
 292                     	xdef	_Timer_Delay
 293                     	xdef	_Timer_GetTick
 294                     	xdef	_Timer_Init
 313                     	xref	c_lcmp
 314                     	xref	c_lsub
 315                     	xref	c_rtol
 316                     	xref	c_ltor
 317                     	xref	c_lgadc
 318                     	end
