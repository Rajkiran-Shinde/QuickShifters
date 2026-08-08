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
  51                     ; 18 void Mode_Init(void)
  51                     ; 19 {
  53                     	switch	.text
  54  0000               _Mode_Init:
  58                     ; 26     currentMode = (QuickShifterMode_t)EEPROM_LoadMode();
  60  0000 cd0000        	call	_EEPROM_LoadMode
  62  0003 b700          	ld	L3_currentMode,a
  63                     ; 27 }
  66  0005 81            	ret
  91                     ; 30 void Mode_Next(void)
  91                     ; 31 {
  92                     	switch	.text
  93  0006               _Mode_Next:
  97                     ; 32     currentMode++;
  99  0006 3c00          	inc	L3_currentMode
 100                     ; 34     if(currentMode >= MODE_COUNT)
 102  0008 b600          	ld	a,L3_currentMode
 103  000a a105          	cp	a,#5
 104  000c 2502          	jrult	L53
 105                     ; 36         currentMode = QS_MODE_1;
 107  000e 3f00          	clr	L3_currentMode
 108  0010               L53:
 109                     ; 42     EEPROM_SaveMode((uint8_t)currentMode);
 111  0010 b600          	ld	a,L3_currentMode
 112  0012 cd0000        	call	_EEPROM_SaveMode
 114                     ; 43 }
 117  0015 81            	ret
 183                     ; 46 QuickShifterMode_t Mode_Get(void)
 183                     ; 47 {
 184                     	switch	.text
 185  0016               _Mode_Get:
 189                     ; 48     return currentMode;
 191  0016 b600          	ld	a,L3_currentMode
 194  0018 81            	ret
 219                     ; 52 uint16_t Mode_GetCutTime(void)
 219                     ; 53 {
 220                     	switch	.text
 221  0019               _Mode_GetCutTime:
 225                     ; 54     return cutTimes[currentMode];
 227  0019 b600          	ld	a,L3_currentMode
 228  001b 5f            	clrw	x
 229  001c 97            	ld	xl,a
 230  001d 58            	sllw	x
 231  001e de0000        	ldw	x,(L5_cutTimes,x)
 234  0021 81            	ret
 269                     	switch	.ubsct
 270  0000               L3_currentMode:
 271  0000 00            	ds.b	1
 272                     	xref	_EEPROM_SaveMode
 273                     	xref	_EEPROM_LoadMode
 274                     	xdef	_Mode_GetCutTime
 275                     	xdef	_Mode_Get
 276                     	xdef	_Mode_Next
 277                     	xdef	_Mode_Init
 297                     	end
