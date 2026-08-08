#include "mode.h"
#include "eeprom.h"

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
    /*
     * Load previously saved mode from EEPROM.
     *
     * EEPROM_LoadMode() returns Mode 1
     * automatically if EEPROM data is invalid.
     */
    currentMode = (QuickShifterMode_t)EEPROM_LoadMode();
}


void Mode_Next(void)
{
    currentMode++;

    if(currentMode >= MODE_COUNT)
    {
        currentMode = QS_MODE_1;
    }

    /*
     * Save the newly selected mode.
     */
    EEPROM_SaveMode((uint8_t)currentMode);
}


QuickShifterMode_t Mode_Get(void)
{
    return currentMode;
}


uint16_t Mode_GetCutTime(void)
{
    return cutTimes[currentMode];
}