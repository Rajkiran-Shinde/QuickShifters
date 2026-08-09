#include "buzzer.h"
#include "gpio.h"
#include "config.h"
#include "timer.h"


/* ============================================================
 * TIM2 REGISTERS - STM8S003F3
 * ============================================================ */

#define TIM2_CR1    (*(volatile uint8_t*)0x5300)
#define TIM2_IER    (*(volatile uint8_t*)0x5303)
#define TIM2_SR1    (*(volatile uint8_t*)0x5304)
#define TIM2_CNTRH  (*(volatile uint8_t*)0x530C)
#define TIM2_CNTRL  (*(volatile uint8_t*)0x530D)
#define TIM2_PSCR   (*(volatile uint8_t*)0x530E)
#define TIM2_ARRH   (*(volatile uint8_t*)0x530F)
#define TIM2_ARRL   (*(volatile uint8_t*)0x5310)


/* ============================================================
 * TIM2 BIT DEFINITIONS
 * ============================================================ */

#define TIM2_CR1_CEN    (1 << 0)
#define TIM2_IER_UIE    (1 << 0)
#define TIM2_SR_UIF     (1 << 0)


/* ============================================================
 * BUZZER NOTE
 * ============================================================ */

typedef struct
{
    uint16_t frequency;
    uint16_t duration;

} BuzzerNote;


/* ============================================================
 * SPECIAL VALUES
 * ============================================================ */

#define BUZZER_REST        0
#define BUZZER_MELODY_END  0xFFFF


/* ============================================================
 * BUZZER TONE RANGE
 *
 * Based on the range that sounded comfortable on the
 * current buzzer + BC547 driver.
 *
 * Low   = 800 Hz
 * Mid   = 1000 Hz
 * High  = 1200 Hz
 * ============================================================ */

#define TONE_LOW        800
#define TONE_MID        1000
#define TONE_HIGH       1200


/* ============================================================
 * BOOT MELODY
 *
 * Original concept:
 *
 * C ? E ? G ? C
 *
 * Mapped into our current comfortable frequency range:
 *
 * 800 ? 1000 ? 1200 ? 1000 Hz
 *
 * "doo ? doo ? BEEP ? doo"
 * ============================================================ */

static const BuzzerNote boot_melody[] =
{
    { TONE_LOW,  100 },
    { TONE_MID,  100 },
    { TONE_HIGH, 120 },
    { TONE_MID,  250 },

    { BUZZER_REST, 50 },

    { BUZZER_MELODY_END, 0 }
};


/* ============================================================
 * MODE CHANGE MELODY
 *
 * Original concept:
 *
 * E ? G
 *
 * Short confirmation tone.
 * ============================================================ */

static const BuzzerNote mode_change_melody[] =
{
    { TONE_MID,  70 },
    { TONE_HIGH, 110 },

    { BUZZER_REST, 30 },

    { BUZZER_MELODY_END, 0 }
};


/* ============================================================
 * QUICK SHIFT MELODY
 *
 * Original concept:
 *
 * A short high note.
 *
 * This is intentionally very short because it happens
 * at the same time as the QuickShifter cut.
 * ============================================================ */

static const BuzzerNote shift_melody[] =
{
    { TONE_HIGH, 45 },

    { BUZZER_MELODY_END, 0 }
};


/* ============================================================
 * READY MELODY
 *
 * Original concept:
 *
 * G ? C
 *
 * Gives a positive "system ready" confirmation.
 * ============================================================ */

static const BuzzerNote ready_melody[] =
{
    { TONE_MID,  100 },
    { TONE_HIGH, 180 },

    { BUZZER_MELODY_END, 0 }
};


/* ============================================================
 * FAULT MELODY
 *
 * Original concept:
 *
 * A ? REST ? A ? REST ? A
 *
 * Three warning beeps.
 * ============================================================ */

static const BuzzerNote fault_melody[] =
{
    { TONE_HIGH, 100 },

    { BUZZER_REST, 70 },

    { TONE_HIGH, 100 },

    { BUZZER_REST, 70 },

    { TONE_HIGH, 100 },

    { BUZZER_MELODY_END, 0 }
};


/* ============================================================
 * BUZZER STATE
 * ============================================================ */

static const BuzzerNote *current_melody = 0;

static uint8_t current_note = 0;

static uint32_t note_start_time = 0;

static uint8_t buzzer_busy = FALSE;


/* ============================================================
 * BUZZER OUTPUT
 * ============================================================ */

static void Buzzer_Output(uint8_t state)
{
    if(state == TRUE)
    {
        GPIO_Set(
            BUZZER_PORT,
            BUZZER_PIN
        );
    }
    else
    {
        GPIO_Clear(
            BUZZER_PORT,
            BUZZER_PIN
        );
    }
}


/* ============================================================
 * STOP TIM2
 * ============================================================ */

static void Buzzer_Timer_Stop(void)
{
    /*
     * Stop TIM2.
     */
    TIM2_CR1 &= (uint8_t)(~TIM2_CR1_CEN);


    /*
     * Disable TIM2 update interrupt.
     */
    TIM2_IER &= (uint8_t)(~TIM2_IER_UIE);


    /*
     * Force buzzer output LOW.
     */
    Buzzer_Output(FALSE);
}


/* ============================================================
 * SET BUZZER FREQUENCY
 * ============================================================ */

