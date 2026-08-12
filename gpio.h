#ifndef GPIO_H
#define GPIO_H

#include "common.h"

typedef enum
{
    PORT_A,
    PORT_B,
    PORT_C,
    PORT_D
} GPIO_Port;

typedef enum
{
    PIN0,
    PIN1,
    PIN2,
    PIN3,
    PIN4,
    PIN5,
    PIN6,
    PIN7
} GPIO_Pin;

void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin);
void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin);

void GPIO_Set(GPIO_Port port, GPIO_Pin pin);
void GPIO_Clear(GPIO_Port port, GPIO_Pin pin);
void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin);

uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin);

#endif