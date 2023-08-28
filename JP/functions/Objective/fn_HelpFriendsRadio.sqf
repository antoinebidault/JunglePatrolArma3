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

	sleep 125;

	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue1"] spawn JP_fnc_talk;
	[_rto, localize "STR_JP_voices_rto_rescue1"] spawn JP_fnc_talk;
	[_mg, localize "STR_JP_voices_mg_rescue1"] spawn JP_fnc_talk;
	[leader GROUP_PLAYERS, localize "STR_JP_voices_player_rescue2"] spawn JP_fnc_talk;