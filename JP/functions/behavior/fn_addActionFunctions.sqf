/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Prepare functions for the civilian spawned on the map mostly

*/


JP_fnc_addActionJoinAsTeamMember = {
      _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_actionRecruitHimLabel"],{
         params["_unit","_talker","_action"];
         if (!(_this call JP_fnc_startTalking)) exitWith {};
         // if (!([GROUP_PLAYERS,500] call JP_fnc_afford)) exitWith { hint (localize "STR_JP_addActionFunctions_morePoints");_this call JP_fnc_endTalking;false;};
      
        [_unit, _talker, _action] spawn {
             params["_unit","_talker","_action"];
            [_unit,true] remoteExec ["stop",owner _unit];
            _talker playActionNow "GestureFreeze";
            [_unit, "GestureHi"] remoteExec ["playActionNow"];
            sleep .3;

            [_talker,localize "STR_JP_voices_teamLeader_hiBuddy"] call JP_fnc_talk;
            [_unit,localize "STR_JP_voices_teamMember_imIn"] call JP_fnc_talk;
            sleep .3;
            [_unit,false] remoteExec ["stop",owner _unit];
        };
        
        [_unit] remoteExec ["removeAllActions"]; 
        _unit setVariable["JP_disable_cache", true, true];
        _unit setVariable["JP_disable_patrol", true, true];
        _unit call JP_fnc_resetStateAI;
        [_unit] join GROUP_PLAYERS;
        _this call JP_fnc_endTalking;

    },nil,1,true,true,"","true",3,false,""];
};


JP_fnc_addActionJoinAsAdvisor = {
      _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_actionRecruitMilitaryAdvLabel"],{
         params["_unit","_talker","_action"];
         if (!(_this call JP_fnc_startTalking)) exitWith {};
         if ({_x getVariable["JP_advisor",false]}count (units GROUP_PLAYERS) >= 2) exitWith {
              hint (localize "STR_JP_addActionFunctions_cantRecruitMoreAdvisors");
             _this call JP_fnc_endTalking;false;
         };
        //  if (!([GROUP_PLAYERS,30] call JP_fnc_afford)) exitWith { 
         //     hint (localize "STR_JP_addActionFunctions_morePoints"); 
         //     _this call JP_fnc_endTalking;false;
        // };
         [_unit, _talker, _action] spawn {
             params["_unit","_talker","_action"];
            [_unit,true] remoteExec ["stop",owner _unit];
            _talker playActionNow "GestureFreeze";
            [_unit, "GestureHi"] remoteExec ["playActionNow"];

            sleep .3;

            [_talker,localize "STR_JP_voices_teamLeader_hiBuddyMil"] call JP_fnc_talk;
            [_unit,localize "STR_JP_voices_teamMember_imIn"] call JP_fnc_talk;
           
            sleep .3;

            [_unit,false] remoteExec ["stop",owner _unit];
        };

        _unit setVariable["JP_advisor", true, true];
        _unit setVariable["JP_disable_patrol", true, true];
        _unit setVariable["JP_disable_cache", true, true];
        [_unit] join GROUP_PLAYERS;
        _this call JP_fnc_endTalking;
        [_unit] remoteExec ["removeAllActions"];
        _unit remoteExec ["JP_fnc_addActionLeaveGroup",0];

    },nil,1,true,true,"","true",3,false,""];
};

//Menote le mec;
JP_fnc_addActionHandCuff =  {
    _this addaction ["<t color='#cd8700'>Capture him</t>",{
        _unit  = (_this select 0);
        _unit removeAllEventHandlers "FiredNear";
        _unit  setVariable["civ_affraid",false];

        sleep .2;
        [_unit,""] remoteExec ["switchMove"];
        sleep .2;
        [ (_this select 1),"PutDown"] remoteExec ["playActionNow"];
        _unit SetBehaviour "CARELESS";
        _unit setCaptive true;
        [_unit,-4] remoteExec ["JP_fnc_updateRep",2];

        //Handle weapon states
        _rifle = primaryWeapon _unit; 
        if (_rifle != "") then {
            _unit action ["dropWeapon", _unit, _rifle];
            waitUntil {animationState _unit == "amovpercmstpsraswrfldnon_ainvpercmstpsraswrfldnon_putdown" || time > 3}; 
            removeAllWeapons _unit; 
        };

        _pistol = handgunWeapon _unit; 
        if (_pistol != "") then {
            _unit action ["dropWeapon", _unit, _pistol];
            waitUntil {animationState _unit == "amovpercmstpsraswrfldnon_ainvpercmstpsraswrfldnon_putdown" || time > 3}; 
            removeAllWeapons _unit; 
        };

        [_unit, ["Surrender", _unit]] remoteExec ["action"]; 
        _unit disableai "ANIM"; 
        _unit disableAI "MOVE"; 

        _unit remoteExec ["RemoveAllActions",0];

        _unit call JP_fnc_addActionLiberate;
        _unit call JP_fnc_addActionLookInventory;
        hint localize "STR_JP_addActionFunctions_captured";	   

        [_unit] remoteExec ["CIVIL_CAPTURED",2];

    },nil,9,false,true,"","true",3,false,""];
};


