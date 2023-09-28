/*
  Author: 
    Bidass

  Version:
    {VERSION}

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
    _ammo = createVehicle [_unitName,_posToSpawn,[],0,"CAN_COLLIDE"]; 
    clearmagazinecargo _ammo; 
    clearweaponcargo _ammo;
    clearBackpackCargo _ammo;

    _ammo setDir (random 359);
    [_ammo,"ColorBrown"] call JP_fnc_addMarker;
    _ammo setVariable["JP_Type","cache", true];
    _ammo setVariable["JP_TaskNotCompleted",true, true];
    _ammo setVariable["JP_IsIntelRevealed",false, true];
    
    [_ammo,["Killed",{ 
        params["_cache","_killer"];
        _cache remoteExec ["JP_fnc_success", 2, false];
    }]] remoteExec["addEventHandler",0, true];
   
    _units pushBack _ammo;
    _nbGuards = 2 + round(random 4);
    _grp = createGroup SIDE_ENEMY;
    for "_i" from 1 to _nbGuards do {
        if (count _posBuildings == 0) exitWith{_units};
         _posToSpawn = _posBuildings call BIS_fnc_selectRandom;
         _posBuildings = _posBuildings -[_posToSpawn];
        _enemy = [_grp,_posToSpawn,false] call JP_fnc_spawnEnemy;
        _enemy setVariable["JP_Type","cacheguard", true];
        _units pushBack _enemy;
    };
};

_units;