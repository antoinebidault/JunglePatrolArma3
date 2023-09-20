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

CRASHSITES  = [];

if (NUMBER_CRASHSITES == 0)exitWith{CRASHSITES};

 _worldSize = (getMarkerSize GAME_ZONE) select 0;
_worldCenter = getMarkerPos GAME_ZONE;
private _tempMarkers = MARKER_WHITE_LIST;

//while {count CRASHSITES < NUMBER_CRASHSITES} do{

    // _spawnPos = [_worldCenter, 0, (_worldSize/2)*.8, 5, 0, .3, 0, _tempMarkers] call BIS_fnc_findSafePos;
    
    // Temp marker with previously spawned tank
    /*
    _tmpmarker = createMarker [format["ch-bl-%1",random 10000], _spawnPos];
    _tmpmarker setMarkerSize [1400,1400];
    _tmpmarker setMarkerShape "ELLIPSE";
    _tmpmarker setMarkerAlpha 0;
    _tempMarkers = _tempMarkers + [_tmpmarker];
    */
    
    _className = (WRECK_LIST call bis_fnc_selectrandom);
    _crater = createVehicle ["Crater", _spawnPos, [], round random 360, "NONE"];
  
    _chopper = createVehicle [_className, _spawnPos, [], round random 360, "NONE"];
    // _chopper enableSimulationGlobal false;
    
    _crater setPos (getPos _chopper);
    _wreckSmoke = "test_EmptyObjectForSmoke" createVehicle (getPos _chopper);
    _wreckSmokePosition = _chopper modelToWorld [-1, 1.45703, -2.2991];
    _wreckSmoke setPosATL _wreckSmokePosition;

    /*_chopper setDamage 1;
    _chopper setVehicleLock "LOCKED";*/

/*
    private _marker = createMarker [format["tk-%1",random 10000],getPos _chopper];
    _marker setMarkerShape "ICON";
    _marker setMarkerColor "ColorRed";
    _marker setMarkerType "b_air";
    _chopper setVariable["marker",_marker];
*/
    _chopper setVariable ["JP_Type","wreck", true];
    _chopper setVariable ["JP_TaskNotCompleted",true, true];
    _chopper setVariable ["JP_IsIntelRevealed",false, true];
    
     //Search intel;
     [_chopper,"Secure and put the charge on...","\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa","\a3\ui_f_oldman\data\IGUI\Cfg\holdactions\destroy_ca.paa","_this distance _target < 6","true",
     {},
     {},
     {
          [_this select 0, _this select 1] spawn {
               params["_chopper","_player"];
              
               [_player,"30 seconds before detonation"] remoteExec ["JP_fnc_talk"];
               sleep 24;
               [_player,"5..."] remoteExec ["JP_fnc_talk"];
               [_player,"...4..."] remoteExec ["JP_fnc_talk"];
               [_player,"...3..."] remoteExec ["JP_fnc_talk"];
               [_player,"...2..."] remoteExec ["JP_fnc_talk"];
               [_player,"...1"]  remoteExec ["JP_fnc_talk"];

               _chopper remoteExec ["JP_fnc_success",2, false];

               _bomb = "HelicopterExploBig";
               _boom = _bomb createVehicle getPos _chopper;

               CRASHSITES = CRASHSITES - [_chopper];
               publicVariable "CRASHSITES";

               sleep 1;
               deleteVehicle _chopper;
          };

     },{},[],8,nil,true,false] remoteExec ["BIS_fnc_holdActionAdd"];

    // Add to markers

    _enemyArea = createMarker [format["ch-bl-%1",random 10000], getPos _chopper];
    _enemyArea setMarkerSize [144,144];
    _enemyArea setMarkerShape "ELLIPSE";
    _enemyArea setMarkerAlpha 0;
    _civ = 0;
    _en = 0;
    if (random 100 > 50) then { _civ = 4;} else { _en  = 4; };
    MARKERS pushback [_enemyArea,getPos _chopper,false,false,40,[],[_civ,0,_en,0,0,0,0,0,0,0],[], 0,true,false,[],"chopper", 50,"Chopper crash site",[],"none", false, [0,0,0,0,0,0,0,0,0,0]];
    CRASHSITES pushback _chopper;
// };

// publicVariable "CRASHSITES";

CRASHSITES;