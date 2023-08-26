/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    Buying function

  Parameters:
    0: OBJECT - Group of players => The money is collected for the whole group
	1: NUMBER - The price

  Returns:
    BOOL - true if the buying is successful.
*/
params ["_group","_price"];

_score = JP_SCORE;
_score = (_score - _price);
if (_score < 0) then{ 
	hint localize "STR_JP_support_hint3";
	false;
}else{
	[_group,-_price] remoteExec ["JP_fnc_updateScore",2];   
	true;
};