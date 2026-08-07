#include "gpio.h"
#include "button.h"
#include "timer.h"
#include "config.h"
#include "clock.h"
#include "quickshifter.h"

int main(void)
{
    CLK_Init();

    TIM4_Init();

    Button_Init();

    QuickShifter_Init();

    while(1)
    {
        QuickShifter_Task();
    }
}