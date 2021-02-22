#define MAX_COUNTERS (16)

#define GetCounterData(%0,%1) g_counter[%0][%1]
#define SetCounterData(%0,%1,%2) g_counter[%0][%1] = %2
#define IsValidCounter(%0) (Iter_Contains(Counters, %0))
#define GetCounterOccupier(%0) GetCounterData(%0, C_OCCUPIER_ID)
#define SetCounterOccupier(%0,%1) SetCounterData(%0, C_OCCUPIER_ID, %1)
#define GetCounterState(%0) GetCounterData(%0, C_STATE)
#define SetCounterState(%0,%1) SetCounterData(%0, C_STATE, %1)
#define GetCounterContent(%0) GetCounterData(%0, C_CONTENT)
#define SetCounterContent(%0,%1) SetCounterData(%0, C_CONTENT, %1)