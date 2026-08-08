   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  60                     ; 13 int main(void)
  60                     ; 14 {
  62                     	switch	.text
  63  0000               _main:
  67                     ; 16     CLK_Init();
  69  0000 cd0000        	call	_CLK_Init
  71                     ; 18     Timer_Init();
  73  0003 cd0000        	call	_Timer_Init
  75                     ; 20     Button_Init();
  77  0006 cd0000        	call	_Button_Init
  79                     ; 22 		ModeButton_Init();
  81  0009 cd0000        	call	_ModeButton_Init
  83                     ; 24 		Mode_Init(); //Mode Initilize 
  85  000c cd0000        	call	_Mode_Init
  87                     ; 26     QuickShifter_Init();
  89  000f cd0000        	call	_QuickShifter_Init
  91                     ; 30 		Debug_Init();// Remove In final Deployment 
  93  0012 cd0000        	call	_Debug_Init
  95                     ; 31 		Debug_Log("STM8 UART TEST\r\n");
  97  0015 ae001d        	ldw	x,#L12
  98  0018 cd0000        	call	_Debug_Log
 100                     ; 32 		Debug_Log("QuickShifter Debug Started\r\n");
 102  001b ae0000        	ldw	x,#L32
 103  001e cd0000        	call	_Debug_Log
 105                     ; 34 		__asm ("rim\n");
 108  0021 9a            rim
 110  0022               L52:
 111                     ; 38     Button_Update();
 113  0022 cd0000        	call	_Button_Update
 115                     ; 40     ModeButton_Update();
 117  0025 cd0000        	call	_ModeButton_Update
 119                     ; 42     QuickShifter_Task();
 121  0028 cd0000        	call	_QuickShifter_Task
 123                     ; 44     if(ModeButton_GetPress())
 125  002b cd0000        	call	_ModeButton_GetPress
 127  002e 4d            	tnz	a
 128  002f 27f1          	jreq	L52
 129                     ; 46         Mode_Next();
 131  0031 cd0000        	call	_Mode_Next
 133                     ; 48         Debug_LogMode(
 133                     ; 49             Mode_Get(),
 133                     ; 50             Mode_GetCutTime()
 133                     ; 51         );
 135  0034 cd0000        	call	_Mode_GetCutTime
 137  0037 89            	pushw	x
 138  0038 cd0000        	call	_Mode_Get
 140  003b cd0000        	call	_Debug_LogMode
 142  003e 85            	popw	x
 143  003f 20e1          	jra	L52
 156                     	xdef	_main
 157                     	xref	_Debug_LogMode
 158                     	xref	_Debug_Log
 159                     	xref	_Debug_Init
 160                     	xref	_Mode_GetCutTime
 161                     	xref	_Mode_Get
 162                     	xref	_Mode_Next
 163                     	xref	_Mode_Init
 164                     	xref	_QuickShifter_Task
 165                     	xref	_QuickShifter_Init
 166                     	xref	_CLK_Init
 167                     	xref	_Timer_Init
 168                     	xref	_ModeButton_GetPress
 169                     	xref	_ModeButton_Update
 170                     	xref	_ModeButton_Init
 171                     	xref	_Button_Update
 172                     	xref	_Button_Init
 173                     .const:	section	.text
 174  0000               L32:
 175  0000 517569636b53  	dc.b	"QuickShifter Debug"
 176  0012 205374617274  	dc.b	" Started",13
 177  001b 0a00          	dc.b	10,0
 178  001d               L12:
 179  001d 53544d382055  	dc.b	"STM8 UART TEST",13
 180  002c 0a00          	dc.b	10,0
 200                     	end
