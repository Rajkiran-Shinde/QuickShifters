#include "led.h"
#include "gpio.h"
#include "config.h"


/* ============================================================
 * INTERNAL HELPERS
 * ============================================================ */

/*
 * Set one GPIO output.
 *
 * This wrapper keeps LED logic independent from the
 * low-level GPIO implementation.
 */
static void LED_Write(GPIO_Port port, GPIO_Pin pin, uint8_t state)
{
    if(state == TRUE)
    {
        GPIO_Set(port, pin);
    }
    else
    {
        GPIO_Clear(port, pin);
    }
}


/* ============================================================
 * LED INITIALIZATION
 * ============================================================ */

void LED_Init(void)
{
    /* ========================================================
     * MODE LED 1
     * ======================================================== */

    GPIO_Output_PP(MODE_LED1_PORT, MODE_LED1_PIN);

    LED_Write(
        MODE_LED1_PORT,
        MODE_LED1_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 2
     * ======================================================== */

    GPIO_Output_PP(MODE_LED2_PORT, MODE_LED2_PIN);

    LED_Write(
        MODE_LED2_PORT,
        MODE_LED2_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 3
     * ======================================================== */

    GPIO_Output_PP(MODE_LED3_PORT, MODE_LED3_PIN);

    LED_Write(
        MODE_LED3_PORT,
        MODE_LED3_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 4
     * ======================================================== */

    GPIO_Output_PP(MODE_LED4_PORT, MODE_LED4_PIN);

    LED_Write(
        MODE_LED4_PORT,
        MODE_LED4_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 5
     * ======================================================== */

    GPIO_Output_PP(MODE_LED5_PORT, MODE_LED5_PIN);

    LED_Write(
        MODE_LED5_PORT,
        MODE_LED5_PIN,
        FALSE
    );
}


/* ============================================================
 * MODE LED CONTROL
 * ============================================================ */

void LED_Mode_Set(uint8_t mode, uint8_t state)
{
    switch(mode)
    {
        case 1:

            LED_Write(
                MODE_LED1_PORT,
                MODE_LED1_PIN,
                state
            );

            break;


        case 2:

            LED_Write(
                MODE_LED2_PORT,
                MODE_LED2_PIN,
                state
            );

            break;


        case 3:

            LED_Write(
                MODE_LED3_PORT,
                MODE_LED3_PIN,
                state
            );

            break;


        case 4:

            LED_Write(
                MODE_LED4_PORT,
                MODE_LED4_PIN,
                state
            );

            break;


        case 5:

            LED_Write(
                MODE_LED5_PORT,
                MODE_LED5_PIN,
                state
            );

            break;


        default:
            /*
             * Invalid mode.
             * Do nothing.
             */
            break;
    }
}


/* ============================================================
 * ALL MODE LEDs OFF
 * ============================================================ */

void LED_Mode_AllOff(void)
{
    LED_Mode_Set(1, FALSE);
    LED_Mode_Set(2, FALSE);
    LED_Mode_Set(3, FALSE);
    LED_Mode_Set(4, FALSE);
    LED_Mode_Set(5, FALSE);
}


/* ============================================================
 * DISPLAY CURRENT MODE
 * ============================================================ */

void LED_Mode_Display(uint8_t mode)
{
    /*
     * First turn everything OFF.
     *
     * This guarantees that only one mode indicator
     * remains active.
     */
    LED_Mode_AllOff();


    /*
     * Turn ON the LED corresponding to the selected mode.
     */
    LED_Mode_Set(mode, TRUE);
}


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================ */

void LED_Status_Off(void)
{
    /*
     * RGB status LED implementation will be enabled
     * after Port B/C GPIO support is added.
     */
}


void LED_Status_Red(void)
{
    /*
     * Future:
     *
     * RED   = ON
     * GREEN = OFF
     * BLUE  = OFF
     */
}


void LED_Status_Green(void)
{
    /*
     * Future:
     *
     * RED   = OFF
     * GREEN = ON
     * BLUE  = OFF
     */
}


void LED_Status_Blue(void)
{
    /*
     * Future:
     *
     * RED   = OFF
     * GREEN = OFF
     * BLUE  = ON
     */
}


void LED_Status_Yellow(void)
{
    /*
     * Future:
     *
     * RED   = ON
     * GREEN = ON
     * BLUE  = OFF
     */
}


void LED_Status_Purple(void)
{
    /*
     * Future:
     *
     * RED   = ON
     * GREEN = OFF
     * BLUE  = ON
     */
}