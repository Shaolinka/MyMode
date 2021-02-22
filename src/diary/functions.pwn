stock IsPlayerHasDiary(playerid)
{
    new fmt_str[] = "SELECT d.id FROM diaries d INNER JOIN diaries_records dr ON d.d_id = dr.d_id WHERE d.c_id = %d LIMIT 1";

    new result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, GetPlayerCharacterID(playerid));

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        bool: is_player_has_diary = false;

    if(rows) 
    {
        is_player_has_diary = true;
        cache_delete(query_result);
    }

    return is_player_has_diary;
}

stock GetPlayerDiaryID(playerid)
{
    new fmt_str[] = "SELECT d.d_id FROM diaries d INNER JOIN diaries_records dr ON d.d_id = dr.d_id WHERE d.c_id = %d LIMIT 1",
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, GetPlayerCharacterID(playerid));

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_diary_id = INVALID_DIARY_ID;
        
    if(rows)
    {
        player_diary_id = cache_get_field_content_int(0, "d_id");
        cache_delete(query_result);
    }

    return player_diary_id;
}

stock GetDiaryCountOfRecords(id)
{
    new fmt_str[] = "SELECT COUNT(*) FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.d_id = %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, id);
    
    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        player_diary_count_of_records = INVALID_DIARY_COUNT_OF_RECORDS;

    if(rows)
        player_diary_count_of_records = cache_get_row_int(0, 0), cache_delete(query_result);

    printf("vsego: %d", player_diary_count_of_records);

    return player_diary_count_of_records;
}

stock GetDiaryCountOfPages(id)
{
    new player_diary_count_of_records = GetDiaryCountOfRecords(id),
        player_diary_count_of_pages = (player_diary_count_of_records / MAX_RECORDS_ON_PAGE);

    return player_diary_count_of_pages;
}

stock IsRecordExistInDiary(playerid, id)
{
    new fmt_str[] = "SELECT dr.id FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.r_id = %d AND dr.d_id = %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)],
        player_diary_id = GetPlayerDiaryID(playerid);

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, id, player_diary_id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows();

    if(rows)
        return 1, cache_delete(query_result);

    else return 0xFFFF, cache_delete(query_result);
}

stock ChangeRecordContentInDiary(playerid, id, const new_content[])
{
    new fmt_str[] = "UPDATE diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id SET dr.r_desc = '%e' WHERE dr.r_id = %d AND dr.d_id = %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + (MAX_RECORD_DESCRIPTION_LEN + 1)) + (- 2 + MAX_RECORDS_LEN) + (- 2 + 11)) + 1)],
        player_diary_id = GetPlayerDiaryID(playerid);

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, new_content, id, player_diary_id);
    mysql_query(mysql_handle, result_str, false);

    return 1;
}

// ShowPlayerDiaryRecordsFromNextPageDialog
stock ShowPlayerDiaryRecordsFromNextP(playerid, last_index)
{
    new fmt_str[] = "SELECT * FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.r_id > %d LIMIT %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + MAX_RECORDS_LEN) + (- 2 + MAX_RECORDS_ON_PAGE_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, last_index, MAX_RECORDS_ON_PAGE);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        fmt_str_prototype[] = "%s\n",
        result_str_prototype[(((sizeof fmt_str_prototype)) + ((- 2 + 11)) + 1)],
        result_dest[((((sizeof result_str_prototype)) * MAX_RECORDS_ON_PAGE) + 1)],
        // player_diary_current_count_of_records
        player_diary_current_count_of_r = INVALID_DIARY_COUNT_OF_RECORDS;

    if(rows)
    {
        for(new idx; idx < rows; idx ++)
        {
            new records_date_of_creation[((10 * MAX_RECORDS_ON_PAGE) + 1)];

            cache_get_field_content(idx, "r_date_of_creation", records_date_of_creation, mysql_handle, sizeof records_date_of_creation);

            format
            (
                result_str_prototype, sizeof result_str_prototype, 
                fmt_str_prototype,
                records_date_of_creation
            );
            strcat(result_dest, result_str_prototype);

            printf("%d, %d", rows, idx);

            player_diary_current_count_of_r = rows;

            SetPlayerListitemValue(playerid, idx, cache_get_field_content_int(idx, "r_id"));
        }

        IncrementPlayerCurrentPageInDiary(playerid);

        new player_diary_id = GetPlayerDiaryID(playerid),
            player_diary_count_of_records = GetDiaryCountOfRecords(player_diary_id);

        if(player_diary_current_count_of_r > (MAX_RECORDS_ON_PAGE - 1))
            strcat(result_dest, ">>");

        new player_page_in_diary = GetPlayerCurrentPageInDiary(playerid);

        if(player_page_in_diary > MIN_PAGE)
            strcat(result_dest, "\n<<");

        new fmt_str_first_prototype[] = "Количество записей: %d, всего страниц: %d",
            result_str_first_prototype[(((sizeof fmt_str_first_prototype)) + ((- 2 + MAX_RECORDS_LEN) + (- 2 + MAX_PAGES_LEN)) + 1)],
            player_diary_count_of_pages = GetDiaryCountOfPages(player_diary_id);

        format(result_str_first_prototype, sizeof result_str_first_prototype, fmt_str_first_prototype, player_diary_count_of_records, player_diary_count_of_pages);

        ShowPlayerDialog
        (
            playerid, DIALOG_DIARY_CONTROL_OF_RECORDS, DIALOG_STYLE_LIST,
            result_str_first_prototype, 
            result_dest,
            "Выбрать", "Назад"
        );
    }

    cache_delete(query_result);
    
    return 1;
} 

