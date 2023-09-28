params["_unit"];

if (vehicle _unit != _unit) then {
	doGetOut _unit;
};

_unit setUnconscious true; 
_unit setCaptive true;
_unit setHit ["legs", 1];  
_unit setVariable ["JP_unit_injured", true, true];

sleep 6;

// Stabilize action
_unit call JP_fnc_addActionHeal;
[_unit,"JP_fnc_carry"] call JP_fnc_addAction; 

_deathsound = format ["A3\sounds_f\characters\human-sfx\P0%1\Hit_Max_%2.wss", selectRandom [4,5,6,7,8,9], selectRandom [1,2,3,4,5]];
playSound3D [_deathsound, _unit, false, getPosASL _unit, 1.5, 1, 150];	

if (isPlayer _unit && _unit == player) then {
	JP_ai_reviving_cancelled = false;
	if (REMAINING_RESPAWN > 0) then {
    	_idAction = [_unit, localize "STR_JP_injured_forceRespawn","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa", "\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_unbind_ca.paa", "true", "true", {  }, { }, { JP_ai_reviving_cancelled = true; }, {  }, [], 3, nil, true, true] call BIS_fnc_holdActionAdd;
	};
	JP_ai_current_medic = objNull;

	// Reviving loop
	while {_unit getVariable["JP_unit_injured",false] && !JP_ai_reviving_cancelled} do {

		
		
		if (!isNull JP_ai_current_medic && lifeState JP_ai_current_medic != "HEALTHY" && lifeState JP_ai_current_medic != "INJURED") exitWith {JP_ai_current_medic = objNull;};

		_foundCloseMedic = _unit call JP_fnc_findCloseMedic;

		// Check the status
		if (_dist == 999999 || isNull _foundCloseUnit) exitWith { 
			JP_ai_current_medic = objNull; 
			hintSilent localize "STR_JP_injured_hintMedicKia";
		};
		
		if (!isNull _foundCloseUnit && isNull JP_ai_current_medic) then {
			_unit setVariable ["JP_healer", objNull, true];
			JP_ai_current_medic = _foundCloseUnit;
			[_foundCloseUnit, _unit,false] spawn JP_fnc_firstAid;
		};

		hintSilent format[localize "STR_JP_injured_medicAt",str round _dist];

		sleep .5;

	};

	hintSilent "";
	[_unit,"JP_fnc_carry"] call JP_fnc_removeAction; 
	if (REMAINING_RESPAWN > 0) then {
		[_unit,_idAction] remoteExec ["BIS_fnc_holdActionRemove"];
	};
	_unit call JP_fnc_removeActionHeal;
	// The soldier has been revived successfully
	if ( !(_unit getVariable["JP_unit_injured",false]) ) exitWith { };

	// If in multiplayer => kill him
	if (isMultiplayer) then { _unit setDamage 1; };
	
	_unit setVariable["JP_unit_injured",false,true];

} else {
	_foundCloseUnit = _unit call JP_fnc_findCloseMedic;

	if (!isNull _foundCloseUnit ) then {
		[_foundCloseUnit, [localize "STR_JP_voices_teamMember_onIt",localize "STR_JP_voices_teamMember_helpHim",localize "STR_JP_voices_teamLeader_afterHim"] call BIS_fnc_selectRandom] remoteExec ["JP_fnc_talk"];
		[_foundCloseUnit,_unit,false] spawn JP_fnc_firstAid;
	};
};
