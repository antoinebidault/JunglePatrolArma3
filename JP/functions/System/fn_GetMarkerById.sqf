params["_markers","_markerId"];

// If not the server fetch from server the markers
// if (!isServer) then { MARKERS = [ missionNamespace, "MARKERS", []] call BIS_fnc_getServerVariable; };

_markerIndex = 0;
_marker = _markers select _markerIndex;

{
	if (_markerID == (_x select 0)) exitWith { _marker = _x; _markerIndex = _foreachIndex; };
} foreach _markers;

_marker = _markers select _markerIndex;

[_marker,_markerIndex];