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

private["_unitName","_car","_pos","_unit","_roadConnectedTo","_roads","_road","_connectedRoad","_roadDirection"];
if (!isServer) exitWith{false};
private _minRange = 1500;
private _maxRange = 1900;
private _carPool = [];

CAR = objNull;
while{ true }do {
	if (count _carPool < MAX_RANDOM_CAR)then{
		//Get random pos
		// get the next connected roadsegements to determine the direction of the road
		_pos = [position (([] call JP_fnc_allPlayers) call BIS_fnc_selectRandom), _minRange, _maxRange, 0, 0, 20, 0, MARKER_WHITE_LIST + PLAYER_MARKER_LIST,[]] call BIS_fnc_findSafePos;
		if (_pos isEqualTo []) then {
			sleep 2;
		} else {
			_road = [_pos,600,MARKER_WHITE_LIST] call BIS_fnc_nearestRoad;
			if (isOnRoad(getPos _road) && (getPos _road) distance (([] call JP_fnc_allPlayers) call BIS_fnc_selectRandom) > 400 )then{
				_roadConnectedTo = roadsConnectedTo _road;
		               
				if (count _roadConnectedTo > 0) then {
				  _connectedRoad = _roadConnectedTo select 0;
				  _roadDirection = [_road, _connectedRoad] call BIS_fnc_DirTo;
                                } else {
				  _roadDirection = 90;
				};

				if(random 100 > PERCENTAGE_CIVILIAN )then{
					_unitName = ENEMY_LIST_CARS call BIS_fnc_selectRandom;
					_car = ([getPos _road, _roadDirection,_unitName, SIDE_ENEMY] call bis_fnc_spawnvehicle)  select 0;
					_nbUnit = 5 min (count (fullCrew [_car,"cargo",true]));
		
					//Civilian team spawn.
					//If we killed them, it's over.
					_grp = group _car;
					for "_xc" from 1 to _nbUnit  do {
						_unit =[_grp,_pos,true] call JP_fnc_spawnEnemy;
						_unit moveInCargo _car;
					};
					
				}else{
					_unitName = CIV_LIST_CARS call BIS_fnc_selectRandom;
					_car = ([getPos _road, _roadDirection,_unitName, SIDE_CIV] call bis_fnc_spawnvehicle)  select 0;

				};

				_carPool pushBack _car ;
				CAR = _car;

				{
					_unit = _x;
					[_unit] call JP_fnc_handlekill;
					// [_unit] call JP_fnc_addTorch;
					[_unit, if(side _unit == SIDE_CIV) then { "ColorBlue" } else { "ColorRed" } ] call JP_fnc_addMarker;
					_unit setVariable["JP_Type","carpatrol"];
					UNITS_SPAWNED_CLOSE pushBack _unit;
				} foreach (crew _car);

				[driver _car, 1900,true] spawn JP_fnc_carPatrol;
				
			};
		};	
	};

	// Garbage collector
	{
		_veh = _x;
		{
			if (!alive _veh || { alive _veh } count crew  _veh == 0 ) then{
				_carPool = _carPool - [_veh];
			};

			if(_veh distance _x > 1600)then{
				_carPool = _carPool - [_veh];
				{
					_x call JP_fnc_deleteMarker;
					deleteVehicle _x;
				} foreach (crew _veh);
				_veh call JP_fnc_deleteMarker;
				deleteVehicle _veh;
			};
		} foreach ([] call JP_fnc_allPlayers);
	} foreach _carPool;

	sleep 150 + random 100;
};
