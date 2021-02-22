stock ShowPlayerDonateDialog(playerid, type = DONATE_SHOW_TYPE_MAIN)
{
    switch(type)
    {
        case DONATE_SHOW_TYPE_MAIN:
        {         
            new 
                donate_elements_name[][] = {"КУПИТЬ АДМИНКУ\n", "КУПИТЬ ЛИДЕРКУ\n", "КУПИТЬ ДОНАТ-АВТО"};   

            new fmt_str[(((sizeof donate_elements_name) * 18) + 1)];

            for(new idx; idx < sizeof donate_elements_name; idx ++)
                strcat(fmt_str, donate_elements_name[idx]);

            ShowPlayerDialog
            (
                playerid, DIALOG_DONATE_MAIN, DIALOG_STYLE_LIST,
                "Донат",
                fmt_str,
                "Выбрать", "Назад"
            );
        }

        case DONATE_SHOW_TYPE_BUY_ADMIN: 
        {
            if(IsPlayerReachedMaxAdminLvl(playerid))
                return SendClientMessage(playerid, -1, "Ты итак уже общеразвитый!");

            if(!IsPlayerAdminEx(playerid))
            {
                new fmt_str[] = "%d уровень\n",
                    result_str[(((sizeof fmt_str)) + ((- 2 + MAX_ADMIN_LVL_LEN)) + 1)],
                    result_dest[(((sizeof result_str) * MAX_ADMIN_LVL) + 1)];

                for(new idx; idx < MAX_ADMIN_LVL; idx ++)
                {
                    format(result_str, sizeof result_str, fmt_str, idx + 1);
                    strcat(result_dest, result_str);

                    SetPlayerListitemValue(playerid, idx, idx + 1);
                }
            
                ShowPlayerDialog
                (
                    playerid, DIALOG_DONATE_BUY_ADMIN, DIALOG_STYLE_LIST,
                    "Покупка админки", 
                    result_dest,
                    "Купить", "Назад"
                );
            }

            else
            {
                new 
                    idx_admin[][] = 
                {
                    {1, 9, 2},
                    {2, 8, 3},
                    {3, 7, 4},
                    {4, 6, 5},
                    {5, 5, 6},
                    {6, 4, 7},
                    {7, 3, 8},
                    {8, 2, 9},
                    {9, 1, 10}
                };

                new fmt_str[] = "%d уровень\n",
                    result_str[(((sizeof fmt_str)) + ((- 2 + MAX_ADMIN_LVL_LEN)) + 1)],
                    result_dest[(((sizeof result_str) * (MAX_ADMIN_LVL - 1)) + 1)],
                    player_admin_lvl = GetPlayerAdminLvl(playerid);

                for(new idx; idx < sizeof idx_admin; idx ++)
                {
                    if(idx_admin[idx][0] != player_admin_lvl)
                        continue;

                    for(new j; j < idx_admin[idx][1]; j ++)
                    {
                        format(result_str, sizeof result_str, fmt_str, j + idx_admin[idx][2]);
                        strcat(result_dest, result_str);

                        SetPlayerListitemValue(playerid, j, j + idx_admin[idx][2]);
                    }
                }

                ShowPlayerDialog
                (
                    playerid, DIALOG_DONATE_BUY_ADMIN, DIALOG_STYLE_LIST,
                    "Покупка админки",
                    result_dest,
                    "Купить", "Назад"
                );
            }
        }

        case DONATE_SHOW_TYPE_BUY_LEADER:
        {

        }

        case DONATE_SHOW_TYPE_BUY_DONAT_AUTO:
        {

        }
    }

    return 1;
}

stock GetPlayerCountOfDonate(playerid)
{
    new player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
    {
        "SELECT cd.c_count_of_donate FROM characters_donate cd INNER JOIN characters c \
        ON cd.c_id = c.c_id INNER JOIN users u \
        ON c.u_id = u.u_id \
        WHERE cd.c_id = %d \
        LIMIT 1"
    },
    result_str[((sizeof fmt_str) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, player_character_id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_count_of_donate = INVALID_COUNT_OF_DONATE;

    if(rows)
    {
        player_count_of_donate = cache_get_field_content_int(0, "c_count_of_donate");
        cache_delete(query_result);
    }

    return player_count_of_donate;
}

stock GetAdminLvlPrice(lvl)
{
    new admin_price = INVALID_ADMIN_PRICE,
        admin_prices[][] = 
    {
        {ADMIN_LVL_TYPE_MODERATOR, ADMIN_LVL_MODERATOR_PRICE},
        {ADMIN_LVL_TYPE_MODERATOR_SEC, ADMIN_LVL_MODERATOR_SEC_PRICE},
        {ADMIN_LVL_TYPE_MODERATOR_THREE, ADMIN_LVL_MODERATOR_THREE_PRICE},
        {ADMIN_LVL_TYPE_MODERATOR_FOURTH, ADMIN_LVL_MODERATOR_FOURTH_PRIC},
        {ADMIN_LVL_TYPE_MODERATOR_FIVE, ADMIN_LVL_MODERATOR_FIVE_PRICE},
        {ADMIN_LVL_TYPE_MODERATOR_SIXTH, ADMIN_LVL_MODERATOR_SIXTH_PRICE},
        {ADMIN_LVL_TYPE_MODERATOR_SEVEN, ADMIN_LVL_MODERATOR_SEVEN_PRICE},
        {ADMIN_LVL_TYPE_GRANDMODERATOR, ADMIN_LVL_GRANDMODERATOR_PRICE},
        {ADMIN_LVL_TYPE_DEPUTY, ADMIN_LVL_DEPUTY_PRICE},
        {ADMIN_LVL_TYPE_FOUNDER, ADMIN_LVL_FOUNDER_PRICE}
    };

    for(new idx; idx < sizeof admin_prices; idx ++)
    {
        if(admin_prices[idx][0] != lvl)
            continue;

        admin_price = admin_prices[idx][1];
    }

    return admin_price;
}

stock SubPlayerDonate(playerid, count = INVALID_COUNT_OF_DONATE)
{
    new player_character_id = GetPlayerCharacterID(playerid),
        fmt_str[] = 
    {
        "UPDATE characters_donate cd INNER JOIN characters c \
        ON cd.c_id = c.c_id INNER JOIN users u \
        ON c.u_id = u.u_id \
        SET cd.c_count_of_donate = cd.c_count_of_donate - %d \
        WHERE cd.c_id = %d"
    },
    result_str[((sizeof fmt_str) + ((- 2 + MAX_COUNT_OF_DONATE_LEN) + (- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, count, player_character_id);
    mysql_query(mysql_handle, result_str, false);

    return !mysql_errno();
}

stock BuyAdmin(playerid, lvl = ADMIN_LVL_TYPE_MODERATOR)
{
    new player_count_of_donate = GetPlayerCountOfDonate(playerid),
        admin_lvl_price = GetAdminLvlPrice(lvl),
        fmt_str[] = "У Вас недостаточно доната, Вам не хватает %d",
        result_str[((sizeof fmt_str) + ((- 2 + MAX_COUNT_OF_DONATE_LEN)) + 1)];

    format(result_str, sizeof result_str, fmt_str, (admin_lvl_price - player_count_of_donate));

    if(player_count_of_donate < admin_lvl_price)
        return SendClientMessage(playerid, -1, result_str);

    SubPlayerDonate(playerid, admin_lvl_price);

    return GivePlayerAdmin(playerid, lvl, ADMIN_TYPE_PURCHASED);
}