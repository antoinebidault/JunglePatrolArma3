
params["_chopper","_lz"];

playMusic "vn_hell_on_earth";


_chopper setFuel 1;
_pilot = driver _chopper;
_pilot setCaptive true;
_start = getPos _chopper;
LZ = [];
EXTRACTION_DONE = false;

_lz setMarkerAlpha 1;
_lzPos = getMarkerPos _lz;
[leader GROUP_PLAYERS, _lzPos ,16] spawn JP_fnc_spawnAvalanche;
_helipad_obj = "Land_HelipadEmpty_F" createVehicle getMarkerPos _lz;

{
 ["JP_primary_extraction",_x, ["Extraction","Extraction","Extraction"],_lzPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, true];
} foreach ([] call JP_fnc_allPlayers);

if (_lz == "rescue_lz") then {
	waitUntil {sleep 3; (leader GROUP_PLAYERS) distance2D _lzPos < 300};
	[] spawn JP_fnc_capturedTask;
};

waitUntil {sleep 3; (leader GROUP_PLAYERS) distance2D _lzPos < 100};

_wp0 = (group _pilot) addWaypoint[getMarkerPos _lz,2];
_wp0 setWaypointType "MOVE";
_wp0 setWaypointBehaviour "CARELESS";
_wp0 setWaypointStatements ["true", "(vehicle this) land ""GET IN"";"];


_units = units GROUP_PLAYERS;
waitUntil { sleep 1; {vehicle _x == _chopper} count _units == count _units };

ENABLE_AVALANCHE = false;

{
 ["JP_primary_extraction","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true]; 
} foreach ([] call JP_fnc_allPlayers);

sleep 1;

//[_pilot, localize "STR_JP_voices_pilot_1"] spawn JP_fnc_talk;

private _wp1 = (group _pilot) addwaypoint [_start, 1];
_wp1 setWaypointBehaviour "CARELESS";
_wp1 setWaypointType "MOVE";
_wp1 setWaypointStatements ["true", "(vehicle this) land ""GET IN""; GROUP_PLAYERS  leaveVehicle (vehicle this); EXTRACTION_DONE = true;"];
_chopper setDamage 0;
_chopper setFuel 1;

waitUntil {sleep 3; EXTRACTION_DONE};
{
 ["JP_primary_extraction",_x, ["Grab a beer","Grab a beer","Grab a beer"],_lzPos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, true];
} foreach ([] call JP_fnc_allPlayers);

private _wp2 = GROUP_PLAYERS addwaypoint [getMarkerPos "endmission", 2];
_wp2 setWaypointStatements ["true", " END_MISSION = true;"];
waitUntil {END_MISSION};
playMusic "vn_freedom_bird";

_txtCnd = format["<t font='tt2020style_e_vn_bold' color='#FFF'>%1</t>", "Good job mate ! Grab a beer !"];
[_txtCnd,0,.5,5,0] spawn BIS_fnc_dynamicText;

sleep 20;

"EveryoneWon" call BIS_fnc_endMission;
true;