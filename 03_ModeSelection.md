# QuickShifter Firmware – Development Log Part 3
## UART Debugging, Mode Selection & Configurable Shift Timing

---

## 1. Overview

In this development stage, the QuickShifter firmware was extended with:

- UART-based debugging
- A dedicated debug abstraction layer
- Temporary USB-to-UART debugging using an ESP8266 NodeMCU board
- Serial monitoring through the onboard CP210x USB-UART bridge
- A second push button for mode selection
- Five configurable QuickShifter operating modes
- Mode-dependent shift cut timing
- Separation between mode selection and timer execution
- Debug output for monitoring the selected operating mode

The objective was to make the firmware easier to test and tune during development while keeping the debugging functionality removable from the final production firmware.

---

# 2. Development Debugging Architecture

The debugging architecture was designed so that the application code does not directly access UART registers.

The architecture is:

```text
QuickShifter Application
          ¦
          ?
       debug.c
       debug.h
          ¦
          ?
        uart.c
        uart.h
          ¦
          ?
      STM8 UART1
          ¦
          ?
      PD5 / TX
          ¦
          ?
 ESP8266 NodeMCU
   CP210x USB-UART
          ¦
          ?
         USB
          ¦
          ?
         PC
          ¦
          ?
      CoolTerm
````

This provides a clean separation between:

* Application logic
* Debugging functionality
* UART hardware implementation

---

# 3. UART Implementation

A dedicated UART driver was created:

```text
uart.c
uart.h
```

The driver provides:

```c
void UART_Init(void);
void UART_SendChar(char c);
void UART_SendString(const char *str);
```

The application does not directly manipulate UART registers.

Instead, it uses:

```c
Debug_Log("message");
```

which internally uses the UART driver.

---

# 4. STM8 UART Configuration

The STM8S003F3 UART1 peripheral is used for debugging.

The transmit pin is:

```text
PD5 ? UART1_TX
```

The current debug configuration is:

```text
Baud Rate : 9600
Data      : 8 bits
Parity    : None
Stop      : 1
```

Therefore:

```text
9600 8-N-1
```

The UART baud-rate configuration used for a 16 MHz system clock is:

```c
UART1_BRR1 = 0x68;
UART1_BRR2 = 0x02;
```

The UART driver configures PD5 as:

```text
Output
Push-Pull
Fast Mode
```

and enables the UART transmitter.

---

# 5. UART Debug Interface

A separate debug abstraction layer was created:

```text
debug.c
debug.h
```

The main functions are:

```c
void Debug_Init(void);

void Debug_Log(const char *message);

void Debug_LogState(uint8_t state);

void Debug_LogShift(uint16_t shift_time);

void Debug_LogMode(uint8_t mode, uint16_t cut_time);
```

The purpose of this layer is to prevent application code from becoming dependent on UART hardware.

For example, the QuickShifter firmware can simply call:

```c
Debug_Log("SHIFT DETECTED\r\n");
```

instead of directly accessing:

```c
UART1_DR
UART1_SR
UART1_BRR1
UART1_BRR2
```

---

# 6. Debug Enable / Disable

Debugging is controlled using:

```c
#define DEBUG_UART_ENABLED
```

When debugging is enabled:

```c
#define DEBUG_UART_ENABLED 1
```

the debug functions transmit data through UART.

For production:

```c
#define DEBUG_UART_ENABLED 0
```

the debug functions become empty stubs.

This allows the same application code to remain in the project without requiring the production hardware to contain a USB-UART interface.

The intended architecture is:

```text
Development:

QuickShifter
     ¦
     ?
   Debug
     ¦
     ?
   UART
     ¦
     ?
 USB-UART
     ¦
     ?
    PC
```

Production:

```text
QuickShifter
     ¦
     ?
   Debug
     ¦
     ?
   Disabled
```

---

# 7. Temporary ESP8266 Debugging Interface

An ESP8266 NodeMCU development board was used as a temporary USB-to-UART interface.

The NodeMCU board contains a CP210x USB-UART bridge.

The ESP8266 itself is not being used as the communication processor in this configuration.

The USB-UART bridge is being used to convert:

```text
STM8 UART
    ?
TTL UART
    ?
USB
```

for monitoring on the PC.

---

# 8. Final Working UART Connection

The following connection was successfully tested:

```text
STM8S003F3                 NodeMCU

PD5 / UART1_TX ----------- TX pin

