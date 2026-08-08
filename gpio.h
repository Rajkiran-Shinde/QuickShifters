#ifndef GPIO_H
#define GPIO_H

#include "common.h"


/* ============================================================
 * GPIO PORTS
 * ============================================================ */

typedef enum
{
		PORT_A,
    PORT_B,
    PORT_C,
    PORT_D

} GPIO_Port;


/* ============================================================
 * GPIO PINS
 * ============================================================ */

typedef enum
{
    PIN0 = 0,
    PIN1 = 1,
    PIN2 = 2,
    PIN3 = 3,
    PIN4 = 4,
    PIN5 = 5,
    PIN6 = 6,
    PIN7 = 7

} GPIO_Pin;


/* ============================================================
 * GPIO CONFIGURATION
 * ============================================================ */

/*
 * Push-Pull Output
 *
 * Output:
 *     0 -> LOW
 *     1 -> HIGH
 */
void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin);


/*
 * Input with Pull-Up
 */
void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin);


/* ============================================================
 * GPIO OUTPUT CONTROL
 * ============================================================ */

void GPIO_Set(GPIO_Port port, GPIO_Pin pin);

void GPIO_Clear(GPIO_Port port, GPIO_Pin pin);

void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin);


/* ============================================================
 * GPIO INPUT
 * ============================================================ */

uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin);


#endif /* GPIO_H */