_unit = _this;

private _foundCloseUnit = objNull;
private _dist = 999999;
{
	if(!isPlayer _x && alive _x && (_x distance _unit) < _dist && (lifeState _x == "HEALTHY" || lifeState _x == "INJURED") && isNull(_unit getVariable["JP_heal_injured",objNull])) then 
	{
		_foundCloseUnit = _x;
		_dist = _x distance _unit;
	};
}foreach units GROUP_PLAYERS; 

_foundCLoseUnit;