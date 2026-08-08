   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  60                     ; 14 int main(void)
  60                     ; 15 {
  62                     	switch	.text
  63  0000               _main:
  67                     ; 16     CLK_Init();
  69  0000 cd0000        	call	_CLK_Init
  71                     ; 18     Timer_Init();
  73  0003 cd0000        	call	_Timer_Init
  75                     ; 20     Button_Init();
  77  0006 cd0000        	call	_Button_Init
  79                     ; 22     ModeButton_Init();
  81  0009 cd0000        	call	_ModeButton_Init
  83                     ; 24     Debug_Init();
  85  000c cd0000        	call	_Debug_Init
  87                     ; 26     EEPROM_Init();
  89  000f cd0000        	call	_EEPROM_Init
  91                     ; 28     Mode_Init();
  93  0012 cd0000        	call	_Mode_Init
  95                     ; 30     QuickShifter_Init();
  97  0015 cd0000        	call	_QuickShifter_Init
  99                     ; 32     __asm ("rim\n");
 102  0018 9a            rim
 104  0019               L12:
 105                     ; 36         Button_Update();
 107  0019 cd0000        	call	_Button_Update
 109                     ; 38         ModeButton_Update();
 111  001c cd0000        	call	_ModeButton_Update
 113                     ; 40         QuickShifter_Task();
 115  001f cd0000        	call	_QuickShifter_Task
 117                     ; 42         if(ModeButton_GetPress())
 119  0022 cd0000        	call	_ModeButton_GetPress
 121  0025 4d            	tnz	a
 122  0026 27f1          	jreq	L12
 123                     ; 44             Mode_Next();
 125  0028 cd0000        	call	_Mode_Next
 127                     ; 46             Debug_LogMode(
 127                     ; 47                 Mode_Get(),
 127                     ; 48                 Mode_GetCutTime()
 127                     ; 49             );
 129  002b cd0000        	call	_Mode_GetCutTime
 131  002e 89            	pushw	x
 132  002f cd0000        	call	_Mode_Get
 134  0032 cd0000        	call	_Debug_LogMode
 136  0035 85            	popw	x
 137  0036 20e1          	jra	L12
 150                     	xdef	_main
 151                     	xref	_Debug_LogMode
 152                     	xref	_Debug_Init
 153                     	xref	_EEPROM_Init
 154                     	xref	_Mode_GetCutTime
 155                     	xref	_Mode_Get
 156                     	xref	_Mode_Next
 157                     	xref	_Mode_Init
 158                     	xref	_QuickShifter_Task
 159                     	xref	_QuickShifter_Init
 160                     	xref	_CLK_Init
 161                     	xref	_Timer_Init
 162                     	xref	_ModeButton_GetPress
 163                     	xref	_ModeButton_Update
 164                     	xref	_ModeButton_Init
 165                     	xref	_Button_Update
 166                     	xref	_Button_Init
 185                     	end
