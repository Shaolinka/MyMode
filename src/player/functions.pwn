stock IsPlayerExistInDatabase(playerid)
{
    new player_name[MAX_PLAYER_NAME];

    format(player_name, sizeof player_name, "%s", GetPlayerNameEx(playerid));

    new fmt_str[] = 
    {
        "SELECT c.id FROM characters c LEFT JOIN users u \
        ON c.user_id = u.user_id WHERE c.character_name = '%s' LIMIT 1"
    },
    result_str[(((sizeof fmt_str)) + ((- 2 + MAX_PLAYER_NAME)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_name);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        bool: is_player_exist = false;

    if(rows)
        is_player_exist = true;

    cache_delete(query_result);

    return is_player_exist;
}

stock GetPlayerUserID(playerid)
{
    new player_name[MAX_PLAYER_NAME];

    format(player_name, sizeof player_name, "%s", GetPlayerNameEx(playerid));

    new fmt_str[] = 
    {
        "SELECT u.user_id FROM users u LEFT JOIN characters c \
        ON u.user_id = c.user_id \
        WHERE c.character_name = '%s' \
        LIMIT 1"
    },
    result_str[((sizeof fmt_str) + ((- 2 + MAX_PLAYER_NAME)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_name);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_user_id = INVALID_USER_ID;

    if(rows)
        player_user_id = cache_get_field_content_int(0, "user_id");

    cache_delete(query_result);

    return player_user_id;
}

stock GetPlayerCharacterID(playerid)
{
    new player_user_id = GetPlayerUserID(playerid),
        fmt_str[] = 
    {
        "SELECT c.character_id FROM characters c LEFT JOIN users u \
        ON c.user_id = u.user_id \
        WHERE c.user_id = %d \
        LIMIT 1"
    },
    result_str[((sizeof fmt_str) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_user_id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_character_id = INVALID_CHARACTER_ID;

    if(rows)
        player_character_id = cache_get_field_content_int(0, "character_id");

    cache_delete(query_result);

    return player_character_id;
}

stock GetPlayerNameByCharacterID(characterid)
{
    new fmt_str[] = 
    {
        "SELECT c.character_name FROM characters c LEFT JOIN users u \
        ON c.user_id = u.user_id WHERE c.character_id = %d LIMIT 1"
    },
    result_str[((sizeof fmt_str) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, characterid);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_name[MAX_PLAYER_NAME];

    if(rows)
        cache_get_field_content(0, "character_name", player_name, mysql_handle, sizeof player_name);

    cache_delete(query_result);

    return player_name;
}

stock SetPlayerAntiFloodTick(playerid, count = -1)
{
    if(count != -1)
        SetPlayerData(playerid, P_ANTI_FLOOD_TICK, (gettime() + (count / 1_000)));

    return 1;
}