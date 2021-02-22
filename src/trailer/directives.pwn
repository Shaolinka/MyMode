#define MAX_TRAILERS (MAX_VEHICLES)
#define MAX_TRAILERS_LEN (4)

#define INVALID_TRAILER_ID (INVALID_PLAYER_ID)

#define GetTrailerData(%0,%1) g_trailer[%0][%1]
#define SetTrailerData(%0,%1,%2) g_trailer[%0][%1] = %2

#define SetTrailerOwnableCarID(%0,%1) SetTrailerData(%0, T_OC_ID, %1)

#define SetTrailerModelID(%0,%1) SetTrailerData(%0, T_MODEL_ID, %1)

#define GetTrailerPosX(%0) GetTrailerData(%0, T_POS_X)
#define SetTrailerPosX(%0,%1) SetTrailerData(%0, T_POS_X, %1)

#define GetTrailerPosY(%0) GetTrailerData(%0, T_POS_Y)
#define SetTrailerPosY(%0,%1) SetTrailerData(%0, T_POS_Y, %1)

#define GetTrailerPosZ(%0) GetTrailerData(%0, T_POS_Z)
#define SetTrailerPosZ(%0,%1) SetTrailerData(%0, T_POS_Z, %1)

#define GetTrailerVehID(%0) GetTrailerData(%0, T_VEH_ID)
#define SetTrailerVehID(%0,%1) SetTrailerData(%0, T_VEH_ID, %1)