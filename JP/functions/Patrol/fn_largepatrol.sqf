/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Large patrol for random enemy spawned

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

private ["_timer","_rndMarker","_rndPos","_radius","_newPos"];
params ["_grp","_marker"];

_unit = leader _grp;
_unit addWeapon "Binocular";


if(isNull(_unit findNearestEnemy _unit))then{
   // _unit forceWalk true;
    _unit setBehaviour "SAFE";
}else{
   // _unit forceWalk false;
    _unit setBehaviour "AWARE";
};

while { alive _unit && !captive _unit }do{
    _unit = leader _grp;
    _rndMarker = ([position _unit, true, "any"] call JP_fnc_findNearestMarker) select 0;
    _rndPos = getMarkerPos _rndMarker;
    _radius = (getMarkerSize _rndMarker) select 0;
    _newPos = [_rndPos, 1, _radius, 1, 0, 20, 0] call BIS_fnc_findSafePos;
    (group _unit) move _newPos;
    
    waitUntil {sleep 5; CHASER_TRIGGERED || unitReady _unit || _unit distance _newPos < 2 };
   
    _unit setUnitPos "Middle";
    _unit selectWeapon "Binocular";
    
    sleep 10 + random 60;

    _unit selectWeapon (primaryWeapon _unit);
    _unit setUnitPos "AUTO";

    sleep 5;

    [_unit] call JP_fnc_gotomeeting;
    sleep 5;
};
