   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  60                     ; 16 int main(void)
  60                     ; 17 {
  62                     	switch	.text
  63  0000               _main:
  67                     ; 18     CLK_Init();
  69  0000 cd0000        	call	_CLK_Init
  71                     ; 20 Timer_Init();
  73  0003 cd0000        	call	_Timer_Init
  75                     ; 22 Button_Init();
  77  0006 cd0000        	call	_Button_Init
  79                     ; 24 ModeButton_Init();
  81  0009 cd0000        	call	_ModeButton_Init
  83                     ; 26 Debug_Init();
  85  000c cd0000        	call	_Debug_Init
  87                     ; 28 EEPROM_Init();
  89  000f cd0000        	call	_EEPROM_Init
  91                     ; 30 Mode_Init();
  93  0012 cd0000        	call	_Mode_Init
  95                     ; 32 Debug_LogMode(
  95                     ; 33     Mode_Get(),
  95                     ; 34     Mode_GetCutTime()
  95                     ; 35 );
  97  0015 cd0000        	call	_Mode_GetCutTime
  99  0018 89            	pushw	x
 100  0019 cd0000        	call	_Mode_Get
 102  001c cd0000        	call	_Debug_LogMode
 104  001f 85            	popw	x
 105                     ; 37 QuickShifter_Init();
 107  0020 cd0000        	call	_QuickShifter_Init
 109                     ; 39 __asm ("rim\n");
 112  0023 9a            rim
 114  0024               L12:
 115                     ; 43         Button_Update();
 117  0024 cd0000        	call	_Button_Update
 119                     ; 45         ModeButton_Update();
 121  0027 cd0000        	call	_ModeButton_Update
 123                     ; 47         QuickShifter_Task();
 125  002a cd0000        	call	_QuickShifter_Task
 127                     ; 49         if(ModeButton_GetPress())
 129  002d cd0000        	call	_ModeButton_GetPress
 131  0030 4d            	tnz	a
 132  0031 27f1          	jreq	L12
 133                     ; 51             Mode_Next();
 135  0033 cd0000        	call	_Mode_Next
 137                     ; 53             Debug_LogMode(
 137                     ; 54                 Mode_Get(),
 137                     ; 55                 Mode_GetCutTime()
 137                     ; 56             );
 139  0036 cd0000        	call	_Mode_GetCutTime
 141  0039 89            	pushw	x
 142  003a cd0000        	call	_Mode_Get
 144  003d cd0000        	call	_Debug_LogMode
 146  0040 85            	popw	x
 147  0041 20e1          	jra	L12
 160                     	xdef	_main
 161                     	xref	_Debug_LogMode
 162                     	xref	_Debug_Init
 163                     	xref	_EEPROM_Init
 164                     	xref	_Mode_GetCutTime
 165                     	xref	_Mode_Get
 166                     	xref	_Mode_Next
 167                     	xref	_Mode_Init
 168                     	xref	_QuickShifter_Task
 169                     	xref	_QuickShifter_Init
 170                     	xref	_CLK_Init
 171                     	xref	_Timer_Init
 172                     	xref	_ModeButton_GetPress
 173                     	xref	_ModeButton_Update
 174                     	xref	_ModeButton_Init
 175                     	xref	_Button_Update
 176                     	xref	_Button_Init
 195                     	end
