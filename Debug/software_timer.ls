   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  95                     ; 5 void SoftwareTimer_Start(SoftwareTimer_t *timer, uint32_t duration)
  95                     ; 6 {
  97                     	switch	.text
  98  0000               _SoftwareTimer_Start:
 100  0000 89            	pushw	x
 101       00000000      OFST:	set	0
 104                     ; 7     timer->start_time = Timer_GetTick();
 106  0001 cd0000        	call	_Timer_GetTick
 108  0004 1e01          	ldw	x,(OFST+1,sp)
 109  0006 cd0000        	call	c_rtol
 111                     ; 8     timer->duration = duration;
 113  0009 1e01          	ldw	x,(OFST+1,sp)
 114  000b 7b08          	ld	a,(OFST+8,sp)
 115  000d e707          	ld	(7,x),a
 116  000f 7b07          	ld	a,(OFST+7,sp)
 117  0011 e706          	ld	(6,x),a
 118  0013 7b06          	ld	a,(OFST+6,sp)
 119  0015 e705          	ld	(5,x),a
 120  0017 7b05          	ld	a,(OFST+5,sp)
 121  0019 e704          	ld	(4,x),a
 122                     ; 9     timer->active = TRUE;
 124  001b 1e01          	ldw	x,(OFST+1,sp)
 125  001d a601          	ld	a,#1
 126  001f e708          	ld	(8,x),a
 127                     ; 10 }
 130  0021 85            	popw	x
 131  0022 81            	ret
 168                     ; 13 void SoftwareTimer_Stop(SoftwareTimer_t *timer)
 168                     ; 14 {
 169                     	switch	.text
 170  0023               _SoftwareTimer_Stop:
 174                     ; 15     timer->active = FALSE;
 176  0023 6f08          	clr	(8,x)
 177                     ; 16 }
 180  0025 81            	ret
 218                     ; 19 uint8_t SoftwareTimer_IsRunning(SoftwareTimer_t *timer)
 218                     ; 20 {
 219                     	switch	.text
 220  0026               _SoftwareTimer_IsRunning:
 224                     ; 21     return timer->active;
 226  0026 e608          	ld	a,(8,x)
 229  0028 81            	ret
 268                     ; 25 uint8_t SoftwareTimer_Expired(SoftwareTimer_t *timer)
 268                     ; 26 {
 269                     	switch	.text
 270  0029               _SoftwareTimer_Expired:
 272  0029 89            	pushw	x
 273       00000000      OFST:	set	0
 276                     ; 27     if(timer->active == FALSE)
 278  002a 6d08          	tnz	(8,x)
 279  002c 2603          	jrne	L721
 280                     ; 29         return FALSE;
 282  002e 4f            	clr	a
 284  002f 2018          	jra	L41
 285  0031               L721:
 286                     ; 32     if((Timer_GetTick() - timer->start_time) >= timer->duration)
 288  0031 cd0000        	call	_Timer_GetTick
 290  0034 1e01          	ldw	x,(OFST+1,sp)
 291  0036 cd0000        	call	c_lsub
 293  0039 1e01          	ldw	x,(OFST+1,sp)
 294  003b 1c0004        	addw	x,#4
 295  003e cd0000        	call	c_lcmp
 297  0041 2508          	jrult	L131
 298                     ; 34         timer->active = FALSE;
 300  0043 1e01          	ldw	x,(OFST+1,sp)
 301  0045 6f08          	clr	(8,x)
 302                     ; 36         return TRUE;
 304  0047 a601          	ld	a,#1
 306  0049               L41:
 308  0049 85            	popw	x
 309  004a 81            	ret
 310  004b               L131:
 311                     ; 39     return FALSE;
 313  004b 4f            	clr	a
 315  004c 20fb          	jra	L41
 328                     	xref	_Timer_GetTick
 329                     	xdef	_SoftwareTimer_IsRunning
 330                     	xdef	_SoftwareTimer_Expired
 331                     	xdef	_SoftwareTimer_Stop
 332                     	xdef	_SoftwareTimer_Start
 351                     	xref	c_lcmp
 352                     	xref	c_lsub
 353                     	xref	c_rtol
 354                     	end
