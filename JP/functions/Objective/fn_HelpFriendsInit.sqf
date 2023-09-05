/*
  Author: 
    Bidass

  Version:
    0.9.1

  Description:
    Task for helping a group of lost soldiers 

  Returns:
    units
*/

"rescue_lz" setMarkerAlpha 0;
"rescue_lz_2" setMarkerAlpha 0;

Medevac_state = "initial";
_teamLeader = missionNamespace getVariable ["danger_team_leader", objNull];
_teamLeader setCaptive true;

{
  _x disableAI "MOVE";
}foreach units group _teamLeader;

