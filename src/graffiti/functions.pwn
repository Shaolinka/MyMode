stock LoadGraffiti()
{
    new fmt_str[] = 
        "SELECT * FROM graffiti g LEFT JOIN characters c ON g.last_author_id = c.character_id LIMIT %d",
        result_str[((sizeof fmt_str) + ((- 2 + MAX_GRAFFITI_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, MAX_GRAFFITI);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows();

    if(rows)
    {
        if(rows > MAX_GRAFFITI)
        {
            rows = MAX_GRAFFITI;

            printf(
                "Количество граффити в базе превысило норму, следовательно %d — не загружено", 
                rows - MAX_GRAFFITI
            );
        }

        for(new j; j < sizeof rows; j ++)
        {
            SetGraffitiObjModelID(j, cache_get_field_content_int(j, "obj_model_id"));

            SetGraffitiPosX(j, cache_get_field_content_float(j, "pos_x"));
            SetGraffitiPosY(j, cache_get_field_content_float(j, "pos_y"));
            SetGraffitiPosZ(j, cache_get_field_content_float(j, "pos_z"));

            SetGraffitiPosRX(j, cache_get_field_content_float(j, "pos_rx"));
            SetGraffitiPosRY(j, cache_get_field_content_float(j, "pos_ry"));
            SetGraffitiPosRZ(j, cache_get_field_content_float(j, "pos_rz"));

            SetGraffitiGangID(j, cache_get_field_content_int(j, "gang_id"));
            
            SetGraffitiCooldown(j, cache_get_field_content_int(j, "cooldown"));

            SetGraffitiLastAuthorID(j, cache_get_field_content_int(j, "last_author_id"));

            Iter_Add(Graffiti, j);
        }
    }

    cache_delete(query_result);

    return printf("count: %d", Iter_Count(Graffiti));
}

stock GetGraffitiPos(id, &Float: pos_x, &Float: pos_y, &Float: pos_z)
{
    pos_x = GetGraffitiPosX(id);
    pos_y = GetGraffitiPosY(id);
    pos_z = GetGraffitiPosZ(id);

    return 1;
}

stock UpdateGraffiti3DText()
{
    foreach(new j : Graffiti)
    {
        DecrementGraffitiCooldown(j);

        new gang_name[][] = {"{CC0099}The Ballas", "{00FFCC}Varrio Los Aztecas"},
            graffiti_cooldown = GetGraffitiCooldown(j),
            fmt_str[] = "%d ч. %d м.",
            result_str[((sizeof fmt_str) + ((- 2 + 1) + (- 2 + 2)) + 1)],
            graffiti_cooldown_hour,
            graffiti_cooldown_minute;

        ConvertTime(
            graffiti_cooldown, 
            CONVERT_TYPE_IN_HOUR_AND_MINUTE, 
            graffiti_cooldown_hour, graffiti_cooldown_minute
        );

        format
        (
            result_str, sizeof result_str, 
            fmt_str, 
            graffiti_cooldown_hour, 
            graffiti_cooldown_minute % 60
        );

        new fmt_str_prototype[] = "Граффити %s\n{ffffff}Можно закрасить через: %s\nПоследний закрашивший: %s",
            result_str_prototype[
                ((sizeof fmt_str_prototype) + 
                ((- 2 + 18) + 
                (- 2 + (sizeof result_str)) +
                (- 2 + MAX_PLAYER_NAME)) + 1)],
            graffiti_gang_id = GetGraffitiGangID(j);

        format
        (
            result_str_prototype, sizeof result_str_prototype, 
            fmt_str_prototype, 
            gang_name[graffiti_gang_id],
            graffiti_cooldown_hour > 0 ? result_str : "Можно закрашивать",
            GetPlayerNameByCharacterID(GetGraffitiLastAuthorID(j))
        );

        new Text3D: graffiti_label = GetGraffitiLabel(j);

        UpdateDynamic3DTextLabelText
        (
            graffiti_label, 
            0xffffffFF,
            result_str_prototype
        );
    }

    return 1;
}

stock GetNearestGraffiti(playerid)
{
    new nearest_graffiti = INVALID_GRAFFITI;

    foreach(new j : Graffiti)
    {
        new graffiti_area = GetGraffitiArea(j);

        if(!IsPlayerInDynamicArea(playerid, graffiti_area))
            continue;

        nearest_graffiti = j;
    }

    return nearest_graffiti;
}