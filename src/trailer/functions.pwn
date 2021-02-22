stock GetTrailerPos(id, &Float: pos_x, &Float: pos_y, &Float: pos_z)
{
    pos_x = GetTrailerPosX(id);
    pos_y = GetTrailerPosY(id);
    pos_z = GetTrailerPosZ(id);

    return 1;
}

stock SetTrailerColors(id, const colors[], size = sizeof colors)
{
    for(new j; j < size; j ++)
        g_trailer[id][T_COLORS][j] = colors[j];

    return 1;
}

stock UpdateTrailersPos()
{
    foreach(new j : Trailers)
    {
        new trailer_veh_id = GetTrailerVehID(j),
            Float: trailer_pos_x = 0.0,
            Float: trailer_pos_y = 0.0,
            Float: trailer_pos_z = 0.0;

        GetVehiclePos(trailer_veh_id, trailer_pos_x, trailer_pos_y, trailer_pos_z);
        SetTrailerPosX(j, trailer_pos_x);
        SetTrailerPosY(j, trailer_pos_y);
        SetTrailerPosZ(j, trailer_pos_z);
    }

    return 1;
}

stock GetNearestTrailer(playerid)
{
    new nearest_trailer_id = INVALID_TRAILER_ID;

    foreach(new j : Trailers)
    {
        new Float: trailer_pos_x = 0.0,
            Float: trailer_pos_y = 0.0,
            Float: trailer_pos_z = 0.0;

        GetTrailerPos(j, trailer_pos_x, trailer_pos_y, trailer_pos_z);

        if(!IsPlayerInRangeOfPoint(playerid, 2.0, trailer_pos_x, trailer_pos_y, trailer_pos_z))
            continue;

        nearest_trailer_id = j;
    }

    return nearest_trailer_id;
}

stock LoadTrailers()
{
    new fmt_str[] = "SELECT * FROM trailers t INNER JOIN ownable_cars oc ON t.t_oc_id = oc.oc_id LIMIT %d",
        result_str[((sizeof fmt_str) + ((- 2 + MAX_TRAILERS_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, MAX_TRAILERS);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows();

    if(rows)
    {
        for(new j; j < sizeof rows; j ++)
        {
            new trailer_ownable_car_id = cache_get_field_content_int(j, "t_oc_id"),
                trailer_ownable_car_veh_id = GetVehicleIDByOcID(trailer_ownable_car_id),
                trailer_model_id = cache_get_field_content_int(j, "t_model_id"),
                Float: trailer_pos_x = cache_get_field_content_float(j, "t_pos_x"),
                Float: trailer_pos_y = cache_get_field_content_float(j, "t_pos_y"),
                Float: trailer_pos_z = cache_get_field_content_float(j, "t_pos_z"),
                trailer_colors[8];

            cache_get_field_content(j, "t_colors", trailer_colors, mysql_handle, sizeof trailer_colors);

            new trailer_colors_ex[2];

            sscanf(trailer_colors, "p<,>a<i>[2]", trailer_colors_ex);

            new trailer_id = CreateVehicle
            (
                trailer_model_id, 
                trailer_pos_x, 
                trailer_pos_y, 
                trailer_pos_z, 
                180.0, 
                trailer_colors_ex[0], 
                trailer_colors_ex[1], 
                -1
            );

            AttachTrailerToVehicleEx(trailer_id, trailer_ownable_car_veh_id);

            SetTrailerOwnableCarID(j, trailer_ownable_car_id);

            SetTrailerModelID(j, trailer_model_id);

            SetTrailerPosX(j, trailer_pos_x);
            SetTrailerPosY(j, trailer_pos_y);
            SetTrailerPosZ(j, trailer_pos_z);

            for(new idx; idx < sizeof trailer_colors_ex; idx ++)
                SetTrailerColors(j, trailer_colors_ex[idx]);
            
            Iter_Add(Trailers, j);
        }
        printf("zagrusheno trailerov: %d", Iter_Count(Trailers));
    }

    cache_delete(query_result);
    
    return !mysql_errno();
}

stock SaveTrailer(id)
{

}