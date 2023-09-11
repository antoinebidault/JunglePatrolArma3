/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    Set up a cache in the selected compound using a proper building position

  Parameters:
    0: ARRAY - position
    1: NUMBER - Radius in meters
    2: NUMBER - Number of units to spawn
    3: ARRAY - Building list

  Returns:
    ARRAY - array of unit's spawned 
*/

private ["_unit","_building","_buildings","_unitName","_posToSpawn","_posBuildings","_enemy"];

private _pos = _this select 0;
private _nb = _this select 1;
private _buildings = _this select 2;
private _units = [];
private _boxeClasses = ["Box_Syndicate_Ammo_F"];

if (_nb == 0)exitWith{_units;};
if (count _buildings == 0) exitWith{[]};

for "_j" from 1 to _nb do {
    _building = _buildings call BIS_fnc_selectRandom;
    _buildings = _buildings - [_building];
    _posBuildings = [_building] call BIS_fnc_buildingPositions;
    if (count _posBuildings == 0) exitWith{_units;};
    _posToSpawn = _posBuildings call BIS_fnc_selectRandom;
    _posBuildings = _posBuildings - [_posToSpawn];
    _unitName = _boxeClasses call BIS_fnc_selectRandom;
    _unit = createVehicle [_unitName,_posToSpawn,[],0,"CAN_COLLIDE"]; 
    clearmagazinecargo _unit; 
    clearweaponcargo _unit;

    _unit setDir (random 359);
    [_unit,"ColorBrown"] call JP_fnc_addMarker;
    _unit setVariable["JP_Type","cache", true];
    _unit setVariable["JP_TaskNotCompleted",true, true];
    _unit setVariable["JP_IsIntelRevealed",false, false];
    
    _unit addMPEventHandler["MPKilled",{ 
        params["_cache","_killer"];
        if (group(_killer) == GROUP_PLAYERS) then {
            _cache remoteExec ["JP_fnc_success", 2, false];
         }else{
            _cache remoteExec ["JP_fnc_failed", 2, false]; 
        }; 
    }];
    _units pushBack _unit;
    _nbGuards = 2 + round(random 4);
    _grp = createGroup SIDE_ENEMY;
    for "_i" from 1 to _nbGuards do {
        if (count _posBuildings == 0) exitWith{_units};
         _posToSpawn = _posBuildings call BIS_fnc_selectRandom;
         _posBuildings = _posBuildings -[_posToSpawn];
        _enemy = [_grp,_posToSpawn,false] call JP_fnc_spawnEnemy;
        _enemy setVariable["JP_type","cacheguard"];
        _units pushBack _enemy;
    };

};

_units;