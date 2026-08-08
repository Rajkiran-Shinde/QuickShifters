   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 77 void QuickShifter_Init(void)
  44                     ; 78 {
  46                     	switch	.text
  47  0000               _QuickShifter_Init:
  51                     ; 85     Relay_Init();
  53  0000 cd0000        	call	_Relay_Init
  55                     ; 91     currentState = QS_STATE_IDLE;
  57  0003 3f1b          	clr	L3_currentState
  58                     ; 92 }
  61  0005 81            	ret
  96                     ; 99 void QuickShifter_Task(void)
  96                     ; 100 {
  97                     	switch	.text
  98  0006               _QuickShifter_Task:
 102                     ; 101     switch(currentState)
 104  0006 b61b          	ld	a,L3_currentState
 106                     ; 349             break;
 107  0008 4d            	tnz	a
 108  0009 271d          	jreq	L13
 109  000b 4a            	dec	a
 110  000c 274d          	jreq	L33
 111  000e 4a            	dec	a
 112  000f 2603cc0095    	jreq	L53
 113  0014 4a            	dec	a
 114  0015 2603cc00a4    	jreq	L73
 115  001a 4a            	dec	a
 116  001b 2603          	jrne	L01
 117  001d cc00ae        	jp	L14
 118  0020               L01:
 119  0020               L34:
 120                     ; 333         default:
 120                     ; 334 
 120                     ; 335             /*
 120                     ; 336              * FAIL-SAFE BEHAVIOR
 120                     ; 337              *
 120                     ; 338              * If the state machine ever reaches
 120                     ; 339              * an invalid state:
 120                     ; 340              *
 120                     ; 341              * 1. Turn relay OFF immediately.
 120                     ; 342              * 2. Return to a known safe state.
 120                     ; 343              */
 120                     ; 344             Relay_Off();
 122  0020 cd0000        	call	_Relay_Off
 124                     ; 346             currentState =
 124                     ; 347                 QS_STATE_IDLE;
 126  0023 3f1b          	clr	L3_currentState
 127                     ; 349             break;
 129  0025 cc00b1        	jra	L75
 130  0028               L13:
 131                     ; 108         case QS_STATE_IDLE:
 131                     ; 109 
 131                     ; 110             /*
 131                     ; 111              * Relay must be OFF while idle.
 131                     ; 112              *
 131                     ; 113              * A valid debounced button press
 131                     ; 114              * starts a new QuickShifter cut.
 131                     ; 115              */
 131                     ; 116             if(Button_GetPress())
 133  0028 cd0000        	call	_Button_GetPress
 135  002b 4d            	tnz	a
 136  002c 27f7          	jreq	L75
 137                     ; 122                 Relay_On();
 139  002e cd0000        	call	_Relay_On
 141                     ; 134                 SoftwareTimer_Start(
 141                     ; 135                     &relayTimer,
 141                     ; 136                     Mode_GetCutTime()
 141                     ; 137                 );
 143  0031 cd0000        	call	_Mode_GetCutTime
 145  0034 cd0000        	call	c_uitolx
 147  0037 be02          	ldw	x,c_lreg+2
 148  0039 89            	pushw	x
 149  003a be00          	ldw	x,c_lreg
 150  003c 89            	pushw	x
 151  003d ae0012        	ldw	x,#L5_relayTimer
 152  0040 cd0000        	call	_SoftwareTimer_Start
 154  0043 5b04          	addw	sp,#4
 155                     ; 147                 SoftwareTimer_Start(
 155                     ; 148                     &safetyTimer,
 155                     ; 149                     QS_MAX_CUT_TIME_MS
 155                     ; 150                 );
 157  0045 ae0064        	ldw	x,#100
 158  0048 89            	pushw	x
 159  0049 ae0000        	ldw	x,#0
 160  004c 89            	pushw	x
 161  004d ae0000        	ldw	x,#L11_safetyTimer
 162  0050 cd0000        	call	_SoftwareTimer_Start
 164  0053 5b04          	addw	sp,#4
 165                     ; 156                 currentState =
 165                     ; 157                     QS_STATE_CUT_ACTIVE;
 167  0055 3501001b      	mov	L3_currentState,#1
 168  0059 2056          	jra	L75
 169  005b               L33:
 170                     ; 167         case QS_STATE_CUT_ACTIVE:
 170                     ; 168 
 170                     ; 169             /*
 170                     ; 170              * Relay is currently ON.
 170                     ; 171              *
 170                     ; 172              * Two timers are running:
 170                     ; 173              *
 170                     ; 174              * 1. relayTimer
 170                     ; 175              *    -> normal 40-80 ms cut
 170                     ; 176              *
 170                     ; 177              * 2. safetyTimer
 170                     ; 178              *    -> absolute 100 ms limit
 170                     ; 179              */
 170                     ; 180 
 170                     ; 181 
 170                     ; 182             /************************************
 170                     ; 183                     SAFETY TIMER CHECK
 170                     ; 184             ************************************/
 170                     ; 185 
 170                     ; 186             /*
 170                     ; 187              * Check the safety timer FIRST.
 170                     ; 188              *
 170                     ; 189              * If this expires, something has gone
 170                     ; 190              * wrong with the normal timing path.
 170                     ; 191              */
 170                     ; 192             if(SoftwareTimer_Expired(&safetyTimer))
 172  005b ae0000        	ldw	x,#L11_safetyTimer
 173  005e cd0000        	call	_SoftwareTimer_Expired
 175  0061 4d            	tnz	a
 176  0062 270f          	jreq	L36
 177                     ; 199                 Relay_Off();
 179  0064 cd0000        	call	_Relay_Off
 181                     ; 205                 Debug_Log(
 181                     ; 206                     "[FAULT] Maximum cut time exceeded\r\n"
 181                     ; 207                 );
 183  0067 ae0000        	ldw	x,#L56
 184  006a cd0000        	call	_Debug_Log
 186                     ; 213                 currentState =
 186                     ; 214                     QS_STATE_FAULT;
 188  006d 3504001b      	mov	L3_currentState,#4
 189                     ; 216                 break;
 191  0071 203e          	jra	L75
 192  0073               L36:
 193                     ; 227             if(SoftwareTimer_Expired(&relayTimer))
 195  0073 ae0012        	ldw	x,#L5_relayTimer
 196  0076 cd0000        	call	_SoftwareTimer_Expired
 198  0079 4d            	tnz	a
 199  007a 2735          	jreq	L75
 200                     ; 234                 Relay_Off();
 202  007c cd0000        	call	_Relay_Off
 204                     ; 243                 SoftwareTimer_Start(
 204                     ; 244                     &cooldownTimer,
 204                     ; 245                     100
 204                     ; 246                 );
 206  007f ae0064        	ldw	x,#100
 207  0082 89            	pushw	x
 208  0083 ae0000        	ldw	x,#0
 209  0086 89            	pushw	x
 210  0087 ae0009        	ldw	x,#L7_cooldownTimer
 211  008a cd0000        	call	_SoftwareTimer_Start
 213  008d 5b04          	addw	sp,#4
 214                     ; 252                 currentState =
 214                     ; 253                     QS_STATE_COOLDOWN;
 216  008f 3502001b      	mov	L3_currentState,#2
 217  0093 201c          	jra	L75
 218  0095               L53:
 219                     ; 263         case QS_STATE_COOLDOWN:
 219                     ; 264 
 219                     ; 265             /*
 219                     ; 266              * Relay was already turned OFF when
 219                     ; 267              * entering this state.
 219                     ; 268              *
 219                     ; 269              * Additional shift presses are ignored
 219                     ; 270              * during cooldown.
 219                     ; 271              */
 219                     ; 272 
 219                     ; 273             if(SoftwareTimer_Expired(&cooldownTimer))
 221  0095 ae0009        	ldw	x,#L7_cooldownTimer
 222  0098 cd0000        	call	_SoftwareTimer_Expired
 224  009b 4d            	tnz	a
 225  009c 2713          	jreq	L75
 226                     ; 281                 currentState =
 226                     ; 282                     QS_STATE_WAIT_RELEASE;
 228  009e 3503001b      	mov	L3_currentState,#3
 229  00a2 200d          	jra	L75
 230  00a4               L73:
 231                     ; 292         case QS_STATE_WAIT_RELEASE:
 231                     ; 293 
 231                     ; 294             /*
 231                     ; 295              * Wait until the debounced shift button
 231                     ; 296              * is actually released.
 231                     ; 297              *
 231                     ; 298              * This prevents one long button press
 231                     ; 299              * from generating multiple cuts.
 231                     ; 300              */
 231                     ; 301             if(Button_IsPressed() == FALSE)
 233  00a4 cd0000        	call	_Button_IsPressed
 235  00a7 4d            	tnz	a
 236  00a8 2607          	jrne	L75
 237                     ; 303                 currentState =
 237                     ; 304                     QS_STATE_IDLE;
 239  00aa 3f1b          	clr	L3_currentState
 240  00ac 2003          	jra	L75
 241  00ae               L14:
 242                     ; 314         case QS_STATE_FAULT:
 242                     ; 315 
 242                     ; 316             /*
 242                     ; 317              * FAIL-SAFE STATE
 242                     ; 318              *
 242                     ; 319              * Relay MUST remain OFF.
 242                     ; 320              *
 242                     ; 321              * No further QuickShifter cuts are
 242                     ; 322              * allowed while the system is in FAULT.
 242                     ; 323              */
 242                     ; 324             Relay_Off();
 244  00ae cd0000        	call	_Relay_Off
 246                     ; 326             break;
 248  00b1               L75:
 249                     ; 351 }
 252  00b1 81            	ret
 378                     	switch	.ubsct
 379  0000               L11_safetyTimer:
 380  0000 000000000000  	ds.b	9
 381  0009               L7_cooldownTimer:
 382  0009 000000000000  	ds.b	9
 383  0012               L5_relayTimer:
 384  0012 000000000000  	ds.b	9
 385  001b               L3_currentState:
 386  001b 00            	ds.b	1
 387                     	xref	_Debug_Log
 388                     	xref	_Mode_GetCutTime
 389                     	xref	_Relay_Off
 390                     	xref	_Relay_On
 391                     	xref	_Relay_Init
 392                     	xref	_Button_IsPressed
 393                     	xref	_Button_GetPress
 394                     	xdef	_QuickShifter_Task
 395                     	xdef	_QuickShifter_Init
 396                     	xref	_SoftwareTimer_Expired
 397                     	xref	_SoftwareTimer_Start
 398                     .const:	section	.text
 399  0000               L56:
 400  0000 5b4641554c54  	dc.b	"[FAULT] Maximum cu"
 401  0012 742074696d65  	dc.b	"t time exceeded",13
 402  0022 0a00          	dc.b	10,0
 403                     	xref.b	c_lreg
 423                     	xref	c_uitolx
 424                     	end
