#include "gpio.h"
#include "button.h"
#include "timer.h"
#include "config.h"
#include "clock.h"
#include "quickshifter.h"
#include "software_timer.h"
#include "mode.h"
#include "eeprom.h"
#include "watchdog.h"
#include "led.h"
#include "buzzer.h"

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

LED_Init();

Buzzer_Init();

EEPROM_Init();

Mode_Init();

LED_Mode_Display(Mode_Get() + 1);

Debug_LogMode(
    Mode_Get(),
    Mode_GetCutTime()
);

QuickShifter_Init();

Buzzer_Play(BUZZER_EVENT_BOOT);

Watchdog_Init();

__asm ("rim\n");

    while(1)
    {
        Button_Update();

        ModeButton_Update();

        QuickShifter_Task();
				
				Buzzer_Task();
				
				Watchdog_Refresh();
				
				/* ================================================
 * MODE CHANGE
 * ================================================ */

if(ModeButton_GetPress())
{
    /*
     * Change mode.
     */
    Mode_Next();


    /*
     * Update mode LED.
     */
    LED_Mode_Display(
        Mode_Get() + 1
    );


    /*
     * Play mode-change confirmation sound.
     */
    Buzzer_Play(
        BUZZER_EVENT_MODE_CHANGE
    );


    /*
     * Debug information.
     */
    Debug_LogMode(
        Mode_Get(),
        Mode_GetCutTime()
    );
}


/* ================================================
 * QUICKSHIFTER
 * ================================================ */

QuickShifter_Task();


/* ================================================
 * BUZZER
 * ================================================ */

Buzzer_Task();


/* ================================================
 * WATCHDOG
 * ================================================ */

Watchdog_Refresh();
				/*
				if((Timer_GetTick() - lastDebugTick) >= 1000)
				{
				lastDebugTick = Timer_GetTick();

				Debug_Log("[TIMER] 1 second elapsed\r\n");
				}*/		//One second test 
    }
		
		
}