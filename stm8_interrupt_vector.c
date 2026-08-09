/*
    BASIC INTERRUPT VECTOR TABLE FOR STM8 devices
*/

#include "timer.h"
#include "stm8_hw.h"
#include "buzzer.h"

typedef void @far (*interrupt_handler_t)(void);

struct interrupt_vector
{
    unsigned char interrupt_instruction;
    interrupt_handler_t interrupt_handler;
};

@far @interrupt void NonHandledInterrupt(void)
{
    /* Unexpected interrupt */
    return;
}

/* Startup routine */
extern void _stext(void);

/*----------------------------------------------------------
    TIM2 Update / Overflow Interrupt
----------------------------------------------------------*/
INTERRUPT_HANDLER(TIM2_UPD_OVF_BRK_IRQHandler, 13)
{
    Buzzer_TickISR();
}

/*----------------------------------------------------------
    TIM4 Update / Overflow Interrupt
----------------------------------------------------------*/
INTERRUPT_HANDLER(TIM4_UPD_OVF_IRQHandler, 23)
{
    /* Clear Update Interrupt Flag */
    TIM4_SR &= (uint8_t)(~0x01);

    /* Update 1ms system tick */
    Timer_TickISR();
}

/*----------------------------------------------------------
    Interrupt Vector Table
----------------------------------------------------------*/
struct interrupt_vector const _vectab[] =
{
    {0x82, (interrupt_handler_t)_stext},               /* reset */
    {0x82, NonHandledInterrupt},                       /* trap  */
    {0x82, NonHandledInterrupt},                       /* irq0  */
    {0x82, NonHandledInterrupt},                       /* irq1  */
    {0x82, NonHandledInterrupt},                       /* irq2  */
    {0x82, NonHandledInterrupt},                       /* irq3  */
    {0x82, NonHandledInterrupt},                       /* irq4  */
    {0x82, NonHandledInterrupt},                       /* irq5  */
    {0x82, NonHandledInterrupt},                       /* irq6  */
    {0x82, NonHandledInterrupt},                       /* irq7  */
    {0x82, NonHandledInterrupt},                       /* irq8  */
    {0x82, NonHandledInterrupt},                       /* irq9  */
    {0x82, NonHandledInterrupt},                       /* irq10 */
    {0x82, NonHandledInterrupt},                       /* irq11 */
    {0x82, NonHandledInterrupt},                       /* irq12 */
		{0x82, TIM2_UPD_OVF_BRK_IRQHandler},               /* irq13 : TIM2 Update/Overflow */
    {0x82, NonHandledInterrupt},                       /* irq14 */
    {0x82, NonHandledInterrupt},                       /* irq15 */
    {0x82, NonHandledInterrupt},                       /* irq16 */
    {0x82, NonHandledInterrupt},                       /* irq17 */
    {0x82, NonHandledInterrupt},                       /* irq18 */
    {0x82, NonHandledInterrupt},                       /* irq19 */
    {0x82, NonHandledInterrupt},                       /* irq20 */
    {0x82, NonHandledInterrupt},                       /* irq21 */
    {0x82, NonHandledInterrupt},                       /* irq22 */

    {0x82, TIM4_UPD_OVF_IRQHandler},                   /* irq23 : TIM4 Update/Overflow */

    {0x82, NonHandledInterrupt},                       /* irq24 */
    {0x82, NonHandledInterrupt},                       /* irq25 */
    {0x82, NonHandledInterrupt},                       /* irq26 */
    {0x82, NonHandledInterrupt},                       /* irq27 */
    {0x82, NonHandledInterrupt},                       /* irq28 */
    {0x82, NonHandledInterrupt}                        /* irq29 */
};