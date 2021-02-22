#if defined _vvar_included
	#endinput
#endif
#define _vvar_included 

#define INVALID_VVAR_ID (INVALID_PLAYER_ID)
#define INVALID_VVAR_VALUE (INVALID_VVAR_ID)
#define INVALID_VVAR_FLOAT_VALUE (0.0)
#define INVALID_COUNT_OF_VVARS (0)  

#if defined MAX_VEHICLES
#undef MAX_VEHICLES
#define MAX_VEHICLES 1999 char
#else 
#define MAX_VEHICLES 1999 char
#endif 

#if !defined MAX_PVARS
    #define MAX_PVARS (800 char)
#endif
#define MAX_VVARS (MAX_PVARS)
#define MAX_VVAR_VAR_NAME_LEN (40 + 1)
#define MAX_VVAR_STRING_VALUE_LEN (126 + 1)

#define GetVVarData(%0,%1,%2) g_vvar[%0 - 1][%1][%2]
#define SetVVarData(%0,%1,%2,%3) g_vvar[%0 - 1][%1][%2] = %3

#define GetVVarName(%0,%1,%2) format(%2, MAX_VVAR_VAR_NAME_LEN, "%s", GetVVarData(%0, %1, VV_VAR_NAME))
#define SetVVarVarName(%0,%1,%2) format(g_vvar[%0 - 1][%1][VV_VAR_NAME], MAX_VVAR_VAR_NAME_LEN, "%s", %2)

#define GetVVarValue(%0,%1) GetVVarData(%0, %1, VV_VALUE)
#define SetVVarValue(%0,%1,%2) SetVVarData(%0, %1, VV_VALUE, %2)

#define GetVVarStringValue(%0,%1,%2) \
    format(%2, MAX_VVAR_STRING_VALUE_LEN, "%s", GetVVarData(%0, %1, VV_STRING_VALUE))
#define SetVVarStringValue(%0,%1,%2) \
    format(g_vvar[%0 - 1][%1][VV_STRING_VALUE], MAX_VVAR_STRING_VALUE_LEN, "%s", %2) 

#define GetVVarFloatValue(%0,%1) GetVVarData(%0, %1, VV_FLOAT_VALUE)
#define SetVVarFloatValue(%0,%1,%2) SetVVarData(%0, %1, VV_FLOAT_VALUE, %2)

#if !defined IsValidVehicle
    native IsValidVehicle(vehicleid);
#endif

#define IsNotInRange(%0,%1,%2) (!(%0 <= %1 <= %2))

enum 
    E_VEHICLE_VAR_STRUCT
{
    VV_VAR_NAME[MAX_VVAR_VAR_NAME_LEN],
    VV_VALUE,
    VV_STRING_VALUE[MAX_VVAR_STRING_VALUE_LEN],
    Float: VV_FLOAT_VALUE
}

new g_vvar[MAX_VEHICLES][MAX_VVARS][E_VEHICLE_VAR_STRUCT];

enum 
{
    VEHICLE_VAR_TYPE_NONE,
    VEHICLE_VAR_TYPE_INT,
    VEHICLE_VAR_TYPE_STRING,
    VEHICLE_VAR_TYPE_FLOAT
}

static stock VvarGetFreeSlot(vehicleid)
{
    new vvar_free_slot = INVALID_VVAR_ID;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        if(GetVVarValue(vehicleid, j) > (INVALID_VVAR_VALUE + 1))
            continue;

        new vvar_string_value[MAX_VVAR_STRING_VALUE_LEN];

        GetVVarStringValue(vehicleid, j, vvar_string_value);

        if(strlen(vvar_string_value) > 0)
            continue;

        if(GetVVarFloatValue(vehicleid, j) > INVALID_VVAR_FLOAT_VALUE)
            continue;

        vvar_free_slot = j;
    }

    return vvar_free_slot;
} 

stock SetVVarInt(vehicleid, const var_name[], value)
{
    new var_name_len = strlen(var_name);

    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (IsNotInRange(EOS, var_name_len, (MAX_VVAR_VAR_NAME_LEN - 1)))
    ) return 0;

    new vvar_free_slot = VvarGetFreeSlot(vehicleid);

    SetVVarVarName(vehicleid, vvar_free_slot, var_name);
    SetVVarValue(vehicleid, vvar_free_slot, value);

    return 1;
} 

stock IsVVarValid(vehicleid, const var_name[])
{
    new bool: is_vvar_valid = false;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        new vvar_names[MAX_VVAR_VAR_NAME_LEN];

        GetVVarName(vehicleid, j, vvar_names);

        if(strcmp(var_name, vvar_names))
            continue;

        is_vvar_valid = true;
    }

    return is_vvar_valid;
}

static stock GetVVarValueByVarName(vehicleid, const var_name[])
{
    new vvar_value = INVALID_VVAR_VALUE;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        new vvar_names[MAX_VVAR_VAR_NAME_LEN];

        GetVVarName(vehicleid, j, vvar_names);

        if(strcmp(var_name, vvar_names))
            continue;

        vvar_value = GetVVarValue(vehicleid, j);
    }

    return vvar_value;
}

stock GetVVarInt(vehicleid, const var_name[])
{
    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (!IsVVarValid(vehicleid, var_name))
    ) return 0;

    new vvar_value = GetVVarValueByVarName(vehicleid, var_name);

    return vvar_value;
} 

