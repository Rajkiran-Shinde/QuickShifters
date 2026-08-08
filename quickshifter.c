#include "quickshifter.h"
#include "button.h"
#include "relay.h"
#include "timer.h"
#include "mode.h"


/************************************************
                QUICKSHIFTER STATE
************************************************/

static QuickShifterState_t currentState;

static SoftwareTimer_t relayTimer;

static SoftwareTimer_t cooldownTimer;


/************************************************
                INITIALIZATION
************************************************/

void QuickShifter_Init(void)
{
    /*
     * Initialize relay hardware.
     *
     * Relay_Init() guarantees that the relay
     * starts in the OFF state.
     */
    Relay_Init();

    /*
     * Always start the QuickShifter state machine
     * in a known safe state.
     */
    currentState = QS_STATE_IDLE;
}


/************************************************
                QUICKSHIFTER TASK
************************************************/

void QuickShifter_Task(void)
{
    switch(currentState)
    {
        /****************************************
                    IDLE
        ****************************************/

        case QS_STATE_IDLE:

            /*
             * Relay must be OFF while idle.
             *
             * This is a safety invariant.
             */
            if(Button_GetPress())
            {
                /*
                 * A valid debounced press has occurred.
                 */

                Relay_On();

                /*
                 * Load the currently selected
                 * QuickShifter cut duration.
                 */
                SoftwareTimer_Start(
                    &relayTimer,
                    Mode_GetCutTime()
                );

                currentState =
                    QS_STATE_CUT_ACTIVE;
            }

            break;


        /****************************************
                    CUT ACTIVE
        ****************************************/

        case QS_STATE_CUT_ACTIVE:

            /*
             * Relay remains ON during the cut.
             *
             * We don't repeatedly call Relay_On()
             * because it was already activated when
             * entering this state.
             */

            if(SoftwareTimer_Expired(&relayTimer))
            {
                /*
                 * Cut duration has expired.
                 *
                 * Immediately disable the relay.
                 */
                Relay_Off();

                /*
                 * Start a short cooldown period
                 * to prevent immediate retriggering.
                 */
                SoftwareTimer_Start(
                    &cooldownTimer,
                    100
                );

                currentState =
                    QS_STATE_COOLDOWN;
            }

            break;


        /****************************************
                    COOLDOWN
        ****************************************/

        case QS_STATE_COOLDOWN:

            /*
             * Relay was already turned OFF when
             * entering this state.
             *
             * Ignore additional shift presses.
             */

            if(SoftwareTimer_Expired(&cooldownTimer))
            {
                currentState =
                    QS_STATE_WAIT_RELEASE;
            }

            break;


        /****************************************
                    WAIT RELEASE
        ****************************************/

        case QS_STATE_WAIT_RELEASE:

            /*
             * Wait until the debounced shift button
             * is actually released.
             *
             * This prevents one long button press
             * from generating multiple cuts.
             */
            if(Button_IsPressed() == FALSE)
            {
                currentState =
                    QS_STATE_IDLE;
            }

            break;


        /****************************************
                    INVALID STATE
        ****************************************/

        default:

            /*
             * Fail-safe behavior.
             *
             * If the state machine ever reaches an
             * invalid state, immediately disable
             * the relay.
             */
            Relay_Off();

            currentState =
                QS_STATE_IDLE;

            break;
    }
}