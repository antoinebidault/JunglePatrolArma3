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

CURRENT_OBJECTIVE set [2, (CURRENT_OBJECTIVE select 2) - 25];
publicVariable "CURRENT_OBJECTIVE";

if (!(_intel getVariable["JP_IsIntelRevealed",false])) then {
  [] call JP_fnc_updateMarker;
};

if (CURRENT_OBJECTIVE select 2 <= 100 && !(_intel getVariable["JP_IsIntelRevealed",false])) then {
  _intel setVariable["JP_IsIntelRevealed",true, true];
  _marker = createMarker [format["s%1",random 13100],getPos _intel];
  _marker setMarkerShape "ICON";
  _marker setMarkerColor "ColorRed";
  _marker setMarkerType "hd_objective";
  _intel setVariable["JP_MarkerIntel",_marker];
  _task = [_intel,true] call JP_fnc_createtask;
} else {
  if (_intel getVariable["JP_IsIntelRevealed",false]) then {
    _taskId = _intel getVariable["JP_Task",""];
    [_taskId,getPos _intel] call BIS_fnc_taskSetDescription;
  };
};


/*



_taskId = _task select 0;
_message = _task select 1;
_intel setVariable["JP_IsIntelRevealed",true, true];
_marker = createMarker [format["s%1",random 13100],getPos _intel];
_marker setMarkerShape "ICON";
_marker setMarkerColor "ColorRed";
_marker setMarkerType "hd_objective";
_intel setVariable["JP_MarkerIntel",_marker];
[_asker, "HQ, I found some informations !",true] remoteExec ["JP_fnc_talk",owner _asker];
[HQ, "Good job, keep up the good work !",true] remoteExec ["JP_fnc_talk",owner _asker];

// Increment the stat of intel found
STAT_INTEL_FOUND = STAT_INTEL_FOUND + 1;
publicVariable "STAT_INTEL_FOUND";
*/

[true,_message];