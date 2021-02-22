cmd:diary(playerid) 
{
    if(!IsPlayerHasDiary(playerid))
        return SendClientMessage(playerid, 0xFFFF, "� ��� ��� ��������, ������ ��� ����� � ��������� 24/7");
        
    return ShowPlayerDiaryDialog(playerid);
}

cmd:crecordrewrite(playerid, const params[])
{
    if(!IsPlayerHasDiary(playerid))
        return SendClientMessage(playerid, 0xFFFF, "� ��� ��� ��������, ������ ��� ����� � ��������� 24/7");

    if(!strlen(params)) 
        return SendClientMessage(playerid, 0xFFFF, "Input: /crecord [record id] [new content]");

    extract params -> new record_id, string: new_content[144 + 1];

    if(!IsRecordExistInDiary(playerid, record_id))
        return SendClientMessage(playerid, 0xFFFF, "��������� ������ ����������� � ����� ��������");

    new new_content_len = strlen(new_content);

    if(!(6 <= new_content_len <= MAX_RECORD_DESCRIPTION_LEN))
        return SendClientMessage(playerid, 0xFFFF, "����� ������ ����������� �� ������������� ������");

    return ChangeRecordContentInDiary(playerid, record_id, new_content);
}