/**
 * DYNAMIC CIVIL WAR
 * Created: 2017-11-29
 * Author: Bidass

  Version:
    {VERSION}
 * License : GNU (GPL)
 *
 * Modified script of SPUn / LostVar
 */


private _grp = _this select 0;
private _radius = _this select 1;
private _meetPoint = _this select 2;
private _buildings = _this select 3;
private _center = _this select 4;
private _foundInjuredUnit = objNull;
sleep 10 + floor(random 30);

{
    if (side _x == SIDE_CIV && isNull(_x getVariable["JP_healer",objNull]) && lifeState _x == "INCAPACITATED") then {
        _foundInjuredUnit = _x;
    };
} foreach nearestObjects [_center,["Man"],_radius];

if (!isNull _foundInjuredUnit) then {
    [leader _grp, _foundInjuredUnit,true] spawn JP_fnc_firstaid;
} else {
    [_grp,_radius,_meetPoint,_buildings] spawn JP_fnc_civilianCompoundPatrol;
};

false;
