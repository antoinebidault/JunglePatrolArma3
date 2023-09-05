class Header
{
	gameType =  Coop;	// Game type
	minPlayers =  1;	// minimum number of players the mission supports
	maxPlayers = 10;	// maximum number of players the mission supports
};  

// disabledAI= 1;
enableDebugConsole[] = {"76561197974435552"}; 
allowFunctionsLog = 1;
author = "Bidass"; 
briefing = 0;
briefingName = "Jungle Patrol Khe Sanh"; 
onLoadMission = $STR_JP_description_onLoadMission;
loadScreen = "images\loadscreen.paa";  
overviewPicture = "images\loadscreen.paa";  
overviewText = $STR_JP_description_onLoadMission;
overviewTextLocked = $STR_JP_description_onLoadMission;
wreckManagerMode = 2; 
wreckRemovalMinTime = 12;   
wreckRemovalMaxTime = 13;  
wreckLimit = 15;  
respawnOnStart = -1;  
corpseManagerMode = 1; 
corpseLimit = 25; 
ReviveMode = 0;                         //0: disabled, 1: enabled, 2: controlled by player attributes
ReviveUnconsciousStateMode = 0;         //0: basic, 1: advanced, 2: realistic
ReviveRequiredTrait = 0;                //0: none, 1: medic trait is required
ReviveRequiredItems = 2;                //0: none, 1: medkit, 2: medkit or first aid kit
ReviveRequiredItemsFakConsumed = 1;     //0: first aid kit is not consumed upon revive, 1: first aid kit is consumed
ReviveDelay = 10;                        //time needed to revive someone (in secs)
ReviveMedicSpeedMultiplier = 2;         //speed multiplier for revive performed by medic
ReviveForceRespawnDelay = 3;            //time needed to perform force respawn (in secs)
ReviveBleedOutDelay = 120;              //unconscious state duration (in secs)
// keys[] = {"key1"};
// keysLimit = 1; 
// taskManagement_propagate = 1;
  
//--------------------------------------------------------------
//---------------------    MUSICS    ---------------------------
//--------------------------------------------------------------

/*
class CfgMusic
{
  	tracks[]=
  	{
      		seal,axe
  	};
    class seal
    {
          name = "seal";
          sound[] = {"\music\seal.ogg", 1, 1.0};
    };
     class axe
    {
          name = "axe";
          sound[] = {"\music\axe.ogg", 1, 1.0};
    };
};*/



#include "config\missionParameters.hpp"
#include "functions\supportui\Defines.hpp"
#include "functions\supportui\buySupports.hpp" 
#include "functions\supportui\notification.hpp" 
#include "functions\building\buildingDialog.hpp"
#include "functions\building\recruitDialog.hpp"
#include "config\respawn.hpp"   
#include "config\configDialog.hpp"  
#include "config\loadoutDialog.hpp"  
#include "functions\CfgFunctions.hpp"
#include "voices\CfgSentences.hpp"
#include "functions\supportui\Config.hpp"
   
class RscTitles {   
  #include "functions\supportui\statusBar.hpp"  
};        



