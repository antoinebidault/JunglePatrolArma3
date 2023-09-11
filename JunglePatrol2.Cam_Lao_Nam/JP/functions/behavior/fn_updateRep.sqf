/*
  Author: 
    Bidass

  Version:
    0.9.5

  Description:
    Update the reputation score

  Parameters:
    0: OBJECT - unit
	1: NUMBER - Score to add (Negative value are allowed)

  Returns:
    BOOL - true 
*/

params["_unit","_score"];

// Always executed on server side
if (!isServer) exitWith{};
if (isNil '_unit') exitWith{false};
if (isnull _unit) exitWith{false};
if (_score == 0) exitWith{};
/*
_startScore = _unit getVariable["JP_Friendliness",50];
_unit setVariable["JP_Friendliness",(0 max (100 min (_startScore + _score))), true];
*/
// Get the closest marker
_compound = ([position _unit,false,"any"] call JP_fnc_findNearestMarker);
[_compound,_score,0] spawn JP_fnc_setCompoundSupport;