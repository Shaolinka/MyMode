stock DonateOnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_DONATE_MAIN: return ShowPlayerDonateDialog(playerid, (listitem + 1));

        case DIALOG_DONATE_BUY_ADMIN:
        {
            switch(response)
            {
                case DIALOG_RESPONSE_TYPE_OK:
                {
                    new admin_lvl = GetPlayerListitemValue(playerid, listitem);
                    printf("%d", admin_lvl);

                    BuyAdmin(playerid, admin_lvl);
                }
            }
        }
    }

    return 1;
}