JP_fnc_addActionInstructor = {
    
    if (!isMultiplayer)then {
        _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_saveGame"],{
        saveGame;
        },nil,1.5,false,true,"","true",3,false,""];
    };

     _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_briefing"],{
        params["_unit"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        [_unit, localize "STR_JP_voices_instructor_briefing1"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing2"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing3"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing4"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing5"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing6"] call JP_fnc_talk;
        _this call JP_fnc_endTalking;
    },nil,1,true,true,"","true",3,false,""];
};

JP_fnc_addActionGiveUsAHand =  {
    _this select 0 addaction [format["<t color='#cd8700'>%1 (20 points/10 minutes)</t>",localize "STR_JP_addActionFunctions_giveUs"],{
        _unit  = (_this select 0);
        _talker  = (_this select 1);
        _action  = (_this select 2);

         if (!(_this call JP_fnc_startTalking)) exitWith {};
        //  if (!([GROUP_PLAYERS,20] call JP_fnc_afford)) exitWith {_this call JP_fnc_endTalking;hint localize "STR_JP_addActionFunctions_morePoints";false;};
         [_unit,localize "STR_JP_voices_teamMember_okWereFlanking"] spawn JP_fnc_talk;
         _this call JP_fnc_endTalking;

        {
            [_x,_action] remoteExec ["removeAction",2];
            [_x,["Stop following us",{
                _unit  = (_this select 0);
                _talker  = (_this select 1);
                _action  = (_this select 2);
                [_unit,localize "STR_JP_voices_teamMember_understood"] spawn JP_fnc_talk;

                 {
                    [_x,_action] remoteExec ["removeAction",2];
                    _x setVariable ["JP_follow_player",false];
                    _x setVariable ["JP_disable_patrol",false,true];
                    [_x] remoteExec ["JP_fnc_addActionGiveUsAHand"];
                } foreach units group _unit;
            }]] remoteExec ["addAction",2];
        } foreach units group _unit;

        _talker playActionNow "PutDown";
        // Make follow us
        _group =  group _unit ;
        [_group,_talker] spawn {
            params["_group","_talker"];
            (leader _group) setVariable["JP_follow_player",true];
            (leader _group)  setVariable ["JP_disable_patrol",true,true];
            _wp1 = _group addWaypoint [[0,0,0],0];
            _wp1 setWaypointType "MOVE";
            _wp1 setWaypointBehaviour "AWARE";
            while {alive _talker && leader _group getVariable["JP_follow_player", false]} do {
                _wp1 setWaypointPosition [(_talker ModelToWorld [random 25,-20,0]), 0];
                _group setCurrentWaypoint _wp1;
                sleep 20;
            };
        };
         

    },nil,1,false,true,"","true",5,false,""];
};

JP_fnc_addActionLiberate =  {
    _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_liberateHim"],{
        _unit  = (_this select 0);
        _talker  = (_this select 1);
        _action  = (_this select 2);
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        [_talker,localize "STR_JP_voices_teamLeader_goAway"] call JP_fnc_talk;
        if(side _unit != SIDE_CIV) then {
		    [_unit] joinSilent (createGroup SIDE_CIV);
        };
        _unit remoteExec ["removeAllActions",0];
        [_talker,"PutDown"] remoteExec ["playActionNow"];

        _this call JP_fnc_endTalking;
        _unit SetBehaviour "AWARE";
        _unit setCaptive false;
        [_unit,""] remoteExec ["switchMove",0]; 
        [_unit,"ANIM"] remoteExec ["switchMove",owner _unit]; 
        [_unit,"MOVE"] remoteExec ["switchMove",owner _unit]; 
        if (side _unit == SIDE_CIV) then {
            [_unit,2] remoteExec ["JP_fnc_updateRep",2];
        };
        _pos = [getPos _unit, 1000, 1100, 1, 0, 20, 0] call BIS_fnc_findSafePos;
        
        [_unit,false] remoteExec ["stop",owner _unit]; 
        [_unit,10] remoteExec ["forceSpeed",owner _unit]; 
        [_unit,false] remoteExec ["forceWalk",owner _unit]; 
        [_unit,_pos] remoteExec ["move",owner _unit]; 
        
    },nil,1,false,true,"","true",3,false,""];
};


