/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Client base script
*/

if (isNull player) exitWith{};
if (!hasInterface) exitWith{};

_leader = (leader GROUP_PLAYERS);
_leader setVariable ["JP_avatar","group-leader", true];
_leader setName "One-Zero";

_rto =missionNamespace getVariable ["rto", objNull];
_rto setName "One-One";
_rto setVariable ["JP_avatar","rto",true];

_doc =missionNamespace getVariable ["doc", objNull];
_doc setName "One-Two";
_doc setVariable ["JP_avatar","doc",true];

_mg =missionNamespace getVariable ["mg", objNull];
_mg setName "Machine Gunner";

HQ = missionNamespace getVariable ["colonel", objNull];
HQ setName "Colonel Russel";
HQ setVariable ["JP_avatar","colonel",true];
publicVariable "HQ";

/*
HQ kbAddTopic ["briefing", "JP\voices\Briefing\CfgSentences.bikb"];
_leader kbAddTopic ["briefing", "JP\voices\Briefing\CfgSentences.bikb"];

_leader kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_doc kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_rto kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_mg kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];

player kbAddTopic ["briefing", "JP\voices\Briefing\CfgSentences.bikb"];
player kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
*/
// Client side 
TALK_QUEUE = [];
MESS_SHOWN = false;
MESS_HEIGHT = 0;

player call JP_fnc_resetState;

player createDiaryRecord ["Diary",["Keep a good reputation",
"The civilian in the sector would be very sensitive to the way you talk to them. Some of them are definitly hostiles to our intervention. You are free to take them in custody, that's a good point to track the potential insurgents in the region. You must avoid any mistakes, because it could have heavy consequences on the reputation of our troops in the sector. More you hurt them, more they might join the insurgents. If you are facing some difficulties, it is possible to convince some of them to join your team (it would costs you some credits...). Keep in mind the rules of engagements and it would be alright."]];


player createDiaryRecord ["Diary",["How to gather supports ?",
"To accomplish these tasks, you would need resources from the HQ. They could provide you all the supports you need (Choppers, CAS, ammo drops, ...). You need to earn points by differents way :<br/> kill enemy<br/>Search & secure dead bodies (action menu)<br/>Clean up compound with enemies<br/>Finish recon missions<br/>Arrest suspicious civilian"]];


