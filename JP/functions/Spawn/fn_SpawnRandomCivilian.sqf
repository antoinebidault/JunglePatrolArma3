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


if (!isServer) exitWith{false};
private _numberOfmen = 1;
private _minRange = 450;
private _maxRange = SPAWN_DISTANCE;
private _firstTrigger = true; 

while{true}do {
	if ({ _x getVariable["JP_Type",""] == "civpatrol" && alive _x } count UNITS_SPAWNED_CLOSE  < MAX_RANDOM_CIVILIAN)then{

		//Get random pos
		if (_firstTrigger) then {_minRange = 1; _firstTrigger = false;}else{_minRange = 450;};
		_pos = [position (([] call JP_fnc_allPlayers) call BIS_fnc_selectRandom), _minRange, _maxRange, 1, 0, 2, 0, MARKER_WHITE_LIST + PLAYER_MARKER_LIST,[]] call BIS_fnc_findSafePos;
		if (_pos isEqualTo [] || _pos isEqualTo [2048,2048,2048]) then {
			sleep 2;
		} else {
			_numberOfmen =  1;
			_group = createGroup SIDE_CIV;

			for "_j" from 1 to _numberOfmen do {
				_unit = [_group,_pos] call JP_fnc_spawnCivil;
				_unit setVariable["JP_Type","civpatrol"]; // overload
				_unit setBehaviour "SAFE";
				sleep .4;
			};
			
			// Send group to HC
			[_group,"JP_fnc_civilianPatrol", [_group]] call JP_fnc_patrolDistributeToHC;

			//[_group] spawn JP_fnc_civilianPatrol;
		};
	};	


	sleep 12;
};