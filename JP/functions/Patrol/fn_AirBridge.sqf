/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Basic chopper patrol drop and push soldier back

  Parameters:
    0: OBJECT - Chopper

  Returns:
    BOOL - true 
*/

LZ = [];
{  if (_x find "lz_" == 0 ) then { LZ pushback _x }; }foreach allMapMarkers; 

for "_i" from 1 to 6 do {
	sleep 3;
	_tlVar = format["tl_%1", _i];
  _chopper = missionNamespace getVariable format["chopper_%1", _i];
  if (isNil '_chopper') then { continue; };

	_lz = LZ select _i - 1;
  _dest = getMarkerPos _lz;
  _tl = missionNamespace getVariable  _tlVar;
  _initialPosition = getPosASL _chopper;
  _helipad_obj_init = "Land_HelipadEmpty_F" createVehicle _initialPosition;
   _pilot = driver _chopper;
  _helipad_obj = "Land_HelipadEmpty_F" createVehicle _dest;

	_waypoint = (group (_pilot)) addWaypoint [_dest, 0];
	_waypoint setWaypointType "TR UNLOAD";
	_waypoint setWaypointBehaviour "CARELESS";
	_waypoint setWaypointSpeed "FULL";
	_waypoint setWaypointStatements ["{vehicle _x == this} count units group " + _tlVar + " == 0", "(vehicle this) land ""GET IN"";  group " + _tlVar + " leaveVehicle (vehicle this);"];
	_waypoint setWaypointCompletionRadius 4;

	_waypoint2 = (group (_pilot)) addWaypoint [_initialPosition, 1];
	_waypoint2 setWaypointType "MOVE";
	_waypoint2 setWaypointSpeed "FULL";
	_waypoint2 setWaypointCompletionRadius 5;
	//_waypoint4 setWaypointTimeout [100,160,130];
	_waypoint2 setWaypointStatements ["true","(vehicle this) land ""GET IN"";"];

/*
	_waypoint21 = (group (_pilot)) addWaypoint [_initialPosition, 1];
	_waypoint21 setWaypointType "HOLD";
	_waypoint21 setWaypointTimeout [100,160,130];
	_waypoint21 setWaypointStatements ["true","this;"];
*/
	_waypoint3 = (group (_pilot)) addWaypoint [_dest, 1];
	_waypoint3 setWaypointType "MOVE";
	_waypoint3 setWaypointSpeed "FULL";
	_waypoint3 setWaypointCompletionRadius 20;
	_waypoint4 setWaypointStatements ["true","(vehicle this) land ""GET IN""; _wp = group " + _tlVar + " addWaypoint [getPos this,0]; _wp setWaypointType ""GETIN""; _wp setWaypointBehaviour ""CARELESS""; _wp setWaypointSpeed ""FULL""; "];
	

	_waypoint4 = (group (_pilot)) addWaypoint [_dest, 1];
	_waypoint4 setWaypointType "LOAD";
	_waypoint4 setWaypointSpeed "FULL";
	_waypoint4 setWaypointCompletionRadius 5;
	_waypoint4 setWaypointStatements ["{vehicle _x == this} count units group " + _tlVar + " == count units group " + _tlVar + "","this;"];


	_waypoint5 = (group (_pilot)) addWaypoint [_initialPosition, 1];
	_waypoint5 setWaypointType "MOVE";
	_waypoint5 setWaypointSpeed "FULL";
	_waypoint5 setWaypointCompletionRadius 5;
	_waypoint5 setWaypointTimeout [100,160,130];
	_waypoint5 setWaypointStatements ["true","(vehicle this) land ""GET IN"";"];

	_waypoint6 = (group (_pilot)) addWaypoint [_initialPosition, 1];
	_waypoint6 setWaypointType "CYCLE";
};