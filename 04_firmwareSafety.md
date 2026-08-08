# QuickShifter Firmware Safety & Robustness Architecture

## 1. Overview

The QuickShifter firmware was not designed as a simple:

```text
Button → Relay ON → Delay → Relay OFF
```

Instead, the firmware has gradually been developed into a **layered safety architecture**.

The purpose of these safety mechanisms is to ensure that:

* electrical inputs do not accidentally trigger the system,
* button noise does not create false shifts,
* the relay is never intentionally held ON longer than the selected cut duration,
* repeated button presses cannot continuously retrigger the relay,
* invalid firmware states force the relay OFF,
* invalid EEPROM data cannot directly control the system,
* saved configuration is verified before being accepted,
* blocking EEPROM/UART operations do not accidentally trigger the watchdog,
* and a genuine firmware lock-up results in an automatic MCU reset.

The resulting architecture is:

```text
                       QUICKSHIFTER
                            │
             ┌──────────────┼──────────────┐
             │              │              │
             ▼              ▼              ▼
        Input Safety    Timing Safety   Data Safety
             │              │              │
             ▼              ▼              ▼
         Debounce      Cut Timer       EEPROM
         State Machine  Cooldown       Checksum
             │              │           Validation
             │              │              │
             └──────────────┼──────────────┘
                            │
                            ▼
                     Firmware Safety
                            │
                            ▼
                       Watchdog IWDG
                            │
                            ▼
                         MCU RESET
```

---

# 2. Safety Philosophy

The main design principle is:

> **Whenever something unexpected happens, the safest state of the QuickShifter is RELAY OFF.**

The relay is the actuator that actually performs the ignition/fuel cut function.

Therefore, the firmware treats the relay as the critical output.

The basic safety invariant is:

```text
Unexpected condition
        ↓
Relay OFF
```

This principle appears throughout the state machine.

For example, during initialization the QuickShifter starts in:

```c
currentState = QS_STATE_IDLE;
```

and relay initialization is performed before entering normal operation. 

An invalid state also explicitly forces:

```c
Relay_Off();
```

before returning to a known state. 

---

# 3. Safety Layer 1 — GPIO Initialization

Before any QuickShifter logic can operate, the physical GPIOs must be placed into known states.

The button inputs are configured using pull-ups:

```c
GPIO_Input_PU(BUTTON_PORT, BUTTON_PIN);
```

and:

```c
GPIO_Input_PU(
    MODE_BUTTON_PORT,
    MODE_BUTTON_PIN
);
```

This gives the inputs a defined idle state instead of leaving them floating. 

The principle is:

```text
Floating input
     ↓
Unpredictable logic
     ↓
Possible false trigger
```

versus:

```text
Pull-up input
     ↓
Defined HIGH idle state
     ↓
Button pulls input LOW
     ↓
Predictable detection
```

---

# 4. Safety Layer 2 — Button Debouncing

A mechanical button does not transition cleanly between:

```text
HIGH → LOW
```

When pressed, its contacts can mechanically bounce.

A raw signal can therefore look like:

```text
HIGH
 ↓
LOW
 ↑
LOW
 ↑
LOW
 ↑
LOW
 ↓
LOW
```

If the firmware interpreted every transition as a valid press, one physical press could generate multiple QuickShifter events.

That would be unacceptable.

---

# 5. Software Debounce State Machine

The button driver therefore uses a state machine:

```text
BUTTON_STATE_RELEASED
        │
        ▼
BUTTON_STATE_DEBOUNCE_PRESS
        │
        ▼
BUTTON_STATE_PRESSED
        │
        ▼
BUTTON_STATE_DEBOUNCE_RELEASE
        │
        ▼
BUTTON_STATE_RELEASED
```

The same principle is implemented for the mode-selection button. 

When a press is first detected, the firmware does **not immediately accept it**.

Instead:

```text
Button goes LOW
      ↓
Start debounce timer
      ↓
Wait
      ↓
Read button again
      ↓
Still LOW?
      ↓
Valid press
```

This prevents short electrical/mechanical glitches from being treated as legitimate commands.

---

# 6. One-Shot Press Events

The shift button generates a press event:

```c
pressEvent = TRUE;
```

The application reads it using:

```c
Button_GetPress();
```

The event is then immediately cleared:

```c
pressEvent = FALSE;
```

Therefore a single valid physical press produces a **single logical event**. 

Conceptually:

