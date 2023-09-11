/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    TODO

  Parameters:
    0: OBJECT - TODO

  Returns:
    BOOL - true 
*/
params["_grp"];
private ["_transporthelo","_chopper","_start","_ch"];

_chopperClassName = SUPPORT_MEDEVAC_CHOPPER_CLASS call BIS_fnc_selectrandom; 
_start = [position (([] call JP_fnc_allPlayers) call BIS_fnc_selectRandom), 4000, 4500, 0, 0, 20, 0] call BIS_fnc_findSafePos;

_ch = [[_start select 0, _start select 1, 50], 180, _chopperClassName, side _grp] call BIS_fnc_spawnVehicle;

_transporthelo = _ch select 0;
_chGroup = _ch select 2; 
_chGroup setBehaviour "CARELESS"; 
_transporthelo setVehicleLock "LOCKEDPLAYER";
_transporthelo setCaptive true;

//If the chopper is destroyed => Abort medevac
_transporthelo addMPEventHandler ["MPKilled",{
     MEDEVAC_State = "aborted"; 
}];

_transporthelo; 