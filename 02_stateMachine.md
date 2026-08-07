
# Quick Shifter Firmware Documentation

# Part 2 – Firmware Architecture & Non-Blocking System

## Overview

After validating the basic hardware (STM8S003F3, relay module, shift button, and GPIO operation), the firmware was redesigned to follow a modular and scalable architecture. The objective was to eliminate blocking delays and prepare the firmware for future features such as multiple shift modes, EEPROM storage, and safety mechanisms.

This phase focused on building the software foundation rather than adding new features.

---

# Objectives

The goals of this phase were:

* Replace blocking delays with timer-based execution.
* Generate an accurate 1 ms system tick.
* Develop reusable software timers.
* Design a finite state machine (FSM) for the quick shifter.
* Build a non-blocking button driver.
* Establish a scalable firmware architecture suitable for future expansion.

---

# System Clock Configuration

Initially, the STM8S003F3 runs from the internal High-Speed Internal (HSI) oscillator at **16 MHz** with a default clock divider of **8**, resulting in a CPU frequency of **2 MHz**.

To improve timer accuracy and overall performance, the firmware configures the clock divider to **1**, allowing the CPU to operate at the full **16 MHz**.

```c
CLK_CKDIVR = 0x00;
```

Result:

```
HSI Oscillator : 16 MHz
Clock Divider  : 1
CPU Frequency  : 16 MHz
```

Operating at 16 MHz enables precise timer calculations and provides sufficient processing time for future features.

---

# Hardware Timer (TIM4)

## Purpose

A hardware timer was required to create a reliable system time base.

TIM4 was selected because:

* Available on STM8S003F3
* Simple 8-bit timer
* Dedicated update interrupt
* Suitable for operating system style system ticks

---

## Timer Configuration

| Parameter         |   Value |
| ----------------- | ------: |
| CPU Clock         |  16 MHz |
| Prescaler         |     128 |
| Timer Clock       | 125 kHz |
| Auto Reload (ARR) |     124 |
| Interrupt Period  |    1 ms |

Calculation:

```
16 MHz / 128 = 125000 Hz

125000 / 125 = 1000 Hz

Interrupt Period = 1 ms
```

---

## Timer Driver

A dedicated timer driver was created.

### timer.h

Responsible for:

* Timer initialization
* Tick retrieval
* Delay function (for initialization only)
* ISR interface

### timer.c

Responsible for:

* TIM4 configuration
* System tick generation
* Tick management

The timer module hides all TIM4 hardware details from the application layer.

---

# System Tick

A global millisecond counter was introduced.

```c
volatile uint32_t system_tick;
```

Every TIM4 interrupt increments this variable.

```
TIM4 Interrupt

?

system_tick++
```

The system tick becomes the common time reference for the entire firmware.

---

# Timer API

The timer driver exposes the following interface:

```c
void Timer_Init(void);

uint32_t Timer_GetTick(void);

void Timer_Delay(uint32_t ms);

void Timer_TickISR(void);
```

`Timer_Delay()` is retained only for initialization and debugging. Application code should avoid using blocking delays.

---

# Interrupt Vector Integration

TIM4 Update/Overflow interrupt was connected to interrupt vector 23.

The ISR performs only two operations:

* Clear interrupt flag
* Update system tick

This follows the embedded software principle:

> Keep interrupt service routines as short as possible.

---

# Timer Verification

The timer was verified by toggling the relay output every 500 ms using the system tick.

```text
Timer_GetTick()

?

500 ms elapsed?

?

Toggle Output
```

Successful verification confirmed:

* Correct clock configuration
* Proper interrupt vector mapping
* Working TIM4 interrupt
* Accurate 1 ms system tick

---

# Software Timer Module

## Motivation

Using blocking delays prevents the CPU from executing other tasks.

Example:

```c
Timer_Delay(40);
```

During these 40 ms:

* Button cannot be read
* State machine cannot execute
* Safety logic stops
* Future features become impossible

Instead, software timers store:

* Start time
* Duration
* Active status

Example:

```c
SoftwareTimer_Start(&relayTimer,40);

if(SoftwareTimer_Expired(&relayTimer))
{
    ...
}
```

