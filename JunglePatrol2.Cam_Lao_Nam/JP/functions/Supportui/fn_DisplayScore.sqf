/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    Display the score UI at the bottom of the screen.
	Executed on player's computer

*/

if (isNull player) exitWith{false;};
 

private _points = JP_SCORE;
private _colorChaser = "";
private _labelChaser = "";
private _statusUnd = "";
private _colorUnd = "";

// Undercover status
if (player getVariable["JP_undercover",false]) then{
	_statusUnd = "hidden";
	_colorUnd = "#2f9581";
	if (player getVariable["JP_watched",false]) then{
		_statusUnd = "watched";
		_colorUnd = "#e0923a";
	};
}else{
	_statusUnd = "Inactive";
	_colorUnd = "#e46b6b";
};

("RscStatusBar" call BIS_fnc_rscLayer) cutRsc ["RscStatusBar","PLAIN"];	
disableSerialization;
	((uiNamespace getVariable "RscStatusBar")displayCtrl 55554) ctrlSetStructuredText
parseText format ["<t shadow='1' shadowColor='#000000' color='#FFFFFF'>Score : %1 points <t color='#cd8700'>|</t> Undercover : <t color='%2'>%3</t> </t>",_points,_colorUnd,_statusUnd];

//parseText format ["<t shadow='1' shadowColor='#000000' color='#FFFFFF'>Score : %1 points <t color='#cd8700'>|</t> Compounds : <t color='#229999'>%2</t>/<t color='#FF0000'>%3</t>/<t color='#000000'>%4</t>/<t>%5</t> <t color='#cd8700'>|</t> Lives : %6 <t color='#cd8700'>|</t> Undercover : <t color='%7'>%8</t> <t color='#cd8700'>|</t> Reputation : %9/100</t>",_points,STAT_COMPOUND_SECURED,STAT_COMPOUND_BASTION,STAT_COMPOUND_MASSACRED,STAT_COMPOUND_TOTAL,if (REMAINING_RESPAWN <= -1) then {"∞"} else {REMAINING_RESPAWN},_colorUnd,_statusUnd,STAT_SUPPORT];