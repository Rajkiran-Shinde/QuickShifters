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
  50                     ; 17 void Mode_Init(void)
  50                     ; 18 {
  52                     	switch	.text
  53  0000               _Mode_Init:
  57                     ; 19     currentMode = QS_MODE_1;
  59  0000 3f00          	clr	L3_currentMode
  60                     ; 20 }
  63  0002 81            	ret
  87                     ; 23 void Mode_Next(void)
  87                     ; 24 {
  88                     	switch	.text
  89  0003               _Mode_Next:
  93                     ; 25     currentMode++;
  95  0003 3c00          	inc	L3_currentMode
  96                     ; 27     if(currentMode >= MODE_COUNT)
  98  0005 b600          	ld	a,L3_currentMode
  99  0007 a105          	cp	a,#5
 100  0009 2502          	jrult	L53
 101                     ; 29         currentMode = QS_MODE_1;
 103  000b 3f00          	clr	L3_currentMode
 104  000d               L53:
 105                     ; 31 }
 108  000d 81            	ret
 174                     ; 34 QuickShifterMode_t Mode_Get(void)
 174                     ; 35 {
 175                     	switch	.text
 176  000e               _Mode_Get:
 180                     ; 36     return currentMode;
 182  000e b600          	ld	a,L3_currentMode
 185  0010 81            	ret
 210                     ; 40 uint16_t Mode_GetCutTime(void)
 210                     ; 41 {
 211                     	switch	.text
 212  0011               _Mode_GetCutTime:
 216                     ; 42     return cutTimes[currentMode];
 218  0011 b600          	ld	a,L3_currentMode
 219  0013 5f            	clrw	x
 220  0014 97            	ld	xl,a
 221  0015 58            	sllw	x
 222  0016 de0000        	ldw	x,(L5_cutTimes,x)
 225  0019 81            	ret
 260                     	switch	.ubsct
 261  0000               L3_currentMode:
 262  0000 00            	ds.b	1
 263                     	xdef	_Mode_GetCutTime
 264                     	xdef	_Mode_Get
 265                     	xdef	_Mode_Next
 266                     	xdef	_Mode_Init
 286                     	end
