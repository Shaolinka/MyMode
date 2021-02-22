stock IsPlayerReachedMaxAdminLvl(playerid)
{
    new player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
        {
            "SELECT a.a_lvl FROM admins a INNER JOIN characters c \
            ON a.c_id = c.c_id INNER JOIN users u \
            ON c.u_id = u.u_id \
            WHERE a.c_id = %d \
            LIMIT 1"
        },
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_character_id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        bool: is_player_reached_max_admin_lvl = false;

    if(rows)
    {
        new player_admin_lvl = cache_get_field_content_int(0, "a_lvl");

        if(player_admin_lvl >= MAX_ADMIN_LVL)
        {
            is_player_reached_max_admin_lvl = true;
            cache_delete(query_result);
        }
    }

    return is_player_reached_max_admin_lvl;
}

stock IsPlayerAdminEx(playerid)
{
    new player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
        {
            "SELECT a.id FROM admins a INNER JOIN characters c \
            ON a.c_id = c.c_id INNER JOIN users u \
            ON c.u_id = u.u_id \
            WHERE a.c_id = %d \
            LIMIT 1"
        },
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_character_id);
        
    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        bool: is_player_admin_ex = false;

    if(rows)
    {
        is_player_admin_ex = true;
        cache_delete(query_result);
    }

    return is_player_admin_ex;
}

stock GetPlayerAdminLvl(playerid)
{
    new player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
        {
            "SELECT a.a_lvl FROM admins a INNER JOIN characters c \
            ON a.c_id = c.c_id INNER JOIN users u \
            ON c.u_id = u.u_id \
            WHERE a.c_id = %d \
            LIMIT 1"
        },
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_character_id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_admin_lvl = INVALID_ADMIN_LVL;

    if(rows)
    {
        player_admin_lvl = cache_get_field_content_int(0, "a_lvl");
        cache_delete(query_result);
    }
    
    return player_admin_lvl;
}

stock GivePlayerAdmin(playerid, lvl, is_purchased = ADMIN_TYPE_REAL)
{
    if(is_purchased)
    {
        new fmt_str[] = 
        {
            "INSERT INTO admins(id, a_id, c_id, a_lvl) \
            VALUES(%d, %d, %d, %d) \
            ON DUPLICATE KEY UPDATE id = id + 1"
        },
        result_str[((sizeof fmt_str) + ((- 2 + 11) + (- 2 + 11) + (- 2 + 11 ) + (- 2 + MAX_ADMIN_LVL_LEN)) + 1)];

        new admin_last_id = cache_insert_id(),
            player_character_id = GetPlayerCharacterID(playerid);

        mysql_format(
            mysql_handle, result_str, sizeof result_str, fmt_str, 
            admin_last_id, admin_last_id, player_character_id, lvl);
        mysql_query(mysql_handle, result_str, false);

        new fmt_str_prototype[] = 
        {
            "INSERT INTO purchased_admins(id, a_id, pa_date_of_purchase) \
            VALUES(%d, %d, NOW()) \
            ON DUPLICATE KEY UPDATE id = id + 1"
        },
        result_str_prototype[((sizeof fmt_str_prototype) + ((- 2 + 11) + (- 2 + 11)) + 1)];

        mysql_format(
            mysql_handle, result_str_prototype, sizeof result_str_prototype, fmt_str_prototype,
            admin_last_id, admin_last_id);
        mysql_query(mysql_handle, result_str_prototype, false);
    }

    return 1;
}