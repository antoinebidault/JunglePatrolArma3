/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Spawn main objective intel.

  Parameters:
    0: OBJECT - unit

  Returns:
    BOOL - true 
*/

private _unit = _this;

if(!alive ENEMY_COMMANDER)exitWith {false};
if(count COMMANDER_LAST_POS == 0) exitWith {[_unit,"But I think you already know it..."] remoteExec ["JP_fnc_talk"];false;};

private _initPos = COMMANDER_LAST_POS call BIS_fnc_selectRandom;
COMMANDER_LAST_POS = COMMANDER_LAST_POS - [_initPos];

private _ratio = 0.8;
private _offset = 40;
private _distance = 350 + random 250;

//Get the marker random position
private _pos = [_initPos, _offset, (_distance - _offset) , 0, 0, 20, 0] call BIS_fnc_findSafePos;

deleteMarker "JP_intel_c";
_marker = createMarker ["JP_intel_c",_pos];
_marker setMarkerShape "ELLIPSE";
_marker setMarkerColor "ColorRed";
_marker setMarkerBrush "Border";
_marker setMarkerSize [_distance,_distance];
_marker setMarkerPos _pos;

private _nb = (2+round(random 2));
for "_j" from 1 to _nb do {
    if (_j > 1) then{
      _initPos = [["JP_intel_c"],["water"]] call BIS_fnc_randomPos;
    };
    deleteMarker format["JP_intel_q_%1",_j];
    _marker = createMarker [format["JP_intel_q_%1",_j],_initPos];
    _marker setMarkerShape "ICON";
    _marker setMarkerColor "ColorRed";
    _marker setMarkerType "hd_unknown";
    _marker setMarkerPos _initPos;
};

//Unique ID added to the task id;
_taskId = "maintask";

[[_unit,_taskid,_pos],{
  params ["_unit","_taskid","_pos"];
  [_unit,"I marked you on the map where I think he is.",true] call JP_fnc_talk;
  {
    [_taskId, _x, [ "Investigate the sector where the enemy\n commander is possibly located","Investigate the sector","Investigate the sector"], _pos, "ASSIGNED", 1, true, true,""] remoteExec ["BIS_fnc_setTask" ,_x , true];
  } foreach ([] call JP_fnc_allPlayers);
  [(leader GROUP_PLAYERS),"Thank you, we'll investigate this place.",true] call JP_fnc_talk;
  [(leader GROUP_PLAYERS),"HQ, we've caught informations about the possible enemy commander last position."] call JP_fnc_talk;
  [HQ,"Copy ! We'll send you extra credits in order to accomplish your task. Good luck ! Out."] call JP_fnc_talk;
}] remoteExec["spawn", GROUP_PLAYERS, false];

[GROUP_PLAYERS,250,false,(leader GROUP_PLAYERS)] call JP_fnc_updatescore;

if (!isMultiplayer) then{
	saveGame;
};


true;