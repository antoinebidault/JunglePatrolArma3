/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    TODO

  Parameters:
    0: OBJECT - unit
    1: OBJECT - Injured unit

  Returns:
    BOOL - true 
*/



params ["_unit", "_injured"];

// If ai, give it a little less time
if (!isPlayer _unit && !isPlayer _injured) then {
  20;
};

private _time = REVIVETIME_INSECONDS;
_time = _time * (damage _injured * 0.414);

_time;