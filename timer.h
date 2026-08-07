#ifndef TIMER_H
#define TIMER_H

#include "common.h"

/*=============================
    Public Functions
==============================*/

/* Initialize TIM4 for 1ms system tick */
void Timer_Init(void);

/* Returns system tick in milliseconds */
uint32_t Timer_GetTick(void);

/* Blocking delay (for initialization/debug only) */
void Timer_Delay(uint32_t ms);

/* Called from TIM4 ISR */
void Timer_TickISR(void);

#endif