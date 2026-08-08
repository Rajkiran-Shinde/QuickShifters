#include "gpio.h"
#include "stm8_hw.h"


/* ============================================================
 * PORT A REGISTERS
 * ============================================================ */

#define PA_ODR  (*(volatile uint8_t*)0x005000)
#define PA_IDR  (*(volatile uint8_t*)0x005001)
#define PA_DDR  (*(volatile uint8_t*)0x005002)
#define PA_CR1  (*(volatile uint8_t*)0x005003)
#define PA_CR2  (*(volatile uint8_t*)0x005004)


/* ============================================================
 * PORT B REGISTERS
 * ============================================================ */

#define PB_ODR  (*(volatile uint8_t*)0x005005)
#define PB_IDR  (*(volatile uint8_t*)0x005006)
#define PB_DDR  (*(volatile uint8_t*)0x005007)
#define PB_CR1  (*(volatile uint8_t*)0x005008)
#define PB_CR2  (*(volatile uint8_t*)0x005009)


/* ============================================================
 * PORT C REGISTERS
 * ============================================================ */

#define PC_ODR  (*(volatile uint8_t*)0x00500A)
#define PC_IDR  (*(volatile uint8_t*)0x00500B)
#define PC_DDR  (*(volatile uint8_t*)0x00500C)
#define PC_CR1  (*(volatile uint8_t*)0x00500D)
#define PC_CR2  (*(volatile uint8_t*)0x00500E)


/* ============================================================
 * REGISTER SELECTION
 * ============================================================ */

static volatile uint8_t* GPIO_Get_ODR(GPIO_Port port)
{
    switch(port)
    {
        case PORT_A:
            return &PA_ODR;

        case PORT_B:
            return &PB_ODR;

        case PORT_C:
            return &PC_ODR;

        case PORT_D:
            return &PD_ODR;

        default:
            return &PD_ODR;
    }
}


static volatile uint8_t* GPIO_Get_IDR(GPIO_Port port)
{
    switch(port)
    {
        case PORT_A:
            return &PA_IDR;

        case PORT_B:
            return &PB_IDR;

        case PORT_C:
            return &PC_IDR;

        case PORT_D:
            return &PD_IDR;

        default:
            return &PD_IDR;
    }
}


static volatile uint8_t* GPIO_Get_DDR(GPIO_Port port)
{
    switch(port)
    {
        case PORT_A:
            return &PA_DDR;

        case PORT_B:
            return &PB_DDR;

        case PORT_C:
            return &PC_DDR;

        case PORT_D:
            return &PD_DDR;

        default:
            return &PD_DDR;
    }
}


static volatile uint8_t* GPIO_Get_CR1(GPIO_Port port)
{
    switch(port)
    {
        case PORT_A:
            return &PA_CR1;

        case PORT_B:
            return &PB_CR1;

        case PORT_C:
            return &PC_CR1;

        case PORT_D:
            return &PD_CR1;

        default:
            return &PD_CR1;
    }
}


static volatile uint8_t* GPIO_Get_CR2(GPIO_Port port)
{
    switch(port)
    {
        case PORT_A:
            return &PA_CR2;

        case PORT_B:
            return &PB_CR2;

        case PORT_C:
            return &PC_CR2;

        case PORT_D:
            return &PD_CR2;

        default:
            return &PD_CR2;
    }
}


/* ============================================================
 * OUTPUT - PUSH PULL
 * ============================================================ */

void GPIO_Output_PP(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *ddr;
    volatile uint8_t *cr1;
    volatile uint8_t *cr2;

    ddr = GPIO_Get_DDR(port);
    cr1 = GPIO_Get_CR1(port);
    cr2 = GPIO_Get_CR2(port);

    /* Output mode */
    *ddr |= (1 << pin);

    /* Push-pull */
    *cr1 |= (1 << pin);

    /* Low-speed output */
    *cr2 &= ~(1 << pin);
}


/* ============================================================
 * INPUT - PULL UP
 * ============================================================ */

void GPIO_Input_PU(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *ddr;
    volatile uint8_t *cr1;
    volatile uint8_t *cr2;

    ddr = GPIO_Get_DDR(port);
    cr1 = GPIO_Get_CR1(port);
    cr2 = GPIO_Get_CR2(port);

    /* Input mode */
    *ddr &= ~(1 << pin);

    /* Pull-up enabled */
    *cr1 |= (1 << pin);

    /* Interrupt disabled */
    *cr2 &= ~(1 << pin);
}


/* ============================================================
 * SET
 * ============================================================ */

void GPIO_Set(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *odr;

    odr = GPIO_Get_ODR(port);

    *odr |= (1 << pin);
}


/* ============================================================
 * CLEAR
 * ============================================================ */

void GPIO_Clear(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *odr;

    odr = GPIO_Get_ODR(port);

    *odr &= ~(1 << pin);
}


/* ============================================================
 * TOGGLE
 * ============================================================ */

void GPIO_Toggle(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *odr;

    odr = GPIO_Get_ODR(port);

    *odr ^= (1 << pin);
}


/* ============================================================
 * READ
 * ============================================================ */

uint8_t GPIO_Read(GPIO_Port port, GPIO_Pin pin)
{
    volatile uint8_t *idr;

    idr = GPIO_Get_IDR(port);

    return (*idr & (1 << pin)) ? TRUE : FALSE;
}