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
 139                     ; 79 uint32_t Timer_GetTick(void)
 139                     ; 80 {
 140                     	switch	.text
 141  0026               _Timer_GetTick:
 145                     ; 81     return system_tick;
 147  0026 ae0000        	ldw	x,#_system_tick
 148  0029 cd0000        	call	c_ltor
 152  002c 81            	ret
 196                     ; 88 void Timer_Delay(uint32_t ms)
 196                     ; 89 {
 197                     	switch	.text
 198  002d               _Timer_Delay:
 200  002d 5204          	subw	sp,#4
 201       00000004      OFST:	set	4
 204                     ; 90     uint32_t start = Timer_GetTick();
 206  002f adf5          	call	_Timer_GetTick
 208  0031 96            	ldw	x,sp
 209  0032 1c0001        	addw	x,#OFST-3
 210  0035 cd0000        	call	c_rtol
 214  0038               L76:
 215                     ; 92     while((Timer_GetTick() - start) < ms)
 217  0038 adec          	call	_Timer_GetTick
 219  003a 96            	ldw	x,sp
 220  003b 1c0001        	addw	x,#OFST-3
 221  003e cd0000        	call	c_lsub
 223  0041 96            	ldw	x,sp
 224  0042 1c0007        	addw	x,#OFST+3
 225  0045 cd0000        	call	c_lcmp
 227  0048 25ee          	jrult	L76
 228                     ; 96 }
 231  004a 5b04          	addw	sp,#4
 232  004c 81            	ret
 256                     	xdef	_system_tick
 257                     	xdef	_Timer_TickISR
 258                     	xdef	_Timer_Delay
 259                     	xdef	_Timer_GetTick
 260                     	xdef	_Timer_Init
 279                     	xref	c_lcmp
 280                     	xref	c_lsub
 281                     	xref	c_rtol
 282                     	xref	c_ltor
 283                     	xref	c_lgadc
 284                     	end
