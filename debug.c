#include "debug.h"
#include "config.h"

#if DEBUG_UART_ENABLED

#include "uart.h"


/************************************************
                DEBUG INITIALIZATION
************************************************/

void Debug_Init(void)
{
    UART_Init();

    Debug_Log("\r\n");
    Debug_Log("================================\r\n");
    Debug_Log(" QuickShifter Debug Console\r\n");
    Debug_Log("================================\r\n");
}


/************************************************
                DEBUG LOG
************************************************/

void Debug_Log(const char *message)
{
    UART_SendString(message);
}


/************************************************
                DEBUG STATE
************************************************/

void Debug_LogState(uint8_t state)
{
    switch(state)
    {
        case 0:
            Debug_Log("[QS] IDLE\r\n");
            break;

        case 1:
            Debug_Log("[QS] CUT_ACTIVE\r\n");
            break;

        case 2:
            Debug_Log("[QS] COOLDOWN\r\n");
            break;

        case 3:
            Debug_Log("[QS] WAIT_RELEASE\r\n");
            break;

        default:
            Debug_Log("[QS] UNKNOWN STATE\r\n");
            break;
    }
}


/************************************************
                DEBUG MODE
************************************************/

void Debug_LogMode(uint8_t mode, uint16_t cut_time)
{
    Debug_Log("[MODE] ");

    UART_SendChar('1' + mode);

    Debug_Log(" | CUT = ");

    if(cut_time >= 100)
    {
        UART_SendChar('0' + (cut_time / 100));

        cut_time = cut_time % 100;
    }

    UART_SendChar('0' + (cut_time / 10));

    UART_SendChar('0' + (cut_time % 10));

    Debug_Log(" ms\r\n");
}


/************************************************
                DEBUG SHIFT TIME
************************************************/

void Debug_LogShift(uint16_t shift_time)
{
    Debug_Log("[QS] CUT = ");

    if(shift_time >= 100)
    {
        UART_SendChar('0' + (shift_time / 100));

        shift_time = shift_time % 100;
    }

    UART_SendChar('0' + (shift_time / 10));

    UART_SendChar('0' + (shift_time % 10));

    Debug_Log(" ms\r\n");
}


#else


/************************************************
                DEBUG DISABLED
************************************************/

void Debug_Init(void)
{
}


void Debug_Log(const char *message)
{
    (void)message;
}


void Debug_LogState(uint8_t state)
{
    (void)state;
}


void Debug_LogShift(uint16_t shift_time)
{
    (void)shift_time;
}


void Debug_LogMode(uint8_t mode, uint16_t cut_time)
{
    (void)mode;
    (void)cut_time;
}


#endif