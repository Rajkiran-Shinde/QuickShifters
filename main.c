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
#include "debug.h"

int main(void)
{
    CLK_Init();
    Timer_Init();

    Button_Init();
    ModeButton_Init();

    Debug_Init();

    /* Initializes mode LEDs and turns the PC6 system LED ON. */
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

        if(ModeButton_GetPress())
        {
            Mode_Next();

            LED_Mode_Display(
                Mode_Get() + 1
            );

            Buzzer_Play(
                BUZZER_EVENT_MODE_CHANGE
            );

            Debug_LogMode(
                Mode_Get(),
                Mode_GetCutTime()
            );
        }

        QuickShifter_Task();
        Buzzer_Task();
        Watchdog_Refresh();
    }
}