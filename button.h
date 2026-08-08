#ifndef BUTTON_H
#define BUTTON_H

#include "common.h"

/************************************************
                SHIFT BUTTON
************************************************/

void Button_Init(void);
void Button_Update(void);

uint8_t Button_GetPress(void);
uint8_t Button_IsPressed(void);


/************************************************
                MODE BUTTON
************************************************/

void ModeButton_Init(void);
void ModeButton_Update(void);

uint8_t ModeButton_GetPress(void);

#endif