GND ---------------------- GND
```

The NodeMCU was connected to the PC through USB.

The NodeMCU `EN` pin was held LOW during the USB-UART-only testing configuration:

```text
EN ? GND
```

The STM8 RX pin was not required for the current debugging system because communication is currently one-way:

```text
STM8 ? PC
```

Therefore:

```text
PD6 / UART1_RX
```

is currently unused.

---

# 9. Important NodeMCU Pin Discovery

During testing, an important pin-mapping issue was discovered.

Initially the STM8 UART TX was connected to the NodeMCU pin labelled:

```text
RX
```

No data was received.

A UART loopback test was performed on the NodeMCU:

```text
NodeMCU TX ? NodeMCU RX
```

The loopback successfully demonstrated that the CP210x USB-UART bridge was functional.

For the NodeMCU board being used as a USB-UART bridge, the working STM8 connection was found to be:

```text
STM8 PD5 / TX ? NodeMCU TX pin
```

This allowed the signal to reach the CP210x RX input and then the PC.

The final tested connection is therefore:

```text
STM8 TX
   ¦
   ?
NodeMCU TX-labelled pin
   ¦
   ?
CP210x RX
   ¦
   ?
USB
   ¦
   ?
PC
```

---

# 10. Serial Monitor Testing

CoolTerm was used as the serial monitor.

The final working configuration was:

```text
COM Port : COM10
Baud     : 9600
Data     : 8
Parity   : None
Stop     : 1
Local Echo : OFF
```

The STM8 successfully transmitted:

```text
================================
 QuickShifter Debug Console
================================
STM8 UART TEST
QuickShifter Debug Started
```

This confirmed that the complete communication chain was operational:

```text
STM8S003F3
     ?
UART1
     ?
PD5
     ?
NodeMCU / CP210x
     ?
USB
     ?
COM10
     ?
CoolTerm
```

---

# 11. Initial UART Test

Before adding application-level debugging, a simple test message was added to `main.c`:

```c
Debug_Init();

Debug_Log("STM8 UART TEST\r\n");
Debug_Log("QuickShifter Debug Started\r\n");
```

This was used to verify the UART hardware and software independently from the QuickShifter state machine.

Once the messages were successfully received, UART debugging was considered operational.

---

# 12. Why UART Debugging Is Event-Based

The QuickShifter contains timing-critical operations.

The relay cut time is in the range of tens of milliseconds.

Because UART transmission is relatively slow, excessive debug messages can interfere with firmware timing.

Therefore, debugging should be performed on significant events rather than continuously inside the main loop.

### Recommended:

```text
SHIFT DETECTED
RELAY ON
RELAY OFF
STATE CHANGE
MODE CHANGE
```

### Avoid:

```text
STATE = IDLE
STATE = IDLE
STATE = IDLE
STATE = IDLE
...
```

The debug system is therefore intended primarily for event-based logging.

---

# 13. Five Operating Modes

A five-mode system was introduced to make the QuickShifter cut time configurable.

The current modes are:

| Mode   | Cut Time |
| ------ | -------- |
| Mode 1 | 40 ms    |
| Mode 2 | 50 ms    |
| Mode 3 | 60 ms    |
| Mode 4 | 70 ms    |
| Mode 5 | 80 ms    |

The sequence is:

```text
Mode 1
  ?
Mode 2
  ?
Mode 3
  ?
Mode 4
  ?
Mode 5
  ?
Mode 1
  ?
...
```

---

# 14. Mode Manager

The mode logic is separated into:

```text
mode.c
mode.h
```

The mode manager is responsible for:

* Maintaining the current mode
* Switching to the next mode
* Returning the current mode
* Returning the selected cut time

The mode enumeration is:

```c
typedef enum
{
    QS_MODE_1 = 0,
    QS_MODE_2,
    QS_MODE_3,
    QS_MODE_4,
    QS_MODE_5

} QuickShifterMode_t;
```

---

# 15. Mode Timing Table

The timing values are stored in a constant array:

```c
static const uint16_t cutTimes[5] =
{
    40,
    50,
    60,
    70,
    80
};
```

The relationship is:

```text
Array Index      Cut Time

     0    ------- 40 ms
     1    ------- 50 ms
     2    ------- 60 ms
     3    ------- 70 ms
     4    ------- 80 ms
