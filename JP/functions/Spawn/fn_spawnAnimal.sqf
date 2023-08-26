params["_pos"];


_spawnPos = [_pos, 50,70, 1, 0, .3, 0] call BIS_fnc_findSafePos;


_type = if (random 1 > 0.5) then { "Fin_random_F";} else { "Goat_random_F" };
	
_animal = createAgent [_type, _spawnPos, [], 0, "NONE"];
_animal setVariable ["BIS_fnc_animalBehaviour_disable", true];
_animal disableAI "FSM";
// _animal forceWalk true;
_animal setBehaviour "CARELESS";
 _animal MoveTo _pos;

[leader GROUP_PLAYERS,"I've heard something, stay quiet..."] call JP_fnc_talk;

{
	["JP_investigate", _x, ["Investigate","Investigate","You've heard some noise coming from bushes..."],_pos,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",_x, false];
} foreach units GROUP_PLAYERS;  


waitUntil { sleep 1; (_animal distance _pos < 3) || ((leader GROUP_PLAYERS) distance (getPos _animal) <= 2) };

[leader GROUP_PLAYERS,"Holly shit ! That's just a fucking animal ! Have a sleep now !"] call JP_fnc_talk;

{
	["JP_investigate", "SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",_x, false];
} foreach units GROUP_PLAYERS;  

OBJECTIVE_DONE = true;

