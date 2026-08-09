# QuickShifter — LED Driver & Buzzer Driver Documentation

## 1. Overview

The QuickShifter firmware uses two independent user-interface subsystems:

1. **LED Driver**

   * Displays the currently selected QuickShifter mode.
   * Provides system/status indication.
   * Uses discrete GPIO outputs rather than an external I/O expander.

2. **Buzzer Driver**

   * Provides audible feedback during system startup.
   * Indicates QuickShifter mode changes.
   * Provides audible feedback when a quick-shift is detected.
   * Provides ready/fault indication.
   * Uses a passive buzzer driven through a **BC547 transistor**.
   * Generates tones using **TIM2** and software-controlled GPIO toggling.
   * Uses a non-blocking melody engine so audio feedback does not interfere with QuickShifter timing.

The design was intentionally kept lightweight and deterministic because the QuickShifter's primary function is timing-critical relay control.

---

# 2. LED Driver

## 2.1 Design Objective

The LED subsystem was designed to provide visual feedback without introducing an external GPIO expander such as the MCP23008.

Initially, an I/O expander and LED matrix were considered because the system contains multiple LEDs.

The final architecture uses the STM8 GPIO pins directly.

This was selected because:

* The number of required outputs was manageable.
* The LEDs can operate from the MCU's logic voltage with appropriate current limiting.
* An external I/O expander would add unnecessary hardware and software complexity.
* A 3×3 LED matrix would require additional scanning logic and six GPIO pins while only providing limited savings.
* Direct GPIO control provides simpler and more deterministic firmware.

---

# 3. LED Hardware Architecture

The system contains:

### Mode LEDs

Five LEDs are used to represent the five QuickShifter modes:

| LED        | Function |
| ---------- | -------- |
| Mode LED 1 | 40 ms    |
| Mode LED 2 | 50 ms    |
| Mode LED 3 | 60 ms    |
| Mode LED 4 | 70 ms    |
| Mode LED 5 | 80 ms    |

The selected mode is displayed by activating the corresponding LED.

The mode timing relationship is:

```text
Mode 1 ? 40 ms
Mode 2 ? 50 ms
Mode 3 ? 60 ms
Mode 4 ? 70 ms
Mode 5 ? 80 ms
```

This gives the user an immediate visual indication of the selected cut duration.

---

# 4. Status RGB LED

A separate RGB LED provides overall system status.

The final GPIO mapping is:

```text
RED   ? PB4
GREEN ? PC6
BLUE  ? PC7
```

This LED is independent of the five mode LEDs.

It can therefore be used for system-level states such as:

```text
OFF      ? System inactive / no status
RED      ? Fault / error
GREEN    ? Ready / normal
BLUE     ? System or operating indication
```

The exact status-state mapping can be extended later without changing the basic driver architecture.

---

# 5. LED Driver Software Architecture

The LED functionality was consolidated into:

```text
led.h
led.c
```

rather than creating separate files such as:

```text
mode_led.c
status_led.c
```

This was intentionally done because both are fundamentally GPIO-based LED functions.

The architecture is therefore:

```text
                LED DRIVER
                    ¦
          +-------------------+
          ¦                   ¦
      Mode LEDs          Status RGB LED
          ¦                   ¦
      5 outputs          R / G / B
```

---

# 6. LED Initialization

The LED driver contains an initialization routine:

```c
LED_Init();
```

This configures all LED GPIO pins as outputs and establishes a known initial state.

The initialization sequence is performed during system startup.

Conceptually:

```text
MCU Reset
   ?
Clock initialization
   ?
Timer initialization
   ?
Button initialization
   ?
LED_Init()
   ?
LED outputs configured
```

This prevents the LEDs from remaining in an undefined state after reset.

---

# 7. Mode LED Display

The mode LED driver provides a function similar to:

```c
LED_Mode_Display(mode);
```

The mode number is converted into the corresponding LED output.

For example:

```text
LED_Mode_Display(1)
       ?
Mode 1 LED ON
```

and:

```text
LED_Mode_Display(5)
       ?
Mode 5 LED ON
```

The selected mode is therefore directly visible to the user.

---

# 8. Mode Selection Integration

The mode display is updated whenever the mode button produces a valid press event.

The main application follows this sequence:

