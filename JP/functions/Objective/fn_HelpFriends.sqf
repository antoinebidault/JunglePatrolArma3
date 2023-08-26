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
_medic_chopper = missionNamespace getVariable ["medic_chopper", objNull];
_pilot = driver _medic_chopper;
_pilot setCaptive true;
_teamLeader = missionNamespace getVariable ["danger_team_leader", objNull];
_teamLeader setCaptive true;
_pos = getPos _teamLeader;
_woundedUnits = [];
{ 
	if (damage _x > 0) then{
		_x setCaptive true;
		_woundedUnits pushBack _x;
	};
} forEach units group _teamLeader;

{
 ["JP_primary_help_friends",_x, ["Rescue Hotel-6 team","Reach the team in danger","Reach the team in danger and rescue"],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);

[_teamLeader,_pos ,16] spawn JP_fnc_spawnAvalanche;


waitUntil {{vehicle _x == _medic_chopper} count _woundedUnits == count _woundedUnits }; 

{
 ["JP_primary_help_friends","SUCCEEDED"] remoteExec ["BIS_fnc_setTask",_x, true];
} foreach ([] call JP_fnc_allPlayers);
