
stock TimerOnPlayerConnect(playerid)
{
    for(new j; j < MAX_TIMERS; j ++)
        StartTimerForPlayer(playerid, j);
}