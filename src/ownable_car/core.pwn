stock OwnableCarOnGameModeInit()
{
    LoadOwnableCars();

    return 1;
}

stock OwnableCarOnVehicleDeath(vehicleid, killerid)
{
    SetVVarInt(vehicleid, "veh_killer", killerid);

    printf("%d", GetVVarInt(vehicleid, "veh_killer"));
    
    return 1;
}