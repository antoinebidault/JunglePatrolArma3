
_chopper = missionNamespace getVariable ["chopper_insertion", objNull];
{
	if (!isPlayer _x) then {
		_x moveInAny _chopper;
	};
} forEach units GROUP_PLAYERS;

_pilot = driver _chopper;
_pilot setCaptive true;
_start = getPos _chopper;
LZ = [];
INSERTION_DONE = false;

{
 ["JP_primary_insertion",_x, ["Board the chopper","Board the chopper","Board the chopper"],getPos _chopper,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",leader GROUP_PLAYERS, true];
} foreach ([] call JP_fnc_allPlayers);

_units = units GROUP_PLAYERS;
waitUntil { {vehicle _x == _chopper} count _units == count _units };

{
 ["JP_primary_insertion","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true]; 
} foreach ([] call JP_fnc_allPlayers);


sleep 2;

[_pilot, localize "STR_JP_voices_pilot_1"] spawn JP_fnc_talk;


JP_fnc_addActionSkipTravel = {
	_lzPos = _this select 0;
	_chopper = _this select 1;
	 // Add action for skipping travel
 	titleCut ["", "BLACK FADED", 999];

	sleep 1;
	_dir =  _chopper getDir _lzPos;
	_newPos = [getPos _chopper, (_chopper distance2D _lzPos) - 500, _dir] call BIS_fnc_relPos; 
	_newPos set [2, 60];
	_chopper setPosATL _newPos;

	titleCut ["", "BLACK IN", 7];
};

{  if (_x find "lz_" == 0 ) then { LZ pushback _x }; }foreach allMapMarkers; 

_lz =  (LZ call BIS_fnc_selectRandom);
CURRENT_LZ = getMarkerPos _lz;
_lzPos = getMarkerPos _lz;
_helipad_obj = "Land_HelipadEmpty_F" createVehicle  _lzPos;
_grp = group _pilot;
private _wp0 = _grp addwaypoint [ _lzPos, 10];
_wp0 setWaypointBehaviour "CARELESS";
_wp0 setWaypointType "MOVE";
_wp0 setWaypointStatements["true", "[CURRENT_LZ] spawn JP_fnc_insertionTrackerTask;"];
_chopper flyInHeight 60;


[] spawn {
	5 fadeMusic 0;

	sleep 10;
	
	_mg = missionNamespace getVariable ["mg", objNull];
	_doc = missionNamespace getVariable ["doc", objNull];

	sleep 1;

	[player, localize "STR_JP_voices_player_helo"] call JP_fnc_talk;
	[_doc, localize "STR_JP_voices_doc_helo"] call JP_fnc_talk;
	[_mg, localize "STR_JP_voices_mg_helo"] call JP_fnc_talk;

	sleep 5; 

	[] spawn JP_fnc_intro;
};


{
 ["JP_primary_insertion2",_x, ["Insert to the LZ","Insert to the LZ","Insert to the LZ"], _lzPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];
} foreach ([] call JP_fnc_allPlayers);

_chopper flyInHeight 40;

private _wp1 = _grp addwaypoint [_lzPos, 1];
_wp1 setWaypointBehaviour "CARELESS";
_wp1 setWaypointSpeed "FULL";
_wp1 setWaypointType "TR UNLOAD";
_wp1 setWaypointStatements ["{vehicle _x == vehicle this} count units GROUP_PLAYERS == 0;","INSERTION_DONE = true;(vehicle this) land ""GET IN""; GROUP_PLAYERS  leaveVehicle (vehicle this);[""JP_primary_insertion2"",""SUCCEEDED"",true] remoteExec [""BIS_fnc_taskSetState"",GROUP_PLAYERS,true]; [] spawn JP_fnc_reconTask;"];


private _wp2 = _grp addwaypoint [_start, 1];
_wp2 setWaypointBehaviour "CARELESS";
_wp2 setWaypointType "MOVE";
_wp2 setWaypointStatements ["true", "(vehicle this) land ""GET IN"";"];
_chopper setDamage 0;
_chopper setFuel 1;

sleep 30;

_actionId = player addAction [format["<t color='#cd8700'>Skip travel</t>"],{
	params["_unit","_caller","_actionId","_arguments"];
	_unit removeAction _actionId;
	_arguments spawn JP_fnc_addActionSkipTravel;
},[_lzPos,_chopper],2.5,false,true,"","true",20,false,""];

hint "You can skip the travel using the action menu";

waitUntil { (getPos _chopper) distance2D _lzPos < 500; };

player removeAction _actionId;

SUPPORT_ENABLED = true;
publicVariable "SUPPORT_ENABLED";
[HQ, localize "STR_JP_voices_HQ_supportAvailable"] spawn JP_fnc_talk;

true;