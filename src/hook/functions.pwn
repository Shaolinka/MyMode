stock AttachTrailerToVehicleEx(trailerid, vehicleid)
{
    new trailer_free_slot = Iter_Free(Trailers),
        Float: trailer_pos_x = 0.0,
        Float: trailer_pos_y = 0.0,
        Float: trailer_pos_z = 0.0;
        
    GetVehiclePos(trailerid, trailer_pos_x, trailer_pos_y, trailer_pos_z);

    SetTrailerVehID(trailer_free_slot, trailerid);
    
    SetTrailerPosX(trailer_free_slot, trailer_pos_x);
    SetTrailerPosY(trailer_free_slot, trailer_pos_y);
    SetTrailerPosZ(trailer_free_slot, trailer_pos_z);

    Iter_Add(Trailers, trailer_free_slot);

    return AttachTrailerToVehicle(trailerid, vehicleid);
}
#if defined _ALS_AttachTrailerToVehicle
    #undef    AttachTrailerToVehicle
#else 
    #define _ALS_AttachTrailerToVehicle
#endif
#define AttachTrailerToVehicle AttachTrailerToVehicleEx