```text
Physical press
      ↓
Debounce
      ↓
Valid press
      ↓
ONE event
      ↓
QuickShifter
```

rather than:

```text
Physical press
      ↓
multiple electrical transitions
      ↓
multiple relay triggers
```

---

# 7. Safety Layer 3 — QuickShifter State Machine

The QuickShifter itself is not implemented as a collection of unrelated `if` statements.

It uses a state machine.

The states are:

```text
IDLE
CUT_ACTIVE
COOLDOWN
WAIT_RELEASE
```

and the later robustness work also introduced a:

```text
FAULT
```

state.

The normal flow is:

```text
             Button press
                  │
                  ▼
               IDLE
                  │
                  ▼
            CUT_ACTIVE
                  │
            timer expires
                  │
                  ▼
             COOLDOWN
                  │
            timer expires
                  │
                  ▼
           WAIT_RELEASE
                  │
             button released
                  │
                  ▼
                IDLE
```

The state machine is implemented in `QuickShifter_Task()`. 

---

# 8. Why the State Machine Improves Safety

Without a state machine, the firmware might accidentally allow:

```text
Button press
 ↓
Relay ON

Button still pressed
 ↓
Another trigger

Button still pressed
 ↓
Another trigger
```

The state machine explicitly separates these conditions.

For example:

```text
CUT_ACTIVE
```

does not look for another shift trigger.

Instead, it waits for the cut timer to expire.

Then:

```text
COOLDOWN
```

ignores additional shift requests.

Finally:

```text
WAIT_RELEASE
```

ensures the original button interaction has ended before returning to `IDLE`. 

---

# 9. Safety Layer 4 — Relay OFF During Initialization

The relay driver is initialized as part of:

```c
QuickShifter_Init();
```

The design explicitly treats relay initialization as a safety boundary.

The state machine then starts in:

```c
QS_STATE_IDLE
```

where:

```text
Relay = OFF
```

is the expected condition. 

Therefore the firmware does not begin with:

```text
Unknown state
+
Unknown relay state
```

Instead:

```text
Startup
 ↓
Relay initialization
 ↓
Known OFF state
 ↓
IDLE
```

---

# 10. Safety Layer 5 — Selected Cut-Time Control

The QuickShifter does not use an arbitrary delay.

The selected mode determines the cut duration.

The system currently supports:

```text
Mode 1 → 40 ms
Mode 2 → 50 ms
Mode 3 → 60 ms
Mode 4 → 70 ms
Mode 5 → 80 ms
```

The active duration is obtained through:

```c
Mode_GetCutTime();
```

and passed to the software timer:

```c
SoftwareTimer_Start(
    &relayTimer,
    Mode_GetCutTime()
);
```



This separates:

```text
Mode selection
```

from:

```text
Timing execution
```

which makes the firmware easier to reason about and validate.

---

# 11. Safety Layer 6 — Hardware/System Timer Foundation

The QuickShifter does not use random software delay loops such as:

```c
delay_ms(70);
```

for its control logic.

Instead, timing is based on the timer/software-timer architecture.

This is important because the firmware needs to continue executing other tasks while timing is taking place.

Conceptually:

```text
System timer
     ↓
Time base
     ↓
Software timer
     ↓
40–80 ms cut timing
```

This allows:

```text
Button_Update()
ModeButton_Update()
QuickShifter_Task()
Watchdog_Refresh()
```

to continue operating within the main loop instead of blocking the CPU for the entire cut duration. The main loop explicitly calls these tasks continuously. 

---

# 12. Safety Layer 7 — Relay Cut Timer

When a valid shift is detected:

```c
Relay_On();
```

and immediately:

```c
SoftwareTimer_Start(
    &relayTimer,
    Mode_GetCutTime()
);
```

The relay therefore has a defined software-controlled ON duration. 

The sequence is:

```text
Valid shift
   ↓
Relay ON
   ↓
Start cut timer
   ↓
Timer running
   ↓
Timer expires
   ↓
Relay OFF
```

This is the primary functional timing protection.

---

# 13. Safety Layer 8 — Explicit Relay OFF

The relay is not simply allowed to remain in whatever state it was last commanded.

When the cut timer expires:

```c
Relay_Off();
```

is explicitly called. 

The same principle is used when the state machine reaches an invalid/default state:

```c
Relay_Off();
currentState = QS_STATE_IDLE;
```

This is a very important embedded-systems principle:

