   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  64                     ; 18 int main(void)
  64                     ; 19 {
  66                     	switch	.text
  67  0000               _main:
  71                     ; 20     CLK_Init();
  73  0000 cd0000        	call	_CLK_Init
  75                     ; 22 Timer_Init();
  77  0003 cd0000        	call	_Timer_Init
  79                     ; 24 Button_Init();
  81  0006 cd0000        	call	_Button_Init
  83                     ; 26 ModeButton_Init();
  85  0009 cd0000        	call	_ModeButton_Init
  87                     ; 28 Debug_Init();
  89  000c cd0000        	call	_Debug_Init
  91                     ; 30 LED_Init();
  93  000f cd0000        	call	_LED_Init
  95                     ; 32 EEPROM_Init();
  97  0012 cd0000        	call	_EEPROM_Init
  99                     ; 34 Mode_Init();
 101  0015 cd0000        	call	_Mode_Init
 103                     ; 36 LED_Mode_Display(Mode_Get() + 1);
 105  0018 cd0000        	call	_Mode_Get
 107  001b 4c            	inc	a
 108  001c cd0000        	call	_LED_Mode_Display
 110                     ; 38 Debug_LogMode(
 110                     ; 39     Mode_Get(),
 110                     ; 40     Mode_GetCutTime()
 110                     ; 41 );
 112  001f cd0000        	call	_Mode_GetCutTime
 114  0022 89            	pushw	x
 115  0023 cd0000        	call	_Mode_Get
 117  0026 cd0000        	call	_Debug_LogMode
 119  0029 85            	popw	x
 120                     ; 43 QuickShifter_Init();
 122  002a cd0000        	call	_QuickShifter_Init
 124                     ; 45 Watchdog_Init();
 126  002d cd0000        	call	_Watchdog_Init
 128                     ; 47 __asm ("rim\n");
 131  0030 9a            rim
 133  0031               L12:
 134                     ; 51         Button_Update();
 136  0031 cd0000        	call	_Button_Update
 138                     ; 53         ModeButton_Update();
 140  0034 cd0000        	call	_ModeButton_Update
 142                     ; 55         QuickShifter_Task();
 144  0037 cd0000        	call	_QuickShifter_Task
 146                     ; 57 				Watchdog_Refresh();
 148  003a cd0000        	call	_Watchdog_Refresh
 150                     ; 59         if(ModeButton_GetPress())
 152  003d cd0000        	call	_ModeButton_GetPress
 154  0040 4d            	tnz	a
 155  0041 27ee          	jreq	L12
 156                     ; 61             Mode_Next();
 158  0043 cd0000        	call	_Mode_Next
 160                     ; 63 						LED_Mode_Display(Mode_Get() + 1);
 162  0046 cd0000        	call	_Mode_Get
 164  0049 4c            	inc	a
 165  004a cd0000        	call	_LED_Mode_Display
 167                     ; 65             Debug_LogMode(
 167                     ; 66                 Mode_Get(),
 167                     ; 67                 Mode_GetCutTime()
 167                     ; 68             );
 169  004d cd0000        	call	_Mode_GetCutTime
 171  0050 89            	pushw	x
 172  0051 cd0000        	call	_Mode_Get
 174  0054 cd0000        	call	_Debug_LogMode
 176  0057 85            	popw	x
 177  0058 20d7          	jra	L12
 190                     	xdef	_main
 191                     	xref	_Debug_LogMode
 192                     	xref	_Debug_Init
 193                     	xref	_LED_Mode_Display
 194                     	xref	_LED_Init
 195                     	xref	_Watchdog_Refresh
 196                     	xref	_Watchdog_Init
 197                     	xref	_EEPROM_Init
 198                     	xref	_Mode_GetCutTime
 199                     	xref	_Mode_Get
 200                     	xref	_Mode_Next
 201                     	xref	_Mode_Init
 202                     	xref	_QuickShifter_Task
 203                     	xref	_QuickShifter_Init
 204                     	xref	_CLK_Init
 205                     	xref	_Timer_Init
 206                     	xref	_ModeButton_GetPress
 207                     	xref	_ModeButton_Update
 208                     	xref	_ModeButton_Init
 209                     	xref	_Button_Update
 210                     	xref	_Button_Init
 229                     	end
