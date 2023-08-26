
_ammoGuard = missionNamespace getVariable ["ammo_guard",objNull];
_ammobox = missionNamespace getVariable ["ammo_base",objNull];
{
    ["JP_primary_ammo",_x, ["Get ammo","Get ammunitions","Go to the S4 logistic center"],getPos _ammobox,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",leader GROUP_PLAYERS, true];
} foreach ([] call JP_fnc_allPlayers);

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

_ammoBox addEventHandler ["ContainerOpened",{
    {
		params["_unit"];
        ["JP_primary_ammo","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",_x,true];
        [] spawn JP_fnc_insertionTask;
		_unit removeAllEventHandlers "ContainerOpened";
    } foreach ([] call JP_fnc_allPlayers);
}];