> **A fault path should drive the actuator toward a safe state.**

For this project:

```text
Safe actuator state = Relay OFF
```

---

# 14. Safety Layer 9 — Cooldown Protection

After the relay is turned OFF, the firmware does not immediately return to normal triggering.

Instead:

```c
SoftwareTimer_Start(
    &cooldownTimer,
    100
);
```

and enters:

```text
QS_STATE_COOLDOWN
```



The sequence is:

```text
Relay OFF
   ↓
100 ms cooldown
   ↓
WAIT_RELEASE
   ↓
Button release
   ↓
IDLE
```

This prevents rapid retriggering.

---

# 15. Why Cooldown Exists

Imagine a button is pressed and released very quickly.

Without cooldown:

```text
Press
 ↓
Relay ON
 ↓
Relay OFF
 ↓
Immediately ready again
 ↓
Electrical/mechanical transient
 ↓
Possible second trigger
```

With cooldown:

```text
Press
 ↓
Relay ON
 ↓
Relay OFF
 ↓
100 ms lockout
 ↓
WAIT_RELEASE
 ↓
Ready
```

So the system gets a controlled recovery period after each cut.

---

# 16. Safety Layer 10 — Wait for Button Release

The firmware also has a dedicated:

```text
QS_STATE_WAIT_RELEASE
```

state.

The system waits until:

```c
Button_IsPressed() == FALSE
```

before returning to:

```text
QS_STATE_IDLE
```



This prevents a long button press from becoming:

```text
one press
→ many cuts
```

Instead:

```text
Press
 ↓
One cut
 ↓
Cooldown
 ↓
Wait until release
 ↓
Ready for next press
```

---

# 17. Safety Layer 11 — Invalid State Recovery

The state machine contains a default path.

If `currentState` somehow contains a value that does not correspond to a valid state, the firmware executes:

```c
Relay_Off();

currentState = QS_STATE_IDLE;
```



Therefore:

```text
Invalid state
     ↓
Relay OFF
     ↓
Return to known state
     ↓
IDLE
```

This is much safer than allowing undefined state behavior to continue.

---

# 18. Safety Layer 12 — Mode Validation

Mode selection is also protected.

The EEPROM layer validates that the stored mode is within the permitted range before accepting it. The current EEPROM implementation checks against:

```c
EEPROM_MIN_MODE
EEPROM_MAX_MODE
```

and falls back to Mode 1 when the stored mode is invalid. 

Therefore corrupted data cannot directly result in an arbitrary mode.

Conceptually:

```text
EEPROM mode
     ↓
Range check
     ↓
1–5 ?
 ┌───┴───┐
YES      NO
 │        │
 ▼        ▼
Accept   Mode 1
```

---

# 19. Safety Layer 13 — EEPROM Magic Number

EEPROM configuration contains a magic value.

The current EEPROM header defines:

```c
#define EEPROM_MAGIC_ADDRESS      0x4000
#define EEPROM_MODE_ADDRESS       0x4001
#define EEPROM_CHECKSUM_ADDRESS   0x4002

#define EEPROM_MAGIC              0xA5
```



The magic value answers:

> “Does this EEPROM area contain configuration data in the format this firmware expects?”

So:

```text
0xA5
```

acts as an identification marker.

---

# 20. Safety Layer 14 — EEPROM Checksum

The stored mode is not trusted by itself.

The firmware calculates:

```text
checksum = MAGIC ^ MODE ^ 0x5A
```

and compares the calculated value against the stored checksum. 

The validation process is:

```text
Read EEPROM
    │
    ├── Magic
    ├── Mode
    └── Checksum
          │
          ▼
Calculate expected checksum
          │
          ▼
Compare
      ┌───┴───┐
    MATCH   MISMATCH
      │         │
      ▼         ▼
   Accept    Default Mode
```

This protects against simple EEPROM data corruption.

---

# 21. Safety Layer 15 — EEPROM Write Verification

Saving a mode does not simply mean:

```text
Write → assume success
```

The firmware writes:

```text
MODE
CHECKSUM
MAGIC
```

and then reads the values back for verification. 

The verification checks:

```c
readBackMagic == EEPROM_MAGIC
```

```c
readBackMode == mode
```

```c
readBackChecksum == checksum
```

Only when all three match is:

```text
SAVE SUCCESS
```

reported.

This provides a basic write-integrity check.

---

# 22. Why MAGIC Is Written Last

