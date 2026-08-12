#include "led.h"
#include "gpio.h"
#include "config.h"

static void LED_Write(GPIO_Port port, GPIO_Pin pin, uint8_t state)
{
    if(state == TRUE)
        GPIO_Set(port, pin);
    else
        GPIO_Clear(port, pin);
}

void LED_Init(void)
{
    GPIO_Output_PP(MODE_LED1_PORT, MODE_LED1_PIN);
    LED_Write(MODE_LED1_PORT, MODE_LED1_PIN, FALSE);

    GPIO_Output_PP(MODE_LED2_PORT, MODE_LED2_PIN);
    LED_Write(MODE_LED2_PORT, MODE_LED2_PIN, FALSE);

    GPIO_Output_PP(MODE_LED3_PORT, MODE_LED3_PIN);
    LED_Write(MODE_LED3_PORT, MODE_LED3_PIN, FALSE);

    GPIO_Output_PP(MODE_LED4_PORT, MODE_LED4_PIN);
    LED_Write(MODE_LED4_PORT, MODE_LED4_PIN, FALSE);

    GPIO_Output_PP(MODE_LED5_PORT, MODE_LED5_PIN);
    LED_Write(MODE_LED5_PORT, MODE_LED5_PIN, FALSE);

    /* System LED: anode -> 3.3V, cathode -> PC6.
       LOW = ON, HIGH = OFF. */
    GPIO_Output_PP(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
    GPIO_Clear(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
}

void LED_System_On(void)
{
    GPIO_Clear(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
}

void LED_System_Off(void)
{
    GPIO_Set(SYSTEM_LED_PORT, SYSTEM_LED_PIN);
}

void LED_Mode_Set(uint8_t mode, uint8_t state)
{
    switch(mode)
    {
        case 1:
            LED_Write(MODE_LED1_PORT, MODE_LED1_PIN, state);
            break;
        case 2:
            LED_Write(MODE_LED2_PORT, MODE_LED2_PIN, state);
            break;
        case 3:
            LED_Write(MODE_LED3_PORT, MODE_LED3_PIN, state);
            break;
        case 4:
            LED_Write(MODE_LED4_PORT, MODE_LED4_PIN, state);
            break;
        case 5:
            LED_Write(MODE_LED5_PORT, MODE_LED5_PIN, state);
            break;
        default:
            break;
    }
}

void LED_Mode_AllOff(void)
{
    LED_Mode_Set(1, FALSE);
    LED_Mode_Set(2, FALSE);
    LED_Mode_Set(3, FALSE);
    LED_Mode_Set(4, FALSE);
    LED_Mode_Set(5, FALSE);
}

void LED_Mode_Display(uint8_t mode)
{
    uint8_t i;

    if(mode < 1)
        mode = 1;

    if(mode > 5)
        mode = 5;

    /* Cumulative indication:
       1: LED1
       2: LED1+LED2
       3: LED1+LED2+LED3
       4: LED1+LED2+LED3+LED4
       5: LED1+LED2+LED3+LED4+LED5 */
    for(i = 1; i <= 5; i++)
    {
        LED_Mode_Set(i, (i <= mode) ? TRUE : FALSE);
    }
}