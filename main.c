#include "gpio.h"
#include "button.h"
#include "timer.h"
#include "config.h"
#include "clock.h"
#include "quickshifter.h"
#include "software_timer.h"

int main(void)
{
	
    CLK_Init();

    Timer_Init();

    Button_Init();

    QuickShifter_Init();
		
		__asm ("rim\n");
		
    while(1)
    {
				Button_Update();
        QuickShifter_Task();
    }
		
		
}