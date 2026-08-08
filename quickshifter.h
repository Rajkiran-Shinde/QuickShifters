#ifndef QUICKSHIFTER_H
#define QUICKSHIFTER_H

#include "common.h"
#include "software_timer.h"


typedef enum
{
    QS_STATE_IDLE = 0,

    QS_STATE_CUT_ACTIVE,

    QS_STATE_COOLDOWN,

    QS_STATE_WAIT_RELEASE,

    QS_STATE_FAULT

} QuickShifterState_t;


void QuickShifter_Init(void);

void QuickShifter_Task(void);

#endif