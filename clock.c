#include "clock.h"

#define CLK_CKDIVR (*(volatile unsigned char*)0x50C6)

void CLK_Init(void)
{
    /* HSI Divider = 1 */

    CLK_CKDIVR = 0x00;
}