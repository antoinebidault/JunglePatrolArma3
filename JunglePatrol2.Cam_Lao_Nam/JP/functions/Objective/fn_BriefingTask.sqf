
_colonel = missionNamespace getVariable ["colonel", objNull];
_colonel kbAddTopic ["briefing", "JP\voices\Briefing\CfgSentences.bikb"];
player kbAddTopic ["briefing", "JP\voices\Briefing\CfgSentences.bikb"];

_mg = missionNamespace getVariable ["mg", objNull];
_doc = missionNamespace getVariable ["doc", objNull];
_rto = missionNamespace getVariable ["rto", objNull];

player kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_doc kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_rto kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];
_mg kbAddTopic ["team", "JP\voices\Team\CfgSentences.bikb"];

sleep 8;

[player,localize "STR_JP_voices_team_briefing","STR_JP_voices_team_briefing","team"] remoteExec ["JP_fnc_talk"];

{
    ["JP_primary_briefing",_x, ["Briefing","Briefing","Talk to colonel Russel for the briefing in the operation room"],getPos _colonel,"CREATED",1, true] remoteExec ["BIS_fnc_setTask",owner _x, true];
} foreach ([] call JP_fnc_allPlayers);


JP_fnc_addActionInstructor = {
     _this addaction [format["<t color='#cd8700'>%1</t>",localize "STR_JP_addActionFunctions_briefing"],{
        params["_unit"];
        if (!(_this call JP_fnc_startTalking)) exitWith {};
        [_unit, localize "STR_JP_voices_instructor_briefing1","STR_JP_voices_instructor_briefing1","briefing"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing2","STR_JP_voices_instructor_briefing2","briefing"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing3","STR_JP_voices_instructor_briefing3","briefing"] call JP_fnc_talk;
        [_unit, localize "STR_JP_voices_instructor_briefing4","STR_JP_voices_instructor_briefing4","briefing"] call JP_fnc_talk;
        _this call JP_fnc_endTalking;
        {
            ["JP_primary_briefing","SUCCEEDED",true] remoteExec ["BIS_fnc_taskSetState",_x,true];
        } foreach ([] call JP_fnc_allPlayers);

        [] spawn JP_fnc_ammoTask;
    },nil,1,true,true,"","true",3,false,""];


};

_colonel call JP_fnc_addActionInstructor;
