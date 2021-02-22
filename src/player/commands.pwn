cmd:veh(playerid, const params[])
{
    extract params -> new veh_model_id, _:veh_colors[2]; else
        return 0;

    printf("%d, %d", veh_colors[0], veh_colors[1]);

    new Float: player_pos_x = 0.0,
        Float: player_pos_y = 0.0,
        Float: player_pos_z = 0.0;

    GetPlayerPos(playerid, player_pos_x, player_pos_y, player_pos_z);

    return CreateVehicle
            (
                veh_model_id, 
                player_pos_x + 5, 
                player_pos_y,
                player_pos_z,
                180.0, 
                veh_colors[0], 
                veh_colors[1], 
                -1
            ); 
}

cmd:svdata(playerid)
{
    new player_veh_id = GetPlayerVehicleID(playerid);

    SetVVarString(player_veh_id, "veh_driver_name", GetPlayerNameEx(playerid));
    SetVVarInt(player_veh_id, "veh_id", player_veh_id);
    SetVVarFloat(player_veh_id, "veh_min_hp", 195.00);

    new player_name[MAX_PLAYER_NAME];

    GetVVarString(player_veh_id, "veh_driver_name", player_name);

    printf("%d, %s", player_veh_id, player_name);

    return 1;
}

cmd:gvdata(playerid)
{
    new player_veh_id = GetPlayerVehicleID(playerid);

    printf("%d", GetCountOfVVars(player_veh_id));

    return 1;
}

cmd:testnaxuy2() return 1;

cmd:atttoveh(playerid)
{
    new player_veh_id = GetPlayerVehicleID(playerid);
    
    AttachTrailerToVehicleEx(2, player_veh_id);

    new Float: trailer_pos_x = 0.0,
        Float: trailer_pos_y = 0.0,
        Float: trailer_pos_z = 0.0;

    GetTrailerPos(0, trailer_pos_x, trailer_pos_y, trailer_pos_z);

    return printf("%f, %f, %f", trailer_pos_x, trailer_pos_y, trailer_pos_z);
}

cmd:testnaxuy()
{
    new Float: trailer_pos_x = 0.0,
        Float: trailer_pos_y = 0.0,
        Float: trailer_pos_z = 0.0;
        
    GetTrailerPos(0, trailer_pos_x, trailer_pos_y, trailer_pos_z);

    return printf("%f, %f, %f", trailer_pos_x, trailer_pos_y, trailer_pos_z);
}

cmd:getneartrailer(playerid) return printf("%d", GetNearestTrailer(playerid));

cmd:buyveh(playerid, const params[])
{
    if(!strlen(params)) 
        return SendClientMessage(playerid, -1, "¬ы ниху€ не ввели"); 

    extract params -> new veh_model_id, _:veh_colors[2];

    for(new j; j < sizeof veh_colors; j ++)
    {
        if(0 <= veh_colors[j] <= 255)
            continue;

        new fmt_str[] = "÷вет %d невалидный",
            result_str[((sizeof fmt_str) + ((- 2 + 3)) + 1)];

        format(result_str, sizeof result_str, fmt_str, j + 1);

        SendClientMessage(playerid, -1, result_str);
    }

    new Float: player_pos_x = 0.0,
        Float: player_pos_y = 0.0,
        Float: player_pos_z = 0.0;

    GetPlayerPos(playerid, player_pos_x, player_pos_y, player_pos_z);

    printf("1: %d, 2: %d", veh_colors[0], veh_colors[1]);

    return BuyOwnableCar
            (
                playerid, 
                veh_model_id, 
                player_pos_x, 
                player_pos_y, 
                player_pos_z, 
                veh_colors
            );
}