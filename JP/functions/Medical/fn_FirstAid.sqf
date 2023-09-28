    
/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    AI behavior 
	Make the selected unit to heal a wounded soldier.
	 It is propagating variable through network to prevent some unwanted behaviors...
	Credits to psycho & BonInf* 

  Parameters:
    0: OBJECT - Healer
	1: OBJECT - Injured unit
	2: BOOL - True to make the animation persistent (It will never stop until one of the unit die...). Useful in humanitar camp

  Returns:
    BOOL - true 
*/

params["_healer","_injuredperson","_ambient"]; 

private ["_injuredperson","_healer","_behaviour","_timenow","_relpos","_dir","_offset","_time","_damage","_isMedic","_healed","_animChangeEVH","_skill_factor"];
if (isNull _healer) exitWith {false};
_behaviour = behaviour _healer;
if(!isNull (_injuredperson getVariable ["JP_healer", objNull])) exitWith{false};
_injuredperson setVariable ["JP_healer", _healer, true];
_healer setVariable ["JP_heal_injured", _injuredperson, true];
_injuredperson setUnconscious true;

sleep 4;

JP_fnc_aiMove = {
	params["_healer", "_injured"];
	_healer setBehaviour "AWARE";
	_healer doMove (position _injured);
	_timenow = time;
	WaitUntil {
		sleep 1;
		!(_injured getVariable["JP_unit_injured",false]) ||
		_healer distance _injured <= 4	 		     ||
		!alive _injured		 					 ||
		!alive _healer				 				 ||
		lifeState _healer == "INCAPACITATED"          ||
		speed _healer == 0                          ||
		_timenow + 320 < time
	};
	
	if (speed _healer == 0) then {
		[_healer,_injured] call JP_fnc_aiMove;
	};
};

if (!isPlayer _healer && {_healer distance _injuredperson > 6}) then {
	[_healer,_injuredperson] call JP_fnc_aiMove;
};

// If healer hase been killed
if (lifeState _healer == "INCAPACITATED") exitWith{
	_healer setVariable ["JP_heal_injured", objNull, true];
	_injuredperson setVariable ["JP_healer", objNull, true];
	if (!(_injuredperson getVariable["JP_unit_injured",false])) then {
		_foundCloseUnit = _injuredperson call JP_fnc_findCloseMedic;
		if (!isNull _foundCloseUnit)then {
			[_foundCloseUnit, _injuredperson, false] spawn JP_fnc_firstAid;
		};
	};
};

// The player has revived him before
if (!(_injuredperson getVariable["JP_unit_injured",false]) ) exitWith{ 	
	_healer setVariable ["JP_heal_injured", objNull, true];
	_injuredperson setVariable ["JP_healer", objNull, true]; 
};

// Another player is healing him
if (_injuredperson getVariable ["JP_healer", objNull] != _healer ) exitWith{
	_healer setVariable ["JP_heal_injured", objNull, true];
}; 

// The injured is dragged by another player
if (_injuredperson getVariable ["JP_unit_dragged", false]) exitWith{
	_healer setVariable ["JP_heal_injured", objNull, true];
}; 

_healer allowDamage false;

_healer selectWeapon primaryWeapon _healer;
sleep 1;
_healer playAction "medicStart";

if (!isPlayer _healer) then {
	_healer stop true;
	_healer disableAI "MOVE";
	_healer disableAI "TARGET";
	_healer disableAI "AUTOTARGET";
	_healer disableAI "ANIM";
};

_offset = [0,0,0]; _dir = 0;
_relpos = _healer worldToModel position _injuredperson;
if((_relpos select 0) < 0) then{_offset=[-0.2,0.7,0]; _dir=90} else{_offset=[0.2,0.7,0]; _dir=270};

_injuredperson attachTo [_healer,_offset];
_injuredperson setDir _dir;
_time = time;

// Pop a smoke
if (!isNull(_healer findNearestEnemy _healer) && !_ambient) then {
	_smoke = "SmokeShell" createVehicle  (_injuredperson modelToWorld[.5 + random 4,.5 + random 1,0]); 
};

[_injuredperson,"JP_fnc_carry"] call JP_fnc_removeAction;
_injuredperson call JP_fnc_removeActionHeal;

if (_ambient) then {
	waitUntil {sleep 10; lifeState _injuredperson != "INCAPACITATED" || !alive _healer;};
} else{
	sleep 1;
	_skill_factor = 30+(random 10);
	_damage = (damage _injuredperson * _skill_factor);
	if (_damage < 5) then {_damage = 5};
	[_healer, _injuredperson,_damage] call JP_fnc_spawnHealEquipement;
	while {
		time - _time < _damage
		&& _injuredperson getVariable["JP_unit_injured",false]
		&& {alive _healer}
		&& {alive _injuredperson}
		&& lifeState _healer != "INCAPACITATED"
		&& {(_healer distance _injuredperson) < 2}
	} do {
		sleep 0.5;
	};
};

detach _healer;
detach _injuredperson;

if (alive _healer && alive _injuredperson && _injuredperson getVariable["JP_unit_injured",false]) then {
	
	if (rating _injuredperson < 0) then {
		_injuredperson addRating ((-(rating _injuredperson)) + 1000);
	};
	_injuredperson setDamage 0;
	_injuredperson setCaptive false;
	_injuredperson setUnconscious false;
	_injuredperson setVariable["JP_unit_injured",false,true];
	deleteMarker (_injuredperson getVariable ["JP_marker_injured",  ""]);
	
	sleep 1;
	resetCamShake;
} else {
	if (damage _injuredperson >= .9 && lifeState _injuredperson == "INCAPACITATED") then {
		[_injuredperson,"JP_fnc_carry"] call JP_fnc_addAction; 
		_injuredperson call JP_fnc_addActionHeal;
	};
};

_injuredperson setVariable ["JP_healer",objNull,true];
_healer setVariable ["JP_heal_injured", objNull, true];

if (!isPlayer _healer) then {
	_healer stop false;
	_healer enableAI "MOVE";
	_healer enableAI "TARGET";
	_healer enableAI "AUTOTARGET";
	_healer enableAI "ANIM";
};

if (alive _healer) then {
	_healer playAction "medicStop";
	_healer setBehaviour _behaviour;
};

_healer allowDamage true;

if (!alive _injuredperson) exitWith {};
if (!alive _healer) exitWith {};