```

The current mode variable contains the array index.

For example:

```text
currentMode = 0
```

means:

```text
Mode 1
Cut = 40 ms
```

while:

```text
currentMode = 2
```

means:

```text
Mode 3
Cut = 60 ms
```

---

# 16. Mode Selection Logic

The mode button calls:

```c
Mode_Next();
```

The logic is:

```c
void Mode_Next(void)
{
    currentMode++;

    if(currentMode >= MODE_COUNT)
    {
        currentMode = QS_MODE_1;
    }
}
```

Therefore:

```text
0 ? 1 ? 2 ? 3 ? 4 ? 0
```

The wrap-around allows the user to continuously cycle through the five modes.

---

# 17. Getting the Selected Cut Time

The selected timing value is obtained using:

```c
uint16_t Mode_GetCutTime(void)
{
    return cutTimes[currentMode];
}
```

For example:

```text
currentMode = 0
        ?
cutTimes[0]
        ?
40 ms
```

or:

```text
currentMode = 3
        ?
cutTimes[3]
        ?
70 ms
```

---

# 18. Mode Button

Instead of creating a separate source file for the mode button, the existing:

```text
button.c
button.h
```

module is being extended.

This avoids duplicating the existing debounce implementation.

The button module now conceptually contains:

```text
button.c
¦
+-- Shift Button
¦   +-- Button_Init()
¦   +-- Button_Update()
¦   +-- Button_GetPress()
¦
+-- Mode Button
    +-- ModeButton_Init()
    +-- ModeButton_Update()
    +-- ModeButton_GetPress()
```

This keeps all physical push-button handling in one module.

---

# 19. Button GPIO Allocation

The current GPIO allocation is:

```text
PD2 ? Relay
PD3 ? Shift Button
PD4 ? Mode Button
PD5 ? UART1 TX
PD6 ? UART1 RX (currently unused)
```

The new mode button is connected as:

```text
PD4 ------- Push Button ------- GND
```

The internal pull-up resistor is used.

Therefore:

```text
Button Released ? PD4 = HIGH

Button Pressed  ? PD4 = LOW
```

The same debounce approach used by the existing shift button is used for the mode button.

---

# 20. Mode Button Debouncing

The mode button uses the existing software timer infrastructure for debouncing.

The debounce period is:

```c
#define BUTTON_DEBOUNCE_TIME 20
```

The button state machine follows:

```text
RELEASED
    ¦
    ¦ Button pressed
    ?
DEBOUNCE_PRESS
    ¦
    ¦ 20 ms stable
    ?
PRESSED
    ¦
    ¦ Button released
    ?
DEBOUNCE_RELEASE
    ¦
    ¦ 20 ms stable
    ?
RELEASED
```

A single valid button press generates one event:

```c
ModeButton_GetPress()
```

This prevents switch bounce from changing multiple modes from one physical press.

---

# 21. Mode Selection Flow

The complete mode selection process is:

```text
User presses MODE button
          ¦
          ?
        PD4
          ¦
          ?
ModeButton_Update()
          ¦
          ?
Debounce
          ¦
          ?
ModeButton_GetPress()
          ¦
          ?
      Mode_Next()
          ¦
          ?
 currentMode changes
          ¦
          ?
Mode_GetCutTime()
          ¦
          ?
Selected cut time
```

---

# 22. Example Mode Sequence

Starting from the default:

```text
Mode 1
40 ms
```

Pressing the mode button once:

```text
Mode 2
50 ms
```

Second press:

```text
Mode 3
60 ms
```

Third press:

```text
Mode 4
70 ms
```

Fourth press:

```text
Mode 5
80 ms
```

Fifth press:

```text
Mode 1
40 ms
```

---

# 23. Relationship Between Mode and Timer

An important design concept is that the **Mode Manager does not measure time**.

The Mode Manager only determines the requested duration:

```text
Mode Manager
     ¦
     ?
40 / 50 / 60 / 70 / 80 ms
```

The existing software timer is responsible for measuring the elapsed time.

The intended flow is:

```text
Mode Manager
     ¦
     ¦ Selected duration
     ?
QuickShifter
     ¦
     ?
SoftwareTimer_Start()
     ¦
     ?
Hardware Timer Tick
     ¦
     ?
Elapsed Time
     ¦
     ?
SoftwareTimer_Expired()
     ¦
     ?
Relay OFF
```

Therefore, the five modes do not create five different hardware timers.

The same timer system is reused with a different target duration.

---

# 24. Example: Mode 3

Suppose the user selects:

```text
Mode 3
```

The mode manager returns:

```text
60 ms
```

The QuickShifter will eventually use:

```c
SoftwareTimer_Start(&relayTimer,
                    Mode_GetCutTime());
