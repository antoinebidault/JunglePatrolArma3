
comment "Remove existing items";
removeAllWeapons _this;
removeAllItems _this;
removeAllAssignedItems _this;
removeUniform _this;
removeVest _this;
removeBackpack _this;
removeHeadgear _this;
removeGoggles _this;

comment "Add weapons";
_this addWeapon "vn_mat49_vc";
_this addPrimaryWeaponItem "vn_mat49_vc_mag";
_this addWeapon "vn_m1895";
_this addHandgunItem "vn_m1895_mag";

comment "Add containers";
_this forceAddUniform "vn_o_uniform_vc_03_04";
_this addVest "vn_o_vest_vc_05";

comment "Add items to containers";
_this addItemToUniform "vn_o_item_firstaidkit";
for "_i" from 1 to 3 do {_this addItemToUniform "vn_mat49_vc_mag";};
for "_i" from 1 to 2 do {_this addItemToUniform "vn_m1895_mag";};
_this addItemToVest "vn_rdg2_mag";
_this addItemToVest "vn_chicom_grenade_mag";
_this addItemToVest "vn_molotov_grenade_mag";
_this addHeadgear "vn_o_boonie_vc_02_01";
_this addGoggles "vn_o_scarf_01_01";

comment "Add items";
_this linkItem "vn_o_item_map";
_this linkItem "vn_b_item_compass";
_this linkItem "vn_b_item_watch";
_this linkItem "vn_o_item_radio_m252";

comment "Set identity";
[_this,"vn_vietnamese_02_01_face","vie"] call BIS_fnc_setIdentity;
