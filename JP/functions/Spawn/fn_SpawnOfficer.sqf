/**
 * DYNAMIC CIVIL WAR
 * Created: 2017-11-29
 * Author: Bidass

  Version:
    {VERSION}
 * License : GNU (GPL)
 * Spawn a officer to assassine
 */

params["_initPos"];

//Trucks
_road = [_initPos,3000, MARKER_WHITE_LIST] call BIS_fnc_nearestRoad;
_roadPos = getPos _road;
_roadConnectedTo = roadsConnectedTo _road;
//if (count _roadConnectedTo == 0) exitWith { hint "restart"; [_initPos] call JP_fnc_spawnOfficer; };
_roadDirection = random 360;
if (count _roadConnectedTo > 0) then {
_connectedRoad = _roadConnectedTo select 0;
_roadDirection = [_road, _connectedRoad] call BIS_fnc_DirTo;
};

_grp = createGroup SIDE_ENEMY;
_officer = _grp createUnit [ENEMY_COMMANDER_CLASS, _initPos,[],AI_SKILLS,"NONE"];
[_officer] joinSilent _grp;
_officer setVariable ["JP_IsIntelRevealed",false, true];
_officer setVariable ["JP_TaskNotCompleted",true, true];
_officer setVariable ["JP_Type","officer", true];
[_officer,"ColorRed"] call JP_fnc_addmarker;

// _grp call JP_fnc_sendToHC;

removeAllWeapons _officer;
_officer setBehaviour "SAFE";
_officer execVM "JP\loadout\loadout-officer.sqf";
_officer enableDynamicSimulation false;

_truckGrp = createGroup SIDE_ENEMY;
_truck = [_roadPos, _roadDirection, ENEMY_OFFICER_LIST_CARS call bis_fnc_selectrandom,_truckGrp ] call BIS_fnc_spawnVehicle select 0;
_truck enableDynamicSimulation false;

_officer moveInAny _truck;

_nbUnit = (count (fullCrew [_truck,"cargo",true])) - 1 min 8;
_unit = objNull;
for "_yc" from 1 to _nbUnit  do {
    _unit = [_grp, _initPos, true] call JP_fnc_spawnEnemy;
     [_unit,"ColorRed"] call JP_fnc_addmarker;
    _unit setVariable ["JP_Type","officerguard", true];
    _unit enableDynamicSimulation false;
    _unit moveInAny _truck;    
};

_grp selectLeader _officer;

[_truck,_officer] spawn JP_fnc_officerPatrol;

[_officer, ["Killed",{
    params["_unit","_killer"];
    [format["JP_secondary_%1", name _unit],"FAILED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
    OFFICERS = OFFICERS - [_unit];
}]] remoteExec ["addEventHandler",0,true];;

[_officer, "HandleDamage"] remoteExec ["removeAllEventHandlers", 0, true];
[_officer, ["HandleDamage", {
    
    params [
        "_unit",			// Object the event handler is assigned to.
        "_hitSelection",			// The source unit (shooter) that caused the damage.
        "_damage",			// Resulting level of damage for the selection.
        "_source"		// Person who pulled the trigger. (Object)
    ];
    
    if (_damage == 0) exitWith {false};
    
    if (_damage > .9 && !(_unit getVariable["JP_isUnconscious",false])) then {
        _unit setVariable["JP_isUnconscious",true,true];
        [_unit] remoteExec ["JP_fnc_shout", 0];	
        _unit remoteExec ["removeAllActions",0];
        _unit setDamage .9;
        _unit setHit ["legs", 1];

        if (vehicle _unit != _unit)then{
            moveOut _unit;
        };

        [leader GROUP_PLAYERS,localize "STR_JP_voices_teamLeader_targetDown", true] remoteExec ["JP_fnc_talk", GROUP_PLAYERS,false];
        [format["JP_secondary_%1", name _unit],GROUP_PLAYERS, ["Talk to the wounded officer","Talk to the officer","Talk to the wounded officer"],getPos _unit,"CREATED",1, true] remoteExec ["BIS_fnc_setTask", GROUP_PLAYERS, true];
        _unit getVariable["marker",""] setMarkerAlpha 1;
        _unit getVariable["marker",""] setMarkerPos (getPos _unit);
        
        //Spasm and unconscious state
        _unit spawn {
            sleep .2;
            _this setUnconscious true;
            waitUntil { vehicle _this != _this || animationState _this == "ainjppnemstpsnonwrfldnon"  }; 
            _this playAction "GestureSpasm" + str floor random 7; 
        };	

        _damage = .9;
        
        // Create task if not exists
		[_unit,true] call JP_fnc_createtask;

        [ _unit,"Interrogate","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","true","true",{
                [(_this select 1), "medicStart"] remoteExec ["playActionNow"];
        },{
            
            [(_this select 1), "medicStart"] remoteExec ["playActionNow"];
        },{
            params["_unit","_player"];
            [_player, "medicStop"] remoteExec ["playActionNow"];
            OFFICERS = OFFICERS - [_unit];
            _unit setVariable["JP_interrogated",true, true];
            [_unit, "Killed"] remoteExec ["removeAllEventHandlers", 0, true];
            
            [_unit] spawn {
                params["_unit"];
                sleep 100;
                _unit setDamage 1;
            };
            
            [_unit,localize "STR_JP_voices_officer_iKnowSomeThing"] remoteExec ["JP_fnc_talk",_player];
            [format["JP_secondary_%1", name _unit],"SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
			_unit remoteExec ["JP_fnc_success", 2, false];
             (_unit getVariable["marker",""]) setMarkerAlpha 0;
        },{
        [(_this select 1), "medicStop"] remoteExec ["playActionNow"];
        },[],3,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd"];

    } else {
        if (!(_unit getVariable["JP_interrogated",false]) && _unit getVariable["JP_isUnconscious",false]) then {
            _damage = .9;
            _unit setDamage .9;
        };
    };
    
    _damage;
}]] remoteExec ["addEventHandler", 0, true];


//Custom variable
_marker = createMarker [format["officerlmarker-%1",str random 100],getPos _officer];
_marker setMarkerShape "ICON";
_marker setMarkerColor "ColorRed";
_marker setMarkerType "mil_warning";
_marker setMarkerAlpha 0;
_officer setVariable["marker",_marker];

[_officer];