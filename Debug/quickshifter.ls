   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  43                     ; 9 void QuickShifter_Init(void)
  43                     ; 10 {
  45                     	switch	.text
  46  0000               _QuickShifter_Init:
  50                     ; 11     GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
  52  0000 ae0002        	ldw	x,#2
  53  0003 cd0000        	call	_GPIO_Output_PP
  55                     ; 12 }
  58  0006 81            	ret
  85                     ; 14 void QuickShifter_Task(void)
  85                     ; 15 {
  86                     	switch	.text
  87  0007               _QuickShifter_Task:
  91                     ; 16     if(Button_GetPress())
  93  0007 cd0000        	call	_Button_GetPress
  95  000a 4d            	tnz	a
  96  000b 2712          	jreq	L13
  97                     ; 18         GPIO_Set(RELAY_PORT, RELAY_PIN);
  99  000d ae0002        	ldw	x,#2
 100  0010 cd0000        	call	_GPIO_Set
 102                     ; 20         TIM4_Delay_ms(SHIFT_TIME_MS);
 104  0013 ae0028        	ldw	x,#40
 105  0016 cd0000        	call	_TIM4_Delay_ms
 107                     ; 22         GPIO_Clear(RELAY_PORT, RELAY_PIN);
 109  0019 ae0002        	ldw	x,#2
 110  001c cd0000        	call	_GPIO_Clear
 112  001f               L13:
 113                     ; 24 }
 116  001f 81            	ret
 129                     	xref	_TIM4_Delay_ms
 130                     	xref	_GPIO_Clear
 131                     	xref	_GPIO_Set
 132                     	xref	_GPIO_Output_PP
 133                     	xref	_Button_GetPress
 134                     	xdef	_QuickShifter_Task
 135                     	xdef	_QuickShifter_Init
 154                     	end
