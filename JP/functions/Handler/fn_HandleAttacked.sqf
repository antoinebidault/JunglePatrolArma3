/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    FiredNear handler attached to enemy unit
	It will make the unit surrender when over pressured
	(Wounded, low morale, less distance from gunner, whole team decimated...)

  Parameters:
    0: OBJECT - unit

  Returns:
    BOOL - true 
*/

 params["_unit"];
[_unit, ["FiredNear",
	{
		_unit=_this select 0;	
		_distance = _this select 2;	
		_muzzle = _this select 4;	
		_gunner = _this select 7;	
		if (!captive _unit && side _gunner == SIDE_FRIENDLY && lifeState _unit != "INCAPACITATED" && count (units (group _unit)) <= 2 && damage _unit > .1 && morale _unit < -.65 && _unit distance _gunner < 120) then {
			[_unit,_gunner] remoteExec["JP_fnc_surrender"];
		};
	}
]] remoteExec ["addEventHandler", 0, true];


[_unit, ["HandleDamage",
	{
		params["_unit","_hitSelection","_damage","_source"];

		if (lifeState _unit == "INCAPACITATED") then{
			[_unit, "AinjPpneMstpSnonWrflDb_death"] remoteExec ["switchMove", 0, true];
		};
		if (lifeState _unit != "INCAPACITATED" && _damage > .9 && alive _unit && random 100 > 75 && !(_hitSelection in ["head"])) then {
			_unit setDamage .9;
			_unit setUnconscious true;

			_unit spawn {
				_this allowDamage false;
				sleep 3;
				_this allowDamage true;

				/*
				_animations = ["Acts_CivilInjuredGeneral_1","Acts_CivilInjuredChest_1"];
				_anim = _animations call BIS_fnc_selectRandom;
				if (_this getHit "arms" > .7) then {
					_anim = "Acts_CivilInjuredArms_1";
				};
				if (_this getHit "legs" > .7) then {
					_anim = "Acts_CivilInjuredLegs_1";
				};
				if (_this getHit "head" > .7) then {
					_anim = "Acts_CivilInjuredHead_1";
				};
				[_this, _anim] remoteExec ["switchMove", 0, true];
				*/

				if (random 100 > 60 && alive _this)then{
					waitUntil{sleep 1; {_x distance _this < 2} count ([] call JP_fnc_allPlayers) > 0 || !alive _this };
					if (!alive _this) exitWith{ false; };
					_nearestFriendly = [getPos _this] call JP_fnc_nearestPlayer;
					_grenade =  createVehicle ["GrenadeHand", (_this modelToWorld [.3,.3,0]), [], 0, "NONE"];
					hint "Grenade thrown by the wounded !";
					[_nearestFriendly, "He has a grenade ! Take cover !"] remoteExec ["JP_fnc_talk", 0, true];
					[_this, "Aaaargh !"] remoteExec ["JP_fnc_talk", 0, true];
					sleep 2;
					_this say3D (["vn_sam_vcwound_003","vn_sam_vcwound_005","vn_sam_vcwound_006"] call BIS_fnc_selectRandom);
					sleep 4;
					if (lifeState _nearestFriendly != 'INCAPACITATED') then{
						[_nearestFriendly, "That was close !"] remoteExec ["JP_fnc_talk", 0, true];
					};
				};
			};

			[_unit, "HandleDamage"] remoteExec  ["removeAllEventHandlers", 0, true];
			
			_unit setHit["legs",1];
		
			_unit setCaptive true;

			// _mine = createMine ["vn_mine_m14",  (_unit modelToWorld[0,.6,0]), [], 0];

			_action = [format["<t color='#cd8700'>%1</t>","Show mercy"],{
					params["_unit","_talker","_action"];
					if (count (units (group _unit)) > 1) then{
					_grp = (createGroup east);
					[_unit] join _grp;
				};
				_unit setUnconscious false;
				_unit remoteExec ["removeAllActions",0, true];
				_unit stop false;
				removeAllWeapons _unit;
				removeHeadgear _unit;
				_unit allowFleeing 1;
				_unit setBehaviour "CARELESS";
				_unit moveTo (_unit modelToWorld [2000,0,0]);
				[_unit,10] remoteExec ["JP_fnc_updateRep",2];
			},nil,1,false,true,"","true",3,false,""];

			_unit call JP_fnc_addActionLookInventory;
			_unit call JP_fnc_addActionGetIntel;

			[_unit, _action] remoteExec ["addAction",0,true];

		};
	}
]] remoteExec ["addEventHandler", 0, true];
true;