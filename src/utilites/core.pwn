stock 
    ConvertTime(
        time = -1, type = CONVERT_TYPE_IN_HOUR_AND_MINUTE, &hour = - 1, &minute = -1, &second = -1)
{
    if(time != -1)
    {
        new 
            convert_types_actions[][] = 
        {
            {CONVERT_TYPE_IN_HOUR_AND_MINUTE, 3600, 60, 0},
            {CONVERT_TYPE_IN_MINUTE_AND_SECO, 0, 60, 60}
        };

        for(new j; j < sizeof convert_types_actions; j ++)
        {
            if(convert_types_actions[j][0] != type)
                continue;

            if(hour != -1)
                hour = (time / convert_types_actions[j][1]);

            if(minute != -1)
                minute = (time / convert_types_actions[j][2]);

            if(second != -1)
                second = (time % convert_types_actions[j][3]);
        }
    }
}