
comment "Exported from Arsenal by dugland";

comment "[!] UNIT MUST BE LOCAL [!]";
if (!local _this) exitWith {};

comment "Remove existing items";
removeAllWeapons _this;
removeAllItems _this;
removeAllAssignedItems _this;
removeUniform _this;
removeVest _this;
removeBackpack _this;
removeHeadgear _this;
removeGoggles _this;

comment "Add containers";
_this forceAddUniform "U_B_FullGhillie_sard";
_this addItemToUniform "FirstAidKit";
for "_i" from 1 to 3 do {_this addItemToUniform "30Rnd_762x39_Mag_F";};
_this addVest "V_BandollierB_oli";
for "_i" from 1 to 2 do {_this addItemToVest "HandGrenade";};
_this addItemToVest "SmokeShell";
_this addItemToVest "SmokeShellRed";
for "_i" from 1 to 2 do {_this addItemToVest "Chemlight_red";};
for "_i" from 1 to 2 do {_this addItemToVest "30Rnd_762x39_Mag_F";};
for "_i" from 1 to 2 do {_this addItemToVest "30Rnd_762x39_AK12_Mag_Tracer_F";};
_this addItemToVest "9Rnd_45ACP_Mag";
_this addGoggles "G_Bandanna_khk";

comment "Add weapons";
_this addWeapon "arifle_AKM_F";
_this addWeapon "hgun_Rook40_F";
_this addWeapon "Binocular";

comment "Add items";
_this linkItem "ItemMap"; 
_this linkItem "ItemCompass";
_this linkItem "ItemWatch";
_this linkItem "ItemRadio";
_this linkItem "ItemGPS";

comment "Set identity";
[_this,"PersianHead_A3_03","male01per"] call BIS_fnc_setIdentity;
