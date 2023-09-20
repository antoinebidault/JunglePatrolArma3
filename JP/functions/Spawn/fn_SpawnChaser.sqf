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
params["_unitChased","_notify"];
private ["_enemy","_unitName"];
private _units = [];

if ( {_x getVariable["JP_Type",""] == "chaser"} count UNITS_SPAWNED_CLOSE >= MAX_CHASERS) exitWith {_units;};

private _nbUnit = MAX_CHASERS - round(random 4);
private _grp = createGroup SIDE_ENEMY;
private _posSelected = [position _unitChased, SPAWN_DISTANCE,SPAWN_DISTANCE + 100, .5, 0, 20, 0, MARKER_WHITE_LIST] call BIS_fnc_findSafePos;

 for "_xc" from 1 to _nbUnit do {
    _enemy = [_grp,_posSelected, false] call JP_fnc_spawnEnemy;

    _enemy setSkill .9;
    _enemy setskill ["aimingAccuracy", .7];
    _enemy setskill ["aimingShake", .6];
    _enemy setskill ["aimingSpeed", .5];
    _enemy setskill ["spotDistance", 1];
    _enemy setskill ["spotTime", 1];
    _enemy setskill ["commanding", 1];
    _enemy setskill ["courage", .7];
    _enemy setskill ["general", 1];
    _enemy setskill ["reloadSpeed", 1];

    _enemy setVariable["JP_Type","chaser"];
    _enemy setDir random 360;
    _units pushback _enemy;
 };

if (_notify) then {
  [leader GROUP_PLAYERS, "Dawn, hey've called in reinforcements, elite units are on their way! Let's find a good hideout!", true] remoteExec["JP_fnc_talk", GROUP_PLAYERS, false];
};

 //Trigger chase
 // [leader _grp, _unitChased] spawn JP_fnc_chase;
[_grp,"JP_fnc_chase", [ _grp, _unitChased]] call JP_fnc_patrolDistributeToHC;

 _units;