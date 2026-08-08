   1                     ; C Compiler for STM8 (COSMIC Software)
   2                     ; Parser V4.13.3 - 22 May 2025
   3                     ; Generator (Limited) V4.6.6 - 07 Jan 2026
  42                     ; 17 void UART_Init(void)
  42                     ; 18 {
  44                     	switch	.text
  45  0000               _UART_Init:
  49                     ; 28     PD_DDR |= (1 << 5);
  51  0000 721a5011      	bset	20497,#5
  52                     ; 29     PD_CR1 |= (1 << 5);
  54  0004 721a5012      	bset	20498,#5
  55                     ; 30     PD_CR2 |= (1 << 5);
  57  0008 721a5013      	bset	20499,#5
  58                     ; 39 	UART1_BRR1 = 0x68;
  60  000c 35685232      	mov	21042,#104
  61                     ; 40 	UART1_BRR2 = 0x02;
  63  0010 35025233      	mov	21043,#2
  64                     ; 42     UART1_CR1 = 0x00;
  66  0014 725f5234      	clr	21044
  67                     ; 45     UART1_CR2 = UART_CR2_TEN;
  69  0018 35085235      	mov	21045,#8
  70                     ; 46 }
  73  001c 81            	ret
 107                     ; 48 void UART_SendChar(char c)
 107                     ; 49 {
 108                     	switch	.text
 109  001d               _UART_SendChar:
 111  001d 88            	push	a
 112       00000000      OFST:	set	0
 115  001e               L14:
 116                     ; 50     while((UART1_SR & UART_SR_TXE) == 0)
 118  001e c65230        	ld	a,21040
 119  0021 a580          	bcp	a,#128
 120  0023 27f9          	jreq	L14
 121                     ; 55     UART1_DR = c;
 123  0025 7b01          	ld	a,(OFST+1,sp)
 124  0027 c75231        	ld	21041,a
 125                     ; 56 }
 128  002a 84            	pop	a
 129  002b 81            	ret
 165                     ; 58 void UART_SendString(const char *str)
 165                     ; 59 {
 166                     	switch	.text
 167  002c               _UART_SendString:
 169  002c 89            	pushw	x
 170       00000000      OFST:	set	0
 173  002d 200c          	jra	L56
 174  002f               L36:
 175                     ; 62         UART_SendChar(*str);
 177  002f 1e01          	ldw	x,(OFST+1,sp)
 178  0031 f6            	ld	a,(x)
 179  0032 ade9          	call	_UART_SendChar
 181                     ; 63         str++;
 183  0034 1e01          	ldw	x,(OFST+1,sp)
 184  0036 1c0001        	addw	x,#1
 185  0039 1f01          	ldw	(OFST+1,sp),x
 186  003b               L56:
 187                     ; 60     while(*str)
 189  003b 1e01          	ldw	x,(OFST+1,sp)
 190  003d 7d            	tnz	(x)
 191  003e 26ef          	jrne	L36
 192                     ; 65 }
 195  0040 85            	popw	x
 196  0041 81            	ret
 209                     	xdef	_UART_SendString
 210                     	xdef	_UART_SendChar
 211                     	xdef	_UART_Init
 230                     	end
