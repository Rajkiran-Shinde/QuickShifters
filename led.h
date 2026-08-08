#ifndef LED_H
#define LED_H

#include "common.h"


/* ============================================================
 * LED INITIALIZATION
 * ============================================================ */

/*
 * Initialize all LED GPIOs.
 *
 * At startup all LEDs are placed in the safe/OFF state.
 */
void LED_Init(void);


/* ============================================================
 * MODE LED CONTROL
 * ============================================================ */

/*
 * Turn a specific mode LED ON or OFF.
 *
 * mode:
 *     1 -> Mode LED 1
 *     2 -> Mode LED 2
 *     3 -> Mode LED 3
 *     4 -> Mode LED 4
 *     5 -> Mode LED 5
 *
 * state:
 *     TRUE  -> ON
 *     FALSE -> OFF
 */
void LED_Mode_Set(uint8_t mode, uint8_t state);


/*
 * Turn all mode LEDs OFF.
 */
void LED_Mode_AllOff(void);


/*
 * Display the currently selected mode.
 *
 * Example:
 *
 * Mode 1 -> LED1 ON
 * Mode 2 -> LED2 ON
 * ...
 * Mode 5 -> LED5 ON
 */
void LED_Mode_Display(uint8_t mode);


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================ */

void LED_Status_Off(void);

void LED_Status_Red(void);

void LED_Status_Green(void);

void LED_Status_Blue(void);

void LED_Status_Yellow(void);

void LED_Status_Purple(void);


#endif /* LED_H */