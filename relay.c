#include "relay.h"
#include "gpio.h"
#include "config.h"
#include "debug.h"

/************************************************
                RELAY STATE
************************************************/

/*
 * Software representation of relay state.
 *
 * FALSE = OFF
 * TRUE  = ON
 */
static uint8_t relayState;


/************************************************
                RELAY INITIALIZATION
************************************************/

void Relay_Init(void)
{
    /*
     * Configure relay GPIO as push-pull output.
     */
    GPIO_Output_PP(RELAY_PORT, RELAY_PIN);

    /*
     * FAIL-SAFE STARTUP
     *
     * Relay must always start OFF.
     */
    GPIO_Clear(RELAY_PORT, RELAY_PIN);

    relayState = FALSE;
}


/************************************************
                RELAY CONTROL
************************************************/

void Relay_On(void)
{
    GPIO_Set(RELAY_PORT, RELAY_PIN);

    relayState = TRUE;
		
		Debug_Log("[RELAY] ON\r\n");
}


void Relay_Off(void)
{
    GPIO_Clear(RELAY_PORT, RELAY_PIN);

    relayState = FALSE;
		
		Debug_Log("[RELAY] OFF\r\n");
}


/************************************************
                RELAY STATUS
************************************************/

uint8_t Relay_IsOn(void)
{
    return relayState;
}