   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  45                     ; 23 void Relay_Init(void)
  45                     ; 24 {
  47                     	switch	.text
  48  0000               _Relay_Init:
  52                     ; 28     GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
  54  0000 ae0302        	ldw	x,#770
  55  0003 cd0000        	call	_GPIO_Output_PP
  57                     ; 35     GPIO_Clear(RELAY_PORT, RELAY_PIN);
  59  0006 ae0302        	ldw	x,#770
  60  0009 cd0000        	call	_GPIO_Clear
  62                     ; 37     relayState = FALSE;
  64  000c 3f00          	clr	L3_relayState
  65                     ; 38 }
  68  000e 81            	ret
  94                     ; 45 void Relay_On(void)
  94                     ; 46 {
  95                     	switch	.text
  96  000f               _Relay_On:
 100                     ; 47     GPIO_Set(RELAY_PORT, RELAY_PIN);
 102  000f ae0302        	ldw	x,#770
 103  0012 cd0000        	call	_GPIO_Set
 105                     ; 49     relayState = TRUE;
 107  0015 35010000      	mov	L3_relayState,#1
 108                     ; 51 		Debug_Log("[RELAY] ON\r\n");
 110  0019 ae000e        	ldw	x,#L33
 111  001c cd0000        	call	_Debug_Log
 113                     ; 52 }
 116  001f 81            	ret
 142                     ; 55 void Relay_Off(void)
 142                     ; 56 {
 143                     	switch	.text
 144  0020               _Relay_Off:
 148                     ; 57     GPIO_Clear(RELAY_PORT, RELAY_PIN);
 150  0020 ae0302        	ldw	x,#770
 151  0023 cd0000        	call	_GPIO_Clear
 153                     ; 59     relayState = FALSE;
 155  0026 3f00          	clr	L3_relayState
 156                     ; 61 		Debug_Log("[RELAY] OFF\r\n");
 158  0028 ae0000        	ldw	x,#L54
 159  002b cd0000        	call	_Debug_Log
 161                     ; 62 }
 164  002e 81            	ret
 188                     ; 69 uint8_t Relay_IsOn(void)
 188                     ; 70 {
 189                     	switch	.text
 190  002f               _Relay_IsOn:
 194                     ; 71     return relayState;
 196  002f b600          	ld	a,L3_relayState
 199  0031 81            	ret
 223                     	switch	.ubsct
 224  0000               L3_relayState:
 225  0000 00            	ds.b	1
 226                     	xref	_Debug_Log
 227                     	xref	_GPIO_Clear
 228                     	xref	_GPIO_Set
 229                     	xref	_GPIO_Output_PP
 230                     	xdef	_Relay_IsOn
 231                     	xdef	_Relay_Off
 232                     	xdef	_Relay_On
 233                     	xdef	_Relay_Init
 234                     .const:	section	.text
 235  0000               L54:
 236  0000 5b52454c4159  	dc.b	"[RELAY] OFF",13
 237  000c 0a00          	dc.b	10,0
 238  000e               L33:
 239  000e 5b52454c4159  	dc.b	"[RELAY] ON",13
 240  0019 0a00          	dc.b	10,0
 260                     	end
