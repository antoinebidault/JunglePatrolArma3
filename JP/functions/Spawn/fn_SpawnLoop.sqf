
// Wait until the players > 0 and they disembark
waitUntil {count ([] call JP_fnc_allPlayers) > 0 && !IN_INTRO_CUTSCENE};

// Display the score to each player
// [] remoteExec ["JP_fnc_displayScore"];

// Initial timer for the hunters
_timerChaser = time - 360;
_tmpRep = 50;
_currentMarker = [];

while { true } do {
	try 
	{ 
		_players = [] call JP_fnc_allPlayers;
		// foreach players
		{
			_player = _x; 

			_playerPos = position _player;
			_playerInMarker = false;
			
			if (!isNil '_playerPos' && alive _x) then{

				_nbUnitSpawned = count UNITS_SPAWNED_CLOSE;

				//Catch flying player
				_isInFlyingVehicle = false;
				if( (vehicle _player) != _player && ((vehicle _player) isKindOf "Air" && (_playerPos select 2) > 4))then{
					_isInFlyingVehicle = true;
				};

				_xC = floor((_playerPos select 0)/SIZE_BLOCK);
				_yC = floor((_playerPos select 1)/SIZE_BLOCK);
				_o = 4;

				// foreach markers
				IN_MARKERS_LOOP = true;
				{
					_currentCompound = _x;
					_marker =_x select 0;
					_pos =_x select 1;
					_triggered =_x select 2;
					_success =_x select 3;
					_radius =_x select 4;
					_units =_x select 5;
					_peopleToSpawn =_x select 6;
					_meetingPointPosition = _x select 7;
					_points =_x select 8;
					_isLocation = _x select 9;
					_isMilitary = _x select 10;
					_buildings = _x select 11;
					_compoundState = _x select 12;
					_supportScore = _x select 13;
					_nameLocation = _x select 14;
					_respawnId = _x select 15;
					_defendTaskState = _x select 16;
					_primaryIntel = _x select 17;
					_notSpawnedArray = _x select 18; 
			
					
					
					if (_triggered && _playerPos distance _pos < _radius ) then {
						_currentMarker = _x;
						_playerInMarker = true;
						// [format["<t color='#cd8700'>%1</t><br/>Inhabitants: %2<br/>State: %3<br/>Reputation: <t >%4%/100</t><br/>",_nameLocation,(_peopleToSpawn select 0) + (_peopleToSpawn select 2),_compoundState call JP_fnc_getCompoundStateLabel,_supportScore], 40] remoteExec ["JP_fnc_showIndicator",_player,false];
				
						/*
						if (_defendTaskState == "planned" && (_compoundState == "neutral" || _compoundState == "resistance")  ) then {
							[_currentCompound,_player] spawn {
								params["_compound"];
								sleep 30;
								[_pos, _radius] call JP_fnc_spawnDefendTask;
							}; 
							_defendTaskState = "done";
						};*/
					};

					// && _playerPos distance _pos >= _radius
					if (!_triggered && !_isInFlyingVehicle && _playerPos distance _pos < ((_radius + 300) max 500) && !_isInFlyingVehicle) then{
						
						if (_nbUnitSpawned < MAX_SPAWNED_UNITS)then{
							
							//Véhicles spawn
							_units = _units + ([_pos,_radius,(_peopleToSpawn select 3),_compoundState] call JP_fnc_spawnCars);
							
							//Units
							_units = _units + ([_pos,_radius,_success,_peopleToSpawn,_meetingPointPosition,_buildings,_compoundState,_supportScore] call JP_fnc_spawnUnits);
							
							//Meeting points
							_units = _units + ([_meetingPointPosition] call JP_fnc_spawnMeetingPoint);
							
							//Spawn random composition
							// _units = _units + ([_pos,_buildings,_success,_compoundState] call JP_fnc_spawnobjects);

							if (_compoundState == "secured")  then {	
								//Units
								_units = _units + ([_pos,_radius,_peopleToSpawn select 9,_meetingPointPosition,_buildings] call JP_fnc_spawnFriendlyOutpost);
							} else {
								_notSpawnedArray set [9,_peopleToSpawn select 9] ;
							};

							/*if (_compoundState == "humanitary") then {
								//Units
								_units = _units + ([_pos,_radius,_peopleToSpawn select 0,_meetingPointPosition,_buildings] call JP_fnc_spawnHumanitaryOutpost);
							};*/

							if (_compoundState != "secured" && _compoundState != "humanitary") then {
								//IEDs
								_units = _units +  ([_pos,_radius,(_peopleToSpawn select 4)] call JP_fnc_spawnIED);
							} else {
								_notSpawnedArray set [4,_peopleToSpawn select 4] ;
							};
							
							if (_compoundState == "bastion" || (_compoundState == "neutral" && _supportScore < 60)) then {
								//Snipers spawn 
								_units = _units + ([_pos,_radius,(_peopleToSpawn select 1)] call JP_fnc_spawnSnipers);
								//Cache
								_units = _units + ([_pos,(_peopleToSpawn select 5),_buildings] call JP_fnc_cache);
								//Hostages
								_units = _units + ([_pos,_radius,(_peopleToSpawn select 6),_buildings] call JP_fnc_hostage);
								//Mortars
								_units = _units + ([_pos,_radius,(_peopleToSpawn select 7)] call JP_fnc_spawnMortar);
							} else {
								_notSpawnedArray set [2,_peopleToSpawn select 2] ;
								_notSpawnedArray set [5,_peopleToSpawn select 5] ;
								_notSpawnedArray set [6,_peopleToSpawn select 6] ;
								_notSpawnedArray set [7,_peopleToSpawn select 7] ;
							};

							if (_compoundState == "bastion" ) then {
								//Outposts
								_units = _units + ([_marker,(_peopleToSpawn select 8)] call JP_fnc_spawnOutpost);
							} else {
								_notSpawnedArray set [8,_peopleToSpawn select 8] ;
							};

							_triggered = true;

							/*
							_marker setMarkerAlpha .3;
							format["%1-icon", _marker] setMarkerAlpha 1;
							*/
							
							//Add a little breath
							sleep 1;
						};


					}else{
						// Cache put in case player is too far
						if(_triggered && { _x distance _pos < ((_radius + 650) max 850) } count _players == 0 ) then {
							_cacheResult = [_units,_notSpawnedArray] call JP_fnc_cachePut;
							_peopleToSpawn = _cacheResult select 0;
							_units = _units - [_cacheResult select 1];
							_triggered = false;
						} else {
							// Check if enemies remains in the area;
							if (_triggered && !_success && _compoundState == "bastion") then {
								if ([_playerPos, _marker] call JP_fnc_isInMarker) then {
									_enemyInMarker = true;
									if ({side _x == SIDE_ENEMY && !(captive _x) && alive _x && [getPos _x, _marker] call JP_fnc_isInMarker  } count allUnits <= floor (0.2 * (_peopleToSpawn select 2))) then {
										_enemyInMarker = false;
									};
									//Cleared success
									if (!_enemyInMarker) then {
										_success = true;
										[_currentCompound,"neutral"] spawn JP_fnc_setCompoundState;
										[_currentCompound,35 + (ceil random 20),0] spawn JP_fnc_setCompoundSupport;				

										//Misa à jour de l'amitié
										[GROUP_PLAYERS,_points,false,(leader GROUP_PLAYERS)] call JP_fnc_updateScore;

										[_player,"The compound is clear ! Great job team.", true] remoteExec ["JP_fnc_talk"];
									};

								};
							};
						};
					}; 
					MARKERS set [_forEachIndex,[_marker,_pos,_triggered,_success,_radius,_units,_peopleToSpawn,_meetingPointPosition,_points,_isLocation,_isMilitary,_buildings,_compoundState,_supportScore,_nameLocation,_respawnId,_defendTaskState,_primaryIntel,_notSpawnedArray]]; 
				} foreach MARKERS select { (_x select 2) || ((_x select 4) <= (_xC + _o) && (_x select 4) >= (_xC - _o) && (_x select 5) <= (_yC + _o) && (_x select 5) >= (_yC - _o)) };
				IN_MARKERS_LOOP = false;
			};
			sleep 1;

			if (!_playerInMarker) then {
				_currentMarker = [];
				["",0] remoteExec ["JP_fnc_showIndicator",_player,false];
			};

		} foreach _players;


		// foreach UNITS_SPAWNED_CLOSE
		{
			_unit = _x;

			//Empty the killed units
			if (!alive _unit)then{
				_unit call JP_fnc_deletemarker;
				UNITS_SPAWNED_CLOSE = UNITS_SPAWNED_CLOSE - [_unit];
			};
			
			// foreach players
			{
				//Detection
				if (!CHASER_TRIGGERED && !CHASER_VIEWED && side _unit == SIDE_ENEMY && _unit knowsAbout _x > 1 && !(_x getVariable["JP_undercover",false]) ) then {
					[_unit,_x] spawn {
						params["_unit","_player"];
						CHASER_VIEWED = true;
						sleep (7 + random 5);
						CHASER_VIEWED = false;
						// [] remoteExec ["JP_fnc_displayScore",_player, false];
						// || _unit knowsAbout player > 2
						//if ( alive _unit && !CHASER_TRIGGERED &&  ([_unit,_player] call JP_fnc_getVisibility > 20) ) then {
						if ( alive _unit && !CHASER_TRIGGERED &&  _unit knowsAbout _player > 2.5 ) then {
							if (DEBUG) then  {
								hint "Alarm !";
							};

							CHASER_TRIGGERED = true;
							publicVariable "CHASER_TRIGGERED";
							
							CHASER_TIMEOUT = time + 5 * 60;
							publicVariable "CHASER_TRIGGERED";

							UNITS_SPAWNED_CLOSE = UNITS_SPAWNED_CLOSE + ([_player] call JP_fnc_spawnChaser);
						};
					};
				} else {
					// Each time the user see the player, it makes the timeout longer
					if (CHASER_TRIGGERED && alive _unit && !(captive _unit) && _unit knowsAbout _x > 1 && [_unit,_x] call JP_fnc_getVisibility > 20) then {
						CHASER_TIMEOUT = time + 5 * 60;
						if (DEBUG) then  {
							hint "Viewed again !";
						};
					};

					if (CHASER_TRIGGERED && time > CHASER_TIMEOUT) then {
						CHASER_TRIGGERED = false;
						publicVariable "CHASER_TRIGGERED";
						if (DEBUG) then  {
							hint "Alarm off!";
						};
					};
				};
			} foreach _players;

			// Garbage collection
			if (!(_unit getVariable["JP_disable_cache",false]) && 
				(
					_unit getVariable["JP_Type",""] == "patrol" || 
					_unit getVariable["JP_Type",""] == "chaser" || 
					_unit getVariable["JP_Type",""] == "civpatrol"
				)
			)then{
				
				if ({_unit distance _x > SPAWN_DISTANCE + 200} count _players == count _players)then {
					UNITS_SPAWNED_CLOSE = UNITS_SPAWNED_CLOSE - [_unit];
						// If it's a vehicle
					if (vehicle _unit != _unit) then {
						{ _x call JP_fnc_deletemarker; deletevehicle _x; } foreach crew _unit;
					};
					_unit call JP_fnc_deleteMarker;
					deleteVehicle _unit;
				};
			};
		} foreach UNITS_SPAWNED_CLOSE;
		

	} catch {
		diag_log format["[SpawnLoop] Error in server.sqf loop :  %1",_exception];
	};
	sleep REFRESH_TIME;
};

diag_log "[SpawnLoop] Exited spawn loop";