#ifndef EEPROM_H
#define EEPROM_H

#include "common.h"

/************ EEPROM MEMORY ************/

#define EEPROM_BASE_ADDRESS       0x4000


/************ EEPROM CONFIGURATION ************/

/*
 * EEPROM configuration layout:
 *
 * 0x4000 -> Magic / configuration version
 * 0x4001 -> User mode (1-5)
 * 0x4002 -> Checksum
 */

#define EEPROM_MAGIC_ADDRESS      0x4000
#define EEPROM_MODE_ADDRESS       0x4001
#define EEPROM_CHECKSUM_ADDRESS   0x4002


/*
 * EEPROM configuration version.
 *
 * 0xA5 = old zero-based format
 * 0xA6 = current one-based format
 */
#define EEPROM_MAGIC              0xA6

#define EEPROM_LEGACY_MAGIC       0xA5


/************ MODE LIMITS ************/

#define EEPROM_MIN_MODE           1
#define EEPROM_MAX_MODE           5


/************ PUBLIC FUNCTIONS ************/

void EEPROM_Init(void);

uint8_t EEPROM_ReadByte(uint16_t address);

uint8_t EEPROM_WriteByte(
    uint16_t address,
    uint8_t value
);

uint8_t EEPROM_LoadMode(void);

void EEPROM_SaveMode(uint8_t mode);

#endif