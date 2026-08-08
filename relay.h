#ifndef RELAY_H
#define RELAY_H

#include "common.h"

/************************************************
                RELAY DRIVER
************************************************/

/* Initialize relay hardware */
void Relay_Init(void);

/* Turn relay ON */
void Relay_On(void);

/* Turn relay OFF */
void Relay_Off(void);

/* Return current software relay state */
uint8_t Relay_IsOn(void);

#endif