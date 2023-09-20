// Reset all the unit's specific states
// Corrected player rating
if (rating _this < 0) then {
	_this addRating ((-(rating _this)) + 1000);
};

 resetCamShake;

// Remove units around the player
{ if (_this distance _x < 120 && side _x == SIDE_ENEMY) then {_x setDamage 1;} } foreach allUnits;


// Set the group leader as a human if he is an AI
if (!isPlayer (leader GROUP_PLAYERS)) then {
	GROUP_PLAYERS selectLeader _this;
};

// Create a basic hidden marker on player's position (Used for blacklisting purposes)
_pm = createMarker [format["player-marker-%1",name _this], getPos _this];
_pm setMarkerShape "ELLIPSE";
_pm setMarkerColor "ColorGreen";
_pm setMarkerAlpha 0;
_pm setMarkerSize [170,170];
if (DEBUG) then {
	_pm setMarkerAlpha .3;
};

_this setVariable["marker", _pm, true];
PLAYER_MARKER_LIST pushBackUnique _pm;
publicVariable "PLAYER_MARKER_LIST";

[] call JP_fnc_displayscore;

// _this remoteExec ["RemoveAllActions"];
detach _this;
_this setDamage 0;
_this enableAI "ALL";
_this stop false;
_this setCaptive false;
_this setUnconscious false;
if (vehicle _this == _this) then {
	[_this,""] remoteExec["switchMove"];
};
_this call JP_fnc_removeActionHeal;
[_this,"JP_fnc_carry"] call JP_fnc_removeAction; 
_this setVariable["JP_fnc_carry",-1,true];
_this setVariable["JP_this_injured",false,true];
_this setVariable["JP_this_dragged",false,true];
_this setVariable["JP_healer",objNull,true];
deleteMarker (_this getVariable["JP_marker_injured",""]);
if (ACE_ENABLED) then {
	[objNull, _this] remoteExec ["ace_medical_fnc_treatmentAdvanced_fullHealLocal"];
};

// Add everything to the _this
_this setskill 1;
_this setUnitAbility 1;
_this allowFleeing 0;
_this setskill ["aimingAccuracy", 1];
_this setskill ["aimingShake", 1];
_this setskill ["aimingSpeed", 1];
_this setskill ["spotDistance", 1];
_this setskill ["spotTime", 1];
_this setskill ["commanding", 1];
_this setskill ["courage", 1];
_this setskill ["general", 1];
_this setskill ["reloadSpeed", 1];
_this setUnitTrait ["engineer",true];
_this setUnitTrait ["medic",true];
_this setUnitTrait ["explosiveSpecialist",true];
_this setUnitTrait ["audibleCoef",.1];

if (!(_this hasWeapon "itemGPS")) then {
	_this addWeapon "itemGPS";
};
if (!("MineDetector"  in (items _this))) then {
	_this addItem "MineDetector";
};

if (ACE_ENABLED) then {
	if (!("ACE_EarPlugs"  in (items _this))) then {
		_this addItem "ACE_EarPlugs";
	};
	if (!("ACE_DefusalKit"  in (items _this))) then {
		_this addItem "ACE_DefusalKit";
	};
} else {
		
	if (!("ToolKit"  in (items _this))) then {
		_this addItem "ToolKit";
	};
};

if (isPlayer _this && (leader GROUP_PLAYERS) == _this) then {
	// _this remoteExec ["removeAllActions"];
	sleep .3;
	//_this call JP_fnc_actionCamp;
	//_this call JP_fnc_addSupportUi;
};

if (isPlayer _this && DEBUG) then {
	_this call JP_fnc_teleport;
};

