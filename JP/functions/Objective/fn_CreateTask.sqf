/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    TODO

  Parameters:
    0: OBJECT - Item containing the intel. It must have a JP_type variable set up to work properly 
    1: BOOL - True to show the task with a visible notification 

  Returns:
    ARRAY - return an array of datas structured as following : 
    [
       0:NUMBER - taskId,
       1:STRING - message,
       2:STRING - message if success,
       3:NUMBER - _bonus
   ];
*/

private _intel = _this select 0;
private _withNotif = if (count _this >1)then{_this select 1}else{true};

 _type = _intel getVariable["JP_Type",""];
 _taskId = "neutral";
 _title = "neutral";
 _desc = "neutral";
 _message = "neutral";
 _messageSuccess = "neutral";
 _bonus = 0;
 _reputation = 0;

switch (_type) do {
    case "ied": { 
        _taskId = "IEDdisabling";
        _desc = "disarm the IED on the road. You need to be equiped with a toolkit, a mine detector and engineer abilities.";
        _title = "disarm the IED";
        _message = "I know something about an IED planted on this road. I can mark it on your map.";
        _messageSuccess = "This IED will no more cause trouble.";
        _bonus = 50;
        _reputation = 6;
     };
     case "wreck": { 
        _taskId = "WreckInvestigation";
        _desc = "Investigate the crashsite and neutralize the wreck with an explosive charge. This will give you extra credits";
        _title = "Chopper crash site (optional)";
        _message = "There is a chopper crash site in this sector.";
        _messageSuccess = "HQ, we cleaned up the crash site.";
        _bonus = 50;
        _reputation = 0;
     };
    case "hostage": {   
         _taskId = "hostage";
        _desc = "Find the hostage and liverate him.";
        _title = "Free the hostage";
        _message = "I know something about a hostage detained in this compound";
        _messageSuccess = "We've liberated a hostage located in this compound.";
        _bonus = 50;
        _reputation = 15;
     };
     case "outpost": {   
        _taskId = "outpost";
        _desc = "Clear all units in the outpost.";
        _title = "Clear the outpost";
        _message = "I've located an outpost with a few insurgents here.";
        _messageSuccess = "Outpost clear ! Good job !";
        _bonus = 50;
        _reputation = 2;
     };
     case "cache": {   
        _taskId = "cache";
        _desc = "Find and destroy the insurgent's cache hidden in the building";
        _title = "Destroy the cache";
        _message = "I've located a weapon cache in this building.";
        _messageSuccess = "We have successfully destroyed the cache";
        _bonus = 50;
        _reputation = 7;
     };
     case "sniper": {   
        _taskId = "snipers";
        _desc = "A sniper group located here";
        _title = "Kill the snipers";
        _message = "I've located a sniper team in this sector.";
        _messageSuccess = "The sniper team has been eliminated.";
        _bonus = 50;
        _reputation = 5;
     };
     case "tank": {   
        _taskId = "tank";
        _desc = "Destroy the tank";
        _title = "Destroy the tank";
        _message = "There is a heavy armor in this sector.";
        _messageSuccess = "Good job ! The tank has been destroyed.";
        _bonus = 50;
        _reputation = 0;
     };
      case "mortar": { 
        _taskId = "Mortar";
        _desc = "Destroy the mortar.";
        _title = "Destroy the mortar";
        _message = "There is a mortar position over here !";
        _messageSuccess = "This mortar won't cause any trouble.";
        _bonus = 50;
        _reputation = 5;
     };
       case "officer": { 
        _taskId = "officer";
        _desc = "Kill the officer";
        _title = "Kill the officer";
        _message = "An enemy officer is present here";
        _messageSuccess = "Good job ! The officer has benen eliminated !";
        _bonus = 50;
        _reputation = 5;
     };
    default { };
};

//Unique ID added to the task id;
_taskId = format["%1_%2",_taskId,random 200];
[GROUP_PLAYERS,  _taskId, [_desc,_title,_title],(getPos _intel),"CREATED",1,_withNotif,""] remoteExec ["BIS_fnc_taskCreate",GROUP_PLAYERS];
_intel setVariable["JP_Bonus",_bonus, true];
_intel setVariable["JP_Reputation",_reputation, true];
_intel setVariable["JP_Task",_taskId, true];

CURRENT_OBJECTIVE set [3, _taskId];

[_taskId,_message,_messageSuccess,_bonus,_title];

