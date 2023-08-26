
params["_item","_player"];

[GROUP_PLAYERS,ceil((_item getVariable["JP_price",0])/2)] remoteExec ["JP_fnc_updatescore",2];
deleteVehicle _item;