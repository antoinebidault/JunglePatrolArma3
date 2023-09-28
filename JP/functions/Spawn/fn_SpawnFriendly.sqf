/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Spawn a friendly unit using the ALLIED_LIST_UNITS class list randomized

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

private _group = _this select 0;
private _pos = _this select 1;
private _excludedFromSpawnedUnit = [_this,2,false] call BIS_fnc_param;
private _forcedUnitClass = [_this,3,""] call BIS_fnc_param;

// Handle the forced unit class
_unitName = "";
if (_forcedUnitClass == "") then {
  _unitName = ALLIED_LIST_UNITS call BIS_fnc_selectRandom;
}else{
  _unitName = _forcedUnitClass;
};

_unit = _group createUnit [_unitName, _pos,[],AI_SKILLS,"NONE"];
[_unit] joinsilent _group;
// _group call JP_fnc_sendToHC;

if (DEBUG)then{
    [_unit,"ColorGreen"] call JP_fnc_addmarker;
};

_unit remoteExec ["JP_fnc_addActionJoinAsAdvisor"];
_unit remoteExec ["JP_fnc_addActionJoinAsTeamMember"];

// Remove all action on death
[_unit, ["Killed",
    { 
        params["_unit","_killer"];
        _unit remoteExec ["RemoveAllActions",0];
    }
]] remoteExec ["addEventHandler",0,true];

if (!_excludedFromSpawnedUnit)then{
    UNITS_SPAWNED_CLOSE pushback _unit;
};

_unit


