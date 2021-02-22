cmd:diary(playerid) 
{
    if(!IsPlayerHasDiary(playerid))
        return SendClientMessage(playerid, 0xFFFF, "У Вас нет дневника, купить его можно в ближайшем 24/7");
        
    return ShowPlayerDiaryDialog(playerid);
}

cmd:crecordrewrite(playerid, const params[])
{
    if(!IsPlayerHasDiary(playerid))
        return SendClientMessage(playerid, 0xFFFF, "У Вас нет дневника, купить его можно в ближайшем 24/7");

    if(!strlen(params)) 
        return SendClientMessage(playerid, 0xFFFF, "Input: /crecord [record id] [new content]");

    extract params -> new record_id, string: new_content[144 + 1];

    if(!IsRecordExistInDiary(playerid, record_id))
        return SendClientMessage(playerid, 0xFFFF, "Введенная запись отсутствует в Вашем дневнике");

    new new_content_len = strlen(new_content);

    if(!(6 <= new_content_len <= MAX_RECORD_DESCRIPTION_LEN))
        return SendClientMessage(playerid, 0xFFFF, "Длина нового содержимого не соответствует нормам");

    return ChangeRecordContentInDiary(playerid, record_id, new_content);
}