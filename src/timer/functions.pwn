stock StartTimerForPlayer(playerid, type = TIMER_TYPE_1000_MC)
{
    switch(type)
    {
        case TIMER_TYPE_1000_MC:
        {
            new timer_id = SetTimerEx("@__OnPlayer1000McTimer", 1_000, true, "%d", playerid);
            SetPlayerTimer(playerid, TIMER_TYPE_1000_MC, timer_id);
        }
    }

    return 1;
}

@__OnPlayer1000McTimer(playerid);
@__OnPlayer1000McTimer(playerid)
{   
    UpdateTrailersPos();

    UpdateGraffiti3DText();

    new nearest_graffiti = GetNearestGraffiti(playerid);

    if(nearest_graffiti != INVALID_GRAFFITI)
    {
        new weapon_id = -1,
            weapon_ammo = -1;

        GetPlayerWeaponData(playerid, 9, weapon_id, weapon_ammo);

        new current_weapon = GetPlayerWeapon(playerid);

        if((weapon_id == WEAPON_SPRAYCAN) && (weapon_ammo > 0) && (current_weapon == WEAPON_SPRAYCAN))
        {
            new graffiti_gang_id = GetGraffitiGangID(nearest_graffiti),
                player_team = GetPlayerTeamEx(playerid);

            if(graffiti_gang_id == player_team)
            {
                new player_anti_flood_tick = GetPlayerAntiFloodTick(playerid);

                if(gettime() > player_anti_flood_tick)
                {
                    SendClientMessage(playerid, -1, "Этот граффити принадлежит Вашей банде");

                    return SetPlayerAntiFloodTick(playerid, 7_000);
                }

                return 0;
            }

            new graffiti_cooldown = GetGraffitiCooldown(nearest_graffiti);

            if(graffiti_cooldown > 0)
            {
                new player_anti_flood_tick = GetPlayerAntiFloodTick(playerid);

                if(gettime() > player_anti_flood_tick)
                {
                    SendClientMessage(playerid, -1, "Дождитесь сброса cooldown'a");

                    return SetPlayerAntiFloodTick(playerid, 7_000);
                }

                return 0;
            }

            IncrementPlayerPaintingSec(playerid);

            new player_painting_sec = GetPlayerPaintingSec(playerid);

            if(player_painting_sec >= 5)
            {
                new graffiti_obj_id = GetGraffitiObjID(nearest_graffiti);

                if(IsValidDynamicObject(graffiti_obj_id))
                    DestroyDynamicObject(graffiti_obj_id);

                SetGraffitiObjID(nearest_graffiti, INVALID_OBJECT_ID);

                new Float: graffiti_pos_x = 0.0,
                    Float: graffiti_pos_y = 0.0,
                    Float: graffiti_pos_z = 0.0;

                GetGraffitiPos(nearest_graffiti, graffiti_pos_x, graffiti_pos_y, graffiti_pos_z);

                new graffiti_obj_id_ex = CreateDynamicObject
                (
                    18661, 
                    graffiti_pos_x, 
                    graffiti_pos_y, 
                    graffiti_pos_z, 
                    GetGraffitiPosRX(nearest_graffiti),
                    GetGraffitiPosRY(nearest_graffiti),
                    GetGraffitiPosRZ(nearest_graffiti)
                );

                SetGraffitiObjID(nearest_graffiti, graffiti_obj_id_ex);

                SetGraffitiGangID(nearest_graffiti, 1);

                new graffiti_cooldown_ex = (4 * 60 * 60);

                SetGraffitiCooldown(nearest_graffiti, graffiti_cooldown_ex);

                new player_character_id = GetPlayerCharacterID(playerid);

                SetGraffitiLastAuthorID(nearest_graffiti, player_character_id);
            }
        }
    }

    return 1;
}