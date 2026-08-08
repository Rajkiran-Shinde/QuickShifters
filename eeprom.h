#ifndef EEPROM_H
#define EEPROM_H

#include "common.h"

/************ EEPROM MEMORY ************/

#define EEPROM_BASE_ADDRESS       0x4000

/************ EEPROM CONFIGURATION ************/

#define EEPROM_MAGIC_ADDRESS      0x4000
#define EEPROM_MODE_ADDRESS       0x4001
#define EEPROM_CHECKSUM_ADDRESS   0x4002

#define EEPROM_MAGIC              0xA5

/************ PUBLIC FUNCTIONS ************/

/* Initialize EEPROM access */
void EEPROM_Init(void);

/* Read one byte from EEPROM */
uint8_t EEPROM_ReadByte(uint16_t address);

/* Write one byte to EEPROM */
uint8_t EEPROM_WriteByte(uint16_t address, uint8_t value);

/* Load saved QuickShifter mode */
uint8_t EEPROM_LoadMode(void);

/* Save QuickShifter mode */
void EEPROM_SaveMode(uint8_t mode);

#endif