   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 171                     ; 16 static void LED_Write(GPIO_Port port, GPIO_Pin pin, uint8_t state)
 171                     ; 17 {
 173                     	switch	.text
 174  0000               L3_LED_Write:
 176  0000 89            	pushw	x
 177       00000000      OFST:	set	0
 180                     ; 18     if(state == TRUE)
 182  0001 7b05          	ld	a,(OFST+5,sp)
 183  0003 a101          	cp	a,#1
 184  0005 260a          	jrne	L101
 185                     ; 20         GPIO_Set(port, pin);
 187  0007 9f            	ld	a,xl
 188  0008 97            	ld	xl,a
 189  0009 7b01          	ld	a,(OFST+1,sp)
 190  000b 95            	ld	xh,a
 191  000c cd0000        	call	_GPIO_Set
 194  000f 2009          	jra	L301
 195  0011               L101:
 196                     ; 24         GPIO_Clear(port, pin);
 198  0011 7b02          	ld	a,(OFST+2,sp)
 199  0013 97            	ld	xl,a
 200  0014 7b01          	ld	a,(OFST+1,sp)
 201  0016 95            	ld	xh,a
 202  0017 cd0000        	call	_GPIO_Clear
 204  001a               L301:
 205                     ; 26 }
 208  001a 85            	popw	x
 209  001b 81            	ret
 234                     ; 33 void LED_Init(void)
 234                     ; 34 {
 235                     	switch	.text
 236  001c               _LED_Init:
 240                     ; 39     GPIO_Output_PP(MODE_LED1_PORT, MODE_LED1_PIN);
 242  001c ae0306        	ldw	x,#774
 243  001f cd0000        	call	_GPIO_Output_PP
 245                     ; 41     LED_Write(
 245                     ; 42         MODE_LED1_PORT,
 245                     ; 43         MODE_LED1_PIN,
 245                     ; 44         FALSE
 245                     ; 45     );
 247  0022 4b00          	push	#0
 248  0024 ae0306        	ldw	x,#774
 249  0027 add7          	call	L3_LED_Write
 251  0029 84            	pop	a
 252                     ; 52     GPIO_Output_PP(MODE_LED2_PORT, MODE_LED2_PIN);
 254  002a ae0001        	ldw	x,#1
 255  002d cd0000        	call	_GPIO_Output_PP
 257                     ; 54     LED_Write(
 257                     ; 55         MODE_LED2_PORT,
 257                     ; 56         MODE_LED2_PIN,
 257                     ; 57         FALSE
 257                     ; 58     );
 259  0030 4b00          	push	#0
 260  0032 ae0001        	ldw	x,#1
 261  0035 adc9          	call	L3_LED_Write
 263  0037 84            	pop	a
 264                     ; 65     GPIO_Output_PP(MODE_LED3_PORT, MODE_LED3_PIN);
 266  0038 ae0203        	ldw	x,#515
 267  003b cd0000        	call	_GPIO_Output_PP
 269                     ; 67     LED_Write(
 269                     ; 68         MODE_LED3_PORT,
 269                     ; 69         MODE_LED3_PIN,
 269                     ; 70         FALSE
 269                     ; 71     );
 271  003e 4b00          	push	#0
 272  0040 ae0203        	ldw	x,#515
 273  0043 adbb          	call	L3_LED_Write
 275  0045 84            	pop	a
 276                     ; 78     GPIO_Output_PP(MODE_LED4_PORT, MODE_LED4_PIN);
 278  0046 ae0204        	ldw	x,#516
 279  0049 cd0000        	call	_GPIO_Output_PP
 281                     ; 80     LED_Write(
 281                     ; 81         MODE_LED4_PORT,
 281                     ; 82         MODE_LED4_PIN,
 281                     ; 83         FALSE
 281                     ; 84     );
 283  004c 4b00          	push	#0
 284  004e ae0204        	ldw	x,#516
 285  0051 adad          	call	L3_LED_Write
 287  0053 84            	pop	a
 288                     ; 91     GPIO_Output_PP(MODE_LED5_PORT, MODE_LED5_PIN);
 290  0054 ae0205        	ldw	x,#517
 291  0057 cd0000        	call	_GPIO_Output_PP
 293                     ; 93     LED_Write(
 293                     ; 94         MODE_LED5_PORT,
 293                     ; 95         MODE_LED5_PIN,
 293                     ; 96         FALSE
 293                     ; 97     );
 295  005a 4b00          	push	#0
 296  005c ae0205        	ldw	x,#517
 297  005f ad9f          	call	L3_LED_Write
 299  0061 84            	pop	a
 300                     ; 98 }
 303  0062 81            	ret
 347                     ; 105 void LED_Mode_Set(uint8_t mode, uint8_t state)
 347                     ; 106 {
 348                     	switch	.text
 349  0063               _LED_Mode_Set:
 351  0063 89            	pushw	x
 352       00000000      OFST:	set	0
 355                     ; 107     switch(mode)
 357  0064 9e            	ld	a,xh
 359                     ; 164         default:
 359                     ; 165             /*
 359                     ; 166              * Invalid mode.
 359                     ; 167              * Do nothing.
 359                     ; 168              */
 359                     ; 169             break;
 360  0065 4a            	dec	a
 361  0066 270e          	jreq	L511
 362  0068 4a            	dec	a
 363  0069 2716          	jreq	L711
 364  006b 4a            	dec	a
 365  006c 271f          	jreq	L121
 366  006e 4a            	dec	a
 367  006f 2728          	jreq	L321
 368  0071 4a            	dec	a
 369  0072 2731          	jreq	L521
 370  0074 2039          	jra	L551
 371  0076               L511:
 372                     ; 109         case 1:
 372                     ; 110 
 372                     ; 111             LED_Write(
 372                     ; 112                 MODE_LED1_PORT,
 372                     ; 113                 MODE_LED1_PIN,
 372                     ; 114                 state
 372                     ; 115             );
 374  0076 7b02          	ld	a,(OFST+2,sp)
 375  0078 88            	push	a
 376  0079 ae0306        	ldw	x,#774
 377  007c ad82          	call	L3_LED_Write
 379  007e 84            	pop	a
 380                     ; 117             break;
 382  007f 202e          	jra	L551
 383  0081               L711:
 384                     ; 120         case 2:
 384                     ; 121 
 384                     ; 122             LED_Write(
 384                     ; 123                 MODE_LED2_PORT,
 384                     ; 124                 MODE_LED2_PIN,
 384                     ; 125                 state
 384                     ; 126             );
 386  0081 7b02          	ld	a,(OFST+2,sp)
 387  0083 88            	push	a
 388  0084 ae0001        	ldw	x,#1
 389  0087 cd0000        	call	L3_LED_Write
 391  008a 84            	pop	a
 392                     ; 128             break;
 394  008b 2022          	jra	L551
 395  008d               L121:
 396                     ; 131         case 3:
 396                     ; 132 
 396                     ; 133             LED_Write(
 396                     ; 134                 MODE_LED3_PORT,
 396                     ; 135                 MODE_LED3_PIN,
 396                     ; 136                 state
 396                     ; 137             );
 398  008d 7b02          	ld	a,(OFST+2,sp)
 399  008f 88            	push	a
 400  0090 ae0203        	ldw	x,#515
 401  0093 cd0000        	call	L3_LED_Write
 403  0096 84            	pop	a
 404                     ; 139             break;
 406  0097 2016          	jra	L551
 407  0099               L321:
 408                     ; 142         case 4:
 408                     ; 143 
 408                     ; 144             LED_Write(
 408                     ; 145                 MODE_LED4_PORT,
 408                     ; 146                 MODE_LED4_PIN,
 408                     ; 147                 state
 408                     ; 148             );
 410  0099 7b02          	ld	a,(OFST+2,sp)
 411  009b 88            	push	a
 412  009c ae0204        	ldw	x,#516
 413  009f cd0000        	call	L3_LED_Write
 415  00a2 84            	pop	a
 416                     ; 150             break;
 418  00a3 200a          	jra	L551
 419  00a5               L521:
 420                     ; 153         case 5:
 420                     ; 154 
 420                     ; 155             LED_Write(
 420                     ; 156                 MODE_LED5_PORT,
 420                     ; 157                 MODE_LED5_PIN,
 420                     ; 158                 state
 420                     ; 159             );
 422  00a5 7b02          	ld	a,(OFST+2,sp)
 423  00a7 88            	push	a
 424  00a8 ae0205        	ldw	x,#517
 425  00ab cd0000        	call	L3_LED_Write
 427  00ae 84            	pop	a
 428                     ; 161             break;
 430  00af               L721:
 431                     ; 164         default:
 431                     ; 165             /*
 431                     ; 166              * Invalid mode.
 431                     ; 167              * Do nothing.
 431                     ; 168              */
 431                     ; 169             break;
 433  00af               L551:
 434                     ; 171 }
 437  00af 85            	popw	x
 438  00b0 81            	ret
 462                     ; 178 void LED_Mode_AllOff(void)
 462                     ; 179 {
 463                     	switch	.text
 464  00b1               _LED_Mode_AllOff:
 468                     ; 180     LED_Mode_Set(1, FALSE);
 470  00b1 ae0100        	ldw	x,#256
 471  00b4 adad          	call	_LED_Mode_Set
 473                     ; 181     LED_Mode_Set(2, FALSE);
 475  00b6 ae0200        	ldw	x,#512
 476  00b9 ada8          	call	_LED_Mode_Set
 478                     ; 182     LED_Mode_Set(3, FALSE);
 480  00bb ae0300        	ldw	x,#768
 481  00be ada3          	call	_LED_Mode_Set
 483                     ; 183     LED_Mode_Set(4, FALSE);
 485  00c0 ae0400        	ldw	x,#1024
 486  00c3 ad9e          	call	_LED_Mode_Set
 488                     ; 184     LED_Mode_Set(5, FALSE);
 490  00c5 ae0500        	ldw	x,#1280
 491  00c8 ad99          	call	_LED_Mode_Set
 493                     ; 185 }
 496  00ca 81            	ret
 532                     ; 192 void LED_Mode_Display(uint8_t mode)
 532                     ; 193 {
 533                     	switch	.text
 534  00cb               _LED_Mode_Display:
 536  00cb 88            	push	a
 537       00000000      OFST:	set	0
 540                     ; 200     LED_Mode_AllOff();
 542  00cc ade3          	call	_LED_Mode_AllOff
 544                     ; 206     LED_Mode_Set(mode, TRUE);
 546  00ce 7b01          	ld	a,(OFST+1,sp)
 547  00d0 ae0001        	ldw	x,#1
 548  00d3 95            	ld	xh,a
 549  00d4 ad8d          	call	_LED_Mode_Set
 551                     ; 207 }
 554  00d6 84            	pop	a
 555  00d7 81            	ret
 578                     ; 214 void LED_Status_Off(void)
 578                     ; 215 {
 579                     	switch	.text
 580  00d8               _LED_Status_Off:
 584                     ; 220 }
 587  00d8 81            	ret
 610                     ; 223 void LED_Status_Red(void)
 610                     ; 224 {
 611                     	switch	.text
 612  00d9               _LED_Status_Red:
 616                     ; 232 }
 619  00d9 81            	ret
 642                     ; 235 void LED_Status_Green(void)
 642                     ; 236 {
 643                     	switch	.text
 644  00da               _LED_Status_Green:
 648                     ; 244 }
 651  00da 81            	ret
 674                     ; 247 void LED_Status_Blue(void)
 674                     ; 248 {
 675                     	switch	.text
 676  00db               _LED_Status_Blue:
 680                     ; 256 }
 683  00db 81            	ret
 706                     ; 259 void LED_Status_Yellow(void)
 706                     ; 260 {
 707                     	switch	.text
 708  00dc               _LED_Status_Yellow:
 712                     ; 268 }
 715  00dc 81            	ret
 738                     ; 271 void LED_Status_Purple(void)
 738                     ; 272 {
 739                     	switch	.text
 740  00dd               _LED_Status_Purple:
 744                     ; 280 }
 747  00dd 81            	ret
 760                     	xref	_GPIO_Clear
 761                     	xref	_GPIO_Set
 762                     	xref	_GPIO_Output_PP
 763                     	xdef	_LED_Status_Purple
 764                     	xdef	_LED_Status_Yellow
 765                     	xdef	_LED_Status_Blue
 766                     	xdef	_LED_Status_Green
 767                     	xdef	_LED_Status_Red
 768                     	xdef	_LED_Status_Off
 769                     	xdef	_LED_Mode_Display
 770                     	xdef	_LED_Mode_AllOff
 771                     	xdef	_LED_Mode_Set
 772                     	xdef	_LED_Init
 791                     	end