// ShowPlayerDiaryRecordsFromPreviousPageDialog
stock ShowPlayerDiaryRecordsFromPrevP(playerid, first_index)
{
    new fmt_str[] = "SELECT * FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.r_id < %d LIMIT %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + MAX_RECORDS_LEN) + (- 2 + MAX_RECORDS_ON_PAGE_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, first_index, MAX_RECORDS_ON_PAGE);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows(),
        fmt_str_prototype[] = "%s\n",
        result_str_prototype[(((sizeof fmt_str_prototype)) + ((- 2 + 11)) + 1)],
        result_dest[((((sizeof result_str_prototype)) * MAX_RECORDS_ON_PAGE) + 1)],
        player_diary_current_count_of_r = INVALID_DIARY_COUNT_OF_RECORDS;

    if(rows)
    {
        for(new idx; idx < rows; idx ++)
        {
            new records_date_of_creation[((11 * MAX_RECORDS_ON_PAGE) + 1)];

            cache_get_field_content(idx, "r_date_of_creation", records_date_of_creation, mysql_handle, sizeof records_date_of_creation);

            format(result_str_prototype, sizeof result_str_prototype, fmt_str_prototype, records_date_of_creation);
            strcat(result_dest, result_str_prototype);

            player_diary_current_count_of_r = rows;

            SetPlayerListitemValue(playerid, idx, cache_get_field_content_int(idx, "r_id"));
        }

        // DecrementPlayerCurrentPageInDiary        
        DecrementPlayerCurrentPageInDia(playerid);

        new player_diary_id = GetPlayerDiaryID(playerid),
            player_diary_count_of_records = GetDiaryCountOfRecords(player_diary_id);

        if(player_diary_current_count_of_r > (MAX_RECORDS_ON_PAGE - 1))
            strcat(result_dest, ">>");

        new player_page_in_diary = GetPlayerCurrentPageInDiary(playerid);

        if(player_page_in_diary > MIN_PAGE)
            strcat(result_dest, "\n<<");

        new fmt_str_first_prototype[] = "Количество записей: %d, всего страниц: %d",
            result_str_first_prototype[(((sizeof fmt_str_first_prototype)) + ((- 2 + MAX_RECORDS_LEN) + (- 2 + MAX_PAGES_LEN)) + 1)],
            player_diary_count_of_pages = GetDiaryCountOfPages(player_diary_id);

        format(result_str_first_prototype, sizeof result_str_first_prototype, fmt_str_first_prototype, player_diary_count_of_records, player_diary_count_of_pages);

        ShowPlayerDialog
        (
            playerid, DIALOG_DIARY_CONTROL_OF_RECORDS, DIALOG_STYLE_LIST,
            result_str_first_prototype, 
            result_dest,
            "Выбрать", "Назад"
        );
    }

    cache_delete(query_result);
    
    return 1;
}

// ShowPlayerInformationAboutRecordDialog
stock ShowPlayerInformationAboutRecor(playerid, id)
{
    new fmt_str[] = "SELECT * FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.r_id = %d",
        result_str[(((sizeof fmt_str)) + ((- 2 + MAX_RECORDS_LEN)) + 1)];

    mysql_format(mysql_handle, result_str, sizeof result_str, fmt_str, id);

    new Cache: query_result = mysql_query(mysql_handle, result_str),
        rows = cache_num_rows();

    if(rows)
    {
        new fmt_str_prototype[] = "Информация о записи: %d",
            result_str_prototype[(((sizeof fmt_str_prototype)) + ((- 2 + MAX_RECORDS_LEN)) + 1)];

        format(result_str_prototype, sizeof result_str_prototype, fmt_str_prototype, id);

        new record_date_of_creation[10 + 1],
            record_description[MAX_RECORD_DESCRIPTION_LEN + 1];

        cache_get_field_content(0, "r_date_of_creation", record_date_of_creation, mysql_handle, sizeof record_date_of_creation); 
        cache_get_field_content(0, "r_desc", record_description, mysql_handle, sizeof record_description); 

        new fmt_str_first_prototype[] = "Дата создания: %s\t\tОписание: «%s»",
            result_str_first_prototype[(((sizeof fmt_str_first_prototype)) + ((- 2 + 11) + (- 2 + (MAX_RECORD_DESCRIPTION_LEN + 1))) + 1)];

        format
        (
            result_str_first_prototype, sizeof result_str_first_prototype, 
            fmt_str_first_prototype, 
            record_date_of_creation, 
            record_description
        );

        ShowPlayerDialog
        (
            playerid, DIALOG_INFORMATION_ABOUT_RECORD, DIALOG_STYLE_MSGBOX,
            result_str_prototype,
            result_str_first_prototype,
            "Назад", "Закрыть"
        );
    }

    cache_delete(query_result);

    return 1;
}

