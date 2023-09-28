/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    TODO

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

private _group = _this select 0;
private _pos = _this select 1;
private _excludedFromSpawnedUnit = _this select 2;
private _canBeWounded = _this select 3;

private _unitName = ENEMY_LIST_UNITS call BIS_fnc_selectRandom;
private _unit = _group createUnit [_unitName, _pos,[], AI_SKILLS,"NONE"];
[_unit] joinsilent _group;
// _group call JP_fnc_sendToHC;

if (DEBUG)then{
    [_unit,"ColorRed"] call JP_fnc_addmarker;
};

// [_unit] call JP_fnc_addTorch;
[_unit] call JP_fnc_handlekill;
[_unit] remoteExec ["JP_fnc_handleAttacked"];

if (!_excludedFromSpawnedUnit)then{
    UNITS_SPAWNED_CLOSE pushback _unit;
};

/*
_unit allowFleeing 1;
_group addEventHandler ["Fleeing", {
	params ["_group", "_fleeingNow"];
  hint "is fleeing";
  { 
    _dude = _x;
    _dude setCaptive true;
    _weapon = currentWeapon _dude;       
     removeAllWeapons _dude;
    _weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
    _weaponHolder addWeaponCargoGlobal [_weapon,1];
    _weaponHolder setPos (_dude modelToWorld [0,.2,1.2]);
    _weaponHolder disableCollisionWith _dude;
    _dir = random(360);
    _speed = 1.5;
    _weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir),4];  

   } foreach units _group;
}];*/

// Remove map
if (random 100 > 15) then {
 _unit removeItem "vn_o_item_map";
};

_unit


