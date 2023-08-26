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
if (!isServer) exitWith{};

params ["_group","_bonus","_silent", "_unit"];
private _silent = if (isNil "_silent") then{ false } else { _silent };

JP_SCORE = (JP_SCORE + _bonus);
publicVariable "JP_SCORE"; 
private _scoreType = if (_bonus > 0) then {"+"}else{""};

if (!_silent)then{
	["ScoreAdded",[format["Total points = %1",str JP_SCORE],_bonus,_scoreType]] remoteExec ["BIS_fnc_showNotification", _group, false];
};

[] remoteExec ["JP_fnc_displayscore",_group, false];
