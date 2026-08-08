   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 31 static void EEPROM_Unlock(void)
  42                     ; 32 {
  44                     	switch	.text
  45  0000               L3_EEPROM_Unlock:
  49                     ; 33     if((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
  51  0000 c6505f        	ld	a,20575
  52  0003 a508          	bcp	a,#8
  53  0005 260f          	jrne	L32
  54                     ; 35         FLASH_DUKR = 0xAE;
  56  0007 35ae5064      	mov	20580,#174
  57                     ; 36         FLASH_DUKR = 0x56;
  59  000b 35565064      	mov	20580,#86
  61  000f               L13:
  62                     ; 42         while((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
  64  000f c6505f        	ld	a,20575
  65  0012 a508          	bcp	a,#8
  66  0014 27f9          	jreq	L13
  67  0016               L32:
  68                     ; 47 }
  71  0016 81            	ret
 106                     ; 57 static uint8_t EEPROM_CalculateChecksum(uint8_t mode)
 106                     ; 58 {
 107                     	switch	.text
 108  0017               L53_EEPROM_CalculateChecksum:
 112                     ; 59     return (uint8_t)(EEPROM_MAGIC ^ mode ^ 0x5A);
 114  0017 a8a5          	xor	a,#165
 115  0019 a85a          	xor	a,#90
 118  001b 81            	ret
 141                     ; 66 void EEPROM_Init(void)
 141                     ; 67 {
 142                     	switch	.text
 143  001c               _EEPROM_Init:
 147                     ; 69 }
 150  001c 81            	ret
 193                     ; 75 uint8_t EEPROM_ReadByte(uint16_t address)
 193                     ; 76 {
 194                     	switch	.text
 195  001d               _EEPROM_ReadByte:
 197  001d 88            	push	a
 198       00000001      OFST:	set	1
 201                     ; 79     value = (*(volatile uint8_t*)address);
 203  001e f6            	ld	a,(x)
 204  001f 6b01          	ld	(OFST+0,sp),a
 206                     ; 81     return value;
 208  0021 7b01          	ld	a,(OFST+0,sp)
 211  0023 5b01          	addw	sp,#1
 212  0025 81            	ret
 256                     ; 87 uint8_t EEPROM_WriteByte(uint16_t address, uint8_t value)
 256                     ; 88 {
 257                     	switch	.text
 258  0026               _EEPROM_WriteByte:
 260  0026 89            	pushw	x
 261       00000000      OFST:	set	0
 264                     ; 89     EEPROM_Unlock();
 266  0027 add7          	call	L3_EEPROM_Unlock
 268                     ; 97     (*(volatile uint8_t*)address) = value;
 270  0029 7b05          	ld	a,(OFST+5,sp)
 271  002b 1e01          	ldw	x,(OFST+1,sp)
 272  002d f7            	ld	(x),a
 274  002e               L531:
 275                     ; 102     while((FLASH_IAPSR & FLASH_IAPSR_EOP) == 0)
 277  002e c6505f        	ld	a,20575
 278  0031 a504          	bcp	a,#4
 279  0033 27f9          	jreq	L531
 280                     ; 107     return TRUE;
 282  0035 a601          	ld	a,#1
 285  0037 85            	popw	x
 286  0038 81            	ret
 352                     ; 125 uint8_t EEPROM_LoadMode(void)
 352                     ; 126 {
 353                     	switch	.text
 354  0039               _EEPROM_LoadMode:
 356  0039 5203          	subw	sp,#3
 357       00000003      OFST:	set	3
 360                     ; 132     Debug_Log("[EEPROM] Loading configuration...\r\n");
 362  003b ae0357        	ldw	x,#L371
 363  003e cd0000        	call	_Debug_Log
 365                     ; 134     magic = EEPROM_ReadByte(EEPROM_MAGIC_ADDRESS);
 367  0041 ae4000        	ldw	x,#16384
 368  0044 add7          	call	_EEPROM_ReadByte
 370  0046 6b03          	ld	(OFST+0,sp),a
 372                     ; 135     mode = EEPROM_ReadByte(EEPROM_MODE_ADDRESS);
 374  0048 ae4001        	ldw	x,#16385
 375  004b add0          	call	_EEPROM_ReadByte
 377  004d 6b02          	ld	(OFST-1,sp),a
 379                     ; 136     checksum = EEPROM_ReadByte(EEPROM_CHECKSUM_ADDRESS);
 381  004f ae4002        	ldw	x,#16386
 382  0052 adc9          	call	_EEPROM_ReadByte
 384  0054 6b01          	ld	(OFST-2,sp),a
 386                     ; 138     Debug_Log("[EEPROM] Magic: 0x");
 388  0056 ae0344        	ldw	x,#L571
 389  0059 cd0000        	call	_Debug_Log
 391                     ; 139     Debug_LogHex(magic);
 393  005c 7b03          	ld	a,(OFST+0,sp)
 394  005e cd0000        	call	_Debug_LogHex
 396                     ; 140     Debug_Log("\r\n");
 398  0061 ae0341        	ldw	x,#L771
 399  0064 cd0000        	call	_Debug_Log
 401                     ; 142     Debug_Log("[EEPROM] Mode: ");
 403  0067 ae0331        	ldw	x,#L102
 404  006a cd0000        	call	_Debug_Log
 406                     ; 143     Debug_LogDecimal(mode);
 408  006d 7b02          	ld	a,(OFST-1,sp)
 409  006f cd0000        	call	_Debug_LogDecimal
 411                     ; 144     Debug_Log("\r\n");
 413  0072 ae0341        	ldw	x,#L771
 414  0075 cd0000        	call	_Debug_Log
 416                     ; 146     Debug_Log("[EEPROM] Checksum: 0x");
 418  0078 ae031b        	ldw	x,#L302
 419  007b cd0000        	call	_Debug_Log
 421                     ; 147     Debug_LogHex(checksum);
 423  007e 7b01          	ld	a,(OFST-2,sp)
 424  0080 cd0000        	call	_Debug_LogHex
 426                     ; 148     Debug_Log("\r\n");
 428  0083 ae0341        	ldw	x,#L771
 429  0086 cd0000        	call	_Debug_Log
 431                     ; 154     if(magic != EEPROM_MAGIC)
 433  0089 7b03          	ld	a,(OFST+0,sp)
 434  008b a1a5          	cp	a,#165
 435  008d 2715          	jreq	L502
 436                     ; 156         Debug_Log("[EEPROM] ERROR: Invalid magic number\r\n");
 438  008f ae02f4        	ldw	x,#L702
 439  0092 cd0000        	call	_Debug_Log
 441                     ; 157         Debug_Log("[EEPROM] No valid configuration found\r\n");
 443  0095 ae02cc        	ldw	x,#L112
 444  0098 cd0000        	call	_Debug_Log
 446                     ; 158         Debug_Log("[EEPROM] Using default Mode 1\r\n");
 448  009b ae02ac        	ldw	x,#L312
 449  009e cd0000        	call	_Debug_Log
 451                     ; 160         return 0;
 453  00a1 4f            	clr	a
 455  00a2 2013          	jra	L02
 456  00a4               L502:
 457                     ; 167     if(mode > 4)
 459  00a4 7b02          	ld	a,(OFST-1,sp)
 460  00a6 a105          	cp	a,#5
 461  00a8 2510          	jrult	L512
 462                     ; 169         Debug_Log("[EEPROM] ERROR: Invalid mode value\r\n");
 464  00aa ae0287        	ldw	x,#L712
 465  00ad cd0000        	call	_Debug_Log
 467                     ; 170         Debug_Log("[EEPROM] Using default Mode 1\r\n");
 469  00b0 ae02ac        	ldw	x,#L312
 470  00b3 cd0000        	call	_Debug_Log
 472                     ; 172         return 0;
 474  00b6 4f            	clr	a
 476  00b7               L02:
 478  00b7 5b03          	addw	sp,#3
 479  00b9 81            	ret
 480  00ba               L512:
 481                     ; 179     expectedChecksum = EEPROM_CalculateChecksum(mode);
 483  00ba 7b02          	ld	a,(OFST-1,sp)
 484  00bc cd0017        	call	L53_EEPROM_CalculateChecksum
 486  00bf 6b03          	ld	(OFST+0,sp),a
 488                     ; 181     Debug_Log("[EEPROM] Expected checksum: 0x");
 490  00c1 ae0268        	ldw	x,#L122
 491  00c4 cd0000        	call	_Debug_Log
 493                     ; 182     Debug_LogHex(expectedChecksum);
 495  00c7 7b03          	ld	a,(OFST+0,sp)
 496  00c9 cd0000        	call	_Debug_LogHex
 498                     ; 183     Debug_Log("\r\n");
 500  00cc ae0341        	ldw	x,#L771
 501  00cf cd0000        	call	_Debug_Log
 503                     ; 189     if(checksum != expectedChecksum)
 505  00d2 7b01          	ld	a,(OFST-2,sp)
 506  00d4 1103          	cp	a,(OFST+0,sp)
 507  00d6 2715          	jreq	L322
 508                     ; 191         Debug_Log("[EEPROM] ERROR: Checksum mismatch\r\n");
 510  00d8 ae0244        	ldw	x,#L522
 511  00db cd0000        	call	_Debug_Log
 513                     ; 192         Debug_Log("[EEPROM] EEPROM data may be corrupted\r\n");
 515  00de ae021c        	ldw	x,#L722
 516  00e1 cd0000        	call	_Debug_Log
 518                     ; 193         Debug_Log("[EEPROM] Using default Mode 1\r\n");
 520  00e4 ae02ac        	ldw	x,#L312
 521  00e7 cd0000        	call	_Debug_Log
 523                     ; 195         return 0;
 525  00ea 4f            	clr	a
 527  00eb 20ca          	jra	L02
 528  00ed               L322:
 529                     ; 202     Debug_Log("[EEPROM] Configuration VALID\r\n");
 531  00ed ae01fd        	ldw	x,#L132
 532  00f0 cd0000        	call	_Debug_Log
 534                     ; 204     Debug_Log("[EEPROM] Restoring Mode: ");
 536  00f3 ae01e3        	ldw	x,#L332
 537  00f6 cd0000        	call	_Debug_Log
 539                     ; 205     Debug_LogDecimal(mode);
 541  00f9 7b02          	ld	a,(OFST-1,sp)
 542  00fb cd0000        	call	_Debug_LogDecimal
 544                     ; 206     Debug_Log("\r\n");
 546  00fe ae0341        	ldw	x,#L771
 547  0101 cd0000        	call	_Debug_Log
 549                     ; 208     return mode;
 551  0104 7b02          	ld	a,(OFST-1,sp)
 553  0106 20af          	jra	L02
 629                     ; 214  void EEPROM_SaveMode(uint8_t mode)
 629                     ; 215 {
 630                     	switch	.text
 631  0108               _EEPROM_SaveMode:
 633  0108 88            	push	a
 634  0109 5204          	subw	sp,#4
 635       00000004      OFST:	set	4
 638                     ; 225     if(mode > 4)
 640  010b a105          	cp	a,#5
 641  010d 250a          	jrult	L372
 642                     ; 227         Debug_Log("[EEPROM] ERROR: Attempted to save invalid mode\r\n");
 644  010f ae01b2        	ldw	x,#L572
 645  0112 cd0000        	call	_Debug_Log
 647                     ; 228         return;
 649  0115 ac000200      	jpf	L42
 650  0119               L372:
 651                     ; 232     Debug_Log("\r\n");
 653  0119 ae0341        	ldw	x,#L771
 654  011c cd0000        	call	_Debug_Log
 656                     ; 233     Debug_Log("[EEPROM] =============================\r\n");
 658  011f ae0189        	ldw	x,#L772
 659  0122 cd0000        	call	_Debug_Log
 661                     ; 234     Debug_Log("[EEPROM] Saving configuration\r\n");
 663  0125 ae0169        	ldw	x,#L103
 664  0128 cd0000        	call	_Debug_Log
 666                     ; 237     Debug_Log("[EEPROM] Mode = ");
 668  012b ae0158        	ldw	x,#L303
 669  012e cd0000        	call	_Debug_Log
 671                     ; 238     Debug_LogDecimal(mode);
 673  0131 7b05          	ld	a,(OFST+1,sp)
 674  0133 cd0000        	call	_Debug_LogDecimal
 676                     ; 239     Debug_Log("\r\n");
 678  0136 ae0341        	ldw	x,#L771
 679  0139 cd0000        	call	_Debug_Log
 681                     ; 242     checksum = EEPROM_CalculateChecksum(mode);
 683  013c 7b05          	ld	a,(OFST+1,sp)
 684  013e cd0017        	call	L53_EEPROM_CalculateChecksum
 686  0141 6b04          	ld	(OFST+0,sp),a
 688                     ; 244     Debug_Log("[EEPROM] Calculated checksum = 0x");
 690  0143 ae0136        	ldw	x,#L503
 691  0146 cd0000        	call	_Debug_Log
 693                     ; 245     Debug_LogHex(checksum);
 695  0149 7b04          	ld	a,(OFST+0,sp)
 696  014b cd0000        	call	_Debug_LogHex
 698                     ; 246     Debug_Log("\r\n");
 700  014e ae0341        	ldw	x,#L771
 701  0151 cd0000        	call	_Debug_Log
 703                     ; 252     Debug_Log("[EEPROM] Writing MODE...\r\n");
 705  0154 ae011b        	ldw	x,#L703
 706  0157 cd0000        	call	_Debug_Log
 708                     ; 254     EEPROM_WriteByte(
 708                     ; 255         EEPROM_MODE_ADDRESS,
 708                     ; 256         mode
 708                     ; 257     );
 710  015a 7b05          	ld	a,(OFST+1,sp)
 711  015c 88            	push	a
 712  015d ae4001        	ldw	x,#16385
 713  0160 cd0026        	call	_EEPROM_WriteByte
 715  0163 84            	pop	a
 716                     ; 263     Debug_Log("[EEPROM] Writing CHECKSUM...\r\n");
 718  0164 ae00fc        	ldw	x,#L113
 719  0167 cd0000        	call	_Debug_Log
 721                     ; 265     EEPROM_WriteByte(
 721                     ; 266         EEPROM_CHECKSUM_ADDRESS,
 721                     ; 267         checksum
 721                     ; 268     );
 723  016a 7b04          	ld	a,(OFST+0,sp)
 724  016c 88            	push	a
 725  016d ae4002        	ldw	x,#16386
 726  0170 cd0026        	call	_EEPROM_WriteByte
 728  0173 84            	pop	a
 729                     ; 274     Debug_Log("[EEPROM] Writing MAGIC...\r\n");
 731  0174 ae00e0        	ldw	x,#L313
 732  0177 cd0000        	call	_Debug_Log
 734                     ; 276     EEPROM_WriteByte(
 734                     ; 277         EEPROM_MAGIC_ADDRESS,
 734                     ; 278         EEPROM_MAGIC
 734                     ; 279     );
 736  017a 4ba5          	push	#165
 737  017c ae4000        	ldw	x,#16384
 738  017f cd0026        	call	_EEPROM_WriteByte
 740  0182 84            	pop	a
 741                     ; 285     Debug_Log("[EEPROM] Verifying EEPROM...\r\n");
 743  0183 ae00c1        	ldw	x,#L513
 744  0186 cd0000        	call	_Debug_Log
 746                     ; 287     readBackMagic =
 746                     ; 288         EEPROM_ReadByte(EEPROM_MAGIC_ADDRESS);
 748  0189 ae4000        	ldw	x,#16384
 749  018c cd001d        	call	_EEPROM_ReadByte
 751  018f 6b02          	ld	(OFST-2,sp),a
 753                     ; 290     readBackMode =
 753                     ; 291         EEPROM_ReadByte(EEPROM_MODE_ADDRESS);
 755  0191 ae4001        	ldw	x,#16385
 756  0194 cd001d        	call	_EEPROM_ReadByte
 758  0197 6b01          	ld	(OFST-3,sp),a
 760                     ; 293     readBackChecksum =
 760                     ; 294         EEPROM_ReadByte(EEPROM_CHECKSUM_ADDRESS);
 762  0199 ae4002        	ldw	x,#16386
 763  019c cd001d        	call	_EEPROM_ReadByte
 765  019f 6b03          	ld	(OFST-1,sp),a
 767                     ; 297     Debug_Log("[EEPROM] Read-back Magic: 0x");
 769  01a1 ae00a4        	ldw	x,#L713
 770  01a4 cd0000        	call	_Debug_Log
 772                     ; 298     Debug_LogHex(readBackMagic);
 774  01a7 7b02          	ld	a,(OFST-2,sp)
 775  01a9 cd0000        	call	_Debug_LogHex
 777                     ; 299     Debug_Log("\r\n");
 779  01ac ae0341        	ldw	x,#L771
 780  01af cd0000        	call	_Debug_Log
 782                     ; 301     Debug_Log("[EEPROM] Read-back Mode: ");
 784  01b2 ae008a        	ldw	x,#L123
 785  01b5 cd0000        	call	_Debug_Log
 787                     ; 302     Debug_LogDecimal(readBackMode);
 789  01b8 7b01          	ld	a,(OFST-3,sp)
 790  01ba cd0000        	call	_Debug_LogDecimal
 792                     ; 303     Debug_Log("\r\n");
 794  01bd ae0341        	ldw	x,#L771
 795  01c0 cd0000        	call	_Debug_Log
 797                     ; 305     Debug_Log("[EEPROM] Read-back Checksum: 0x");
 799  01c3 ae006a        	ldw	x,#L323
 800  01c6 cd0000        	call	_Debug_Log
 802                     ; 306     Debug_LogHex(readBackChecksum);
 804  01c9 7b03          	ld	a,(OFST-1,sp)
 805  01cb cd0000        	call	_Debug_LogHex
 807                     ; 307     Debug_Log("\r\n");
 809  01ce ae0341        	ldw	x,#L771
 810  01d1 cd0000        	call	_Debug_Log
 812                     ; 313     if((readBackMagic == EEPROM_MAGIC) &&
 812                     ; 314        (readBackMode == mode) &&
 812                     ; 315        (readBackChecksum == checksum))
 814  01d4 7b02          	ld	a,(OFST-2,sp)
 815  01d6 a1a5          	cp	a,#165
 816  01d8 261a          	jrne	L523
 818  01da 7b01          	ld	a,(OFST-3,sp)
 819  01dc 1105          	cp	a,(OFST+1,sp)
 820  01de 2614          	jrne	L523
 822  01e0 7b03          	ld	a,(OFST-1,sp)
 823  01e2 1104          	cp	a,(OFST+0,sp)
 824  01e4 260e          	jrne	L523
 825                     ; 317         Debug_Log("[EEPROM] SAVE SUCCESS\r\n");
 827  01e6 ae0052        	ldw	x,#L723
 828  01e9 cd0000        	call	_Debug_Log
 830                     ; 318         Debug_Log("[EEPROM] Configuration verified OK\r\n");
 832  01ec ae002d        	ldw	x,#L133
 833  01ef cd0000        	call	_Debug_Log
 836  01f2 2006          	jra	L333
 837  01f4               L523:
 838                     ; 322         Debug_Log("[EEPROM] ERROR: EEPROM verification FAILED\r\n");
 840  01f4 ae0000        	ldw	x,#L533
 841  01f7 cd0000        	call	_Debug_Log
 843  01fa               L333:
 844                     ; 326     Debug_Log("[EEPROM] =============================\r\n");
 846  01fa ae0189        	ldw	x,#L772
 847  01fd cd0000        	call	_Debug_Log
 849                     ; 327 }
 850  0200               L42:
 853  0200 5b05          	addw	sp,#5
 854  0202 81            	ret
 867                     	xref	_Debug_LogDecimal
 868                     	xref	_Debug_LogHex
 869                     	xref	_Debug_Log
 870                     	xdef	_EEPROM_SaveMode
 871                     	xdef	_EEPROM_LoadMode
 872                     	xdef	_EEPROM_WriteByte
 873                     	xdef	_EEPROM_ReadByte
 874                     	xdef	_EEPROM_Init
 875                     .const:	section	.text
 876  0000               L533:
 877  0000 5b454550524f  	dc.b	"[EEPROM] ERROR: EE"
 878  0012 50524f4d2076  	dc.b	"PROM verification "
 879  0024 4641494c4544  	dc.b	"FAILED",13
 880  002b 0a00          	dc.b	10,0
 881  002d               L133:
 882  002d 5b454550524f  	dc.b	"[EEPROM] Configura"
 883  003f 74696f6e2076  	dc.b	"tion verified OK",13
 884  0050 0a00          	dc.b	10,0
 885  0052               L723:
 886  0052 5b454550524f  	dc.b	"[EEPROM] SAVE SUCC"
 887  0064 4553530d      	dc.b	"ESS",13
 888  0068 0a00          	dc.b	10,0
 889  006a               L323:
 890  006a 5b454550524f  	dc.b	"[EEPROM] Read-back"
 891  007c 20436865636b  	dc.b	" Checksum: 0x",0
 892  008a               L123:
 893  008a 5b454550524f  	dc.b	"[EEPROM] Read-back"
 894  009c 204d6f64653a  	dc.b	" Mode: ",0
 895  00a4               L713:
 896  00a4 5b454550524f  	dc.b	"[EEPROM] Read-back"
 897  00b6 204d61676963  	dc.b	" Magic: 0x",0
 898  00c1               L513:
 899  00c1 5b454550524f  	dc.b	"[EEPROM] Verifying"
 900  00d3 20454550524f  	dc.b	" EEPROM...",13
 901  00de 0a00          	dc.b	10,0
 902  00e0               L313:
 903  00e0 5b454550524f  	dc.b	"[EEPROM] Writing M"
 904  00f2 414749432e2e  	dc.b	"AGIC...",13
 905  00fa 0a00          	dc.b	10,0
 906  00fc               L113:
 907  00fc 5b454550524f  	dc.b	"[EEPROM] Writing C"
 908  010e 4845434b5355  	dc.b	"HECKSUM...",13
 909  0119 0a00          	dc.b	10,0
 910  011b               L703:
 911  011b 5b454550524f  	dc.b	"[EEPROM] Writing M"
 912  012d 4f44452e2e2e  	dc.b	"ODE...",13
 913  0134 0a00          	dc.b	10,0
 914  0136               L503:
 915  0136 5b454550524f  	dc.b	"[EEPROM] Calculate"
 916  0148 642063686563  	dc.b	"d checksum = 0x",0
 917  0158               L303:
 918  0158 5b454550524f  	dc.b	"[EEPROM] Mode = ",0
 919  0169               L103:
 920  0169 5b454550524f  	dc.b	"[EEPROM] Saving co"
 921  017b 6e6669677572  	dc.b	"nfiguration",13
 922  0187 0a00          	dc.b	10,0
 923  0189               L772:
 924  0189 5b454550524f  	dc.b	"[EEPROM] ========="
 925  019b 3d3d3d3d3d3d  	dc.b	"=================="
 926  01ad 3d3d0d        	dc.b	"==",13
 927  01b0 0a00          	dc.b	10,0
 928  01b2               L572:
 929  01b2 5b454550524f  	dc.b	"[EEPROM] ERROR: At"
 930  01c4 74656d707465  	dc.b	"tempted to save in"
 931  01d6 76616c696420  	dc.b	"valid mode",13
 932  01e1 0a00          	dc.b	10,0
 933  01e3               L332:
 934  01e3 5b454550524f  	dc.b	"[EEPROM] Restoring"
 935  01f5 204d6f64653a  	dc.b	" Mode: ",0
 936  01fd               L132:
 937  01fd 5b454550524f  	dc.b	"[EEPROM] Configura"
 938  020f 74696f6e2056  	dc.b	"tion VALID",13
 939  021a 0a00          	dc.b	10,0
 940  021c               L722:
 941  021c 5b454550524f  	dc.b	"[EEPROM] EEPROM da"
 942  022e 7461206d6179  	dc.b	"ta may be corrupte"
 943  0240 640d          	dc.b	"d",13
 944  0242 0a00          	dc.b	10,0
 945  0244               L522:
 946  0244 5b454550524f  	dc.b	"[EEPROM] ERROR: Ch"
 947  0256 65636b73756d  	dc.b	"ecksum mismatch",13
 948  0266 0a00          	dc.b	10,0
 949  0268               L122:
 950  0268 5b454550524f  	dc.b	"[EEPROM] Expected "
 951  027a 636865636b73  	dc.b	"checksum: 0x",0
 952  0287               L712:
 953  0287 5b454550524f  	dc.b	"[EEPROM] ERROR: In"
 954  0299 76616c696420  	dc.b	"valid mode value",13
 955  02aa 0a00          	dc.b	10,0
 956  02ac               L312:
 957  02ac 5b454550524f  	dc.b	"[EEPROM] Using def"
 958  02be 61756c74204d  	dc.b	"ault Mode 1",13
 959  02ca 0a00          	dc.b	10,0
 960  02cc               L112:
 961  02cc 5b454550524f  	dc.b	"[EEPROM] No valid "
 962  02de 636f6e666967  	dc.b	"configuration foun"
 963  02f0 640d          	dc.b	"d",13
 964  02f2 0a00          	dc.b	10,0
 965  02f4               L702:
 966  02f4 5b454550524f  	dc.b	"[EEPROM] ERROR: In"
 967  0306 76616c696420  	dc.b	"valid magic number"
 968  0318 0d0a00        	dc.b	13,10,0
 969  031b               L302:
 970  031b 5b454550524f  	dc.b	"[EEPROM] Checksum:"
 971  032d 20307800      	dc.b	" 0x",0
 972  0331               L102:
 973  0331 5b454550524f  	dc.b	"[EEPROM] Mode: ",0
 974  0341               L771:
 975  0341 0d0a00        	dc.b	13,10,0
 976  0344               L571:
 977  0344 5b454550524f  	dc.b	"[EEPROM] Magic: 0x",0
 978  0357               L371:
 979  0357 5b454550524f  	dc.b	"[EEPROM] Loading c"
 980  0369 6f6e66696775  	dc.b	"onfiguration...",13
 981  0379 0a00          	dc.b	10,0
1001                     	end
