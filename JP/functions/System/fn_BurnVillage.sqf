
_compound = ([position player,false,"any"] call JP_fnc_findNearestMarker);
// [getMarkerPos (_compound select 0), _compound select 4, 456, []] call BIS_fnc_destroyCity;

_buildings = _compound select 11;

 {
	[_x] call JP_fnc_burnHouse;
} forEach  _buildings;