```text
Mode button pressed
        ?
Debounce
        ?
ModeButton_GetPress()
        ?
Mode_Next()
        ?
LED_Mode_Display()
        ?
Buzzer_Play(MODE_CHANGE)
```

This creates a combined visual + audible user interface.

---

# 9. GPIO Port A Issue Discovered During Development

One important debugging issue occurred while implementing the buzzer and GPIO abstraction.

The initial GPIO driver supported:

```text
PORT_B
PORT_C
PORT_D
```

but did not correctly implement:

```text
PORT_A
```

When the buzzer was moved to PA3, the GPIO abstraction did not correctly map the Port A registers.

The result was that a request such as:

```c
GPIO_Output_PP(PORT_A, PIN3);
```

did not actually configure the PA3 registers correctly.

This caused PA3 not to reach the expected output voltage.

The issue was solved by adding the STM8S003F3 Port A registers:

```text
PA_ODR
PA_IDR
PA_DDR
PA_CR1
PA_CR2
```

and adding `PORT_A` handling to the GPIO register-selection functions.

This was an important firmware-level hardware abstraction bug.

---

# 10. Buzzer Driver

## 10.1 Objective

The buzzer subsystem was designed to provide an audible interface without blocking the QuickShifter control loop.

The required events were:

* Boot
* Mode change
* Quick shift
* Ready
* Fault

Instead of simply turning the buzzer ON/OFF for arbitrary delays, a reusable **melody engine** was implemented.

---

# 11. Passive Buzzer

The project uses a:

```text
Passive buzzer
```

A passive buzzer requires an alternating electrical signal.

Therefore, the STM8 does not simply set the buzzer GPIO HIGH.

Instead, the firmware generates a square wave.

For example:

```text
       +-----+     +-----+
HIGH   ¦     ¦     ¦     ¦
       ¦     ¦     ¦     ¦
LOW ---+     +-----+     +-----
```

The frequency of this waveform determines the perceived pitch.

---

# 12. Initial Direct GPIO Buzzer Drive

Initially, the passive buzzer was connected directly to the STM8 GPIO.

This worked electrically, but the output volume was very low.

The same buzzer was then tested using an Arduino Uno.

The Arduino produced significantly louder sound.

This demonstrated that:

```text
Buzzer itself ? functional
```

and the problem was related to the STM8-side drive.

---

# 13. BC547 Driver

To solve the low-volume problem, a BC547 NPN transistor was added as a low-side driver.

The final architecture is:

```text
                  +5V
                   ¦
                   ¦
               Passive
                Buzzer
                   ¦
                   ¦
                   C
                +-----+
STM8 PA3 --1k--?¦ B   ¦
                ¦BC547¦
                ¦     ¦
                +--E--+
                   ¦
                  GND
```

The STM8 does **not** directly power the buzzer anymore.

Instead:

```text
PA3
 ?
1 kO resistor
 ?
BC547 base
 ?
BC547 switches buzzer current
```

The transistor therefore isolates the MCU GPIO from the buzzer load and provides significantly stronger drive.

---

# 14. Common Ground

The STM8 and buzzer supply must share a common ground:

```text
STM8 GND
   ¦
   +-------- Buzzer supply GND
   ¦
   +-------- BC547 emitter
```

Without a common reference, the transistor control signal would not have a reliable voltage reference.

---

# 15. Buzzer GPIO

The final buzzer GPIO is:

```text
PA3
```

The configuration is:

```c
#define BUZZER_PORT    PORT_A
#define BUZZER_PIN     PIN3
```

PA3 is configured as a push-pull output.

The signal from PA3 drives the BC547 base through the base resistor.

---

# 16. Why PB5 Was Abandoned

The buzzer was initially tested using PB5.

However, PB5 on the STM8S003F3 is a true open-drain pin.

That made it unsuitable for the direct push-pull buzzer waveform we wanted.

Therefore, the buzzer was moved to:

```text
PA3
```

and configured as a push-pull output.

This was a hardware-specific STM8 pin-selection decision.

---

# 17. TIM2 Tone Generation

The buzzer uses **TIM2** to generate its waveform.

The STM8 system clock is operating at:

```text
16 MHz
```

TIM2 is configured with a prescaler of:

```text
/8
```

Therefore:

```text
16 MHz / 8 = 2 MHz
```

