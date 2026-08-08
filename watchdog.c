#include "watchdog.h"


/************************************************
                IWDG REGISTERS
************************************************/

#define IWDG_KR    (*(volatile uint8_t*)0x50E0)
#define IWDG_PR    (*(volatile uint8_t*)0x50E1)
#define IWDG_RLR   (*(volatile uint8_t*)0x50E2)


/************************************************
                IWDG KEYS
************************************************/

#define IWDG_KEY_ACCESS     0x55
#define IWDG_KEY_REFRESH    0xAA
#define IWDG_KEY_ENABLE     0xCC


/************************************************
                IWDG CONFIGURATION
************************************************/

/*
 * STM8S003F3 IWDG uses the independent
 * 128 kHz LSI clock.
 *
 * PR = 0x06
 *     -> /256
 *
 * RLR = 0xFF
 *
 * Nominal timeout:
 *
 * 128000 Hz / 256 = 500 Hz
 *
 * 256 counts / 500 Hz
 * ˜ 512 ms
 *
 * Actual timeout depends on LSI tolerance.
 */

#define IWDG_PRESCALER      0x06
#define IWDG_RELOAD         0xFF


/************************************************
                INITIALIZATION
************************************************/

void Watchdog_Init(void)
{
    /*
     * STEP 1
     *
     * Start the Independent Watchdog.
     *
     * According to STM8 IWDG operation,
     * writing 0xCC starts the counter.
     */
    IWDG_KR = IWDG_KEY_ENABLE;


    /*
     * STEP 2
     *
     * Enable write access to PR and RLR.
     */
    IWDG_KR = IWDG_KEY_ACCESS;


    /*
     * STEP 3
     *
     * Configure prescaler.
     */
    IWDG_PR = IWDG_PRESCALER;


    /*
     * STEP 4
     *
     * Configure reload value.
     */
    IWDG_RLR = IWDG_RELOAD;


    /*
     * STEP 5
     *
     * Reload the watchdog counter.
     *
     * This also gives the newly configured
     * watchdog its full timeout period.
     */
    IWDG_KR = IWDG_KEY_REFRESH;
}


/************************************************
                REFRESH
************************************************/

void Watchdog_Refresh(void)
{
    /*
     * Reload the watchdog counter.
     */
    IWDG_KR = IWDG_KEY_REFRESH;
}