#define MAX_OWNABLE_CARS (MAX_VEHICLES)
#define MAX_OWNABLE_CARS_LEN (4)

#define GetOwnableCarData(%0,%1) g_ownable_car[%0][%1]
#define SetOwnableCarData(%0,%1,%2) g_ownable_car[%0][%1] = %2

#define GetOwnableCarID(%0) GetOwnableCarData(%0, OC_ID)
#define SetOwnableCarID(%0,%1) SetOwnableCarData(%0, OC_ID, %1)

#define SetOwnableCarOwnerID(%0,%1) SetOwnableCarData(%0, OC_OWNER_ID, %1)

#define SetOwnableCarModelID(%0,%1) SetOwnableCarData(%0, OC_MODEL_ID, %1)

#define SetOwnableCarPosX(%0,%1) SetOwnableCarData(%0, OC_POS_X, %1)

#define SetOwnableCarPosY(%0,%1) SetOwnableCarData(%0, OC_POS_Y, %1)

#define SetOwnableCarPosZ(%0,%1) SetOwnableCarData(%0, OC_POS_Z, %1)

#define GetOwnableCarVehID(%0) GetOwnableCarData(%0, OC_VEH_ID)
#define SetOwnableCarVehID(%0,%1) SetOwnableCarData(%0, OC_VEH_ID, %1)