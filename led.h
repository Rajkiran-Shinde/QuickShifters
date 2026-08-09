#ifndef LED_H
#define LED_H

#include "common.h"


/* ============================================================
 * LED INITIALIZATION
 * ============================================================ */

void LED_Init(void);


/* ============================================================
 * MODE LED CONTROL
 * ============================================================ */

/*
 * mode:
 *
 * 1 -> Mode LED 1
 * 2 -> Mode LED 2
 * 3 -> Mode LED 3
 * 4 -> Mode LED 4
 * 5 -> Mode LED 5
 *
 * state:
 *
 * TRUE  -> ON
 * FALSE -> OFF
 */
void LED_Mode_Set(uint8_t mode, uint8_t state);


/*
 * Turn all mode LEDs OFF.
 */
void LED_Mode_AllOff(void);


/*
 * Display the selected mode.
 *
 * Only the LED corresponding to the selected
 * mode will remain ON.
 */
void LED_Mode_Display(uint8_t mode);


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================ */

/*
 * Turn RGB status LED OFF.
 */
void LED_Status_Off(void);


/*
 * Red status.
 */
void LED_Status_Red(void);


/*
 * Green status.
 */
void LED_Status_Green(void);


/*
 * Blue status.
 */
void LED_Status_Blue(void);


/*
 * Red + Green = Yellow.
 */
void LED_Status_Yellow(void);


/*
 * Red + Blue = Purple.
 */
void LED_Status_Purple(void);


#endif /* LED_H */