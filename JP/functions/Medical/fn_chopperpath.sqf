/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    TODO

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/


_landPos =_this select 0;
TRANSPORTHELO = _this select 1; 
_groupToHelp = _this select 2;

interventionGroup = [TRANSPORTHELO, side _groupToHelp] call JP_fnc_spawnHeloCrew;
_grp = group (driver TRANSPORTHELO);
HASLANDED = false;

private _startPos = position TRANSPORTHELO;
[HQ,format[localize "STR_JP_voices_HQ_inBound",ceil((_landPos distance _startPos)/1000)*.333] ,true] remoteExec ["JP_fnc_talk", _groupToHelp, false];

 private _wp0 = _grp addWaypoint [_landPos, 10];
 _wp0 setwaypointtype "MOVE";

TRANSPORTHELO addEventHandler ["handleDamage", {
	params [
		"_unit",			
		"_hitSelection",	
		"_damage",			
		"_source",		
		"_projectile",		
		"_hitPartIndex",	
		"_instigator",		
		"_hitPoint"		
	];
	if (_damage > .2)then{
		MEDEVAC_State = "aborted";
	}
}];


waitUntil {MEDEVAC_State == "aborted" || TRANSPORTHELO distance2D _landPos < 200};
if (MEDEVAC_State == "aborted") exitWith { false };

[HQ,localize "STR_JP_voices_HQ_smoke" ,true] remoteExec ["JP_fnc_talk"];
// hint localize "STR_JP_chopperPath_hintRTB";

// Silently add a red smoke to group leader
{
	if (isPlayer _x) then {
		_x addItem  "SmokeShellRed";
	};
} forEach units GROUP_PLAYERS;

MEDEVAC_SmokeShell = objNull;
{
	_x addEventHandler ["Fired", {
		if ((_this select 4) isKindOf "SmokeShell") then 
		{
			MEDEVAC_SmokeShell = _this select 6;
		};
	}];
} foreach (units GROUP_PLAYERS);

_startTime = time;
waitUntil {!isNull MEDEVAC_SmokeShell  };// || time > (_startTime + 500 )
// if (time > (_startTime + 500)) exitWith { MEDEVAC_State = "aborted"; "EveryoneLost" call BIS_fnc_endMissionServer; };

sleep 5;

/*
[] spawn{
	sleep 3;
	TRANSPORTHELO action ["useWeapon",TRANSPORTHELO,driver TRANSPORTHELO,1];
	sleep 5;
	TRANSPORTHELO action ["useWeapon",TRANSPORTHELO,driver TRANSPORTHELO,1];
	sleep 3;
	TRANSPORTHELO action ["useWeapon",TRANSPORTHELO,driver TRANSPORTHELO,1];
};*/

[HQ,localize "STR_JP_voices_HQ_landing" ,true] remoteExec ["JP_fnc_talk"];

{
 	_x removeEventHandler ["Fired", 0];
} foreach (units GROUP_PLAYERS);

deleteWaypoint [_grp, 0];
 private _pos = [getposatl MEDEVAC_SmokeShell, 2, 50, 7, 0, 20, 0] call BIS_fnc_findSafePos;
 private _landpad = createVehicle ["Land_HelipadEmpty_F", _pos, [], 0, "CAN_COLLIDE"];
 private _wp01 = _grp addwaypoint [_pos, 0];

 _wp01 setwaypointtype "UNLOAD";
 _wp01 setWaypointStatements ["true","HASLANDED = true;"];

_timer = time;
waitUntil {sleep 2; MEDEVAC_state == "aborted" || HASLANDED || time == _timer + 300};
if (MEDEVAC_state == "aborted") exitWith{false};
if (!HASLANDED) exitWith { MEDEVAC_State = "aborted"; };

sleep 1;

TRANSPORTHELO land "GET IN";

sleep 10;

// replacementGroup leavevehicle TRANSPORTHELO;
interventionGroup leavevehicle TRANSPORTHELO; 
interventionGroup move (TRANSPORTHELO modelToWorld [5, 0 ,0]);

waitUntil{sleep 2; { MEDEVAC_state == "aborted" ||  _x in TRANSPORTHELO} count units  interventionGroup == 0  };
if (MEDEVAC_state == "aborted") exitWith{false};

/*
replacementGroup move position (leader _groupToHelp);
{_x setUnitPos "MIDDLE"; _x setBehaviour "MIDDLE"; } foreach (units replacementGroup);
*/

//{ [_x] joinSilent grpNull; } foreach _groupToHelp;

//Make replacementGroup join player
//{unassignVehicle _x;_x setBehaviour "AWARE"; _x enableAI "ALL"; _x setUnitPos "AUTO";}foreach (units replacementGroup);
//(units replacementGroup) join _groupToHelp;
//[HQ,localize "STR_JP_voices_HQ_reinforcement",true] remoteExec ["JP_fnc_talk"];

// Save units
[HQ,format[localize "STR_JP_voices_HQ_startingEvac",count _soldiersDead],true] remoteExec ["JP_fnc_talk"];

// [interventionGroup,_soldiersDead,TRANSPORTHELO] spawn JP_fnc_save;

_wp1 = _groupToHelp addWaypoint [getPos TRANSPORTHELO,12];
 _wp1 setWaypointType "GETIN"; 
 _wp1 setWaypointBehaviour "CARELESS"; 
 _wp1 setWaypointSpeed "FULL"; 
_wp1 setWaypointStatements ["true","{_x assignAsCargo TRANSPORTHELO;}  forEach units (group this);  units (group this) orderGetIn true;"];  

waitUntil{sleep 2; MEDEVAC_state == "aborted" || ({_x in TRANSPORTHELO} count (units  _groupToHelp) == count (units  _groupToHelp))};

_wp2 = interventionGroup addWaypoint [getPos TRANSPORTHELO,12];
_wp2 setWaypointType "GETIN"; 
_wp2 setWaypointBehaviour "CARELESS"; 
_wp2 setWaypointSpeed "FULL"; 
_wp2 setWaypointStatements ["true","{_x assignAsCargo TRANSPORTHELO;}  forEach units group this; units (group this) orderGetIn true;"];  

waitUntil {sleep2; MEDEVAC_state == "aborted" || ({_x in TRANSPORTHELO} count (units  interventionGroup) == count (units  interventionGroup))};

// Go back home
TRANSPORTHELO move _startPos;

/*
sleep 3;
	TRANSPORTHELO action ["useWeapon",TRANSPORTHELO,driver TRANSPORTHELO,1];
sleep 5;
	TRANSPORTHELO action ["useWeapon",TRANSPORTHELO,driver TRANSPORTHELO,1];
*/
// Check waypoint;
waitUntil{sleep 2; MEDEVAC_state == "succeeded" || (TRANSPORTHELO distance2D _startPos < 150) };
MEDEVAC_State = "succeeded";

