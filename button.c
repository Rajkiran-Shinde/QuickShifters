#include "button.h"
#include "gpio.h"
#include "config.h"
#include "software_timer.h"
#include "mode.h"


/************************************************
                Configuration
************************************************/

//#define BUTTON_DEBOUNCE_TIME    20


/************************************************
                SHIFT BUTTON
************************************************/

typedef enum
{
    BUTTON_STATE_RELEASED = 0,

    BUTTON_STATE_DEBOUNCE_PRESS,

    BUTTON_STATE_PRESSED,

    BUTTON_STATE_DEBOUNCE_RELEASE

} ButtonState_t;


static ButtonState_t currentState;

static SoftwareTimer_t debounceTimer;

static uint8_t pressEvent;


/************************************************
                SHIFT BUTTON
                Initialization
************************************************/

void Button_Init(void)
{
    GPIO_Input_PU(BUTTON_PORT, BUTTON_PIN);

    currentState = BUTTON_STATE_RELEASED;

    pressEvent = FALSE;
}


/************************************************
                SHIFT BUTTON
                Update
************************************************/

void Button_Update(void)
{
    switch(currentState)
    {
        case BUTTON_STATE_RELEASED:

            if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
            {
                SoftwareTimer_Start(&debounceTimer,
                                    BUTTON_DEBOUNCE_TIME);

                currentState =
                    BUTTON_STATE_DEBOUNCE_PRESS;
            }

            break;


        case BUTTON_STATE_DEBOUNCE_PRESS:

            if(SoftwareTimer_Expired(&debounceTimer))
            {
                if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == FALSE)
                {
                    pressEvent = TRUE;

                    currentState =
                        BUTTON_STATE_PRESSED;
                }
                else
                {
                    currentState =
                        BUTTON_STATE_RELEASED;
                }
            }

            break;


        case BUTTON_STATE_PRESSED:

            if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
            {
                SoftwareTimer_Start(&debounceTimer,
                                    BUTTON_DEBOUNCE_TIME);

                currentState =
                    BUTTON_STATE_DEBOUNCE_RELEASE;
            }

            break;


        case BUTTON_STATE_DEBOUNCE_RELEASE:

            if(SoftwareTimer_Expired(&debounceTimer))
            {
                if(GPIO_Read(BUTTON_PORT, BUTTON_PIN) == TRUE)
                {
                    currentState =
                        BUTTON_STATE_RELEASED;
                }
                else
                {
                    currentState =
                        BUTTON_STATE_PRESSED;
                }
            }

            break;


        default:

            currentState =
                BUTTON_STATE_RELEASED;

            break;
    }
}


/************************************************
                SHIFT BUTTON
                Event
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

uint8_t Button_IsPressed(void)
{
    if(currentState == BUTTON_STATE_PRESSED)
    {
        return TRUE;
    }

    return FALSE;
}

/************************************************
                MODE BUTTON
************************************************/

typedef enum
{
    MODE_BUTTON_STATE_RELEASED = 0,

    MODE_BUTTON_STATE_DEBOUNCE_PRESS,

    MODE_BUTTON_STATE_PRESSED,

    MODE_BUTTON_STATE_DEBOUNCE_RELEASE

} ModeButtonState_t;


static ModeButtonState_t modeButtonState;

static SoftwareTimer_t modeButtonDebounceTimer;

static uint8_t modeButtonPressEvent;


/************************************************
                MODE BUTTON
                Initialization
************************************************/

void ModeButton_Init(void)
{
    GPIO_Input_PU(MODE_BUTTON_PORT,
                  MODE_BUTTON_PIN);

    modeButtonState =
        MODE_BUTTON_STATE_RELEASED;

    modeButtonPressEvent = FALSE;
}


/************************************************
                MODE BUTTON
                Update
************************************************/

void ModeButton_Update(void)
{
    switch(modeButtonState)
    {
        case MODE_BUTTON_STATE_RELEASED:

            if(GPIO_Read(MODE_BUTTON_PORT,
                         MODE_BUTTON_PIN) == FALSE)
            {
                SoftwareTimer_Start(
                    &modeButtonDebounceTimer,
                    BUTTON_DEBOUNCE_TIME);

                modeButtonState =
                    MODE_BUTTON_STATE_DEBOUNCE_PRESS;
            }

            break;


        case MODE_BUTTON_STATE_DEBOUNCE_PRESS:

            if(SoftwareTimer_Expired(
                    &modeButtonDebounceTimer))
            {
                if(GPIO_Read(MODE_BUTTON_PORT,
                             MODE_BUTTON_PIN) == FALSE)
                {
                    modeButtonPressEvent = TRUE;

                    modeButtonState =
                        MODE_BUTTON_STATE_PRESSED;
                }
                else
                {
                    modeButtonState =
                        MODE_BUTTON_STATE_RELEASED;
                }
            }

            break;


        case MODE_BUTTON_STATE_PRESSED:

            if(GPIO_Read(MODE_BUTTON_PORT,
                         MODE_BUTTON_PIN) == TRUE)
            {
                SoftwareTimer_Start(
                    &modeButtonDebounceTimer,
                    BUTTON_DEBOUNCE_TIME);

                modeButtonState =
                    MODE_BUTTON_STATE_DEBOUNCE_RELEASE;
            }

            break;


        case MODE_BUTTON_STATE_DEBOUNCE_RELEASE:

            if(SoftwareTimer_Expired(
                    &modeButtonDebounceTimer))
            {
                if(GPIO_Read(MODE_BUTTON_PORT,
                             MODE_BUTTON_PIN) == TRUE)
                {
                    modeButtonState =
                        MODE_BUTTON_STATE_RELEASED;
                }
                else
                {
                    modeButtonState =
                        MODE_BUTTON_STATE_PRESSED;
                }
            }

            break;


        default:

            modeButtonState =
                MODE_BUTTON_STATE_RELEASED;

            break;
    }
}


/************************************************
                MODE BUTTON
                Event
************************************************/

uint8_t ModeButton_GetPress(void)
{
    if(modeButtonPressEvent == TRUE)
    {
        modeButtonPressEvent = FALSE;

        return TRUE;
    }

    return FALSE;
}