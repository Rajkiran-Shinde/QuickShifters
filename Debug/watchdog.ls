   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 53 void Watchdog_Init(void)
  42                     ; 54 {
  44                     	switch	.text
  45  0000               _Watchdog_Init:
  49                     ; 63     IWDG_KR = IWDG_KEY_ENABLE;
  51  0000 35cc50e0      	mov	20704,#204
  52                     ; 71     IWDG_KR = IWDG_KEY_ACCESS;
  54  0004 355550e0      	mov	20704,#85
  55                     ; 79     IWDG_PR = IWDG_PRESCALER;
  57  0008 350650e1      	mov	20705,#6
  58                     ; 87     IWDG_RLR = IWDG_RELOAD;
  60  000c 35ff50e2      	mov	20706,#255
  61                     ; 98     IWDG_KR = IWDG_KEY_REFRESH;
  63  0010 35aa50e0      	mov	20704,#170
  64                     ; 99 }
  67  0014 81            	ret
  90                     ; 106 void Watchdog_Refresh(void)
  90                     ; 107 {
  91                     	switch	.text
  92  0015               _Watchdog_Refresh:
  96                     ; 111     IWDG_KR = IWDG_KEY_REFRESH;
  98  0015 35aa50e0      	mov	20704,#170
  99                     ; 112 }
 102  0019 81            	ret
 115                     	xdef	_Watchdog_Refresh
 116                     	xdef	_Watchdog_Init
 135                     	end
