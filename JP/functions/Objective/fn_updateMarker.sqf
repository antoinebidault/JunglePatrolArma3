
_pos = getPos (CURRENT_OBJECTIVE select 4);
_radius = CURRENT_OBJECTIVE select 2;

_setPos =  [[[_pos, _radius]], MARKER_WHITE_LIST] call BIS_fnc_randomPos; // [_pos, 0, (_radius - 100) min 50, 0, 0, 0, 0, MARKER_WHITE_LIST] call BIS_fnc_findSafePos;
_mkr = "recon_zone";
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush  "FDiagonal";
_mkr setMarkerAlpha (if (_radius <= 100) then {1} else {0.5});
_mkr setMarkerSize [2 * _radius, 2 * _radius];
_mkr setMarkerPos _setPos;

_mkr2 = "recon_zone_text";
_mkr2 setMarkerPos _setPos;
