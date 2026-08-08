#include "eeprom.h"
#include "debug.h"
#include "watchdog.h"


/************************************************
        STM8 FLASH / EEPROM REGISTERS
************************************************/

#define FLASH_IAPSR     (*(volatile uint8_t*)0x505F)
#define FLASH_DUKR      (*(volatile uint8_t*)0x5064)


/************************************************
                FLASH_IAPSR BITS
************************************************/

#define FLASH_IAPSR_DUL     0x08
#define FLASH_IAPSR_EOP     0x04


/************************************************
                INTERNAL FUNCTIONS
************************************************/

static void EEPROM_Unlock(void)
{
    if((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
    {
        FLASH_DUKR = 0xAE;
        FLASH_DUKR = 0x56;

        while((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
        {
            /*
             * Wait for EEPROM/FLASH data unlock.
             *
             * Keep watchdog alive while waiting.
             */
            Watchdog_Refresh();
        }
    }
}


/*
 * Calculate checksum for CURRENT configuration.
 *
 * checksum = MAGIC ^ MODE ^ 0x5A
 */
static uint8_t EEPROM_CalculateChecksum(
    uint8_t mode
)
{
    return (uint8_t)(
        EEPROM_MAGIC ^
        mode ^
        0x5A
    );
}


/*
 * Calculate checksum for LEGACY configuration.
 *
 * Old format:
 *
 * checksum = 0xA5 ^ legacy_mode ^ 0x5A
 */
static uint8_t EEPROM_CalculateLegacyChecksum(
    uint8_t mode
)
{
    return (uint8_t)(
        EEPROM_LEGACY_MAGIC ^
        mode ^
        0x5A
    );
}


/************************************************
                PUBLIC FUNCTIONS
************************************************/

void EEPROM_Init(void)
{
    /*
     * No initialization required.
     *
     * EEPROM is memory mapped.
     */
}


/************************************************
                EEPROM READ
************************************************/

uint8_t EEPROM_ReadByte(
    uint16_t address
)
{
    uint8_t value;

    value = (*(volatile uint8_t*)address);

    return value;
}


/************************************************
                EEPROM WRITE
************************************************/

uint8_t EEPROM_WriteByte(
    uint16_t address,
    uint8_t value
)
{
    /*
     * Unlock EEPROM / data memory.
     */
    EEPROM_Unlock();


    /*
     * Write EEPROM byte.
     */
    (*(volatile uint8_t*)address) = value;


    /*
     * EEPROM programming is a blocking operation.
     *
     * Keep the watchdog alive while waiting for
     * the programming operation to complete.
     */
    while((FLASH_IAPSR & FLASH_IAPSR_EOP) == 0)
    {
        Watchdog_Refresh();
    }


    /*
     * Refresh once more after the write completes.
     */
    Watchdog_Refresh();


    return TRUE;
}


/************************************************
                LOAD MODE
************************************************/

uint8_t EEPROM_LoadMode(void)
{
    uint8_t magic;
    uint8_t mode;
    uint8_t checksum;
    uint8_t expectedChecksum;


    Debug_Log(
        "[EEPROM] Loading configuration...\r\n"
    );


    /*
     * Read configuration.
     */

    magic =
        EEPROM_ReadByte(
            EEPROM_MAGIC_ADDRESS
        );

    mode =
        EEPROM_ReadByte(
            EEPROM_MODE_ADDRESS
        );

    checksum =
        EEPROM_ReadByte(
            EEPROM_CHECKSUM_ADDRESS
        );


    /**********************************************
                DEBUG INFORMATION
    **********************************************/

    Debug_Log("[EEPROM] Magic: 0x");
    Debug_LogHex(magic);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Stored Mode: ");
    Debug_LogDecimal(mode);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Checksum: 0x");
    Debug_LogHex(checksum);
    Debug_Log("\r\n");


    /**********************************************
                CURRENT FORMAT
    **********************************************/

    if(magic == EEPROM_MAGIC)
    {
        /*
         * Validate mode range.
         */

        if(
            (mode < EEPROM_MIN_MODE) ||
            (mode > EEPROM_MAX_MODE)
        )
        {
            Debug_Log(
                "[EEPROM] ERROR: Invalid mode\r\n"
            );

            Debug_Log(
                "[EEPROM] Using default Mode 1\r\n"
            );

            return 1;
        }


        /*
         * Calculate expected checksum.
         */

        expectedChecksum =
            EEPROM_CalculateChecksum(mode);


        Debug_Log(
            "[EEPROM] Expected checksum: 0x"
        );

        Debug_LogHex(expectedChecksum);

        Debug_Log("\r\n");


        /*
         * Verify checksum.
         */

        if(checksum != expectedChecksum)
        {
            Debug_Log(
                "[EEPROM] ERROR: Checksum mismatch\r\n"
            );

            Debug_Log(
                "[EEPROM] Using default Mode 1\r\n"
            );

            return 1;
        }


        /*
         * Configuration is valid.
         */

        Debug_Log(
            "[EEPROM] Configuration VALID\r\n"
        );

        Debug_Log(
            "[EEPROM] Restoring Mode: "
        );

        Debug_LogDecimal(mode);

        Debug_Log("\r\n");


        return mode;
    }


    /**********************************************
                LEGACY FORMAT
    **********************************************/

    if(magic == EEPROM_LEGACY_MAGIC)
    {
        uint8_t legacyChecksum;


        /*
         * Old format:
         *
         * 0 -> Mode 1
         * 1 -> Mode 2
         * 2 -> Mode 3
         * 3 -> Mode 4
         * 4 -> Mode 5
         */

        Debug_Log(
            "[EEPROM] Legacy configuration detected\r\n"
        );


        /*
         * Validate old mode.
         */

        if(mode > 4)
        {
            Debug_Log(
                "[EEPROM] ERROR: Invalid legacy mode\r\n"
            );

            Debug_Log(
                "[EEPROM] Using default Mode 1\r\n"
            );

            return 1;
        }


        /*
         * Validate legacy checksum.
         */

        legacyChecksum =
            EEPROM_CalculateLegacyChecksum(mode);


        if(checksum != legacyChecksum)
        {
            Debug_Log(
                "[EEPROM] ERROR: Legacy checksum mismatch\r\n"
            );

            Debug_Log(
                "[EEPROM] Using default Mode 1\r\n"
            );

            return 1;
        }


        /*
         * Convert legacy mode:
         *
         * 0 -> 1
         * 1 -> 2
         * 2 -> 3
         * 3 -> 4
         * 4 -> 5
         */

        mode = mode + 1;


        Debug_Log(
            "[EEPROM] Legacy mode converted to Mode: "
        );

        Debug_LogDecimal(mode);

        Debug_Log("\r\n");


        /*
         * Save converted configuration using
         * the current EEPROM format.
         */
        EEPROM_SaveMode(mode);


        Debug_Log(
            "[EEPROM] Legacy configuration migrated\r\n"
        );


        return mode;
    }


    /**********************************************
                UNKNOWN FORMAT
    **********************************************/

    Debug_Log(
        "[EEPROM] ERROR: Unknown configuration format\r\n"
    );

    Debug_Log(
        "[EEPROM] Using default Mode 1\r\n"
    );


    return 1;
}


/************************************************
                SAVE MODE
************************************************/

void EEPROM_SaveMode(uint8_t mode)
{
    uint8_t checksum;

    uint8_t readBackMode;
    uint8_t readBackMagic;
    uint8_t readBackChecksum;


    /**********************************************
                VALIDATE MODE
    **********************************************/

    if(
        (mode < EEPROM_MIN_MODE) ||
        (mode > EEPROM_MAX_MODE)
    )
    {
        Debug_Log(
            "[EEPROM] ERROR: Attempted to save invalid mode\r\n"
        );

        return;
    }


    Debug_Log("\r\n");

    Debug_Log(
        "[EEPROM] =============================\r\n"
    );

    Debug_Log(
        "[EEPROM] Saving configuration\r\n"
    );


    /**********************************************
                CALCULATE CHECKSUM
    **********************************************/

    checksum =
        EEPROM_CalculateChecksum(mode);


    Debug_Log("[EEPROM] Mode = ");
    Debug_LogDecimal(mode);

    Debug_Log("\r\n");


    Debug_Log(
        "[EEPROM] Calculated checksum = 0x"
    );

    Debug_LogHex(checksum);

    Debug_Log("\r\n");


    /**********************************************
                WRITE MODE
    **********************************************/

    Debug_Log(
        "[EEPROM] Writing MODE...\r\n"
    );

    EEPROM_WriteByte(
        EEPROM_MODE_ADDRESS,
        mode
    );

    /*
     * Give the watchdog a refresh between
     * EEPROM programming operations.
     */
    Watchdog_Refresh();


    /**********************************************
                WRITE CHECKSUM
    **********************************************/

    Debug_Log(
        "[EEPROM] Writing CHECKSUM...\r\n"
    );

    EEPROM_WriteByte(
        EEPROM_CHECKSUM_ADDRESS,
        checksum
    );

    Watchdog_Refresh();


    /**********************************************
                WRITE MAGIC LAST
    **********************************************/

    Debug_Log(
        "[EEPROM] Writing MAGIC...\r\n"
    );

    EEPROM_WriteByte(
        EEPROM_MAGIC_ADDRESS,
        EEPROM_MAGIC
    );

    Watchdog_Refresh();


    /**********************************************
                READ BACK
    **********************************************/

    Debug_Log(
        "[EEPROM] Verifying EEPROM...\r\n"
    );


    readBackMagic =
        EEPROM_ReadByte(
            EEPROM_MAGIC_ADDRESS
        );

    readBackMode =
        EEPROM_ReadByte(
            EEPROM_MODE_ADDRESS
        );

    readBackChecksum =
        EEPROM_ReadByte(
            EEPROM_CHECKSUM_ADDRESS
        );


    /*
     * Refresh watchdog after EEPROM verification
     * reads.
     */
    Watchdog_Refresh();


    Debug_Log(
        "[EEPROM] Read-back Magic: 0x"
    );

    Debug_LogHex(readBackMagic);

    Debug_Log("\r\n");


    Debug_Log(
        "[EEPROM] Read-back Mode: "
    );

    Debug_LogDecimal(readBackMode);

    Debug_Log("\r\n");


    Debug_Log(
        "[EEPROM] Read-back Checksum: 0x"
    );

    Debug_LogHex(readBackChecksum);

    Debug_Log("\r\n");


    /**********************************************
                VERIFY
    **********************************************/

    if(
        (readBackMagic == EEPROM_MAGIC) &&
        (readBackMode == mode) &&
        (readBackChecksum == checksum)
    )
    {
        Debug_Log(
            "[EEPROM] SAVE SUCCESS\r\n"
        );

        Debug_Log(
            "[EEPROM] Configuration verified OK\r\n"
        );
    }
    else
    {
        Debug_Log(
            "[EEPROM] ERROR: EEPROM verification FAILED\r\n"
        );
    }


    Debug_Log(
        "[EEPROM] =============================\r\n"
    );


    /*
     * Final watchdog refresh before returning
     * to the main loop.
     */
    Watchdog_Refresh();
}