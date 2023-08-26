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

private _pos = _this select 0;
private _radius = _this select 1;
private _nb = _this select 2;
private _state = _this select 3;

private _cars = [];

private _roads = _pos nearRoads _radius;

_roadSelects = [];

_i = _nb;
if (count _roads == 0) exitWith {_cars};
while {_i > 0} do {
	if (_i > count _roads) exitWith{};
    _rnd = _roads call BIS_fnc_selectRandom;
    _roadSelects pushBack _rnd;
    _roads = _roads - [_rnd];
    _i = _i-1;
};

private _connectedRoad = objNull;
private _car = objNull;
private _roadConnectedTo = objNull;

{
  _x;
  
  if (count nearestObjects[getPos _x,["Car"],6] == 0) then {
    _r = floor random 100;
    if (_state == "humanitary") then {
      _car = createVehicle [HUMANITAR_LIST_CARS call BIS_fnc_selectRandom, getPos _x, [], random 5, "NONE"];
    } else {
      if (_state == "bastion")then{
        _car = createVehicle [ENEMY_LIST_CARS call BIS_fnc_selectRandom, getPos _x, [], random 5, "NONE"];
      } else {
        _car = createVehicle [CIV_LIST_CARS call BIS_fnc_selectRandom, getPos _x, [], random 5, "NONE"];
      };
    };

    _car setVariable ["JP_Type","car"];
    //_car setVehicleLock "LOCKED";
    _roadConnectedTo = roadsConnectedTo _x;
    ROAD = _roadConnectedTo;
    if (count _roadConnectedTo == 0) then{
      _car setDir floor(random 360);
    }else{
      _connectedRoad = _roadConnectedTo select 0;
      _car setDir ([_x, _connectedRoad] call BIS_fnc_dirTo);
    };
    _car setPos [(getPos _car select 0)-2.5, getPos _car select 1, getPos _car select 2];
    _cars pushBack _car;
  };
} forEach _roadSelects;

_cars;