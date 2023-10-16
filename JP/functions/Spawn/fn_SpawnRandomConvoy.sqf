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

//Stand by during a long period
if (!isServer) exitWith{false};

_units = [];

//SLEEP (_this select 0);
params["_initial"];
STOP_SPAWN_CONVOY= false;
publicVariable "STOP_SPAWN_CONVOY";
CONVOY_LIST = [];
publicVariable "CONVOY_LIST";
while { true } do {
   if (count CONVOY_LIST <= MAX_RANDOM_CONVOY && !STOP_SPAWN_CONVOY) then {
    [] spawn {
      _nbTrucks = ceil(random 2) min 1;
      _roadRadius = 40;

      _start = (missionNamespace getVariable["convoy_start",""]);
      _end = (missionNamespace getVariable["convoy_stop",""]);

      _startPos = getPos(_start);
      _endPos = getPos(_end);
      _ambushPos = getPos(_ambush);

      _road = [_startPos,500,[]] call BIS_fnc_nearestRoad;
      _roadPos = getPos _road;

      _grp = createGroup SIDE_ENEMY;
      _car = objNull;
      CONVOY_LIST = [];
      _roadConnectedTo = roadsConnectedTo _road;
      _connectedRoad = _roadConnectedTo select 0;
      _roadDirection = [_road, _connectedRoad] call BIS_fnc_dirTo;


        _trucks = [];
        for "_xc" from 1 to _nbTrucks  do {
            _truck = [_road modelToWorld [0,0,-((_xc - 1)*15)], _roadDirection, ENEMY_CONVOY_TRUCK_CLASS call BIS_fnc_selectRandom, _grp] call BIS_fnc_spawnVehicle select 0;
            _nbUnit = (count (fullCrew [_truck,"cargo",true])) min 10;
            for "_yc" from 1 to _nbUnit  do {
                _unit = [_grp,_startPos,true] call JP_fnc_spawnEnemy;
                _unit moveInCargo _truck;
            };

             [_truck,"ColorPink"] call JP_fnc_addMarker;

            [_truck, ["Killed",{
              params["_unit"];
              [GROUP_PLAYERS,5] remoteExec ["JP_fnc_updateScore",2];   
              CONVOY_LIST = CONVOY_LIST - [_unit];
            }]] remoteExec ["addEventHandler",0,true];;
            CONVOY_LIST pushback _truck;
            publicVariable "CONVOY_LIST";
            _trucks pushback _truck;
        };

      _grp setBehaviour "SAFE";
      _grp setSpeedMode "FAST";
      _grp setFormation "COLUMN";


      _wpt = _grp addWaypoint [_endPos, 10];
      _wpt setWaypointType "MOVE";
      _wpt setWaypointBehaviour "SAFE";
      _wpt setWaypointFormation "COLUMN";
      leader _grp moveTo _endPos;
      driver _car moveTo _endPos;

      waitUntil {sleep 5;  { alive _x } count _trucks == 0 || (leader _grp) distance _end < 10 };

        if ((leader _grp) distance _end < 10) then {
            sleep 40;
            {
              _units = _units - [_x]; _x call JP_fnc_deleteMarker; deleteVehicle _x; 
              CONVOY_LIST = CONVOY_LIST - [_x];
            } forEach _units;
        };

      };
  };

  sleep 520 + random(560);

};