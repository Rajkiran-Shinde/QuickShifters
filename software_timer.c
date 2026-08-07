#include "software_timer.h"
#include "timer.h"


void SoftwareTimer_Start(SoftwareTimer_t *timer, uint32_t duration)
{
    timer->start_time = Timer_GetTick();
    timer->duration = duration;
    timer->active = TRUE;
}


void SoftwareTimer_Stop(SoftwareTimer_t *timer)
{
    timer->active = FALSE;
}


uint8_t SoftwareTimer_IsRunning(SoftwareTimer_t *timer)
{
    return timer->active;
}


uint8_t SoftwareTimer_Expired(SoftwareTimer_t *timer)
{
    if(timer->active == FALSE)
    {
        return FALSE;
    }

    if((Timer_GetTick() - timer->start_time) >= timer->duration)
    {
        timer->active = FALSE;

        return TRUE;
    }

    return FALSE;
}