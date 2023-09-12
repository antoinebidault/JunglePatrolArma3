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
params["_unitChased","_destination","_max"];
private ["_enemy","_unitName"];
private _units = [];
AVALANCHE_TROOPS = [];
ENABLE_AVALANCHE = true;
publicVariable "ENABLE_AVALANCHE";

3 fadeMusic 1;
playMusic "vn_contact";

if (DEBUG) then {
  hint "Avalanche started";
};

_i = 0;
while { ENABLE_AVALANCHE } do {
    if ({alive _x && !captive _x}count AVALANCHE_TROOPS < _max) then {
      _dir =  360 - (_unitChased getDir _destination) ;
      _flankDir = 0;
      
      _flankDir = if (random 1 > 0.33) then { 0 } else { 60 };
      _pos = [getPos _unitChased, 350, _dir] call BIS_fnc_relPos; 
      private _nbUnit = 3 + round(random 3);
      private _grp = createGroup SIDE_ENEMY;
      private _posSelected = [_pos, 0, 50, 1, 0, 20, 0] call BIS_fnc_findSafePos;

      for "_xc" from 1 to _nbUnit do {
          _enemy = [_grp,_posSelected, false] call JP_fnc_spawnEnemy;
          _enemy setVariable["JP_Type","avalanche"];
          _enemy setDir random 360;
          _units pushback _enemy;
          AVALANCHE_TROOPS pushBack _enemy;
      };

      //Trigger chase
      [_grp,"JP_fnc_chase", [ _grp, _unitChased, true]] call JP_fnc_patrolDistributeToHC;

      sleep (30 * _i) min 5 * 60;
      _i = _i + 1;
    };
    sleep 10; 
};

if (DEBUG) then {
  hint "Avalanche stopped";
};

/*
{	
  _x call JP_fnc_deleteMarker; 
  deleteVehicle _x; 
} forEach AVALANCHE_TROOPS;*/