This allows multiple independent timers to operate simultaneously using the same hardware timer.

---

# Software Timer Structure

```c
typedef struct
{
    uint32_t start_time;
    uint32_t duration;
    uint8_t active;

} SoftwareTimer_t;
```

---

# Software Timer API

```c
void SoftwareTimer_Start();

void SoftwareTimer_Stop();

uint8_t SoftwareTimer_Expired();

uint8_t SoftwareTimer_IsRunning();
```

This module forms the timing backbone of the firmware.

---

# Quick Shifter State Machine

The original firmware executed sequentially.

```
Button

?

Relay ON

?

Delay

?

Relay OFF
```

This architecture was replaced by a finite state machine.

---

## State Diagram

```
                +----------------------+
                |        IDLE          |
                +----------+-----------+
                           |
                           | Shift Detected
                           |
                           ?
                +----------------------+
                |    CUT_ACTIVE        |
                +----------+-----------+
                           |
                           | Cut Time Expired
                           |
                           ?
                +----------------------+
                |     COOLDOWN         |
                +----------+-----------+
                           |
                           | Cooldown Complete
                           |
                           ?
                +----------------------+
                |   WAIT_RELEASE       |
                +----------+-----------+
                           |
                           | Button Released
                           |
                           ?
                        IDLE
```

---

## State Description

### IDLE

System waits for a valid shift input.

---

### CUT_ACTIVE

Relay activates, interrupting ignition.

A software timer measures the cut duration.

---

### COOLDOWN

After relay deactivation, the firmware ignores new requests for a fixed period.

This prevents repeated triggering caused by linkage vibration.

---

### WAIT_RELEASE

The firmware waits until the shift sensor is released.

This guarantees only one ignition cut per gear shift.

---

# Button Driver Redesign

The original button driver used:

```c
Timer_Delay(20);

while(button_pressed);
```

This caused:

* Blocking execution
* Ignition cut only after button release
* Poor scalability

The driver was redesigned into its own finite state machine.

---

## Button States

```
Released

?

Debounce Press

?

Pressed

?

Debounce Release

?

Released
```

The new driver:

* Debounces using software timers.
* Generates a single press event.
* Does not block execution.
* Detects the press immediately rather than waiting for release.

---

# Main Application Loop

The firmware now executes continuously without blocking.

```c
while(1)
{
    Button_Update();

    QuickShifter_Task();
}
```

Every module executes independently and cooperatively.

---

# Layered Firmware Architecture

```
                    main()

                      ¦

                      ?

            QuickShifter_Task()

                      ¦

      +-------------------------------+

      ?                               ?

 Button Driver                 Software Timer

      ¦                               ¦

      +-------------------------------+

                      ?

                 Timer Driver

                      ¦

                      ?

                 TIM4 Hardware
```

Each layer performs a single responsibility.

---

# Lessons Learned

During this development phase several important embedded software concepts were implemented:

* System clock configuration
* Hardware timer configuration
* Interrupt vector mapping
* Interrupt Service Routine design
* Millisecond system tick generation
* Software timer implementation
* Event-driven programming
* Finite State Machine design
* Layered firmware architecture
* Non-blocking embedded software design
* Modular driver development
* Separation of hardware and application layers

---

# Current Project Status

| Module                      | Status       |
| --------------------------- | ------------ |
| Clock Driver                | ? Complete   |
| GPIO Driver                 | ? Complete   |
| Relay Driver                | ? Complete   |
| Hardware Timer (TIM4)       | ? Complete   |
| Software Timer              | ? Complete   |
| Button Driver (FSM)         | ? Complete   |
| Quick Shifter State Machine | ? Complete   |
| 5 Shift Modes               | ? Next Phase |
| EEPROM Storage              | ? Planned    |
| Safety Features             | ? Planned    |

---

# Next Development Phase (Part 3)

The next phase of development will focus on product-level functionality:

* Implement five selectable ignition cut modes.
* Add mode selection button.
* Store the selected mode in internal EEPROM.
* Restore the saved mode on power-up.
* Add LED indication for the active mode.
* Implement startup self-test.
* Add relay timeout protection.
* Add shift sensor fault detection.
* Improve overall firmware robustness.


