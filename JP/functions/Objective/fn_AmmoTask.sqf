if (!isServer) exitWith {false};
_ammoGuard = missionNamespace getVariable ["ammo_guard",objNull];
_ammobox = missionNamespace getVariable ["ammo_base",objNull];

["JP_primary_ammo",GROUP_PLAYERS,  ["Get ammo","Get ammunitions","Go to the S4 logistic center and get ammo from the box"],getPos _ammobox,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];

_trig = createTrigger["EmptyDetector",getPosATL _ammobox];
_trig setTriggerArea[7,7,0,FALSE,3];
_trig setTriggerActivation["ANYPLAYER","PRESENT",false];
_trig setTriggerTimeout[1,1,1,true];
_trig setTriggerStatements[
    "this",
    " [ammo_guard,""Hello sergeant ! This will be a long mission, take lots of mags""] remoteExec [""JP_fnc_talk""];
    ",
    "deleteVehicle thisTrigger;"
];

[_ammoBox, ["ContainerOpened",{
    params["_ammo"];
    ["JP_primary_ammo","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
    [] remoteExec ["JP_fnc_insertionTask", 2];
    [_ammo,"ContainerOpened"] remoteExec ["removeAllEventHandlers",0,true];
}]] remoteExec ["addEventHandler",0,true];

