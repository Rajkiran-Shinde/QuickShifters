#include "button.h"
#include "gpio.h"
#include "timer.h"
#include "config.h"

void Button_Init(void)
{
    GPIO_Input_PU(BUTTON_PORT,BUTTON_PIN);
}

uint8_t Button_GetPress(void)
{
    if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE)
    {
        TIM4_Delay_ms(20);

        if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE)
        {
            while(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==FALSE);

            TIM4_Delay_ms(20);

            return TRUE;
        }
    }

    return FALSE;
}