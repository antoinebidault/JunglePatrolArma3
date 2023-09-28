/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Player's surrendering system 

*/

JP_map_teleport_enabled = false;

map_click_handler =
[
	"map_teleport", "onMapSingleClick",
	{
		if (JP_map_teleport_enabled) then {
			{
				// Current result is saved in variable _x
				_x enableAI "ALL";
				_x switchMove "";
				_x setPos _pos; // _pos is predefined for onMapSingleClick
			} forEach  units group player;
			systemChat format [localize "STR_JP_teleport_teleportToMapPosition", _pos];
			JP_map_teleport_enabled = false;
			openMap false;
		};
	},
	nil
] call BIS_fnc_addStackedEventHandler;

_id = _this addAction
[
	localize "STR_JP_teleport_teleportTo",
	{
		JP_map_teleport_enabled = true;
		if (!visibleMap) then {
			// will probably need to check if player has map, and use forceMap if he doesn't
			openMap true;
			waitUntil {visibleMap};
		};
		mapCenterOnCamera ((findDisplay 12) displayCtrl 51);
		waitUntil {!visibleMap};
		if (JP_map_teleport_enabled) then {
			systemChat localize "STR_JP_teleport_teleportCancel";
		};
		JP_map_teleport_enabled = false;
	},
	nil, 0.5, false, true
];
