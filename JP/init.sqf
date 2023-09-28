/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Main components preloading and initialization
*/


// Default configuration is called here
titleCut ["", "BLACK FADED", 9999];
missionNamespace setVariable["JP_SCORE", 0];


// Total blackout on startup
if (!isNull player) then {

  [] spawn {
    showCinemaBorder true;
    _camPos = player modelToWorld [20,-18.2,12];
    _chopper = missionNamespace getVariable["chopper_insertion", objNull];
    _cam = "camera" camcreate _camPos;
    _cam cameraeffect ["internal", "back"];
    _cam camSetPos _camPos;
    _cam camSetTarget (_chopper modelToWorld [-1,-0.2,3]);
    _cam camSetFov 1.0;
    _cam camCommit 0;
    playMusic "vn_blues_for_suzy";
    if (daytime > 8 && daytime < 20) then {
      ["Mediterranean",0,false] call bis_fnc_setppeffecttemplate;
    };
    sleep 3;
    titleCut ["", "BLACK IN", 6];

    [] spawn {

     // Position control
      _w = 0.7 * safeZoneW;
      _xPos = safeZoneX + (0.15 * safeZoneW );
      _y = safeZoneY + (0.35 * safeZoneH);
      _h = safeZoneH;

      _layer = round (random 99999);
      disableSerialization;
      _layer cutrsc ["rscDynamicText","plain"];
      _display = displayNull;
      waitUntil {_display = uiNamespace getVariable "BIS_dynamicText"; !(isNull _display)};
      _ctrl = _display displayCtrl 9999;
      _pic = "images\jungle-patrol.paa"; 
      _text = parseText format ["<t align='center' shadow='2' size='.8' ><img  size='6' shadow='0' image='%1' /></t>",_pic];
      _ctrl ctrlSetStructuredText _text;

      _ctrl ctrlSetPosition [_xPos,.95*_y,_w,_h];
      _ctrl ctrlCommit 0;
      _ctrl ctrlSetPosition [_xPos,_y,_w,_h];

      // Hide control
      _ctrl ctrlSetFade 0;
      _ctrl ctrlCommit .3;
      sleep 7;
      _ctrl ctrlSetFade 1;
      _ctrl ctrlCommit 4;
   };
      /*
        [ 
          '', 
          _xPos, 
          _y, 
          _w, 
          _h, 
          0, 
          12345
        ] spawn BIS_fnc_dynamicText;
      };*/

    
      _cam camSetPos  (player modelToWorld [20,-19.2,15]);
      _cam camSetFov 1.5;
      _cam camCommit 7;

    
    enableSentences false;
    enableRadio false;
    
    sleep 2;
    sleep 3;
    titleCut ["", "BLACK OUT", 3];
    sleep 4;
    titleCut ["", "BLACK IN", 1];
    camDestroy _cam;
    _cam cameraeffect ["terminate", "back"];
    "dynamicBlur" ppEffectEnable true;  
    "dynamicBlur" ppEffectAdjust [6];   
    "dynamicBlur" ppEffectCommit 0;   
    "dynamicBlur" ppEffectAdjust [0.0];  
    "dynamicBlur" ppEffectCommit 6;   
    // Enable radio
    enableSentences true;
    enableRadio true;
    
    // [worldName, format["%1km from %2", round(((getPos _loc) distance2D player)/10)/100,text _loc], str(date select 1) + "." + str(date select 2) + "." + str(date select 0), daytime call BIS_fnc_timeToString] spawn BIS_fnc_infoText;
    sleep 10;
    ["",5,true] call bis_fnc_setppeffecttemplate;
    //titleCut ["", "BLACK IN", 5];

  };

}; 


// Global simulation system enabled
enableDynamicSimulationSystem true;
"Group" setDynamicSimulationDistance 600;

// CONFIG
call(compileFinal preprocessFileLineNumbers  "JP\config\config-dialog-functions.sqf");
JP_fnc_dialog =  compileFinal preprocessFileLineNumbers "JP\config\config-dialog.sqf";
JP_fnc_missionSetup =  compileFinal preprocessFileLineNumbers "JP\config\MissionSetup.sqf";

// Action preparation
[] call JP_fnc_addActionFunctions; 

// Loadout
JP_fnc_loadoutSniper = compileFinal preprocessFileLineNumbers  "JP\Loadout\Loadout-sniper.sqf";
JP_fnc_loadoutSpotter = compileFinal preprocessFileLineNumbers  "JP\Loadout\Loadout-spotter.sqf";

//composition
compo_camp1 =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp1.sqf");
compo_camp2 =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp2.sqf");
compo_camp3 =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp3.sqf");
compo_camp4 =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp4.sqf");
compo_camp5 =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp5.sqf");
compo_commander1 =  call (compileFinal preprocessFileLineNumbers "JP\composition\commander1.sqf");
compo_commander2 =  call (compileFinal preprocessFileLineNumbers "JP\composition\commander2.sqf");
compos = [compo_camp1,compo_camp2,compo_camp3,compo_camp4,compo_camp5];
compo_rest =  call (compileFinal preprocessFileLineNumbers "JP\composition\rest.sqf");
compo_camp =  call (compileFinal preprocessFileLineNumbers "JP\composition\camp.sqf");
compo_captured =  call (compileFinal preprocessFileLineNumbers "JP\composition\captured.sqf");
compo_startup =  call (compileFinal preprocessFileLineNumbers "JP\composition\startup-composition.sqf");
compos_turrets=  call (compileFinal preprocessFileLineNumbers "JP\composition\compound\turrets.sqf");
compos_objects =  call (compileFinal preprocessFileLineNumbers "JP\composition\compound\objects.sqf");
compos_medical =  call (compileFinal preprocessFileLineNumbers "JP\composition\compound\medical.sqf");


// Mission introduction function
JP_fnc_intro  = compileFinal preprocessFileLineNumbers "JP\intro\intro.sqf";

// ACE detection
ACE_ENABLED = if (isClass(configFile >> "CfgPatches" >> "ace_main")) then { true; } else { false; };
if (ACE_ENABLED) then {
    [] call (compileFinal preprocessFileLineNumbers "JP\config\ace-config.sqf"); 
};

[] call (compileFinal preprocessFileLineNumbers "JP\config\config-default.sqf"); 

// Wait until everything is ready
waitUntil {count ([] call JP_fnc_allPlayers) > 0 && time > 0 };


// Public variables
call (compileFinal preprocessFileLineNumbers "JP\variables.sqf"); 

	{
		if (!isPlayer _x) then {
			_x disableAI "MOVE";
		};
	} forEach units GROUP_PLAYERS;

[] execVM "JP\client.sqf";
[] execVM "JP\server.sqf";
[] execVM "JP\headlessClient.sqf";