/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Trigger when unit is captured.
	A little cutscene is automatically triggered
	The player is moved to a random bastion.

  Parameters:
    0: OBJECT - player

  Returns:
    BOOL - true 
*/


params["_player"];

COMPO_OBJS = [];

_player action [localize "STR_JP_captured_surrender", _player]; 
_player setVariable ["JP_surrender_action", true, false]; 
_player setCaptive true;
_wasTheLeader = (leader GROUP_PLAYERS == _player);

sleep 3;
cutText [localize "STR_JP_captured_captured","BLACK OUT", 7];
sleep 7;

// Find a random building pos at the first floor preferently.
[[_player],{
	params["_player"];
	_heightRequired = 1.5; //m
	_numberPositionRequired = 2; 
	_enemyMarkers =  [];
	{ if (_x select 12 == "bastion") then {_enemyMarkers pushback _x;}; }foreach MARKERS;
	_enemyMarker = _enemyMarkers call BIS_fnc_selectRandom;
	_positionSelected = [];
	_currentPosition = [];
	_foundPosition = [0,0,0];
	_discoveredBuildings = [];
	while {_foundPosition isEqualTo [0,0,0] || count _enemyMarkers > 0} do{
		_enemyMarker = _enemyMarkers call BIS_fnc_selectRandom;
		_enemyMarkers = _enemyMarkers - [_enemyMarker];
		while {_foundPosition isEqualTo [0,0,0] || count _discoveredBuildings <  count (_enemyMarker select 11)} do {
			_currentBuilding = (_enemyMarker select 11) call BIS_fnc_selectRandom;
			_discoveredBuildings pushback _currentBuilding;
			_positions = [_currentBuilding] call BIS_fnc_buildingPositions;
			if (count _positions > _numberPositionRequired) then {
				while { _foundPosition isEqualTo [0,0,0] || count _positions == 0 || (_foundPosition) select 2 > _heightRequired} do {
					_foundPosition = (_positions call BIS_fnc_selectRandom);
					_positions = _positions - [_foundPosition];
				};
			};
		};
	};
	_player setPos _foundPosition;
}] remoteExec ["spawn",2, false];

/*
[[_player],{
	params["_player"];
	_heightRequired = 1.5; //m
	_numberPositionRequired = 7; 
	_enemyMarkers =  [];
	{ if (!(_x select 3)) then {_enemyMarkers pushback _x;}; }foreach MARKERS;
	_enemyMarker = _enemyMarkers call BIS_fnc_selectRandom;
	_pos = getMarkerPos (_enemyMarker select 0);
	_radius =  (getMarkerSize (_enemyMarker select 0)) select 0;
	
	_foundPos = [_pos, 0, _radius, 15, 0, .4, 0,MARKER_WHITE_LIST] call BIS_fnc_findSafePos;
	COMPO_OBJS = [_foundPos,random 360, compo_captured ] call BIS_fnc_ObjectsMapper;
	owner (_player) publicVariableClient "COMPO_OBJS";

	_player setPos [_foundPos select 0,_foundPos select 1,0];

}] remoteExec ["spawn",2, false];
*/
sleep 1;

_loadout = getUnitLoadout _player;
_player action ["Surrender", _player]; 
_player switchMove "Acts_ExecutionVictim_Loop";

/* Remove everything */
RemoveAllWeapons _player;
removeAllAssignedItems _player;
removeBackpack _player;
RemoveAllItems _player;
removeAllActions _player;
removeHeadgear _player;
removeVest _player;
removeGoggles _player;

// Join another isolated group
[_player] joinSilent (createGroup SIDE_FRIENDLY);

_pos = _player  modelToWorld [0,1,0];
_general = (createGroup SIDE_ENEMY) createUnit [ENEMY_COMMANDER_CLASS, _pos,[],AI_SKILLS,"CAN_COLLIDE"];
_general attachTo [_player,[-0.9,-0.2,0]]; 
_general setDir (_general getDir _player); 
_general doWatch _player;
_general execVM "JP\loadout\loadout-commander.sqf";
_general addWeapon "hgun_Pistol_01_F";
_general disableAI "ALL";


// Add a basic pistol
_player setDir (_player getDir _general);
//_general execVM "JP\loadout\loadout-commander.sqf";

