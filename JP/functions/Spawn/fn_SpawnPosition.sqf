/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Get the enterable buildings in a position

  Parameters:
    0: ARRAY - pos
    1: NUMBER - radius

  Returns:
    ARRAY - [positions,buildings] list of buildings and positions 
*/

//list buildings
params["_pos","_radius","_buildings","_max"];

//list buildings
_positions = [];

//list buildings
// private _buildings = nearestObjects [_pos, ["house"], _radius*1.3];
{
    _posBuilding = [_x] call BIS_fnc_buildingPositions;
    for "_uc" from 0 to 1 do {
          _rndpos = ([_posBuilding] call BIS_fnc_selectRandom) select 0;
        _posBuilding = _posBuilding - [_rndpos];
        _positions pushback _rndpos;
    };
} foreach _buildings;

if (count _buildings > _max) then {
  _temp = [];
  for "_uc" from 1 to _max do {
    _random = (_positions call BIS_fnc_selectRandom);
    _temp pushBack _random;
    _positions = _positions - [_random];
  };
  [_temp];
};

[_positions];
