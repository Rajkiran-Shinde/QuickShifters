#include "timer.h"
#include "stm8_hw.h"

void TIM4_Init(void)
{
    TIM4_PSCR = 7;      // Divide by 128

    TIM4_ARR = 124;     // 1ms @16MHz

    TIM4_CR1 = 0x01;    // Enable Timer
}

void TIM4_Delay_ms(uint16_t ms)
{
    while(ms--)
    {
        TIM4_SR &= ~(1<<0);

        while(!(TIM4_SR & (1<<0)));

        TIM4_SR &= ~(1<<0);
    }
}