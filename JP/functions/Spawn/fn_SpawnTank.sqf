/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    TODO

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/
params["_spawnPos"];

_className = (ENEMY_LIST_TANKS call bis_fnc_selectrandom);
_tank = [[_spawnPos select 0, _spawnPos select 1, 0], 180, _className, SIDE_ENEMY] call BIS_fnc_spawnVehicle select 0;
_tank enableDynamicSimulation true;

_tank setPilotLight true;
_tank setCollisionLight true;
group _tank setBehaviour "SAFE";
driver _tank setBehaviour "SAFE";

if (DEBUG) then {
    private _marker = createMarker [format["tk-%1",random 10000],_spawnPos];
    _marker setMarkerShape "ICON";
    _marker setMarkerColor "ColorRed";
    _marker setMarkerType "o_armor";
    _tank setVariable["marker",_marker];
};

_tank setVariable ["JP_Type","tank",true];
_tank setVariable ["JP_TaskNotCompleted",true,true];

_tank addMPEventHandler ["MPKilled",{
      params["_tank","_killer"];
      if (isPlayer _killer || _killer in units GROUP_PLAYERS) then {
        //Task success
        _tank remoteExec ["JP_fnc_success",2,false];
      };
}];

[_tank];