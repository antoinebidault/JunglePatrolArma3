

playMusic "vn_death_scene";
_player = leader GROUP_PLAYERS;
_prisonPos = getPos(missionNamespace getVariable["prison", ""]);
_backpackPos = getPosATL(missionNamespace getVariable["backpack_pos", ""]);
_box = createVehicle ["Box_Syndicate_Ammo_F",_backpackPos,[],0,"CAN_COLLIDE"]; 
clearmagazinecargo _box; 
clearweaponcargo _box;
_box addBackpackCargo [RADIO_BACKPACK_CLASS,1];


// RPG RPG
[_player,localize "STR_JP_voices_captured_leader_1"] remoteExec ["JP_fnc_talk"];
sleep 3;

[_player,localize "STR_JP_voices_captured_leader_2"] remoteExec ["JP_fnc_talk"];

titleCut ["", "BLACK OUT", 3];
sleep 3;
titleCut ["", "BLACK FADED", 9999];
sleep 4;
titleCut ["", "BLACK IN", 3];
"dynamicBlur" ppEffectEnable true;   
"dynamicBlur" ppEffectAdjust [6];   
"dynamicBlur" ppEffectCommit 0;     
"dynamicBlur" ppEffectAdjust [0.0];  
"dynamicBlur" ppEffectCommit 5;  


{
	_x setCaptive true;
	if (_x != _player) then {
		_x setPos (_player modelToWorld [-1, 0,0]);
	};
	_x spawn {
		sleep (5 + (random 3));
		_this action ["surrender",_this];
	};
} foreach (units GROUP_PLAYERS);

_grp = createGroup SIDE_ENEMY;
_nbUnits = 20;
_unit = 360/_nbUnits;
for "_i" from 0 to _nbUnits do {
	_pos = _player getRelPos [10, _unit * _i];
	_enemy = _grp createUnit [ENEMY_LIST_UNITS call BIS_fnc_selectRandom, _pos, [], 0, "NONE"];
	_enemy setCaptive true;
	_enemy doWatch _player;
	_enemy setDir (_enemy getDir _player);
	_enemy setUnitCombatMode "YELLOW";
	_enemy disableAI "MOVE";
};

sleep 20;

titleCut ["", "BLACK OUT", 5];
sleep 5;
titleCut ["", "BLACK FADED", 9999];
playSound "vn_sam_vcaware_009";
sleep 5;
skipTime 5*24;
_date = date;
_date set [3,22];
setDate _date;

 [parseText format ["<t font='PuristaBold' size='1.6'>5 days later</t><br/>%1", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;
sleep 5;
playSound "vn_sam_vcaware_010";
{

 	if (!isPlayer _x) then {
		deleteVehicle _x;
	} else{
 		["JP_primary_extraction","FAILED",true] remoteExec ["BIS_fnc_taskSetState",owner _x,true]; 
		removeAllWeapons _x;
		removeAllItems _x;
		removeBackpack _x;
		removeHeadgear _x;
		removeAllActions _x;
		removeAllAssignedItems _x;
		removeGoggles _x;
		removeVest _x;
		_x addHeadgear "H_HeadBandage_bloody_F";
		_x setPos _prisonPos;
		_x setDamage .3;
		_x setCaptive true;
		_x setUnconscious false;
		_x setVariable["JP_unit_injured", false,false];
	};
	
} foreach (units GROUP_PLAYERS);

player switchMove "Acts_UnconsciousStandUp_part1";
sleep 10;
playSound "vn_sam_vcaware_011";
titleCut ["", "BLACK IN", 5];

 {
	deleteVehicle _x;
} foreach units _grp;

sleep 8; 
savegame;
5 fadeMusic 0;

waitUntil { sleep 1; {_x distance2D _prisonPos > 5} count ([] call JP_fnc_allPlayers) > 0};

{
	_x setCaptive false;
} forEach ([] call JP_fnc_allPlayers);

[_player,localize "STR_JP_voices_captured_leader_3"] remoteExec ["JP_fnc_talk"];

_lz = getMarkerPos "rescue_lz";
sleep 5;
{
 ["JP_primary_scape",_x, ["Recover your radio","Recover your radio","Recover your radio located in the vietcong village"], _backpackPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, true];
} foreach ([] call JP_fnc_allPlayers);

waitUntil {sleep 1;(backpack (_player)) == RADIO_BACKPACK_CLASS};
[_player,localize "STR_JP_voices_captured_leader_4"] call JP_fnc_talk;
[HQ,localize "STR_JP_voices_captured_hq_1"] call JP_fnc_talk;
[_player,localize "STR_JP_voices_captured_leader_5"] call JP_fnc_talk;

[] call vn_fnc_artillery_actions;


_lz = getMarkerPos "rescue_lz";

sleep 5;

_chopper = missionNamespace getVariable ["chopper_secondary", objNull];
_lz = "rescue_lz_2";
[_chopper,_lz] spawn JP_fnc_extractionTask;