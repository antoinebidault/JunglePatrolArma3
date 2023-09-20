/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Catch firednear event => Make civilian join the guerilla if attacked
	CREDITS : Thanks to phronk : https://forums.bistudio.com/profile/785811-phronk/

  Parameters:
    0: OBJECT - civilian unit

  Returns:
    BOOL - true 
*/



[_this ,["FiredNear",
{
	_civ=_this select 0;	
	_distance = _this select 2;	
	_gunner = _this select 7;	
	
	// Check the civ is not too far
	if ( { _civ distance _x > 30 && _civ distance _x < 400 } count ([] call JP_fnc_allPlayers) == count ([] call JP_fnc_allPlayers) && (_civ getVariable["JP_Suspect", true] || (random 100) < PERCENTAGE_INSURGENTS))then{
		
		//Remove the eventHandler to prevent spamming
		[_civ , "FiredNear"] remoteExec ["removeAllEventHandlers", 0, true];
		[_civ,_gunner] spawn JP_fnc_spawnAsEnemy;
	}else{
		group _civ setspeedmode "FULL";
		_civ forceWalk false;
		
        _civ remoteExec ["removeAllActions",0];
		
		switch(round(random 2))do{
			case 0:{_civ switchMove "ApanPercMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			case 1:{_civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			case 2:{_civ playMoveNow "ApanPpneMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
			default{_civ playMoveNow "ApanPknlMstpSnonWnonDnon_G01";_civ setSpeedMode "FULL";};
		};		

		_nH=nearestObjects [_civ, ["house"], 100];		

		//Pick an object found in the above nearestObjects array		
		_H=selectRandom _nH;

		//Finds list of all available building positions in the selected building		
		_HP=_H buildingPos -1;

		//Picks a building position from the list of building positions		
		_HP=selectRandom _HP;

		//Orders the civilian to move to the building position		
		_civ doMove _HP;

		//Make unit shout
		if (_distance < 40)then{
			[_civ] call JP_fnc_shout;
		};
		
		_civ setVariable["civ_affraid",true, true];

		//Remove the eventHandler to prevent spamming
		[_civ, "FiredNear"] remoteExec ["removeAllEventHandlers", 0, true];

		//Action to make him calm down !
		[_civ,[localize "STR_JP_handleKill_calm",{
			params["_unit","_asker","_action"];
			_unit removeAction _action;
				if (!weaponLowered _asker)then{
				_asker  action ["WeaponOnBack", _asker];
			};
			[_asker,localize "STR_JP_handleKill_calmFriend"] call JP_fnc_talk;
			_unit stop true;
			_unit  setVariable["civ_affraid",false, true];
			sleep .3;
			[_unit,""] remoteExec ["switchMove",0];
			sleep .3;
			[_unit] remoteExec ["JP_fnc_addCivilianAction",0];
			[_unit,2] remoteExec ["JP_fnc_updateRep",2];
			sleep 15;
			_unit stop false;
			_unit call "JP_fnc_handleFiredNear";
		},nil,1.5,false,true,"","true",2,false,""]] remoteExec ["addAction"];

		if (isPlayer _gunner )then {
			[_unit,-5] remoteExec ["JP_fnc_updateRep",2];
		}else{
			[_unit,1] remoteExec ["JP_fnc_updateRep",2];
		};
	};

}]
] remoteExec ["addEventHandler", 0,true];
