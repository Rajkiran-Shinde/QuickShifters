#ifndef LED_H
#define LED_H

#include "common.h"

void LED_Init(void);

/* System LED on PC6: anode -> 3.3V, cathode -> PC6. */
void LED_System_On(void);
void LED_System_Off(void);

void LED_Mode_Set(uint8_t mode, uint8_t state);
void LED_Mode_AllOff(void);
void LED_Mode_Display(uint8_t mode);

#endif /* LED_H */