timer clock.

The buzzer GPIO is toggled once per timer overflow.

Therefore the output frequency is approximately:

```text
Fout = TimerClock / (2 × ARR)
```

or:

```text
Fout = 2,000,000 / (2 × ARR)
```

This produces the required audible square wave.

---

# 18. TIM2 Interrupt Architecture

TIM2 generates an update interrupt.

The interrupt vector is:

```c
INTERRUPT_HANDLER(
    TIM2_UPD_OVF_BRK_IRQHandler,
    13
)
{
    Buzzer_TickISR();
}
```

The architecture is:

```text
TIM2 overflow
      ?
TIM2 interrupt
      ?
IRQ 13
      ?
Buzzer_TickISR()
      ?
Clear interrupt flag
      ?
Toggle PA3
      ?
BC547
      ?
Passive buzzer
```

---

# 19. Important TIM2 Watchdog Issue

During development, enabling the TIM2 interrupt initially caused the STM8 watchdog to reset the MCU.

The debugging process isolated the problem.

The following test worked:

```c
TIM2_IER |= TIM2_IER_UIE;
```

while the ISR only cleared the TIM2 update flag.

This confirmed that:

* TIM2 configuration was functional.
* TIM2 was running.
* The interrupt was reaching the MCU.
* The interrupt flag could be cleared.
* The watchdog problem was related to the original ISR/output handling rather than TIM2 itself.

The final ISR became:

```c
void Buzzer_TickISR(void)
{
    TIM2_SR1 &= (uint8_t)(~TIM2_SR_UIF);

    GPIO_Toggle(
        BUZZER_PORT,
        BUZZER_PIN
    );
}
```

This successfully generates the buzzer waveform.

---

# 20. Buzzer Melody Engine

Instead of hardcoding delays, the buzzer uses a note structure:

```c
typedef struct
{
    uint16_t frequency;
    uint16_t duration;

} BuzzerNote;
```

Each note contains:

```text
frequency
duration
```

For example:

```c
{ 800, 100 }
```

means:

```text
800 Hz
100 ms
```

---

# 21. REST and End Markers

Two special values are used.

### REST

```c
#define BUZZER_REST 0
```

A REST means:

```text
No sound
```

The timer is stopped and the buzzer output is forced LOW.

### End of melody

```c
#define BUZZER_MELODY_END 0xFFFF
```

This tells the melody engine that the sequence has finished.

---

# 22. Current Tone Range

After testing several frequencies, the current preferred range was established as:

```c
#define TONE_LOW   800
#define TONE_MID   1000
#define TONE_HIGH  1200
```

This range was selected based on actual listening tests with the installed buzzer and BC547 driver.

Higher frequencies such as:

```text
1800 Hz
2200 Hz
2600 Hz
3000+ Hz
```

were found to sound sharper and more aggressive.

The 800–1200 Hz range provides a more comfortable sound for this application.

---

# 23. Boot Melody

The boot melody follows the original musical concept developed during the project.

Current sequence:

```text
800 Hz
   ?
1000 Hz
   ?
1200 Hz
   ?
1000 Hz
```

It provides a rising startup signature followed by a settling tone.

Conceptually:

```text
DO ? MID ? HIGH ? MID
```

---

# 24. Mode Change Melody

The mode-change melody is:

```text
1000 Hz
   ?
1200 Hz
```

It provides a short confirmation that the selected QuickShifter mode has changed.

The mode change therefore provides:

```text
Button press
     ?
Mode changes
     ?
Mode LED changes
     ?
Buzzer confirmation
```

---

# 25. QuickShift Melody

The QuickShift beep is deliberately short.

The current implementation uses:

```text
1200 Hz
˜45 ms
```

This produces a short audible confirmation when the shift input is detected.

---

# 26. QuickShift Integration

The buzzer was integrated into `quickshifter.c`.

When a valid shift event is detected:

```c
if(Button_GetPress())
{
    Buzzer_Play(BUZZER_EVENT_SHIFT);

    Relay_On();

    ...
}
```

The important design decision is that **the buzzer does not delay the relay operation**.

The sequence is:

```text
Valid shift detected
       ¦
       +--------? Start buzzer
       ¦
       +--------? Relay ON
                       ¦
                       ?
                  40–80 ms cut
```

