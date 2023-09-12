

/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Spawn a defend task

  Parameters:
    0: ARRAY - Compound config array

*/

5 fadeMusic 0;
params["_pos", "_radius"];

ENEMY_REACH_POINT = false;
_units = [];
_nbGroups = 2 max ceil(random 3);

_taskId = format["JP_patrol_%1",str (random 999)];

[leader GROUP_PLAYERS,"Damn, I hear some noise !"] remoteExec ["JP_fnc_talk"];
{
	[_taskId, _x, ["Avoid Charlie Patrol","Avoid Charlie Patrol","Hide or eliminate the group of enemy soldiers getting close to your campement"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, false];
} foreach units GROUP_PLAYERS;     
// STAT_INTEL_FOUND = STAT_INTEL_FOUND + 1;


_grp = createGroup SIDE_ENEMY;
_spawnPos = [_pos, 200,230, 1, 0, .3, 0] call BIS_fnc_findSafePos;
_nbUnits =  4 + floor(random 4); 

for "_xc" from 1 to _nbUnits  do {
	_unit =[_grp,_spawnPos,true] call JP_fnc_spawnEnemy;
	_unit setVariable["JP_type","nighttracker"];
	_unit setBehaviour "SAFE";
	_unit setSpeedMode "LIMITED";
	_units pushback _unit;
};


_posToSpot = [_pos, 3,16, 1, 0, .3, 0] call BIS_fnc_findSafePos;
_wp = _grp addWaypoint [_posToSpot, 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";
_wp setWaypointFormation "LINE";
_wp setWaypointCompletionRadius 5;
_wp setWaypointTimeout [15,17,20];
_wp setWaypointStatements["true","ENEMY_REACH_POINT = true;"];

_posToGo = [_pos, 1600,1700, 1, 0, .3, 0] call BIS_fnc_findSafePos;
_wp2 = _grp addWaypoint [_posToGo, 0];
_wp2 setWaypointType "MOVE";
_wp2 setWaypointBehaviour "SAFE";
_wp2 setWaypointSpeed "LIMITED";
_wp2 setWaypointFormation "LINE";
_wp2 setWaypointCompletionRadius 30;


_sectorToDefend = createMarker ["defenseZone",_pos];
_sectorToDefend setMarkerShape "ELLIPSE";
_sectorToDefend setMarkerSize [_radius,_radius];
_sectorToDefend setMarkerAlpha 1;

OBJECTIVE_DONE = false;

waitUntil {sleep 3; (ENEMY_REACH_POINT && {_x inArea _sectorToDefend} count _units == 0) || ({alive _x && !(captive _x)} count _units < 2)};

OBJECTIVE_DONE = true;


{
	[_taskId,"SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",_x,false];
} foreach units GROUP_PLAYERS;   

[leader GROUP_PLAYERS,"We are not more in danger !"] remoteExec ["JP_fnc_talk"];

// Remove the markers when mission accoplished #64
deleteMarker "defenseZone";

// Delete all units
{ {
	_x call JP_fnc_deleteMarker;
	deleteVehicle _x;
 } foreach crew _x; _x call JP_fnc_deleteMarker; deleteVehicle _x; } foreach _units;

_units = [];

5 fadeMusic 1;