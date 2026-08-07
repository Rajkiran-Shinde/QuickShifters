   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  43                     ; 6 void Button_Init(void)
  43                     ; 7 {
  45                     	switch	.text
  46  0000               _Button_Init:
  50                     ; 8     GPIO_Input_PU(BUTTON_PORT,BUTTON_PIN);
  52  0000 ae0003        	ldw	x,#3
  53  0003 cd0000        	call	_GPIO_Input_PU
  55                     ; 9 }
  58  0006 81            	ret
  83                     ; 11 uint8_t Button_GetPress(void)
  83                     ; 12 {
  84                     	switch	.text
  85  0007               _Button_GetPress:
  89                     ; 13     if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE)
  91  0007 ae0003        	ldw	x,#3
  92  000a cd0000        	call	_GPIO_Read
  94  000d 4d            	tnz	a
  95  000e 2621          	jrne	L13
  96                     ; 15         TIM4_Delay_ms(20);
  98  0010 ae0014        	ldw	x,#20
  99  0013 cd0000        	call	_TIM4_Delay_ms
 101                     ; 17         if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE)
 103  0016 ae0003        	ldw	x,#3
 104  0019 cd0000        	call	_GPIO_Read
 106  001c 4d            	tnz	a
 107  001d 2612          	jrne	L13
 109  001f               L73:
 110                     ; 19             while(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE);
 112  001f ae0003        	ldw	x,#3
 113  0022 cd0000        	call	_GPIO_Read
 115  0025 4d            	tnz	a
 116  0026 27f7          	jreq	L73
 117                     ; 21             TIM4_Delay_ms(20);
 119  0028 ae0014        	ldw	x,#20
 120  002b cd0000        	call	_TIM4_Delay_ms
 122                     ; 23             return TRUE;
 124  002e a601          	ld	a,#1
 127  0030 81            	ret
 128  0031               L13:
 129                     ; 27     return FALSE;
 131  0031 4f            	clr	a
 134  0032 81            	ret
 147                     	xref	_TIM4_Delay_ms
 148                     	xref	_GPIO_Read
 149                     	xref	_GPIO_Input_PU
 150                     	xdef	_Button_GetPress
 151                     	xdef	_Button_Init
 170                     	end
