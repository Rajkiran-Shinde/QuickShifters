#include "quickshifter.h"
#include "button.h"
#include "gpio.h"
#include "timer.h"
#include "config.h"

#define SHIFT_TIME_MS   40

void QuickShifter_Init(void)
{
    GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
}

void QuickShifter_Task(void)
{
    if(Button_GetPress())
    {
        GPIO_Set(RELAY_PORT, RELAY_PIN);

        TIM4_Delay_ms(SHIFT_TIME_MS);

        GPIO_Clear(RELAY_PORT, RELAY_PIN);
    }
}