#include "timer.h"

/*=============================
        TIM4 Registers
==============================*/

#define TIM4_CR1        (*(volatile uint8_t*)0x5340)
#define TIM4_IER        (*(volatile uint8_t*)0x5343)
#define TIM4_SR         (*(volatile uint8_t*)0x5344)
#define TIM4_CNTR       (*(volatile uint8_t*)0x5346)
#define TIM4_PSCR       (*(volatile uint8_t*)0x5347)
#define TIM4_ARR        (*(volatile uint8_t*)0x5348)

/*=============================
        Bit Definitions
==============================*/

#define TIM4_CR1_CEN        (1 << 0)

#define TIM4_IER_UIE        (1 << 0)

#define TIM4_SR_UIF         (1 << 0)

/*=============================
        System Tick
==============================*/

volatile uint32_t system_tick = 0;

/*=============================
        Timer Initialization
==============================*/

void Timer_Init(void)
{
    /* Stop Timer */
    TIM4_CR1 = 0x00;

    /*
        CPU Clock = 16 MHz

        Prescaler = 128

        Timer Clock = 125 kHz

        ARR = 124

        Interrupt = 1 ms
    */

    TIM4_PSCR = 0x07;     // Divide by 128
    TIM4_ARR  = 124;

    TIM4_CNTR = 0;

    /* Clear Pending Interrupt Flag */
    TIM4_SR &= (uint8_t)(~TIM4_SR_UIF);

    /* Enable Update Interrupt */
    TIM4_IER |= TIM4_IER_UIE;

    /* Start Timer */
    TIM4_CR1 |= TIM4_CR1_CEN;
}

/*=============================
        Tick Function
==============================*/

void Timer_TickISR(void)
{
    system_tick++;
}

/*=============================
        Get Tick
==============================*/

uint32_t Timer_GetTick(void)
{
    uint32_t tick;

    __asm("sim");

    tick = system_tick;

    __asm("rim");

    return tick;
}

/*=============================
        Blocking Delay
==============================*/

void Timer_Delay(uint32_t ms)
{
    uint32_t start = Timer_GetTick();

    while((Timer_GetTick() - start) < ms)
    {

    }
}