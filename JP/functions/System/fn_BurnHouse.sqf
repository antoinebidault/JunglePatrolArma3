params ["_house"];

_house setDamage (if (random 1 > .5) then { 1 } else{ 0 });
_pos = position _house;
 _bound =  boundingBox _house;
 _pos set [2,(if (damage _house == 1) then {0} else { ((_bound select 1) select 2) - 1})];
 
elt = createVehicle ["test_EmptyObjectForFireBig",_pos,[],0,"NONE"]; 
//elt setPos _pos;