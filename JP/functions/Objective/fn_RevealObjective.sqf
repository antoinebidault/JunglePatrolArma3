  _intel = _this;
  
if (!(_intel getVariable["JP_IsIntelRevealed",false])) then {
  _intel setVariable["JP_IsIntelRevealed",true, true];
  _marker = createMarker [format["obj-s%1",random 13100],getPos _intel];
  _marker setMarkerShape "ICON";
  _marker setMarkerColor "ColorRed";
  _marker setMarkerType "hd_objective";
  _intel setVariable["JP_MarkerIntel",_marker];
  _task = [_intel,true] call JP_fnc_createtask;
} else {
  if (_intel getVariable["JP_IsIntelRevealed",false]) then {
    _taskId = _intel getVariable["JP_Task",""];
    [_taskId,getPos _intel] call BIS_fnc_taskSetDestination;
  };
};