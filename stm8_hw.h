#ifndef STM8_HW_H
#define STM8_HW_H

#include "common.h"

/******** PORT D ********/

#define PD_ODR (*(volatile uint8_t*)0x500F)
#define PD_IDR (*(volatile uint8_t*)0x5010)
#define PD_DDR (*(volatile uint8_t*)0x5011)
#define PD_CR1 (*(volatile uint8_t*)0x5012)
#define PD_CR2 (*(volatile uint8_t*)0x5013)

/******** TIM4 ********/

#define TIM4_CR1 (*(volatile uint8_t*)0x5340)
#define TIM4_IER (*(volatile uint8_t*)0x5343)
#define TIM4_SR  (*(volatile uint8_t*)0x5344)
#define TIM4_EGR (*(volatile uint8_t*)0x5345)
#define TIM4_PSCR (*(volatile uint8_t*)0x5347)
#define TIM4_ARR (*(volatile uint8_t*)0x5348)

#endif