/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Trigger chasing

  Parameters:
    0: OBJECT - Group of units chasing
    1: OBJECT - Unit attacked

  Returns:
    BOOL - true 
*/

private ["_flrObj","_wp0"];
_grp = _this select 0;
_unitChased = _this select 1;
_forceChase = if (count _this > 2) then {_this select 2} else {false};
_leader= leader _grp;
_lastKnownPosition = position _leader;

_wp0 = _grp addWaypoint [_lastKnownPosition, 0]; 
_wp0 setWaypointBehaviour "AWARE";
_wp0 setWaypointFormation "LINE";
_wp0 setWaypointSpeed "FULL";

_marker = createMarker [format["sold%1",random 13100], _lastKnownPosition];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerSize [6,6];
_marker setMarkerColor "ColorBlack";
_marker setMarkerBrush "SolidBorder";
if (!DEBUG) then {
    _marker setMarkerAlpha 0;
};

while {!isNull _leader && alive _leader &&  !isNil '_unitChased' && !isNull _unitChased && !(_leader getVariable["JP_disable_patrol",false])}do{
    _leader = leader _grp;
    if (_leader knowsAbout _unitChased >= .5) then {
        if (time > LAST_FLARE_TIME + 120)then{
            _flrObj = "F_40mm_white" createvehicle ((_unitChased) modelToWorld [50-round(random 25),50-round(random 25),200]); 
            _flrObj setVelocity [0,0,-.1];
            LAST_FLARE_TIME = time;
        };
        _lastKnownPosition = _leader getHideFrom _unitChased;
    } else {
       _leader setFormation "LINE";
        //Si déclenchement de la recherche
        if (_forceChase || CHASER_TRIGGERED)then{
            _leader setBehaviour "AWARE";
            _leader setSpeedMode "FULL";
            _lastKnownPosition = [position _unitChased , 0, 60, 1, 0, 20, 0] call BIS_fnc_findSafePos;
        }else{
            _leader setBehaviour "SAFE";
            _leader setSpeedMode "LIMITED";
            _lastKnownPosition = [position _leader , 0, 400, 1, 0, 20, 0] call BIS_fnc_findSafePos;
        };
    };

    // Random shoot in the air
    /*if (_leader knowsAbout _unitChased < .1) then {
      _anyUnit = (units _grp) call BIS_fnc_selectRandom;
      [_anyUnit,_unitChased] spawn { 
        _unit = _this select 0;
        _unitChased = _this select 1;
        _unit doWatch (_unitChased modelToWorld [50-round(random 25),50-round(random 25),200]); 
        sleep 0.5; 
        /*
        while { alive _unit} do { 
          sleep .1; 
          _unit action ["useweapon",vehicle _unit,_unit,0]; 
            sleep .2; 
          _unit action ["useweapon",vehicle _unit,_unit,0]; 
            sleep .3; 
          _unit action ["useweapon",vehicle _unit,_unit,0]; 
        };
      };
    };*/

    if (DEBUG) then {
        _marker setMarkerPos _lastKnownPosition;
    };

    _wp0 setWaypointPosition [_lastKnownPosition,5];
    
    sleep 20;
};

_leader;