#ifndef CONFIG_H
#define CONFIG_H

#include "gpio.h"

/************ DEBUG ************/

#define DEBUG_UART_ENABLED    1
#define DEBUG_BAUDRATE        9600

/************ RELAY ************/

#define RELAY_PORT PORT_D
#define RELAY_PIN  PIN2

/************ BUTTON ************/

#define BUTTON_PORT PORT_D
#define BUTTON_PIN  PIN3

//Mode Selection button 
#define MODE_BUTTON_PORT PORT_D
#define MODE_BUTTON_PIN  PIN4

//DEBOUNCE DELAY
#define BUTTON_DEBOUNCE_TIME    20 

#endif