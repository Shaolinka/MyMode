/*
 * Получает ближайший прилавок, -1 в случае неудачи
 *
 * @param int playerid
 *
 * @return int
 */
stock GetNearestCounter(playerid)
{
    new nearest_counter_id = 0xFFFF;

    foreach(new idx : Counters) 
    {
        new counter_area_id = GetCounterData(idx, C_AREA);

        if(!IsPlayerInDynamicArea(playerid, counter_area_id))
            continue;

        nearest_counter_id = idx;

        break;
    }

    return nearest_counter_id;
}

/*
 * Проверяет занимает ли игрок какой-то из прилавков, в случае неудачи возвращает -1
 *
 * @param int playerid
 *
 * @return int
 */
stock IsPlayerOccupyingAnyCounter(playerid)
{
    foreach(new idx : Counters)
    {
        new user_id = GetPlayerAccountID(playerid),
            counter_occupier = GetCounterOccupier(idx);

        if(user_id != counter_occupier)
            continue;

        return 1;
    }

    return 0xFFFF;
}

stock GetCounterTimeToEnd(id, &minutes, &seconds)
{
    if(!IsValidCounter(id))
        return 0xFFFF;

    new counter_time_to_end = GetCounterData(id, C_TIME_TO_END);

    new counter_time_to_end_in_minutes,
        counter_time_to_end_in_seconds;

    if(counter_time_to_end != 0)
        ConvertTime(counter_time_to_end, counter_time_to_end_in_minutes, counter_time_to_end_in_seconds);

    minutes = counter_time_to_end_in_minutes;
    seconds = counter_time_to_end_in_seconds;

    return 1;
}

stock InitCounters()
{
    
}