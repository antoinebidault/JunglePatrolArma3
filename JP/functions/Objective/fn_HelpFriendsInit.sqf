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
Medevac_state = "initial";
_teamLeader = missionNamespace getVariable ["danger_team_leader", objNull];
_teamLeader setCaptive true;

{
  _x disableAI "MOVE";
}foreach units group _teamLeader;