The EEPROM save sequence is structured as:

```text
Write MODE
     ↓
Write CHECKSUM
     ↓
Write MAGIC
```

The idea is that the configuration marker is written after the configuration contents.

Therefore, if a write sequence is interrupted before completion, the firmware should not blindly treat partially updated data as a valid configuration.

The final verification then confirms that the complete configuration exists.

---

# 23. EEPROM Legacy Configuration Handling

The firmware also contains compatibility handling for the previous EEPROM representation.

The legacy format used:

```text
0 → Mode 1
1 → Mode 2
2 → Mode 3
3 → Mode 4
4 → Mode 5
```

The current format uses the user-visible mode numbering directly.

The EEPROM loader detects the legacy magic value, validates the legacy checksum, converts the old representation, and saves the converted configuration using the new format. 

This prevents an EEPROM format change from automatically making existing stored configuration unusable.

---

# 24. Safety Layer 16 — EEPROM + Watchdog Interaction

Adding the watchdog exposed an important firmware-level problem.

The EEPROM save operation contains blocking operations.

The UART debug system is also blocking.

The initial architecture was:

```text
Main loop
   ↓
Watchdog refresh
   ↓
EEPROM_SaveMode()
   ↓
Large amount of UART output
   ↓
Main loop temporarily not reached
   ↓
Watchdog timeout
   ↓
MCU reset
```

This initially made it look like EEPROM was broken.

However, disabling the watchdog proved that EEPROM was functioning correctly.

---

# 25. Watchdog-Aware EEPROM

The EEPROM driver was therefore modified so that blocking EEPROM operations service the watchdog.

For example:

```c
while((FLASH_IAPSR & FLASH_IAPSR_EOP) == 0)
{
    Watchdog_Refresh();
}
```



Watchdog refreshes were also added between EEPROM programming operations and after verification. 

The result is:

```text
EEPROM operation
      │
      ├── Write
      ├── Watchdog refresh
      ├── Write
      ├── Watchdog refresh
      ├── Write
      └── Verify
```

---

# 26. Safety Layer 17 — Watchdog-Aware Debug UART

The larger issue was the blocking UART debug output.

The debug system was changed so that individual UART transmissions can service the watchdog.

The architecture became:

```text
Debug_Log()
     ↓
Debug_SendChar()
     ↓
UART_SendChar()
     ↓
Watchdog_Refresh()
```

The watchdog therefore remains alive during legitimate lengthy debug output.

This was particularly important because the UART implementation waits for the transmitter to become ready before sending each character. 

---

# 27. Why We Did Not Simply Disable the Watchdog During EEPROM

A tempting solution would have been:

```text
Watchdog OFF
     ↓
EEPROM operation
     ↓
Watchdog ON
```

We deliberately did not choose that architecture.

Why?

Because if the firmware becomes stuck during that EEPROM operation, the watchdog would not be available.

Instead, the system now allows the watchdog to continue operating during legitimate blocking activity.

That preserves the fundamental safety principle:

```text
Legitimate operation
       ↓
Watchdog serviced


Genuine firmware lock-up
       ↓
No servicing
       ↓
Watchdog RESET
```

---

# 28. Safety Layer 18 — Independent Watchdog

The final major safety layer is the STM8 Independent Watchdog (IWDG).

The application provides:

```c
Watchdog_Init();
```

and:

```c
Watchdog_Refresh();
```

The normal main loop refreshes the watchdog continuously. 

Conceptually:

```text
Main loop
   │
   ├── Button_Update()
   ├── ModeButton_Update()
   ├── QuickShifter_Task()
   │
   └── Watchdog_Refresh()
           │
           ▼
       IWDG alive
```

---

# 29. What the Watchdog Protects Against

The watchdog is not primarily protecting against:

```text
Button bounce
```

or:

```text
Relay timing
```

Those already have dedicated protection.

The watchdog protects against **firmware execution failure**.

Examples include:

* Main loop getting stuck
* Unexpected infinite loop
* Software deadlock
* Unexpected execution path
* Firmware becoming unresponsive

The watchdog provides a hardware recovery mechanism.

---

# 30. Watchdog Fault-Injection Test

The watchdog was not considered complete merely because the code compiled.

A deliberate fault-injection test was performed.

The normal:

```c
Watchdog_Refresh();
```

was intentionally disabled.

The firmware then executed normally but never refreshed the watchdog.

The expected sequence was:

