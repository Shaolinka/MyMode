// ShowPlayerBlackMarketProductsDialog
stock ShowPlayerBlackMarketProductsDi(playerid)
{
    new fmt_str[] = "- %s\n",
        result_str[((sizeof fmt_str) + ((- 2 + 10)) + 1)],
        result_dest[(((sizeof result_str) * 10) + 1)];

    for(new j; j < sizeof g_black_market_products_name; j ++)
    {
        format(result_str, sizeof result_str, fmt_str, g_black_market_products_name[j]);
        strcat(result_dest, result_str);
    }

    return ShowPlayerDialog
            (
                playerid, DIALOG_BLACK_MARKET_PRODUCTS, DIALOG_STYLE_LIST, 
                "Чёрный рынок", 
                result_dest, 
                "Далее", "Отмена"
            );
}

// ShowPlayerBuyBlackMarketProductDialog
stock ShowPlayerBuyBlackMarketProduct(playerid, type = BLACK_MARKET_PRODUCT_TYPE_NULL)
{
    if(type != BLACK_MARKET_PRODUCT_TYPE_NULL)
    {
        // E_BLACK_MARKET_PRODUCTS_DIALOG_STRUCT
        enum E_BLACK_MARKET_PRODUCTS_DIALOG
        {
            BMPD_DIALOG_ID,
            BMPD_DIALOG_TYPE,
            BMPD_CAPTION[34 + 1],
            BMPD_CONTENT[58 + 1],
            BMPD_BUTTON_OK_CONTENT[6 + 1],
            BMPD_BUTTON_NOT_CONTENT[6 + 1]
        }

        new 
            g_black_market_products_dialog[][E_BLACK_MARKET_PRODUCTS_DIALOG] =
        {
            {
                DIALOG_BUY_BLACK_MARKET_WEAPON,
                DIALOG_STYLE_MSGBOX,
                "Покупка оружия на чёрном рынке", 
                "Введите ид и количество патронов",
                "Купить", "Отмена"
            },
            {
                DIALOG_BUY_BLACK_MARKET_DRUGS,
                DIALOG_STYLE_MSGBOX,
                "Покупка наркотиков на чёрном рынке",
                "Введите количество грамм",
                "Купить", "Отмена"
            },
            {
                DIALOG_BUY_BLACK_MARKET_KEYS,
                DIALOG_STYLE_MSGBOX,
                "Покупка ключей на чёрном рынке",
                "Введите номер ключа, который хотите купить. 0 - ВЧ, 1 - ВС",
                "Купить", "Отмена"
            }
        };

        for(new j; j < sizeof g_black_market_products_dialog; j ++)
        {
            if(j != (type - 1))
                continue;

            new black_market_products_dialog_id = g_black_market_products_dialog[j][BMPD_DIALOG_ID],
                // black_market_products_dialog_type
                black_market_products_dialog_ty = g_black_market_products_dialog[j][BMPD_DIALOG_TYPE],
                black_market_products_caption[34 + 1],
                black_market_products_content[58 + 1],
                // black_market_products_button_ok_content
                black_market_products_button_ok[6 + 1],
                // black_market_products_button_not_content
                black_market_products_button_no[6 + 1];

            format
            (
                black_market_products_caption, sizeof black_market_products_caption, 
                "%s",
                g_black_market_products_dialog[j][BMPD_CAPTION]
            );

            format
            (
                black_market_products_content, sizeof black_market_products_content, 
                "%s",
                g_black_market_products_dialog[j][BMPD_CONTENT]
            );

            format
            (
                black_market_products_button_ok, sizeof black_market_products_button_ok,
                "%s",
                g_black_market_products_dialog[j][BMPD_BUTTON_OK_CONTENT]
            );

            format
            (
                black_market_products_button_no, sizeof black_market_products_button_no, 
                "%s", 
                g_black_market_products_dialog[j][BMPD_BUTTON_NOT_CONTENT]
            );
            
            ShowPlayerDialog
            (
                playerid, black_market_products_dialog_id, black_market_products_dialog_ty,
                black_market_products_caption, 
                black_market_products_content,
                black_market_products_button_ok, black_market_products_button_no
            );
        }
    }

    return 1;
}