#include "uart.h"
#include "stm8_hw.h"

#define UART1_SR      (*(volatile uint8_t*)0x5230)
#define UART1_DR      (*(volatile uint8_t*)0x5231)
#define UART1_BRR1    (*(volatile uint8_t*)0x5232)
#define UART1_BRR2    (*(volatile uint8_t*)0x5233)
#define UART1_CR1     (*(volatile uint8_t*)0x5234)
#define UART1_CR2     (*(volatile uint8_t*)0x5235)
#define UART1_CR3     (*(volatile uint8_t*)0x5236)

/* UART bits */
#define UART_SR_TXE   (1 << 7)

#define UART_CR2_TEN  (1 << 3)

void UART_Init(void)
{
    /*
     * Configure PD5 as UART TX
     *
     * PD5:
     * Output
     * Push-pull
     * Fast mode
     */

    PD_DDR |= (1 << 5);
    PD_CR1 |= (1 << 5);
    PD_CR2 |= (1 << 5);

    /*
 * 16 MHz / 9600 baud
 * 8 data bits
 * No parity
 * 1 stop bit
 */

	UART1_BRR1 = 0x68;
	UART1_BRR2 = 0x02;
	
    UART1_CR1 = 0x00;

    /* Enable transmitter */
    UART1_CR2 = UART_CR2_TEN;
}

void UART_SendChar(char c)
{
    while((UART1_SR & UART_SR_TXE) == 0)
    {
        /* Wait */
    }

    UART1_DR = c;
}

void UART_SendString(const char *str)
{
    while(*str)
    {
        UART_SendChar(*str);
        str++;
    }
}