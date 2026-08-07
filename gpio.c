#include "gpio.h"
#include "stm8_hw.h"

void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin)
{
    PD_DDR |= (1<<pin);
    PD_CR1 |= (1<<pin);
    PD_CR2 &= ~(1<<pin);
}

void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin)
{
    PD_DDR &= ~(1<<pin);
    PD_CR1 |= (1<<pin);
    PD_CR2 &= ~(1<<pin);
}

void GPIO_Set(GPIO_Port port, GPIO_Pin pin)
{
    PD_ODR |= (1<<pin);
}

void GPIO_Clear(GPIO_Port port, GPIO_Pin pin)
{
    PD_ODR &= ~(1<<pin);
}

void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin)
{
    PD_ODR ^= (1<<pin);
}

uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin)
{
    return (PD_IDR & (1<<pin)) ? TRUE : FALSE;
}