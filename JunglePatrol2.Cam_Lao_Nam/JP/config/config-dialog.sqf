/*
	Author: 
		Bidass

  Version:
    0.9.5

	Description:
		Display the scenario configuration dialog
		This requires the config-dialog-functions to work properly.

*/


disableSerialization;

titleCut ["", "BLACK FADED", 999];

_anims = ["Acts_millerCamp_A","Acts_ShieldFromSun_loop","Acts_millerCamp_C","Acts_AidlPercMstpSloWWrflDnon_warmup_7_loop","Acts_AidlPercMstpSloWWrflDnon_warmup_8_loop","Acts_AidlPercMstpSloWWrflDnon_warmup_6_loop","acts_millerIdle","Acts_Briefing_SA_Loop","Acts_Briefing_SB_Loop"];
UNIT_SHOWCASE = player; 
{
	if (!isPlayer _x) then {
		[_x,"MOVE"] remoteExec ["disableAI"] ;
		[_x,"FSM"] remoteExec ["disableAI"] ;
	};
	_anim = _anims select 0;
	_anims = _anims - [_anim];
    [_x,_anim] remoteExec ["switchMove"];
	//_x setPosATL (player modelToWorld[(_foreachIndex+1),0,0]);
	_x setDir (direction player);
}
foreach units group player;

titleCut ["", "BLACK IN", 7];

// Start the camera 
[] call JP_fnc_initCamera;

// Open the dialog
[] call JP_fnc_openConfigDialog;
