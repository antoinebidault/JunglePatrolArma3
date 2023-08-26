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
params["_unitChased"];
private ["_enemy","_unitName"];
private _units = [];

if ( {_x getVariable["JP_Type",""] == "chaser"} count UNITS_SPAWNED_CLOSE >= MAX_CHASERS) exitWith {_units;};

private _nbUnit = MAX_CHASERS - round(random 3);
private _grp = createGroup SIDE_ENEMY;
private _posSelected = [position _unitChased, SPAWN_DISTANCE,SPAWN_DISTANCE + 100, .5, 0, 20, 0, MARKER_WHITE_LIST] call BIS_fnc_findSafePos;

 for "_xc" from 1 to _nbUnit do {
    _enemy = [_grp,_posSelected, false] call JP_fnc_spawnEnemy;
    _enemy setVariable["JP_Type","chaser"];
    _enemy setDir random 360;
    _units pushback _enemy;
 };

[HQ, format["Too late, there will be probably a unit moving straight to your position, and there are other reinforcements incoming !",_nbUnit], true] remoteExec["JP_fnc_talk", GROUP_PLAYERS, false];

 //Trigger chase
 // [leader _grp, _unitChased] spawn JP_fnc_chase;
[_grp,"JP_fnc_chase", [ _grp, _unitChased]] call JP_fnc_patrolDistributeToHC;

 _units;