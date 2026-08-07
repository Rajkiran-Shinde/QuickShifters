   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  45                     ; 42 void Button_Init(void)
  45                     ; 43 {
  47                     	switch	.text
  48  0000               _Button_Init:
  52                     ; 44     GPIO_Input_PU(BUTTON_PORT, BUTTON_PIN);
  54  0000 ae0003        	ldw	x,#3
  55  0003 cd0000        	call	_GPIO_Input_PU
  57                     ; 46     currentState = BUTTON_STATE_RELEASED;
  59  0006 3f0a          	clr	L3_currentState
  60                     ; 48     pressEvent = FALSE;
  62  0008 3f00          	clr	L7_pressEvent
  63                     ; 49 }
  66  000a 81            	ret
  95                     ; 55 void Button_Update(void)
  95                     ; 56 {
  96                     	switch	.text
  97  000b               _Button_Update:
 101                     ; 57     switch(currentState)
 103  000b b60a          	ld	a,L3_currentState
 105                     ; 126             break;
 106  000d 4d            	tnz	a
 107  000e 270d          	jreq	L72
 108  0010 4a            	dec	a
 109  0011 2729          	jreq	L13
 110  0013 4a            	dec	a
 111  0014 2746          	jreq	L33
 112  0016 4a            	dec	a
 113  0017 2763          	jreq	L53
 114  0019               L73:
 115                     ; 122         default:
 115                     ; 123 
 115                     ; 124             currentState = BUTTON_STATE_RELEASED;
 117  0019 3f0a          	clr	L3_currentState
 118                     ; 126             break;
 120  001b 207a          	jra	L35
 121  001d               L72:
 122                     ; 60         case BUTTON_STATE_RELEASED:
 122                     ; 61 
 122                     ; 62             if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
 124  001d ae0003        	ldw	x,#3
 125  0020 cd0000        	call	_GPIO_Read
 127  0023 4d            	tnz	a
 128  0024 2671          	jrne	L35
 129                     ; 64                 SoftwareTimer_Start(&debounceTimer,
 129                     ; 65                                     BUTTON_DEBOUNCE_TIME);
 131  0026 ae0014        	ldw	x,#20
 132  0029 89            	pushw	x
 133  002a ae0000        	ldw	x,#0
 134  002d 89            	pushw	x
 135  002e ae0001        	ldw	x,#L5_debounceTimer
 136  0031 cd0000        	call	_SoftwareTimer_Start
 138  0034 5b04          	addw	sp,#4
 139                     ; 67                 currentState = BUTTON_STATE_DEBOUNCE_PRESS;
 141  0036 3501000a      	mov	L3_currentState,#1
 142  003a 205b          	jra	L35
 143  003c               L13:
 144                     ; 73         case BUTTON_STATE_DEBOUNCE_PRESS:
 144                     ; 74 
 144                     ; 75             if(SoftwareTimer_Expired(&debounceTimer))
 146  003c ae0001        	ldw	x,#L5_debounceTimer
 147  003f cd0000        	call	_SoftwareTimer_Expired
 149  0042 4d            	tnz	a
 150  0043 2752          	jreq	L35
 151                     ; 77                 if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
 153  0045 ae0003        	ldw	x,#3
 154  0048 cd0000        	call	_GPIO_Read
 156  004b 4d            	tnz	a
 157  004c 260a          	jrne	L16
 158                     ; 79                     pressEvent = TRUE;
 160  004e 35010000      	mov	L7_pressEvent,#1
 161                     ; 81                     currentState = BUTTON_STATE_PRESSED;
 163  0052 3502000a      	mov	L3_currentState,#2
 165  0056 203f          	jra	L35
 166  0058               L16:
 167                     ; 85                     currentState = BUTTON_STATE_RELEASED;
 169  0058 3f0a          	clr	L3_currentState
 170  005a 203b          	jra	L35
 171  005c               L33:
 172                     ; 92         case BUTTON_STATE_PRESSED:
 172                     ; 93 
 172                     ; 94             if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
 174  005c ae0003        	ldw	x,#3
 175  005f cd0000        	call	_GPIO_Read
 177  0062 a101          	cp	a,#1
 178  0064 2631          	jrne	L35
 179                     ; 96                 SoftwareTimer_Start(&debounceTimer,
 179                     ; 97                                     BUTTON_DEBOUNCE_TIME);
 181  0066 ae0014        	ldw	x,#20
 182  0069 89            	pushw	x
 183  006a ae0000        	ldw	x,#0
 184  006d 89            	pushw	x
 185  006e ae0001        	ldw	x,#L5_debounceTimer
 186  0071 cd0000        	call	_SoftwareTimer_Start
 188  0074 5b04          	addw	sp,#4
 189                     ; 99                 currentState = BUTTON_STATE_DEBOUNCE_RELEASE;
 191  0076 3503000a      	mov	L3_currentState,#3
 192  007a 201b          	jra	L35
 193  007c               L53:
 194                     ; 105         case BUTTON_STATE_DEBOUNCE_RELEASE:
 194                     ; 106 
 194                     ; 107             if(SoftwareTimer_Expired(&debounceTimer))
 196  007c ae0001        	ldw	x,#L5_debounceTimer
 197  007f cd0000        	call	_SoftwareTimer_Expired
 199  0082 4d            	tnz	a
 200  0083 2712          	jreq	L35
 201                     ; 109                 if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
 203  0085 ae0003        	ldw	x,#3
 204  0088 cd0000        	call	_GPIO_Read
 206  008b a101          	cp	a,#1
 207  008d 2604          	jrne	L17
 208                     ; 111                     currentState = BUTTON_STATE_RELEASED;
 210  008f 3f0a          	clr	L3_currentState
 212  0091 2004          	jra	L35
 213  0093               L17:
 214                     ; 115                     currentState = BUTTON_STATE_PRESSED;
 216  0093 3502000a      	mov	L3_currentState,#2
 217  0097               L35:
 218                     ; 128 }
 221  0097 81            	ret
 245                     ; 134 uint8_t Button_GetPress(void)
 245                     ; 135 {
 246                     	switch	.text
 247  0098               _Button_GetPress:
 251                     ; 136     if(pressEvent == TRUE)
 253  0098 b600          	ld	a,L7_pressEvent
 254  009a a101          	cp	a,#1
 255  009c 2605          	jrne	L501
 256                     ; 138         pressEvent = FALSE;
 258  009e 3f00          	clr	L7_pressEvent
 259                     ; 140         return TRUE;
 261  00a0 a601          	ld	a,#1
 264  00a2 81            	ret
 265  00a3               L501:
 266                     ; 143     return FALSE;
 268  00a3 4f            	clr	a
 271  00a4 81            	ret
 381                     	switch	.ubsct
 382  0000               L7_pressEvent:
 383  0000 00            	ds.b	1
 384  0001               L5_debounceTimer:
 385  0001 000000000000  	ds.b	9
 386  000a               L3_currentState:
 387  000a 00            	ds.b	1
 388                     	xref	_SoftwareTimer_Expired
 389                     	xref	_SoftwareTimer_Start
 390                     	xref	_GPIO_Read
 391                     	xref	_GPIO_Input_PU
 392                     	xdef	_Button_GetPress
 393                     	xdef	_Button_Update
 394                     	xdef	_Button_Init
 414                     	end
