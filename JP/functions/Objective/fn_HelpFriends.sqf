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
	_doc = missionNamespace getVariable ["doc", objNull];

	sleep 1;

  [_teamLeader, localize "STR_JP_voices_helpFriends_lostleader_1"] remoteExec ["JP_fnc_talk"];
	[_rto, localize "STR_JP_voices_helpFriends_rto_1"] remoteExec ["JP_fnc_talk"];
  

 ["JP_charlie_rescue_coyote", GROUP_PLAYERS, ["Rescue COYOTE-01 team","Reach the team in danger","Reach the team in danger and rescue them"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];


	[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriends_leader_1"] remoteExec ["JP_fnc_talk"];
	[_mg, localize "STR_JP_voices_helpFriends_mg_1"] remoteExec ["JP_fnc_talk"];
	[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriends_leader_2"] remoteExec ["JP_fnc_talk"];
	[_mg, localize "STR_JP_voices_helpFriends_mg_2"] remoteExec ["JP_fnc_talk"];
	[_mg, localize "STR_JP_voices_helpFriends_doc_1"] remoteExec ["JP_fnc_talk"];


waitUntil { sleep 3; leader GROUP_PLAYERS distance2D _teamLeader < 150 };

_woundedUnits = [missionNamespace getVariable ["wounded_1", objNull],missionNamespace getVariable ["wounded_2", objNull]];
{
  _x setCaptive true;
  _x setUnconscious true;
  _x setHit ["legs", 1]; 
  _x spawn{ _this call JP_fnc_addActionHeal; };
}foreach _woundedUnits;

waitUntil { sleep 3; leader GROUP_PLAYERS distance2D _teamLeader < 10 };


[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriends_leader_3"] remoteExec ["JP_fnc_talk"];
[_teamLeader, localize "STR_JP_voices_helpFriends_lostleader_2"] remoteExec ["JP_fnc_talk"];
[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriends_leader_4"] remoteExec ["JP_fnc_talk"];


{
 ["JP_charlie_rescue_coyote","SUCCEEDED"] remoteExec ["BIS_fnc_taskSetState",_x, true];
} foreach ([] call JP_fnc_allPlayers);

sleep 1;

{
 ["JP_charlie_first_aid",_x, ["Give first aid to wounded","Give first aid to wounded","Give first aid to the both unit wouned"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

waitUntil { sleep 3; {lifeState _x == "INCAPACITATED" } count units (group _teamLeader) == 0; };

{
 ["JP_charlie_first_aid","SUCCEEDED"] remoteExec ["BIS_fnc_taskSetState",_x, true];
} foreach ([] call JP_fnc_allPlayers);

[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriends_leader_5"] remoteExec ["JP_fnc_talk"];
[_teamLeader, localize "STR_JP_voices_helpFriends_lostleader_3"] remoteExec ["JP_fnc_talk"];

// _lz = missionNamespace getVariable["lz_medevac", ""];
_lzPos = getMarkerPos "lz_1";
_helipad_obj = "Land_HelipadEmpty_F" createVehicle _lzPos;

["JP_charlie_extract",GROUP_PLAYERS, ["Extract Coyote-01","Extract Coyote-01","Extract Coyote-01"],_lzPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];

CHASER_TRIGGERED = true;
publicVariable "CHASER_TRIGGERED";
CHASER_TIMEOUT = time + 5 * 60;
publicVariable "CHASER_TIMEOUT";

//[_teamLeader,_lzPos ,16] spawn JP_fnc_spawnAvalanche;

{
  _x switchMove "";
  _x setCaptive true;
  _x setUnitPos "AUTO";
  _x setBehaviour "AWARE";
  _x enableAI "MOVE";
} forEach units _teamLeader;

/*
while {alive _teamLeader && leader GROUP_PLAYERS distance2d _lzPos > 60} do
{
  _teamLeader move (position (leader GROUP_PLAYERS));
  sleep 3;
};*/
_destPos =_helipad_obj modelToWorld [30,30,0];
_wp0 = (group _teamLeader) addWaypoint[_destPos,10];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointSpeed "FULL";
_wp0 setWaypointBehaviour "AWARE";

waitUntil {sleep 1; alive _teamLeader && _teamLeader distance2d _lzPos < 60};

[_teamLeader, localize "STR_JP_voices_helpFriends_rto_2"] spawn JP_fnc_talk;
_medic_chopper = [GROUP_PLAYERS] call JP_fnc_spawnHelo;
_pilot = driver _medic_chopper;
_pilot setCaptive true;
_pilot allowDamage false;
_medic_chopper allowDamage false;

// Startup the chopper path
[_lzPos,_medic_chopper,group _teamLeader] spawn JP_fnc_chopperPath;

waitUntil {{vehicle _x == _medic_chopper} count _woundedUnits == count _woundedUnits }; 

[_teamLeader, localize "STR_JP_voices_helpFriends_lostleader_4"] spawn JP_fnc_talk;

["JP_charlie_extract","SUCCEEDED"] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS, true];

sleep 5;

ENABLE_AVALANCHE = false;

[] spawn JP_fnc_sleepTask;
