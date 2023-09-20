


_colonel = missionNamespace getVariable ["colonel", objNull];
_leader = leader GROUP_PLAYERS;

sleep 8;

[_leader,localize "STR_JP_voices_team_briefing","STR_JP_voices_team_briefing","team"] remoteExec ["JP_fnc_talk"];

["JP_primary_briefing",GROUP_PLAYERS, ["Briefing","Briefing","Talk to colonel Russel for the briefing in the operation room"],getPos _colonel,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",GROUP_PLAYERS, true];

JP_fnc_addActionInstructor = {
     _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_briefing"],{
        params["_unit","_caller","_actionId"];
		_unit removeAction _actionId;

        JP_fnc_briefingTalk = {
            [_this, localize "STR_JP_voices_instructor_briefing1","STR_JP_voices_instructor_briefing1","briefing"] call JP_fnc_talk;
            [_this, localize "STR_JP_voices_instructor_briefing2","STR_JP_voices_instructor_briefing2","briefing"] call JP_fnc_talk;
            [_this, localize "STR_JP_voices_instructor_briefing3","STR_JP_voices_instructor_briefing3","briefing"] call JP_fnc_talk;
            [_this, localize "STR_JP_voices_instructor_briefing4","STR_JP_voices_instructor_briefing4","briefing"] call JP_fnc_talk;
        };
        
        // Execute the briefing for all the player
        _unit remoteExec ["JP_fnc_briefingTalk"];

        ["JP_primary_briefing","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",GROUP_PLAYERS,true];

        [] remoteExec ["JP_fnc_ammoTask",2];

    },nil,1,true,true,"","true",3,false,""];
};

_colonel remoteExec ["JP_fnc_addActionInstructor", _leader];