stock ShowPlayerDiaryDialog(playerid, type = DIARY_SHOW_TYPE_MAIN)
{
    new player_diary_id = GetPlayerDiaryID(playerid);

    switch(type)
    {
        case DIARY_SHOW_TYPE_MAIN:
        {
            new fmt_str[] = "Ваш дневник, d_id(%d)",
                result_str[(((sizeof fmt_str)) + ((- 2 + 11)) + 1)];

            format(result_str, sizeof result_str, fmt_str, player_diary_id);

            ShowPlayerDialog
            (
                playerid, DIALOG_DIARY_MAIN, DIALOG_STYLE_LIST, 
                result_str, 
                "1. Управление записями\n"\
                "2. Кол-во записей", 
                "Выбрать", "Закрыть"
            );
        }

        case DIARY_SHOW_TYPE_CONTROL_OF_RECO:
        {
            new fmt_str[] = "Количество записей: %d, всего страниц: %d",
                result_str[(((sizeof fmt_str)) + ((- 2 + MAX_RECORDS_LEN) + (- 2 + MAX_PAGES_LEN)) + 1)],
                player_diary_count_of_records = GetDiaryCountOfRecords(player_diary_id);

            format
            (
                result_str, sizeof result_str, 
                fmt_str,
                player_diary_count_of_records, 
                GetDiaryCountOfPages(player_diary_id)
            );

            new fmt_str_prototype[] = "SELECT * FROM diaries_records dr INNER JOIN diaries d ON dr.d_id = d.d_id WHERE dr.d_id = %d LIMIT %d",
                result_str_prototype[(((sizeof fmt_str_prototype)) + ((- 2 + 11) + (- 2 + MAX_RECORDS_ON_PAGE_LEN)) + 1)];

            mysql_format(mysql_handle, result_str_prototype, sizeof result_str_prototype, fmt_str_prototype, player_diary_id, MAX_RECORDS_ON_PAGE);

            new Cache: query_result = mysql_query(mysql_handle, result_str_prototype),
                rows = cache_num_rows(),
                fmt_str_first_prototype[] = "%s\n",
                result_str_first_prototype[(((sizeof fmt_str_first_prototype)) + ((- 2 + 11)) + 1)],
                result_dest[(((sizeof result_str_first_prototype) * MAX_RECORDS_ON_PAGE) + 1)];

            if(!rows) 
                return print("something didn't great");

            if(rows)
            {
                for(new idx; idx < rows; idx ++)
                {
                    /* if(!idx) 
                        return print("something didn't great x2"); */

                    new records_date_of_creation[((10 * MAX_RECORDS_ON_PAGE) + 1)];

                    cache_get_field_content(idx, "r_date_of_creation", records_date_of_creation, mysql_handle, sizeof records_date_of_creation);

                    format
                    (
                        result_str_first_prototype, sizeof result_str_first_prototype, 
                        fmt_str_first_prototype,
                        records_date_of_creation
                    );
                    strcat(result_dest, result_str_first_prototype);

                    printf("%d, %d", rows, idx);

                    SetPlayerListitemValue(playerid, idx, cache_get_field_content_int(idx, "r_id"));
                }

                SetPlayerCurrentPageInDiary(playerid, MIN_PAGE);
                
                printf("%d yopta", GetPlayerCurrentPageInDiary(playerid));

                if(player_diary_count_of_records > (MAX_RECORDS_ON_PAGE - 1))
                    strcat(result_dest, ">>");

                new player_page_in_diary = GetPlayerCurrentPageInDiary(playerid);

                if(player_page_in_diary > MIN_PAGE)
                    strcat(result_dest, "<<");

                ShowPlayerDialog
                (
                    playerid, DIALOG_DIARY_CONTROL_OF_RECORDS, DIALOG_STYLE_LIST,
                    result_str, 
                    result_dest,
                    "Выбрать", "Назад"
                );
            }
            cache_delete(query_result);
        }
    }

    return 1;
}