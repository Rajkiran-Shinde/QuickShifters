#ifndef BUZZER_H
#define BUZZER_H

#include "common.h"


/* ============================================================
 * BUZZER EVENTS
 * ============================================================ */

typedef enum
{
    BUZZER_EVENT_BOOT = 0,
    BUZZER_EVENT_MODE_CHANGE,
    BUZZER_EVENT_SHIFT,
    BUZZER_EVENT_READY,
    BUZZER_EVENT_FAULT

} BuzzerEvent;


/* ============================================================
 * INITIALIZATION
 * ============================================================ */

void Buzzer_Init(void);


/* ============================================================
 * TASK
 * ============================================================ */

/*
 * Called periodically from the main loop.
 *
 * Handles:
 *     - melody sequencing
 *     - note duration
 *     - pauses
 *     - event completion
 */
void Buzzer_Task(void);


/* ============================================================
 * EVENTS
 * ============================================================ */

void Buzzer_Play(BuzzerEvent event);


/* ============================================================
 * CONTROL
 * ============================================================ */

void Buzzer_Stop(void);

uint8_t Buzzer_IsBusy(void);

void Buzzer_TickISR(void);


#endif /* BUZZER_H */