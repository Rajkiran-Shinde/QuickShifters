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

int main(void)
{
    CLK_Init();

    Timer_Init();

    Button_Init();

    ModeButton_Init();

    Debug_Init();

    EEPROM_Init();

    Mode_Init();

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
    }
}