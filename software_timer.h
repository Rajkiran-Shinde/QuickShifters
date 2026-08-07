#ifndef SOFTWARE_TIMER_H
#define SOFTWARE_TIMER_H

#include "common.h"

/*=============================
        Software Timer
==============================*/

typedef struct
{
    uint32_t start_time;
    uint32_t duration;
    uint8_t active;

}SoftwareTimer_t;


/*=============================
        API
==============================*/

void SoftwareTimer_Start(SoftwareTimer_t *timer, uint32_t duration);

void SoftwareTimer_Stop(SoftwareTimer_t *timer);

uint8_t SoftwareTimer_Expired(SoftwareTimer_t *timer);

uint8_t SoftwareTimer_IsRunning(SoftwareTimer_t *timer);

#endif