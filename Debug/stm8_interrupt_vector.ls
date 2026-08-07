   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 16 @far @interrupt void NonHandledInterrupt(void)
  44                     ; 17 {
  45                     	switch	.text
  46  0000               f_NonHandledInterrupt:
  50                     ; 19     return;
  53  0000 80            	iret
  77                     ; 28 INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
  77                     ; 29 {
  78                     	switch	.text
  79  0001               f_TIM4_UPD_OVF_IRQHandler:
  81  0001 8a            	push	cc
  82  0002 84            	pop	a
  83  0003 a4bf          	and	a,#191
  84  0005 88            	push	a
  85  0006 86            	pop	cc
  86  0007 3b0002        	push	c_x+2
  87  000a be00          	ldw	x,c_x
  88  000c 89            	pushw	x
  89  000d 3b0002        	push	c_y+2
  90  0010 be00          	ldw	x,c_y
  91  0012 89            	pushw	x
  94                     ; 31     TIM4_SR &= (uint8_t)(~0x01);
  96  0013 72115344      	bres	21316,#0
  97                     ; 34     Timer_TickISR();
  99  0017 cd0000        	call	_Timer_TickISR
 101                     ; 35 }
 104  001a 85            	popw	x
 105  001b bf00          	ldw	c_y,x
 106  001d 320002        	pop	c_y+2
 107  0020 85            	popw	x
 108  0021 bf00          	ldw	c_x,x
 109  0023 320002        	pop	c_x+2
 110  0026 80            	iret
 112                     .const:	section	.text
 113  0000               __vectab:
 114  0000 82            	dc.b	130
 116  0001 00            	dc.b	page(__stext)
 117  0002 0000          	dc.w	__stext
 118  0004 82            	dc.b	130
 120  0005 00            	dc.b	page(f_NonHandledInterrupt)
 121  0006 0000          	dc.w	f_NonHandledInterrupt
 122  0008 82            	dc.b	130
 124  0009 00            	dc.b	page(f_NonHandledInterrupt)
 125  000a 0000          	dc.w	f_NonHandledInterrupt
 126  000c 82            	dc.b	130
 128  000d 00            	dc.b	page(f_NonHandledInterrupt)
 129  000e 0000          	dc.w	f_NonHandledInterrupt
 130  0010 82            	dc.b	130
 132  0011 00            	dc.b	page(f_NonHandledInterrupt)
 133  0012 0000          	dc.w	f_NonHandledInterrupt
 134  0014 82            	dc.b	130
 136  0015 00            	dc.b	page(f_NonHandledInterrupt)
 137  0016 0000          	dc.w	f_NonHandledInterrupt
 138  0018 82            	dc.b	130
 140  0019 00            	dc.b	page(f_NonHandledInterrupt)
 141  001a 0000          	dc.w	f_NonHandledInterrupt
 142  001c 82            	dc.b	130
 144  001d 00            	dc.b	page(f_NonHandledInterrupt)
 145  001e 0000          	dc.w	f_NonHandledInterrupt
 146  0020 82            	dc.b	130
 148  0021 00            	dc.b	page(f_NonHandledInterrupt)
 149  0022 0000          	dc.w	f_NonHandledInterrupt
 150  0024 82            	dc.b	130
 152  0025 00            	dc.b	page(f_NonHandledInterrupt)
 153  0026 0000          	dc.w	f_NonHandledInterrupt
 154  0028 82            	dc.b	130
 156  0029 00            	dc.b	page(f_NonHandledInterrupt)
 157  002a 0000          	dc.w	f_NonHandledInterrupt
 158  002c 82            	dc.b	130
 160  002d 00            	dc.b	page(f_NonHandledInterrupt)
 161  002e 0000          	dc.w	f_NonHandledInterrupt
 162  0030 82            	dc.b	130
 164  0031 00            	dc.b	page(f_NonHandledInterrupt)
 165  0032 0000          	dc.w	f_NonHandledInterrupt
 166  0034 82            	dc.b	130
 168  0035 00            	dc.b	page(f_NonHandledInterrupt)
 169  0036 0000          	dc.w	f_NonHandledInterrupt
 170  0038 82            	dc.b	130
 172  0039 00            	dc.b	page(f_NonHandledInterrupt)
 173  003a 0000          	dc.w	f_NonHandledInterrupt
 174  003c 82            	dc.b	130
 176  003d 00            	dc.b	page(f_NonHandledInterrupt)
 177  003e 0000          	dc.w	f_NonHandledInterrupt
 178  0040 82            	dc.b	130
 180  0041 00            	dc.b	page(f_NonHandledInterrupt)
 181  0042 0000          	dc.w	f_NonHandledInterrupt
 182  0044 82            	dc.b	130
 184  0045 00            	dc.b	page(f_NonHandledInterrupt)
 185  0046 0000          	dc.w	f_NonHandledInterrupt
 186  0048 82            	dc.b	130
 188  0049 00            	dc.b	page(f_NonHandledInterrupt)
 189  004a 0000          	dc.w	f_NonHandledInterrupt
 190  004c 82            	dc.b	130
 192  004d 00            	dc.b	page(f_NonHandledInterrupt)
 193  004e 0000          	dc.w	f_NonHandledInterrupt
 194  0050 82            	dc.b	130
 196  0051 00            	dc.b	page(f_NonHandledInterrupt)
 197  0052 0000          	dc.w	f_NonHandledInterrupt
 198  0054 82            	dc.b	130
 200  0055 00            	dc.b	page(f_NonHandledInterrupt)
 201  0056 0000          	dc.w	f_NonHandledInterrupt
 202  0058 82            	dc.b	130
 204  0059 00            	dc.b	page(f_NonHandledInterrupt)
 205  005a 0000          	dc.w	f_NonHandledInterrupt
 206  005c 82            	dc.b	130
 208  005d 00            	dc.b	page(f_NonHandledInterrupt)
 209  005e 0000          	dc.w	f_NonHandledInterrupt
 210  0060 82            	dc.b	130
 212  0061 00            	dc.b	page(f_NonHandledInterrupt)
 213  0062 0000          	dc.w	f_NonHandledInterrupt
 214  0064 82            	dc.b	130
 216  0065 01            	dc.b	page(f_TIM4_UPD_OVF_IRQHandler)
 217  0066 0001          	dc.w	f_TIM4_UPD_OVF_IRQHandler
 218  0068 82            	dc.b	130
 220  0069 00            	dc.b	page(f_NonHandledInterrupt)
 221  006a 0000          	dc.w	f_NonHandledInterrupt
 222  006c 82            	dc.b	130
 224  006d 00            	dc.b	page(f_NonHandledInterrupt)
 225  006e 0000          	dc.w	f_NonHandledInterrupt
 226  0070 82            	dc.b	130
 228  0071 00            	dc.b	page(f_NonHandledInterrupt)
 229  0072 0000          	dc.w	f_NonHandledInterrupt
 230  0074 82            	dc.b	130
 232  0075 00            	dc.b	page(f_NonHandledInterrupt)
 233  0076 0000          	dc.w	f_NonHandledInterrupt
 234  0078 82            	dc.b	130
 236  0079 00            	dc.b	page(f_NonHandledInterrupt)
 237  007a 0000          	dc.w	f_NonHandledInterrupt
 238  007c 82            	dc.b	130
 240  007d 00            	dc.b	page(f_NonHandledInterrupt)
 241  007e 0000          	dc.w	f_NonHandledInterrupt
 292                     	xdef	__vectab
 293                     	xdef	f_TIM4_UPD_OVF_IRQHandler
 294                     	xref	__stext
 295                     	xdef	f_NonHandledInterrupt
 296                     	xref	_Timer_TickISR
 297                     	xref.b	c_x
 298                     	xref.b	c_y
 317                     	end
