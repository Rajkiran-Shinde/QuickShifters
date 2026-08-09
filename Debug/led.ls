   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
 171                     ; 10 static void LED_Write(GPIO_Port port, GPIO_Pin pin, uint8_t state)
 171                     ; 11 {
 173                     	switch	.text
 174  0000               L3_LED_Write:
 176  0000 89            	pushw	x
 177       00000000      OFST:	set	0
 180                     ; 12     if(state == TRUE)
 182  0001 7b05          	ld	a,(OFST+5,sp)
 183  0003 a101          	cp	a,#1
 184  0005 260a          	jrne	L101
 185                     ; 14         GPIO_Set(port, pin);
 187  0007 9f            	ld	a,xl
 188  0008 97            	ld	xl,a
 189  0009 7b01          	ld	a,(OFST+1,sp)
 190  000b 95            	ld	xh,a
 191  000c cd0000        	call	_GPIO_Set
 194  000f 2009          	jra	L301
 195  0011               L101:
 196                     ; 18         GPIO_Clear(port, pin);
 198  0011 7b02          	ld	a,(OFST+2,sp)
 199  0013 97            	ld	xl,a
 200  0014 7b01          	ld	a,(OFST+1,sp)
 201  0016 95            	ld	xh,a
 202  0017 cd0000        	call	_GPIO_Clear
 204  001a               L301:
 205                     ; 20 }
 208  001a 85            	popw	x
 209  001b 81            	ret
 235                     ; 27 void LED_Init(void)
 235                     ; 28 {
 236                     	switch	.text
 237  001c               _LED_Init:
 241                     ; 33     GPIO_Output_PP(
 241                     ; 34         MODE_LED1_PORT,
 241                     ; 35         MODE_LED1_PIN
 241                     ; 36     );
 243  001c ae0306        	ldw	x,#774
 244  001f cd0000        	call	_GPIO_Output_PP
 246                     ; 38     LED_Write(
 246                     ; 39         MODE_LED1_PORT,
 246                     ; 40         MODE_LED1_PIN,
 246                     ; 41         FALSE
 246                     ; 42     );
 248  0022 4b00          	push	#0
 249  0024 ae0306        	ldw	x,#774
 250  0027 add7          	call	L3_LED_Write
 252  0029 84            	pop	a
 253                     ; 49     GPIO_Output_PP(
 253                     ; 50         MODE_LED2_PORT,
 253                     ; 51         MODE_LED2_PIN
 253                     ; 52     );
 255  002a ae0001        	ldw	x,#1
 256  002d cd0000        	call	_GPIO_Output_PP
 258                     ; 54     LED_Write(
 258                     ; 55         MODE_LED2_PORT,
 258                     ; 56         MODE_LED2_PIN,
 258                     ; 57         FALSE
 258                     ; 58     );
 260  0030 4b00          	push	#0
 261  0032 ae0001        	ldw	x,#1
 262  0035 adc9          	call	L3_LED_Write
 264  0037 84            	pop	a
 265                     ; 65     GPIO_Output_PP(
 265                     ; 66         MODE_LED3_PORT,
 265                     ; 67         MODE_LED3_PIN
 265                     ; 68     );
 267  0038 ae0203        	ldw	x,#515
 268  003b cd0000        	call	_GPIO_Output_PP
 270                     ; 70     LED_Write(
 270                     ; 71         MODE_LED3_PORT,
 270                     ; 72         MODE_LED3_PIN,
 270                     ; 73         FALSE
 270                     ; 74     );
 272  003e 4b00          	push	#0
 273  0040 ae0203        	ldw	x,#515
 274  0043 adbb          	call	L3_LED_Write
 276  0045 84            	pop	a
 277                     ; 81     GPIO_Output_PP(
 277                     ; 82         MODE_LED4_PORT,
 277                     ; 83         MODE_LED4_PIN
 277                     ; 84     );
 279  0046 ae0204        	ldw	x,#516
 280  0049 cd0000        	call	_GPIO_Output_PP
 282                     ; 86     LED_Write(
 282                     ; 87         MODE_LED4_PORT,
 282                     ; 88         MODE_LED4_PIN,
 282                     ; 89         FALSE
 282                     ; 90     );
 284  004c 4b00          	push	#0
 285  004e ae0204        	ldw	x,#516
 286  0051 adad          	call	L3_LED_Write
 288  0053 84            	pop	a
 289                     ; 97     GPIO_Output_PP(
 289                     ; 98         MODE_LED5_PORT,
 289                     ; 99         MODE_LED5_PIN
 289                     ; 100     );
 291  0054 ae0205        	ldw	x,#517
 292  0057 cd0000        	call	_GPIO_Output_PP
 294                     ; 102     LED_Write(
 294                     ; 103         MODE_LED5_PORT,
 294                     ; 104         MODE_LED5_PIN,
 294                     ; 105         FALSE
 294                     ; 106     );
 296  005a 4b00          	push	#0
 297  005c ae0205        	ldw	x,#517
 298  005f ad9f          	call	L3_LED_Write
 300  0061 84            	pop	a
 301                     ; 123     GPIO_Output_PP(
 301                     ; 124         STATUS_LED_R_PORT,
 301                     ; 125         STATUS_LED_R_PIN
 301                     ; 126     );
 303  0062 ae0104        	ldw	x,#260
 304  0065 cd0000        	call	_GPIO_Output_PP
 306                     ; 128     GPIO_Set(
 306                     ; 129         STATUS_LED_R_PORT,
 306                     ; 130         STATUS_LED_R_PIN
 306                     ; 131     );
 308  0068 ae0104        	ldw	x,#260
 309  006b cd0000        	call	_GPIO_Set
 311                     ; 135     GPIO_Output_PP(
 311                     ; 136         STATUS_LED_G_PORT,
 311                     ; 137         STATUS_LED_G_PIN
 311                     ; 138     );
 313  006e ae0206        	ldw	x,#518
 314  0071 cd0000        	call	_GPIO_Output_PP
 316                     ; 140     GPIO_Set(
 316                     ; 141         STATUS_LED_G_PORT,
 316                     ; 142         STATUS_LED_G_PIN
 316                     ; 143     );
 318  0074 ae0206        	ldw	x,#518
 319  0077 cd0000        	call	_GPIO_Set
 321                     ; 147     GPIO_Output_PP(
 321                     ; 148         STATUS_LED_B_PORT,
 321                     ; 149         STATUS_LED_B_PIN
 321                     ; 150     );
 323  007a ae0207        	ldw	x,#519
 324  007d cd0000        	call	_GPIO_Output_PP
 326                     ; 152     GPIO_Set(
 326                     ; 153         STATUS_LED_B_PORT,
 326                     ; 154         STATUS_LED_B_PIN
 326                     ; 155     );
 328  0080 ae0207        	ldw	x,#519
 329  0083 cd0000        	call	_GPIO_Set
 331                     ; 156 }
 334  0086 81            	ret
 378                     ; 163 void LED_Mode_Set(uint8_t mode, uint8_t state)
 378                     ; 164 {
 379                     	switch	.text
 380  0087               _LED_Mode_Set:
 382  0087 89            	pushw	x
 383       00000000      OFST:	set	0
 386                     ; 165     switch(mode)
 388  0088 9e            	ld	a,xh
 390                     ; 222         default:
 390                     ; 223 
 390                     ; 224             break;
 391  0089 4a            	dec	a
 392  008a 270e          	jreq	L511
 393  008c 4a            	dec	a
 394  008d 2717          	jreq	L711
 395  008f 4a            	dec	a
 396  0090 2720          	jreq	L121
 397  0092 4a            	dec	a
 398  0093 2729          	jreq	L321
 399  0095 4a            	dec	a
 400  0096 2732          	jreq	L521
 401  0098 203a          	jra	L551
 402  009a               L511:
 403                     ; 167         case 1:
 403                     ; 168 
 403                     ; 169             LED_Write(
 403                     ; 170                 MODE_LED1_PORT,
 403                     ; 171                 MODE_LED1_PIN,
 403                     ; 172                 state
 403                     ; 173             );
 405  009a 7b02          	ld	a,(OFST+2,sp)
 406  009c 88            	push	a
 407  009d ae0306        	ldw	x,#774
 408  00a0 cd0000        	call	L3_LED_Write
 410  00a3 84            	pop	a
 411                     ; 175             break;
 413  00a4 202e          	jra	L551
 414  00a6               L711:
 415                     ; 178         case 2:
 415                     ; 179 
 415                     ; 180             LED_Write(
 415                     ; 181                 MODE_LED2_PORT,
 415                     ; 182                 MODE_LED2_PIN,
 415                     ; 183                 state
 415                     ; 184             );
 417  00a6 7b02          	ld	a,(OFST+2,sp)
 418  00a8 88            	push	a
 419  00a9 ae0001        	ldw	x,#1
 420  00ac cd0000        	call	L3_LED_Write
 422  00af 84            	pop	a
 423                     ; 186             break;
 425  00b0 2022          	jra	L551
 426  00b2               L121:
 427                     ; 189         case 3:
 427                     ; 190 
 427                     ; 191             LED_Write(
 427                     ; 192                 MODE_LED3_PORT,
 427                     ; 193                 MODE_LED3_PIN,
 427                     ; 194                 state
 427                     ; 195             );
 429  00b2 7b02          	ld	a,(OFST+2,sp)
 430  00b4 88            	push	a
 431  00b5 ae0203        	ldw	x,#515
 432  00b8 cd0000        	call	L3_LED_Write
 434  00bb 84            	pop	a
 435                     ; 197             break;
 437  00bc 2016          	jra	L551
 438  00be               L321:
 439                     ; 200         case 4:
 439                     ; 201 
 439                     ; 202             LED_Write(
 439                     ; 203                 MODE_LED4_PORT,
 439                     ; 204                 MODE_LED4_PIN,
 439                     ; 205                 state
 439                     ; 206             );
 441  00be 7b02          	ld	a,(OFST+2,sp)
 442  00c0 88            	push	a
 443  00c1 ae0204        	ldw	x,#516
 444  00c4 cd0000        	call	L3_LED_Write
 446  00c7 84            	pop	a
 447                     ; 208             break;
 449  00c8 200a          	jra	L551
 450  00ca               L521:
 451                     ; 211         case 5:
 451                     ; 212 
 451                     ; 213             LED_Write(
 451                     ; 214                 MODE_LED5_PORT,
 451                     ; 215                 MODE_LED5_PIN,
 451                     ; 216                 state
 451                     ; 217             );
 453  00ca 7b02          	ld	a,(OFST+2,sp)
 454  00cc 88            	push	a
 455  00cd ae0205        	ldw	x,#517
 456  00d0 cd0000        	call	L3_LED_Write
 458  00d3 84            	pop	a
 459                     ; 219             break;
 461  00d4               L721:
 462                     ; 222         default:
 462                     ; 223 
 462                     ; 224             break;
 464  00d4               L551:
 465                     ; 226 }
 468  00d4 85            	popw	x
 469  00d5 81            	ret
 493                     ; 233 void LED_Mode_AllOff(void)
 493                     ; 234 {
 494                     	switch	.text
 495  00d6               _LED_Mode_AllOff:
 499                     ; 235     LED_Mode_Set(1, FALSE);
 501  00d6 ae0100        	ldw	x,#256
 502  00d9 adac          	call	_LED_Mode_Set
 504                     ; 236     LED_Mode_Set(2, FALSE);
 506  00db ae0200        	ldw	x,#512
 507  00de ada7          	call	_LED_Mode_Set
 509                     ; 237     LED_Mode_Set(3, FALSE);
 511  00e0 ae0300        	ldw	x,#768
 512  00e3 ada2          	call	_LED_Mode_Set
 514                     ; 238     LED_Mode_Set(4, FALSE);
 516  00e5 ae0400        	ldw	x,#1024
 517  00e8 ad9d          	call	_LED_Mode_Set
 519                     ; 239     LED_Mode_Set(5, FALSE);
 521  00ea ae0500        	ldw	x,#1280
 522  00ed ad98          	call	_LED_Mode_Set
 524                     ; 240 }
 527  00ef 81            	ret
 563                     ; 247 void LED_Mode_Display(uint8_t mode)
 563                     ; 248 {
 564                     	switch	.text
 565  00f0               _LED_Mode_Display:
 567  00f0 88            	push	a
 568       00000000      OFST:	set	0
 571                     ; 252     LED_Mode_AllOff();
 573  00f1 ade3          	call	_LED_Mode_AllOff
 575                     ; 258     LED_Mode_Set(mode, TRUE);
 577  00f3 7b01          	ld	a,(OFST+1,sp)
 578  00f5 ae0001        	ldw	x,#1
 579  00f8 95            	ld	xh,a
 580  00f9 ad8c          	call	_LED_Mode_Set
 582                     ; 259 }
 585  00fb 84            	pop	a
 586  00fc 81            	ret
 610                     ; 277 void LED_Status_Off(void)
 610                     ; 278 {
 611                     	switch	.text
 612  00fd               _LED_Status_Off:
 616                     ; 282     GPIO_Set(
 616                     ; 283         STATUS_LED_R_PORT,
 616                     ; 284         STATUS_LED_R_PIN
 616                     ; 285     );
 618  00fd ae0104        	ldw	x,#260
 619  0100 cd0000        	call	_GPIO_Set
 621                     ; 291     GPIO_Set(
 621                     ; 292         STATUS_LED_G_PORT,
 621                     ; 293         STATUS_LED_G_PIN
 621                     ; 294     );
 623  0103 ae0206        	ldw	x,#518
 624  0106 cd0000        	call	_GPIO_Set
 626                     ; 300     GPIO_Set(
 626                     ; 301         STATUS_LED_B_PORT,
 626                     ; 302         STATUS_LED_B_PIN
 626                     ; 303     );
 628  0109 ae0207        	ldw	x,#519
 629  010c cd0000        	call	_GPIO_Set
 631                     ; 304 }
 634  010f 81            	ret
 659                     ; 311 void LED_Status_Red(void)
 659                     ; 312 {
 660                     	switch	.text
 661  0110               _LED_Status_Red:
 665                     ; 316     GPIO_Clear(
 665                     ; 317         STATUS_LED_R_PORT,
 665                     ; 318         STATUS_LED_R_PIN
 665                     ; 319     );
 667  0110 ae0104        	ldw	x,#260
 668  0113 cd0000        	call	_GPIO_Clear
 670                     ; 325     GPIO_Set(
 670                     ; 326         STATUS_LED_G_PORT,
 670                     ; 327         STATUS_LED_G_PIN
 670                     ; 328     );
 672  0116 ae0206        	ldw	x,#518
 673  0119 cd0000        	call	_GPIO_Set
 675                     ; 334     GPIO_Set(
 675                     ; 335         STATUS_LED_B_PORT,
 675                     ; 336         STATUS_LED_B_PIN
 675                     ; 337     );
 677  011c ae0207        	ldw	x,#519
 678  011f cd0000        	call	_GPIO_Set
 680                     ; 338 }
 683  0122 81            	ret
 708                     ; 345 void LED_Status_Green(void)
 708                     ; 346 {
 709                     	switch	.text
 710  0123               _LED_Status_Green:
 714                     ; 350     GPIO_Set(
 714                     ; 351         STATUS_LED_R_PORT,
 714                     ; 352         STATUS_LED_R_PIN
 714                     ; 353     );
 716  0123 ae0104        	ldw	x,#260
 717  0126 cd0000        	call	_GPIO_Set
 719                     ; 359     GPIO_Clear(
 719                     ; 360         STATUS_LED_G_PORT,
 719                     ; 361         STATUS_LED_G_PIN
 719                     ; 362     );
 721  0129 ae0206        	ldw	x,#518
 722  012c cd0000        	call	_GPIO_Clear
 724                     ; 368     GPIO_Set(
 724                     ; 369         STATUS_LED_B_PORT,
 724                     ; 370         STATUS_LED_B_PIN
 724                     ; 371     );
 726  012f ae0207        	ldw	x,#519
 727  0132 cd0000        	call	_GPIO_Set
 729                     ; 372 }
 732  0135 81            	ret
 757                     ; 379 void LED_Status_Blue(void)
 757                     ; 380 {
 758                     	switch	.text
 759  0136               _LED_Status_Blue:
 763                     ; 384     GPIO_Set(
 763                     ; 385         STATUS_LED_R_PORT,
 763                     ; 386         STATUS_LED_R_PIN
 763                     ; 387     );
 765  0136 ae0104        	ldw	x,#260
 766  0139 cd0000        	call	_GPIO_Set
 768                     ; 393     GPIO_Set(
 768                     ; 394         STATUS_LED_G_PORT,
 768                     ; 395         STATUS_LED_G_PIN
 768                     ; 396     );
 770  013c ae0206        	ldw	x,#518
 771  013f cd0000        	call	_GPIO_Set
 773                     ; 402     GPIO_Clear(
 773                     ; 403         STATUS_LED_B_PORT,
 773                     ; 404         STATUS_LED_B_PIN
 773                     ; 405     );
 775  0142 ae0207        	ldw	x,#519
 776  0145 cd0000        	call	_GPIO_Clear
 778                     ; 406 }
 781  0148 81            	ret
 806                     ; 413 void LED_Status_Yellow(void)
 806                     ; 414 {
 807                     	switch	.text
 808  0149               _LED_Status_Yellow:
 812                     ; 418     GPIO_Clear(
 812                     ; 419         STATUS_LED_R_PORT,
 812                     ; 420         STATUS_LED_R_PIN
 812                     ; 421     );
 814  0149 ae0104        	ldw	x,#260
 815  014c cd0000        	call	_GPIO_Clear
 817                     ; 427     GPIO_Clear(
 817                     ; 428         STATUS_LED_G_PORT,
 817                     ; 429         STATUS_LED_G_PIN
 817                     ; 430     );
 819  014f ae0206        	ldw	x,#518
 820  0152 cd0000        	call	_GPIO_Clear
 822                     ; 436     GPIO_Set(
 822                     ; 437         STATUS_LED_B_PORT,
 822                     ; 438         STATUS_LED_B_PIN
 822                     ; 439     );
 824  0155 ae0207        	ldw	x,#519
 825  0158 cd0000        	call	_GPIO_Set
 827                     ; 440 }
 830  015b 81            	ret
 855                     ; 447 void LED_Status_Purple(void)
 855                     ; 448 {
 856                     	switch	.text
 857  015c               _LED_Status_Purple:
 861                     ; 452     GPIO_Clear(
 861                     ; 453         STATUS_LED_R_PORT,
 861                     ; 454         STATUS_LED_R_PIN
 861                     ; 455     );
 863  015c ae0104        	ldw	x,#260
 864  015f cd0000        	call	_GPIO_Clear
 866                     ; 461     GPIO_Set(
 866                     ; 462         STATUS_LED_G_PORT,
 866                     ; 463         STATUS_LED_G_PIN
 866                     ; 464     );
 868  0162 ae0206        	ldw	x,#518
 869  0165 cd0000        	call	_GPIO_Set
 871                     ; 470     GPIO_Clear(
 871                     ; 471         STATUS_LED_B_PORT,
 871                     ; 472         STATUS_LED_B_PIN
 871                     ; 473     );
 873  0168 ae0207        	ldw	x,#519
 874  016b cd0000        	call	_GPIO_Clear
 876                     ; 474 }
 879  016e 81            	ret
 892                     	xref	_GPIO_Clear
 893                     	xref	_GPIO_Set
 894                     	xref	_GPIO_Output_PP
 895                     	xdef	_LED_Status_Purple
 896                     	xdef	_LED_Status_Yellow
 897                     	xdef	_LED_Status_Blue
 898                     	xdef	_LED_Status_Green
 899                     	xdef	_LED_Status_Red
 900                     	xdef	_LED_Status_Off
 901                     	xdef	_LED_Mode_Display
 902                     	xdef	_LED_Mode_AllOff
 903                     	xdef	_LED_Mode_Set
 904                     	xdef	_LED_Init
 923                     	end