_player setDamage .4;


if (!isMultiplayer) then {
	setAccTime 6;
};

cutText [localize "STR_JP_captured_sixHours","BLACK FADED", 7];
sleep 7;
_general switchMove "Acts_Executioner_StandingLoop";
cutText ["","BLACK IN", 7];
sleep 7;

sleep 3;

[_player, localize "STR_JP_voices_teamLeader_hugeMistake"] call JP_fnc_talk;
[_general, localize "STR_JP_voices_general_shutUp"] call JP_fnc_talk;
[_general, localize "STR_JP_voices_general_traitor"] call JP_fnc_talk;

// Animation 
_general switchMove "Acts_Executioner_Backhand";
_player switchMove "Acts_ExecutionVictim_Backhand";
[_player] call JP_fnc_shout;

sleep 3.6;

// Standing loop
_player switchMove "Acts_ExecutionVictim_Loop";
_general switchMove "Acts_Executioner_StandingLoop";
sleep 1;

// Animation 
_general switchMove "Acts_Executioner_Forehand";
_player switchMove "Acts_ExecutionVictim_Forehand";
[_player] call JP_fnc_shout;

sleep 3.6;

// Standing loop
_player switchMove "Acts_ExecutionVictim_Loop";
_general switchMove "Acts_Executioner_StandingLoop";

sleep 5;
cutText [localize "STR_JP_captured_twoDays","BLACK OUT", 3];
sleep 3;
cutText [localize "STR_JP_captured_twoDays","BLACK FADED", 999];
detach _general;
deleteVehicle _general;
sleep 7;

cutText [localize "STR_JP_captured_twoDays","BLACK IN", 3];

if (!isMultiplayer) then {
	setAccTime 44;
};
_player switchMove "Acts_UnconsciousStandUp_part1";
[_player, localize "STR_JP_voices_teamLeader_theGuard"] call JP_fnc_talk;
sleep 10;

_notWatched = true;
_actionId = 0;
while {_notWatched} do
{
	{
		if (_player distance _x < 1.675) then {
			if (_actionId == 0) then {
				_actionId = _player addAction [localize "STR_JP_captured_kill", {
					params ["_target", "_caller", "_actionId", "_arguments"];
					_soldier = _arguments select 0;
					_target switchMove "acts_miller_knockout";
					sleep .4;
					_soldier setDamage 1;
				},[_x],2,true,true,"","_this",1.4,false,""];
			};
		} else {
			if (_actionId != 0) then {
				_player removeAction _actionId;
			};
			_actionId = 0;
		};

		if (side _x == SIDE_ENEMY && _x knowsAbout _player > 1) then{
			_know =  [_x,_player] call JP_fnc_getVisibility; 
			if ([_x,_player] call JP_fnc_getVisibility > 50 && alive _x) then{
				hint localize "STR_JP_captured_beenWatched";
				_notWatched = false;
				_player setCaptive false;
			};
		};
	} foreach allUnits; 

	if ( !alive _player || {side _x == SIDE_FRIENDLY && (_player distance _x) < 10} count allUnits > 0) then {
		_notWatched = false;
	};
	sleep 0.4;
};

hintSilent localize "STR_JP_captured_beenWatched2";

waitUntil { sleep .3; (lifestate _player == "INCAPACITATED")  || { side _x == SIDE_FRIENDLY && (_player distance _x) < 10} count allUnits > 1 };

_player setVariable ["JP_surrender_action", false];

_wasKIA = (lifestate _player == "INCAPACITATED");

_player setUnitLoadout _loadout;
[_player] joinSilent GROUP_PLAYERS;
if (_wasTheLeader) then{group _player selectLeader _player;};

if (_wasKIA) then {
	waitUntil {lifestate _player != "INCAPACITATED"};
	[leader GROUP_PLAYERS, localize "STR_JP_voices_teamLeader_goodToSeeYou"] call JP_fnc_talk;
} else {
	[leader GROUP_PLAYERS, localize "STR_JP_voices_teamLeader_welcomeBack"] call JP_fnc_talk;
	[_player] remoteExec ["JP_fnc_mainobjectiveIntel"];
};

{deleteVehicle _x;} foreach COMPO_OBJS;
