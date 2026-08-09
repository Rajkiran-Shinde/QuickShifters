   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  67                     ; 19 int main(void)
  67                     ; 20 {
  69                     	switch	.text
  70  0000               _main:
  74                     ; 21     CLK_Init();
  76  0000 cd0000        	call	_CLK_Init
  78                     ; 23 Timer_Init();
  80  0003 cd0000        	call	_Timer_Init
  82                     ; 25 Button_Init();
  84  0006 cd0000        	call	_Button_Init
  86                     ; 27 ModeButton_Init();
  88  0009 cd0000        	call	_ModeButton_Init
  90                     ; 29 Debug_Init();
  92  000c cd0000        	call	_Debug_Init
  94                     ; 31 LED_Init();
  96  000f cd0000        	call	_LED_Init
  98                     ; 33 Buzzer_Init();
 100  0012 cd0000        	call	_Buzzer_Init
 102                     ; 35 EEPROM_Init();
 104  0015 cd0000        	call	_EEPROM_Init
 106                     ; 37 Mode_Init();
 108  0018 cd0000        	call	_Mode_Init
 110                     ; 39 LED_Mode_Display(Mode_Get() + 1);
 112  001b cd0000        	call	_Mode_Get
 114  001e 4c            	inc	a
 115  001f cd0000        	call	_LED_Mode_Display
 117                     ; 41 Debug_LogMode(
 117                     ; 42     Mode_Get(),
 117                     ; 43     Mode_GetCutTime()
 117                     ; 44 );
 119  0022 cd0000        	call	_Mode_GetCutTime
 121  0025 89            	pushw	x
 122  0026 cd0000        	call	_Mode_Get
 124  0029 cd0000        	call	_Debug_LogMode
 126  002c 85            	popw	x
 127                     ; 46 QuickShifter_Init();
 129  002d cd0000        	call	_QuickShifter_Init
 131                     ; 48 Buzzer_Play(BUZZER_EVENT_BOOT);
 133  0030 4f            	clr	a
 134  0031 cd0000        	call	_Buzzer_Play
 136                     ; 50 Watchdog_Init();
 138  0034 cd0000        	call	_Watchdog_Init
 140                     ; 52 __asm ("rim\n");
 143  0037 9a            rim
 145  0038               L12:
 146                     ; 56         Button_Update();
 148  0038 cd0000        	call	_Button_Update
 150                     ; 58         ModeButton_Update();
 152  003b cd0000        	call	_ModeButton_Update
 154                     ; 60         QuickShifter_Task();
 156  003e cd0000        	call	_QuickShifter_Task
 158                     ; 62 				Buzzer_Task();
 160  0041 cd0000        	call	_Buzzer_Task
 162                     ; 64 				Watchdog_Refresh();
 164  0044 cd0000        	call	_Watchdog_Refresh
 166                     ; 70 if(ModeButton_GetPress())
 168  0047 cd0000        	call	_ModeButton_GetPress
 170  004a 4d            	tnz	a
 171  004b 271a          	jreq	L52
 172                     ; 75     Mode_Next();
 174  004d cd0000        	call	_Mode_Next
 176                     ; 81     LED_Mode_Display(
 176                     ; 82         Mode_Get() + 1
 176                     ; 83     );
 178  0050 cd0000        	call	_Mode_Get
 180  0053 4c            	inc	a
 181  0054 cd0000        	call	_LED_Mode_Display
 183                     ; 89     Buzzer_Play(
 183                     ; 90         BUZZER_EVENT_MODE_CHANGE
 183                     ; 91     );
 185  0057 a601          	ld	a,#1
 186  0059 cd0000        	call	_Buzzer_Play
 188                     ; 97     Debug_LogMode(
 188                     ; 98         Mode_Get(),
 188                     ; 99         Mode_GetCutTime()
 188                     ; 100     );
 190  005c cd0000        	call	_Mode_GetCutTime
 192  005f 89            	pushw	x
 193  0060 cd0000        	call	_Mode_Get
 195  0063 cd0000        	call	_Debug_LogMode
 197  0066 85            	popw	x
 198  0067               L52:
 199                     ; 108 QuickShifter_Task();
 201  0067 cd0000        	call	_QuickShifter_Task
 203                     ; 115 Buzzer_Task();
 205  006a cd0000        	call	_Buzzer_Task
 207                     ; 122 Watchdog_Refresh();
 209  006d cd0000        	call	_Watchdog_Refresh
 212  0070 20c6          	jra	L12
 225                     	xdef	_main
 226                     	xref	_Debug_LogMode
 227                     	xref	_Debug_Init
 228                     	xref	_Buzzer_Play
 229                     	xref	_Buzzer_Task
 230                     	xref	_Buzzer_Init
 231                     	xref	_LED_Mode_Display
 232                     	xref	_LED_Init
 233                     	xref	_Watchdog_Refresh
 234                     	xref	_Watchdog_Init
 235                     	xref	_EEPROM_Init
 236                     	xref	_Mode_GetCutTime
 237                     	xref	_Mode_Get
 238                     	xref	_Mode_Next
 239                     	xref	_Mode_Init
 240                     	xref	_QuickShifter_Task
 241                     	xref	_QuickShifter_Init
 242                     	xref	_CLK_Init
 243                     	xref	_Timer_Init
 244                     	xref	_ModeButton_GetPress
 245                     	xref	_ModeButton_Update
 246                     	xref	_ModeButton_Init
 247                     	xref	_Button_Update
 248                     	xref	_Button_Init
 267                     	end
