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

params [
	"_unit",			// Object the event handler is assigned to.
	"_hitSelection",	// Name of the selection where the unit was damaged. "" for over-all structural damage, "?" for unknown selections.
	"_damage",			// Resulting level of damage for the selection.
	"_source",			// The source unit (shooter) that caused the damage.
	"_projectile",		// Classname of the projectile that caused inflicted the damage. ("" for unknown, such as falling damage.) (String)
	"_hitPartIndex",	// Hit part index of the hit point, -1 otherwise.
	"_instigator",		// Person who pulled the trigger. (Object)
	"_hitPoint"			// hit point Cfg name (String)
];
//&& {_hitSelection in ["", "head", "body"]}
if (_damage == 0) exitWith {false};
if (isPlayer _unit) exitWith{false};

// Reducing damage with a factor of 3
//_damage = 0.9 min _damage;

if (_damage >= .9  && !(_unit getVariable["JP_unit_injured",false])) then {

	_unit setDamage .9;
	_damage = .9;
	_unit setVariable ["JP_unit_injured", true,true];
	[_unit] spawn JP_fnc_injured;
	
	[leader GROUP_PLAYERS, [localize "STR_JP_voices_teamLeader_manDown",format[localize "STR_JP_voices_teamLeader_isDown",name _unit],format[localize "STR_JP_voices_teamLeader_needMedic",name _unit]] call BIS_fnc_selectRandom] remoteExec ["JP_fnc_talk"];
	
    _marker = createMarker [format["JP-injured-%1", name _unit], position _unit];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "mil_dot";
    _marker setMarkerColor "ColorOrange";
    _marker setMarkerText format[localize "STR_JP_handleDamage_markerTeammates", name _unit];
	_unit setVariable ["JP_marker_injured",  _marker, true];
	
} else {
	if (_unit getVariable["JP_unit_injured",false])then{
		_damage = .9;
		_unit setDamage .9;
	};
};

_damage;