```text
Watchdog started
      ↓
No refresh
      ↓
Watchdog counter continues
      ↓
Timeout
      ↓
STM8 reset
      ↓
main() starts again
```

This behavior was actually observed on the hardware.

The MCU repeatedly restarted at approximately the watchdog timeout interval.

Therefore the IWDG reset mechanism has been **experimentally verified**, not merely assumed.

---

# 31. Watchdog Option-Byte Verification

The STM8 option bytes were checked using ST Visual Programmer.

The configuration was confirmed as:

```text
IWDG_HW
Independent Watchdog activated by Software
```

Therefore the watchdog is intentionally started by firmware rather than automatically at power-on.

This matches the software architecture.

---

# 32. Complete Safety Architecture

At this point the QuickShifter has several independent safety mechanisms.

```text
                         INPUT
                           │
                           ▼
                    GPIO + Pull-up
                           │
                           ▼
                     Debounce FSM
                           │
                           ▼
                    One-shot Event
                           │
                           ▼
                    QuickShifter FSM
                           │
              ┌────────────┴────────────┐
              │                         │
              ▼                         ▼
         Cut Timer                 State Safety
              │                         │
              ▼                         ▼
         Relay OFF                Invalid → OFF
              │
              ▼
          Cooldown
              │
              ▼
        Wait Release
              │
              ▼
             IDLE


MODE CONFIGURATION PATH
────────────────────────

Mode Button
     │
     ▼
Debounce
     │
     ▼
Mode Change
     │
     ▼
Range Validation
     │
     ▼
EEPROM
     │
     ├── Magic validation
     ├── Mode validation
     ├── Checksum validation
     └── Read-back verification


FIRMWARE SAFETY PATH
─────────────────────

Main Loop
    │
    ▼
Watchdog Refresh
    │
    ▼
IWDG

If firmware stops:
    │
    ▼
No refresh
    │
    ▼
IWDG timeout
    │
    ▼
MCU RESET
```

---

# 33. Safety Layers Summary

| Layer | Protection                       | Failure Prevented                        |
| ----- | -------------------------------- | ---------------------------------------- |
| 1     | GPIO pull-up/input configuration | Floating inputs                          |
| 2     | Button debounce                  | Mechanical/electrical bounce             |
| 3     | One-shot button events           | Multiple triggers from one press         |
| 4     | QuickShifter state machine       | Invalid sequencing                       |
| 5     | Relay initialization             | Unknown startup relay state              |
| 6     | Mode-based timer                 | Undefined cut duration                   |
| 7     | Cut timer                        | Excessive normal relay activation        |
| 8     | Explicit `Relay_Off()`           | Relay remaining active after cut         |
| 9     | Cooldown                         | Immediate retriggering                   |
| 10    | Wait-release state               | Long press causing repeated cuts         |
| 11    | Invalid-state recovery           | Undefined FSM behavior                   |
| 12    | Mode range validation            | Invalid configuration                    |
| 13    | EEPROM magic                     | Unknown/uninitialized data               |
| 14    | EEPROM checksum                  | Corrupted configuration                  |
| 15    | EEPROM read-back                 | Failed EEPROM write                      |
| 16    | EEPROM watchdog servicing        | Legitimate EEPROM blocking causing reset |
| 17    | Watchdog-aware UART              | Debug logging starving watchdog          |
| 18    | Independent watchdog             | Firmware lock-up                         |
| 19    | Watchdog fault injection         | Unverified watchdog assumptions          |

---

# 34. Failure → Protection Mapping

A useful way to understand the design is to start from the failure.

### Button bounces

```text
Button bounce
     ↓
Debounce FSM
     ↓
One valid event
```

### Button held

```text
Button held
     ↓
CUT_ACTIVE
     ↓
COOLDOWN
     ↓
WAIT_RELEASE
     ↓
No additional cut
```

### Normal cut timer expires

```text
Timer expires
     ↓
Relay_Off()
```

### State corruption

```text
Invalid state
     ↓
Relay_Off()
     ↓
IDLE
```

### EEPROM corruption

```text
Bad magic/checksum/mode
     ↓
Reject configuration
     ↓
Default Mode 1
```

### EEPROM write failure

```text
Write
 ↓
Read-back
 ↓
Mismatch
 ↓
SAVE FAILED
```

### Long EEPROM/UART operation

```text
Blocking operation
     ↓
Watchdog serviced
     ↓
No false reset
```

### Firmware lock-up

