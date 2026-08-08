#include "mode.h"

#define MODE_COUNT 5

static QuickShifterMode_t currentMode;

static const uint16_t cutTimes[MODE_COUNT] =
{
    40,
    50,
    60,
    70,
    80
};


void Mode_Init(void)
{
    currentMode = QS_MODE_1;
}


void Mode_Next(void)
{
    currentMode++;

    if(currentMode >= MODE_COUNT)
    {
        currentMode = QS_MODE_1;
    }
}


QuickShifterMode_t Mode_Get(void)
{
    return currentMode;
}


uint16_t Mode_GetCutTime(void)
{
    return cutTimes[currentMode];
}