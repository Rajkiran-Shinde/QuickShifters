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
 297                     ; 188 void ModeButton_Init(void)
 297                     ; 189 {
 298                     	switch	.text
 299  00a5               _ModeButton_Init:
 303                     ; 190     GPIO_Input_PU(MODE_BUTTON_PORT,
 303                     ; 191                   MODE_BUTTON_PIN);
 305  00a5 ae0004        	ldw	x,#4
 306  00a8 cd0000        	call	_GPIO_Input_PU
 308                     ; 193     modeButtonState =
 308                     ; 194         MODE_BUTTON_STATE_RELEASED;
 310  00ab 3f0a          	clr	L701_modeButtonState
 311                     ; 196     modeButtonPressEvent = FALSE;
 313  00ad 3f00          	clr	L311_modeButtonPressEvent
 314                     ; 197 }
 317  00af 81            	ret
 346                     ; 205 void ModeButton_Update(void)
 346                     ; 206 {
 347                     	switch	.text
 348  00b0               _ModeButton_Update:
 352                     ; 207     switch(modeButtonState)
 354  00b0 b60a          	ld	a,L701_modeButtonState
 356                     ; 290             break;
 357  00b2 4d            	tnz	a
 358  00b3 270d          	jreq	L521
 359  00b5 4a            	dec	a
 360  00b6 2729          	jreq	L721
 361  00b8 4a            	dec	a
 362  00b9 2746          	jreq	L131
 363  00bb 4a            	dec	a
 364  00bc 2763          	jreq	L331
 365  00be               L531:
 366                     ; 285         default:
 366                     ; 286 
 366                     ; 287             modeButtonState =
 366                     ; 288                 MODE_BUTTON_STATE_RELEASED;
 368  00be 3f0a          	clr	L701_modeButtonState
 369                     ; 290             break;
 371  00c0 207a          	jra	L151
 372  00c2               L521:
 373                     ; 209         case MODE_BUTTON_STATE_RELEASED:
 373                     ; 210 
 373                     ; 211             if(GPIO_Read(MODE_BUTTON_PORT,
 373                     ; 212                          MODE_BUTTON_PIN) == FALSE)
 375  00c2 ae0004        	ldw	x,#4
 376  00c5 cd0000        	call	_GPIO_Read
 378  00c8 4d            	tnz	a
 379  00c9 2671          	jrne	L151
 380                     ; 214                 SoftwareTimer_Start(
 380                     ; 215                     &modeButtonDebounceTimer,
 380                     ; 216                     BUTTON_DEBOUNCE_TIME);
 382  00cb ae0014        	ldw	x,#20
 383  00ce 89            	pushw	x
 384  00cf ae0000        	ldw	x,#0
 385  00d2 89            	pushw	x
 386  00d3 ae0001        	ldw	x,#L111_modeButtonDebounceTimer
 387  00d6 cd0000        	call	_SoftwareTimer_Start
 389  00d9 5b04          	addw	sp,#4
 390                     ; 218                 modeButtonState =
 390                     ; 219                     MODE_BUTTON_STATE_DEBOUNCE_PRESS;
 392  00db 3501000a      	mov	L701_modeButtonState,#1
 393  00df 205b          	jra	L151
 394  00e1               L721:
 395                     ; 225         case MODE_BUTTON_STATE_DEBOUNCE_PRESS:
 395                     ; 226 
 395                     ; 227             if(SoftwareTimer_Expired(
 395                     ; 228                     &modeButtonDebounceTimer))
 397  00e1 ae0001        	ldw	x,#L111_modeButtonDebounceTimer
 398  00e4 cd0000        	call	_SoftwareTimer_Expired
 400  00e7 4d            	tnz	a
 401  00e8 2752          	jreq	L151
 402                     ; 230                 if(GPIO_Read(MODE_BUTTON_PORT,
 402                     ; 231                              MODE_BUTTON_PIN) == FALSE)
 404  00ea ae0004        	ldw	x,#4
 405  00ed cd0000        	call	_GPIO_Read
 407  00f0 4d            	tnz	a
 408  00f1 260a          	jrne	L751
 409                     ; 233                     modeButtonPressEvent = TRUE;
 411  00f3 35010000      	mov	L311_modeButtonPressEvent,#1
 412                     ; 235                     modeButtonState =
 412                     ; 236                         MODE_BUTTON_STATE_PRESSED;
 414  00f7 3502000a      	mov	L701_modeButtonState,#2
 416  00fb 203f          	jra	L151
 417  00fd               L751:
 418                     ; 240                     modeButtonState =
 418                     ; 241                         MODE_BUTTON_STATE_RELEASED;
 420  00fd 3f0a          	clr	L701_modeButtonState
 421  00ff 203b          	jra	L151
 422  0101               L131:
 423                     ; 248         case MODE_BUTTON_STATE_PRESSED:
 423                     ; 249 
 423                     ; 250             if(GPIO_Read(MODE_BUTTON_PORT,
 423                     ; 251                          MODE_BUTTON_PIN) == TRUE)
 425  0101 ae0004        	ldw	x,#4
 426  0104 cd0000        	call	_GPIO_Read
 428  0107 a101          	cp	a,#1
 429  0109 2631          	jrne	L151
 430                     ; 253                 SoftwareTimer_Start(
 430                     ; 254                     &modeButtonDebounceTimer,
 430                     ; 255                     BUTTON_DEBOUNCE_TIME);
 432  010b ae0014        	ldw	x,#20
 433  010e 89            	pushw	x
 434  010f ae0000        	ldw	x,#0
 435  0112 89            	pushw	x
 436  0113 ae0001        	ldw	x,#L111_modeButtonDebounceTimer
 437  0116 cd0000        	call	_SoftwareTimer_Start
 439  0119 5b04          	addw	sp,#4
 440                     ; 257                 modeButtonState =
 440                     ; 258                     MODE_BUTTON_STATE_DEBOUNCE_RELEASE;
 442  011b 3503000a      	mov	L701_modeButtonState,#3
 443  011f 201b          	jra	L151
 444  0121               L331:
 445                     ; 264         case MODE_BUTTON_STATE_DEBOUNCE_RELEASE:
 445                     ; 265 
 445                     ; 266             if(SoftwareTimer_Expired(
 445                     ; 267                     &modeButtonDebounceTimer))
 447  0121 ae0001        	ldw	x,#L111_modeButtonDebounceTimer
 448  0124 cd0000        	call	_SoftwareTimer_Expired
 450  0127 4d            	tnz	a
 451  0128 2712          	jreq	L151
 452                     ; 269                 if(GPIO_Read(MODE_BUTTON_PORT,
 452                     ; 270                              MODE_BUTTON_PIN) == TRUE)
 454  012a ae0004        	ldw	x,#4
 455  012d cd0000        	call	_GPIO_Read
 457  0130 a101          	cp	a,#1
 458  0132 2604          	jrne	L761
 459                     ; 272                     modeButtonState =
 459                     ; 273                         MODE_BUTTON_STATE_RELEASED;
 461  0134 3f0a          	clr	L701_modeButtonState
 463  0136 2004          	jra	L151
 464  0138               L761:
 465                     ; 277                     modeButtonState =
 465                     ; 278                         MODE_BUTTON_STATE_PRESSED;
 467  0138 3502000a      	mov	L701_modeButtonState,#2
 468  013c               L151:
 469                     ; 292 }
 472  013c 81            	ret
 497                     ; 300 uint8_t ModeButton_GetPress(void)
 497                     ; 301 {
 498                     	switch	.text
 499  013d               _ModeButton_GetPress:
 503                     ; 302     if(modeButtonPressEvent == TRUE)
 505  013d b600          	ld	a,L311_modeButtonPressEvent
 506  013f a101          	cp	a,#1
 507  0141 2605          	jrne	L302
 508                     ; 304         modeButtonPressEvent = FALSE;
 510  0143 3f00          	clr	L311_modeButtonPressEvent
 511                     ; 306         return TRUE;
 513  0145 a601          	ld	a,#1
 516  0147 81            	ret
 517  0148               L302:
 518                     ; 309     return FALSE;
 520  0148 4f            	clr	a
 523  0149 81            	ret
 702                     	switch	.ubsct
 703  0000               L311_modeButtonPressEvent:
 704  0000 00            	ds.b	1
 705  0001               L111_modeButtonDebounceTimer:
 706  0001 000000000000  	ds.b	9
 707  000a               L701_modeButtonState:
 708  000a 00            	ds.b	1
 709  000b               L7_pressEvent:
 710  000b 00            	ds.b	1
 711  000c               L5_debounceTimer:
 712  000c 000000000000  	ds.b	9
 713  0015               L3_currentState:
 714  0015 00            	ds.b	1
 715                     	xref	_SoftwareTimer_Expired
 716                     	xref	_SoftwareTimer_Start
 717                     	xref	_GPIO_Read
 718                     	xref	_GPIO_Input_PU
 719                     	xdef	_ModeButton_GetPress
 720                     	xdef	_ModeButton_Update
 721                     	xdef	_ModeButton_Init
 722                     	xdef	_Button_GetPress
 723                     	xdef	_Button_Update
 724                     	xdef	_Button_Init
 744                     	end
