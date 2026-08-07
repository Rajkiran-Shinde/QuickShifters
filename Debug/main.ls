   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  50                     ; 9 int main(void)
  50                     ; 10 {
  52                     	switch	.text
  53  0000               _main:
  57                     ; 12     CLK_Init();
  59  0000 cd0000        	call	_CLK_Init
  61                     ; 14     Timer_Init();
  63  0003 cd0000        	call	_Timer_Init
  65                     ; 16     Button_Init();
  67  0006 cd0000        	call	_Button_Init
  69                     ; 18     QuickShifter_Init();
  71  0009 cd0000        	call	_QuickShifter_Init
  73                     ; 20 		__asm ("rim\n");
  76  000c 9a            rim
  78  000d               L12:
  79                     ; 24 				Button_Update();
  81  000d cd0000        	call	_Button_Update
  83                     ; 25         QuickShifter_Task();
  85  0010 cd0000        	call	_QuickShifter_Task
  88  0013 20f8          	jra	L12
 101                     	xdef	_main
 102                     	xref	_QuickShifter_Task
 103                     	xref	_QuickShifter_Init
 104                     	xref	_CLK_Init
 105                     	xref	_Timer_Init
 106                     	xref	_Button_Update
 107                     	xref	_Button_Init
 126                     	end
