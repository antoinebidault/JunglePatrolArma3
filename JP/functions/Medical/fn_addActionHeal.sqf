/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Add the heal action to unit

  Parameters:
    0: OBJECT - the unit

  Returns:
    BOOL - true 
*/


if (_this getVariable["JP_fnc_addActionHeal",-1] != -1) exitWith{};

[_this, {
	_actionId = [_this,localize "STR_JP_addActionHeal_heal","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa","\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_reviveMedic_ca.paa","_this distance _target <= 2","true",{
			params["_injured","_healer"];
			if (!alive _injured) exitWith {};
			_healer setVariable["JP_heal_injured", _injured, true];
			_injured setVariable["JP_healer", _healer, true];
			[_healer, "medicStart"] remoteExec ["playActionNow"];
			[_injured,"JP_fnc_carry"] spawn JP_fnc_removeAction; 
			[_injured,[localize "STR_JP_voices_injured_Argh",localize "STR_JP_voices_injured_ouch"] call BIS_fnc_selectRandom] spawn JP_fnc_talk;
			sleep 2;
			[_injured,[localize "STR_JP_voices_injured_sryMan",localize "STR_JP_voices_injured_fuckingMess",localize "STR_JP_voices_injured_iamPain",localize "STR_JP_voices_injured_hurts",localize "STR_JP_voices_injured_hitMe"] call BIS_fnc_selectRandom] spawn JP_fnc_talk;
			sleep 2;
			[_healer,[localize "STR_JP_voices_healer_dontGiveUp",localize "STR_JP_voices_healer_stayWithUs",localize "STR_JP_voices_healer_stayAlive",localize "STR_JP_voices_healer_wontAbandonYou",localize "STR_JP_voices_healer_keepOpenEyes"] call BIS_fnc_selectRandom] spawn JP_fnc_talk;
			[_injured] spawn JP_fnc_shout;
			[_healer,_injured,20] spawn JP_fnc_spawnHealEquipement;
			_offset = [0,0,0];
			_dir = 0;
			_relpos = _healer worldToModel position _injured;
			if ((_relpos select 0) < 0) then {_offset = [-0.2,0.7,0]; _dir = 90} else {_offset = [0.2,0.7,0]; _dir = 270};
			_injured attachTo [_healer, _offset];
			[_injured, _dir] remoteExec ["setDir", 0, false];
			true;
		},{
		//	params["_injured","_healer"];
		//	if (!alive _injured) exitWith { _healer playActionNow "medicStop"; };
			//_healer playActionNow "medicStart";
			true;
		},{
			params["_injured","_healer","_action"];
			_healer setVariable["JP_healer", objNull,true];
			_healer setVariable["JP_heal_injured", objNull, true];
			_injured setVariable ["JP_unit_injured", false, true];
			[_healer, "medicStop"] remoteExec ["playActionNow"];
			detach _injured;
			_injured setUnconscious false;
			_injured setDamage 0;
			_injured setCaptive false;
			_injured setHit ["legs", 0]; 
			[_injured,"JP_fnc_carry"] call JP_fnc_removeAction; 
			_injured call JP_fnc_removeActionHeal;
			deleteMarker (_injured getVariable ["JP_marker_injured",  ""]);
			
			// If civilian add a bonus
			if (side _injured == SIDE_CIV) then {
				[GROUP_PLAYERS,10] remoteExec ["JP_fnc_updateScore",2];   
			};
			
			[_healer,[localize "STR_JP_voices_healer_yourGoodToGo",localize "STR_JP_voices_healer_getCover",localize "STR_JP_voices_healer_goodForYouBuddy"] call BIS_fnc_selectRandom] spawn JP_fnc_talk;
			sleep 2;
			true;
		},{
			params["_injured","_healer"];
			_healer setVariable["JP_healer", objNull, true];
			_healer setVariable["JP_heal_injured", objNull, true];

			if (lifeState _healer != "INCAPACITATED") then {
				[_healer, "medicStop"] remoteExec ["playActionNow"];
			};

			if (lifeState _injured == "INCAPACITATED") then {
				[_injured, "JP_fnc_carry"] call JP_fnc_addAction; 
			};
			
			detach _injured;
			false;
		},[],12,nil,true,false] call BIS_fnc_holdActionAdd;
	_this setVariable["JP_fnc_addActionHeal", _actionId];
}] remoteExec ["call", GROUP_PLAYERS];
