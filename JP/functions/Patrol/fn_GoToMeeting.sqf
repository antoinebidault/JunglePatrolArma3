/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Make a unit go to the meeting point

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

params["_unit","_meetingPoint"];
private _friend = objNull;

if (isNil '_meetingPoint') exitWith {false;};
if (count _meetingPoint != 3) exitWith {false;};
if (!alive _unit || stopped _unit) exitWith{false;};
if (_unit getVariable["civ_affraid",false]) exitWith{false;};

_anims = ["STAND","STAND_IA","WATCH","WATCH1","WATCH2"];
//_group allowFleeing 0;
//{_unit disableCollisionWith _x;}foreach _chairs;
//{_unit disableCollisionWith _x;}foreach _objs;

private _newPos =  [_meetingPoint ,.6,1.5,.25, 0, 20, 0] call BIS_fnc_findSafePos;//[[[_meetingPoint, 2]],[[_meetingPoint,1]]] call BIS_fnc_randomPos;
_unit doMove _newPos;
_timer = time;

sleep 1;

waitUntil {unitReady _unit || _unit distance _newPos < 2 || !alive _unit || time > _timer + 500 };
if (time > _timer + 149 || !alive _unit ) exitWith{false;}; 
sleep 5;
_unit setPos _newPos;



if (side _unit == SIDE_CIV )then{
	_animPossible = ["Acts_CivilListening_1","Acts_CivilListening_2","acts_StandingSpeakingUnarmed"];
	/*if (count _chairFound > 0) then {
		[_unit, "SIT", "NONE"] call BIS_fnc_ambientAnim;
		sleep  (10 + random 350);
		_unit spawn BIS_fnc_ambientAnim__terminate;
	}else{*/
		_unit doWatch _newPos;
		_unit setDir ([_unit,_newPos] call BIS_fnc_dirTo);
		if (random 1 > .5)then{
			private _anim = (_animPossible call BIS_fnc_selectRandom);
			_unit switchMove _anim;
			friends = nearestObjects [position _unit,["Man"],5];
			if ({side _x == side _unit} count friends > 0) then {
				_friend = (friends call BIS_fnc_selectRandom);
				_unit doWatch _friend;
			};
			sleep  (10 + random 50);
			[_unit, ""] remoteExec ["switchMove"];
		} else {
			_unit stop true;
			sleep 3;
			_unit action ["sitdown",_unit];
			sleep  (10 + random 50);
			_unit stop false;
		};
	//};
}else{
	
	friends = nearestObjects [position _unit,["Man"],3];

	if ({side _x == side _unit} count friends > 0) then {
		_friend = (friends call BIS_fnc_selectRandom);
		_unit doWatch _friend;
		_friend lookAt _unit;
		//_unit setDir ([_unit,_friend] call BIS_fnc_dirTo);
		//_friend setDir ([_friend,_unit] call BIS_fnc_dirTo);
		_unit stop true;
		[_unit, "salute"] remoteExec ["playAction"];
		sleep 2;	
		[_unit, "salute"] remoteExec ["saluteOff"];
		sleep 2;	
		_unit stop false;	
	};

	_unit doWatch _newPos;
	//_unit setDir ([_unit,_newPos] call BIS_fnc_dirTo);
	if (random 10 > 5)then{
		[_unit,_anims call BIS_fnc_selectRandom,"FULL"] remoteExec["BIS_fnc_ambientAnimCombat"];
		if ({side _x == side _unit} count friends > 0) then {
			_unit doWatch _friend;
		};
		sleep  (10 + random 50);
		[_unit] remoteExec ["BIS_fnc_ambientAnim__terminate"];
	}else{
		_unit stop true;
		sleep 3;
		_unit action ["sitdown",_unit];
		sleep  (10 + random 50);
		_unit stop false;
	};

};
sleep 10 + random 50;
true;