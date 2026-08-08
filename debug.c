#include "debug.h"
#include "config.h"
#include "watchdog.h"


#if DEBUG_UART_ENABLED

#include "uart.h"


/************************************************
                DEBUG UART HELPER
************************************************/

/*
 * UART_SendChar() is blocking.
 *
 * Refresh the watchdog after every transmitted
 * character so long debug messages cannot
 * accidentally cause a watchdog reset.
 */
static void Debug_SendChar(char character)
{
    UART_SendChar(character);

    Watchdog_Refresh();
}


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
    while(*message != '\0')
    {
        Debug_SendChar(*message);

        message++;
    }
}


/************************************************
                DEBUG HEX
************************************************/

void Debug_LogHex(uint8_t value)
{
    char hex[] = "0123456789ABCDEF";

    Debug_SendChar(
        hex[(value >> 4) & 0x0F]
    );

    Debug_SendChar(
        hex[value & 0x0F]
    );
}


/************************************************
                DEBUG DECIMAL
************************************************/

void Debug_LogDecimal(uint8_t value)
{
    char buffer[4];

    uint8_t i;

    i = 0;


    if(value >= 100)
    {
        buffer[i++] =
            '0' + (value / 100);

        value =
            value % 100;

        buffer[i++] =
            '0' + (value / 10);

        buffer[i++] =
            '0' + (value % 10);
    }
    else if(value >= 10)
    {
        buffer[i++] =
            '0' + (value / 10);

        buffer[i++] =
            '0' + (value % 10);
    }
    else
    {
        buffer[i++] =
            '0' + value;
    }


    buffer[i] = '\0';


    Debug_Log(buffer);
}


/************************************************
                DEBUG STATE
************************************************/

void Debug_LogState(uint8_t state)
{
    switch(state)
    {
        case 0:

            Debug_Log(
                "[QS] IDLE\r\n"
            );

            break;


        case 1:

            Debug_Log(
                "[QS] CUT_ACTIVE\r\n"
            );

            break;


        case 2:

            Debug_Log(
                "[QS] COOLDOWN\r\n"
            );

            break;


        case 3:

            Debug_Log(
                "[QS] WAIT_RELEASE\r\n"
            );

            break;


        case 4:

            Debug_Log(
                "[QS] FAULT\r\n"
            );

            break;


        default:

            Debug_Log(
                "[QS] UNKNOWN STATE\r\n"
            );

            break;
    }
}


/************************************************
                DEBUG MODE
************************************************/

void Debug_LogMode(
    uint8_t mode,
    uint16_t cut_time
)
{
    Debug_Log(
        "[MODE] "
    );


    /*
     * Internal mode:
     *
     * 0 -> Mode 1
     * 1 -> Mode 2
     * 2 -> Mode 3
     * 3 -> Mode 4
     * 4 -> Mode 5
     */

    Debug_SendChar(
        '1' + mode
    );


    Debug_Log(
        " | CUT = "
    );


    if(cut_time >= 100)
    {
        Debug_SendChar(
            '0' + (cut_time / 100)
        );

        cut_time =
            cut_time % 100;
    }


    Debug_SendChar(
        '0' + (cut_time / 10)
    );


    Debug_SendChar(
        '0' + (cut_time % 10)
    );


    Debug_Log(
        " ms\r\n"
    );
}


/************************************************
                DEBUG SHIFT TIME
************************************************/

void Debug_LogShift(uint16_t shift_time)
{
    Debug_Log(
        "[QS] CUT = "
    );


    if(shift_time >= 100)
    {
        Debug_SendChar(
            '0' + (shift_time / 100)
        );

        shift_time =
            shift_time % 100;
    }


    Debug_SendChar(
        '0' + (shift_time / 10)
    );


    Debug_SendChar(
        '0' + (shift_time % 10)
    );


    Debug_Log(
        " ms\r\n"
    );
}


#else


/************************************************
                DEBUG DISABLED
************************************************/

void Debug_Init(void)
{
}


void Debug_Log(
    const char *message
)
{
    (void)message;
}


void Debug_LogHex(
    uint8_t value
)
{
    (void)value;
}


void Debug_LogDecimal(
    uint8_t value
)
{
    (void)value;
}


void Debug_LogState(
    uint8_t state
)
{
    (void)state;
}


void Debug_LogShift(
    uint16_t shift_time
)
{
    (void)shift_time;
}


void Debug_LogMode(
    uint8_t mode,
    uint16_t cut_time
)
{
    (void)mode;
    (void)cut_time;
}


#endif