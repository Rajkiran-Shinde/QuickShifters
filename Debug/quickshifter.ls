   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 78 void QuickShifter_Init(void)
  44                     ; 79 {
  46                     	switch	.text
  47  0000               _QuickShifter_Init:
  51                     ; 86     Relay_Init();
  53  0000 cd0000        	call	_Relay_Init
  55                     ; 92     currentState = QS_STATE_IDLE;
  57  0003 3f1b          	clr	L3_currentState
  58                     ; 93 }
  61  0005 81            	ret
  97                     ; 100 void QuickShifter_Task(void)
  97                     ; 101 {
  98                     	switch	.text
  99  0006               _QuickShifter_Task:
 103                     ; 102     switch(currentState)
 105  0006 b61b          	ld	a,L3_currentState
 107                     ; 351             break;
 108  0008 4d            	tnz	a
 109  0009 271e          	jreq	L13
 110  000b 4a            	dec	a
 111  000c 2756          	jreq	L33
 112  000e 4a            	dec	a
 113  000f 2603cc009e    	jreq	L53
 114  0014 4a            	dec	a
 115  0015 2603          	jrne	L01
 116  0017 cc00ad        	jp	L73
 117  001a               L01:
 118  001a 4a            	dec	a
 119  001b 2603          	jrne	L21
 120  001d cc00b7        	jp	L14
 121  0020               L21:
 122  0020               L34:
 123                     ; 335         default:
 123                     ; 336 
 123                     ; 337             /*
 123                     ; 338              * FAIL-SAFE BEHAVIOR
 123                     ; 339              *
 123                     ; 340              * If the state machine ever reaches
 123                     ; 341              * an invalid state:
 123                     ; 342              *
 123                     ; 343              * 1. Turn relay OFF immediately.
 123                     ; 344              * 2. Return to a known safe state.
 123                     ; 345              */
 123                     ; 346             Relay_Off();
 125  0020 cd0000        	call	_Relay_Off
 127                     ; 348             currentState =
 127                     ; 349                 QS_STATE_IDLE;
 129  0023 3f1b          	clr	L3_currentState
 130                     ; 351             break;
 132  0025 acba00ba      	jpf	L75
 133  0029               L13:
 134                     ; 109         case QS_STATE_IDLE:
 134                     ; 110 
 134                     ; 111             /*
 134                     ; 112              * Relay must be OFF while idle.
 134                     ; 113              *
 134                     ; 114              * A valid debounced button press
 134                     ; 115              * starts a new QuickShifter cut.
 134                     ; 116              */
 134                     ; 117             if(Button_GetPress())
 136  0029 cd0000        	call	_Button_GetPress
 138  002c 4d            	tnz	a
 139  002d 2603cc00ba    	jreq	L75
 140                     ; 122 								 Buzzer_Play(BUZZER_EVENT_SHIFT);
 142  0032 a602          	ld	a,#2
 143  0034 cd0000        	call	_Buzzer_Play
 145                     ; 124                 Relay_On();
 147  0037 cd0000        	call	_Relay_On
 149                     ; 136                 SoftwareTimer_Start(
 149                     ; 137                     &relayTimer,
 149                     ; 138                     Mode_GetCutTime()
 149                     ; 139                 );
 151  003a cd0000        	call	_Mode_GetCutTime
 153  003d cd0000        	call	c_uitolx
 155  0040 be02          	ldw	x,c_lreg+2
 156  0042 89            	pushw	x
 157  0043 be00          	ldw	x,c_lreg
 158  0045 89            	pushw	x
 159  0046 ae0012        	ldw	x,#L5_relayTimer
 160  0049 cd0000        	call	_SoftwareTimer_Start
 162  004c 5b04          	addw	sp,#4
 163                     ; 149                 SoftwareTimer_Start(
 163                     ; 150                     &safetyTimer,
 163                     ; 151                     QS_MAX_CUT_TIME_MS
 163                     ; 152                 );
 165  004e ae0064        	ldw	x,#100
 166  0051 89            	pushw	x
 167  0052 ae0000        	ldw	x,#0
 168  0055 89            	pushw	x
 169  0056 ae0000        	ldw	x,#L11_safetyTimer
 170  0059 cd0000        	call	_SoftwareTimer_Start
 172  005c 5b04          	addw	sp,#4
 173                     ; 158                 currentState =
 173                     ; 159                     QS_STATE_CUT_ACTIVE;
 175  005e 3501001b      	mov	L3_currentState,#1
 176  0062 2056          	jra	L75
 177  0064               L33:
 178                     ; 169         case QS_STATE_CUT_ACTIVE:
 178                     ; 170 
 178                     ; 171             /*
 178                     ; 172              * Relay is currently ON.
 178                     ; 173              *
 178                     ; 174              * Two timers are running:
 178                     ; 175              *
 178                     ; 176              * 1. relayTimer
 178                     ; 177              *    -> normal 40-80 ms cut
 178                     ; 178              *
 178                     ; 179              * 2. safetyTimer
 178                     ; 180              *    -> absolute 100 ms limit
 178                     ; 181              */
 178                     ; 182 
 178                     ; 183 
 178                     ; 184             /************************************
 178                     ; 185                     SAFETY TIMER CHECK
 178                     ; 186             ************************************/
 178                     ; 187 
 178                     ; 188             /*
 178                     ; 189              * Check the safety timer FIRST.
 178                     ; 190              *
 178                     ; 191              * If this expires, something has gone
 178                     ; 192              * wrong with the normal timing path.
 178                     ; 193              */
 178                     ; 194             if(SoftwareTimer_Expired(&safetyTimer))
 180  0064 ae0000        	ldw	x,#L11_safetyTimer
 181  0067 cd0000        	call	_SoftwareTimer_Expired
 183  006a 4d            	tnz	a
 184  006b 270f          	jreq	L36
 185                     ; 201                 Relay_Off();
 187  006d cd0000        	call	_Relay_Off
 189                     ; 207                 Debug_Log(
 189                     ; 208                     "[FAULT] Maximum cut time exceeded\r\n"
 189                     ; 209                 );
 191  0070 ae0000        	ldw	x,#L56
 192  0073 cd0000        	call	_Debug_Log
 194                     ; 215                 currentState =
 194                     ; 216                     QS_STATE_FAULT;
 196  0076 3504001b      	mov	L3_currentState,#4
 197                     ; 218                 break;
 199  007a 203e          	jra	L75
 200  007c               L36:
 201                     ; 229             if(SoftwareTimer_Expired(&relayTimer))
 203  007c ae0012        	ldw	x,#L5_relayTimer
 204  007f cd0000        	call	_SoftwareTimer_Expired
 206  0082 4d            	tnz	a
 207  0083 2735          	jreq	L75
 208                     ; 236                 Relay_Off();
 210  0085 cd0000        	call	_Relay_Off
 212                     ; 245                 SoftwareTimer_Start(
 212                     ; 246                     &cooldownTimer,
 212                     ; 247                     100
 212                     ; 248                 );
 214  0088 ae0064        	ldw	x,#100
 215  008b 89            	pushw	x
 216  008c ae0000        	ldw	x,#0
 217  008f 89            	pushw	x
 218  0090 ae0009        	ldw	x,#L7_cooldownTimer
 219  0093 cd0000        	call	_SoftwareTimer_Start
 221  0096 5b04          	addw	sp,#4
 222                     ; 254                 currentState =
 222                     ; 255                     QS_STATE_COOLDOWN;
 224  0098 3502001b      	mov	L3_currentState,#2
 225  009c 201c          	jra	L75
 226  009e               L53:
 227                     ; 265         case QS_STATE_COOLDOWN:
 227                     ; 266 
 227                     ; 267             /*
 227                     ; 268              * Relay was already turned OFF when
 227                     ; 269              * entering this state.
 227                     ; 270              *
 227                     ; 271              * Additional shift presses are ignored
 227                     ; 272              * during cooldown.
 227                     ; 273              */
 227                     ; 274 
 227                     ; 275             if(SoftwareTimer_Expired(&cooldownTimer))
 229  009e ae0009        	ldw	x,#L7_cooldownTimer
 230  00a1 cd0000        	call	_SoftwareTimer_Expired
 232  00a4 4d            	tnz	a
 233  00a5 2713          	jreq	L75
 234                     ; 283                 currentState =
 234                     ; 284                     QS_STATE_WAIT_RELEASE;
 236  00a7 3503001b      	mov	L3_currentState,#3
 237  00ab 200d          	jra	L75
 238  00ad               L73:
 239                     ; 294         case QS_STATE_WAIT_RELEASE:
 239                     ; 295 
 239                     ; 296             /*
 239                     ; 297              * Wait until the debounced shift button
 239                     ; 298              * is actually released.
 239                     ; 299              *
 239                     ; 300              * This prevents one long button press
 239                     ; 301              * from generating multiple cuts.
 239                     ; 302              */
 239                     ; 303             if(Button_IsPressed() == FALSE)
 241  00ad cd0000        	call	_Button_IsPressed
 243  00b0 4d            	tnz	a
 244  00b1 2607          	jrne	L75
 245                     ; 305                 currentState =
 245                     ; 306                     QS_STATE_IDLE;
 247  00b3 3f1b          	clr	L3_currentState
 248  00b5 2003          	jra	L75
 249  00b7               L14:
 250                     ; 316         case QS_STATE_FAULT:
 250                     ; 317 
 250                     ; 318             /*
 250                     ; 319              * FAIL-SAFE STATE
 250                     ; 320              *
 250                     ; 321              * Relay MUST remain OFF.
 250                     ; 322              *
 250                     ; 323              * No further QuickShifter cuts are
 250                     ; 324              * allowed while the system is in FAULT.
 250                     ; 325              */
 250                     ; 326             Relay_Off();
 252  00b7 cd0000        	call	_Relay_Off
 254                     ; 328             break;
 256  00ba               L75:
 257                     ; 353 }
 260  00ba 81            	ret
 386                     	switch	.ubsct
 387  0000               L11_safetyTimer:
 388  0000 000000000000  	ds.b	9
 389  0009               L7_cooldownTimer:
 390  0009 000000000000  	ds.b	9
 391  0012               L5_relayTimer:
 392  0012 000000000000  	ds.b	9
 393  001b               L3_currentState:
 394  001b 00            	ds.b	1
 395                     	xref	_Buzzer_Play
 396                     	xref	_Debug_Log
 397                     	xref	_Mode_GetCutTime
 398                     	xref	_Relay_Off
 399                     	xref	_Relay_On
 400                     	xref	_Relay_Init
 401                     	xref	_Button_IsPressed
 402                     	xref	_Button_GetPress
 403                     	xdef	_QuickShifter_Task
 404                     	xdef	_QuickShifter_Init
 405                     	xref	_SoftwareTimer_Expired
 406                     	xref	_SoftwareTimer_Start
 407                     .const:	section	.text
 408  0000               L56:
 409  0000 5b4641554c54  	dc.b	"[FAULT] Maximum cu"
 410  0012 742074696d65  	dc.b	"t time exceeded",13
 411  0022 0a00          	dc.b	10,0
 412                     	xref.b	c_lreg
 432                     	xref	c_uitolx
 433                     	end