JP_fnc_addActionLookInventory = {
      _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_searchInGear"],{
        params["_unit","_human","_action"];
        _unit removeAction _action;
        if (_unit getVariable["JP_Suspect",false])then{
            for "_i" from 1 to 3 do {_unit addItemToUniform "1Rnd_HE_Grenade_shell";};
            [_human,localize "STR_JP_voices_teamLeader_holyShit"] remoteExec ["JP_fnc_talk"];
            [_unit,1] remoteExec ["JP_fnc_updateRep",2];   
            [GROUP_PLAYERS,25,false,_human] remoteExec ["JP_fnc_updateScore",2];   
            _unit remoteExec ["RemoveAllActions",0];

        }else{
            [_unit,-1] remoteExec ["JP_fnc_updateRep",-2];   
        };
        sleep .4;
        if (alive _unit) then {
            _human action ["Gear", _unit];
        };

    },nil,5,false,true,"","true",3,false,""];
};

    JP_fnc_addActionHalt = {
        _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_sayHello"],{
        params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        
        _talker remoteExec ["GestureFreeze"];
        
        _unit stop true;
        [_unit,"MOVE"] remoteExec ["disableAI"];

        [_talker,"Hello sir !"] call JP_fnc_talk;
        
        if (!weaponLowered _talker) exitWith { 
            [_unit,"I don't talk to somebody pointing his gun on me ! Go away !"]  call JP_fnc_talk;
            [_unit, "gestureNo"] remoteExec ["playActionNow"];
            [_talker,"I'm sorry, sir !"] call JP_fnc_talk;
            [_unit,-2] remoteExec ["JP_fnc_updateRep",2];
            _unit stop false;
            [_unit,"MOVE"] remoteExec ["enableAI"];
            _this call JP_fnc_endtalking;
            false; 
        };
        
        [_unit,_action] remoteExec ["removeAction"];
        _unit remoteExec ["JP_fnc_addActionDidYouSee"];
        _unit remoteExec ["JP_fnc_addActionFeeling"];
        _unit remoteExec ["JP_fnc_addActionGetIntel"];
        _unit remoteExec ["JP_fnc_addActionRally"];
       // _unit remoteExec ["JP_fnc_addActionSupportUs"];
        if ( _unit getVariable["JP_Chief",objNull] != objNull && alive (_unit getVariable["JP_Chief",objNull])) then {
           // [_unit,_unit getVariable["JP_Chief",objNull]] remoteExec ["JP_fnc_addActionFindChief"];
        };

        sleep 1;
        [_unit, "GestureHi"] remoteExec ["playActionNow"];
        [_unit,format["Hi ! My name is %1.", name _unit]] remoteExec ["JP_fnc_talk",_talker];
        
        sleep 0.5;

        _this call JP_fnc_endtalking;

        waitUntil { sleep 4; _talker distance _unit > 13;  };
            
        _unit stop false;
        [_unit,"MOVE"] remoteExec ["enableAI"];

        _unit remoteExec ["RemoveAllActions"];
        [_unit] remoteExec ["JP_fnc_addCivilianAction"];

    },nil,12,false,true,"","true",6,false,""];
};

JP_fnc_addActionDidYouSee = {
    //Try to gather intel
     _this addaction ["<t color='#cd8700'>Did you see anything recently ?</t>",{
    params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};

        [_unit,_action] remoteExec ["removeAction"];

        /*if (_unit getVariable["JP_Friendliness",50] < 40) exitWith {
            [_unit,-2] remoteExec ["JP_fnc_updateRep",2];
            [_unit,"Don't talk to me !"] call JP_fnc_talk;
            false;
        };*/
        
        [_talker,"Did you see anything recently ?"] remoteExec ["JP_fnc_talk",_talker];
        private _data = _unit targetsQuery [objNull,SIDE_ENEMY, "", [], 0];
        sleep 1;
        _data = _data select {side group (_x select 1) == SIDE_ENEMY};

        if (count _data == 0) exitWith {
            [_unit, "I saw nothing..."] remoteExec ["JP_fnc_talk",_talker];
            _this call JP_fnc_endtalking;
        };

        if (count _data > 3) then { _data = [_data select 0] + [_data select 1] + [_data select 2];};
        
        [_unit,format["I saw %1 enemies...",count _data]] remoteExec ["JP_fnc_talk", _talker];
        _markers = [];
        {
            _enemy = _x select 1;
            if (alive _enemy) then {
                _nbMeters = round((_enemy distance _unit)/10)/100;
                _ang = ([_unit,_enemy] call BIS_fnc_dirTo) + 11.25; 
                if (_ang > 360) then {_ang = _ang - 360};
                _points = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"];
                _num = floor (_ang / 22.5);
                _compass = _points select _num;
                _type = getText (configFile >> "cfgVehicles" >> typeOf vehicle _enemy >> "displayName");
                [_unit, format["I saw a %1 %2 %3km away, %4minutes ago ", _type,_compass,_nbMeters,ceil((_x select 5)/60)]] call JP_fnc_talk;
                _marker = createMarkerLocal [format["enemyviewed-%1", random 50], position _enemy];
                _marker setMarkerShapeLocal "ICON";
                _marker setMarkerTypeLocal "mil_dot";
                _marker setMarkerColorLocal "ColorRed";
                _marker setMarkerTextLocal format["%1", _type];
                _markers pushback _marker;
                sleep .3;
            };
        } forEach _data;

        [_unit,"I marked their positions on your map. Help us please !"] call JP_fnc_talk;
        [_unit,1] remoteExec ["JP_fnc_updateRep",2];
        [_talker,"Thanks a lot !"] call JP_fnc_talk;
        _this call JP_fnc_endtalking;
        sleep 240;
        { deleteMarker _x; }foreach _markers;
        if (alive _unit) then {
            _unit remoteExec ["JP_fnc_addActionDidYouSee"];
        };

    },nil,5,false,true,"","true",2.5,false,""];
};

