/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    TODO
 
  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/



private["_unit","_radius","_houses","_pos","_wp","_posBuilding","_gunner"];

_unit = _this select 0;
_gunner = _this select 1;
_radius = 100;
_pos = position _unit;
_unit setVariable ["civ_insurgent",true]; 
_unit setVariable ["JP_disable_patrol",true,true]; 

if(isNil '_unit') exitWith {false};
if(!alive _unit) exitWith {false};

//Add a bonus wether the shooter is from the enemy side or not
private _bonus = if (side _gunner == SIDE_ENEMY)then{25}else{-25};
private _side = if (random 100 > (PERCENTAGE_FRIENDLY_INSURGENTS + _bonus)) then {SIDE_ENEMY}else{SIDE_FRIENDLY};

if (DEBUG) then {
    _marker = _unit getVariable["marker",""];
	_marker setMarkerColor "ColorWhite";
};

_houses  = [getPosATL _unit, _radius] call JP_fnc_findbuildings; 

sleep 3;
_unit forceWalk false;
_unit setspeedmode "FULL";
_unit setbehaviour "CARELESS"; 
//_marker setMarkerColor "ColorRed";
if (count _houses > 0 ) then{
	_house = _houses select 0;
	_posBuilding = ([_house] call BIS_fnc_buildingPositions) call bis_fnc_selectrandom;
	if (_unit distance _posBuilding < 70) then{
		_unit doMove _posBuilding ;
		waitUntil { isNull _unit || _unit distance _posBuilding < 2};
		[_unit,_side] remoteExec ["JP_fnc_badGuyLoadOut",owner _unit];
	}else{
		[_unit,_side] remoteExec ["JP_fnc_badGuyLoadOut",owner _unit];
	};
}else{
	[_unit,_side] remoteExec ["JP_fnc_badGuyLoadOut",owner _unit];
};

//Move to a new position
sleep 3;
_dir = random 360;
 _newPos = [_pos ,40,50, 2, 0, 20, 0] call BIS_fnc_findSafePos;
_unit doMove _newPos;
