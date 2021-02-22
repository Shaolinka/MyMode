#define MAX_GRAFFITI (3)
#define MAX_GRAFFITI_LEN (1)

#define INVALID_GRAFFITI (INVALID_PLAYER_ID)

#define GetGraffitiData(%0,%1) g_graffiti[%0][%1]
#define SetGraffitiData(%0,%1,%2) g_graffiti[%0][%1] = %2

#define GetGraffitiObjModelID(%0) GetGraffitiData(%0, G_OBJ_MODEL_ID)
#define SetGraffitiObjModelID(%0,%1) SetGraffitiData(%0, G_OBJ_MODEL_ID, %1)

#define GetGraffitiPosX(%0) GetGraffitiData(%0, G_POS_X)
#define SetGraffitiPosX(%0,%1) SetGraffitiData(%0, G_POS_X, %1)

#define GetGraffitiPosY(%0) GetGraffitiData(%0, G_POS_Y)
#define SetGraffitiPosY(%0,%1) SetGraffitiData(%0, G_POS_Y, %1)

#define GetGraffitiPosZ(%0) GetGraffitiData(%0, G_POS_Z)
#define SetGraffitiPosZ(%0,%1) SetGraffitiData(%0, G_POS_Z, %1)

#define GetGraffitiPosRX(%0) GetGraffitiData(%0, G_POS_RX)
#define SetGraffitiPosRX(%0,%1) SetGraffitiData(%0, G_POS_RX, %1)

#define GetGraffitiPosRY(%0) GetGraffitiData(%0, G_POS_RY)
#define SetGraffitiPosRY(%0,%1) SetGraffitiData(%0, G_POS_RY, %1)

#define GetGraffitiPosRZ(%0) GetGraffitiData(%0, G_POS_RZ)
#define SetGraffitiPosRZ(%0,%1) SetGraffitiData(%0, G_POS_RZ, %1)

#define GetGraffitiObjID(%0) GetGraffitiData(%0, G_OBJ_ID)
#define SetGraffitiObjID(%0,%1) SetGraffitiData(%0, G_OBJ_ID, %1)

#define GetGraffitiArea(%0) GetGraffitiData(%0, G_AREA)
#define SetGraffitiArea(%0,%1) SetGraffitiData(%0, G_AREA, %1)

#define GetGraffitiLabel(%0) GetGraffitiData(%0, G_LABEL)
#define SetGraffitiLabel(%0,%1) SetGraffitiData(%0, G_LABEL, %1)

#define GetGraffitiGangID(%0) GetGraffitiData(%0, G_GANG_ID)
#define SetGraffitiGangID(%0,%1) SetGraffitiData(%0, G_GANG_ID, %1)

#define GetGraffitiCooldown(%0) GetGraffitiData(%0, G_COOLDOWN)
#define SetGraffitiCooldown(%0,%1) SetGraffitiData(%0, G_COOLDOWN, %1)
#define DecrementGraffitiCooldown(%0) g_graffiti[%0][G_COOLDOWN] --

#define GetGraffitiLastAuthorID(%0) GetGraffitiData(%0, G_LAST_AUTHOR_ID)
#define SetGraffitiLastAuthorID(%0,%1) SetGraffitiData(%0, G_LAST_AUTHOR_ID, %1)

enum E_GRAFFITI_STRUCT
{
    G_OBJ_MODEL_ID,
    Float: G_POS_X,
    Float: G_POS_Y,
    Float: G_POS_Z,
    Float: G_POS_RX,
    Float: G_POS_RY,
    Float: G_POS_RZ,
    G_OBJ_ID,
    G_AREA,
    Text3D: G_LABEL,
    G_GANG_ID,
    G_COOLDOWN,
    G_LAST_AUTHOR_ID
}

new g_graffiti[MAX_GRAFFITI][E_GRAFFITI_STRUCT];

new Iterator: Graffiti<MAX_GRAFFITI>;