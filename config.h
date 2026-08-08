#ifndef CONFIG_H
#define CONFIG_H

#include "gpio.h"

/************ DEBUG ************/

#define DEBUG_UART_ENABLED    1
#define DEBUG_BAUDRATE        9600

/************ RELAY ************/

#define RELAY_PORT PORT_D
#define RELAY_PIN  PIN2

/************ BUTTON ************/

#define BUTTON_PORT PORT_D
#define BUTTON_PIN  PIN3

//Mode Selection button 
#define MODE_BUTTON_PORT PORT_D
#define MODE_BUTTON_PIN  PIN4

//DEBOUNCE DELAY
#define BUTTON_DEBOUNCE_TIME    20 


/* ============================================================
 * MODE INDICATOR LEDs
 * ============================================================
 *
 * Five individual LEDs indicate the currently selected mode.
 *
 * Mode 1 -> 40 ms
 * Mode 2 -> 50 ms
 * Mode 3 -> 60 ms
 * Mode 4 -> 70 ms
 * Mode 5 -> 80 ms
 *
 * Currently only MODE_LED1 is being implemented/tested.
 * The remaining pins are reserved for the next stages.
 */


/* Mode 1 LED */
#define MODE_LED1_PORT      PORT_D
#define MODE_LED1_PIN       PIN6

/* Mode 2 LED */
#define MODE_LED2_PORT      PORT_A
#define MODE_LED2_PIN       PIN1

/*
 * Mode 3, 4 and 5 will use another GPIO port.
 * These are reserved for the LED expansion stage.
 */
#define MODE_LED3_PORT      PORT_C
#define MODE_LED3_PIN       PIN3

#define MODE_LED4_PORT      PORT_C
#define MODE_LED4_PIN       PIN4

#define MODE_LED5_PORT      PORT_C
#define MODE_LED5_PIN       PIN5


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================
 *
 * RGB LED is used for overall system status.
 *
 * Planned states:
 *
 * OFF    -> System disabled
 * GREEN  -> System ready
 * BLUE   -> Configuration / mode selection
 * RED    -> Fault / safety shutdown
 *
 * The RGB LED will be implemented after the mode LEDs.
 */


/* Red channel */
#define STATUS_LED_R_PORT   PORT_B
#define STATUS_LED_R_PIN    PIN4

/* Green channel */
#define STATUS_LED_G_PORT   PORT_C
#define STATUS_LED_G_PIN    PIN6

/* Blue channel */
#define STATUS_LED_B_PORT   PORT_C
#define STATUS_LED_B_PIN    PIN7


/* ============================================================
 * BUZZER
 * ============================================================
 *
 * Passive buzzer.
 *
 * The buzzer will be implemented using a timer-generated
 * square-wave/PWM signal.
 */
#define BUZZER_PORT         PORT_B
#define BUZZER_PIN          PIN5


/* ============================================================
 * QUICK-SHIFTER MODES
 * ============================================================ */

#define QS_MODE_COUNT       5

#define QS_MODE_1_TIME      40
#define QS_MODE_2_TIME      50
#define QS_MODE_3_TIME      60
#define QS_MODE_4_TIME      70
#define QS_MODE_5_TIME      80


/* ============================================================
 * SAFETY CONFIGURATION
 * ============================================================ */

#define WATCHDOG_TIMEOUT_MS 1000

#endif