static void Buzzer_SetFrequency(uint16_t frequency)
{
    uint16_t reload;


    /*
     * Frequency = 0 means REST.
     */
    if(frequency == BUZZER_REST)
    {
        Buzzer_Timer_Stop();

        return;
    }


    /*
     * TIM2 clock:
     *
     * CPU clock = 16 MHz
     * TIM2 prescaler = /8
     *
     * Timer clock = 2 MHz
     *
     * GPIO toggles on every TIM2 overflow.
     *
     * Therefore:
     *
     * Fout = Timer clock / (2 × reload)
     */
    reload = (uint16_t)(
        2000000UL / (2UL * frequency)
    );


    if(reload == 0)
    {
        reload = 1;
    }


    /*
     * Stop TIM2 before changing frequency.
     */
    Buzzer_Timer_Stop();


    /*
     * TIM2 prescaler = /8
     */
    TIM2_PSCR = 3;


    /*
     * Load auto-reload value.
     */
    TIM2_ARRH = (uint8_t)(reload >> 8);
    TIM2_ARRL = (uint8_t)(reload & 0xFF);


    /*
     * Reset counter.
     */
    TIM2_CNTRH = 0;
    TIM2_CNTRL = 0;


    /*
     * Clear any pending update interrupt.
     */
    TIM2_SR1 &= (uint8_t)(~TIM2_SR_UIF);


    /*
     * Enable TIM2 update interrupt.
     */
    TIM2_IER |= TIM2_IER_UIE;


    /*
     * Start TIM2.
     */
    TIM2_CR1 |= TIM2_CR1_CEN;
}


/* ============================================================
 * INITIALIZATION
 * ============================================================ */

void Buzzer_Init(void)
{
    /*
     * Configure buzzer GPIO as push-pull.
     *
     * Current hardware:
     *
     * STM8 PA3 ? resistor ? BC547
     */
    GPIO_Output_PP(
        BUZZER_PORT,
        BUZZER_PIN
    );


    /*
     * Start silent.
     */
    Buzzer_Output(FALSE);


    /*
     * Reset state.
     */
    current_melody = 0;

    current_note = 0;

    note_start_time = 0;

    buzzer_busy = FALSE;


    /*
     * Make sure TIM2 is stopped.
     */
    Buzzer_Timer_Stop();
}


/* ============================================================
 * PLAY BUZZER EVENT
 * ============================================================ */

void Buzzer_Play(BuzzerEvent event)
{
    /*
     * Select melody.
     */
    switch(event)
    {
        case BUZZER_EVENT_BOOT:

            current_melody = boot_melody;

            break;


        case BUZZER_EVENT_MODE_CHANGE:

            current_melody = mode_change_melody;

            break;


        case BUZZER_EVENT_SHIFT:

            current_melody = shift_melody;

            break;


        case BUZZER_EVENT_READY:

            current_melody = ready_melody;

            break;


        case BUZZER_EVENT_FAULT:

            current_melody = fault_melody;

            break;


        default:

            return;
    }


    /*
     * Start from first note.
     */
    current_note = 0;


    /*
     * Record note start time.
     */
    note_start_time = Timer_GetTick();


    /*
     * Mark buzzer active.
     */
    buzzer_busy = TRUE;


    /*
     * Start first note immediately.
     */
    Buzzer_SetFrequency(
        current_melody[current_note].frequency
    );
}


/* ============================================================
 * BUZZER TASK
 *
 * Non-blocking melody engine.
 *
 * Must be called continuously from main().
 * ============================================================ */

void Buzzer_Task(void)
{
    const BuzzerNote *note;


    /*
     * Nothing playing.
     */
    if(buzzer_busy == FALSE)
    {
        return;
    }


    /*
     * Get current note.
     */
    note = &current_melody[current_note];


    /*
     * End of melody.
     */
    if(note->frequency == BUZZER_MELODY_END)
    {
        Buzzer_Stop();

        return;
    }


    /*
     * Wait until current note duration expires.
     */
    if((Timer_GetTick() - note_start_time) < note->duration)
    {
        return;
    }


    /*
     * Move to next note.
     */
    current_note++;


    /*
     * Start timing next note.
     */
    note_start_time = Timer_GetTick();


    /*
     * Start next note.
     */
    Buzzer_SetFrequency(
        current_melody[current_note].frequency
    );
}


/* ============================================================
 * STOP BUZZER
 * ============================================================ */

void Buzzer_Stop(void)
{
    /*
     * Stop TIM2 and silence buzzer.
     */
    Buzzer_Timer_Stop();


    /*
     * Reset state.
     */
    current_melody = 0;

    current_note = 0;

    note_start_time = 0;

    buzzer_busy = FALSE;
}


/* ============================================================
 * BUSY STATUS
 * ============================================================ */

uint8_t Buzzer_IsBusy(void)
{
    return buzzer_busy;
}


/* ============================================================
 * TIM2 INTERRUPT SERVICE
 *
 * Called from:
 *
 * TIM2_UPD_OVF_BRK_IRQHandler()
 *
 * in stm8_interrupt_vector.c
 * ============================================================ */

void Buzzer_TickISR(void)
{
    /*
     * Clear TIM2 update interrupt flag.
     */
    TIM2_SR1 &= (uint8_t)(~TIM2_SR_UIF);


    /*
     * Toggle the buzzer output.
     *
     * TIM2 determines the frequency.
     * The BC547 provides the buzzer drive.
     */
    GPIO_Toggle(
        BUZZER_PORT,
        BUZZER_PIN
    );
}