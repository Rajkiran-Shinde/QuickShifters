#ifndef CONFIG_H
#define CONFIG_H

#include "gpio.h"


/************ DEBUG ************/

#define DEBUG_UART_ENABLED    1
#define DEBUG_BAUDRATE        9600


/************ RELAY ************/

#define RELAY_PORT            PORT_D
#define RELAY_PIN             PIN2


/************ BUTTON ************/

#define BUTTON_PORT           PORT_D
#define BUTTON_PIN            PIN3

/* Mode Selection button */
#define MODE_BUTTON_PORT      PORT_D
#define MODE_BUTTON_PIN       PIN4


/************ DEBOUNCE ************/

#define BUTTON_DEBOUNCE_TIME 20


/* ============================================================
 * MODE INDICATOR LEDs
 * ============================================================
 *
 * Mode 1 -> 40 ms
 * Mode 2 -> 50 ms
 * Mode 3 -> 60 ms
 * Mode 4 -> 70 ms
 * Mode 5 -> 80 ms
 *
 * All five mode LEDs are blue.
 * Only the LED corresponding to the current mode is ON.
 */


/* Mode 1 */
#define MODE_LED1_PORT       PORT_D
#define MODE_LED1_PIN        PIN6


/* Mode 2 */
#define MODE_LED2_PORT       PORT_A
#define MODE_LED2_PIN        PIN1


/* Mode 3 */
#define MODE_LED3_PORT       PORT_C
#define MODE_LED3_PIN        PIN3


/* Mode 4 */
#define MODE_LED4_PORT       PORT_C
#define MODE_LED4_PIN        PIN4


/* Mode 5 */
#define MODE_LED5_PORT       PORT_C
#define MODE_LED5_PIN        PIN5


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================
 *
 * RGB LED configuration:
 *
 * Red   -> PB4
 * Green -> PC6
 * Blue  -> PC7
 *
 * IMPORTANT:
 * The RGB LED is assumed to be COMMON ANODE.
 *
 * Common Anode -> +3.3V
 *
 * Therefore:
 *
 * GPIO LOW  -> LED ON
 * GPIO HIGH -> LED OFF
 */


/* Red channel */
#define STATUS_LED_R_PORT    PORT_B
#define STATUS_LED_R_PIN     PIN4


/* Green channel */
#define STATUS_LED_G_PORT    PORT_C
#define STATUS_LED_G_PIN     PIN6


/* Blue channel */
#define STATUS_LED_B_PORT    PORT_C
#define STATUS_LED_B_PIN     PIN7


/* ============================================================
 * BUZZER
 * ============================================================
 *
 * Passive buzzer.
 * To be implemented using timer-generated signal.
 */

#define BUZZER_PORT          PORT_A
#define BUZZER_PIN           PIN3


/* ============================================================
 * QUICK-SHIFTER MODES
 * ============================================================ */

#define QS_MODE_COUNT        5

#define QS_MODE_1_TIME       40
#define QS_MODE_2_TIME       50
#define QS_MODE_3_TIME       60
#define QS_MODE_4_TIME       70
#define QS_MODE_5_TIME       80


/* ============================================================
 * SAFETY CONFIGURATION
 * ============================================================ */

#define WATCHDOG_TIMEOUT_MS  1000


#endif /* CONFIG_H */