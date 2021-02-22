new mysql_handle;

stock MysqlOnGameModeInit()
{
    mysql_handle = mysql_connect("127.0.0.1", "root", "ayebasota", "");

    mysql_set_charset("cp1251");

    return 1;
}

stock MysqlOnGameModeExit()
{
    return mysql_close(mysql_handle);
}
