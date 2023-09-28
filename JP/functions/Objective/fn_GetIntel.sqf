/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Get intel on the current objective

  Parameters:
    0: OBJECT - Unit who is interrogated
    1: OBJECT - Unit who is asking (The player)
    2: NUMBER - Probability 

  Returns:
    ARRAY - [BOOL,OBJECT] 
*/

private _unit = _this select 0;
private _asker = _this select 1;
private _probability  =  if (count _this == 3) then { _this select 2 } else { 50 };
_message = "";
private _pos = getPosASL _unit;

// If nothing found 
if (isNull (CURRENT_OBJECTIVE select 4) || random 100 > _probability || ((CURRENT_OBJECTIVE select 2) <= 50) ) exitWith { 
  if (alive _unit) then {
      [_unit, ["I have no idea...","I can't talk about this..."] call BIS_fnc_selectRandom,true] remoteExec ["JP_fnc_talk",owner _asker]; 
  } else{
    
    [_asker, "I've found nothing !",true] remoteExec ["JP_fnc_talk",owner _asker];
  };
  [false,"Nothing found"];
};

_intel = CURRENT_OBJECTIVE select 4;

[_asker, "I've found some informations on a potential target !",true] remoteExec ["JP_fnc_talk",owner _asker];

CURRENT_OBJECTIVE set [2, (CURRENT_OBJECTIVE select 2) - 40];
publicVariable "CURRENT_OBJECTIVE";

if (!(_intel getVariable["JP_IsIntelRevealed",false])) then {
  [] call JP_fnc_updateMarker;
};

if (CURRENT_OBJECTIVE select 2 <= 100 ) then {
  _intel call JP_fnc_revealObjective;
};

[true,_message];