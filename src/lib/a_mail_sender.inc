#define MAX_MAIL_NAME_LEN (64)
#define MAX_THEME_NAME_LEN (200)
#define MAX_MESSAGE_LEN (70)

stock SendMail(playerid, const mail[], const theme[], const message[])
{
    new fmt_str[] = 
    {
        "pizdasakura.000webhostapp.com/CMailSender.php/?mail=%s&theme=%s&message=%s"
    },
    result_str[((sizeof fmt_str) + ((- 2 + MAX_MAIL_NAME_LEN) + (- 2 + MAX_THEME_NAME_LEN) + (- 2 + MAX_MESSAGE_LEN)) + 1)];
    
    format(result_str, sizeof result_str, fmt_str, mail, theme, message);

    return HTTP(playerid, HTTP_GET, result_str, "", "@__SendMailHttpResponse");
}

@__SendMailHttpResponse(index, response_code, const data[]);
@__SendMailHttpResponse(index, response_code, const data[])
{
    if(response_code == 200)
    {
        new result_str[300];

        format(result_str, sizeof result_str, "%s", data);
        SendClientMessage(index, -1, result_str);
    }

    else
    {
        new result_str[15];

        format(result_str, sizeof result_str, "code: %d", response_code);
        SendClientMessage(index, -1, result_str);
    }
}