JP_fnc_addActionFeeling = {
    //Try to gather intel
     _this addaction [format["<t color='#cd8700'>What's your feeling about the %1's presence in %2</t>",getText(configfile >> "CfgFactionClasses" >> format["%1",faction (([] call JP_fnc_allPlayers) select 0)] >> "displayName"),"Khe Sanh"] ,{
        params["_unit","_talker","_action"];
            if (!(_this call JP_fnc_startTalking)) exitWith {};
            [_unit,1] remoteExec ["JP_fnc_updateRep",2];
            [_unit, _action] remoteExec["removeAction"];
            _message = "No problem, if you stay calm";
            CIVIL_REPUTATION = ([position _unit,false,"any"] call JP_fnc_findNearestMarker) select 13;
            if (CIVIL_REPUTATION  < 10) then {
                _message = "Go away, before I call all my friends to kick your ass!";
            }else{
                if (CIVIL_REPUTATION  < 20) then {
                _message = "You crossed a line... I would never help you guys ! ";
                }else{
                    if (CIVIL_REPUTATION  < 30) then {
                    _message = "It's getting really bad... ";
                    }else{
                        if (CIVIL_REPUTATION  < 40) then {
                            _message = "You're not welcome here... ";
                        }else{
                            if (CIVIL_REPUTATION  < 50) then {
                                _message = "Ou relations are getting worst";
                            }else{
                            if (CIVIL_REPUTATION  < 55) then {
                                    _message = "You should do more to help us !";
                                }else{
                                    if (CIVIL_REPUTATION  < 70) then {
                                        _message = "Less hostile around here, it's getting better here.";
                                    }else{
                                        if (CIVIL_REPUTATION  < 85) then {
                                            _message = "You made a great job here ! Thanks for everything.";
                                        }else{
                                            if (CIVIL_REPUTATION  <= 100) then {
                                                _message = "Have a drink my friend ! Grab a bier ! My home is yours !";
                                            };
                                        };
                                    };
                                };
                            };
                        };
                    };
                };
            };

            [_unit,_message] call JP_fnc_talk;
            _this call JP_fnc_endtalking;
            
            sleep 120;
            
            _unit remoteExec["JP_fnc_addActionFeeling"];

        },nil,4,false,true,"","true",3,false,""];
};



