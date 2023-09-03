/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    TODO

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

private _group = _this select 0;
private _pos = _this select 1;
private _excludedFromSpawnedUnit = _this select 2;

private _unitName = ENEMY_LIST_UNITS call BIS_fnc_selectRandom;
private _unit = _group createUnit [_unitName, _pos,[], AI_SKILLS,"NONE"];
[_unit] joinsilent _group;
// _group call JP_fnc_sendToHC;

if (DEBUG)then{
    [_unit,"ColorRed"] call JP_fnc_addmarker;
};

// [_unit] call JP_fnc_addTorch;
[_unit] call JP_fnc_handlekill;
[_unit] call JP_fnc_handleAttacked;

if (!_excludedFromSpawnedUnit)then{
    UNITS_SPAWNED_CLOSE pushback _unit;
};

// Remove map
if (random 100 > 15) then {
 _unit removeItem "vn_o_item_map";
};

_unit


