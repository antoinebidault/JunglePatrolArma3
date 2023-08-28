/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Task for helping a group of lost soldiers 

  Returns:
    units
*/
Medevac_state = "initial";
_teamLeader = missionNamespace getVariable ["danger_team_leader", objNull];
_pos = getPos _teamLeader;


	_mg = missionNamespace getVariable ["mg", objNull];
	_rto = missionNamespace getVariable ["rto", objNull];

	sleep 1;

	[_rto, localize "STR_JP_voices_rto_rescue2"] spawn JP_fnc_talk;
	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue3"] spawn JP_fnc_talk;
	[_mg, localize "STR_JP_voices_mg_rescue2"] spawn JP_fnc_talk;
	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue4"] spawn JP_fnc_talk;
	[_mg, localize "STR_JP_voices_mg_rescue3"] spawn JP_fnc_talk;

_medic_chopper = [GROUP_PLAYERS] call JP_fnc_spawnHelo;
_pilot = driver _medic_chopper;
_pilot setCaptive true;

{
 ["JP_charlie_help_friends",_x, ["Rescue Hotel-6 team","Reach the team in danger","Reach the team in danger and rescue them"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue4"] spawn JP_fnc_talk;
[_teamLeader, localize "STR_JP_voices_lostleader_1"] spawn JP_fnc_talk;
[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue5"] spawn JP_fnc_talk;

waitUntil { sleep 3; leader GROUP_PLAYERS distance2D _teamLeader < 150 };

_woundedUnits = [missionNamespace getVariable ["wounded_1", objNull],missionNamespace getVariable ["wounded_2", objNull]];
{
  _x setCaptive true;
  _x setUnconscious true;
  _x setHit ["legs", 1]; 
  _x spawn{ _this call JP_fnc_addActionHeal; };
}foreach _woundedUnits;

waitUntil { sleep 3; leader GROUP_PLAYERS distance2D _teamLeader < 10 };

{
 ["JP_charlie_help_friends","SUCCEEDED"] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

{
 ["JP_charlie_first_aid",_x, ["Give first aid to wounded","Give first aid to wounded","Give first aid to the both unit wouned"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

waitUntil { sleep 3; {lifeState _x == "INCAPACITATED" } count units (group _teamLeader) == 0; };

{
 ["JP_charlie_first_aid","SUCCEEDED"] remoteExec ["BIS_fnc_taskSetState",_x, true];
} foreach ([] call JP_fnc_allPlayers);

[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue6"] spawn JP_fnc_talk;
[leader _rto, localize "STR_JP_voices_player_rescue3"] spawn JP_fnc_talk;

_lz = missionNamespace getVariable["lz_medevac", ""];
_lzPos = getPos(_lz);
_helipad_obj = "Land_HelipadEmpty_F" createVehicle _lzPos;

{
 ["JP_charlie_extract",_x, ["Extract Charlie-3","Extract Charlie-3","Extract Charlie-3"],_lzPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

// Startup the chopper path
[_lzPos,_medic_chopper,group _teamLeader] spawn JP_fnc_chopperPath;
[_teamLeader,_pos ,16] spawn JP_fnc_spawnAvalanche;

{
  _x switchMove "";
  _x setCaptive true;
  _x setUnitPos "AUTO";
  _x setBehaviour "AWARE";
  _x enableAI "MOVE";
} forEach units _teamLeader;


_wp0 = (group _teamLeader) addWaypoint[_lz modelToWorld[10, 5, 0],10];
_wp0 setWaypointType "MOVE";

waitUntil {{vehicle _x == _medic_chopper} count _woundedUnits == count _woundedUnits }; 

{
 ["JP_charlie_extract","SUCCEEDED"] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

sleep 5;

ENABLE_AVALANCHE = false;

[] spawn JP_fnc_sleepTask;