JP_fnc_addActionGetIntel = {
    //Try to gather intel
    _this addaction ["<t color='#cd8700'>Gather intel (15 minutes)</t>",{
       params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};

        //Suspect
        _isSuspect=_unit getVariable ["JP_Suspect",false];

         /*if (_unit getVariable["JP_Friendliness",50] < 35 ) exitWith {
            if (side _unit == SIDE_CIV) then {
                [_unit,-3] remoteExec ["JP_fnc_updateRep",2];
            };  
           [_unit,"Don't talk to me !"] call JP_fnc_talk;
           false;
        };*/

        _unit removeAction _action;
        if (!weaponLowered _talker)then{
            _talker action ["WeaponOnBack", _talker];
        };
        showCinemaBorder true;
        _camPos = _talker modelToWorld [-1,-0.2,1.9];
        _cam = "camera" camcreate _camPos;
        _cam cameraeffect ["internal", "back"];
        _cam camSetPos _camPos;
        _cam camSetTarget _unit;
        _cam camSetFov 1.0;
        _cam camCommit 0;
        _unit lookAt _talker;
        _talker lookAt _unit;

        sleep 1;

        //Talking with the fixed glitch
        _anim = format["Acts_CivilTalking_%1",ceil(random 2)];
        _unit switchMove _anim;

        titleCut ["", "BLACK OUT", 1];
        [parseText format ["<t font='PuristaBold' size='1.6'>15 minutes later...</t><br/>%1", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;

        sleep 1;
        if (!isMultiplayer) then {
            skipTime .25;
        };
        if (_isSuspect)then{
           [_unit,["Not your business !","I must leave...","Leave me alone please...","I'm a dead man if I talk to you..."] call BIS_fnc_selectRandom] call JP_fnc_talk;
        }else{
           [_unit,_talker,27] remoteExec ["JP_fnc_getIntel",2];
           [_unit,3] remoteExec ["JP_fnc_updateRep",2];
        };

        sleep 1;

        titleCut ["", "BLACK IN", 4];

        showCinemaBorder false;
        _cam cameraeffect ["terminate", "back"];
        camDestroy _cam;

        // Stop
        _this call JP_fnc_endTalking;

         waitUntil{animationState _unit != _anim};
        [_unit,""] remoteExec["switchMove",owner _unit] ;

        sleep 10;


    },nil,5,false,true,"","true",3,false,""];
};


JP_fnc_addActionRally = {
    //Try to make him a friendly
    _this addaction["<t color='#cd8700'>Try to rally (5 minutes/5 points)</t>",{
       params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        if (!([GROUP_PLAYERS,5] call JP_fnc_afford)) exitWith {_this call JP_fnc_endTalking;[_unit,"You need more points !"] call JP_fnc_talk;false;};

        _unit removeAction _action;
        showCinemaBorder true;
        _camPos = _talker modelToWorld [-1,-0.2,1.9];
        _cam = "camera" camcreate _camPos;
        _cam cameraeffect ["internal", "back"];
        _cam camSetPos _camPos;
        _cam camSetTarget _unit;
        _cam camSetFov 1.0;
        _cam camCommit 0;
        [_unit,true] remoteExec["stop",owner _unit];
        _unit lookAt _talker;
        _talker lookAt _unit;
        sleep 1;
        _unit disableAI "MOVE";
        titleCut ["", "BLACK OUT", 1];
        [parseText format ["<t font='PuristaBold' size='1.6'>5 minutes later...</t><br/>%1", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;

        sleep 1;
        skipTime .12;
        sleep 2;
        titleCut ["", "BLACK IN", 4];
        sleep 3;
        showCinemaBorder false;
        _cam cameraeffect ["terminate", "back"];
        camDestroy _cam;

        //Suspect
        _isSuspect = _unit getVariable ["JP_Suspect",false];
        
        _this call JP_fnc_endTalking;
       
       if(random 100 < PERCENTAGE_FRIENDLY_INSURGENTS && !_isSuspect) then {
            [_unit,false] remoteExec["stop",owner _unit];
            [_unit,"ALL"] remoteExec["enableAI",owner _unit];
            [_unit,"Ok, I'm in !"] remoteExec ["JP_fnc_talk",_talker];
            [_unit,SIDE_FRIENDLY] remoteExec ["JP_fnc_badGuyLoadOut",owner _unit];
            _unit remoteExec ["RemoveAllActions"];
            _unit setVariable["JP_recruit",true,true];
            _unit setVariable["JP_disable_cache", true, true];
            _unit remoteExec ["JP_fnc_addActionLeaveGroup"];
            [_unit,3] remoteExec ["JP_fnc_updateRep",2];
            [[_unit],GROUP_PLAYERS] remoteExec["join", 2];
        }else{
            if (_isSuspect)then{
                [_unit,"No thanks"] remoteExec ["JP_fnc_talk",_talker];
            }else{
                [_unit,"Sorry, but I have a family ! No way I get back to war..."] remoteExec ["JP_fnc_talk",_talker];
            };

            [_unit,-1 ] remoteExec ["JP_fnc_updateRep",2];
        };
    },nil,2,false,true,"","true",3,false,""];
};

JP_fnc_addActionSupportUs = {
    //Try to gather intel
     _this addaction ["<t color='#cd8700'>Give him help (2 FAKs/20points)</t>",{
        params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        _unit removeAction _action;
        _numberOfKits = { "FirstAidKit" == _x } count (items _talker);
        if (_numberOfKits <= 1) exitWith {_this call JP_fnc_endTalking;["Not enough FAK !"] remoteExec["hint", _talker];false;};
       //  if (!([GROUP_PLAYERS,20] call JP_fnc_afford)) exitWith {_this call JP_fnc_endTalking;[_unit,"You need more money !"] remoteExec ["JP_fnc_talk",_talker];false;};
        
        // Remove two faks
        _talker removeItem "FirstAidKit";
        _talker removeItem "FirstAidKit";

        [_talker,"What are looking for ? We can provide you food, medicine, water..."] remoteExec ["JP_fnc_talk",_talker];
        [_unit,1] remoteExec ["JP_fnc_updateRep",(2 + floor random 2)];
        [_unit,"Thanks for your precious help !"] remoteExec ["JP_fnc_talk",_talker];
        [_unit,"You're welcome !"] remoteExec ["JP_fnc_talk",_talker];
        _this call JP_fnc_endTalking;
    },nil,1,false,true,"","true",2.5,false,""];

};



JP_fnc_addActionRecruitGuard = {
    _this addAction  ["<t color='#cd8700'>Recruit a guard 80 points</t>",{ 
        params["_object","_player","_action"]; 
       //  if (!([GROUP_PLAYERS,80] call JP_fnc_afford)) exitWith {[_player,"You need more money !"] remoteExec ["JP_fnc_talk",_player];false;};
        _radius = 60;
        _grp = createGroup SIDE_FRIENDLY;
        _pos = [getPos _object, 0,7,1,0,20] call BIS_fnc_findSafePos;
        _unit = [_grp,_pos,true] call JP_fnc_spawnFriendly;
        _unit enableDynamicSimulation true;
        _buildings = [getpos _unit, _radius] call JP_fnc_findBuildings;
        [_grp,"JP_fnc_simplePatrol", [_grp,_radius,false]] call JP_fnc_patrolDistributeToHC;
        [_unit,format["private %1, at your command !", name _unit]] remoteExec ["JP_fnc_talk",_player];
        [_player,"Welcome soldier !"] remoteExec ["JP_fnc_talk",_player];
    },nil,1,false,true,"","true",20,false,""];
};



JP_fnc_addActionSitOnChair = {
    _object = _this;
   [_object,["Sit on chair",{ 
        params["_object","_player","_action"]; 
        [_object,_action] remoteExec ["removeAction",0];
        _player attachTo [_object, [0,0.08,0.05]];
        _player setDir ((getDir _object) - 180);
        [_player,["HubSittingChairB_idle1","HubSittingChairB_idle2","HubSittingChairB_idle3","HubSittingChairB_move1"] call BIS_fnc_selectRandom] remoteExec ["switchMove"];
      
        _player addAction ["leave", {
            params["_player","_executer","_action","_object"]; 
            [_player,""] remoteExec ["switchMove"];
            [_object,_action] remoteExec ["removeAction",0];
            _object call JP_fnc_addActionSitOnChair;
         },_object];
    },nil,1,false,true,"","true",20,false,""]] remoteExec ["addAction"];
};


JP_fnc_addActionFindChief = {
    params["_unit","_chief"];
    //Try to gather intel
   _unit addAction["<t color='#cd8700'>Where is your chief ?</t>",{
        params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        _chief = (_this select 3) select 0;
        if(alive _chief) then {

            _marker = "localchief";
            if(getMarkerColor "localchief" == "") then {
                _marker = createMarkerLocal ["localchief", getPosWorld _chief];
            };
            _marker setMarkerShapeLocal "ICON";
            _marker setMarkerTypeLocal "mil_dot";
            _marker setMarkerColorLocal "ColorGreen";
            _marker setMarkerTextLocal "Local chief";
            _marker setMarkerPosLocal (getPosWorld _chief);

            [_unit,format["I marked you the exact position where I last saw %1", name _chief]] remoteExec ["JP_fnc_talk",_talker];
        }else{
            [_unit,"Our chief is no more... Fucking war !"] remoteExec ["JP_fnc_talk",_talker];
        };
        _this call JP_fnc_endTalking;
    },[_chief],7,false,true,"","true",3,false,""];
};


JP_fnc_addActionLeaveGroup = {
     _this addaction ["<t color='#cd8700'>Order him to leave</t>",{
        params["_unit","_talker"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        [_unit,4] remoteExec ["JP_fnc_updateRep",2];
        _unit remoteExec ["removeAllActions",0]; 
        [_talker,"gestureGo"] remoteExec ["playActionNow"];
        [_talker,format["%1, You are now free to go ! Thanks for your help",name _unit]] remoteExec ["JP_fnc_talk",_talker];
        [_unit,["Well, good bye buddy !","Bye my friend !","Ok, See you in hell.."] call BIS_fnc_selectRandom]  remoteExec ["JP_fnc_talk",_talker];;
        _newGrp = createGroup SIDE_FRIENDLY;
        [_unit] join _newGrp;
        
        [_unit,{
            _pos = [getPos _this, 1000, 1100, 1, 0, 20, 0] call BIS_fnc_findSafePos;
            _this enableAI "MOVE";
            _this stop false;
            _this forceWalk false;
            _this forceSpeed 10;
            _this move _pos;
            waitUntil { isNull _this || _this distance _pos < 10 };
            _this setVariable["JP_disable_cache", false, true];
            deleteVehicle _this;
        }] remoteExec ["spawn",owner _unit];

        _this call JP_fnc_endTalking;
    },nil,8,false,true,"","true",3,false,""];
};

JP_fnc_addActionLeave = {
     _this addaction ["<t color='#cd8700'>Go away !</t>",{
        params["_unit","_talker"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        [_unit,-3] remoteExec ["JP_fnc_updateRep",2];
        _unit remoteExec ["removeAllActions",0];
        [_talker,"gestureGo"] remoteExec ["playActionNow"];
        [_talker,"Sorry sir, you must leave now, go away !"] remoteExec ["JP_fnc_talk",_talker];

        [_unit,{
            _pos = [getPos _this, 1000, 1100, 1, 0, 20, 0] call BIS_fnc_findSafePos;
            _this enableAI "MOVE";
            _this stop false;
            _this forceWalk false;
            _this forceSpeed 10;
            _this move _pos;
            waitUntil { isNull _this || _this distance _pos < 10};
            deleteVehicle _this;
        }] remoteExec ["spawn",owner _unit];

        _this call JP_fnc_endTalking;
    },nil,8,false,true,"","true",3,false,""];
};


JP_fnc_actionRest =  {
    _this addAction ["<t color='#00FF00'>Rest (3 hours)</t>", {
        params["_tent","_unit","_action"];
        if((_unit findNearestEnemy _unit) distance _unit < 100) exitWith { [_unit,"Impossible untill there is enemies around"] call JP_fnc_talk;};
        _tent removeAction _action;
        _newObjs = [getPos _unit,getDir _unit, compo_rest ] call BIS_fnc_objectsMapper;
        _camPos = _unit modelToWorld [.3,2.2,2];
        _cam = "camera" camcreate _camPos;
        _cam cameraeffect ["internal", "back"];
        _cam camSetPos _camPos;
        _cam camSetTarget _unit;
        _cam camSetFov 1.05;
        _cam camCommit 30;
        _unit stop true;
        sleep 2;
        _unit action ["sitdown",_unit];
        sleep 3;
        
        if (!isMultiplayer) then {
            setAccTime 120;
        };

        sleep 25;
        
        if (!isMultiplayer) then {
            setAccTime 1;
            skipTime 3;
        };

        sleep 3;
        [_unit,"Ok, let's go back to work !"] remoteExec ["JP_fnc_talk",_unit];
        _unit action ["sitdown",_unit];

        _cam cameraeffect ["terminate", "back"];
        camDestroy _cam;

        _unit setFatigue 0;
        _unit setStamina 1;
        _unit enableStamina false;
        _unit enableFatigue false;

        { deleteVehicle _x; }foreach _newObjs;

        sleep 1;
        disableUserInput false;
        sleep 3;

        if (!isMultiplayer) then {
            savegame;
        };

        [_tent,_unit,_action] spawn {
            params["_tent","_unit","_action"];
            sleep 30;
            _unit enableStamina true;
            _unit enableFatigue true;
            sleep 300;
            if (isNull _tent) exitWith {};
            _tent remoteExec ["JP_fnc_actionRest", 0, true];
        };
        
    },nil,1,false,true,"","if(vehicle(_this) == _this)then{true}else{false};",15,false,""];
 };

JP_fnc_actionCorrupt =  {
    _this addAction ["<t color='#000000'>Corrupt him (30min)</t>",{
          params["_unit","_talker","_action"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
      //   if (!([GROUP_PLAYERS,100] call JP_fnc_afford)) exitWith {_this call JP_fnc_endTalking; [_unit,"You need more money !"] spawn JP_fnc_talk;false;};

        //Populate with friendlies
        _curr = ([position _unit,false,"any"] call JP_fnc_findNearestMarker);
    
        [_talker,"Maybe we could find an arrangement..."] remoteExec ["JP_fnc_talk",_talker];

        sleep 1;
        titleCut ["", "BLACK IN", 1];
        [parseText format ["<t font='PuristaBold' size='1.6'>30 minutes later...</t><br/>%1", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;

        showCinemaBorder true;
        _camPos = _talker modelToWorld [-1,-0.2,1.9];
        _cam = "camera" camcreate _camPos;
        _cam cameraeffect ["internal", "back"];
        _unit disableAI "MOVE";
        titleCut ["", "BLACK OUT", 1];
        sleep 1;
        skipTime .50;
        detach _talker;
        _talker switchMove "";
        sleep 2;
        titleCut ["", "BLACK IN", 4];
        sleep 3;
        _unit stop false;
        _unit enableAI "ALL";
        showCinemaBorder false;
        _cam cameraeffect ["terminate", "back"];
        camDestroy _cam;
        
        if(_curr select 17 == "torture") then{ 
            if (!isMultiplayer) then {
                skipTime 6;
            };
		    [_unit,20] remoteExec ["JP_fnc_updateRep",2];
            [_unit,"I accept the deal..."] remoteExec ["JP_fnc_talk",_talker];
            _unit call JP_fnc_mainObjectiveIntel;
        } else {
            [_unit,"You're wasting your time !"] remoteExec ["JP_fnc_talk",_talker];
            [_unit,-10] remoteExec ["JP_fnc_updateRep",2];
        };

        _unit removeAction _action;
        _this call JP_fnc_endTalking;

    },nil,1,true,true,"","true",20,false,""];
};

JP_fnc_actionTorture =  {
    _this addAction ["<t color='#000000'>Torture him (2 hours/Bad reputation)</t>",{
        params["_unit","_talker","_action"];
        //Populate with friendlies
        if (!(_this call JP_fnc_startTalking)) exitWith {};

        _curr = ([position _unit,false,"any"] call JP_fnc_findNearestMarker);
    
		[_unit,-20] remoteExec ["JP_fnc_updateRep",2];
        [_talker,"I need an answer now !! Little piece of shit !!"] remoteExec ["JP_fnc_talk",_talker];

        titleCut ["", "BLACK OUT", 1];
        [parseText format ["<t font='PuristaBold' size='1.6'>2 hours later...</t><br/>%1", daytime call BIS_fnc_timeToString], true, nil, 12, 0.7, 0] spawn BIS_fnc_textTiles;

        sleep 1;

        showCinemaBorder true;
        _camPos = _talker modelToWorld [-1,-0.2,1.9];
        _cam = "camera" camcreate _camPos;
        _cam cameraeffect ["internal", "back"];
        _unit disableAI "MOVE";

        titleCut ["", "BLACK IN", 1];
        sleep 1;

        _cam camSetPos _camPos;
        _cam camSetTarget _unit;
        _cam camSetFov 1.0;
        _cam camCommit 0;
        _unit stop true;
        _unit lookAt _talker;
        _talker lookAt _unit;


        // Animation 
        _talker attachTo [_unit,[-0.9,-0.2,0]]; 
        _talker setDir (_talker getRelDir _unit); 
	    _talker switchMove "Acts_Executioner_StandingLoop";
        _talker switchMove "Acts_Executioner_Backhand";
        _unit switchMove "Acts_ExecutionVictim_Backhand";
        [_unit] call JP_fnc_shout;
        _unit setDamage .5;
        
        sleep 3.6;
        
        // Standing loop
        _unit switchMove "Acts_ExecutionVictim_Loop";
        _talker switchMove "Acts_Executioner_StandingLoop";
        sleep 1;

        // Animation 
        _talker switchMove "Acts_Executioner_Forehand";
        _unit switchMove "Acts_ExecutionVictim_Forehand";
        [_unit] call JP_fnc_shout;
        _unit setDamage .7;

        sleep 3.6;

        // Standing loop
        _unit switchMove "Acts_ExecutionVictim_Loop";
        _talker switchMove "Acts_Executioner_StandingLoop";

        sleep 1;
      
        titleCut ["", "BLACK OUT", 2];
        sleep 2;
        skipTime .50;
        titleCut ["", "BLACK IN", 4];
        sleep 3;
        _unit stop false;
        _unit enableAI "ALL";
        showCinemaBorder false;
        _cam cameraeffect ["terminate", "back"];
        camDestroy _cam;
        detach _talker;
        _talker switchMove "";

        if(_curr select 17 == "torture") then{ 
            if (!isMultiplayer) then {
                skipTime 6;
            };
            _unit removeAction _action;
            [_unit,"I know something ! But stop it ! Please !"] remoteExec ["JP_fnc_talk",_talker];
		    [_unit,10] remoteExec ["JP_fnc_updateRep",2];
            _unit call JP_fnc_mainObjectiveIntel;
        } else {
            [_unit,"Argh... I've told you, I have no idea where he is... Leave me alone ! Please !"] remoteExec ["JP_fnc_talk",_talker];
            [_unit,-10] remoteExec ["JP_fnc_updateRep",2];
            _unit removeAction _action; 
            removeAllActions _unit;
        };
        _this call JP_fnc_endTalking;
    },nil,1,true,true,"","true",20,false,""];
};


JP_fnc_startTalking = {
    params["_unit","_talker","_action"];
     if (_unit getVariable["JP_talking",false]) exitWith {
         hint "Can't do multiple action at the same time..."; 
        _this spawn {
            sleep 10;
            _this call JP_fnc_endTalking;
        };
        false;
    };
    _unit setVariable["JP_talking",true];
    [_unit,[_unit,_talker] call BIS_fnc_dirTo] remoteExec ["setDir",owner _unit];
    [_unit,_talker] remoteExec ["doWatch",owner _unit];
    [_unit,_talker] remoteExec ["lookAt",owner _unit];
    true;
};


JP_fnc_endTalking = {
    params["_unit","_talker","_action"];
    _unit setVariable["JP_talking",false,true];
    true;
};
