   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  14                     .const:	section	.text
  15  0000               L5_cutTimes:
  16  0000 0028          	dc.w	40
  17  0002 0032          	dc.w	50
  18  0004 003c          	dc.w	60
  19  0006 0046          	dc.w	70
  20  0008 0050          	dc.w	80
  62                     ; 32 void Mode_Init(void)
  62                     ; 33 {
  64                     	switch	.text
  65  0000               _Mode_Init:
  67  0000 88            	push	a
  68       00000001      OFST:	set	1
  71                     ; 47     savedMode = EEPROM_LoadMode();
  73  0001 cd0000        	call	_EEPROM_LoadMode
  75  0004 6b01          	ld	(OFST+0,sp),a
  77                     ; 56     if(
  77                     ; 57         (savedMode >= 1) &&
  77                     ; 58         (savedMode <= MODE_COUNT)
  77                     ; 59     )
  79  0006 0d01          	tnz	(OFST+0,sp)
  80  0008 270d          	jreq	L33
  82  000a 7b01          	ld	a,(OFST+0,sp)
  83  000c a106          	cp	a,#6
  84  000e 2407          	jruge	L33
  85                     ; 61         currentMode =
  85                     ; 62             (QuickShifterMode_t)(
  85                     ; 63                 savedMode - 1
  85                     ; 64             );
  87  0010 7b01          	ld	a,(OFST+0,sp)
  88  0012 4a            	dec	a
  89  0013 b700          	ld	L3_currentMode,a
  91  0015 2002          	jra	L53
  92  0017               L33:
  93                     ; 72         currentMode = QS_MODE_1;
  95  0017 3f00          	clr	L3_currentMode
  96  0019               L53:
  97                     ; 74 }
 100  0019 84            	pop	a
 101  001a 81            	ret
 126                     ; 81 void Mode_Next(void)
 126                     ; 82 {
 127                     	switch	.text
 128  001b               _Mode_Next:
 132                     ; 89     currentMode++;
 134  001b 3c00          	inc	L3_currentMode
 135                     ; 92     if(currentMode >= MODE_COUNT)
 137  001d b600          	ld	a,L3_currentMode
 138  001f a105          	cp	a,#5
 139  0021 2502          	jrult	L74
 140                     ; 94         currentMode = QS_MODE_1;
 142  0023 3f00          	clr	L3_currentMode
 143  0025               L74:
 144                     ; 103     EEPROM_SaveMode(
 144                     ; 104         (uint8_t)currentMode + 1
 144                     ; 105     );
 146  0025 b600          	ld	a,L3_currentMode
 147  0027 4c            	inc	a
 148  0028 cd0000        	call	_EEPROM_SaveMode
 150                     ; 106 }
 153  002b 81            	ret
 219                     ; 113 QuickShifterMode_t Mode_Get(void)
 219                     ; 114 {
 220                     	switch	.text
 221  002c               _Mode_Get:
 225                     ; 115     return currentMode;
 227  002c b600          	ld	a,L3_currentMode
 230  002e 81            	ret
 255                     ; 123 uint16_t Mode_GetCutTime(void)
 255                     ; 124 {
 256                     	switch	.text
 257  002f               _Mode_GetCutTime:
 261                     ; 129     if(currentMode >= MODE_COUNT)
 263  002f b600          	ld	a,L3_currentMode
 264  0031 a105          	cp	a,#5
 265  0033 2502          	jrult	L701
 266                     ; 131         currentMode = QS_MODE_1;
 268  0035 3f00          	clr	L3_currentMode
 269  0037               L701:
 270                     ; 135     return cutTimes[currentMode];
 272  0037 b600          	ld	a,L3_currentMode
 273  0039 5f            	clrw	x
 274  003a 97            	ld	xl,a
 275  003b 58            	sllw	x
 276  003c de0000        	ldw	x,(L5_cutTimes,x)
 279  003f 81            	ret
 314                     	switch	.ubsct
 315  0000               L3_currentMode:
 316  0000 00            	ds.b	1
 317                     	xref	_EEPROM_SaveMode
 318                     	xref	_EEPROM_LoadMode
 319                     	xdef	_Mode_GetCutTime
 320                     	xdef	_Mode_Get
 321                     	xdef	_Mode_Next
 322                     	xdef	_Mode_Init
 342                     	end
