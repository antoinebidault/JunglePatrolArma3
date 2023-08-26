params["_marker","_state"];

if (!isServer) exitWith { hint "setCompoundState executed on client"};

_markerID = _marker select 0;
_markerData = [MARKERS,_markerID] call JP_fnc_getMarkerById;
_marker = _markerData select 0;
_markerIndex = _markerData select 1;

_marker set [12,_state];

_populations = _marker select 6;

_icon = _markerID + "-icon";

_markerID setMarkerBrush "Solid";

// Set the marker state
if (_state == "secured") then{
		_markerID setMarkerColor "ColorGreen";
		_icon setMarkerColor "ColorGreen";
		_icon setMarkerType "loc_Ruin";
	}else{
		if (_state == "neutral") then {
			_markerID setMarkerColor "ColorWhite";
			_icon setMarkerColor "ColorBlack";
			_icon setMarkerType "loc_tourism";
		}else {
			if (_state == "bastion") then {
				_markerID setMarkerColor "ColorRed";
				_icon setMarkerColor "ColorRed";
				_icon setMarkerType "loc_Ruin";
			}else {
				if (_state == "humanitary") then {
					_markerID setMarkerColor "ColorBlue";
					_icon setMarkerColor "ColorBlue";
					_icon setMarkerType "loc_Hospital";
				} else {
					if (_state == "massacred") then {
						_markerID setMarkerColor "ColorBlack";
						_icon setMarkerColor "ColorBlack";
						_icon setMarkerType "loc_Cross";
					} else {
						if (_state == "resistance") then {
							_markerID setMarkerColor "ColorGreen";
							_markerID setMarkerBrush "FDiagonal";
							_icon setMarkerColor "ColorGreen";
							_icon setMarkerType "loc_tourism";
						}
					};
				};
			};
		};
	};


// Add the respawn position if secured only
if (_state == "secured" ) then{

	_populations = _marker select 6;
	// Add the friendly unit to compound
	_populations set [9,(_populations select 0) + ceil(random 3)];
	_marker  set [6,_populations];

	_units = _marker select 5;
	_pos = _marker select 1;
	_radius = _marker select 4; 
	_meetingPointPosition = _marker select 7;
	_units = _units +  ([_pos,_radius,_populations select 9,_meetingPointPosition, _marker select 11] call JP_fnc_spawnFriendlyOutpost);
	_marker  set [5,_units];

	// White list this marker
	_mkrToAvoid = createMarker [format["secured-whitelist-%1",str (_pos)],_pos];
	_mkrToAvoid setMarkerAlpha 0;
	_mkrToAvoid setMarkerShape "ELLIPSE";
	_mkrToAvoid setMarkerSize [150 max 1.3*_radius,150 max 1.3*_radius];
	MARKER_WHITE_LIST pushback _mkrToAvoid;

	_spawnPos =  [_pos, 0, (30 max (.3*_radius)), 2, 0, 1, 0] call BIS_fnc_findSafePos;
	_marker set [15, [SIDE_FRIENDLY, _spawnPos, _marker select 14] call BIS_fnc_addRespawnPosition];
	[_units] remoteExec ["JP_fnc_compoundsecuredCutScene", GROUP_PLAYERS];
} else {
	if (!((_marker select 15) isEqualTo [])) then {
		(_marker select 15) remoteExec ["BIS_fnc_RemoveRespawnPosition",0, true]; 
	};
};


if (_state == "bastion") then {
	(_marker select 0) setMarkerColor "ColorRed";
	_civilians = (_populations select 0) + (_populations select 2);
	_enemies = _civilians - round(_civilians/3);
	_populations set [0, round(_civilians/3)];
	_populations set [2, _enemies];

	if (DEBUG) then {HQ sideChat format[localize "STR_JP_voices_HQ_occupiedByEni",_marker select 14];};
} else {
	if (_state == "massacred") then {
		_marker select 0 setMarkerBrush "BDiagonal";
		_marker select 0 setMarkerColor "ColorBlack";
		[_marker] spawn {
			params["_marker"];
			// Let time to officer to leave the area
			sleep 120;
			[getMarkerPos (_marker select 0), _marker select 4, 456, []] call BIS_fnc_destroyCity;
			if (DEBUG) then {HQ sideChat format[localize "STR_JP_voices_HQ_civilianSlaughtered",_marker select 14];};
		};
	 	
	} else{
		if (_state == "humanitary") then {
			_marker select 0 setMarkerBrush "BDiagonal";
			_marker select 0 setMarkerColor "ColorGrey";
			if (DEBUG) then {HQ sideChat format[localize "STR_JP_voices_HQ_humanitaryDeployed",_marker select 14];};
		};
	};
};

_marker set [6,_populations];

waitUntil {!IN_MARKERS_LOOP};
MARKERS set [_markerIndex,_marker];

[] call JP_fnc_refreshMarkerStats;
// [] remoteExec ["JP_fnc_displayScore"];

_marker;
