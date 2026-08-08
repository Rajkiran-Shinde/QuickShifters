   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  45                     ; 17 void QuickShifter_Init(void)
  45                     ; 18 {
  47                     	switch	.text
  48  0000               _QuickShifter_Init:
  52                     ; 19     GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
  54  0000 ae0002        	ldw	x,#2
  55  0003 cd0000        	call	_GPIO_Output_PP
  57                     ; 21 		GPIO_Clear(RELAY_PORT, RELAY_PIN);
  59  0006 ae0002        	ldw	x,#2
  60  0009 cd0000        	call	_GPIO_Clear
  62                     ; 23     currentState = QS_STATE_IDLE;
  64  000c 3f12          	clr	L3_currentState
  65                     ; 24 }
  68  000e 81            	ret
 101                     ; 27 void QuickShifter_Task(void)
 101                     ; 28 {
 102                     	switch	.text
 103  000f               _QuickShifter_Task:
 107                     ; 29     switch(currentState)
 109  000f b612          	ld	a,L3_currentState
 111                     ; 84             break;
 112  0011 4d            	tnz	a
 113  0012 270d          	jreq	L72
 114  0014 4a            	dec	a
 115  0015 2730          	jreq	L13
 116  0017 4a            	dec	a
 117  0018 2752          	jreq	L33
 118  001a 4a            	dec	a
 119  001b 275e          	jreq	L53
 120  001d               L73:
 121                     ; 80         default:
 121                     ; 81 
 121                     ; 82             currentState = QS_STATE_IDLE;
 123  001d 3f12          	clr	L3_currentState
 124                     ; 84             break;
 126  001f 2066          	jra	L35
 127  0021               L72:
 128                     ; 32         case QS_STATE_IDLE:
 128                     ; 33 
 128                     ; 34             if(Button_GetPress())
 130  0021 cd0000        	call	_Button_GetPress
 132  0024 4d            	tnz	a
 133  0025 2760          	jreq	L35
 134                     ; 36                 GPIO_Set(RELAY_PORT, RELAY_PIN);
 136  0027 ae0002        	ldw	x,#2
 137  002a cd0000        	call	_GPIO_Set
 139                     ; 38                 SoftwareTimer_Start(&relayTimer, Mode_GetCutTime());
 141  002d cd0000        	call	_Mode_GetCutTime
 143  0030 cd0000        	call	c_uitolx
 145  0033 be02          	ldw	x,c_lreg+2
 146  0035 89            	pushw	x
 147  0036 be00          	ldw	x,c_lreg
 148  0038 89            	pushw	x
 149  0039 ae0009        	ldw	x,#L5_relayTimer
 150  003c cd0000        	call	_SoftwareTimer_Start
 152  003f 5b04          	addw	sp,#4
 153                     ; 40                 currentState = QS_STATE_CUT_ACTIVE;
 155  0041 35010012      	mov	L3_currentState,#1
 156  0045 2040          	jra	L35
 157  0047               L13:
 158                     ; 46         case QS_STATE_CUT_ACTIVE:
 158                     ; 47 
 158                     ; 48             if(SoftwareTimer_Expired(&relayTimer))
 160  0047 ae0009        	ldw	x,#L5_relayTimer
 161  004a cd0000        	call	_SoftwareTimer_Expired
 163  004d 4d            	tnz	a
 164  004e 2737          	jreq	L35
 165                     ; 50                 GPIO_Clear(RELAY_PORT, RELAY_PIN);
 167  0050 ae0002        	ldw	x,#2
 168  0053 cd0000        	call	_GPIO_Clear
 170                     ; 52                 SoftwareTimer_Start(&cooldownTimer,100);
 172  0056 ae0064        	ldw	x,#100
 173  0059 89            	pushw	x
 174  005a ae0000        	ldw	x,#0
 175  005d 89            	pushw	x
 176  005e ae0000        	ldw	x,#L7_cooldownTimer
 177  0061 cd0000        	call	_SoftwareTimer_Start
 179  0064 5b04          	addw	sp,#4
 180                     ; 54                 currentState = QS_STATE_COOLDOWN;
 182  0066 35020012      	mov	L3_currentState,#2
 183  006a 201b          	jra	L35
 184  006c               L33:
 185                     ; 60         case QS_STATE_COOLDOWN:
 185                     ; 61 
 185                     ; 62             if(SoftwareTimer_Expired(&cooldownTimer))
 187  006c ae0000        	ldw	x,#L7_cooldownTimer
 188  006f cd0000        	call	_SoftwareTimer_Expired
 190  0072 4d            	tnz	a
 191  0073 2712          	jreq	L35
 192                     ; 64                 currentState = QS_STATE_WAIT_RELEASE;
 194  0075 35030012      	mov	L3_currentState,#3
 195  0079 200c          	jra	L35
 196  007b               L53:
 197                     ; 70         case QS_STATE_WAIT_RELEASE:
 197                     ; 71 
 197                     ; 72             if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==TRUE)
 199  007b ae0003        	ldw	x,#3
 200  007e cd0000        	call	_GPIO_Read
 202  0081 a101          	cp	a,#1
 203  0083 2602          	jrne	L35
 204                     ; 74                 currentState = QS_STATE_IDLE;
 206  0085 3f12          	clr	L3_currentState
 207  0087               L35:
 208                     ; 86 }
 211  0087 81            	ret
 320                     	switch	.ubsct
 321  0000               L7_cooldownTimer:
 322  0000 000000000000  	ds.b	9
 323  0009               L5_relayTimer:
 324  0009 000000000000  	ds.b	9
 325  0012               L3_currentState:
 326  0012 00            	ds.b	1
 327                     	xref	_Mode_GetCutTime
 328                     	xref	_GPIO_Read
 329                     	xref	_GPIO_Clear
 330                     	xref	_GPIO_Set
 331                     	xref	_GPIO_Output_PP
 332                     	xref	_Button_GetPress
 333                     	xdef	_QuickShifter_Task
 334                     	xdef	_QuickShifter_Init
 335                     	xref	_SoftwareTimer_Expired
 336                     	xref	_SoftwareTimer_Start
 337                     	xref.b	c_lreg
 357                     	xref	c_uitolx
 358                     	end
