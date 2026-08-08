   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  44                     ; 23 void QuickShifter_Init(void)
  44                     ; 24 {
  46                     	switch	.text
  47  0000               _QuickShifter_Init:
  51                     ; 31     Relay_Init();
  53  0000 cd0000        	call	_Relay_Init
  55                     ; 37     currentState = QS_STATE_IDLE;
  57  0003 3f12          	clr	L3_currentState
  58                     ; 38 }
  61  0005 81            	ret
  94                     ; 45 void QuickShifter_Task(void)
  94                     ; 46 {
  95                     	switch	.text
  96  0006               _QuickShifter_Task:
 100                     ; 47     switch(currentState)
 102  0006 b612          	ld	a,L3_currentState
 104                     ; 185             break;
 105  0008 4d            	tnz	a
 106  0009 2710          	jreq	L72
 107  000b 4a            	dec	a
 108  000c 2730          	jreq	L13
 109  000e 4a            	dec	a
 110  000f 274f          	jreq	L33
 111  0011 4a            	dec	a
 112  0012 275b          	jreq	L53
 113  0014               L73:
 114                     ; 171         default:
 114                     ; 172 
 114                     ; 173             /*
 114                     ; 174              * Fail-safe behavior.
 114                     ; 175              *
 114                     ; 176              * If the state machine ever reaches an
 114                     ; 177              * invalid state, immediately disable
 114                     ; 178              * the relay.
 114                     ; 179              */
 114                     ; 180             Relay_Off();
 116  0014 cd0000        	call	_Relay_Off
 118                     ; 182             currentState =
 118                     ; 183                 QS_STATE_IDLE;
 120  0017 3f12          	clr	L3_currentState
 121                     ; 185             break;
 123  0019 205c          	jra	L35
 124  001b               L72:
 125                     ; 53         case QS_STATE_IDLE:
 125                     ; 54 
 125                     ; 55             /*
 125                     ; 56              * Relay must be OFF while idle.
 125                     ; 57              *
 125                     ; 58              * This is a safety invariant.
 125                     ; 59              */
 125                     ; 60             if(Button_GetPress())
 127  001b cd0000        	call	_Button_GetPress
 129  001e 4d            	tnz	a
 130  001f 2756          	jreq	L35
 131                     ; 66                 Relay_On();
 133  0021 cd0000        	call	_Relay_On
 135                     ; 72                 SoftwareTimer_Start(
 135                     ; 73                     &relayTimer,
 135                     ; 74                     Mode_GetCutTime()
 135                     ; 75                 );
 137  0024 cd0000        	call	_Mode_GetCutTime
 139  0027 cd0000        	call	c_uitolx
 141  002a be02          	ldw	x,c_lreg+2
 142  002c 89            	pushw	x
 143  002d be00          	ldw	x,c_lreg
 144  002f 89            	pushw	x
 145  0030 ae0009        	ldw	x,#L5_relayTimer
 146  0033 cd0000        	call	_SoftwareTimer_Start
 148  0036 5b04          	addw	sp,#4
 149                     ; 77                 currentState =
 149                     ; 78                     QS_STATE_CUT_ACTIVE;
 151  0038 35010012      	mov	L3_currentState,#1
 152  003c 2039          	jra	L35
 153  003e               L13:
 154                     ; 88         case QS_STATE_CUT_ACTIVE:
 154                     ; 89 
 154                     ; 90             /*
 154                     ; 91              * Relay remains ON during the cut.
 154                     ; 92              *
 154                     ; 93              * We don't repeatedly call Relay_On()
 154                     ; 94              * because it was already activated when
 154                     ; 95              * entering this state.
 154                     ; 96              */
 154                     ; 97 
 154                     ; 98             if(SoftwareTimer_Expired(&relayTimer))
 156  003e ae0009        	ldw	x,#L5_relayTimer
 157  0041 cd0000        	call	_SoftwareTimer_Expired
 159  0044 4d            	tnz	a
 160  0045 2730          	jreq	L35
 161                     ; 105                 Relay_Off();
 163  0047 cd0000        	call	_Relay_Off
 165                     ; 111                 SoftwareTimer_Start(
 165                     ; 112                     &cooldownTimer,
 165                     ; 113                     100
 165                     ; 114                 );
 167  004a ae0064        	ldw	x,#100
 168  004d 89            	pushw	x
 169  004e ae0000        	ldw	x,#0
 170  0051 89            	pushw	x
 171  0052 ae0000        	ldw	x,#L7_cooldownTimer
 172  0055 cd0000        	call	_SoftwareTimer_Start
 174  0058 5b04          	addw	sp,#4
 175                     ; 116                 currentState =
 175                     ; 117                     QS_STATE_COOLDOWN;
 177  005a 35020012      	mov	L3_currentState,#2
 178  005e 2017          	jra	L35
 179  0060               L33:
 180                     ; 127         case QS_STATE_COOLDOWN:
 180                     ; 128 
 180                     ; 129             /*
 180                     ; 130              * Relay was already turned OFF when
 180                     ; 131              * entering this state.
 180                     ; 132              *
 180                     ; 133              * Ignore additional shift presses.
 180                     ; 134              */
 180                     ; 135 
 180                     ; 136             if(SoftwareTimer_Expired(&cooldownTimer))
 182  0060 ae0000        	ldw	x,#L7_cooldownTimer
 183  0063 cd0000        	call	_SoftwareTimer_Expired
 185  0066 4d            	tnz	a
 186  0067 270e          	jreq	L35
 187                     ; 138                 currentState =
 187                     ; 139                     QS_STATE_WAIT_RELEASE;
 189  0069 35030012      	mov	L3_currentState,#3
 190  006d 2008          	jra	L35
 191  006f               L53:
 192                     ; 149         case QS_STATE_WAIT_RELEASE:
 192                     ; 150 
 192                     ; 151             /*
 192                     ; 152              * Wait until the debounced shift button
 192                     ; 153              * is actually released.
 192                     ; 154              *
 192                     ; 155              * This prevents one long button press
 192                     ; 156              * from generating multiple cuts.
 192                     ; 157              */
 192                     ; 158             if(Button_IsPressed() == FALSE)
 194  006f cd0000        	call	_Button_IsPressed
 196  0072 4d            	tnz	a
 197  0073 2602          	jrne	L35
 198                     ; 160                 currentState =
 198                     ; 161                     QS_STATE_IDLE;
 200  0075 3f12          	clr	L3_currentState
 201  0077               L35:
 202                     ; 187 }
 205  0077 81            	ret
 314                     	switch	.ubsct
 315  0000               L7_cooldownTimer:
 316  0000 000000000000  	ds.b	9
 317  0009               L5_relayTimer:
 318  0009 000000000000  	ds.b	9
 319  0012               L3_currentState:
 320  0012 00            	ds.b	1
 321                     	xref	_Mode_GetCutTime
 322                     	xref	_Relay_Off
 323                     	xref	_Relay_On
 324                     	xref	_Relay_Init
 325                     	xref	_Button_IsPressed
 326                     	xref	_Button_GetPress
 327                     	xdef	_QuickShifter_Task
 328                     	xdef	_QuickShifter_Init
 329                     	xref	_SoftwareTimer_Expired
 330                     	xref	_SoftwareTimer_Start
 331                     	xref.b	c_lreg
 351                     	xref	c_uitolx
 352                     	end
