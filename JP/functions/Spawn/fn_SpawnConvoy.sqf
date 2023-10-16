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
_nbVeh = 3;
_nbTrucks = _nbVeh - 1;
_roadRadius = 40;

STOP_SPAWN_CONVOY = true;
publicVariable "STOP_SPAWN_CONVOY";


_ambush = (missionNamespace getVariable["convoy_ambush",""]);
_start = (missionNamespace getVariable["convoy_start",""]);
_end = (missionNamespace getVariable["convoy_stop",""]);
_startPos = getPos(_start);
_endPos = getPos(_end);
_ambushPos = getPos(_ambush);

_road = [_startPos,500,[]] call BIS_fnc_nearestRoad;
_roadPos = getPos _road;

_grp = createGroup SIDE_ENEMY;
_car = objNull;
CONVOY = [];
  _roadConnectedTo = roadsConnectedTo _road;
  _connectedRoad = _roadConnectedTo select 0;
  _roadDirection = [_road, _connectedRoad] call BIS_fnc_dirTo;
  _car = [_roadPos, _roadDirection, ENEMY_CONVOY_CAR_CLASS, _grp] call BIS_fnc_spawnVehicle select 0;
  _ambush setVariable["JP_Type","convoy", true];
  _ambush setVariable["JP_TaskNotCompleted",true, true];
  _ambush setVariable["JP_IsIntelRevealed",true, false];
  if (_initial) then {
	  [_ambush,_initial] call JP_fnc_createTask;
    [HQ,"There is an enemy convoy moving not far from your position. Go next to the road between the start and end marker position",true] remoteExec ["JP_fnc_talk"];
  };
  //(driver _car) enableSimulationGlobal false;
  
  [_car,["Killed",{
      [GROUP_PLAYERS,5] remoteExec ["JP_fnc_updateScore",2];   
  }]] remoteExec ["addEventHandler",0,true];

_grp selectLeader  (driver _car)  ;


  _units pushback _car;
  CONVOY pushback _car;
  _units = _units + (crew _car);
  
  _nbUnit = (count (fullCrew [_car,"cargo",true])) min 10;
  
  //Civilian team spawn.
  //If we killed them, it's over.
  for "_xc" from 1 to _nbUnit  do {
      _unit =[_grp,_startPos,true] call JP_fnc_spawnEnemy;
      _unit moveInCargo _car;
      _units pushback _unit;
  };

  //Trucks
  for "_xc" from 1 to _nbTrucks  do {
      _truck = [_car modelToWorld [0,-(_xc*15),0], _roadDirection, ENEMY_CONVOY_TRUCK_CLASS call BIS_fnc_selectRandom, _grp] call BIS_fnc_spawnVehicle select 0;
      _nbUnit = (count (fullCrew [_truck,"cargo",true]));
      for "_yc" from 1 to _nbUnit  do {
          _unit = [_grp,_startPos,true] call JP_fnc_spawnEnemy;
          _unit moveInCargo _truck;
          _units pushback _unit;
      };
      _units pushback _truck;
      _units = _units + (crew _truck);


      [_truck, ["Killed",{
        [GROUP_PLAYERS,5] remoteExec ["JP_fnc_updateScore",2];   
      }]] remoteExec ["addEventHandler",0,true];;
      CONVOY pushback _truck;
  };

  _grp setBehaviour "SAFE";
 // _grp setSpeedMode "NORMAL";
  _grp setFormation "COLUMN";

deleteMarker "convoy-ambush-marker";
private _wpt = createMarker ["convoy-ambush-marker",_ambushPos];
_wpt setMarkerShape "ICON";
_wpt setMarkerColor "ColorRed";
_wpt setMarkerType "mil_ambush";
_wpt setMarkerText "Ambush the convoy";

deleteMarker "convoy-start-marker";
private _wpt = createMarker ["convoy-start-marker",_startPos];
_wpt setMarkerShape "ICON";
_wpt setMarkerColor "ColorRed";
_wpt setMarkerType "mil_start";
_wpt setMarkerText "convoy start";

deleteMarker "convoy-end-marker";
_wpt = createMarker ["convoy-end-marker",_endPos];
_wpt setMarkerShape "ICON";
_wpt setMarkerColor "ColorRed";
_wpt setMarkerType "hd_ambush";
_wpt setMarkerText "convoy destination";

_wpt = _grp addWaypoint [_endPos, 10];
_wpt setWaypointType "MOVE";
_wpt setWaypointBehaviour "SAFE";
// _wpt setWaypointSpeed "LIMITED";
_wpt setWaypointFormation "COLUMN";
leader _grp moveTo _endPos;
driver _car moveTo _endPos;

waitUntil {sleep 5;  {alive _x} count CONVOY == 0 || (leader _grp) distance _end < 10 };

deleteMarker "convoy-ambush-marker";
deleteMarker "convoy-start-marker";
deleteMarker "convoy-end-marker";

if ((leader _grp) distance _end < 10) then {
    sleep 40;
    [HQ,"You missed the convoy ! Wait for the next one !",true]  remoteExec ["JP_fnc_talk"];
    {_units = _units - [_x]; _x call JP_fnc_deleteMarker; deleteVehicle _x; } forEach _units;
    sleep 60;
    [false] call JP_fnc_spawnConvoy;
};

if ({alive _x} count CONVOY == 0) exitWith {
    [HQ,"You successfully ambushed the convoy ! Well done !",true] remoteExec ["JP_fnc_talk"];
     _ambush remoteExec ["JP_fnc_success",2, false];
    [_ambush];
};

STOP_SPAWN_CONVOY = false;
publicVariable "STOP_SPAWN_CONVOY";

[_ambush];