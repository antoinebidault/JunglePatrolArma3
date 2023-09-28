params["_pos"];

private _foundCloseUnit = objNull;
private _dist = 999999;
{
	if(alive _x && ((getPos _x) distance _pos) < _dist && (lifeState _x == "HEALTHY" || lifeState _x == "INJURED")) then {
		_foundCloseUnit = _x;
		_dist =  (getPos _x) distance _pos;
	};
}foreach units GROUP_PLAYERS; 

_foundCLoseUnit;