```

which is equivalent to:

```c
SoftwareTimer_Start(&relayTimer, 60);
```

The timer then measures the elapsed time until the requested duration has passed.

Conceptually:

```text
Relay ON
   ¦
   +-- 1 ms
   +-- 2 ms
   +-- 3 ms
   ¦
   ¦   ...
   ¦
   +-- 59 ms
   +-- 60 ms
          ¦
          ?
       Timer Expired
          ¦
          ?
       Relay OFF
```

---

# 25. Important Current Status

At this stage, the following components have been implemented:

```text
[?] UART driver
[?] UART1 TX on PD5
[?] 9600 baud communication
[?] Debug abstraction layer
[?] Debug enable/disable mechanism
[?] ESP8266/CP210x USB-UART debugging
[?] CoolTerm serial monitoring
[?] Second mode button
[?] Mode button debounce
[?] Five operating modes
[?] Mode cycling
[?] Mode-dependent timing table
[?] UART mode reporting
```

The next firmware integration step is to ensure the actual QuickShifter relay timer uses:

```c
Mode_GetCutTime()
```

instead of the previous fixed shift-time value.

---

# 26. Current Firmware Architecture

The project is now structured conceptually as:

```text
                         MAIN
                          ¦
          +---------------+----------------+
          ¦               ¦                ¦
          ?               ?                ?
      Shift Button    Mode Button      Debug
          ¦               ¦                ¦
          ?               ?                ?
       button.c        button.c         debug.c
          ¦               ¦                ¦
          ¦               ?                ?
          ¦            mode.c           uart.c
          ¦               ¦                ¦
          ¦               ?                ?
          ¦          Cut Time           UART1
          ¦               ¦                ¦
          +---------------¦                ¦
                          ?                ¦
                    QuickShifter           ¦
                          ¦                ¦
                          ?                ¦
                   Software Timer          ¦
                          ¦                ¦
                          ?                ¦
                       Relay               ¦
                                           ¦
                                           ?
                                  NodeMCU / CP210x
                                           ¦
                                           ?
                                        CoolTerm
```

---

# 27. Development Hardware Configuration

Current development setup:

```text
STM8S003F3
¦
+-- PD2 ? Relay Module
¦
+-- PD3 ? Shift Button
¦
+-- PD4 ? Mode Button
¦
+-- PD5 ? UART TX
             ¦
             ?
        NodeMCU / CP210x
             ¦
             ?
            USB
             ¦
             ?
            PC
             ¦
             ?
          CoolTerm
```

The ESP8266 NodeMCU is being used only as a temporary debugging interface.

It is not part of the intended production QuickShifter architecture.

---

# 28. Production Consideration

The debug system is intentionally designed to be removable.

During development:

```text
STM8
 ¦
 +-- UART TX ? Debug Interface ? PC
```

During production:

```text
DEBUG_UART_ENABLED = 0
```

and the debug output is disabled.

The production PCB can optionally expose a small debug header containing:

```text
GND
TX
RX
```

This allows debugging hardware to be connected when required without permanently including the USB-UART converter in the final product.

---

# 29. Next Development Step

The next task is to integrate the mode timing directly into the QuickShifter state machine.

The current target is:

```c
SoftwareTimer_Start(
    &relayTimer,
    Mode_GetCutTime()
);
```

After this integration, the complete system will work as:

```text
                MODE BUTTON
                     ¦
                     ?
             Select Mode 1–5
                     ¦
                     ?
            Select 40–80 ms
                     ¦
                     ?
                SHIFT EVENT
                     ¦
                     ?
                RELAY ON
                     ¦
                     ?
              Software Timer
                     ¦
                     ?
            Selected time elapsed
                     ¦
                     ?
                RELAY OFF
```

The UART debugger will then be used to verify the complete sequence and selected timing during development.

````

### Current milestone

The most important thing we've achieved in this stage is that **the STM8 is now talking to your PC through UART successfully**, and we've built the firmware structure so that the new 5-mode system doesn't interfere with the existing QuickShifter state machine.

The next milestone should be **actual mode-dependent relay timing + UART output such as**:

```text
[MODE] 3 | CUT = 60 ms
[QS] SHIFT DETECTED
[QS] RELAY ON
[QS] RELAY OFF
[QS] CUT COMPLETE
````