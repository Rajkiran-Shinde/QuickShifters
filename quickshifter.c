#include "quickshifter.h"
#include "button.h"
#include "gpio.h"
#include "timer.h"
#include "config.h"
#include "mode.h"



//State Machine
static QuickShifterState_t currentState;

static SoftwareTimer_t relayTimer;

static SoftwareTimer_t cooldownTimer;

void QuickShifter_Init(void)
{
    GPIO_Output_PP(RELAY_PORT, RELAY_PIN);
		
		GPIO_Clear(RELAY_PORT, RELAY_PIN);

    currentState = QS_STATE_IDLE;
}

//Switch Statements for the sate machine 
void QuickShifter_Task(void)
{
    switch(currentState)
    {
        /*------------------------------*/
        case QS_STATE_IDLE:

            if(Button_GetPress())
            {
                GPIO_Set(RELAY_PORT, RELAY_PIN);

                SoftwareTimer_Start(&relayTimer, Mode_GetCutTime());

                currentState = QS_STATE_CUT_ACTIVE;
            }

            break;

        /*------------------------------*/
        case QS_STATE_CUT_ACTIVE:

            if(SoftwareTimer_Expired(&relayTimer))
            {
                GPIO_Clear(RELAY_PORT, RELAY_PIN);

                SoftwareTimer_Start(&cooldownTimer,100);

                currentState = QS_STATE_COOLDOWN;
            }

            break;

        /*------------------------------*/
        case QS_STATE_COOLDOWN:

            if(SoftwareTimer_Expired(&cooldownTimer))
            {
                currentState = QS_STATE_WAIT_RELEASE;
            }

            break;

        /*------------------------------*/
        case QS_STATE_WAIT_RELEASE:

            if(GPIO_Read(BUTTON_PORT,BUTTON_PIN)==TRUE)
            {
                currentState = QS_STATE_IDLE;
            }

            break;

        /*------------------------------*/
        default:

            currentState = QS_STATE_IDLE;

            break;
    }
}