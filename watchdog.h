#ifndef WATCHDOG_H
#define WATCHDOG_H

#include "common.h"


/************************************************
                WATCHDOG API
************************************************/

/*
 * Initialize and start the STM8 independent
 * watchdog.
 */
void Watchdog_Init(void);


/*
 * Refresh the watchdog counter.
 *
 * Must be called periodically while the firmware
 * is operating normally.
 */
void Watchdog_Refresh(void);


#endif