The buzzer operates independently using TIM2 and the non-blocking melody engine.

---

# 27. Non-Blocking Buzzer Architecture

This is one of the most important design decisions.

The firmware does **not** use:

```c
delay(40);
```

or:

```c
for(...)
{
    // wait
}
```

to generate sound.

Instead:

```c
Buzzer_Play(...)
```

starts the sound and immediately returns.

Then:

```c
Buzzer_Task();
```

is called continuously from the main loop.

Therefore:

```text
Buzzer_Play()
     ?
Set state
     ?
Start TIM2
     ?
RETURN
```

while:

```text
Main loop
    ?
Buzzer_Task()
    ?
Check elapsed time
    ?
Move to next note
```

This keeps the system responsive.

---

# 28. Why This Is Important for QuickShifter

The QuickShifter timing is:

```text
Mode 1 ? 40 ms
Mode 2 ? 50 ms
Mode 3 ? 60 ms
Mode 4 ? 70 ms
Mode 5 ? 80 ms
```

These timings are safety/function-critical.

The buzzer must therefore **never become part of the relay timing path**.

The final architecture keeps them independent:

```text
              MAIN LOOP
                  ¦
       +---------------------+
       ¦                     ¦
 QuickShifter             Buzzer
       ¦                     ¦
 Relay timing            TIM2 timing
       ¦                     ¦
 40–80 ms cut            Audio waveform
```

---

# 29. Buzzer State

The driver maintains:

```c
static const BuzzerNote *current_melody;
static uint8_t current_note;
static uint32_t note_start_time;
static uint8_t buzzer_busy;
```

These variables allow the melody engine to know:

* Which melody is playing.
* Which note is active.
* When that note started.
* Whether the buzzer is currently active.

---

# 30. Buzzer Event Interface

The application does not directly manipulate TIM2.

Instead it uses:

```c
Buzzer_Play(BUZZER_EVENT_BOOT);
```

or:

```c
Buzzer_Play(BUZZER_EVENT_MODE_CHANGE);
```

or:

```c
Buzzer_Play(BUZZER_EVENT_SHIFT);
```

This creates a clean abstraction:

```text
Application
    ¦
    ?
Buzzer_Play(EVENT)
    ¦
    ?
Melody Engine
    ¦
    ?
TIM2
    ¦
    ?
GPIO
    ¦
    ?
BC547
    ¦
    ?
Buzzer
```

---

# 31. Main Application Integration

The main initialization sequence includes:

```c
LED_Init();

Buzzer_Init();

EEPROM_Init();

Mode_Init();

LED_Mode_Display(
    Mode_Get() + 1
);

QuickShifter_Init();

Buzzer_Play(
    BUZZER_EVENT_BOOT
);
```

The boot melody therefore plays after the system has initialized its major subsystems.

---

# 32. Main Loop Integration

The main loop continuously services the buzzer:

```c
Buzzer_Task();
```

This must remain in the main loop because the melody timing is software-managed.

The general architecture is:

```text
while(1)
{
    Button_Update();

    ModeButton_Update();

    Mode event handling

    QuickShifter_Task();

    Buzzer_Task();

    Watchdog_Refresh();
}
```

---

# 33. Current User Interface

The QuickShifter now has three feedback mechanisms:

### Mode LEDs

```text
Mode 1 ? 40 ms
Mode 2 ? 50 ms
Mode 3 ? 60 ms
Mode 4 ? 70 ms
Mode 5 ? 80 ms
```

### RGB status LED

```text
Red
Green
Blue
```

for system-level indication.

### Buzzer

```text
Boot
Mode change
Quick shift
Ready
Fault
```

This gives the project a complete embedded-system user interface.

---

# 34. Final Hardware Architecture

The current relevant architecture is:

```text
                    STM8S003F3
                         ¦
          +--------------+--------------+
          ¦              ¦              ¦
       Mode LEDs      Status RGB       PA3
          ¦              ¦              ¦
          ¦              ¦             1kO
          ¦              ¦              ¦
          ¦              ¦              ?
          ¦              ¦           BC547
          ¦              ¦              ¦
          ¦              ¦              ?
          ¦              ¦        Passive Buzzer
          ¦              ¦              ¦
          ¦              ¦             +5V
          ¦              ¦
          +---------------------------------
```

