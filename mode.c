#include "mode.h"
#include "eeprom.h"

#define MODE_COUNT 5


/************************************************
                CURRENT MODE
************************************************/

static QuickShifterMode_t currentMode;


/************************************************
                CUT TIME TABLE
************************************************/

static const uint16_t cutTimes[MODE_COUNT] =
{
    40,
    50,
    60,
    70,
    80
};


/************************************************
                INITIALIZATION
************************************************/

void Mode_Init(void)
{
    uint8_t savedMode;


    /*
     * EEPROM stores user-visible mode:
     *
     * 1 ? Mode 1
     * 2 ? Mode 2
     * 3 ? Mode 3
     * 4 ? Mode 4
     * 5 ? Mode 5
     */

    savedMode = EEPROM_LoadMode();


    /*
     * Convert EEPROM representation
     * 1–5 into internal representation
     * 0–4.
     */

    if(
        (savedMode >= 1) &&
        (savedMode <= MODE_COUNT)
    )
    {
        currentMode =
            (QuickShifterMode_t)(
                savedMode - 1
            );
    }
    else
    {
        /*
         * Safety fallback.
         */

        currentMode = QS_MODE_1;
    }
}


/************************************************
                NEXT MODE
************************************************/

void Mode_Next(void)
{
    /*
     * Internal mode:
     *
     * 0 ? 1 ? 2 ? 3 ? 4 ? 0
     */

    currentMode++;


    if(currentMode >= MODE_COUNT)
    {
        currentMode = QS_MODE_1;
    }


    /*
     * Convert internal 0–4
     * to EEPROM 1–5.
     */

    EEPROM_SaveMode(
        (uint8_t)currentMode + 1
    );
}


/************************************************
                GET CURRENT MODE
************************************************/

QuickShifterMode_t Mode_Get(void)
{
    return currentMode;
}


/************************************************
                GET CUT TIME
************************************************/

uint16_t Mode_GetCutTime(void)
{
    /*
     * Protect against invalid array index.
     */

    if(currentMode >= MODE_COUNT)
    {
        currentMode = QS_MODE_1;
    }


    return cutTimes[currentMode];
}