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

	sleep 1;

	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_radio1"] spawn JP_fnc_talk;
	[_rto, localize "STR_JP_voices_rto_radio1"] spawn JP_fnc_talk;
	[_mg, localize "STR_JP_voices_mg_radio1"] spawn JP_fnc_talk;
	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_radio2"] spawn JP_fnc_talk;