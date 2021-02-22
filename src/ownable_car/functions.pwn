stock GetVehicleIDByOcID(id)
{
    new veh_id = INVALID_VEHICLE_ID;

    foreach(new j : OwnableCars)
    {
        if(id != GetOwnableCarID(j))
            continue;

        veh_id = GetOwnableCarVehID(j);
    }

    return veh_id;
}

stock SetOwnableCarColors(id, const colors[], size = sizeof colors)
{
    for(new j; j < size; j ++)
        g_ownable_car[id][OC_COLORS][j] = colors[j];
}

stock BuyOwnableCar(playerid, model_id, Float: pos_x, Float: pos_y, Float: pos_z, const colors[])
{
    new ownable_car_free_slot = Iter_Free(OwnableCars),
        player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
        {
            "INSERT INTO ownable_cars \
            (id, oc_id, oc_owner_id, oc_model_id, oc_pos_x, oc_pos_y, oc_pos_z, oc_colors) \
            VALUES \
            (LAST_INSERT_ID(), %d, %d, %d, %f, %f, %f, '%s') \
            ON DUPLICATE KEY UPDATE id = id + 1"
        },
        result_str[
            ((sizeof fmt_str) + 
            ((- 2 + MAX_OWNABLE_CARS_LEN) + 
            (- 2 + 11) + 
            (- 2 + 3) + 
            (- 2 + 10) + 
            (- 2 + 10) +
            (- 2 + 10) +
            (- 2 + 8)) + 
            1)];

    new fmt_str_prototype[] = "%d, %d",
        result_str_prototype[((sizeof fmt_str_prototype) + ((- 2 + 3) + (- 2 + 3)) + 1)];

    format
    (
        result_str_prototype, sizeof result_str_prototype, 
        fmt_str_prototype, 
        colors[0], 
        colors[1]
    );

    mysql_format(
        mysql_handle, result_str, sizeof result_str, fmt_str, 
        ownable_car_free_slot, player_character_id, model_id, pos_x,
        pos_y, pos_z, result_str_prototype);

    mysql_query(mysql_handle, result_str, false);

    return !mysql_errno();
}

stock LoadOwnableCars()
{
    new fmt_str[] = "SELECT * FROM ownable_cars oc INNER JOIN trailers t ON oc.oc_id = t.t_oc_id LIMIT %d",
        result_str[((sizeof fmt_str) + ((- 2 + MAX_OWNABLE_CARS_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, MAX_OWNABLE_CARS);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows();

    if(rows)
    {
        for(new j; j < sizeof rows; j ++)
        {
            new ownable_car_id = cache_get_field_content_int(j, "oc_id"),
                ownable_car_owner_id = cache_get_field_content_int(j, "oc_owner_id"),
                ownable_car_model_id = cache_get_field_content_int(j, "oc_model_id"),
                Float: ownable_car_pos_x = cache_get_field_content_float(j, "oc_pos_x"),
                Float: ownable_car_pos_y = cache_get_field_content_float(j, "oc_pos_y"),
                Float: ownable_car_pos_z = cache_get_field_content_float(j, "oc_pos_z"),
                ownable_car_colors[8];

            cache_get_field_content(j, "oc_colors", ownable_car_colors, mysql_handle, sizeof ownable_car_colors);

            new ownable_car_colors_ex[2];

            sscanf(ownable_car_colors, "p<,>a<i>[2]", ownable_car_colors_ex);

            new ownable_car_veh_id = CreateVehicle
            (
                ownable_car_model_id, 
                ownable_car_pos_x, 
                ownable_car_pos_y, 
                ownable_car_pos_z, 
                180.0, 
                ownable_car_colors_ex[0], 
                ownable_car_colors_ex[1], 
                -1
            );

            SetOwnableCarID(j, ownable_car_id);

            SetOwnableCarOwnerID(j, ownable_car_owner_id);

            SetOwnableCarModelID(j, ownable_car_model_id);

            SetOwnableCarPosX(j, ownable_car_pos_x);
            SetOwnableCarPosY(j, ownable_car_pos_y);
            SetOwnableCarPosZ(j, ownable_car_pos_z);

            for(new idx; idx < sizeof ownable_car_colors_ex; idx ++)
                SetOwnableCarColors(j, ownable_car_colors_ex[idx]);

            SetOwnableCarVehID(j, ownable_car_veh_id);

            Iter_Add(OwnableCars, j);
        }
        printf("zagrusheno: %d", Iter_Count(OwnableCars));
    }

    cache_delete(query_result);

    return !mysql_errno();
}