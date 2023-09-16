/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Global scope variables declarations
*/
 

 if (didJIP) exitWith {};

waitUntil {count ([] call JP_fnc_allPlayers) > 0};

STAT_SUPPORT = 0;
publicVariable "STAT_SUPPORT";

SUPPORT_ENABLED = false;
publicVariable "SUPPORT_ENABLED";

// List of base names
BASE_NAMES = ["alpha","bravo","charlie","delta","echo","foxtrot"];
publicVariable "BASE_NAMES";

// True if the mission is set up and started up.
INSERTION_DONE = false;
publicVariable "INSERTION_DONE";

// True if the mission is set up and started up.
JP_STARTED = false;
publicVariable "JP_STARTED";

// Triggered when the admin is on the loadout panel
JP_LOADOUT = false;
publicVariable "JP_LOADOUT";

GROUP_PLAYERS = group (([] call JP_fnc_allPlayers) select 0); 
publicVariable "GROUP_PLAYERS";

SIDE_FRIENDLY = side(([] call JP_fnc_allPlayers) select 0); //Side player
publicVariable "SIDE_FRIENDLY";

// True when triggered
CHASER_TRIGGERED = false;
publicVariable "CHASER_TRIGGERED";

// True when triggered
CHASER_TIMEOUT = 0;
publicVariable "CHASER_TIMEOUT";

// True if the chase is triggered by any friendly player
CHASER_VIEWED = false;
publicVariable "CHASER_VIEWED";

// Score store
JP_SCORE = 0;
publicVariable "JP_SCORE";

CAMP_RESPAWN_POSITION = [];
publicVariable "CAMP_RESPAWN_POSITION";

// Respawn position id
CAMP_RESPAWN_POSITION_ID = [];
publicVariable "CAMP_RESPAWN_POSITION_ID";

// List of player's marker
PLAYER_MARKER_LIST = []; 
publicVariable "PLAYER_MARKER_LIST";

// List of ieds object spawned on the map
IEDS = [];
publicVariable "IEDS";

// Crash sites
CRASHSITES  = [];
publicVariable "CRASHSITES";

// List of markers to exclude from enemy & civilian path
MARKER_WHITE_LIST = []; 
publicVariable "MARKER_WHITE_LIST";

REMAINING_INTEL = 12;
publicVariable "REMAINING_INTEL";

// Create a marker base if it does not exists
if (getMarkerColor "marker_base" == "") then {
	_markerBase = createMarker ["marker_base", getPos leader GROUP_PLAYERS];
	_markerBase setMarkerShape "ELLIPSE";
	_markerBase setMarkerBrush "Border";
	_markerBase setMarkerSize [600,600];
	_markerBase setMarkerColor "ColorGreen";
};

OBJECTIVES = ["convoy","hostage","tank","officer","wreck","cache"];
publicVariable "OBJECTIVES";

CURRENT_OBJECTIVE = ["",[0,0,0],1500,"",objNull];
publicVariable "CURRENT_OBJECTIVE";

MAX_OBJECTIVES = 3;
publicVariable "MAX_OBJECTIVES";

REMAINING_OBJECTIVES = MAX_OBJECTIVES;
publicVariable "REMAINING_OBJECTIVES";

NIGHT_EVENTS_POOL = ["patrol","defend","mortar", "animal"];

START_POSITION = getMarkerPos "marker_base";
publicVariable "START_POSITION";

SLEEP_POSITIONS = [];
for "_i" from 0 to 10 do {
 _place = missionNamespace getVariable [format["sleep_%1", _i], objNull];
 if (!isNull _place) then {
  SLEEP_POSITIONS pushBack _place;
 };
};
publicVariable "SLEEP_POSITIONS";

HOSTAGE_POSITIONS = [];
for "_i" from 0 to 3 do {
 _place = missionNamespace getVariable [format["hostage_%1", _i], objNull];
 if (!isNull _place) then {
  HOSTAGE_POSITIONS pushBack _place;
 };
};
publicVariable "HOSTAGE_POSITIONS";

WRECK_POSITIONS = [];
for "_i" from 0 to 3 do {
 _place = missionNamespace getVariable [format["wreck_%1", _i], objNull];
 if (!isNull _place) then {
  WRECK_POSITIONS pushBack _place;
 };
};
publicVariable "WRECK_POSITIONS";

TANK_POSITIONS = [];
for "_i" from 0 to 3 do {
 _place = missionNamespace getVariable [format["tank_%1", _i], objNull];
 if (!isNull _place) then {
  TANK_POSITIONS pushBack _place;
 };
};
publicVariable "TANK_POSITIONS";

OFFICER_POSITIONS = [];
for "_i" from 0 to 3 do {
 _place = missionNamespace getVariable [format["officer_%1", _i], objNull];
 if (!isNull _place) then {
  OFFICER_POSITIONS pushBack _place;
 };
};
publicVariable "OFFICER_POSITIONS";


CACHE_POSITIONS = [];
for "_i" from 0 to 3 do {
 _place = missionNamespace getVariable [format["cache_%1", _i], objNull];
 if (!isNull _place) then {
  CACHE_POSITIONS pushBack _place;
 };
};
publicVariable "CACHE_POSITIONS";

