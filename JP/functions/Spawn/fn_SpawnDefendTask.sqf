

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

params["_pos", "_radius"];

_units = [];
_nbGroups = ceil(random 2);

_taskId = format["JP_defend_%1",str (random 999)];

[HQ,format[localize "STR_JP_voices_HQ_enemyGroups",_nbGroups]] remoteExec ["JP_fnc_talk"];
{
	[_taskId, _x, [localize "STR_JP_spawnDefendTask_taskDesc",localize "STR_JP_spawnDefendTask_taskName",localize "STR_JP_spawnDefendTask_taskName"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, false];
} foreach units GROUP_PLAYERS;     
// STAT_INTEL_FOUND = STAT_INTEL_FOUND + 1;

/*
_unitsInCompound = _compound select 5;
{
	if (side _x == SIDE_CIV) then {
		[_x] joinSilent (createGroup SIDE_FRIENDLY);
	};
}
foreach _unitsInCompound;
*/

for "_j" from 1 to _nbGroups do {

	_grp = createGroup SIDE_ENEMY;
	_spawnPos = [_pos, 250,350, 1, 0, .3, 0] call BIS_fnc_findSafePos;
	_nbUnits =  4 + floor(random 4); 

	for "_xc" from 1 to _nbUnits  do {
		_unit =[_grp,_spawnPos,true] call JP_fnc_spawnEnemy;
		_unit setBehaviour "AWARE";
		_unit setSpeedMode "FULL";
		_unit enableDynamicSimulation false;
		_units pushback _unit;
	};

		
	_mkrName = format["JP_defend_%1",str _j];
	if (getMarkerColor _mkrName !="") then{
		deleteMarker _mkrName;
	};

	// Calculate direction for the marker
	_dir = round([_spawnPos,_pos] call BIS_fnc_dirTo);

	_marker = createMarker [_mkrName,_spawnPos];
	_marker setMarkerShape "ICON";
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText "Defend !";
	_marker setMarkerType "hd_arrow";
	_marker setMarkerDir _dir;

	_wp = _grp addWaypoint [_pos, 0];
	_wp setWaypointType "SAD";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointFormation "LINE";
	_wp setWaypointCompletionRadius 30;
	sleep 30;
};

_sectorToDefend = createMarker ["defenseZone",_pos];
_sectorToDefend setMarkerShape "ELLIPSE";
_sectorToDefend setMarkerSize [_radius,_radius];
_sectorToDefend setMarkerAlpha 1;

DEFEND_TASK = true;

[] spawn {
	while { DEFEND_TASK } do{
		_flrObj = "F_40mm_white" createvehicle ((leader GROUP_PLAYERS) modelToWorld [50-round(random 25),50-round(random 25),200]); 
		_flrObj setVelocity [0,0,-.1];
		sleep 100;
	};
};

waitUntil {sleep 3; ({_x inArea _sectorToDefend} count (units GROUP_PLAYERS) == 0 && {_x inArea _sectorToDefend} count _units >= 2) || ({ _x distance (_pos) > SPAWN_DISTANCE } count (units GROUP_PLAYERS) == count (units GROUP_PLAYERS)) || ({alive _x && !(captive _x)} count _units < 2) };

DEFEND_TASK = false;

// If eliminated
if ({(alive _x) && !(captive _x)} count _units <= 2) then {

	{
		[HQ, localize "STR_JP_voices_HQ_taskDefendSuccess"] remoteExec ["JP_fnc_talk",_x,false];
		[_taskId,"SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",_x,false];
	} foreach ([] call JP_fnc_allPlayers);    
	OBJECTIVE_DONE = true;
	publicVariable "OBJECTIVE_DONE";

} else {
	// Player too far from position
	{
		[HQ, localize "STR_JP_voices_HQ_taskDefendSuccess"] remoteExec ["JP_fnc_talk",_x,false];
		[_taskId,"FAILED",true] remoteExec ["BIS_fnc_taskSetState",_x,false];
	} foreach ([] call JP_fnc_allPlayers);       

	"LOSER" call BIS_fnc_endMission;
};



// Remove the markers when mission accoplished #64
deleteMarker "defenseZone";
for "_j" from 1 to _nbGroups do {	
	_mkrName = format["JP_defend_%1",str _j];
	if (getMarkerColor _mkrName !="") then{
		deleteMarker _mkrName;
	};
};

// Delete all units
{ { _x call JP_fnc_deleteMarker; deleteVehicle _x; } foreach crew _x; _x call JP_fnc_deleteMarker; deleteVehicle _x; } foreach _units;

_units = [];

