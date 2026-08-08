   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  43                     ; 26 static void EEPROM_Unlock(void)
  43                     ; 27 {
  45                     	switch	.text
  46  0000               L3_EEPROM_Unlock:
  50                     ; 28     if((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
  52  0000 c6505f        	ld	a,20575
  53  0003 a508          	bcp	a,#8
  54  0005 2614          	jrne	L32
  55                     ; 30         FLASH_DUKR = 0xAE;
  57  0007 35ae5064      	mov	20580,#174
  58                     ; 31         FLASH_DUKR = 0x56;
  60  000b 35565064      	mov	20580,#86
  62  000f 2003          	jra	L13
  63  0011               L52:
  64                     ; 40             Watchdog_Refresh();
  66  0011 cd0000        	call	_Watchdog_Refresh
  68  0014               L13:
  69                     ; 33         while((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
  71  0014 c6505f        	ld	a,20575
  72  0017 a508          	bcp	a,#8
  73  0019 27f6          	jreq	L52
  74  001b               L32:
  75                     ; 43 }
  78  001b 81            	ret
 113                     ; 51 static uint8_t EEPROM_CalculateChecksum(
 113                     ; 52     uint8_t mode
 113                     ; 53 )
 113                     ; 54 {
 114                     	switch	.text
 115  001c               L53_EEPROM_CalculateChecksum:
 119                     ; 55     return (uint8_t)(
 119                     ; 56         EEPROM_MAGIC ^
 119                     ; 57         mode ^
 119                     ; 58         0x5A
 119                     ; 59     );
 121  001c a8a6          	xor	a,#166
 122  001e a85a          	xor	a,#90
 125  0020 81            	ret
 160                     ; 70 static uint8_t EEPROM_CalculateLegacyChecksum(
 160                     ; 71     uint8_t mode
 160                     ; 72 )
 160                     ; 73 {
 161                     	switch	.text
 162  0021               L55_EEPROM_CalculateLegacyChecksum:
 166                     ; 74     return (uint8_t)(
 166                     ; 75         EEPROM_LEGACY_MAGIC ^
 166                     ; 76         mode ^
 166                     ; 77         0x5A
 166                     ; 78     );
 168  0021 a8a5          	xor	a,#165
 169  0023 a85a          	xor	a,#90
 172  0025 81            	ret
 195                     ; 86 void EEPROM_Init(void)
 195                     ; 87 {
 196                     	switch	.text
 197  0026               _EEPROM_Init:
 201                     ; 93 }
 204  0026 81            	ret
 247                     ; 100 uint8_t EEPROM_ReadByte(
 247                     ; 101     uint16_t address
 247                     ; 102 )
 247                     ; 103 {
 248                     	switch	.text
 249  0027               _EEPROM_ReadByte:
 251  0027 88            	push	a
 252       00000001      OFST:	set	1
 255                     ; 106     value = (*(volatile uint8_t*)address);
 257  0028 f6            	ld	a,(x)
 258  0029 6b01          	ld	(OFST+0,sp),a
 260                     ; 108     return value;
 262  002b 7b01          	ld	a,(OFST+0,sp)
 265  002d 5b01          	addw	sp,#1
 266  002f 81            	ret
 311                     ; 116 uint8_t EEPROM_WriteByte(
 311                     ; 117     uint16_t address,
 311                     ; 118     uint8_t value
 311                     ; 119 )
 311                     ; 120 {
 312                     	switch	.text
 313  0030               _EEPROM_WriteByte:
 315  0030 89            	pushw	x
 316       00000000      OFST:	set	0
 319                     ; 124     EEPROM_Unlock();
 321  0031 adcd          	call	L3_EEPROM_Unlock
 323                     ; 130     (*(volatile uint8_t*)address) = value;
 325  0033 7b05          	ld	a,(OFST+5,sp)
 326  0035 1e01          	ldw	x,(OFST+1,sp)
 327  0037 f7            	ld	(x),a
 329  0038 2003          	jra	L551
 330  003a               L151:
 331                     ; 141         Watchdog_Refresh();
 333  003a cd0000        	call	_Watchdog_Refresh
 335  003d               L551:
 336                     ; 139     while((FLASH_IAPSR & FLASH_IAPSR_EOP) == 0)
 338  003d c6505f        	ld	a,20575
 339  0040 a504          	bcp	a,#4
 340  0042 27f6          	jreq	L151
 341                     ; 148     Watchdog_Refresh();
 343  0044 cd0000        	call	_Watchdog_Refresh
 345                     ; 151     return TRUE;
 347  0047 a601          	ld	a,#1
 350  0049 85            	popw	x
 351  004a 81            	ret
 428                     ; 159 uint8_t EEPROM_LoadMode(void)
 428                     ; 160 {
 429                     	switch	.text
 430  004b               _EEPROM_LoadMode:
 432  004b 5203          	subw	sp,#3
 433       00000003      OFST:	set	3
 436                     ; 167     Debug_Log(
 436                     ; 168         "[EEPROM] Loading configuration...\r\n"
 436                     ; 169     );
 438  004d ae03dc        	ldw	x,#L712
 439  0050 cd0000        	call	_Debug_Log
 441                     ; 176     magic =
 441                     ; 177         EEPROM_ReadByte(
 441                     ; 178             EEPROM_MAGIC_ADDRESS
 441                     ; 179         );
 443  0053 ae4000        	ldw	x,#16384
 444  0056 adcf          	call	_EEPROM_ReadByte
 446  0058 6b02          	ld	(OFST-1,sp),a
 448                     ; 181     mode =
 448                     ; 182         EEPROM_ReadByte(
 448                     ; 183             EEPROM_MODE_ADDRESS
 448                     ; 184         );
 450  005a ae4001        	ldw	x,#16385
 451  005d adc8          	call	_EEPROM_ReadByte
 453  005f 6b03          	ld	(OFST+0,sp),a
 455                     ; 186     checksum =
 455                     ; 187         EEPROM_ReadByte(
 455                     ; 188             EEPROM_CHECKSUM_ADDRESS
 455                     ; 189         );
 457  0061 ae4002        	ldw	x,#16386
 458  0064 adc1          	call	_EEPROM_ReadByte
 460  0066 6b01          	ld	(OFST-2,sp),a
 462                     ; 196     Debug_Log("[EEPROM] Magic: 0x");
 464  0068 ae03c9        	ldw	x,#L122
 465  006b cd0000        	call	_Debug_Log
 467                     ; 197     Debug_LogHex(magic);
 469  006e 7b02          	ld	a,(OFST-1,sp)
 470  0070 cd0000        	call	_Debug_LogHex
 472                     ; 198     Debug_Log("\r\n");
 474  0073 ae03c6        	ldw	x,#L322
 475  0076 cd0000        	call	_Debug_Log
 477                     ; 200     Debug_Log("[EEPROM] Stored Mode: ");
 479  0079 ae03af        	ldw	x,#L522
 480  007c cd0000        	call	_Debug_Log
 482                     ; 201     Debug_LogDecimal(mode);
 484  007f 7b03          	ld	a,(OFST+0,sp)
 485  0081 cd0000        	call	_Debug_LogDecimal
 487                     ; 202     Debug_Log("\r\n");
 489  0084 ae03c6        	ldw	x,#L322
 490  0087 cd0000        	call	_Debug_Log
 492                     ; 204     Debug_Log("[EEPROM] Checksum: 0x");
 494  008a ae0399        	ldw	x,#L722
 495  008d cd0000        	call	_Debug_Log
 497                     ; 205     Debug_LogHex(checksum);
 499  0090 7b01          	ld	a,(OFST-2,sp)
 500  0092 cd0000        	call	_Debug_LogHex
 502                     ; 206     Debug_Log("\r\n");
 504  0095 ae03c6        	ldw	x,#L322
 505  0098 cd0000        	call	_Debug_Log
 507                     ; 213     if(magic == EEPROM_MAGIC)
 509  009b 7b02          	ld	a,(OFST-1,sp)
 510  009d a1a6          	cp	a,#166
 511  009f 2664          	jrne	L132
 512                     ; 219         if(
 512                     ; 220             (mode < EEPROM_MIN_MODE) ||
 512                     ; 221             (mode > EEPROM_MAX_MODE)
 512                     ; 222         )
 514  00a1 0d03          	tnz	(OFST+0,sp)
 515  00a3 2706          	jreq	L532
 517  00a5 7b03          	ld	a,(OFST+0,sp)
 518  00a7 a106          	cp	a,#6
 519  00a9 2510          	jrult	L332
 520  00ab               L532:
 521                     ; 224             Debug_Log(
 521                     ; 225                 "[EEPROM] ERROR: Invalid mode\r\n"
 521                     ; 226             );
 523  00ab ae037a        	ldw	x,#L732
 524  00ae cd0000        	call	_Debug_Log
 526                     ; 228             Debug_Log(
 526                     ; 229                 "[EEPROM] Using default Mode 1\r\n"
 526                     ; 230             );
 528  00b1 ae035a        	ldw	x,#L142
 529  00b4 cd0000        	call	_Debug_Log
 531                     ; 232             return 1;
 533  00b7 a601          	ld	a,#1
 535  00b9 202c          	jra	L22
 536  00bb               L332:
 537                     ; 240         expectedChecksum =
 537                     ; 241             EEPROM_CalculateChecksum(mode);
 539  00bb 7b03          	ld	a,(OFST+0,sp)
 540  00bd cd001c        	call	L53_EEPROM_CalculateChecksum
 542  00c0 6b02          	ld	(OFST-1,sp),a
 544                     ; 244         Debug_Log(
 544                     ; 245             "[EEPROM] Expected checksum: 0x"
 544                     ; 246         );
 546  00c2 ae033b        	ldw	x,#L342
 547  00c5 cd0000        	call	_Debug_Log
 549                     ; 248         Debug_LogHex(expectedChecksum);
 551  00c8 7b02          	ld	a,(OFST-1,sp)
 552  00ca cd0000        	call	_Debug_LogHex
 554                     ; 250         Debug_Log("\r\n");
 556  00cd ae03c6        	ldw	x,#L322
 557  00d0 cd0000        	call	_Debug_Log
 559                     ; 257         if(checksum != expectedChecksum)
 561  00d3 7b01          	ld	a,(OFST-2,sp)
 562  00d5 1102          	cp	a,(OFST-1,sp)
 563  00d7 2711          	jreq	L542
 564                     ; 259             Debug_Log(
 564                     ; 260                 "[EEPROM] ERROR: Checksum mismatch\r\n"
 564                     ; 261             );
 566  00d9 ae0317        	ldw	x,#L742
 567  00dc cd0000        	call	_Debug_Log
 569                     ; 263             Debug_Log(
 569                     ; 264                 "[EEPROM] Using default Mode 1\r\n"
 569                     ; 265             );
 571  00df ae035a        	ldw	x,#L142
 572  00e2 cd0000        	call	_Debug_Log
 574                     ; 267             return 1;
 576  00e5 a601          	ld	a,#1
 578  00e7               L22:
 580  00e7 5b03          	addw	sp,#3
 581  00e9 81            	ret
 582  00ea               L542:
 583                     ; 275         Debug_Log(
 583                     ; 276             "[EEPROM] Configuration VALID\r\n"
 583                     ; 277         );
 585  00ea ae02f8        	ldw	x,#L152
 586  00ed cd0000        	call	_Debug_Log
 588                     ; 279         Debug_Log(
 588                     ; 280             "[EEPROM] Restoring Mode: "
 588                     ; 281         );
 590  00f0 ae02de        	ldw	x,#L352
 591  00f3 cd0000        	call	_Debug_Log
 593                     ; 283         Debug_LogDecimal(mode);
 595  00f6 7b03          	ld	a,(OFST+0,sp)
 596  00f8 cd0000        	call	_Debug_LogDecimal
 598                     ; 285         Debug_Log("\r\n");
 600  00fb ae03c6        	ldw	x,#L322
 601  00fe cd0000        	call	_Debug_Log
 603                     ; 288         return mode;
 605  0101 7b03          	ld	a,(OFST+0,sp)
 607  0103 20e2          	jra	L22
 608  0105               L132:
 609                     ; 296     if(magic == EEPROM_LEGACY_MAGIC)
 611  0105 7b02          	ld	a,(OFST-1,sp)
 612  0107 a1a5          	cp	a,#165
 613  0109 265a          	jrne	L552
 614                     ; 311         Debug_Log(
 614                     ; 312             "[EEPROM] Legacy configuration detected\r\n"
 614                     ; 313         );
 616  010b ae02b5        	ldw	x,#L752
 617  010e cd0000        	call	_Debug_Log
 619                     ; 320         if(mode > 4)
 621  0111 7b03          	ld	a,(OFST+0,sp)
 622  0113 a105          	cp	a,#5
 623  0115 2510          	jrult	L162
 624                     ; 322             Debug_Log(
 624                     ; 323                 "[EEPROM] ERROR: Invalid legacy mode\r\n"
 624                     ; 324             );
 626  0117 ae028f        	ldw	x,#L362
 627  011a cd0000        	call	_Debug_Log
 629                     ; 326             Debug_Log(
 629                     ; 327                 "[EEPROM] Using default Mode 1\r\n"
 629                     ; 328             );
 631  011d ae035a        	ldw	x,#L142
 632  0120 cd0000        	call	_Debug_Log
 634                     ; 330             return 1;
 636  0123 a601          	ld	a,#1
 638  0125 20c0          	jra	L22
 639  0127               L162:
 640                     ; 338         legacyChecksum =
 640                     ; 339             EEPROM_CalculateLegacyChecksum(mode);
 642  0127 7b03          	ld	a,(OFST+0,sp)
 643  0129 cd0021        	call	L55_EEPROM_CalculateLegacyChecksum
 645  012c 6b02          	ld	(OFST-1,sp),a
 647                     ; 342         if(checksum != legacyChecksum)
 649  012e 7b01          	ld	a,(OFST-2,sp)
 650  0130 1102          	cp	a,(OFST-1,sp)
 651  0132 2710          	jreq	L562
 652                     ; 344             Debug_Log(
 652                     ; 345                 "[EEPROM] ERROR: Legacy checksum mismatch\r\n"
 652                     ; 346             );
 654  0134 ae0264        	ldw	x,#L762
 655  0137 cd0000        	call	_Debug_Log
 657                     ; 348             Debug_Log(
 657                     ; 349                 "[EEPROM] Using default Mode 1\r\n"
 657                     ; 350             );
 659  013a ae035a        	ldw	x,#L142
 660  013d cd0000        	call	_Debug_Log
 662                     ; 352             return 1;
 664  0140 a601          	ld	a,#1
 666  0142 20a3          	jra	L22
 667  0144               L562:
 668                     ; 366         mode = mode + 1;
 670  0144 0c03          	inc	(OFST+0,sp)
 672                     ; 369         Debug_Log(
 672                     ; 370             "[EEPROM] Legacy mode converted to Mode: "
 672                     ; 371         );
 674  0146 ae023b        	ldw	x,#L172
 675  0149 cd0000        	call	_Debug_Log
 677                     ; 373         Debug_LogDecimal(mode);
 679  014c 7b03          	ld	a,(OFST+0,sp)
 680  014e cd0000        	call	_Debug_LogDecimal
 682                     ; 375         Debug_Log("\r\n");
 684  0151 ae03c6        	ldw	x,#L322
 685  0154 cd0000        	call	_Debug_Log
 687                     ; 382         EEPROM_SaveMode(mode);
 689  0157 7b03          	ld	a,(OFST+0,sp)
 690  0159 ad1c          	call	_EEPROM_SaveMode
 692                     ; 385         Debug_Log(
 692                     ; 386             "[EEPROM] Legacy configuration migrated\r\n"
 692                     ; 387         );
 694  015b ae0212        	ldw	x,#L372
 695  015e cd0000        	call	_Debug_Log
 697                     ; 390         return mode;
 699  0161 7b03          	ld	a,(OFST+0,sp)
 701  0163 2082          	jra	L22
 702  0165               L552:
 703                     ; 398     Debug_Log(
 703                     ; 399         "[EEPROM] ERROR: Unknown configuration format\r\n"
 703                     ; 400     );
 705  0165 ae01e3        	ldw	x,#L572
 706  0168 cd0000        	call	_Debug_Log
 708                     ; 402     Debug_Log(
 708                     ; 403         "[EEPROM] Using default Mode 1\r\n"
 708                     ; 404     );
 710  016b ae035a        	ldw	x,#L142
 711  016e cd0000        	call	_Debug_Log
 713                     ; 407     return 1;
 715  0171 a601          	ld	a,#1
 717  0173 ace700e7      	jpf	L22
 794                     ; 415 void EEPROM_SaveMode(uint8_t mode)
 794                     ; 416 {
 795                     	switch	.text
 796  0177               _EEPROM_SaveMode:
 798  0177 88            	push	a
 799  0178 5204          	subw	sp,#4
 800       00000004      OFST:	set	4
 803                     ; 428     if(
 803                     ; 429         (mode < EEPROM_MIN_MODE) ||
 803                     ; 430         (mode > EEPROM_MAX_MODE)
 803                     ; 431     )
 805  017a 4d            	tnz	a
 806  017b 2704          	jreq	L733
 808  017d a106          	cp	a,#6
 809  017f 250a          	jrult	L533
 810  0181               L733:
 811                     ; 433         Debug_Log(
 811                     ; 434             "[EEPROM] ERROR: Attempted to save invalid mode\r\n"
 811                     ; 435         );
 813  0181 ae01b2        	ldw	x,#L143
 814  0184 cd0000        	call	_Debug_Log
 816                     ; 437         return;
 818  0187 ac810281      	jpf	L62
 819  018b               L533:
 820                     ; 441     Debug_Log("\r\n");
 822  018b ae03c6        	ldw	x,#L322
 823  018e cd0000        	call	_Debug_Log
 825                     ; 443     Debug_Log(
 825                     ; 444         "[EEPROM] =============================\r\n"
 825                     ; 445     );
 827  0191 ae0189        	ldw	x,#L343
 828  0194 cd0000        	call	_Debug_Log
 830                     ; 447     Debug_Log(
 830                     ; 448         "[EEPROM] Saving configuration\r\n"
 830                     ; 449     );
 832  0197 ae0169        	ldw	x,#L543
 833  019a cd0000        	call	_Debug_Log
 835                     ; 456     checksum =
 835                     ; 457         EEPROM_CalculateChecksum(mode);
 837  019d 7b05          	ld	a,(OFST+1,sp)
 838  019f cd001c        	call	L53_EEPROM_CalculateChecksum
 840  01a2 6b04          	ld	(OFST+0,sp),a
 842                     ; 460     Debug_Log("[EEPROM] Mode = ");
 844  01a4 ae0158        	ldw	x,#L743
 845  01a7 cd0000        	call	_Debug_Log
 847                     ; 461     Debug_LogDecimal(mode);
 849  01aa 7b05          	ld	a,(OFST+1,sp)
 850  01ac cd0000        	call	_Debug_LogDecimal
 852                     ; 463     Debug_Log("\r\n");
 854  01af ae03c6        	ldw	x,#L322
 855  01b2 cd0000        	call	_Debug_Log
 857                     ; 466     Debug_Log(
 857                     ; 467         "[EEPROM] Calculated checksum = 0x"
 857                     ; 468     );
 859  01b5 ae0136        	ldw	x,#L153
 860  01b8 cd0000        	call	_Debug_Log
 862                     ; 470     Debug_LogHex(checksum);
 864  01bb 7b04          	ld	a,(OFST+0,sp)
 865  01bd cd0000        	call	_Debug_LogHex
 867                     ; 472     Debug_Log("\r\n");
 869  01c0 ae03c6        	ldw	x,#L322
 870  01c3 cd0000        	call	_Debug_Log
 872                     ; 479     Debug_Log(
 872                     ; 480         "[EEPROM] Writing MODE...\r\n"
 872                     ; 481     );
 874  01c6 ae011b        	ldw	x,#L353
 875  01c9 cd0000        	call	_Debug_Log
 877                     ; 483     EEPROM_WriteByte(
 877                     ; 484         EEPROM_MODE_ADDRESS,
 877                     ; 485         mode
 877                     ; 486     );
 879  01cc 7b05          	ld	a,(OFST+1,sp)
 880  01ce 88            	push	a
 881  01cf ae4001        	ldw	x,#16385
 882  01d2 cd0030        	call	_EEPROM_WriteByte
 884  01d5 84            	pop	a
 885                     ; 492     Watchdog_Refresh();
 887  01d6 cd0000        	call	_Watchdog_Refresh
 889                     ; 499     Debug_Log(
 889                     ; 500         "[EEPROM] Writing CHECKSUM...\r\n"
 889                     ; 501     );
 891  01d9 ae00fc        	ldw	x,#L553
 892  01dc cd0000        	call	_Debug_Log
 894                     ; 503     EEPROM_WriteByte(
 894                     ; 504         EEPROM_CHECKSUM_ADDRESS,
 894                     ; 505         checksum
 894                     ; 506     );
 896  01df 7b04          	ld	a,(OFST+0,sp)
 897  01e1 88            	push	a
 898  01e2 ae4002        	ldw	x,#16386
 899  01e5 cd0030        	call	_EEPROM_WriteByte
 901  01e8 84            	pop	a
 902                     ; 508     Watchdog_Refresh();
 904  01e9 cd0000        	call	_Watchdog_Refresh
 906                     ; 515     Debug_Log(
 906                     ; 516         "[EEPROM] Writing MAGIC...\r\n"
 906                     ; 517     );
 908  01ec ae00e0        	ldw	x,#L753
 909  01ef cd0000        	call	_Debug_Log
 911                     ; 519     EEPROM_WriteByte(
 911                     ; 520         EEPROM_MAGIC_ADDRESS,
 911                     ; 521         EEPROM_MAGIC
 911                     ; 522     );
 913  01f2 4ba6          	push	#166
 914  01f4 ae4000        	ldw	x,#16384
 915  01f7 cd0030        	call	_EEPROM_WriteByte
 917  01fa 84            	pop	a
 918                     ; 524     Watchdog_Refresh();
 920  01fb cd0000        	call	_Watchdog_Refresh
 922                     ; 531     Debug_Log(
 922                     ; 532         "[EEPROM] Verifying EEPROM...\r\n"
 922                     ; 533     );
 924  01fe ae00c1        	ldw	x,#L163
 925  0201 cd0000        	call	_Debug_Log
 927                     ; 536     readBackMagic =
 927                     ; 537         EEPROM_ReadByte(
 927                     ; 538             EEPROM_MAGIC_ADDRESS
 927                     ; 539         );
 929  0204 ae4000        	ldw	x,#16384
 930  0207 cd0027        	call	_EEPROM_ReadByte
 932  020a 6b02          	ld	(OFST-2,sp),a
 934                     ; 541     readBackMode =
 934                     ; 542         EEPROM_ReadByte(
 934                     ; 543             EEPROM_MODE_ADDRESS
 934                     ; 544         );
 936  020c ae4001        	ldw	x,#16385
 937  020f cd0027        	call	_EEPROM_ReadByte
 939  0212 6b01          	ld	(OFST-3,sp),a
 941                     ; 546     readBackChecksum =
 941                     ; 547         EEPROM_ReadByte(
 941                     ; 548             EEPROM_CHECKSUM_ADDRESS
 941                     ; 549         );
 943  0214 ae4002        	ldw	x,#16386
 944  0217 cd0027        	call	_EEPROM_ReadByte
 946  021a 6b03          	ld	(OFST-1,sp),a
 948                     ; 556     Watchdog_Refresh();
 950  021c cd0000        	call	_Watchdog_Refresh
 952                     ; 559     Debug_Log(
 952                     ; 560         "[EEPROM] Read-back Magic: 0x"
 952                     ; 561     );
 954  021f ae00a4        	ldw	x,#L363
 955  0222 cd0000        	call	_Debug_Log
 957                     ; 563     Debug_LogHex(readBackMagic);
 959  0225 7b02          	ld	a,(OFST-2,sp)
 960  0227 cd0000        	call	_Debug_LogHex
 962                     ; 565     Debug_Log("\r\n");
 964  022a ae03c6        	ldw	x,#L322
 965  022d cd0000        	call	_Debug_Log
 967                     ; 568     Debug_Log(
 967                     ; 569         "[EEPROM] Read-back Mode: "
 967                     ; 570     );
 969  0230 ae008a        	ldw	x,#L563
 970  0233 cd0000        	call	_Debug_Log
 972                     ; 572     Debug_LogDecimal(readBackMode);
 974  0236 7b01          	ld	a,(OFST-3,sp)
 975  0238 cd0000        	call	_Debug_LogDecimal
 977                     ; 574     Debug_Log("\r\n");
 979  023b ae03c6        	ldw	x,#L322
 980  023e cd0000        	call	_Debug_Log
 982                     ; 577     Debug_Log(
 982                     ; 578         "[EEPROM] Read-back Checksum: 0x"
 982                     ; 579     );
 984  0241 ae006a        	ldw	x,#L763
 985  0244 cd0000        	call	_Debug_Log
 987                     ; 581     Debug_LogHex(readBackChecksum);
 989  0247 7b03          	ld	a,(OFST-1,sp)
 990  0249 cd0000        	call	_Debug_LogHex
 992                     ; 583     Debug_Log("\r\n");
 994  024c ae03c6        	ldw	x,#L322
 995  024f cd0000        	call	_Debug_Log
 997                     ; 590     if(
 997                     ; 591         (readBackMagic == EEPROM_MAGIC) &&
 997                     ; 592         (readBackMode == mode) &&
 997                     ; 593         (readBackChecksum == checksum)
 997                     ; 594     )
 999  0252 7b02          	ld	a,(OFST-2,sp)
1000  0254 a1a6          	cp	a,#166
1001  0256 261a          	jrne	L173
1003  0258 7b01          	ld	a,(OFST-3,sp)
1004  025a 1105          	cp	a,(OFST+1,sp)
1005  025c 2614          	jrne	L173
1007  025e 7b03          	ld	a,(OFST-1,sp)
1008  0260 1104          	cp	a,(OFST+0,sp)
1009  0262 260e          	jrne	L173
1010                     ; 596         Debug_Log(
1010                     ; 597             "[EEPROM] SAVE SUCCESS\r\n"
1010                     ; 598         );
1012  0264 ae0052        	ldw	x,#L373
1013  0267 cd0000        	call	_Debug_Log
1015                     ; 600         Debug_Log(
1015                     ; 601             "[EEPROM] Configuration verified OK\r\n"
1015                     ; 602         );
1017  026a ae002d        	ldw	x,#L573
1018  026d cd0000        	call	_Debug_Log
1021  0270 2006          	jra	L773
1022  0272               L173:
1023                     ; 606         Debug_Log(
1023                     ; 607             "[EEPROM] ERROR: EEPROM verification FAILED\r\n"
1023                     ; 608         );
1025  0272 ae0000        	ldw	x,#L104
1026  0275 cd0000        	call	_Debug_Log
1028  0278               L773:
1029                     ; 612     Debug_Log(
1029                     ; 613         "[EEPROM] =============================\r\n"
1029                     ; 614     );
1031  0278 ae0189        	ldw	x,#L343
1032  027b cd0000        	call	_Debug_Log
1034                     ; 621     Watchdog_Refresh();
1036  027e cd0000        	call	_Watchdog_Refresh
1038                     ; 622 }
1039  0281               L62:
1042  0281 5b05          	addw	sp,#5
1043  0283 81            	ret
1056                     	xref	_Watchdog_Refresh
1057                     	xref	_Debug_LogDecimal
1058                     	xref	_Debug_LogHex
1059                     	xref	_Debug_Log
1060                     	xdef	_EEPROM_SaveMode
1061                     	xdef	_EEPROM_LoadMode
1062                     	xdef	_EEPROM_WriteByte
1063                     	xdef	_EEPROM_ReadByte
1064                     	xdef	_EEPROM_Init
1065                     .const:	section	.text
1066  0000               L104:
1067  0000 5b454550524f  	dc.b	"[EEPROM] ERROR: EE"
1068  0012 50524f4d2076  	dc.b	"PROM verification "
1069  0024 4641494c4544  	dc.b	"FAILED",13
1070  002b 0a00          	dc.b	10,0
1071  002d               L573:
1072  002d 5b454550524f  	dc.b	"[EEPROM] Configura"
1073  003f 74696f6e2076  	dc.b	"tion verified OK",13
1074  0050 0a00          	dc.b	10,0
1075  0052               L373:
1076  0052 5b454550524f  	dc.b	"[EEPROM] SAVE SUCC"
1077  0064 4553530d      	dc.b	"ESS",13
1078  0068 0a00          	dc.b	10,0
1079  006a               L763:
1080  006a 5b454550524f  	dc.b	"[EEPROM] Read-back"
1081  007c 20436865636b  	dc.b	" Checksum: 0x",0
1082  008a               L563:
1083  008a 5b454550524f  	dc.b	"[EEPROM] Read-back"
1084  009c 204d6f64653a  	dc.b	" Mode: ",0
1085  00a4               L363:
1086  00a4 5b454550524f  	dc.b	"[EEPROM] Read-back"
1087  00b6 204d61676963  	dc.b	" Magic: 0x",0
1088  00c1               L163:
1089  00c1 5b454550524f  	dc.b	"[EEPROM] Verifying"
1090  00d3 20454550524f  	dc.b	" EEPROM...",13
1091  00de 0a00          	dc.b	10,0
1092  00e0               L753:
1093  00e0 5b454550524f  	dc.b	"[EEPROM] Writing M"
1094  00f2 414749432e2e  	dc.b	"AGIC...",13
1095  00fa 0a00          	dc.b	10,0
1096  00fc               L553:
1097  00fc 5b454550524f  	dc.b	"[EEPROM] Writing C"
1098  010e 4845434b5355  	dc.b	"HECKSUM...",13
1099  0119 0a00          	dc.b	10,0
1100  011b               L353:
1101  011b 5b454550524f  	dc.b	"[EEPROM] Writing M"
1102  012d 4f44452e2e2e  	dc.b	"ODE...",13
1103  0134 0a00          	dc.b	10,0
1104  0136               L153:
1105  0136 5b454550524f  	dc.b	"[EEPROM] Calculate"
1106  0148 642063686563  	dc.b	"d checksum = 0x",0
1107  0158               L743:
1108  0158 5b454550524f  	dc.b	"[EEPROM] Mode = ",0
1109  0169               L543:
1110  0169 5b454550524f  	dc.b	"[EEPROM] Saving co"
1111  017b 6e6669677572  	dc.b	"nfiguration",13
1112  0187 0a00          	dc.b	10,0
1113  0189               L343:
1114  0189 5b454550524f  	dc.b	"[EEPROM] ========="
1115  019b 3d3d3d3d3d3d  	dc.b	"=================="
1116  01ad 3d3d0d        	dc.b	"==",13
1117  01b0 0a00          	dc.b	10,0
1118  01b2               L143:
1119  01b2 5b454550524f  	dc.b	"[EEPROM] ERROR: At"
1120  01c4 74656d707465  	dc.b	"tempted to save in"
1121  01d6 76616c696420  	dc.b	"valid mode",13
1122  01e1 0a00          	dc.b	10,0
1123  01e3               L572:
1124  01e3 5b454550524f  	dc.b	"[EEPROM] ERROR: Un"
1125  01f5 6b6e6f776e20  	dc.b	"known configuratio"
1126  0207 6e20666f726d  	dc.b	"n format",13
1127  0210 0a00          	dc.b	10,0
1128  0212               L372:
1129  0212 5b454550524f  	dc.b	"[EEPROM] Legacy co"
1130  0224 6e6669677572  	dc.b	"nfiguration migrat"
1131  0236 65640d        	dc.b	"ed",13
1132  0239 0a00          	dc.b	10,0
1133  023b               L172:
1134  023b 5b454550524f  	dc.b	"[EEPROM] Legacy mo"
1135  024d 646520636f6e  	dc.b	"de converted to Mo"
1136  025f 64653a2000    	dc.b	"de: ",0
1137  0264               L762:
1138  0264 5b454550524f  	dc.b	"[EEPROM] ERROR: Le"
1139  0276 676163792063  	dc.b	"gacy checksum mism"
1140  0288 617463680d    	dc.b	"atch",13
1141  028d 0a00          	dc.b	10,0
1142  028f               L362:
1143  028f 5b454550524f  	dc.b	"[EEPROM] ERROR: In"
1144  02a1 76616c696420  	dc.b	"valid legacy mode",13
1145  02b3 0a00          	dc.b	10,0
1146  02b5               L752:
1147  02b5 5b454550524f  	dc.b	"[EEPROM] Legacy co"
1148  02c7 6e6669677572  	dc.b	"nfiguration detect"
1149  02d9 65640d        	dc.b	"ed",13
1150  02dc 0a00          	dc.b	10,0
1151  02de               L352:
1152  02de 5b454550524f  	dc.b	"[EEPROM] Restoring"
1153  02f0 204d6f64653a  	dc.b	" Mode: ",0
1154  02f8               L152:
1155  02f8 5b454550524f  	dc.b	"[EEPROM] Configura"
1156  030a 74696f6e2056  	dc.b	"tion VALID",13
1157  0315 0a00          	dc.b	10,0
1158  0317               L742:
1159  0317 5b454550524f  	dc.b	"[EEPROM] ERROR: Ch"
1160  0329 65636b73756d  	dc.b	"ecksum mismatch",13
1161  0339 0a00          	dc.b	10,0
1162  033b               L342:
1163  033b 5b454550524f  	dc.b	"[EEPROM] Expected "
1164  034d 636865636b73  	dc.b	"checksum: 0x",0
1165  035a               L142:
1166  035a 5b454550524f  	dc.b	"[EEPROM] Using def"
1167  036c 61756c74204d  	dc.b	"ault Mode 1",13
1168  0378 0a00          	dc.b	10,0
1169  037a               L732:
1170  037a 5b454550524f  	dc.b	"[EEPROM] ERROR: In"
1171  038c 76616c696420  	dc.b	"valid mode",13
1172  0397 0a00          	dc.b	10,0
1173  0399               L722:
1174  0399 5b454550524f  	dc.b	"[EEPROM] Checksum:"
1175  03ab 20307800      	dc.b	" 0x",0
1176  03af               L522:
1177  03af 5b454550524f  	dc.b	"[EEPROM] Stored Mo"
1178  03c1 64653a2000    	dc.b	"de: ",0
1179  03c6               L322:
1180  03c6 0d0a00        	dc.b	13,10,0
1181  03c9               L122:
1182  03c9 5b454550524f  	dc.b	"[EEPROM] Magic: 0x",0
1183  03dc               L712:
1184  03dc 5b454550524f  	dc.b	"[EEPROM] Loading c"
1185  03ee 6f6e66696775  	dc.b	"onfiguration...",13
1186  03fe 0a00          	dc.b	10,0
1206                     	end
