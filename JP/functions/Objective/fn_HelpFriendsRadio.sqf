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
_mg = missionNamespace getVariable ["mg", objNull];
_rto = missionNamespace getVariable ["rto", objNull];
_teamLeader = missionNamespace getVariable ["danger_team_leader", objNull];

sleep 125;

[_rto, localize "STR_JP_voices_helpFriendsRadio_rto_1"] call JP_fnc_talk;
[_teamLeader, localize "STR_JP_voices_helpFriendsRadio_lostleader_1"] call JP_fnc_talk;
[_rto, localize "STR_JP_voices_helpFriendsRadio_rto_2"] call JP_fnc_talk;
[_rto, localize "STR_JP_voices_helpFriendsRadio_rto_3"] call JP_fnc_talk;
[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriendsRadio_leader_1"] call JP_fnc_talk;
[_mg, localize "STR_JP_voices_helpFriendsRadio_mg_1"] call JP_fnc_talk;
[leader GROUP_PLAYERS, localize "STR_JP_voices_helpFriendsRadio_leader_2"] call JP_fnc_talk;