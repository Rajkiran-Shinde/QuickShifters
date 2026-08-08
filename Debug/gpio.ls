   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  89                     ; 42 static volatile uint8_t* GPIO_Get_ODR(GPIO_Port port)
  89                     ; 43 {
  91                     	switch	.text
  92  0000               L3_GPIO_Get_ODR:
  96                     ; 44     switch(port)
  99                     ; 58         default:
  99                     ; 59             return &PD_ODR;
 100  0000 4d            	tnz	a
 101  0001 270d          	jreq	L5
 102  0003 4a            	dec	a
 103  0004 270e          	jreq	L7
 104  0006 4a            	dec	a
 105  0007 270f          	jreq	L11
 106  0009 4a            	dec	a
 107  000a 2710          	jreq	L31
 108  000c               L51:
 111  000c ae500f        	ldw	x,#20495
 114  000f 81            	ret
 115  0010               L5:
 116                     ; 46         case PORT_A:
 116                     ; 47             return &PA_ODR;
 118  0010 ae5000        	ldw	x,#20480
 121  0013 81            	ret
 122  0014               L7:
 123                     ; 49         case PORT_B:
 123                     ; 50             return &PB_ODR;
 125  0014 ae5005        	ldw	x,#20485
 128  0017 81            	ret
 129  0018               L11:
 130                     ; 52         case PORT_C:
 130                     ; 53             return &PC_ODR;
 132  0018 ae500a        	ldw	x,#20490
 135  001b 81            	ret
 136  001c               L31:
 137                     ; 55         case PORT_D:
 137                     ; 56             return &PD_ODR;
 139  001c ae500f        	ldw	x,#20495
 142  001f 81            	ret
 178                     ; 64 static volatile uint8_t* GPIO_Get_IDR(GPIO_Port port)
 178                     ; 65 {
 179                     	switch	.text
 180  0020               L36_GPIO_Get_IDR:
 184                     ; 66     switch(port)
 187                     ; 80         default:
 187                     ; 81             return &PD_IDR;
 188  0020 4d            	tnz	a
 189  0021 270d          	jreq	L56
 190  0023 4a            	dec	a
 191  0024 270e          	jreq	L76
 192  0026 4a            	dec	a
 193  0027 270f          	jreq	L17
 194  0029 4a            	dec	a
 195  002a 2710          	jreq	L37
 196  002c               L57:
 199  002c ae5010        	ldw	x,#20496
 202  002f 81            	ret
 203  0030               L56:
 204                     ; 68         case PORT_A:
 204                     ; 69             return &PA_IDR;
 206  0030 ae5001        	ldw	x,#20481
 209  0033 81            	ret
 210  0034               L76:
 211                     ; 71         case PORT_B:
 211                     ; 72             return &PB_IDR;
 213  0034 ae5006        	ldw	x,#20486
 216  0037 81            	ret
 217  0038               L17:
 218                     ; 74         case PORT_C:
 218                     ; 75             return &PC_IDR;
 220  0038 ae500b        	ldw	x,#20491
 223  003b 81            	ret
 224  003c               L37:
 225                     ; 77         case PORT_D:
 225                     ; 78             return &PD_IDR;
 227  003c ae5010        	ldw	x,#20496
 230  003f 81            	ret
 266                     ; 86 static volatile uint8_t* GPIO_Get_DDR(GPIO_Port port)
 266                     ; 87 {
 267                     	switch	.text
 268  0040               L121_GPIO_Get_DDR:
 272                     ; 88     switch(port)
 275                     ; 102         default:
 275                     ; 103             return &PD_DDR;
 276  0040 4d            	tnz	a
 277  0041 270d          	jreq	L321
 278  0043 4a            	dec	a
 279  0044 270e          	jreq	L521
 280  0046 4a            	dec	a
 281  0047 270f          	jreq	L721
 282  0049 4a            	dec	a
 283  004a 2710          	jreq	L131
 284  004c               L331:
 287  004c ae5011        	ldw	x,#20497
 290  004f 81            	ret
 291  0050               L321:
 292                     ; 90         case PORT_A:
 292                     ; 91             return &PA_DDR;
 294  0050 ae5002        	ldw	x,#20482
 297  0053 81            	ret
 298  0054               L521:
 299                     ; 93         case PORT_B:
 299                     ; 94             return &PB_DDR;
 301  0054 ae5007        	ldw	x,#20487
 304  0057 81            	ret
 305  0058               L721:
 306                     ; 96         case PORT_C:
 306                     ; 97             return &PC_DDR;
 308  0058 ae500c        	ldw	x,#20492
 311  005b 81            	ret
 312  005c               L131:
 313                     ; 99         case PORT_D:
 313                     ; 100             return &PD_DDR;
 315  005c ae5011        	ldw	x,#20497
 318  005f 81            	ret
 354                     ; 108 static volatile uint8_t* GPIO_Get_CR1(GPIO_Port port)
 354                     ; 109 {
 355                     	switch	.text
 356  0060               L751_GPIO_Get_CR1:
 360                     ; 110     switch(port)
 363                     ; 124         default:
 363                     ; 125             return &PD_CR1;
 364  0060 4d            	tnz	a
 365  0061 270d          	jreq	L161
 366  0063 4a            	dec	a
 367  0064 270e          	jreq	L361
 368  0066 4a            	dec	a
 369  0067 270f          	jreq	L561
 370  0069 4a            	dec	a
 371  006a 2710          	jreq	L761
 372  006c               L171:
 375  006c ae5012        	ldw	x,#20498
 378  006f 81            	ret
 379  0070               L161:
 380                     ; 112         case PORT_A:
 380                     ; 113             return &PA_CR1;
 382  0070 ae5003        	ldw	x,#20483
 385  0073 81            	ret
 386  0074               L361:
 387                     ; 115         case PORT_B:
 387                     ; 116             return &PB_CR1;
 389  0074 ae5008        	ldw	x,#20488
 392  0077 81            	ret
 393  0078               L561:
 394                     ; 118         case PORT_C:
 394                     ; 119             return &PC_CR1;
 396  0078 ae500d        	ldw	x,#20493
 399  007b 81            	ret
 400  007c               L761:
 401                     ; 121         case PORT_D:
 401                     ; 122             return &PD_CR1;
 403  007c ae5012        	ldw	x,#20498
 406  007f 81            	ret
 442                     ; 130 static volatile uint8_t* GPIO_Get_CR2(GPIO_Port port)
 442                     ; 131 {
 443                     	switch	.text
 444  0080               L512_GPIO_Get_CR2:
 448                     ; 132     switch(port)
 451                     ; 146         default:
 451                     ; 147             return &PD_CR2;
 452  0080 4d            	tnz	a
 453  0081 270d          	jreq	L712
 454  0083 4a            	dec	a
 455  0084 270e          	jreq	L122
 456  0086 4a            	dec	a
 457  0087 270f          	jreq	L322
 458  0089 4a            	dec	a
 459  008a 2710          	jreq	L522
 460  008c               L722:
 463  008c ae5013        	ldw	x,#20499
 466  008f 81            	ret
 467  0090               L712:
 468                     ; 134         case PORT_A:
 468                     ; 135             return &PA_CR2;
 470  0090 ae5004        	ldw	x,#20484
 473  0093 81            	ret
 474  0094               L122:
 475                     ; 137         case PORT_B:
 475                     ; 138             return &PB_CR2;
 477  0094 ae5009        	ldw	x,#20489
 480  0097 81            	ret
 481  0098               L322:
 482                     ; 140         case PORT_C:
 482                     ; 141             return &PC_CR2;
 484  0098 ae500e        	ldw	x,#20494
 487  009b 81            	ret
 488  009c               L522:
 489                     ; 143         case PORT_D:
 489                     ; 144             return &PD_CR2;
 491  009c ae5013        	ldw	x,#20499
 494  009f 81            	ret
 634                     ; 156 void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin)
 634                     ; 157 {
 635                     	switch	.text
 636  00a0               _GPIO_Output_PP:
 638  00a0 89            	pushw	x
 639  00a1 5206          	subw	sp,#6
 640       00000006      OFST:	set	6
 643                     ; 162     ddr = GPIO_Get_DDR(port);
 645  00a3 9e            	ld	a,xh
 646  00a4 ad9a          	call	L121_GPIO_Get_DDR
 648  00a6 1f01          	ldw	(OFST-5,sp),x
 650                     ; 163     cr1 = GPIO_Get_CR1(port);
 652  00a8 7b07          	ld	a,(OFST+1,sp)
 653  00aa adb4          	call	L751_GPIO_Get_CR1
 655  00ac 1f03          	ldw	(OFST-3,sp),x
 657                     ; 164     cr2 = GPIO_Get_CR2(port);
 659  00ae 7b07          	ld	a,(OFST+1,sp)
 660  00b0 adce          	call	L512_GPIO_Get_CR2
 662  00b2 1f05          	ldw	(OFST-1,sp),x
 664                     ; 167     *ddr |= (1 << pin);
 666  00b4 1e01          	ldw	x,(OFST-5,sp)
 667  00b6 7b08          	ld	a,(OFST+2,sp)
 668  00b8 905f          	clrw	y
 669  00ba 9097          	ld	yl,a
 670  00bc a601          	ld	a,#1
 671  00be 905d          	tnzw	y
 672  00c0 2705          	jreq	L02
 673  00c2               L22:
 674  00c2 48            	sll	a
 675  00c3 905a          	decw	y
 676  00c5 26fb          	jrne	L22
 677  00c7               L02:
 678  00c7 fa            	or	a,(x)
 679  00c8 f7            	ld	(x),a
 680                     ; 170     *cr1 |= (1 << pin);
 682  00c9 1e03          	ldw	x,(OFST-3,sp)
 683  00cb 7b08          	ld	a,(OFST+2,sp)
 684  00cd 905f          	clrw	y
 685  00cf 9097          	ld	yl,a
 686  00d1 a601          	ld	a,#1
 687  00d3 905d          	tnzw	y
 688  00d5 2705          	jreq	L42
 689  00d7               L62:
 690  00d7 48            	sll	a
 691  00d8 905a          	decw	y
 692  00da 26fb          	jrne	L62
 693  00dc               L42:
 694  00dc fa            	or	a,(x)
 695  00dd f7            	ld	(x),a
 696                     ; 173     *cr2 &= ~(1 << pin);
 698  00de 1e05          	ldw	x,(OFST-1,sp)
 699  00e0 7b08          	ld	a,(OFST+2,sp)
 700  00e2 905f          	clrw	y
 701  00e4 9097          	ld	yl,a
 702  00e6 a601          	ld	a,#1
 703  00e8 905d          	tnzw	y
 704  00ea 2705          	jreq	L03
 705  00ec               L23:
 706  00ec 48            	sll	a
 707  00ed 905a          	decw	y
 708  00ef 26fb          	jrne	L23
 709  00f1               L03:
 710  00f1 43            	cpl	a
 711  00f2 f4            	and	a,(x)
 712  00f3 f7            	ld	(x),a
 713                     ; 174 }
 716  00f4 5b08          	addw	sp,#8
 717  00f6 81            	ret
 795                     ; 181 void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin)
 795                     ; 182 {
 796                     	switch	.text
 797  00f7               _GPIO_Input_PU:
 799  00f7 89            	pushw	x
 800  00f8 5206          	subw	sp,#6
 801       00000006      OFST:	set	6
 804                     ; 187     ddr = GPIO_Get_DDR(port);
 806  00fa 9e            	ld	a,xh
 807  00fb cd0040        	call	L121_GPIO_Get_DDR
 809  00fe 1f01          	ldw	(OFST-5,sp),x
 811                     ; 188     cr1 = GPIO_Get_CR1(port);
 813  0100 7b07          	ld	a,(OFST+1,sp)
 814  0102 cd0060        	call	L751_GPIO_Get_CR1
 816  0105 1f03          	ldw	(OFST-3,sp),x
 818                     ; 189     cr2 = GPIO_Get_CR2(port);
 820  0107 7b07          	ld	a,(OFST+1,sp)
 821  0109 cd0080        	call	L512_GPIO_Get_CR2
 823  010c 1f05          	ldw	(OFST-1,sp),x
 825                     ; 192     *ddr &= ~(1 << pin);
 827  010e 1e01          	ldw	x,(OFST-5,sp)
 828  0110 7b08          	ld	a,(OFST+2,sp)
 829  0112 905f          	clrw	y
 830  0114 9097          	ld	yl,a
 831  0116 a601          	ld	a,#1
 832  0118 905d          	tnzw	y
 833  011a 2705          	jreq	L63
 834  011c               L04:
 835  011c 48            	sll	a
 836  011d 905a          	decw	y
 837  011f 26fb          	jrne	L04
 838  0121               L63:
 839  0121 43            	cpl	a
 840  0122 f4            	and	a,(x)
 841  0123 f7            	ld	(x),a
 842                     ; 195     *cr1 |= (1 << pin);
 844  0124 1e03          	ldw	x,(OFST-3,sp)
 845  0126 7b08          	ld	a,(OFST+2,sp)
 846  0128 905f          	clrw	y
 847  012a 9097          	ld	yl,a
 848  012c a601          	ld	a,#1
 849  012e 905d          	tnzw	y
 850  0130 2705          	jreq	L24
 851  0132               L44:
 852  0132 48            	sll	a
 853  0133 905a          	decw	y
 854  0135 26fb          	jrne	L44
 855  0137               L24:
 856  0137 fa            	or	a,(x)
 857  0138 f7            	ld	(x),a
 858                     ; 198     *cr2 &= ~(1 << pin);
 860  0139 1e05          	ldw	x,(OFST-1,sp)
 861  013b 7b08          	ld	a,(OFST+2,sp)
 862  013d 905f          	clrw	y
 863  013f 9097          	ld	yl,a
 864  0141 a601          	ld	a,#1
 865  0143 905d          	tnzw	y
 866  0145 2705          	jreq	L64
 867  0147               L05:
 868  0147 48            	sll	a
 869  0148 905a          	decw	y
 870  014a 26fb          	jrne	L05
 871  014c               L64:
 872  014c 43            	cpl	a
 873  014d f4            	and	a,(x)
 874  014e f7            	ld	(x),a
 875                     ; 199 }
 878  014f 5b08          	addw	sp,#8
 879  0151 81            	ret
 935                     ; 206 void GPIO_Set(GPIO_Port port, GPIO_Pin pin)
 935                     ; 207 {
 936                     	switch	.text
 937  0152               _GPIO_Set:
 939  0152 89            	pushw	x
 940  0153 89            	pushw	x
 941       00000002      OFST:	set	2
 944                     ; 210     odr = GPIO_Get_ODR(port);
 946  0154 9e            	ld	a,xh
 947  0155 cd0000        	call	L3_GPIO_Get_ODR
 949  0158 1f01          	ldw	(OFST-1,sp),x
 951                     ; 212     *odr |= (1 << pin);
 953  015a 1e01          	ldw	x,(OFST-1,sp)
 954  015c 7b04          	ld	a,(OFST+2,sp)
 955  015e 905f          	clrw	y
 956  0160 9097          	ld	yl,a
 957  0162 a601          	ld	a,#1
 958  0164 905d          	tnzw	y
 959  0166 2705          	jreq	L45
 960  0168               L65:
 961  0168 48            	sll	a
 962  0169 905a          	decw	y
 963  016b 26fb          	jrne	L65
 964  016d               L45:
 965  016d fa            	or	a,(x)
 966  016e f7            	ld	(x),a
 967                     ; 213 }
 970  016f 5b04          	addw	sp,#4
 971  0171 81            	ret
1027                     ; 220 void GPIO_Clear(GPIO_Port port, GPIO_Pin pin)
1027                     ; 221 {
1028                     	switch	.text
1029  0172               _GPIO_Clear:
1031  0172 89            	pushw	x
1032  0173 89            	pushw	x
1033       00000002      OFST:	set	2
1036                     ; 224     odr = GPIO_Get_ODR(port);
1038  0174 9e            	ld	a,xh
1039  0175 cd0000        	call	L3_GPIO_Get_ODR
1041  0178 1f01          	ldw	(OFST-1,sp),x
1043                     ; 226     *odr &= ~(1 << pin);
1045  017a 1e01          	ldw	x,(OFST-1,sp)
1046  017c 7b04          	ld	a,(OFST+2,sp)
1047  017e 905f          	clrw	y
1048  0180 9097          	ld	yl,a
1049  0182 a601          	ld	a,#1
1050  0184 905d          	tnzw	y
1051  0186 2705          	jreq	L26
1052  0188               L46:
1053  0188 48            	sll	a
1054  0189 905a          	decw	y
1055  018b 26fb          	jrne	L46
1056  018d               L26:
1057  018d 43            	cpl	a
1058  018e f4            	and	a,(x)
1059  018f f7            	ld	(x),a
1060                     ; 227 }
1063  0190 5b04          	addw	sp,#4
1064  0192 81            	ret
1120                     ; 234 void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin)
1120                     ; 235 {
1121                     	switch	.text
1122  0193               _GPIO_Toggle:
1124  0193 89            	pushw	x
1125  0194 89            	pushw	x
1126       00000002      OFST:	set	2
1129                     ; 238     odr = GPIO_Get_ODR(port);
1131  0195 9e            	ld	a,xh
1132  0196 cd0000        	call	L3_GPIO_Get_ODR
1134  0199 1f01          	ldw	(OFST-1,sp),x
1136                     ; 240     *odr ^= (1 << pin);
1138  019b 1e01          	ldw	x,(OFST-1,sp)
1139  019d 7b04          	ld	a,(OFST+2,sp)
1140  019f 905f          	clrw	y
1141  01a1 9097          	ld	yl,a
1142  01a3 a601          	ld	a,#1
1143  01a5 905d          	tnzw	y
1144  01a7 2705          	jreq	L07
1145  01a9               L27:
1146  01a9 48            	sll	a
1147  01aa 905a          	decw	y
1148  01ac 26fb          	jrne	L27
1149  01ae               L07:
1150  01ae f8            	xor	a,(x)
1151  01af f7            	ld	(x),a
1152                     ; 241 }
1155  01b0 5b04          	addw	sp,#4
1156  01b2 81            	ret
1212                     ; 248 uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin)
1212                     ; 249 {
1213                     	switch	.text
1214  01b3               _GPIO_Read:
1216  01b3 89            	pushw	x
1217  01b4 5204          	subw	sp,#4
1218       00000004      OFST:	set	4
1221                     ; 252     idr = GPIO_Get_IDR(port);
1223  01b6 9e            	ld	a,xh
1224  01b7 cd0020        	call	L36_GPIO_Get_IDR
1226  01ba 1f03          	ldw	(OFST-1,sp),x
1228                     ; 254     return (*idr & (1 << pin)) ? TRUE : FALSE;
1230  01bc 1e03          	ldw	x,(OFST-1,sp)
1231  01be f6            	ld	a,(x)
1232  01bf 5f            	clrw	x
1233  01c0 97            	ld	xl,a
1234  01c1 1f01          	ldw	(OFST-3,sp),x
1236  01c3 ae0001        	ldw	x,#1
1237  01c6 7b06          	ld	a,(OFST+2,sp)
1238  01c8 4d            	tnz	a
1239  01c9 2704          	jreq	L001
1240  01cb               L201:
1241  01cb 58            	sllw	x
1242  01cc 4a            	dec	a
1243  01cd 26fc          	jrne	L201
1244  01cf               L001:
1245  01cf 01            	rrwa	x,a
1246  01d0 1402          	and	a,(OFST-2,sp)
1247  01d2 01            	rrwa	x,a
1248  01d3 1401          	and	a,(OFST-3,sp)
1249  01d5 01            	rrwa	x,a
1250  01d6 a30000        	cpw	x,#0
1251  01d9 2704          	jreq	L67
1252  01db a601          	ld	a,#1
1253  01dd 2001          	jra	L401
1254  01df               L67:
1255  01df 4f            	clr	a
1256  01e0               L401:
1259  01e0 5b06          	addw	sp,#6
1260  01e2 81            	ret
1273                     	xdef	_GPIO_Read
1274                     	xdef	_GPIO_Toggle
1275                     	xdef	_GPIO_Clear
1276                     	xdef	_GPIO_Set
1277                     	xdef	_GPIO_Input_PU
1278                     	xdef	_GPIO_Output_PP
1297                     	end
