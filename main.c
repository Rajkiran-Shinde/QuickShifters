#include "gpio.h"
#include "button.h"
#include "timer.h"
#include "config.h"
#include "clock.h"
#include "quickshifter.h"
#include "software_timer.h"
#include "mode.h"
#include "eeprom.h"

//Debug
#include "debug.h"

//static uint32_t lastDebugTick = 0; //The one Second Test 

int main(void)
{
    CLK_Init();

Timer_Init();

Button_Init();

ModeButton_Init();

Debug_Init();

EEPROM_Init();

Mode_Init();

Debug_LogMode(
    Mode_Get(),
    Mode_GetCutTime()
);

QuickShifter_Init();

__asm ("rim\n");

    while(1)
    {
        Button_Update();

        ModeButton_Update();

        QuickShifter_Task();

        if(ModeButton_GetPress())
        {
            Mode_Next();

            Debug_LogMode(
                Mode_Get(),
                Mode_GetCutTime()
            );
        }
				/*
				if((Timer_GetTick() - lastDebugTick) >= 1000)
				{
				lastDebugTick = Timer_GetTick();

				Debug_Log("[TIMER] 1 second elapsed\r\n");
				}*/		//One second test 
    }
		
}