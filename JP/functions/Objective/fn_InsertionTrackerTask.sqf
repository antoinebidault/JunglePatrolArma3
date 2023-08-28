
// Lz position
[leader GROUP_PLAYERS, "Look ! There is a small group of watchers spotting at us ! It smells not good... If they reach their position, they will call reinforcements ! I've recently hear they have created some special units for tracking !"] spawn JP_fnc_talk;
_lzPos = _this select 0;
_lzPos set [2, 0];
_nbGuards = 1 + round(random 2);
_grp = createGroup SIDE_ENEMY;
_pos = [_lzPos, 120, 150, 1, 0, 2, 0] call BIS_fnc_findSafePos;
_units = [];

{
 ["JP_primary_insertion3",_x, ["Kill the watchers","Kill the watchers","Kill a small group of watchers before they call reinforcements"], _pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];
} foreach ([] call JP_fnc_allPlayers);

for "_i" from 1 to _nbGuards do {
	_enemy = [_grp,_pos,false] call JP_fnc_spawnEnemy;
	_enemy setVariable["JP_type","trackerInsertion"];
	_units pushBack _enemy;
	_enemy setUnitPos (if (random 1 > 0.5) then {"MIDDLE";} else {"DOWN";});
};

_nextPos = [_lzPos, 120, 150, 1, 0, 2, 0] call BIS_fnc_findSafePos;

_wp0 = _grp addWaypoint [_nextPos,4];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointBehaviour "STEALTH";

waitUntil { INSERTION_DONE };

{
	_x setUnitPos "AUTO";
} forEach  units _grp;

_nextPos = [_lzPos, 500, 550, 4, 0, 2, 0] call BIS_fnc_findSafePos;
_wp1 = _grp addWaypoint [_nextPos, 4];
_wp1 setWaypointType "MOVE";
_wp1 setWaypointBehaviour "AWARE";
_wp1 setWaypointStatements ["true", "[leader GROUP_PLAYERS] spawn JP_fnc_spawnChaser;CHASER_TRIGGERED = true; [""JP_primary_insertion3"",""FAILED"",true] remoteExec [""BIS_fnc_taskSetState"",GROUP_PLAYERS,true];"];


waitUntil { ({ alive _x || captive _x } count units _grp == 0 && !("JP_primary_insertion3" call BIS_fnc_taskCompleted)) ||  ("JP_primary_insertion3" call BIS_fnc_taskCompleted)};


[leader GROUP_PLAYERS, "Good job ! The watchers have been neutralized !"] spawn JP_fnc_talk;
if (!("JP_primary_insertion3" call BIS_fnc_taskCompleted)) then {
	["JP_primary_insertion3","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
} else{
	["JP_primary_insertion3","FAILED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
};