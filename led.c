#include "led.h"
#include "gpio.h"
#include "config.h"


/* ============================================================
 * INTERNAL HELPER
 * ============================================================ */

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

    GPIO_Output_PP(
        MODE_LED1_PORT,
        MODE_LED1_PIN
    );

    LED_Write(
        MODE_LED1_PORT,
        MODE_LED1_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 2
     * ======================================================== */

    GPIO_Output_PP(
        MODE_LED2_PORT,
        MODE_LED2_PIN
    );

    LED_Write(
        MODE_LED2_PORT,
        MODE_LED2_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 3
     * ======================================================== */

    GPIO_Output_PP(
        MODE_LED3_PORT,
        MODE_LED3_PIN
    );

    LED_Write(
        MODE_LED3_PORT,
        MODE_LED3_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 4
     * ======================================================== */

    GPIO_Output_PP(
        MODE_LED4_PORT,
        MODE_LED4_PIN
    );

    LED_Write(
        MODE_LED4_PORT,
        MODE_LED4_PIN,
        FALSE
    );


    /* ========================================================
     * MODE LED 5
     * ======================================================== */

    GPIO_Output_PP(
        MODE_LED5_PORT,
        MODE_LED5_PIN
    );

    LED_Write(
        MODE_LED5_PORT,
        MODE_LED5_PIN,
        FALSE
    );


    /* ========================================================
     * RGB STATUS LED
     * ========================================================
     *
     * Common-anode configuration:
     *
     * GPIO HIGH -> OFF
     * GPIO LOW  -> ON
     *
     * Start with all colors OFF.
     * ======================================================== */


    /* Red */
    GPIO_Output_PP(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );

    GPIO_Set(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /* Green */
    GPIO_Output_PP(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );

    GPIO_Set(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /* Blue */
    GPIO_Output_PP(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );

    GPIO_Set(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
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
     * First turn every mode LED OFF.
     */
    LED_Mode_AllOff();


    /*
     * Then turn ON the selected mode LED.
     */
    LED_Mode_Set(mode, TRUE);
}


/* ============================================================
 * SYSTEM STATUS RGB LED
 * ============================================================
 *
 * Common-anode RGB LED:
 *
 * LOW  -> ON
 * HIGH -> OFF
 */


/* ============================================================
 * STATUS OFF
 * ============================================================ */

void LED_Status_Off(void)
{
    /*
     * Red OFF
     */
    GPIO_Set(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green OFF
     */
    GPIO_Set(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue OFF
     */
    GPIO_Set(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}


/* ============================================================
 * STATUS RED
 * ============================================================ */

void LED_Status_Red(void)
{
    /*
     * Red ON
     */
    GPIO_Clear(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green OFF
     */
    GPIO_Set(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue OFF
     */
    GPIO_Set(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}


/* ============================================================
 * STATUS GREEN
 * ============================================================ */

void LED_Status_Green(void)
{
    /*
     * Red OFF
     */
    GPIO_Set(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green ON
     */
    GPIO_Clear(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue OFF
     */
    GPIO_Set(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}


/* ============================================================
 * STATUS BLUE
 * ============================================================ */

void LED_Status_Blue(void)
{
    /*
     * Red OFF
     */
    GPIO_Set(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green OFF
     */
    GPIO_Set(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue ON
     */
    GPIO_Clear(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}


/* ============================================================
 * STATUS YELLOW
 * ============================================================ */

void LED_Status_Yellow(void)
{
    /*
     * Red ON
     */
    GPIO_Clear(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green ON
     */
    GPIO_Clear(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue OFF
     */
    GPIO_Set(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}


/* ============================================================
 * STATUS PURPLE
 * ============================================================ */

void LED_Status_Purple(void)
{
    /*
     * Red ON
     */
    GPIO_Clear(
        STATUS_LED_R_PORT,
        STATUS_LED_R_PIN
    );


    /*
     * Green OFF
     */
    GPIO_Set(
        STATUS_LED_G_PORT,
        STATUS_LED_G_PIN
    );


    /*
     * Blue ON
     */
    GPIO_Clear(
        STATUS_LED_B_PORT,
        STATUS_LED_B_PIN
    );
}