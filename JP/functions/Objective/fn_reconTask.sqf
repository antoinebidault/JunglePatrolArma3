if (!isServer) exitWith { false };

sleep 2;

 10 fadeMusic 0;

_objective = OBJECTIVES call BIS_fnc_selectRandom;
OBJECTIVES = OBJECTIVES - [_objective];

_mkr = createMarker ["recon_zone",[0,0,0]];
_mkr setMarkerShape "Ellipse";
_mkr setMarkerText "Recon area";
_mkr setMarkerSize [1500,1500];

_mkr2 = createMarker ["recon_zone_text",[0,0,0]];
_mkr2 setMarkerShape "ICON";
_mkr2 setMarkerType "mil_dot";
_mkr2 setMarkerColor "ColorRed";
_mkr2 setMarkerText "Recon area";

["JP_primary_recon",GROUP_PLAYERS, ["Recon","Recon","Perform a reconnaissance in enemy territory (red marker)."],nil,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];
// _mkr setMarkerBrush "SolidBorder";

_position = [0,0,0];
_units = [];
_noMarker = false;

switch (_objective) do {
	case "hostage": {
		_marker = HOSTAGE_POSITIONS call BIS_fnc_selectRandom;
		_building = nearestBuilding _marker;
		_position = getPos _building;
		_units = [_position,20,1,[_building]] call JP_fnc_hostage;
	};
	case "officer": {
		_position = getPos(OFFICER_POSITIONS call BIS_fnc_selectRandom);
		_units = [_position] call JP_fnc_spawnOfficer;
	 };
	  case "convoy": {
		_noMarker = true;
		_units = [true] call JP_fnc_spawnConvoy;
	 };
	 case "cache": {
		_cache_pos =  CACHE_POSITIONS call BIS_fnc_selectRandom;
		_building =  nearestBuilding _cache_pos;
		_position = getPos _building;
		_units = [_position,1,[_building]] call JP_fnc_cache;
	 };
	 case "tank": {
		_tankLogic = TANK_POSITIONS call BIS_fnc_selectRandom;
		_position = getPos _tankLogic;
		_units = [_position] call JP_fnc_spawnTank;
	 };
	 case "wreck": {
		_position = getPos(WRECK_POSITIONS call BIS_fnc_selectRandom);
		_units = [_position] call JP_fnc_spawnCrashSite;
	 };
	default { };
};


CURRENT_OBJECTIVE = [_objective,_position, 400,"", _units select 0];
publicVariable "CURRENT_OBJECTIVE";

if (!_noMarker) then {
	hint "The recon area is represented with the large red marker. If you interrogate civilian in this sector or search in Viet's dead bodies, you'll find intel (documents, indications...) that will reduce the size of the red marker and give you more informations about the good location.";

	[] call JP_fnc_updateMarker;
};

[_units select 0] spawn {
	params["_unit"];
	_do = true;
	while {_do} do {

		if (((CURRENT_OBJECTIVE select 3) call BIS_fnc_taskState) == "SUCCEEDED") then {
			_do = false;
		} else {
			if (getPos (leader GROUP_PLAYERS) distance (CURRENT_OBJECTIVE select 1) < 30) then {
				_unit call JP_fnc_revealObjective;
				_do = false;
			};
		};
		sleep 4;
	};
};

waitUntil { sleep 3; (CURRENT_OBJECTIVE select 3) != "" && (((CURRENT_OBJECTIVE select 3) call BIS_fnc_taskState) == "SUCCEEDED") };

{
["JP_primary_recon","SUCCEEDED", true] remoteExec ["BIS_fnc_taskSetState",_x, true];
} foreach ([] call JP_fnc_allPlayers);

deleteMarker "recon_zone";
deleteMarker "recon_zone_text";

REMAINING_OBJECTIVES = REMAINING_OBJECTIVES - 1;
publicVariable "REMAINING_OBJECTIVES";

sleep 10;

if (REMAINING_OBJECTIVES == 0) then {
	_chopper = missionNamespace getVariable ["chopper_insertion", objNull];
	_lz = "rescue_lz";
	[_chopper,_lz] spawn JP_fnc_extractionTask;
} else {
	if (REMAINING_OBJECTIVES == 1) then {
		[] spawn JP_fnc_helpFriends;
	} else {
		if (REMAINING_OBJECTIVES == 2) then {	
			[] spawn {
				sleep 125;
				[] remoteExec ["JP_fnc_helpFriendsRadio"];
			};
		};

		[] spawn JP_fnc_sleepTask;
	};
};

true;