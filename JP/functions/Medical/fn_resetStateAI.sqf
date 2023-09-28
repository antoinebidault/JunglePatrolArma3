// Reset all the unit's specific states
// Corrected player rating
if (rating _this < 0) then {
	_this addRating ((-(rating _this)) + 1000);
};

_this remoteExec ["RemoveAllActions"];
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

// Restore unit health
if (ACE_ENABLED) then {
	[objNull, _this] remoteExec ["ace_medical_fnc_treatmentAdvanced_fullHealLocal"];
};
	
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

[_this,"HandleDamage"] remoteExec ["removeAllEventHandlers", 0, true];
[_this,"Killed"] remoteExec ["removeAllEventHandlers", 0, true];
[_this, ["HandleDamage",{_this call JP_fnc_handleDamage;}]] remoteExec ["addEventHandler", 0, true];
[_this, ["Killed",{_this call JP_fnc_handleKilled;}]] remoteExec ["addEventHandler", 0, true];

