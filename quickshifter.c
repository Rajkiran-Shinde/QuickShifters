#include "quickshifter.h"
#include "button.h"
#include "relay.h"
#include "timer.h"
#include "mode.h"
#include "debug.h"
#include "buzzer.h"


/************************************************
                SAFETY LIMIT
************************************************/

/*
 * Maximum amount of time the relay is allowed
 * to remain ON during a QuickShifter cut.
 *
 * Normal modes:
 *
 * Mode 1 -> 40 ms
 * Mode 2 -> 50 ms
 * Mode 3 -> 60 ms
 * Mode 4 -> 70 ms
 * Mode 5 -> 80 ms
 *
 * Safety limit:
 *
 * 100 ms
 *
 * If the normal cut timer somehow fails to
 * expire, this timer provides an independent
 * maximum ON-time protection.
 */
#define QS_MAX_CUT_TIME_MS    100


/************************************************
                QUICKSHIFTER STATE
************************************************/

static QuickShifterState_t currentState;


/************************************************
                SOFTWARE TIMERS
************************************************/

/*
 * Normal QuickShifter cut timer.
 *
 * Controls the actual selected cut duration:
 *
 * 40 / 50 / 60 / 70 / 80 ms
 */
static SoftwareTimer_t relayTimer;


/*
 * Cooldown timer.
 *
 * Prevents immediate retriggering after a cut.
 */
static SoftwareTimer_t cooldownTimer;


/*
 * Safety timer.
 *
 * Independent maximum relay ON-time protection.
 */
static SoftwareTimer_t safetyTimer;


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
             * A valid debounced button press
             * starts a new QuickShifter cut.
             */
            if(Button_GetPress())
            {
                /*
                 * A valid debounced press has occurred.
                 */
								 Buzzer_Play(BUZZER_EVENT_SHIFT);

                Relay_On();


                /*
                 * Start the normal QuickShifter
                 * cut timer.
                 *
                 * Duration comes from the current
                 * selected mode.
                 *
                 * 40 / 50 / 60 / 70 / 80 ms
                 */
                SoftwareTimer_Start(
                    &relayTimer,
                    Mode_GetCutTime()
                );


                /*
                 * Start the independent safety timer.
                 *
                 * Even if the normal timer fails,
                 * the relay must not remain ON longer
                 * than QS_MAX_CUT_TIME_MS.
                 */
                SoftwareTimer_Start(
                    &safetyTimer,
                    QS_MAX_CUT_TIME_MS
                );


                /*
                 * Enter active cut state.
                 */
                currentState =
                    QS_STATE_CUT_ACTIVE;
            }

            break;


        /****************************************
                    CUT ACTIVE
        ****************************************/

        case QS_STATE_CUT_ACTIVE:

            /*
             * Relay is currently ON.
             *
             * Two timers are running:
             *
             * 1. relayTimer
             *    -> normal 40-80 ms cut
             *
             * 2. safetyTimer
             *    -> absolute 100 ms limit
             */


            /************************************
                    SAFETY TIMER CHECK
            ************************************/

            /*
             * Check the safety timer FIRST.
             *
             * If this expires, something has gone
             * wrong with the normal timing path.
             */
            if(SoftwareTimer_Expired(&safetyTimer))
            {
                /*
                 * EMERGENCY ACTION:
                 *
                 * Immediately turn the relay OFF.
                 */
                Relay_Off();


                /*
                 * Report the fault through UART.
                 */
                Debug_Log(
                    "[FAULT] Maximum cut time exceeded\r\n"
                );


                /*
                 * Enter latched FAULT state.
                 */
                currentState =
                    QS_STATE_FAULT;

                break;
            }


            /************************************
                    NORMAL TIMER CHECK
            ************************************/

            /*
             * Check the normal QuickShifter timer.
             */
            if(SoftwareTimer_Expired(&relayTimer))
            {
                /*
                 * Normal cut duration has expired.
                 *
                 * Immediately disable the relay.
                 */
                Relay_Off();


                /*
                 * Start the cooldown period.
                 *
                 * This prevents an immediate
                 * retrigger after the cut.
                 */
                SoftwareTimer_Start(
                    &cooldownTimer,
                    100
                );


                /*
                 * Move to cooldown state.
                 */
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
             * Additional shift presses are ignored
             * during cooldown.
             */

            if(SoftwareTimer_Expired(&cooldownTimer))
            {
                /*
                 * Cooldown finished.
                 *
                 * Now wait for the original button
                 * press to be completely released.
                 */
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
                    FAULT
        ****************************************/

        case QS_STATE_FAULT:

            /*
             * FAIL-SAFE STATE
             *
             * Relay MUST remain OFF.
             *
             * No further QuickShifter cuts are
             * allowed while the system is in FAULT.
             */
            Relay_Off();

            break;


        /****************************************
                    INVALID STATE
        ****************************************/

        default:

            /*
             * FAIL-SAFE BEHAVIOR
             *
             * If the state machine ever reaches
             * an invalid state:
             *
             * 1. Turn relay OFF immediately.
             * 2. Return to a known safe state.
             */
            Relay_Off();

            currentState =
                QS_STATE_IDLE;

            break;
    }
}