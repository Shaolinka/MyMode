#include <..\src\lib\a_samp>
#include <..\src\lib\a_http>
#include <..\src\lib\a_mysql>
#include <..\src\lib\foreach>
#include <..\src\lib\Pawn.CMD>
#include <..\src\lib\Pawn.Regex>
#include <..\src\lib\Pawn.RakNet>
#include <..\src\lib\sscanf2>
#include <..\src\lib\crashdetect>
#include <..\src\lib\streamer>
#include <..\src\lib\mxdate>
#include "..\src\lib\a_mail_sender"
#include "..\src\lib\a_vvar"

/* Utilites */
#include "..\src\utilites\structure.pwn"
#include "..\src\utilites\core.pwn"

/* Dialog */ 
#include "..\src\dialog\structures.pwn"

/* Mysql */
#include "..\src\mysql\core.pwn"

/* Ownable Car */
#include "..\src\ownable_car\structure.pwn"
#include "..\src\ownable_car\array.pwn"
#include "..\src\ownable_car\directives.pwn"
#include "..\src\ownable_car\iterator.pwn"
#include "..\src\ownable_car\functions.pwn"
#include "..\src\ownable_car\core.pwn"

/* Trailer */
#include "..\src\trailer\structure.pwn"
#include "..\src\trailer\directives.pwn"
#include "..\src\trailer\array.pwn"
#include "..\src\trailer\iterator.pwn"
#include "..\src\trailer\functions.pwn"
#include "..\src\trailer\core.pwn"

/* Hook */
#include "..\src\hook\functions.pwn"

/*  Player, но модуль относится к папке «diary», было принято решение добавить его в блок кода, 
    относящийся к модулям папки «player», во избежании ошибки 017(неизвестный символ: MAX_RECORDS_ON_PAGE)
    Вариант фикса, если Вы любитель порядка:
    Проверить наличие директивы «MAX_RECORDS_ON_PAGE»
*/
#include "..\src\diary\directives.pwn"
/*  Player, но модуль относится к папке «admin», было принято решение добавить его в блок кода, 
    относящийся к модулям папки «player», во избежании ошибки 017(неизвестный символ: MAX_ADMIN_LVL)
    Вариант фикса, если Вы любитель порядка:
    Проверить наличие директивы «MAX_ADMIN_LVL»
*/
#include "..\src\admin\directives.pwn"
/*  Player, но модуль относится к папке timer, было принято решение добавить его в блок кода, 
    относящийся к модулям папки «timer», во избежании ошибки 017(неизвестный символ: MAX_TIMERS)
    Вариант фикса, если Вы любитель порядка:
    Проверить наличие директивы «MAX_TIMERS»
*/
#include "..\src\timer\directives.pwn"
#include "..\src\player\other.pwn"
#include "..\src\player\functions.pwn"
#include "..\src\player\core.pwn"
#include "..\src\player\commands.pwn"

/* Graffiti */
#include "..\src\graffiti\other.pwn"
#include "..\src\graffiti\functions.pwn"
#include "..\src\graffiti\core.pwn"

/* Timer */
#include "..\src\timer\structure.pwn"
#include "..\src\timer\functions.pwn"
#include "..\src\timer\core.pwn"

/* Diary */
#include "..\src\diary\structure.pwn"
#include "..\src\diary\functions.pwn"
#include "..\src\diary\commands.pwn"
#include "..\src\diary\core.pwn"

/* Counter */
#include "..\src\counter\directives.pwn"
#include "..\src\counter\structure.pwn"
#include "..\src\counter\core.pwn"
#include "..\src\counter\commands.pwn"
#include "..\src\counter\functions.pwn"

/* Admin */
#include "..\src\admin\structures.pwn"
#include "..\src\admin\functions.pwn"

/* Donate */
#include "..\src\donate\structures.pwn"
#include "..\src\donate\directives.pwn"
#include "..\src\donate\functions.pwn"
#include "..\src\donate\core.pwn"
#include "..\src\donate\commands.pwn"

/* Black Market */
#include "..\src\black_market\array.pwn"
#include "..\src\black_market\directive.pwn"
#include "..\src\black_market\functions.pwn"

/* Object */
#include "..\src\object\functions.pwn"
#include "..\src\object\core.pwn"

/* 3D text */
#include "..\src\3D text\functions.pwn"
#include "..\src\3D text\core.pwn"
main(){}

public OnGameModeInit()
{
    MysqlOnGameModeInit();
    CounterOnGameModeInit();
    OwnableCarOnGameModeInit();
    TrailerOnGameModeInit();
    GraffitiOnGameModeInit();
    ObjectOnGameModeInit();
    _3DTextOnGameModeInit();

    return 1;
}

public OnGameModeExit()
{
    MysqlOnGameModeExit();
    
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerOnPlayerConnect(playerid);
    DiaryOnPlayerConnect(playerid);
    TimerOnPlayerConnect(playerid);

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    DiaryOnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    DonateOnDialogResponse(playerid, dialogid, response, listitem, inputtext);

    return 1;
}

cmd:karplox(playerid) return ShowPlayerBuyBlackMarketProduct(playerid, 1);

cmd:sppos(playerid) return SetPlayerPos(playerid, -2170.26514, -281.43811, 39.00430 + 10.0);

cmd:gv(playerid) return GivePlayerWeapon(playerid, WEAPON_SPRAYCAN, 500);

cmd:spteam(playerid) return SetPlayerTeamEx(playerid, 1);

cmd:spteam1(playerid) return SetPlayerTeamEx(playerid, 0);

cmd:sgcd(playerid) return SetGraffitiCooldown(0, 0);

cmd:blyatporn(playerid) return SetVVarFloat(GetPlayerVehicleID(playerid), "veh_health", 1000.00);

cmd:blyatporn1(playerid) return printf("%f", GetVVarFloat(GetPlayerVehicleID(playerid), "veh_health"));