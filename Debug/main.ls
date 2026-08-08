   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  62                     ; 17 int main(void)
  62                     ; 18 {
  64                     	switch	.text
  65  0000               _main:
  69                     ; 19     CLK_Init();
  71  0000 cd0000        	call	_CLK_Init
  73                     ; 21 Timer_Init();
  75  0003 cd0000        	call	_Timer_Init
  77                     ; 23 Button_Init();
  79  0006 cd0000        	call	_Button_Init
  81                     ; 25 ModeButton_Init();
  83  0009 cd0000        	call	_ModeButton_Init
  85                     ; 27 Debug_Init();
  87  000c cd0000        	call	_Debug_Init
  89                     ; 29 EEPROM_Init();
  91  000f cd0000        	call	_EEPROM_Init
  93                     ; 31 Mode_Init();
  95  0012 cd0000        	call	_Mode_Init
  97                     ; 33 Debug_LogMode(
  97                     ; 34     Mode_Get(),
  97                     ; 35     Mode_GetCutTime()
  97                     ; 36 );
  99  0015 cd0000        	call	_Mode_GetCutTime
 101  0018 89            	pushw	x
 102  0019 cd0000        	call	_Mode_Get
 104  001c cd0000        	call	_Debug_LogMode
 106  001f 85            	popw	x
 107                     ; 38 QuickShifter_Init();
 109  0020 cd0000        	call	_QuickShifter_Init
 111                     ; 40 Watchdog_Init();
 113  0023 cd0000        	call	_Watchdog_Init
 115                     ; 42 __asm ("rim\n");
 118  0026 9a            rim
 120  0027               L12:
 121                     ; 46         Button_Update();
 123  0027 cd0000        	call	_Button_Update
 125                     ; 48         ModeButton_Update();
 127  002a cd0000        	call	_ModeButton_Update
 129                     ; 50         QuickShifter_Task();
 131  002d cd0000        	call	_QuickShifter_Task
 133                     ; 52 				Watchdog_Refresh();
 135  0030 cd0000        	call	_Watchdog_Refresh
 137                     ; 54         if(ModeButton_GetPress())
 139  0033 cd0000        	call	_ModeButton_GetPress
 141  0036 4d            	tnz	a
 142  0037 27ee          	jreq	L12
 143                     ; 56             Mode_Next();
 145  0039 cd0000        	call	_Mode_Next
 147                     ; 58             Debug_LogMode(
 147                     ; 59                 Mode_Get(),
 147                     ; 60                 Mode_GetCutTime()
 147                     ; 61             );
 149  003c cd0000        	call	_Mode_GetCutTime
 151  003f 89            	pushw	x
 152  0040 cd0000        	call	_Mode_Get
 154  0043 cd0000        	call	_Debug_LogMode
 156  0046 85            	popw	x
 157  0047 20de          	jra	L12
 170                     	xdef	_main
 171                     	xref	_Debug_LogMode
 172                     	xref	_Debug_Init
 173                     	xref	_Watchdog_Refresh
 174                     	xref	_Watchdog_Init
 175                     	xref	_EEPROM_Init
 176                     	xref	_Mode_GetCutTime
 177                     	xref	_Mode_Get
 178                     	xref	_Mode_Next
 179                     	xref	_Mode_Init
 180                     	xref	_QuickShifter_Task
 181                     	xref	_QuickShifter_Init
 182                     	xref	_CLK_Init
 183                     	xref	_Timer_Init
 184                     	xref	_ModeButton_GetPress
 185                     	xref	_ModeButton_Update
 186                     	xref	_ModeButton_Init
 187                     	xref	_Button_Update
 188                     	xref	_Button_Init
 207                     	end
