# Phase 1 – GPIO, Button Interface, Relay Pulse & Timer Validation

## Project

Quick Shifter Firmware

Platform:
- STM8S003F3P6
- Cosmic Compiler
- ST Visual Develop (STVD)
- ST Visual Programmer (STVP)

---

# Objective

The objective of this phase was to build the hardware abstraction layer required
for the Quick Shifter firmware.

Instead of directly writing application logic, the firmware was divided into
independent modules to improve readability, scalability and maintainability.

The following features were implemented.

? GPIO Driver

? Button Driver

? Clock Configuration

? TIM4 Delay Driver

? Relay Pulse Generation

? QuickShifter Application Layer

---

# Hardware Used

Controller

STM8S003F3P6

Clock

Internal High Speed Oscillator (HSI)

Configured Frequency

16 MHz

Programming Interface

ST-Link V2

---

# Hardware Connections

## Button

PD3

Configuration

Input Pull-up

Circuit

PD3
 ¦
Push Button
 ¦
GND

Released

Logic HIGH

Pressed

Logic LOW

---

## Relay Module

PD2

Configuration

Push Pull Output

Connection

STM8 PD2 -------------- IN

5V --------------------- VCC

GND -------------------- GND

STM8 GND --------------- GND

The relay module already contains

• Driver Transistor

• Flyback Diode

• Status LED

No external MOSFET was used during this phase.

---

# Firmware Architecture

Application Layer

main.c

?

QuickShifter.c

?

Button Driver

Relay Driver

Timer Driver

GPIO Driver

?

STM8 Hardware Registers

This architecture keeps the application independent from hardware details.

---

# Project Structure

Include

common.h

config.h

stm8_hw.h

gpio.h

button.h

timer.h

clock.h

relay.h

quickshifter.h

Source

main.c

gpio.c

button.c

timer.c

clock.c

relay.c

quickshifter.c

---

# Module Description

## common.h

Contains

• Standard data types

uint8_t

uint16_t

uint32_t

• TRUE

• FALSE

Purpose

Provides common definitions used by every module.

---

## config.h

Contains project level configuration.

Example

Relay Pin

Button Pin

Future versions will also contain

Shift Time

Mode Selection

EEPROM Addresses

etc.

Changing a pin only requires modifying one file.

---

## stm8_hw.h

Contains STM8 register definitions.

Example

PD_ODR

PD_IDR

PD_DDR

PD_CR1

PD_CR2

TIM4 Registers

Clock Registers

Purpose

Separates hardware register addresses from application code.

---

## gpio.c

Purpose

Provides reusable GPIO functions.

Functions

GPIO_Output_PP()

GPIO_Input_PU()

GPIO_Set()

GPIO_Clear()

GPIO_Toggle()

GPIO_Read()

The application never directly accesses registers.

---

## button.c

Purpose

Handles button interface.

Features

Internal Pull-up

Software Debounce

Press Detection

Button Release Detection

The application simply calls

Button_GetPress()

---

## clock.c

Purpose

Configures the STM8 clock.

Default STM8 Frequency

2 MHz

Configured Frequency

16 MHz

Function

CLK_Init()

Reason

All timing calculations are based on 16 MHz.

---

## timer.c

Purpose

Provides accurate millisecond delays.

Peripheral Used

TIM4

Functions

TIM4_Init()

TIM4_Delay_ms()

Current Usage

Relay pulse generation

Button debounce

Future Usage

Shift timing

State machine timing

Timeout management

---

## relay.c

Purpose

Provides relay abstraction.

Functions

Relay_Init()

Relay_On()

Relay_Off()

Relay_Pulse()

The application never directly controls GPIO.

---

## quickshifter.c

Purpose

Contains application logic.

Current Logic

Button Press

?

Relay ON

?

40 ms Delay

?

Relay OFF

Future versions will include

Trigger Detection

Mode Selection

EEPROM

Engine Cut Timing

State Machine

---

# GPIO Configuration

## Relay Output

Pin

PD2

Mode

Output

Push Pull

Slow Mode

Interrupt

Disabled

Registers

DDR = 1

CR1 = 1

CR2 = 0

---

## Button Input

Pin

PD3

Mode

Input Pull-up

Interrupt

Disabled

Registers

DDR = 0

CR1 = 1

CR2 = 0

Released

HIGH

Pressed

LOW

---

# Button Debouncing

Mechanical push buttons do not produce a clean transition.

Instead they generate multiple transitions within a few milliseconds.

Without debouncing

HIGH

LOW

HIGH

LOW

HIGH

LOW

The controller interprets multiple presses.

Solution

After detecting LOW

?

Delay 20 ms

?

Read Again

?

Still LOW

?

Valid Press

?

Wait Until Button Release

?

Return TRUE

Result

One physical press generates one software event.

---

# Relay Operation

Button Press

?

Relay ON

?

40 ms

?

Relay OFF

Current pulse width

40 ms

Future versions

40

50

60

70

80

ms

Selectable using mode button.

---

# Design Decisions

Why Bare Metal?

Provides complete hardware control.

No dependency on vendor libraries.

Improves understanding of STM8 peripherals.

Easy to port to other STM8 devices.

---

Why Drivers?

Keeps application clean.

Improves code reuse.

Reduces maintenance.

Supports future expansion.

---

Why Modules?

Every module has only one responsibility.

GPIO

Only GPIO

Button

Only Button

Timer

Only Timer

Relay

Only Relay

QuickShifter

Only application logic

This follows the Single Responsibility Principle.

---

# Current Firmware Flow

Power ON

?

Clock Initialization

?

GPIO Initialization

?

Button Initialization

?

Timer Initialization

?

Relay Initialization

?

Infinite Loop

?

Button Press ?

?

No

?

Repeat

?

Yes

?

Relay ON

?

40 ms Delay

?

Relay OFF

?

Repeat

---

# Current Status

Completed

? GPIO Driver

? Button Driver

? Software Debounce

? Clock Configuration

? TIM4 Delay

? Relay Driver

? QuickShifter Application Layer

Hardware Tested

? Button

? Relay Module

? 40 ms Pulse

Pending

? Non-blocking State Machine

? EEPROM

? Shift Modes

? Trigger Filtering

? Final PCB

---

# Lessons Learned

1. Always initialize the clock before timers.

2. Keep GPIO access inside dedicated drivers.

3. Separate hardware drivers from application logic.

4. Debounce should be handled inside the button driver.

5. Application code should remain hardware independent.

---

# Version

Firmware Version

v0.1

Author

Rajkiran Shinde

Project

Quick Shifter Firmware

Date

August 2026