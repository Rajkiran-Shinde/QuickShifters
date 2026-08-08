#ifndef DEBUG_H
#define DEBUG_H

#include "common.h"

/************************************************
                DEBUG
************************************************/

void Debug_Init(void);

void Debug_Log(const char *message);

void Debug_LogState(uint8_t state);

void Debug_LogShift(uint16_t shift_time);

void Debug_LogMode(uint8_t mode, uint16_t cut_time);

#endif