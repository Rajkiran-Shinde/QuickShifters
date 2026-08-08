#include "gpio.h"
#include "button.h"
#include "timer.h"
#include "config.h"
#include "clock.h"
#include "quickshifter.h"
#include "software_timer.h"
#include "mode.h"

//Debug
#include "debug.h"

int main(void)
{
	
    CLK_Init();

    Timer_Init();

    Button_Init();
		
		ModeButton_Init();

		Mode_Init(); //Mode Initilize 
		
    QuickShifter_Init();
		
		
		//Debug Call
		Debug_Init();// Remove In final Deployment 
		Debug_Log("STM8 UART TEST\r\n");
		Debug_Log("QuickShifter Debug Started\r\n");
		
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