```text
Firmware stops
     ↓
No watchdog refresh
     ↓
IWDG timeout
     ↓
MCU RESET
```

---

# 35. What Has Actually Been Tested

The important distinction is between **implemented** and **verified**.

### Verified on hardware

* Button operation
* Mode switching
* Mode persistence
* EEPROM read/write
* EEPROM checksum validation
* EEPROM read-back verification
* Relay operation
* QuickShifter state machine operation
* Selected cut modes
* Watchdog activation
* Watchdog timeout
* Automatic MCU reset
* Watchdog survival during EEPROM/debug operation

The watchdog fault-injection test was especially important because it demonstrated that deliberately stopping watchdog servicing causes the STM8 to restart.

---

# 36. What Is NOT Yet Completed

The current safety architecture is strong, but it is **not yet the final production safety architecture**.

The following are intentionally left for later:

```text
Reset-cause detection
        ↓
Persistent watchdog fault logging
        ↓
Startup fault diagnostics
        ↓
More advanced watchdog health monitoring
        ↓
Production fault recovery strategy
```

We have specifically postponed reset-cause reporting for a later phase.

So we should **not document it as implemented yet**.

---

# 37. Current Safety Philosophy

The QuickShifter now follows three important principles:

### Principle 1 — Fail Safe

Whenever the firmware detects an invalid state:

```text
RELAY OFF
```

### Principle 2 — Validate Before Trusting

External/user-controlled data is not blindly trusted.

```text
Button → Debounce
Mode → Range check
EEPROM → Magic + checksum + range
EEPROM write → Read-back verification
```

### Principle 3 — Recover From Firmware Failure

If the firmware itself stops executing:

```text
No watchdog refresh
        ↓
IWDG timeout
        ↓
MCU reset
```

---

# 38. Final Architecture

The QuickShifter firmware has evolved from a basic relay controller into a layered embedded control system:

```text
                         ┌─────────────────────┐
                         │     QUICKSHIFTER     │
                         └──────────┬──────────┘
                                    │
             ┌──────────────────────┼──────────────────────┐
             │                      │                      │
             ▼                      ▼                      ▼
       INPUT SAFETY           CONTROL SAFETY          DATA SAFETY
             │                      │                      │
       ┌─────┴─────┐          ┌─────┴─────┐         ┌─────┴─────┐
       │           │          │           │         │           │
    Debounce    Events     Cut Timer   Cooldown   EEPROM     Checksum
       │           │          │           │         │           │
       └─────┬─────┘          └─────┬─────┘         └─────┬─────┘
             │                      │                      │
             └──────────────────────┼──────────────────────┘
                                    │
                                    ▼
                            STATE MACHINE
                                    │
                             ┌──────┴──────┐
                             │             │
                             ▼             ▼
                         Normal         Invalid
                             │             │
                             ▼             ▼
                       Relay control   Relay OFF
                                   
                                    │
                                    ▼
                           FIRMWARE SAFETY
                                    │
                                    ▼
                               IWDG
                                    │
                     ┌──────────────┴──────────────┐
                     │                             │
                Refreshing                    No refresh
                     │                             │
                     ▼                             ▼
               Keep running                  MCU RESET
```

---

# 39. Conclusion

The safety work completed so far is not a single feature. It is a collection of independent protections built around the most important requirement of the QuickShifter:

> **The relay must never remain active because of an unexpected firmware condition.**

The firmware therefore uses:

* debounced inputs,
* one-shot button events,
* a deterministic state machine,
* controlled cut timing,
* cooldown protection,
* release detection,
* explicit relay shutdown,
* invalid-state recovery,
* EEPROM validation,
* checksum protection,
* EEPROM write verification,
* watchdog-aware blocking operations,
* and an independently verified hardware watchdog.

The most significant validation performed in this phase was the deliberate watchdog fault injection.

The firmware was intentionally prevented from refreshing the watchdog, and the STM8S003F3 was observed to automatically reset.

This establishes a layered safety architecture:

```text
                USER INPUT
                    │
                    ▼
               VALIDATION
                    │
                    ▼
             STATE MACHINE
                    │
                    ▼
              TIMED RELAY
                    │
                    ▼
             SAFE SHUTDOWN
                    │
                    ▼
             FIRMWARE WATCHDOG
                    │
                    ▼
              MCU RECOVERY
```

This forms the current **safety foundation of the QuickShifter firmware**.

---
