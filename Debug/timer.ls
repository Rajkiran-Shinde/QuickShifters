   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 4 void TIM4_Init(void)
  42                     ; 5 {
  44                     	switch	.text
  45  0000               _TIM4_Init:
  49                     ; 6     TIM4_PSCR = 7;      // Divide by 128
  51  0000 35075347      	mov	21319,#7
  52                     ; 8     TIM4_ARR = 124;     // 1ms @16MHz
  54  0004 357c5348      	mov	21320,#124
  55                     ; 10     TIM4_CR1 = 0x01;    // Enable Timer
  57  0008 35015340      	mov	21312,#1
  58                     ; 11 }
  61  000c 81            	ret
  95                     ; 13 void TIM4_Delay_ms(uint16_t ms)
  95                     ; 14 {
  96                     	switch	.text
  97  000d               _TIM4_Delay_ms:
  99  000d 89            	pushw	x
 100       00000000      OFST:	set	0
 103  000e 200f          	jra	L14
 104  0010               L73:
 105                     ; 17         TIM4_SR &= ~(1<<0);
 107  0010 72115344      	bres	21316,#0
 109  0014               L74:
 110                     ; 19         while(!(TIM4_SR & (1<<0)));
 112  0014 c65344        	ld	a,21316
 113  0017 a501          	bcp	a,#1
 114  0019 27f9          	jreq	L74
 115                     ; 21         TIM4_SR &= ~(1<<0);
 117  001b 72115344      	bres	21316,#0
 118  001f               L14:
 119                     ; 15     while(ms--)
 121  001f 1e01          	ldw	x,(OFST+1,sp)
 122  0021 1d0001        	subw	x,#1
 123  0024 1f01          	ldw	(OFST+1,sp),x
 124  0026 1c0001        	addw	x,#1
 125  0029 a30000        	cpw	x,#0
 126  002c 26e2          	jrne	L73
 127                     ; 23 }
 130  002e 85            	popw	x
 131  002f 81            	ret
 144                     	xdef	_TIM4_Delay_ms
 145                     	xdef	_TIM4_Init
 164                     	end
