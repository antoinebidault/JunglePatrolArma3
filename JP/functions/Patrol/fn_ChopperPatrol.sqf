/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Basic chopper patrol around the group position

  Parameters:
    0: OBJECT - Chopper

  Returns:
    BOOL - true 
*/

private ["_newPos"];
params["_chopper"];
private _grp = group _chopper;
//_chopper flyInHeight 75;
//_grp setSpeedMode "LIMITED";
sleep random 50;

while { alive _chopper } do {
    _unit = ([] call JP_fnc_allPlayers) call BIS_fnc_selectRandom;
    sleep .4;
     _newPos = ([_unit, 0, 5000, 0, 0, 20, 0] call BIS_fnc_findSafePos);
     _grp move _newPos;
    waitUntil {sleep 10;(_chopper distance2D _newPos) < 140 || !alive _chopper};
    sleep .4;
      _newPos = ([_unit,5500, 6500, 0, 0, 20, 0] call BIS_fnc_findSafePos);
     _grp move _newPos;
    waitUntil {sleep 10;(_chopper distance2D _newPos) < 140|| !alive _chopper};
    sleep random 100;
};

