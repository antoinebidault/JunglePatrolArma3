params["_pos"];


_spawnPos = [_pos, 50,70, 1, 0, .3, 0] call BIS_fnc_findSafePos;


_type = "Fin_random_F";
	
_animal = createAgent [_type, _spawnPos, [], 0, "NONE"];
_animal setVariable ["BIS_fnc_animalBehaviour_disable", true];
_animal disableAI "FSM";
// _animal forceWalk true;
_animal setBehaviour "CARELESS";
 _animal MoveTo _pos;

[leader GROUP_PLAYERS,"I've heard something, stay quiet..."] remoteExec ["JP_fnc_talk"];

["JP_investigate",["Investigate","Investigate","You've heard some noise coming from bushes..."],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, false];

_timer = time;
waitUntil { sleep 1; (_animal distance _pos < 3) || ((leader GROUP_PLAYERS) distance (getPos _animal) <= 2) || time > _timer + 5*60 };

if (time > _timer + 5*60 ) then {
	[leader GROUP_PLAYERS,"Nothing found... Let's get back to the camp"]  remoteExec ["JP_fnc_talk"];
	["JP_investigate", "FAILED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS, false];
}else{
	[leader GROUP_PLAYERS,"Holly shit ! That's just a fucking animal ! Have a sleep now !"]  remoteExec ["JP_fnc_talk"];
	["JP_investigate", "SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS, false];
};

OBJECTIVE_DONE = true;

