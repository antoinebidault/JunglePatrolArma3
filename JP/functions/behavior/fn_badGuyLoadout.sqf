/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Transform a civil in an insurgent with an AK, magazines...
    The unit's gear is randomized

  Parameters:
    0: OBJECT - unit
    0: OBJECT - unit's side

  Returns:
    OBJECT - unit 
*/ 
params ["_unit","_side"];

[_unit] joinSilent grpNull;
[_unit] joinSilent (createGroup _side);
[_unit,""] remoteExec ["switchMove"];

private _marker = _unit getVariable["marker",""];

if (_side == SIDE_ENEMY) then {
  _unit stop true;
  [_unit, "TakeFlag"] remoteExec ["playActionNow"];
  sleep 1;
};

_unit removeAllEventHandlers "HandleDamage";
_unit removeAllEventHandlers "FiredNear";


// Random weapon loadout
switch (floor(random 3)) do
{
  case 0:
  {       
    _unit addVest "vn_o_vest_vc_04";
    _unit addMagazines ["vn_izh54_mag", 5];
    _unit addWeapon "vn_izh54"; 
    _unit addMagazine "HandGrenade";
  };
  case 1:
  {
    _unit addVest "vn_o_vest_vc_02";
    _unit addMagazines ["vn_rdg2_mag", 5];
    _unit addWeapon "vn_m9130";
    _unit addMagazine "vn_rg42_grenade_mag";
  };
  case 2:
  {
    _unit addMagazines ["vn_sks_t_mag", 5];
    _unit addWeapon "vn_sks_gl";
  };
  case 3:
  {
    _unit addVest "vn_o_vest_01";
    _unit addMagazines ["vn_type56_t_mag", 5];
    _unit addWeapon "vn_type56";
  };
};
_unit addItem "FirstAidkit";

_unit setskill ["Endurance",1];
_unit setskill ["aimingSpeed",0.7];
_unit setskill ["aimingAccuracy",0.8];
_unit setskill ["Endurance",1];
_unit setskill ["general",0.5];

_unit stop false;

if (_side == SIDE_ENEMY)then{  
  _unit remoteExec ["RemoveAllActions",0];        
  _marker setMarkerColor "ColorRed";
  _unit setVariable["JP_Type","enemy"];
  sleep 4;
  [_unit, "MountOptic"] remoteExec ["playActionNow"];
  sleep 3;
  _unit SetBehaviour "COMBAT";
}else{
  _marker setMarkerColor "ColorGreen";
  _unit setVariable["JP_Type","civ"];
};

_unit allowFleeing .1;  

_unit;