stock SetVVarString(vehicleid, const var_name[], const string_value[])
{
    new var_name_len = strlen(var_name);

    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (IsNotInRange(EOS, var_name_len, (MAX_VVAR_VAR_NAME_LEN - 1)))
    ) return 0;

    new vvar_free_slot = VvarGetFreeSlot(vehicleid);

    SetVVarVarName(vehicleid, vvar_free_slot, var_name);
    SetVVarStringValue(vehicleid, vvar_free_slot, string_value);

    return 1;
}

static stock GetVVarStringValueByVarName(vehicleid, const var_name[])
{
    new vvar_string_value[MAX_VVAR_STRING_VALUE_LEN] = EOS;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        new vvar_names[MAX_VVAR_VAR_NAME_LEN];

        GetVVarName(vehicleid, j, vvar_names);

        if(strcmp(var_name, vvar_names))
            continue;

        GetVVarStringValue(vehicleid, j, vvar_string_value);
    }

    return vvar_string_value;
}

stock GetVVarString(vehicleid, const var_name[], return_string[], len = sizeof return_string)
{
    if(!IsVVarValid(vehicleid, var_name))
        return 0;

    format(return_string, len, "%s", GetVVarStringValueByVarName(vehicleid, var_name));

    return 1;
} 

stock SetVVarFloat(vehicleid, const var_name[], Float: float_value)
{
    new var_name_len = strlen(var_name);

    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (IsNotInRange(EOS, var_name_len, (MAX_VVAR_VAR_NAME_LEN - 1)))
    ) return 0;

    new vvar_free_slot = VvarGetFreeSlot(vehicleid);

    SetVVarVarName(vehicleid, vvar_free_slot, var_name);
    SetVVarFloatValue(vehicleid, vvar_free_slot, float_value);

    return 1;
} 

static stock Float: GetVVarFloatValueByVarName(vehicleid, const var_name[])
{
    new Float: vvar_float_value = INVALID_VVAR_FLOAT_VALUE;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        new vvar_names[MAX_VVAR_VAR_NAME_LEN];

        GetVVarName(vehicleid, j, vvar_names);

        if(strcmp(var_name, vvar_names))
            continue;

        vvar_float_value = GetVVarFloatValue(vehicleid, j);
    }

    return Float: vvar_float_value;
}

stock Float: GetVVarFloat(vehicleid, const var_name[])
{
    new var_name_len = strlen(var_name);

    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (IsNotInRange(EOS, var_name_len, (MAX_VVAR_VAR_NAME_LEN - 1)))
    ) return INVALID_VVAR_FLOAT_VALUE;

    new Float: vvar_float_value = GetVVarFloatValueByVarName(vehicleid, var_name);

    return Float: vvar_float_value;
} 

stock DeleteVVar(vehicleid, const var_name[])
{
    if
    (
        (!IsValidVehicle(vehicleid)) || 
        (!IsVVarValid(vehicleid, var_name))
    ) return 0;

    SetVVarInt(vehicleid, var_name, INVALID_VVAR_VALUE);
    SetVVarString(vehicleid, var_name, EOS);
    SetVVarFloat(vehicleid, var_name, INVALID_VVAR_FLOAT_VALUE);

    return 1;
} 

stock GetCountOfVVars(vehicleid)
{
    new count_of_vvars = INVALID_COUNT_OF_VVARS;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        if(GetVVarValue(vehicleid, j) <= (INVALID_VVAR_VALUE + 1))
            continue;

        new vvar_string_value[MAX_VVAR_STRING_VALUE_LEN];

        GetVVarStringValue(vehicleid, j, vvar_string_value);

        if(!strlen(vvar_string_value))
            continue;

        if(GetVVarFloatValue(vehicleid, j) <= INVALID_VVAR_FLOAT_VALUE)
            continue;

        count_of_vvars ++;
    }

    return count_of_vvars;
}

stock GetVVarsUpperIndex(vehicleid)
{
    new count_of_vvars = GetCountOfVVars(vehicleid);

    return count_of_vvars + 1;
} 

stock GetVVarNameAtIndex(vehicleid, index, return_var_name[], len = sizeof return_var_name)
{
    if(!IsValidVehicle(vehicleid))
        return 0;

    new vvar_name[MAX_VVAR_VAR_NAME_LEN];

    GetVVarName(vehicleid, index, vvar_name);

    new vvar_name_len = strlen(vvar_name);

    if(vvar_name_len <= EOS)
        return 0;

    if(vvar_name_len > len)
        return 0;

    else 
        format(return_var_name, len, "%s", vvar_name);

    return 1;
} 

stock GetVVarTypeByVarName(vehicleid, const var_name[])
{
    new vvar_type = VEHICLE_VAR_TYPE_NONE;

    for(new j; j < sizeof g_vvar[]; j ++)
    {
        new vvar_names[MAX_VVAR_VAR_NAME_LEN];

        GetVVarName(vehicleid, j, vvar_names);

        if(strcmp(var_name, vvar_names))
            continue;

        if(GetVVarValue(vehicleid, j) > (INVALID_VVAR_VALUE + 1))
            vvar_type = VEHICLE_VAR_TYPE_INT;

        new vvar_string_value[MAX_VVAR_STRING_VALUE_LEN];

        GetVVarStringValue(vehicleid, j, vvar_string_value);

        if(strlen(vvar_string_value) > 0)
            vvar_type = VEHICLE_VAR_TYPE_STRING;

        if(GetVVarFloatValue(vehicleid, j) > INVALID_VVAR_FLOAT_VALUE)
            vvar_type = VEHICLE_VAR_TYPE_FLOAT;
    }

    return vvar_type;
}

stock GetVVarType(vehicleid, const var_name[])
{
    new vvar_type = GetVVarTypeByVarName(vehicleid, var_name);

    return vvar_type;
}