/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Make the task successful.

  Parameters:
    0: OBJECT - unit with the task

  Returns:
    BOOL - true 
*/

private _objWithTask = _this;
private _task = "";
private _taskName = "";

// Success
if (!isServer) exitWith{hint format["JP_fnc_success executed on the client %1 ;/", _objWithTask getVariable["JP_Task",""]]; };

//Task type unknown
if (_objWithTask getVariable["JP_Type",""] == "") exitWith { false };

//Task already successful
if (!(_objWithTask getVariable["JP_TaskNotCompleted",true])) exitWith {false};

_task = _objWithTask getVariable["JP_Task",""];

// Silently create a task if not exists
if (_task == "") then {
  _result = [_objWithTask,false] call JP_fnc_createTask;
  _task = _objWithTask getVariable["JP_Task",""];
  _taskName = _result select 4;
} else {
  _taskName = ((_task call BIS_fnc_taskDescription) select 1) select 0;
};

// Spawn task successful on each client
[[_task,_taskName,_objWIthTask],{
  params["_task","_taskName","_objWithTask"];
  [_task, "SUCCEEDED", true] call BIS_fnc_taskSetState;
}] remoteExec ["spawn", GROUP_PLAYERS,false];

//Custom callback
[_objWithTask,_objWithTask getVariable["JP_Reputation",0]] remoteExec ["JP_fnc_updateRep",2];
if (_objWithTask getVariable["JP_Bonus",0] > 0) then{
    [GROUP_PLAYERS,_objWithTask getVariable["JP_Bonus",0],false,leader GROUP_PLAYERS]  remoteExec ["JP_fnc_updateScore",0];
};

//Delete the task after success.
_objWithTask getVariable["JP_MarkerIntel",""] setMarkerColor "ColorGreen";
_objWithTask setVariable["JP_Task","", true];
_objWithTask setVariable["JP_Type","",true];
_objWithTask setVariable["JP_TaskNotCompleted",false, true];
_objWithTask setVariable["JP_IsIntelRevealed",false, true];

STAT_INTEL_RESOLVED = STAT_INTEL_RESOLVED + 1;
publicVariable "STAT_INTEL_RESOLVED";

true;