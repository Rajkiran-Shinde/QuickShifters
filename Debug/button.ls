   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  45                     ; 44 void Button_Init(void)
  45                     ; 45 {
  47                     	switch	.text
  48  0000               _Button_Init:
  52                     ; 46     GPIO_Input_PU(BUTTON_PORT, BUTTON_PIN);
  54  0000 ae0003        	ldw	x,#3
  55  0003 cd0000        	call	_GPIO_Input_PU
  57                     ; 48     currentState = BUTTON_STATE_RELEASED;
  59  0006 3f15          	clr	L3_currentState
  60                     ; 50     pressEvent = FALSE;
  62  0008 3f0b          	clr	L7_pressEvent
  63                     ; 51 }
  66  000a 81            	ret
  95                     ; 59 void Button_Update(void)
  95                     ; 60 {
  96                     	switch	.text
  97  000b               _Button_Update:
 101                     ; 61     switch(currentState)
 103  000b b615          	ld	a,L3_currentState
 105                     ; 136             break;
 106  000d 4d            	tnz	a
 107  000e 270d          	jreq	L72
 108  0010 4a            	dec	a
 109  0011 2729          	jreq	L13
 110  0013 4a            	dec	a
 111  0014 2746          	jreq	L33
 112  0016 4a            	dec	a
 113  0017 2763          	jreq	L53
 114  0019               L73:
 115                     ; 131         default:
 115                     ; 132 
 115                     ; 133             currentState =
 115                     ; 134                 BUTTON_STATE_RELEASED;
 117  0019 3f15          	clr	L3_currentState
 118                     ; 136             break;
 120  001b 207a          	jra	L35
 121  001d               L72:
 122                     ; 63         case BUTTON_STATE_RELEASED:
 122                     ; 64 
 122                     ; 65             if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
 124  001d ae0003        	ldw	x,#3
 125  0020 cd0000        	call	_GPIO_Read
 127  0023 4d            	tnz	a
 128  0024 2671          	jrne	L35
 129                     ; 67                 SoftwareTimer_Start(&debounceTimer,
 129                     ; 68                                     BUTTON_DEBOUNCE_TIME);
 131  0026 ae0014        	ldw	x,#20
 132  0029 89            	pushw	x
 133  002a ae0000        	ldw	x,#0
 134  002d 89            	pushw	x
 135  002e ae000c        	ldw	x,#L5_debounceTimer
 136  0031 cd0000        	call	_SoftwareTimer_Start
 138  0034 5b04          	addw	sp,#4
 139                     ; 70                 currentState =
 139                     ; 71                     BUTTON_STATE_DEBOUNCE_PRESS;
 141  0036 35010015      	mov	L3_currentState,#1
 142  003a 205b          	jra	L35
 143  003c               L13:
 144                     ; 77         case BUTTON_STATE_DEBOUNCE_PRESS:
 144                     ; 78 
 144                     ; 79             if(SoftwareTimer_Expired(&debounceTimer))
 146  003c ae000c        	ldw	x,#L5_debounceTimer
 147  003f cd0000        	call	_SoftwareTimer_Expired
 149  0042 4d            	tnz	a
 150  0043 2752          	jreq	L35
 151                     ; 81                 if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
 153  0045 ae0003        	ldw	x,#3
 154  0048 cd0000        	call	_GPIO_Read
 156  004b 4d            	tnz	a
 157  004c 260a          	jrne	L16
 158                     ; 83                     pressEvent = TRUE;
 160  004e 3501000b      	mov	L7_pressEvent,#1
 161                     ; 85                     currentState =
 161                     ; 86                         BUTTON_STATE_PRESSED;
 163  0052 35020015      	mov	L3_currentState,#2
 165  0056 203f          	jra	L35
 166  0058               L16:
 167                     ; 90                     currentState =
 167                     ; 91                         BUTTON_STATE_RELEASED;
 169  0058 3f15          	clr	L3_currentState
 170  005a 203b          	jra	L35
 171  005c               L33:
 172                     ; 98         case BUTTON_STATE_PRESSED:
 172                     ; 99 
 172                     ; 100             if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
 174  005c ae0003        	ldw	x,#3
 175  005f cd0000        	call	_GPIO_Read
 177  0062 a101          	cp	a,#1
 178  0064 2631          	jrne	L35
 179                     ; 102                 SoftwareTimer_Start(&debounceTimer,
 179                     ; 103                                     BUTTON_DEBOUNCE_TIME);
 181  0066 ae0014        	ldw	x,#20
 182  0069 89            	pushw	x
 183  006a ae0000        	ldw	x,#0
 184  006d 89            	pushw	x
 185  006e ae000c        	ldw	x,#L5_debounceTimer
 186  0071 cd0000        	call	_SoftwareTimer_Start
 188  0074 5b04          	addw	sp,#4
 189                     ; 105                 currentState =
 189                     ; 106                     BUTTON_STATE_DEBOUNCE_RELEASE;
 191  0076 35030015      	mov	L3_currentState,#3
 192  007a 201b          	jra	L35
 193  007c               L53:
 194                     ; 112         case BUTTON_STATE_DEBOUNCE_RELEASE:
 194                     ; 113 
 194                     ; 114             if(SoftwareTimer_Expired(&debounceTimer))
 196  007c ae000c        	ldw	x,#L5_debounceTimer
 197  007f cd0000        	call	_SoftwareTimer_Expired
 199  0082 4d            	tnz	a
 200  0083 2712          	jreq	L35
 201                     ; 116                 if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
 203  0085 ae0003        	ldw	x,#3
 204  0088 cd0000        	call	_GPIO_Read
 206  008b a101          	cp	a,#1
 207  008d 2604          	jrne	L17
 208                     ; 118                     currentState =
 208                     ; 119                         BUTTON_STATE_RELEASED;
 210  008f 3f15          	clr	L3_currentState
 212  0091 2004          	jra	L35
 213  0093               L17:
 214                     ; 123                     currentState =
 214                     ; 124                         BUTTON_STATE_PRESSED;
 216  0093 35020015      	mov	L3_currentState,#2
 217  0097               L35:
 218                     ; 138 }
 221  0097 81            	ret
 245                     ; 146 uint8_t Button_GetPress(void)
 245                     ; 147 {
 246                     	switch	.text
 247  0098               _Button_GetPress:
 251                     ; 148     if(pressEvent == TRUE)
 253  0098 b60b          	ld	a,L7_pressEvent
 254  009a a101          	cp	a,#1
 255  009c 2605          	jrne	L501
 256                     ; 150         pressEvent = FALSE;
 258  009e 3f0b          	clr	L7_pressEvent
 259                     ; 152         return TRUE;
 261  00a0 a601          	ld	a,#1
 264  00a2 81            	ret
 265  00a3               L501:
 266                     ; 155     return FALSE;
 268  00a3 4f            	clr	a
 271  00a4 81            	ret
 295                     ; 158 uint8_t Button_IsPressed(void)
 295                     ; 159 {
 296                     	switch	.text
 297  00a5               _Button_IsPressed:
 301                     ; 160     if(currentState == BUTTON_STATE_PRESSED)
 303  00a5 b615          	ld	a,L3_currentState
 304  00a7 a102          	cp	a,#2
 305  00a9 2603          	jrne	L711
 306                     ; 162         return TRUE;
 308  00ab a601          	ld	a,#1
 311  00ad 81            	ret
 312  00ae               L711:
 313                     ; 165     return FALSE;
 315  00ae 4f            	clr	a
 318  00af 81            	ret
 344                     ; 197 void ModeButton_Init(void)
 344                     ; 198 {
 345                     	switch	.text
 346  00b0               _ModeButton_Init:
 350                     ; 199     GPIO_Input_PU(MODE_BUTTON_PORT,
 350                     ; 200                   MODE_BUTTON_PIN);
 352  00b0 ae0004        	ldw	x,#4
 353  00b3 cd0000        	call	_GPIO_Input_PU
 355                     ; 202     modeButtonState =
 355                     ; 203         MODE_BUTTON_STATE_RELEASED;
 357  00b6 3f0a          	clr	L121_modeButtonState
 358                     ; 205     modeButtonPressEvent = FALSE;
 360  00b8 3f00          	clr	L521_modeButtonPressEvent
 361                     ; 206 }
 364  00ba 81            	ret
 393                     ; 214 void ModeButton_Update(void)
 393                     ; 215 {
 394                     	switch	.text
 395  00bb               _ModeButton_Update:
 399                     ; 216     switch(modeButtonState)
 401  00bb b60a          	ld	a,L121_modeButtonState
 403                     ; 299             break;
 404  00bd 4d            	tnz	a
 405  00be 270d          	jreq	L731
 406  00c0 4a            	dec	a
 407  00c1 2729          	jreq	L141
 408  00c3 4a            	dec	a
 409  00c4 2746          	jreq	L341
 410  00c6 4a            	dec	a
 411  00c7 2763          	jreq	L541
 412  00c9               L741:
 413                     ; 294         default:
 413                     ; 295 
 413                     ; 296             modeButtonState =
 413                     ; 297                 MODE_BUTTON_STATE_RELEASED;
 415  00c9 3f0a          	clr	L121_modeButtonState
 416                     ; 299             break;
 418  00cb 207a          	jra	L361
 419  00cd               L731:
 420                     ; 218         case MODE_BUTTON_STATE_RELEASED:
 420                     ; 219 
 420                     ; 220             if(GPIO_Read(MODE_BUTTON_PORT,
 420                     ; 221                          MODE_BUTTON_PIN) == FALSE)
 422  00cd ae0004        	ldw	x,#4
 423  00d0 cd0000        	call	_GPIO_Read
 425  00d3 4d            	tnz	a
 426  00d4 2671          	jrne	L361
 427                     ; 223                 SoftwareTimer_Start(
 427                     ; 224                     &modeButtonDebounceTimer,
 427                     ; 225                     BUTTON_DEBOUNCE_TIME);
 429  00d6 ae0014        	ldw	x,#20
 430  00d9 89            	pushw	x
 431  00da ae0000        	ldw	x,#0
 432  00dd 89            	pushw	x
 433  00de ae0001        	ldw	x,#L321_modeButtonDebounceTimer
 434  00e1 cd0000        	call	_SoftwareTimer_Start
 436  00e4 5b04          	addw	sp,#4
 437                     ; 227                 modeButtonState =
 437                     ; 228                     MODE_BUTTON_STATE_DEBOUNCE_PRESS;
 439  00e6 3501000a      	mov	L121_modeButtonState,#1
 440  00ea 205b          	jra	L361
 441  00ec               L141:
 442                     ; 234         case MODE_BUTTON_STATE_DEBOUNCE_PRESS:
 442                     ; 235 
 442                     ; 236             if(SoftwareTimer_Expired(
 442                     ; 237                     &modeButtonDebounceTimer))
 444  00ec ae0001        	ldw	x,#L321_modeButtonDebounceTimer
 445  00ef cd0000        	call	_SoftwareTimer_Expired
 447  00f2 4d            	tnz	a
 448  00f3 2752          	jreq	L361
 449                     ; 239                 if(GPIO_Read(MODE_BUTTON_PORT,
 449                     ; 240                              MODE_BUTTON_PIN) == FALSE)
 451  00f5 ae0004        	ldw	x,#4
 452  00f8 cd0000        	call	_GPIO_Read
 454  00fb 4d            	tnz	a
 455  00fc 260a          	jrne	L171
 456                     ; 242                     modeButtonPressEvent = TRUE;
 458  00fe 35010000      	mov	L521_modeButtonPressEvent,#1
 459                     ; 244                     modeButtonState =
 459                     ; 245                         MODE_BUTTON_STATE_PRESSED;
 461  0102 3502000a      	mov	L121_modeButtonState,#2
 463  0106 203f          	jra	L361
 464  0108               L171:
 465                     ; 249                     modeButtonState =
 465                     ; 250                         MODE_BUTTON_STATE_RELEASED;
 467  0108 3f0a          	clr	L121_modeButtonState
 468  010a 203b          	jra	L361
 469  010c               L341:
 470                     ; 257         case MODE_BUTTON_STATE_PRESSED:
 470                     ; 258 
 470                     ; 259             if(GPIO_Read(MODE_BUTTON_PORT,
 470                     ; 260                          MODE_BUTTON_PIN) == TRUE)
 472  010c ae0004        	ldw	x,#4
 473  010f cd0000        	call	_GPIO_Read
 475  0112 a101          	cp	a,#1
 476  0114 2631          	jrne	L361
 477                     ; 262                 SoftwareTimer_Start(
 477                     ; 263                     &modeButtonDebounceTimer,
 477                     ; 264                     BUTTON_DEBOUNCE_TIME);
 479  0116 ae0014        	ldw	x,#20
 480  0119 89            	pushw	x
 481  011a ae0000        	ldw	x,#0
 482  011d 89            	pushw	x
 483  011e ae0001        	ldw	x,#L321_modeButtonDebounceTimer
 484  0121 cd0000        	call	_SoftwareTimer_Start
 486  0124 5b04          	addw	sp,#4
 487                     ; 266                 modeButtonState =
 487                     ; 267                     MODE_BUTTON_STATE_DEBOUNCE_RELEASE;
 489  0126 3503000a      	mov	L121_modeButtonState,#3
 490  012a 201b          	jra	L361
 491  012c               L541:
 492                     ; 273         case MODE_BUTTON_STATE_DEBOUNCE_RELEASE:
 492                     ; 274 
 492                     ; 275             if(SoftwareTimer_Expired(
 492                     ; 276                     &modeButtonDebounceTimer))
 494  012c ae0001        	ldw	x,#L321_modeButtonDebounceTimer
 495  012f cd0000        	call	_SoftwareTimer_Expired
 497  0132 4d            	tnz	a
 498  0133 2712          	jreq	L361
 499                     ; 278                 if(GPIO_Read(MODE_BUTTON_PORT,
 499                     ; 279                              MODE_BUTTON_PIN) == TRUE)
 501  0135 ae0004        	ldw	x,#4
 502  0138 cd0000        	call	_GPIO_Read
 504  013b a101          	cp	a,#1
 505  013d 2604          	jrne	L102
 506                     ; 281                     modeButtonState =
 506                     ; 282                         MODE_BUTTON_STATE_RELEASED;
 508  013f 3f0a          	clr	L121_modeButtonState
 510  0141 2004          	jra	L361
 511  0143               L102:
 512                     ; 286                     modeButtonState =
 512                     ; 287                         MODE_BUTTON_STATE_PRESSED;
 514  0143 3502000a      	mov	L121_modeButtonState,#2
 515  0147               L361:
 516                     ; 301 }
 519  0147 81            	ret
 544                     ; 309 uint8_t ModeButton_GetPress(void)
 544                     ; 310 {
 545                     	switch	.text
 546  0148               _ModeButton_GetPress:
 550                     ; 311     if(modeButtonPressEvent == TRUE)
 552  0148 b600          	ld	a,L521_modeButtonPressEvent
 553  014a a101          	cp	a,#1
 554  014c 2605          	jrne	L512
 555                     ; 313         modeButtonPressEvent = FALSE;
 557  014e 3f00          	clr	L521_modeButtonPressEvent
 558                     ; 315         return TRUE;
 560  0150 a601          	ld	a,#1
 563  0152 81            	ret
 564  0153               L512:
 565                     ; 318     return FALSE;
 567  0153 4f            	clr	a
 570  0154 81            	ret
 749                     	switch	.ubsct
 750  0000               L521_modeButtonPressEvent:
 751  0000 00            	ds.b	1
 752  0001               L321_modeButtonDebounceTimer:
 753  0001 000000000000  	ds.b	9
 754  000a               L121_modeButtonState:
 755  000a 00            	ds.b	1
 756  000b               L7_pressEvent:
 757  000b 00            	ds.b	1
 758  000c               L5_debounceTimer:
 759  000c 000000000000  	ds.b	9
 760  0015               L3_currentState:
 761  0015 00            	ds.b	1
 762                     	xref	_SoftwareTimer_Expired
 763                     	xref	_SoftwareTimer_Start
 764                     	xref	_GPIO_Read
 765                     	xref	_GPIO_Input_PU
 766                     	xdef	_ModeButton_GetPress
 767                     	xdef	_ModeButton_Update
 768                     	xdef	_ModeButton_Init
 769                     	xdef	_Button_IsPressed
 770                     	xdef	_Button_GetPress
 771                     	xdef	_Button_Update
 772                     	xdef	_Button_Init
 792                     	end