The exact mode/status GPIO mappings are maintained in `config.h` and the LED driver.

---

# 35. Engineering Principles Used

The LED and buzzer implementation follows several important embedded-system principles.

### 1. Hardware abstraction

Application code does not directly manipulate LED registers.

Instead:

```c
LED_Mode_Display();
```

is used.

Likewise, the application does not directly configure TIM2 for every sound.

It uses:

```c
Buzzer_Play();
```

---

### 2. Non-blocking design

No blocking delays are used for melody playback.

This preserves QuickShifter responsiveness.

---

### 3. Event-driven architecture

The system reacts to events:

```text
Boot event
Mode event
Shift event
Ready event
Fault event
```

rather than continuously polling the buzzer state for application decisions.

---

### 4. Deterministic timing

TIM2 generates the actual audio waveform.

The system timer continues to provide the millisecond timing used by the rest of the firmware.

---

### 5. Separation of responsibilities

```text
LED Driver
    ? visual feedback

Buzzer Driver
    ? audio feedback

QuickShifter Driver
    ? relay timing

Button Driver
    ? input/debounce

Mode Driver
    ? mode management

Timer Driver
    ? system timing
```

Each subsystem has a clearly defined responsibility.

---

# 36. Major Debugging Lessons

Several real hardware/firmware issues were identified while implementing these drivers.

### Issue 1 — LED GPIO resource planning

We considered:

```text
GPIO expander
LED matrix
Direct GPIO
```

and ultimately selected direct GPIO because the available STM8 pins were sufficient.

---

### Issue 2 — PB5 unsuitable for direct buzzer drive

PB5's open-drain characteristics made it unsuitable for the intended direct push-pull waveform.

The buzzer was moved to PA3.

---

### Issue 3 — Port A missing from GPIO abstraction

The GPIO driver did not initially implement Port A correctly.

This caused PA3 configuration failures.

Port A support was added to the GPIO abstraction.

---

### Issue 4 — Buzzer output was too quiet

Direct STM8 GPIO drive produced very low acoustic output.

Testing the same buzzer with Arduino Uno confirmed the buzzer itself was functional.

A BC547 transistor driver was then added.

Result:

```text
STM8 direct drive ? very quiet
BC547 driver      ? significantly louder
```

---

### Issue 5 — TIM2 interrupt/watchdog reset

Enabling the buzzer timer interrupt initially caused watchdog resets.

The issue was isolated through incremental testing:

```text
Buzzer disabled
      ?
No reset

Buzzer enabled
      ?
Reset

TIM2 interrupt enabled
      ?
Test ISR

Clear flag only
      ?
Stable

GPIO toggle added
      ?
Stable
```

This demonstrated the importance of isolating one subsystem at a time when debugging embedded firmware.

---

# 37. Final Driver Files

The resulting software organization is:

```text
QuickShifter/
¦
+-- led.c
+-- led.h
¦
+-- buzzer.c
+-- buzzer.h
¦
+-- gpio.c
+-- gpio.h
¦
+-- button.c
+-- button.h
¦
+-- mode.c
+-- mode.h
¦
+-- quickshifter.c
+-- quickshifter.h
¦
+-- timer.c
+-- timer.h
¦
+-- config.h
```

The LED and buzzer drivers are therefore independent modules that can be reused or modified without restructuring the QuickShifter state machine.

---

# 38. Current Final Behavior

The complete user experience is now:

```text
                    POWER ON
                       ¦
                       ?
                 System Initialize
                       ¦
                       ?
                 LED Status Setup
                       ¦
                       ?
                  ?? BOOT TUNE
                       ¦
                       ?
                Current Mode LED
                       ¦
                       ?
                 SYSTEM READY
                       ¦
             +-------------------+
             ¦                   ¦
        MODE BUTTON          SHIFT INPUT
             ¦                   ¦
             ?                   ?
        Mode_Next()         Buzzer_Play()
             ¦                   ¦
             ?                   ?
        Mode LED update       Relay ON
             ¦                   ¦
             ?                   ?
        Mode beep             40–80 ms
                                 ¦
                                 ?
                            Relay OFF
```

The buzzer and LEDs are therefore not merely decorative additions. They are now part of the **embedded system's user-interface and diagnostic architecture**, while remaining isolated from the safety-critical relay timing.
