   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 5 void CLK_Init(void)
  42                     ; 6 {
  44                     	switch	.text
  45  0000               _CLK_Init:
  49                     ; 9     CLK_CKDIVR = 0x00;
  51  0000 725f50c6      	clr	20678
  52                     ; 10 }
  55  0004 81            	ret
  68                     	xdef	_CLK_Init
  87                     	end
