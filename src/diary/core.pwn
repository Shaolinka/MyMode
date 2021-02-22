stock DiaryOnPlayerConnect(playerid)
{
    if(IsPlayerHasDiary(playerid))
        return SendClientMessage(playerid, 0xFFFF, "У Вас есть дневник, подробнее: /diary");

    return 1;
}

stock DiaryOnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_DIARY_MAIN:
        {
            if(response)
                return ShowPlayerDiaryDialog(playerid, listitem + 1);
        }

        case DIALOG_DIARY_CONTROL_OF_RECORDS:
        {
            if(response)
            {
                if(0 <= listitem <= (MAX_RECORDS_ON_PAGE - 1))
                {
                    new record_id = GetPlayerListitemValue(playerid, listitem);

                    return ShowPlayerInformationAboutRecor(playerid, record_id);
                }

                else
                {
                    new diary_page_symbols[][] = {">>", "<<"};

                    for(new idx; idx < sizeof diary_page_symbols; idx ++)
                    {
                        if(strcmp(inputtext, diary_page_symbols[idx]))
                            continue;
                        
                        switch(idx)
                        {
                            case DIARY_CONTROL_TYPE_NEXT_PAGE:
                            {
                                new record_last_id = GetPlayerListitemValue(playerid, 4);

                                printf("%d sho naxui", record_last_id);
                                return ShowPlayerDiaryRecordsFromNextP(playerid, record_last_id);
                            }

                            case DIARY_CONTROL_TYPE_PREVIOUS_PAG:
                            {
                                new record_first_id = GetPlayerListitemValue(playerid, 0);

                                printf("%d mama shiva", record_first_id);
                                return ShowPlayerDiaryRecordsFromPrevP(playerid, record_first_id);
                            }
                        }
                    }
                }
            }
        }
    }

    return 1;
}