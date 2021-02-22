stock CreateGraffitiObjects()
{
    foreach(new j : Graffiti)
    {
        new Float: graffiti_pos_x = 0.0,
            Float: graffiti_pos_y = 0.0,
            Float: graffiti_pos_z = 0.0;

        GetGraffitiPos(j, graffiti_pos_x, graffiti_pos_y, graffiti_pos_z);

        new graffiti_area = CreateDynamicSphere
        (
            graffiti_pos_x,
            (graffiti_pos_y + - 0.3052),
            graffiti_pos_z,
            2.0
        );

        SetGraffitiArea(j, graffiti_area);

        new graffiti_obj_id = CreateDynamicObject
        (
            GetGraffitiObjModelID(j),
            graffiti_pos_x,
            graffiti_pos_y,
            graffiti_pos_z,
            GetGraffitiPosRX(j),
            GetGraffitiPosRY(j),
            GetGraffitiPosRZ(j)
        );

        SetGraffitiObjID(j, graffiti_obj_id);
    }

    return 1;
}

stock LoadObjects()
{
    CreateGraffitiObjects();

    return 1;
}