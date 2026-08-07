#include "button.h"
#include "gpio.h"
#include "config.h"
#include "software_timer.h"

/************************************************
                Configuration
************************************************/

#define BUTTON_DEBOUNCE_TIME    20

/************************************************
                Button States
************************************************/

typedef enum
{
    BUTTON_STATE_RELEASED = 0,

    BUTTON_STATE_DEBOUNCE_PRESS,

    BUTTON_STATE_PRESSED,

    BUTTON_STATE_DEBOUNCE_RELEASE

}ButtonState_t;

/************************************************
                Static Variables
************************************************/

static ButtonState_t currentState;

static SoftwareTimer_t debounceTimer;

static uint8_t pressEvent;

/************************************************
                Initialization
************************************************/

void Button_Init(void)
{
    GPIO_Input_PU(BUTTON_PORT, BUTTON_PIN);

    currentState = BUTTON_STATE_RELEASED;

    pressEvent = FALSE;
}

/************************************************
                Button Update
************************************************/

void Button_Update(void)
{
    switch(currentState)
    {
        /****************************************/
        case BUTTON_STATE_RELEASED:

            if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
            {
                SoftwareTimer_Start(&debounceTimer,
                                    BUTTON_DEBOUNCE_TIME);

                currentState = BUTTON_STATE_DEBOUNCE_PRESS;
            }

            break;

        /****************************************/
        case BUTTON_STATE_DEBOUNCE_PRESS:

            if(SoftwareTimer_Expired(&debounceTimer))
            {
                if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
                {
                    pressEvent = TRUE;

                    currentState = BUTTON_STATE_PRESSED;
                }
                else
                {
                    currentState = BUTTON_STATE_RELEASED;
                }
            }

            break;

        /****************************************/
        case BUTTON_STATE_PRESSED:

            if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
            {
                SoftwareTimer_Start(&debounceTimer,
                                    BUTTON_DEBOUNCE_TIME);

                currentState = BUTTON_STATE_DEBOUNCE_RELEASE;
            }

            break;

        /****************************************/
        case BUTTON_STATE_DEBOUNCE_RELEASE:

            if(SoftwareTimer_Expired(&debounceTimer))
            {
                if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
                {
                    currentState = BUTTON_STATE_RELEASED;
                }
                else
                {
                    currentState = BUTTON_STATE_PRESSED;
                }
            }

            break;

        /****************************************/
        default:

            currentState = BUTTON_STATE_RELEASED;

            break;
    }
}

/************************************************
                Button Event
************************************************/

uint8_t Button_GetPress(void)
{
    if(pressEvent == TRUE)
    {
        pressEvent = FALSE;

        return TRUE;
    }

    return FALSE;
}