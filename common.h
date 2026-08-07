#ifndef COMMON_H
#define COMMON_H

typedef unsigned char  uint8_t;
typedef unsigned short uint16_t;
typedef unsigned long  uint32_t;

#define TRUE    1
#define FALSE   0
/* Cosmic Interrupt Handler Macro */
#define INTERRUPT_HANDLER(f, irq) @far @interrupt void f(void)
#endif

