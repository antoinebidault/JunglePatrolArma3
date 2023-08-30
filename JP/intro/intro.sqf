/*0 fadeSound .2;
titleCut [localize "STR_JP_intro_loading", "BLACK FADED",999];
_cam = "camera" camcreate START_POSITION;
_cam cameraeffect ["internal", "back"];
showCinemaBorder true;

waitUntil {!isNull(CHOPPER_INTRO)};
_dest = START_POSITION;
_chopper = CHOPPER_INTRO;


sleep 1;
titleCut ["", "BLACK IN",10];

*/
	nul = [localize "STR_JP_intro_authorPresent",.3,.7,8] spawn BIS_fnc_dynamicText;
	1 fadeMusic 1;
	playMusic "vn_dont_cry_baby";
	sleep 14;
	nul = [localize "STR_JP_intro_scenario",.5,.2,8] spawn BIS_fnc_dynamicText;
	/*
	sleep 14;
	    _pic = "images\jungle-patrol.paa"; 
        [ 
          '<img align=''left'' size=''7.1'' shadow=''0'' image='+(str(_pic))+' />', 
          safeZoneX+.7, 
          safeZoneY+safeZoneH-1.2, 
          6, 
          0, 
          0, 
          12345
        ] spawn bis_fnc_dynamicText;*/
	sleep 8;
	// nul = [localize "STR_JP_intro_oriIdea",.2,.3,5] spawn BIS_fnc_dynamicText;
	sleep 8;
	nul = [localize "STR_JP_intro_trad",.3,.2,5] spawn BIS_fnc_dynamicText;
	/*sleep 8;
	nul = [localize "STR_JP_intro_music",.3,.7,5] spawn BIS_fnc_dynamicText;*/
	sleep 5;
	nul = [localize "STR_JP_intro_speThanksNovakat77",.3,.5,5] spawn BIS_fnc_dynamicText;
/*
_camPos =  [getPos _chopper, 400,[getPos _chopper,_dest] call BIS_fnc_dirTo] call BIS_fnc_relPos;
_camPos set[2,30];
_cam camSetPos _camPos;
_cam camsettarget _dest;
_cam camcommit 0;

_camPos set[2,40];
_cam camSetPos _camPos;
_cam camcommit 14;

sleep 13;

_cam camsettarget _chopper modelToWorld[0,0,-14];
_cam camcommit 4;

sleep 14;

_smoke = "SmokeShellYellow" createVehicle  _dest; 

[_cam,_chopper, [0,40,4], 7] call JP_fnc_camfollow;

deleteVehicle _smoke;
_dest set [2,5];
_cam camSetPos _dest;
_cam camsettarget _chopper modelToWorld[0,0,-10];
_cam camcommit 0;

_dest set [2,10]; 
_cam camSetPos _dest;
_cam camcommit 10;

sleep 10;

// [_cam,_chopper, [-14,22,-15],7] call JP_fnc_camfollow;

titleCut ["", "BLACK OUT", 1];
sleep 1;
titleCut ["", "BLACK FADED", 9999];

camDestroy _cam;
showCinemaBorder false;
_cam cameraeffect ["terminate", "back"];
8 fadeSound 1;	

// [player, "All units deployed to the insertion point", 150, 250, 75, 1, [], 0, false] call BIS_fnc_establishingShot;
*/