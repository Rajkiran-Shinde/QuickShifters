#include "eeprom.h"
#include "debug.h"

/************ STM8 FLASH / EEPROM REGISTERS ************/

/*
 * STM8S003F3 register addresses
 */

#define FLASH_IAPSR     (*(volatile uint8_t*)0x505F)
#define FLASH_DUKR      (*(volatile uint8_t*)0x5064)

/************ FLASH_IAPSR BITS ************/

#define FLASH_IAPSR_DUL     0x08
#define FLASH_IAPSR_EOP     0x04


/************ INTERNAL FUNCTIONS ************/

/*
 * Unlock Data EEPROM for writing.
 *
 * STM8 requires the MASS key sequence:
 *
 *      0xAE
 *      0x56
 *
 * After the correct sequence, DUL becomes 1.
 */
static void EEPROM_Unlock(void)
{
    if((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
    {
        FLASH_DUKR = 0xAE;
        FLASH_DUKR = 0x56;

        /*
         * Wait until EEPROM write protection
         * has actually been removed.
         */
        while((FLASH_IAPSR & FLASH_IAPSR_DUL) == 0)
        {
            /* Wait */
        }
    }
}


/*
 * Calculate configuration checksum.
 *
 * The checksum is based on:
 *
 *      MAGIC ^ MODE ^ 0x5A
 */
static uint8_t EEPROM_CalculateChecksum(uint8_t mode)
{
    return (uint8_t)(EEPROM_MAGIC ^ mode ^ 0x5A);
}


/************ PUBLIC FUNCTIONS ************/


void EEPROM_Init(void)
{
//empty 
}


/*
 * Read one byte from EEPROM.
 */
uint8_t EEPROM_ReadByte(uint16_t address)
{
    uint8_t value;

    value = (*(volatile uint8_t*)address);

    return value;
}

/*
 * Write one byte to EEPROM.
 */
uint8_t EEPROM_WriteByte(uint16_t address, uint8_t value)
{
    EEPROM_Unlock();

    /*
     * Direct write to EEPROM address.
     *
     * STM8 performs the EEPROM erase/program cycle
     * automatically.
     */
    (*(volatile uint8_t*)address) = value;

    /*
     * Wait until programming is complete.
     */
    while((FLASH_IAPSR & FLASH_IAPSR_EOP) == 0)
    {
        /* Wait */
    }

    return TRUE;
}


/*
 * Load saved QuickShifter mode.
 *
 * Returns:
 *
 * 0 -> Mode 1
 * 1 -> Mode 2
 * 2 -> Mode 3
 * 3 -> Mode 4
 * 4 -> Mode 5
 *
 * If EEPROM data is invalid,
 * Mode 1 is returned.
 */
uint8_t EEPROM_LoadMode(void)
{
    uint8_t magic;
    uint8_t mode;
    uint8_t checksum;
    uint8_t expectedChecksum;

    Debug_Log("[EEPROM] Loading configuration...\r\n");

    magic = EEPROM_ReadByte(EEPROM_MAGIC_ADDRESS);
    mode = EEPROM_ReadByte(EEPROM_MODE_ADDRESS);
    checksum = EEPROM_ReadByte(EEPROM_CHECKSUM_ADDRESS);

    Debug_Log("[EEPROM] Magic: 0x");
    Debug_LogHex(magic);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Mode: ");
    Debug_LogDecimal(mode);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Checksum: 0x");
    Debug_LogHex(checksum);
    Debug_Log("\r\n");


    /*
     * Check magic number
     */
    if(magic != EEPROM_MAGIC)
    {
        Debug_Log("[EEPROM] ERROR: Invalid magic number\r\n");
        Debug_Log("[EEPROM] No valid configuration found\r\n");
        Debug_Log("[EEPROM] Using default Mode 1\r\n");

        return 0;
    }


    /*
     * Check mode range
     */
    if(mode > 4)
    {
        Debug_Log("[EEPROM] ERROR: Invalid mode value\r\n");
        Debug_Log("[EEPROM] Using default Mode 1\r\n");

        return 0;
    }


    /*
     * Calculate expected checksum
     */
    expectedChecksum = EEPROM_CalculateChecksum(mode);

    Debug_Log("[EEPROM] Expected checksum: 0x");
    Debug_LogHex(expectedChecksum);
    Debug_Log("\r\n");


    /*
     * Verify checksum
     */
    if(checksum != expectedChecksum)
    {
        Debug_Log("[EEPROM] ERROR: Checksum mismatch\r\n");
        Debug_Log("[EEPROM] EEPROM data may be corrupted\r\n");
        Debug_Log("[EEPROM] Using default Mode 1\r\n");

        return 0;
    }


    /*
     * Everything is valid
     */
    Debug_Log("[EEPROM] Configuration VALID\r\n");

    Debug_Log("[EEPROM] Restoring Mode: ");
    Debug_LogDecimal(mode);
    Debug_Log("\r\n");

    return mode;
}

/*
 * Save QuickShifter mode into EEPROM.
 */
 void EEPROM_SaveMode(uint8_t mode)
{
    uint8_t checksum;
    uint8_t readBackMode;
    uint8_t readBackMagic;
    uint8_t readBackChecksum;


    /*
     * Validate mode before writing.
     */
    if(mode > 4)
    {
        Debug_Log("[EEPROM] ERROR: Attempted to save invalid mode\r\n");
        return;
    }


    Debug_Log("\r\n");
    Debug_Log("[EEPROM] =============================\r\n");
    Debug_Log("[EEPROM] Saving configuration\r\n");


    Debug_Log("[EEPROM] Mode = ");
    Debug_LogDecimal(mode);
    Debug_Log("\r\n");


    checksum = EEPROM_CalculateChecksum(mode);

    Debug_Log("[EEPROM] Calculated checksum = 0x");
    Debug_LogHex(checksum);
    Debug_Log("\r\n");


    /*
     * Write MODE
     */
    Debug_Log("[EEPROM] Writing MODE...\r\n");

    EEPROM_WriteByte(
        EEPROM_MODE_ADDRESS,
        mode
    );


    /*
     * Write CHECKSUM
     */
    Debug_Log("[EEPROM] Writing CHECKSUM...\r\n");

    EEPROM_WriteByte(
        EEPROM_CHECKSUM_ADDRESS,
        checksum
    );


    /*
     * Write MAGIC LAST
     */
    Debug_Log("[EEPROM] Writing MAGIC...\r\n");

    EEPROM_WriteByte(
        EEPROM_MAGIC_ADDRESS,
        EEPROM_MAGIC
    );


    /*
     * Read everything back.
     */
    Debug_Log("[EEPROM] Verifying EEPROM...\r\n");

    readBackMagic =
        EEPROM_ReadByte(EEPROM_MAGIC_ADDRESS);

    readBackMode =
        EEPROM_ReadByte(EEPROM_MODE_ADDRESS);

    readBackChecksum =
        EEPROM_ReadByte(EEPROM_CHECKSUM_ADDRESS);


    Debug_Log("[EEPROM] Read-back Magic: 0x");
    Debug_LogHex(readBackMagic);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Read-back Mode: ");
    Debug_LogDecimal(readBackMode);
    Debug_Log("\r\n");

    Debug_Log("[EEPROM] Read-back Checksum: 0x");
    Debug_LogHex(readBackChecksum);
    Debug_Log("\r\n");


    /*
     * Verify everything.
     */
    if((readBackMagic == EEPROM_MAGIC) &&
       (readBackMode == mode) &&
       (readBackChecksum == checksum))
    {
        Debug_Log("[EEPROM] SAVE SUCCESS\r\n");
        Debug_Log("[EEPROM] Configuration verified OK\r\n");
    }
    else
    {
        Debug_Log("[EEPROM] ERROR: EEPROM verification FAILED\r\n");
    }


    Debug_Log("[EEPROM] =============================\r\n");
}