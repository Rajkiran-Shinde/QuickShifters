   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 17 @far @interrupt void NonHandledInterrupt(void)
  44                     ; 18 {
  45                     	switch	.text
  46  0000               f_NonHandledInterrupt:
  50                     ; 20     return;
  53  0000 80            	iret
  77                     ; 29 INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
  77                     ; 30 {
  78                     	switch	.text
  79  0001               f_TIM2_UPD_OVF_BRK_IRQHandler:
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
  94                     ; 31     Buzzer_TickISR();
  96  0013 cd0000        	call	_Buzzer_TickISR
  98                     ; 32 }
 101  0016 85            	popw	x
 102  0017 bf00          	ldw	c_y,x
 103  0019 320002        	pop	c_y+2
 104  001c 85            	popw	x
 105  001d bf00          	ldw	c_x,x
 106  001f 320002        	pop	c_x+2
 107  0022 80            	iret
 131                     ; 37 INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
 131                     ; 38 {
 132                     	switch	.text
 133  0023               f_TIM4_UPD_OVF_IRQHandler:
 135  0023 8a            	push	cc
 136  0024 84            	pop	a
 137  0025 a4bf          	and	a,#191
 138  0027 88            	push	a
 139  0028 86            	pop	cc
 140  0029 3b0002        	push	c_x+2
 141  002c be00          	ldw	x,c_x
 142  002e 89            	pushw	x
 143  002f 3b0002        	push	c_y+2
 144  0032 be00          	ldw	x,c_y
 145  0034 89            	pushw	x
 148                     ; 40     TIM4_SR &= (uint8_t)(~0x01);
 150  0035 72115344      	bres	21316,#0
 151                     ; 43     Timer_TickISR();
 153  0039 cd0000        	call	_Timer_TickISR
 155                     ; 44 }
 158  003c 85            	popw	x
 159  003d bf00          	ldw	c_y,x
 160  003f 320002        	pop	c_y+2
 161  0042 85            	popw	x
 162  0043 bf00          	ldw	c_x,x
 163  0045 320002        	pop	c_x+2
 164  0048 80            	iret
 166                     .const:	section	.text
 167  0000               __vectab:
 168  0000 82            	dc.b	130
 170  0001 00            	dc.b	page(__stext)
 171  0002 0000          	dc.w	__stext
 172  0004 82            	dc.b	130
 174  0005 00            	dc.b	page(f_NonHandledInterrupt)
 175  0006 0000          	dc.w	f_NonHandledInterrupt
 176  0008 82            	dc.b	130
 178  0009 00            	dc.b	page(f_NonHandledInterrupt)
 179  000a 0000          	dc.w	f_NonHandledInterrupt
 180  000c 82            	dc.b	130
 182  000d 00            	dc.b	page(f_NonHandledInterrupt)
 183  000e 0000          	dc.w	f_NonHandledInterrupt
 184  0010 82            	dc.b	130
 186  0011 00            	dc.b	page(f_NonHandledInterrupt)
 187  0012 0000          	dc.w	f_NonHandledInterrupt
 188  0014 82            	dc.b	130
 190  0015 00            	dc.b	page(f_NonHandledInterrupt)
 191  0016 0000          	dc.w	f_NonHandledInterrupt
 192  0018 82            	dc.b	130
 194  0019 00            	dc.b	page(f_NonHandledInterrupt)
 195  001a 0000          	dc.w	f_NonHandledInterrupt
 196  001c 82            	dc.b	130
 198  001d 00            	dc.b	page(f_NonHandledInterrupt)
 199  001e 0000          	dc.w	f_NonHandledInterrupt
 200  0020 82            	dc.b	130
 202  0021 00            	dc.b	page(f_NonHandledInterrupt)
 203  0022 0000          	dc.w	f_NonHandledInterrupt
 204  0024 82            	dc.b	130
 206  0025 00            	dc.b	page(f_NonHandledInterrupt)
 207  0026 0000          	dc.w	f_NonHandledInterrupt
 208  0028 82            	dc.b	130
 210  0029 00            	dc.b	page(f_NonHandledInterrupt)
 211  002a 0000          	dc.w	f_NonHandledInterrupt
 212  002c 82            	dc.b	130
 214  002d 00            	dc.b	page(f_NonHandledInterrupt)
 215  002e 0000          	dc.w	f_NonHandledInterrupt
 216  0030 82            	dc.b	130
 218  0031 00            	dc.b	page(f_NonHandledInterrupt)
 219  0032 0000          	dc.w	f_NonHandledInterrupt
 220  0034 82            	dc.b	130
 222  0035 00            	dc.b	page(f_NonHandledInterrupt)
 223  0036 0000          	dc.w	f_NonHandledInterrupt
 224  0038 82            	dc.b	130
 226  0039 00            	dc.b	page(f_NonHandledInterrupt)
 227  003a 0000          	dc.w	f_NonHandledInterrupt
 228  003c 82            	dc.b	130
 230  003d 01            	dc.b	page(f_TIM2_UPD_OVF_BRK_IRQHandler)
 231  003e 0001          	dc.w	f_TIM2_UPD_OVF_BRK_IRQHandler
 232  0040 82            	dc.b	130
 234  0041 00            	dc.b	page(f_NonHandledInterrupt)
 235  0042 0000          	dc.w	f_NonHandledInterrupt
 236  0044 82            	dc.b	130
 238  0045 00            	dc.b	page(f_NonHandledInterrupt)
 239  0046 0000          	dc.w	f_NonHandledInterrupt
 240  0048 82            	dc.b	130
 242  0049 00            	dc.b	page(f_NonHandledInterrupt)
 243  004a 0000          	dc.w	f_NonHandledInterrupt
 244  004c 82            	dc.b	130
 246  004d 00            	dc.b	page(f_NonHandledInterrupt)
 247  004e 0000          	dc.w	f_NonHandledInterrupt
 248  0050 82            	dc.b	130
 250  0051 00            	dc.b	page(f_NonHandledInterrupt)
 251  0052 0000          	dc.w	f_NonHandledInterrupt
 252  0054 82            	dc.b	130
 254  0055 00            	dc.b	page(f_NonHandledInterrupt)
 255  0056 0000          	dc.w	f_NonHandledInterrupt
 256  0058 82            	dc.b	130
 258  0059 00            	dc.b	page(f_NonHandledInterrupt)
 259  005a 0000          	dc.w	f_NonHandledInterrupt
 260  005c 82            	dc.b	130
 262  005d 00            	dc.b	page(f_NonHandledInterrupt)
 263  005e 0000          	dc.w	f_NonHandledInterrupt
 264  0060 82            	dc.b	130
 266  0061 00            	dc.b	page(f_NonHandledInterrupt)
 267  0062 0000          	dc.w	f_NonHandledInterrupt
 268  0064 82            	dc.b	130
 270  0065 23            	dc.b	page(f_TIM4_UPD_OVF_IRQHandler)
 271  0066 0023          	dc.w	f_TIM4_UPD_OVF_IRQHandler
 272  0068 82            	dc.b	130
 274  0069 00            	dc.b	page(f_NonHandledInterrupt)
 275  006a 0000          	dc.w	f_NonHandledInterrupt
 276  006c 82            	dc.b	130
 278  006d 00            	dc.b	page(f_NonHandledInterrupt)
 279  006e 0000          	dc.w	f_NonHandledInterrupt
 280  0070 82            	dc.b	130
 282  0071 00            	dc.b	page(f_NonHandledInterrupt)
 283  0072 0000          	dc.w	f_NonHandledInterrupt
 284  0074 82            	dc.b	130
 286  0075 00            	dc.b	page(f_NonHandledInterrupt)
 287  0076 0000          	dc.w	f_NonHandledInterrupt
 288  0078 82            	dc.b	130
 290  0079 00            	dc.b	page(f_NonHandledInterrupt)
 291  007a 0000          	dc.w	f_NonHandledInterrupt
 292  007c 82            	dc.b	130
 294  007d 00            	dc.b	page(f_NonHandledInterrupt)
 295  007e 0000          	dc.w	f_NonHandledInterrupt
 346                     	xdef	__vectab
 347                     	xdef	f_TIM4_UPD_OVF_IRQHandler
 348                     	xdef	f_TIM2_UPD_OVF_BRK_IRQHandler
 349                     	xref	__stext
 350                     	xdef	f_NonHandledInterrupt
 351                     	xref	_Buzzer_TickISR
 352                     	xref	_Timer_TickISR
 353                     	xref.b	c_x
 354                     	xref.b	c_y
 373                     	end
