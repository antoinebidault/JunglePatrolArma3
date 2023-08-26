
params ["_hours"];

player action ["sitdown", player];

 _camPos = player modelToWorld [.3,2.2,.7];
_cam = "camera" camcreate _camPos;
_cam cameraeffect ["internal", "back"];
_cam camSetPos _camPos;
_cam camSetTarget player;
_cam camSetFov 1.05;
_cam camCommit 30;

_date = date;
if (_date select 3 > _hours) then {
_date set [2, (_date select 2) + 1];
};
_date set [3, _hours];

sleep 3;

[0, "BLACK", 25, 1] spawn BIS_fnc_fadeEffect;

playMusic "vn_another_life";
setAccTime 1000;
while {_date select 3 != date select 3 || _date select 2 != date select 2} do {
	_txtCnd = format["<t font='tt2020style_e_vn_bold' color='#FFF'>%1</t>", daytime call BIS_fnc_timeToString];
	[_txtCnd,0,.5,1,0] spawn BIS_fnc_dynamicText;
	sleep 1;
};

_txtCnd = format["<t font='tt2020style_e_vn_bold' color='#FFF'>%1</t>", daytime call BIS_fnc_timeToString];
[_txtCnd,0,.5,5,0] call BIS_fnc_dynamicText;
setAccTime 1; 

[1, "BLACK", 5, 1] spawn BIS_fnc_fadeEffect;
sleep 1;
SKIP_TIME = true;

showCinemaBorder false;
_cam cameraeffect ["terminate", "back"];
camDestroy _cam;

sleep 3;

savegame;