#ifndef MODE_H
#define MODE_H

#include "common.h"

typedef enum
{
    QS_MODE_1 = 0,
    QS_MODE_2,
    QS_MODE_3,
    QS_MODE_4,
    QS_MODE_5

} QuickShifterMode_t;


void Mode_Init(void);

void Mode_Next(void);

QuickShifterMode_t Mode_Get(void);

uint16_t Mode_GetCutTime(void);

#endif