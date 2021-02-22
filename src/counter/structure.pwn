enum 
    E_COUNTER_STRUCT
{
    C_ID,
    C_OCCUPIER_ID,
    bool: C_STATE,
    C_CONTENT,
    C_TIME_TO_END
}

new g_counter[MAX_COUNTERS][E_COUNTER_STRUCT];

new Iterator: Counters<MAX_COUNTERS>;