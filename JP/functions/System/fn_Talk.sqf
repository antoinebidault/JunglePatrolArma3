/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Display the chat

  Parameters:
    0: OBJECT - player

  Returns:
    BOOL - true 
*/
if (!hasInterface) exitWith{};

 params["_talker","_say","_sound","_topic"];
_layer = round (random 99999);
_this pushBack _layer;

// Queuing conversation
TALK_QUEUE pushback _this;
waitUntil { sleep .2; TALK_QUEUE select 0 isEqualTo _this};

_side = side group _talker;
_color = "#E0E0E0";
if (_side == CIVILIAN) then {
	_color = '#c6b32b';
}else{
	if (_side == RESISTANCE) then {
		_color = '#549c66';
	}else{
		if (_side == WEST) then {
			_color = '#E5B52E';
		}else{
			if (_side == EAST) then {
				_color = '#d22b2f';
			};
		};
	};
};

player createDiarySubject ["ConvLog", localize "STR_JP_conversation_convLog"];
player createDiaryRecord ["ConvLog", [name _talker, format["%1 %2", date,_say]]];


// Create display and control
disableSerialization;
_layer cutrsc ["rscDynamicText","plain"];
_display = displayNull;
waitUntil {_display = uiNamespace getVariable "BIS_dynamicText"; !(isNull _display)};
_ctrl = _display displayCtrl 9999;
uiNamespace setVariable ["BIS_dynamicText", displayNull];
_ctrlBackground = _display ctrlCreate ["RscText",9999];

// Position control
 _w = 0.7 * safeZoneW;
 _x = safeZoneX + (0.15 * safeZoneW );
 _y = safeZoneY + (0.75 * safeZoneH);
 _h = safeZoneH;


// Show subtitle
// <br/><t size='.3' align = 'center' shadow = '1' color='#cd8700' opacity='.4'>%4</t>
_name = name _talker;

_img="";
_imgName=  _talker getVariable["JP_avatar",""];
if (_imgName != "") then{
	_pic = format['images\%1.paa',_imgName] ; 
	_img = format["<img align='center' size='2' shadow='0' image='%1' />", _pic]; 
};
_text = parseText format ["<t font='PuristaSemiBold' align = 'center' shadow = '2' size = '.8'>%1<br /><t color = '%2'>%3</t></t><br /><t align = 'center'  shadow = '1' size = '.63'><t color = '#E0E0E0'>%4</t></t>",_img,_color,name _talker,_say,localize "STR_JP_talk_spaceToSkip"];
_ctrl ctrlSetStructuredText _text;
MESS_HEIGHT = ctrlTextHeight _ctrl;
MESS_SHOWN = true;

_ctrl ctrlSetPosition [_x,.95*_y,_w,_h];
_ctrl ctrlCommit 0;
_ctrl ctrlSetPosition [_x,_y,_w,_h];

// Hide control
_ctrl ctrlSetFade 0;
_ctrl ctrlCommit .3;


_talker setVariable["JP_speak",true];


if (!isNil '_sound' && !isNil '_topic' ) then {
	_talker kbTell [player, _topic, _sound,false];
	waitUntil { _talker kbWasSaid [player, _topic,_sound, 3]; };
} else {
	playSound "FD_CP_Clear_F";
	_currentTime = time;
	_talker setRandomLip true;
	waitUntil { time >= _currentTime + ((count(_say)/13) max 1.6); };
};

// SPACEBAR_HIT = false;
// _display displayRemoveEventHandler ["KeyDown",_ehId];
_talker setRandomLip false;
_talker setVariable["JP_speak",false];

if (isNull _ctrl) exitWith{};

if (count TALK_QUEUE > 1) then {
	TALK_QUEUE = TALK_QUEUE - [_this];
	MESS_SHOWN = false;
	// Wait for the next message to show up
	waituntil {MESS_SHOWN || count TALK_QUEUE == 0};
	_ctrl ctrlSetPosition [_x,1.1*MESS_HEIGHT + _y,_w,_h];	
	_ctrl ctrlSetFade .4;
	_ctrl ctrlCommit .3;
	sleep ((count((TALK_QUEUE select 0) select 1)/11) max 1.6);
	_ctrl ctrlSetFade 1;
	_ctrl ctrlCommit .3;
} else {
	_ctrl ctrlSetFade 1;
	_ctrl ctrlCommit .3;
	sleep .3;
	// remove talk queue
	TALK_QUEUE = TALK_QUEUE - [_this];
	MESS_SHOWN = false;
};

ctrlDelete _ctrl;
