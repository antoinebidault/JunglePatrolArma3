/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Player's surrendering system 

  Parameters:
    0: OBJECT - player

  Returns:
    BOOL - true 
*/

params["_player"];

sleep 15;

_actionId = -1;
_timer = time;
while { true } do {

	// If player is in bad situation
	if ( alive player 
	&& !(player getVariable ["JP_surrender_action", false]) 
	&& (damage player > .3 || morale player < -0.5)
	&& (player findNearestEnemy player) distance player < 60 
	&& { _x distance player < 100 } count units GROUP_PLAYERS == 1
	&& _actionId == -1
	) then {
		[player] call JP_fnc_shout;
		_timer = time;
		if (_actionId == -1) then {
			playMusic "vn_death_scene";
			_actionId = player addAction [localize "STR_JP_captured_surrender",{
				params ["_target", "_caller", "_actionId", "_arguments"];
				_caller removeAction _actionId;
				[_caller] spawn JP_fnc_captured;
			},nil,1,true,true];
		};
	} else {
		if (time > _timer + 60) then {
			if (_actionId != -1) then {
				player removeAction _actionId;
			};
			_actionId = -1;
		};
	};
	sleep 5;
};

