 /*
	Author: 
		Bidass

  Version:
    0.9.5

	Description:
		Add the base civilian action.
		"Say hello"
		"Leave"
		"Capture him"

	Parameters:
		0: OBJECT - unit (Must be a civilian)

	Returns:
		BOOL - true 
*/

params ["_unit"];

_unit call JP_fnc_addActionHalt;
_unit call JP_fnc_addActionLeave;
_unit call JP_fnc_addActionHandcuff;

true;