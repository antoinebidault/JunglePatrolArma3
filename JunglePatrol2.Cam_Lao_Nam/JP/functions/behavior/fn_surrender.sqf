/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    Make the enemy soldier surrender

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/

params["_unit","_gunner"];

_unit removeAllEventHandlers "FiredNear";
_unit setCaptive true;
_unit action ["Surrender", _unit]; 
removeHeadgear _unit;
_weapon = currentWeapon _unit;     
_unit removeWeapon (currentWeapon _unit);
sleep .2;
_weaponHolder = "WeaponHolderSimulated" createVehicle [0,0,0];
_weaponHolder addWeaponCargoGlobal [_weapon,1];
_weaponHolder setPos (_unit modelToWorld [0,.2,1.2]);
_weaponHolder disableCollisionWith _unit;
_dir = random(360);
_speed = 1.5;
_weaponHolder setVelocity [_speed * sin(_dir), _speed * cos(_dir),4];  

sleep 2; 
if (!isNull _gunner && group _gunner == GROUP_PLAYERS && alive _unit) then {
  [_gunner,localize (["STR_JP_surrender_1","STR_JP_surrender_2","STR_JP_surrender_3", "STR_JP_surrender_4"] call BIS_fnc_selectRandom)] spawn JP_fnc_talk;
  _unit call JP_fnc_addActionLiberate;
  _unit call JP_fnc_addActionLookInventory;
  _unit call JP_fnc_addActionGetIntel;
  [_unit] call JP_fnc_shout;
};