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

_group = _this select 0;
_pos = _this select 1;
_chief =  [_this, 2, objNull, [objNull]] call BIS_fnc_param;
_handleFireEvent =  [_this, 3, true, [true]] call BIS_fnc_param;
_unitName =  [_this, 4, CIV_LIST_UNITS call BIS_fnc_selectRandom, ["",[]]] call BIS_fnc_param;
_friendlieness =  [_this, 5, 100-PERCENTAGE_SUSPECT, [0]] call BIS_fnc_param;

_unit = _group createUnit [_unitName, _pos,[],AI_SKILLS,"NONE"];
[_unit] joinsilent _group;
// _group call JP_fnc_sendToHC;

removeAllWeapons _unit;

//Si c'est un mauvais
_unit setVariable["JP_Chief",_chief, true];

[_unit] call JP_fnc_handlekill;
_unit call JP_fnc_handleDamaged;

//By default, it takes the average civil reputation;
_unit setVariable["JP_Suspect", if(random 100 > _friendlieness) then {true}else{false} ];
// _unit setVariable["JP_Friendliness",CIVIL_REPUTATION, true];

if (DEBUG)then{
    [_unit, if (_unit getVariable["JP_Suspect", false])then{"ColorOrange"}else{"ColorBlue"}] call JP_fnc_addmarker;
};

_unit setVariable["JP_Type","civ"];
_unit setDir random 360;

if (_handleFireEvent)then{
    [_unit] spawn JP_fnc_handleFiredNear;
    [_unit] remoteexec ["JP_fnc_addCivilianAction",0];
};

UNITS_SPAWNED_CLOSE pushBack _unit;

_unit
