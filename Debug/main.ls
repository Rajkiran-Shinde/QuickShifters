   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  67                     ; 15 int main(void)
  67                     ; 16 {
  69                     	switch	.text
  70  0000               _main:
  74                     ; 17     CLK_Init();
  76  0000 cd0000        	call	_CLK_Init
  78                     ; 18     Timer_Init();
  80  0003 cd0000        	call	_Timer_Init
  82                     ; 20     Button_Init();
  84  0006 cd0000        	call	_Button_Init
  86                     ; 21     ModeButton_Init();
  88  0009 cd0000        	call	_ModeButton_Init
  90                     ; 23     Debug_Init();
  92  000c cd0000        	call	_Debug_Init
  94                     ; 26     LED_Init();
  96  000f cd0000        	call	_LED_Init
  98                     ; 28     Buzzer_Init();
 100  0012 cd0000        	call	_Buzzer_Init
 102                     ; 29     EEPROM_Init();
 104  0015 cd0000        	call	_EEPROM_Init
 106                     ; 31     Mode_Init();
 108  0018 cd0000        	call	_Mode_Init
 110                     ; 33     LED_Mode_Display(Mode_Get() + 1);
 112  001b cd0000        	call	_Mode_Get
 114  001e 4c            	inc	a
 115  001f cd0000        	call	_LED_Mode_Display
 117                     ; 35     Debug_LogMode(
 117                     ; 36         Mode_Get(),
 117                     ; 37         Mode_GetCutTime()
 117                     ; 38     );
 119  0022 cd0000        	call	_Mode_GetCutTime
 121  0025 89            	pushw	x
 122  0026 cd0000        	call	_Mode_Get
 124  0029 cd0000        	call	_Debug_LogMode
 126  002c 85            	popw	x
 127                     ; 40     QuickShifter_Init();
 129  002d cd0000        	call	_QuickShifter_Init
 131                     ; 42     Buzzer_Play(BUZZER_EVENT_BOOT);
 133  0030 4f            	clr	a
 134  0031 cd0000        	call	_Buzzer_Play
 136                     ; 44     Watchdog_Init();
 138  0034 cd0000        	call	_Watchdog_Init
 140                     ; 46     __asm ("rim\n");
 143  0037 9a            rim
 145  0038               L12:
 146                     ; 50         Button_Update();
 148  0038 cd0000        	call	_Button_Update
 150                     ; 51         ModeButton_Update();
 152  003b cd0000        	call	_ModeButton_Update
 154                     ; 53         if(ModeButton_GetPress())
 156  003e cd0000        	call	_ModeButton_GetPress
 158  0041 4d            	tnz	a
 159  0042 271a          	jreq	L52
 160                     ; 55             Mode_Next();
 162  0044 cd0000        	call	_Mode_Next
 164                     ; 57             LED_Mode_Display(
 164                     ; 58                 Mode_Get() + 1
 164                     ; 59             );
 166  0047 cd0000        	call	_Mode_Get
 168  004a 4c            	inc	a
 169  004b cd0000        	call	_LED_Mode_Display
 171                     ; 61             Buzzer_Play(
 171                     ; 62                 BUZZER_EVENT_MODE_CHANGE
 171                     ; 63             );
 173  004e a601          	ld	a,#1
 174  0050 cd0000        	call	_Buzzer_Play
 176                     ; 65             Debug_LogMode(
 176                     ; 66                 Mode_Get(),
 176                     ; 67                 Mode_GetCutTime()
 176                     ; 68             );
 178  0053 cd0000        	call	_Mode_GetCutTime
 180  0056 89            	pushw	x
 181  0057 cd0000        	call	_Mode_Get
 183  005a cd0000        	call	_Debug_LogMode
 185  005d 85            	popw	x
 186  005e               L52:
 187                     ; 71         QuickShifter_Task();
 189  005e cd0000        	call	_QuickShifter_Task
 191                     ; 72         Buzzer_Task();
 193  0061 cd0000        	call	_Buzzer_Task
 195                     ; 73         Watchdog_Refresh();
 197  0064 cd0000        	call	_Watchdog_Refresh
 200  0067 20cf          	jra	L12
 213                     	xdef	_main
 214                     	xref	_Debug_LogMode
 215                     	xref	_Debug_Init
 216                     	xref	_Buzzer_Play
 217                     	xref	_Buzzer_Task
 218                     	xref	_Buzzer_Init
 219                     	xref	_LED_Mode_Display
 220                     	xref	_LED_Init
 221                     	xref	_Watchdog_Refresh
 222                     	xref	_Watchdog_Init
 223                     	xref	_EEPROM_Init
 224                     	xref	_Mode_GetCutTime
 225                     	xref	_Mode_Get
 226                     	xref	_Mode_Next
 227                     	xref	_Mode_Init
 228                     	xref	_QuickShifter_Task
 229                     	xref	_QuickShifter_Init
 230                     	xref	_CLK_Init
 231                     	xref	_Timer_Init
 232                     	xref	_ModeButton_GetPress
 233                     	xref	_ModeButton_Update
 234                     	xref	_ModeButton_Init
 235                     	xref	_Button_Update
 236                     	xref	_Button_Init
 255                     	end
