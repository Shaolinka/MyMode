stock PlayerOnPlayerConnect(playerid)
{
    GetPlayerName(playerid, g_player[playerid][P_NAME], MAX_PLAYER_NAME);

    if(IsPlayerExistInDatabase(playerid))
        return SendClientMessage(playerid, 0xFFFF, "��� ������� ��������");

    return 1;
}