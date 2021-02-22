stock CreateGraffiti3DTexts()
{
    foreach(new j : Graffiti)
    {
        new Float: graffiti_pos_x = 0.0,
            Float: graffiti_pos_y = 0.0,
            Float: graffiti_pos_z = 0.0;

        GetGraffitiPos(j, graffiti_pos_x, graffiti_pos_y, graffiti_pos_z);

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
            result_str,
            GetPlayerNameByCharacterID(GetGraffitiLastAuthorID(j))
        );

        new Text3D: graffiti_label = CreateDynamic3DTextLabel
        (
            result_str_prototype, 
            0xffffffFF, 
            graffiti_pos_x,
            (graffiti_pos_y + - 0.3052),
            graffiti_pos_z,
            20.0
        );

        printf("%d, %d", graffiti_cooldown_hour, graffiti_cooldown_minute);

        SetGraffitiLabel(j, graffiti_label);
    }
}

stock Load3DTexts()
{
    CreateGraffiti3DTexts();

    return 1;
}