/*
	Author: 
		Bidass

  Version:
    0.9.5

	Description:
		This process is executed when the group leader press the "start mission button"
		All the class list are set up from the main CONFIG_VEHICLES array that is an all vehicle className cache.
		When the process is finished, the JP_STARTED is set to true => The mission is allowed to start

*/



if (!isServer) exitWith {};

diag_log "[MissionSetup] Starting";
diag_log format["[MissionSetup] nbVehicles %1",str count CONFIG_VEHICLES];

_units = units GROUP_PLAYERS;
GROUP_PLAYERS = createGroup SIDE_FRIENDLY;
_units joinSilent GROUP_PLAYERS;
publicVariable "GROUP_PLAYERS";


FRIENDLY_LIST_UNITS = [FRIENDLY_LIST_UNITS,[FACTION_PLAYER,["Man"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
_choppers = [FRIENDLY_CHOPPER_CLASS,[FACTION_PLAYER,["Helicopter"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
_tmpChoppers = [];
{
 if (getNumber(configfile >> "CfgVehicles" >> _x >> "transportSoldier") >= count(units(GROUP_PLAYERS)) ) then {
	 _tmpChoppers pushback _x;
 };
} foreach _choppers;
if (count _tmpChoppers > 0) then {
	FRIENDLY_CHOPPER_CLASS = _tmpChoppers;
};


// FRIENDLY_LIST_TURRETS = [FRIENDLY_LIST_TURRETS, [FACTION_PLAYER,["StaticMGWeapon","StaticMortar"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;;


ALLIED_LIST_UNITS = [ALLIED_LIST_UNITS,[FACTION_FRIENDLY,["Man"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
ALLIED_LIST_CARS = [ALLIED_LIST_CARS,[FACTION_FRIENDLY,["Car"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;

CIV_LIST_UNITS = [FACTION_CIV,["Man"],[]] call JP_fnc_factiongetunits;
CIV_LIST_CARS = [FACTION_CIV,["Car"],[]] call JP_fnc_factiongetunits;

ENEMY_LIST_UNITS = [ENEMY_LIST_UNITS,[FACTION_ENEMY,["Man"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
// ENEMY_LIST_CARS = [ENEMY_LIST_CARS,[FACTION_ENEMY,["Car"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;

// Filter the cars classes without turrets
_removedClasses = [];
{
 if (count([_x, false] call BIS_fnc_allTurrets) == 0) then {
	 _removedClasses pushback _x;
 };
}foreach ENEMY_LIST_CARS;
ENEMY_LIST_CARS = ENEMY_LIST_CARS - _removedClasses;

ENEMY_CHOPPERS =  [ENEMY_CHOPPERS,[FACTION_ENEMY,["Helicopter"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
ENEMY_LIST_TANKS = [ENEMY_LIST_TANKS,[FACTION_ENEMY,["Tank"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
ENEMY_SNIPER_UNITS =  [ENEMY_SNIPER_UNITS,[FACTION_ENEMY,["Man"], ["sniper"]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
ENEMY_CONVOY_CAR_CLASS = ENEMY_LIST_CARS select 0;
ENEMY_CONVOY_TRUCK_CLASS = [ENEMY_CONVOY_TRUCK_CLASS,[FACTION_ENEMY,["Truck_F"],[]] call JP_fnc_factiongetunits] call JP_fnc_fillSupportParam;
ENEMY_COMMANDER_CLASS = ENEMY_LIST_UNITS select 0; 
// ENEMY_OFFICER_LIST_CARS = ENEMY_CONVOY_TRUCK_CLASS; 

_mortars = [FACTION_ENEMY,["StaticMortar"],[]] call JP_fnc_factiongetunits;
if (count _mortars > 0) then {
	ENEMY_MORTAR_CLASS = _mortars select 0;
};

SUPPORT_ARTILLERY_CLASS = [SUPPORT_ARTILLERY_CLASS,[FACTION_PLAYER, ["StaticWeapon"], "Artillery"] call JP_fnc_factionGetSupportUnits] call JP_fnc_fillSupportParam;
SUPPORT_TRANSPORT_CHOPPER_CLASS = FRIENDLY_CHOPPER_CLASS;
SUPPORT_DROP_AIRCRAFT_CLASS = [SUPPORT_DROP_AIRCRAFT_CLASS,[FACTION_PLAYER, ["Air"], "Drop"] call JP_fnc_factionGetSupportUnits] call JP_fnc_fillSupportParam;
// SUPPORT_MEDEVAC_CHOPPER_CLASS = FRIENDLY_CHOPPER_CLASS;
SUPPORT_BOMBING_AIRCRAFT_CLASS = [SUPPORT_BOMBING_AIRCRAFT_CLASS,[FACTION_PLAYER, ["Plane"], "CAS_Bombing"] call JP_fnc_factionGetSupportUnits] call JP_fnc_fillSupportParam;
SUPPORT_CAS_HELI_CLASS = [SUPPORT_CAS_HELI_CLASS,[FACTION_PLAYER, ["Helicopter"], "CAS_Heli"] call JP_fnc_factionGetSupportUnits] call JP_fnc_fillSupportParam;
_choppers = [SUPPORT_HEAVY_TRANSPORT_CLASS,[FACTION_PLAYER, ["Helicopter"], "Drop"] call JP_fnc_factionGetSupportUnits] call JP_fnc_fillSupportParam;
_tmpChoppers = [];
{
 if (getNumber(configfile >> "CfgVehicles" >> _x >> "slingLoadMaxCargoMass") >= 11500) then {
	 _tmpChoppers pushback _x;
 };
}foreach _choppers; 
if (count _tmpChoppers > 0) then {
	SUPPORT_HEAVY_TRANSPORT_CLASS = _tmpChoppers;
};

SUPPORT_DRONE_CLASS = if (SIDE_FRIENDLY == WEST) then {"B_UAV_02_dynamicLoadout_F"} else {"O_UAV_02_dynamicLoadout_F"};
// SUPPORT_MEDEVAC_CREW_CLASS = ALLIED_LIST_UNITS call BIS_fnc_selectrandom;
_cars = [FACTION_PLAYER,["Car"],"slingload"] call JP_fnc_factionGetSupportUnits;
if (count _cars > 0) then {
	SUPPORT_CAR_PARADROP_CLASS = _cars;
};

// EMpty the array for memory saving purposes...
CONFIG_VEHICLES = []; 
publicVariable "CONFIG_VEHICLES";

// When Everything is done => Let's start the mission !
JP_STARTED = true;
publicVariable "JP_STARTED";
publicVariableServer "JP_STARTED";

diag_log "[MissionSetup] Done, JP_STARTED = true";


true;