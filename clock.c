#include "clock.h"

#define CLK_CKDIVR (*(volatile unsigned char*)0x50C6)
#define CLK_DIV_1     0x00
#define CLK_DIV_2     0x01
#define CLK_DIV_4     0x02
#define CLK_DIV_8     0x03

void CLK_Init(void)
{
    /* HSI Divider = 1 */

    CLK_CKDIVR = CLK_DIV_1;
}