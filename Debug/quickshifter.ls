   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  45                     ; 16 void QuickShifter_Init(void)
  45                     ; 17 {
  47                     	switch	.text
  48  0000               _QuickShifter_Init:
  52                     ; 18     GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
  54  0000 ae0002        	ldw	x,#2
  55  0003 cd0000        	call	_GPIO_Output_PP
  57                     ; 20 		GPIO_Clear(RELAY_PORT, RELAY_PIN);
  59  0006 ae0002        	ldw	x,#2
  60  0009 cd0000        	call	_GPIO_Clear
  62                     ; 22     currentState = QS_STATE_IDLE;
  64  000c 3f12          	clr	L3_currentState
  65                     ; 23 }
  68  000e 81            	ret
 100                     ; 26 void QuickShifter_Task(void)
 100                     ; 27 {
 101                     	switch	.text
 102  000f               _QuickShifter_Task:
 106                     ; 28     switch(currentState)
 108  000f b612          	ld	a,L3_currentState
 110                     ; 83             break;
 111  0011 4d            	tnz	a
 112  0012 270d          	jreq	L72
 113  0014 4a            	dec	a
 114  0015 272c          	jreq	L13
 115  0017 4a            	dec	a
 116  0018 274e          	jreq	L33
 117  001a 4a            	dec	a
 118  001b 275a          	jreq	L53
 119  001d               L73:
 120                     ; 79         default:
 120                     ; 80 
 120                     ; 81             currentState = QS_STATE_IDLE;
 122  001d 3f12          	clr	L3_currentState
 123                     ; 83             break;
 125  001f 2062          	jra	L35
 126  0021               L72:
 127                     ; 31         case QS_STATE_IDLE:
 127                     ; 32 
 127                     ; 33             if(Button_GetPress())
 129  0021 cd0000        	call	_Button_GetPress
 131  0024 4d            	tnz	a
 132  0025 275c          	jreq	L35
 133                     ; 35                 GPIO_Set(RELAY_PORT, RELAY_PIN);
 135  0027 ae0002        	ldw	x,#2
 136  002a cd0000        	call	_GPIO_Set
 138                     ; 37                 SoftwareTimer_Start(&relayTimer, SHIFT_TIME_MS);
 140  002d ae0028        	ldw	x,#40
 141  0030 89            	pushw	x
 142  0031 ae0000        	ldw	x,#0
 143  0034 89            	pushw	x
 144  0035 ae0009        	ldw	x,#L5_relayTimer
 145  0038 cd0000        	call	_SoftwareTimer_Start
 147  003b 5b04          	addw	sp,#4
 148                     ; 39                 currentState = QS_STATE_CUT_ACTIVE;
 150  003d 35010012      	mov	L3_currentState,#1
 151  0041 2040          	jra	L35
 152  0043               L13:
 153                     ; 45         case QS_STATE_CUT_ACTIVE:
 153                     ; 46 
 153                     ; 47             if(SoftwareTimer_Expired(&relayTimer))
 155  0043 ae0009        	ldw	x,#L5_relayTimer
 156  0046 cd0000        	call	_SoftwareTimer_Expired
 158  0049 4d            	tnz	a
 159  004a 2737          	jreq	L35
 160                     ; 49                 GPIO_Clear(RELAY_PORT, RELAY_PIN);
 162  004c ae0002        	ldw	x,#2
 163  004f cd0000        	call	_GPIO_Clear
 165                     ; 51                 SoftwareTimer_Start(&cooldownTimer,100);
 167  0052 ae0064        	ldw	x,#100
 168  0055 89            	pushw	x
 169  0056 ae0000        	ldw	x,#0
 170  0059 89            	pushw	x
 171  005a ae0000        	ldw	x,#L7_cooldownTimer
 172  005d cd0000        	call	_SoftwareTimer_Start
 174  0060 5b04          	addw	sp,#4
 175                     ; 53                 currentState = QS_STATE_COOLDOWN;
 177  0062 35020012      	mov	L3_currentState,#2
 178  0066 201b          	jra	L35
 179  0068               L33:
 180                     ; 59         case QS_STATE_COOLDOWN:
 180                     ; 60 
 180                     ; 61             if(SoftwareTimer_Expired(&cooldownTimer))
 182  0068 ae0000        	ldw	x,#L7_cooldownTimer
 183  006b cd0000        	call	_SoftwareTimer_Expired
 185  006e 4d            	tnz	a
 186  006f 2712          	jreq	L35
 187                     ; 63                 currentState = QS_STATE_WAIT_RELEASE;
 189  0071 35030012      	mov	L3_currentState,#3
 190  0075 200c          	jra	L35
 191  0077               L53:
 192                     ; 69         case QS_STATE_WAIT_RELEASE:
 192                     ; 70 
 192                     ; 71             if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==TRUE)
 194  0077 ae0003        	ldw	x,#3
 195  007a cd0000        	call	_GPIO_Read
 197  007d a101          	cp	a,#1
 198  007f 2602          	jrne	L35
 199                     ; 73                 currentState = QS_STATE_IDLE;
 201  0081 3f12          	clr	L3_currentState
 202  0083               L35:
 203                     ; 85 }
 206  0083 81            	ret
 315                     	switch	.ubsct
 316  0000               L7_cooldownTimer:
 317  0000 000000000000  	ds.b	9
 318  0009               L5_relayTimer:
 319  0009 000000000000  	ds.b	9
 320  0012               L3_currentState:
 321  0012 00            	ds.b	1
 322                     	xref	_GPIO_Read
 323                     	xref	_GPIO_Clear
 324                     	xref	_GPIO_Set
 325                     	xref	_GPIO_Output_PP
 326                     	xref	_Button_GetPress
 327                     	xdef	_QuickShifter_Task
 328                     	xdef	_QuickShifter_Init
 329                     	xref	_SoftwareTimer_Expired
 330                     	xref	_SoftwareTimer_Start
 350                     	end
