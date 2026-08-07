   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  47                     ; 8 int main(void)
  47                     ; 9 {
  49                     	switch	.text
  50  0000               _main:
  54                     ; 10     CLK_Init();
  56  0000 cd0000        	call	_CLK_Init
  58                     ; 12     TIM4_Init();
  60  0003 cd0000        	call	_TIM4_Init
  62                     ; 14     Button_Init();
  64  0006 cd0000        	call	_Button_Init
  66                     ; 16     QuickShifter_Init();
  68  0009 cd0000        	call	_QuickShifter_Init
  70  000c               L12:
  71                     ; 20         QuickShifter_Task();
  73  000c cd0000        	call	_QuickShifter_Task
  76  000f 20fb          	jra	L12
  89                     	xdef	_main
  90                     	xref	_QuickShifter_Task
  91                     	xref	_QuickShifter_Init
  92                     	xref	_CLK_Init
  93                     	xref	_TIM4_Init
  94                     	xref	_Button_Init
 113                     	end
