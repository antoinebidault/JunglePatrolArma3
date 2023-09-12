
private ["_nearestSleepingPosition"];


JP_fnc_createCamp = {
     params["_pos"];
     
    {deleteVehicle _x;} foreach CAMP_OBJS;
    
    [player, "medic"] remoteExec ["playActionNow"];

     /*
    CAMP_MARKER setMarkerPos _pos;
    CAMP_MARKER setMarkerSize [70,70];
    CAMP_MARKER setMarkerShape "ELLIPSE"; 
    CAMP_MARKER setMarkerColor "ColorGreen";
    CAMP_MARKER setMarkerAlpha 0.2;
     */
    // Set up global scope variable for respawning all units
    CAMP_RESPAWN_POSITION = _pos;
    publicVariable "CAMP_RESPAWN_POSITION";

    // Update the respawn position
    if (!(CAMP_RESPAWN_POSITION_ID isEqualTo [])) then {
            CAMP_RESPAWN_POSITION_ID remoteExec ["BIS_fnc_removeRespawnPosition",0]; 
    };

    titleCut ["", "BLACK OUT", 3];
    sleep 3;

     _date = date;
     date set[3, 19];
     setDate _date;
    
    titleCut ["", "BLACK FADED", 9999];
    [parseText format ["<t font='tt2020style_e_vn_bold' size='1.6'>1 %1</t><br/>%2", localize "STR_JP_actionCamp_hourLater", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;

    CAMP_OBJS = [_pos,getDir player, compo_camp ] call BIS_fnc_objectsMapper;
    sleep 2;
    titleCut ["", "BLACK IN", 2];
    sleep 2;
    [player,localize "STR_JP_voices_teamLeader_campSetUp"] remoteExec ["JP_fnc_talk",0, false];

};

NIGHT_EVENT = "none";
if (count NIGHT_EVENTS_POOL > 0) then {
     NIGHT_EVENT = NIGHT_EVENTS_POOL call BIS_fnc_selectRandom;
     NIGHT_EVENTS_POOL = NIGHT_EVENTS_POOL - [NIGHT_EVENT];
};


_threshold = 0;
_nearestSleeping = SLEEP_POSITIONS select 0;

{
     if(_x distance2D player < player distance2D _nearestSleeping) then
     {
          _nearestSleeping  =  _x;
     };
} forEach SLEEP_POSITIONS;

SLEEP_POSITIONS = SLEEP_POSITIONS - [_nearestSleeping];
_nearestSleepingPosition = getPos _nearestSleeping;



{
    ["JP_primary_sleep",_x, ["Remain overnight","Remain overnight","Remain overnight"], _nearestSleepingPosition,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, true];
    [player,"Ok guy, it is time to take a Rest, let's find a safe place to have a sleep."] remoteExec ["JP_fnc_talk"];
} foreach ([] call JP_fnc_allPlayers);

waitUntil {(leader GROUP_PLAYERS) distance _nearestSleepingPosition < 20; };

_mkr = createMarker [format["sleep_bl_%1",random 999], _nearestSleepingPosition];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerSize [100,100];
_mkr setMarkerAlpha 0.2;
_mkr setMarkerColor "ColorOrange";
MARKER_WHITE_LIST pushback _mkr;

CHASER_VIEWED = false;
publicVariable "CHASER_VIEWED";

CHASER_TRIGGERED = false;
publicVariable "CHASER_TRIGGERED";

// Clean up all following units
{
     _x call JP_fnc_deleteMarker;
     deleteVehicle _x;
} forEach UNITS_SPAWNED_CLOSE;

[leader GROUP_PLAYERS,"Prepare the camp"] remoteExec ["JP_fnc_talk"];

sleep 5;

_camp = [_nearestSleepingPosition] call JP_fnc_createCamp;

[leader GROUP_PLAYERS,"Plants some claymore around the base and take care of your smells. The viet trackers are all around."] remoteExec ["JP_fnc_talk"];

SKIP_TIME = false;

[leader GROUP_PLAYERS,"Remain overnight","\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\holdAction_sleep2_ca.paa","\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\holdAction_sleep2_ca.paa","_this distance _target < 3","true",
     {},
     {},
     {
      params ["_target", "_caller", "_actionId", "_arguments"];
      if (NIGHT_EVENT == "none") then {
          SKIP_TIME = true;
          OBJECTIVE_DONE = true;
      } else {
          [floor (random 4)] call JP_fnc_skipTime;
      };
},{},[],1,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd",0 , true];

waitUntil {sleep 1; SKIP_TIME};

if (NIGHT_EVENT != "none") then {
     5 fadeMusic 0;
     [player,"Something is approaching be careful ! "] remoteExec ["JP_fnc_talk"];

     OBJECTIVE_DONE = false;
     _rnd = random 1;

     if (NIGHT_EVENT == 'defend') then {
          [_nearestSleepingPosition, 100] call JP_fnc_spawnDefendTask;
     }else{
          if (NIGHT_EVENT == 'mortar')then {
               [_nearestSleepingPosition, 100, 1, 5] call JP_fnc_spawnMortar;
          } else {
               if (NIGHT_EVENT == 'animal')then {
               [_nearestSleepingPosition, 100, 1, 5] call JP_fnc_spawnAnimal;
               }  else {
                    if (NIGHT_EVENT == 'patrol')then {
                    [_nearestSleepingPosition, 100] call JP_fnc_spawnTrackerPatrol;
                    };
               };
          };
     };

     waitUntil {sleep 5; OBJECTIVE_DONE};
     [player,"Good job ! Now let's have a sleep !"] remoteExec ["JP_fnc_talk"];
     sleep 20;
};


[7] call JP_fnc_skipTime;
[WEATHER] call JP_fnc_setWeather;

{
  ["JP_primary_sleep","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];
} foreach ([] call JP_fnc_allPlayers);

[] call JP_fnc_reconTask;
