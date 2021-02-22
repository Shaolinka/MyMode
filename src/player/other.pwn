#define INVALID_USER_ID (INVALID_PLAYER_ID)
#define INVALID_CHARACTER_ID (INVALID_USER_ID)

#define GetPlayerData(%0,%1) g_player[%0][%1]
#define SetPlayerData(%0,%1,%2) g_player[%0][%1] = %2

#define GetPlayerNameEx(%0) GetPlayerData(%0, P_NAME)

#define GetPlayerCurrentPageInDiary(%0) GetPlayerData(%0, P_CURRENT_PAGE_IN_DIARY)
#define SetPlayerCurrentPageInDiary(%0,%1) SetPlayerData(%0, P_CURRENT_PAGE_IN_DIARY, %1)
#define IncrementPlayerCurrentPageInDiary(%0) g_player[%0][P_CURRENT_PAGE_IN_DIARY] ++
// DecrementPlayerCurrentPageInDiary
#define DecrementPlayerCurrentPageInDia(%0) g_player[%0][P_CURRENT_PAGE_IN_DIARY] --

#define GetPlayerListitemValue(%0,%1) g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) g_player_listitem[%0][%1] = %2

#define SetPlayerTimer(%0,%1,%2) g_player_timer[%0][%1] = %2

#define GetPlayerPaintingSec(%0) GetPlayerData(%0, P_PAINTING_SEC)
#define IncrementPlayerPaintingSec(%0) g_player[%0][P_PAINTING_SEC] ++

#define GetPlayerTeamEx(%0) GetPlayerData(%0, P_TEAM)
#define SetPlayerTeamEx(%0,%1) SetPlayerData(%0, P_TEAM, %1)

#define GetPlayerAntiFloodTick(%0) GetPlayerData(%0, P_ANTI_FLOOD_TICK)

enum
    E_PLAYER_STRUCT
{
    P_NAME[MAX_PLAYER_NAME],
    P_CURRENT_PAGE_IN_DIARY,
    P_PAINTING_SEC,
    P_TEAM,
    P_ANTI_FLOOD_TICK
}

new g_player[MAX_PLAYERS][E_PLAYER_STRUCT];

new g_player_listitem[MAX_PLAYERS][MAX_ADMIN_LVL];

new g_player_timer[MAX_PLAYERS][MAX_TIMERS];