player createDiaryRecord ["Diary",["Presentation",
"Jungle Patrol<br/><br/>
In this singleplayer scenario, you have one major objective : perform a huge reconnaissance mission for 3 days in enemy territory. Every objectives and enemy locations are randomly generated, so each mission are completely differents and can have a good replayability."]];

 _loc =  nearestLocations [getPosWorld player, ["NameVillage","NameCity","NameCityCapital"],10000] select 0;

// If unit JIP
if (didJIP) then {
	 player setPos ((leader GROUP_PLAYERS) modelToWorld [5,5,0]);
};

// If is admin
/*if (ENABLE_DIALOG && !didJIP) then {
	
	// playMusic "AmbientTrack04_F";

	if ((leader GROUP_PLAYERS) != player) then{
		titleCut ["", "WHITE IN", 4];

		[] spawn {
			uisleep 4;
			[parseText "<t font='PuristaBold'  size='1.6'>Dynamic Civil War</t><br />by Bidass", true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;
			uisleep 14;
			[
				[
					[format["Welcome on %1, ","Khe Sanh"], "align = 'left' shadow = '1' size = '1.0'"],
					["","<br/>"], // line break
					["Stand by, the administrator is currently configuring", "align = 'left' shadow = '1' size = '1'"],
					["","<br/>"], // line break
					["the scenario's parameters...","align = 'left' shadow = '1' size = '1.0'"]
				]
			] spawn BIS_fnc_typeText2;
		};

		_randomPos = [getPos player, 200, 10000, 0, 0, 20, 0] call BIS_fnc_findSafePos;
		_randomPos set [2, 140];
		_targetPos = [_randomPos, 1000, 1100, 0, 0, 20, 0] call BIS_fnc_findSafePos;
		CONFIG_CAMERA = "camera" camcreate _randomPos;
		CONFIG_CAMERA cameraeffect ["internal", "back"];
		showCinemaBorder false;
		CONFIG_CAMERA camSetPos _randomPos;
		CONFIG_CAMERA camCommit 0;
		CONFIG_CAMERA camSetTarget _targetPos; 
		CONFIG_CAMERA camSetPos _targetPos;
		CONFIG_CAMERA camCommit 500;
	} else { 
		// He is the team leader => he administrates the mission
		[] call JP_fnc_dialog;
	};

	// Just in case there is no config at all
	if (!isPlayer (leader GROUP_PLAYERS)) then {
		JP_STARTED = true;
	};

	waitUntil {JP_STARTED};

	// Close the dialog 
	if ((leader GROUP_PLAYERS) != player) then{
		CONFIG_CAMERA cameraeffect ["terminate", "back"];
		camDestroy CONFIG_CAMERA;
	} else {
	
	};

	JP_STARTED = true;
	publicVariableServer "JP_STARTED";

	hintSilent "";
} else {
	
};*/


waitUntil {JP_STARTED};

// Initial score display
[] call JP_fnc_displayscore;



// init user respawn loop
// [player] spawn JP_fnc_respawn; //Respawn loop

//Loop to check mines
iedBlasts=["Bo_Mk82","Rocket_03_HE_F","M_Mo_82mm_AT_LG","Bo_GBU12_LGB","Bo_GBU12_LGB_MI10","HelicopterExploSmall"];
iedJunks=["Land_Garbage_square3_F","Land_Garbage_square5_F","Land_Garbage_line_F"];

// Trigger the blasting effect
iedAct={	
	_iedObj=_this;
	if(mineActive _iedObj)then{

		_iedBlast = selectRandom iedBlasts;
		createVehicle[_iedBlast,(getPosATL _iedObj),[],0,"NONE"];
		createVehicle["Crater",(getPosATL _iedObj),[],0,"NONE"];

		{
			hideObject _x
		}forEach nearestObjects[getPosATL _iedObj,iedJunks,4];
		
		deleteVehicle _iedObj;
	};
};

[] spawn {
	while {true} do {
		{
			_mine = _x select 0;
			if (!(mineActive _mine) || !(alive _mine)) then {
				_junk = _x select 1;
				// It's in cache, that's okay !
				if (player distance _junk < 250) then{

					// The mine is defused by the player
					_junk remoteExec ["JP_fnc_success", 2, false];

					// Delete the mine
					IEDS = IEDS - [_x];
					publicVariable "IEDS";
				};
				
			} else {
				if (_mine distance player < 3  && (speed player > 4 || (stance player) != "PRONE")) then{
					_mine call iedAct;
				};
			};
			sleep .2;
		} foreach IEDS;
		sleep .4;
	};
};

// Hover effect on map;
addMissionEventHandler
[	"Map",
	{	
		params ["_isOpened","_isForced"];
		if (_isOpened) then {
			// Fetch markers from server silently
			[] spawn {
				params ["_markers"];
			 	_timer = time;
				_markers = [ missionNamespace, "MARKERS", []] call BIS_fnc_getServerVariable;
				CurrentMarker = "";
				["JP-markerhover", "onEachFrame", {
					params ["_markers","_timer"];
					_map = findDisplay 12 displayCtrl 51; 
					_mapMarker = (ctrlMapMouseOver _map);
					hintsilent "";
					_map ctrlMapCursor ["Track","Track"];
					if (_mapMarker select 0 == "marker") then {
						_mkr = _mapMarker select 1; 

						// check the alpha level
						if (markerAlpha _mkr > 0) then {
							_map ctrlMapCursor ["Track","HC_overFriendly"];

							// Debug specific handling
							if (DEBUG) then {
								{
									if (_x getVariable["marker",""] == _mkr) then {
										hint format["Type : %1",_x getVariable["JP_Type","unknown"]];
									};
								} foreach allUnits;
							};

							if ( ["JP-cluster-",str _mkr] call BIS_fnc_inString && CurrentMarker != _mkr) then {
								CurrentMarker = _mkr;
								_marker = [_markers,_mkr] call JP_fnc_getMarkerById;
								_compound = _marker select 0;
								_people = (_compound select 6);
								_population = (_people select 0) + (_people select 1) + (_people select 2) + (_people select 5) + (_people select 8); 
								_dbg =  "";
								if (DEBUG) then {
									_labels = ["Civilians","Snipers","Enemies","Cars","Ieds","Caches","Hostages","Mortars","Outposts","Friendlies"];
									{
										_dbg =  _dbg + format["<br/><t >%1:%2</t>",_labels select _foreachIndex,_x];
									}foreach _people;
									_dbg =  _dbg + format["<br/><t>Defend task state:%1</t>",_compound select 16];
								};
								
								hintsilent parseText format["<t color='#cd8700' >%1</t><br/><t size='1.3'>State : %2</t><br/><t size='1.3'>Reputation : %3/100</t><br/><t size='1.3'>Population : %4</t>%5",(_marker select 0) select 14,((_marker select 0) select 12) call JP_fnc_getCompoundStateLabel,(_marker select 0) select 13,_population,_dbg];
							} else {
								CurrentMarker = "";
							};
						}else {
							CurrentMarker = "";
						};
					} else{
						CurrentMarker = "";
					};

					// Refresh each 4 secs
					if (time == _timer + 4 ) then {
						_markers = [missionNamespace, "MARKERS", []] call BIS_fnc_getServerVariable;
						_timer = time;
					};

					if (!visibleMap) then {
						["JP-markerhover", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;
					};
				},[_markers,_timer]] call BIS_fnc_addStackedEventHandler;
			};
		};
	
	}
];


