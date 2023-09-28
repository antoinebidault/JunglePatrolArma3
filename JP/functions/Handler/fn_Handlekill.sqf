/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Triggered when an enemy soldier is killed

  Parameters:
    0: OBJECT - enemy soldier

  Returns:
    BOOL - true 
*/

 params["_unit"];
 
 [_unit, ["Killed",
{ 
        params["_unit","_killer"];
        _unit remoteExec ["RemoveAllActions",0];
        _side = side(group(_unit));
        if (_side == SIDE_CIV && isPlayer _killer)then{ 
            [_unit,_killer] call CIVILIAN_KILLED;
            [_unit,-10] remoteExec ["JP_fnc_updaterep",2];
        }else{
            if (_side == SIDE_ENEMY && group _killer == GROUP_PLAYERS)then{
                _unit remoteExec ["removeAllActions", 0, true];
                [_unit, ["Disguise",{
                    params ["_enemy","_unit"];
                    [_unit,_enemy] spawn JP_fnc_undercover;
                },nil,1.5,false,true,"","true",3,false,""]] remoteExec["addAction",0];

                //Search intel;
                 [ _unit,localize "STR_JP_handleKill_searchAndSecure","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_search_ca.paa","_this distance _target < 2","true",
                 {
                    playSound3D ["", _this select 1];
                  // (_this select 1) playActionNow "TakeFlag";
                 },
                 {},
                 {
                    _unit = (_this select 0);
                    _player = (_this select 1);
                    [_unit,_player] remoteExec ["ENEMY_SEARCHED",2];
                    [_unit, _player, 38] remoteExec ["JP_fnc_getIntel",2];
                },{},[],1,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd",0 , true];

                [_unit,_killer] call ENEMY_KILLED;
            };
        };
        _unit setVariable["JP_TaskNotCompleted",false];
        _unit setVariable["JP_unit_injured",false, true];
        _unit call JP_fnc_deleteMarker;

    }
 ]
 ] remoteExec ["addEventHandler",0,true];