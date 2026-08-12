#ifndef CONFIG_H
#define CONFIG_H

#include "gpio.h"

#define DEBUG_UART_ENABLED    1
#define DEBUG_BAUDRATE        9600

#define RELAY_PORT            PORT_D
#define RELAY_PIN             PIN2

#define BUTTON_PORT           PORT_D
#define BUTTON_PIN            PIN3

#define MODE_BUTTON_PORT      PORT_D
#define MODE_BUTTON_PIN       PIN4

#define BUTTON_DEBOUNCE_TIME 20

/* Mode indicator LEDs */
#define MODE_LED1_PORT       PORT_D
#define MODE_LED1_PIN        PIN6

#define MODE_LED2_PORT       PORT_A
#define MODE_LED2_PIN        PIN1

#define MODE_LED3_PORT       PORT_C
#define MODE_LED3_PIN        PIN3

#define MODE_LED4_PORT       PORT_C
#define MODE_LED4_PIN        PIN4

#define MODE_LED5_PORT       PORT_C
#define MODE_LED5_PIN        PIN5

/* System LED
 * Single LED:
 * Anode -> 3.3V
 * Cathode -> PC6
 * LOW = ON, HIGH = OFF
 *
 * PB4 and PC7 are not used by the LED driver.
 */
#define SYSTEM_LED_PORT      PORT_C
#define SYSTEM_LED_PIN       PIN6

#define BUZZER_PORT          PORT_A
#define BUZZER_PIN           PIN3

#define QS_MODE_COUNT        5
#define QS_MODE_1_TIME       40
#define QS_MODE_2_TIME       50
#define QS_MODE_3_TIME       60
#define QS_MODE_4_TIME       70
#define QS_MODE_5_TIME       80

#define WATCHDOG_TIMEOUT_MS  1000

#endif /* CONFIG_H */