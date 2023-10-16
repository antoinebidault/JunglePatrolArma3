  /*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Create a complete map cluster

  Parameters:
    0: STRING - Marker area

  Returns:
    BOOL - true 
*/

params["_gameArea"];

diag_log localize "STR_JP_getclusters_startProcess";

private _worldSize = if (isNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize")) then {getNumber (configfile >> "CfgWorlds" >> worldName >> "mapSize");} else {8192;};
private _worldCenter = [_worldSize/2,_worldSize/2,0];
private _worldNbBlocks = floor(_worldSize/SIZE_BLOCK);
private _isCloseToAnotherCompound = false;
private _isMilitary = false;
private _clusters = [];

JP_fnc_isMilitary = {
	params["_buildings"];
	_isMilitary = false;
	//Check military houses
	_nbMilitaryBuilding = {
		_class = (getText (configfile >> "CfgVehicles" >>  (typeOf _x) >> "vehicleClass")) ;
		_class == "Structures_Military" || _class == "Structures_Airport" || _class == "Fortifications" 
	} count _buildings;
	if(_nbMilitaryBuilding > (count _buildings)/6) exitWith {true};
	false;
};

JP_fnc_getRadiusLocation = {
	params ["_locpos"];
	_locpos set [2,0];
	private _houseCount = 0;
	private _oldHouseCount = 0;
	private _prevHouseCount = 0;
	private _rad = 50;
	private _count = 0;
	private _houses = []; 
	private _totalHouses  = [];
	for "_radius" from 50 to MAX_CLUSTER_SIZE step 50 do
	{
		_houses = []; 
		_houses = [_locPos,_radius] call JP_fnc_findBuildings;
		_count = (count _houses);
		_totalHouses = _totalHouses + _houses;
		if (_count == _prevHouseCount) exitWith { _rad = _radius-50; };
		_prevHouseCount = _count;
		_rad = _radius;
	};

	_isMilitary = [_totalHouses] call JP_fnc_isMilitary;

	[_rad, _count,_isMilitary,_totalHouses];
};

// Friendly markers
_markerFriendly = [];
{  if (_x find "marker_friendly" == 0 ) then { _markerFriendly pushback _x }; }foreach allMapMarkers; 
{
	_locPos = getMarkerPos _x;
	_radius = getMarkerSize _x select 0;
	_result = [_locPos] call JP_fnc_getRadiusLocation;
	if (_radius > 0)then {
		_clusters pushback [_locPos,_radius,_result select 1,true,_x,true, _result select 3,str random 10000];
	};
} foreach _markerFriendly;


{
	_pos = getPos _x;
    _res = [_pos,true] call JP_fnc_getRadiusLocation;
    _radius = _res select 0;
	
	if (_radius > 0 && !(surfaceIsWater _pos) && _pos inArea _gameArea)then {
		_clusters pushback [_pos,_radius,_res select 1,true,if (text _x == "") then {localize "STR_JP_getclusters_unknownLocation"} else {text _x},_res select 2, _res select 3,str random 10000];
	};
} forEach nearestLocations [getArray (configFile >> "CfgWorlds" >> worldName >> "centerPosition"), ["NameCityCapital","NameLocal","NameCity","NameVillage","Airport","CityCenter"], 25000]; 


for "_xc" from 0 to _worldNbBlocks do {
	for "_yc" from 0 to _worldNbBlocks do {
		_markerPos = [(_xc*SIZE_BLOCK),(_yc*SIZE_BLOCK),0];
		if (_markerPos inArea _gameArea) then {
			_buildings = [_markerPos, (SIZE_BLOCK)] call JP_fnc_findBuildings;
			_nbBuildings = count _buildings;
			if (_nbBuildings > 0)then{
				private _building =  (_buildings select 0);
				private _posCenteredOnBuilding = position _building;
				private _res  = [_posCenteredOnBuilding] call JP_fnc_getRadiusLocation;
				private _radius = _res select 0;
				
				_nbHouses = _res select 1;
				if (_nbHouses > 1)then {
					_name = localize "STR_JP_getclusters_compound";
					if (_nbHouses < 2) then {
						_name = localize "STR_JP_getclusters_landHouse";
					} else {
						if (_nbHouses < 6) then {
							_name = localize "STR_JP_getclusters_smallCompound";
						} else{
							if (_nbHouses < 10) then {
								_name = localize "STR_JP_getclusters_largeCompound";
							} else{
								if (_nbHouses < 30) then {
									_name = localize "STR_JP_getclusters_village";
								} else{
									_name = localize "STR_JP_getclusters_town";
								};
							};
						};
					};
					_clusters pushback [_posCenteredOnBuilding,_radius,_res select 1,false,_name,_res select 2,_res select 3,str random 10000];
				};

			};
		};
	};
};


_sortedClusters = [_clusters, [], { if(_x select 3) then { 99999 } else { _x select 1 }; }, "DESCEND"] call BIS_fnc_sortBy;
_sortedClustersReverse = [_clusters, [], { if(_x select 3) then { 0 } else { _x select 1 }; }, "ASCEND"] call BIS_fnc_sortBy;

{
	_posCenteredOnBuilding = _x select 0;
	_radius = _x select 1;
	_isCloseToAnotherCompound = false;
	_id = _x select 7;
	{ 
	    _dist = _posCenteredOnBuilding distance2D (_x select 0);
		if( _x select 7 != _id && _dist < ((_x select 1)  + _radius) ) then { 
			_clusters = _clusters - [_x]; 
		};
	} foreach _sortedClustersReverse;

	_sortedClustersReverse = _sortedClustersReverse - [_x];
		
} foreach _sortedClusters;

_sortedClusters = [];
_sortedClustersReverse = [];

diag_log localize "STR_JP_getclusters_endProcess";

_clusters;
