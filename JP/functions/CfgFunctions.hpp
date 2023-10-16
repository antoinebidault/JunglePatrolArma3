class CfgFunctions
{
	class JP
	{
		class JPFunctions
		{
			tag = "JP"; //Custom tag name
			requiredAddons[] = {"A3_Data_F"}; //Optional requirements of CfgPatches classes. When some addons are missing, functions won't be compiled.
		};

		class Behavior
		{	
			file = "JP\functions\behavior";
			class actionCamp {};
			class addCivilianAction {};
			class addTorch {};
			class badGuyLoadout {};
			class camp {};
			class localChief {};
			class medic {};
			class mortarbombing {};
			class addActionFunctions {};
			class randomAnimation {};
			class shout {};
			class surrender {};
			class updateRep {};
			class shoot {};
		};

		class CutScene
		{	
			file = "JP\functions\cutscene";
			class CamFollow {};
			class CompoundSecuredCutScene {};
		};

		
		class System
		{	
			file = "JP\functions\system";
			class factionClasses {};
			class factionGetUnits {};
			class factionList {};
			class factionGetSupportUnits {};
			class nearestPlayer {};
			class getConfigVehicles {};
			class getCompoundStateLabel {};
			class getClusters {};
			class isInMarker {};
			class findBuildings {};
			class addMarker {};
			class deleteMarker {};
			class findNearestMarker {};
			class setWeather {};
			class cachePut {};
			class showIndicator {};
			class talk {};
			class getVisibility {};
			class undercover {};
			class setCompoundState {};
			class setCompoundSupport {};
			class surrenderSystem {};
			class captured {};
			class getMarkerById {};
			class refreshMarkerStats {};
			class teleport {};
			class addAction {};
			class removeAction {};
			class allPlayers {};
			class fillClusters {};
			class conversation {};
			class showSubtitle {};
			class hideSubtitle {};
		};
			
		class Spawn
		{	
			file = "JP\functions\spawn";
			//class respawn {};
			//class respawnDialog {};
			class spawnOfficer{};
			class spawnUnits {};
			class spawnAsEnemy {};
			class spawnchaser {};
			class spawnRandomConvoy {};
			class spawnoutpost {};
			class spawnMeetingPoint {};
			class spawnCivil {};
			class spawnEnemy {};
			class spawnAircraft {};
			class spawnFriendlyOutpost {};
			class spawnMortar {};
			class spawnCars {};
			class spawnMainObjective {};
			class spawnSecondaryObjective {};
			class spawnTrackerPatrol {};
			class spawnAnimal {};
			class spawnConvoy {};
			class spawnPosition {};
			class spawnCrashSite {};
			class spawnDefendTask {};
			class spawnIED {};
			class spawnFriendly {};
			class spawncrate {};
			class spawnhumanitaryoutpost {};
			class SpawnObjects {};
			class SpawnAvalanche {};
			class spawnhumanitar {};
			class spawnSnipers {};
			class spawnSheep {};
			class spawnRandomEnemies {};
			class spawnRandomCivilian {};
			class spawnRandomCar {};
			class spawnChopper {};
			class spawnLoop {};
			class SpawnTank {};
		};

		class Patrol
		{	
			file = "JP\functions\patrol";
			class enemyCompoundPatrol {};
			class civilianCompoundPatrol {};
			class simplePatrol {};
			class largePatrol {};
			class chase {};
			class aircraftPatrol {};
			class carPatrol {};
			class officerPatrol {};
			class civilianPatrol {};
			class gotomeeting {};
			class chopperpatrol {};
			class humanitarPatrol {};
			class patrolDistributeToHC {};
			class airBridge {};
		};

	    class Objective
		{	
			file = "JP\functions\objective";
			class getIntel {};
			class cache {};
			class hostage {};
			class success {};
			class revealObjective {};
			class updateMarker {};
			class failed {};
			class createtask {};
			class skipTime {};
			class capturedTask {};
			class reconTask {};
			class sleepTask {};
			class extractionTask {};
			class briefingTask {};
			class insertionTask {};
			class ammoTask {};
			class insertionTrackerTask {};
			class mainObjectiveIntel {};
			class compoundSecured {};
			class helpFriends {};
			class helpFriendsInit {};
			class helpFriendsRadio {};
		};

	    class Handler
		{	
			file = "JP\functions\handler";
			class HandleFiredNear {};
			class HandleDamaged {};
			class HandleKill {};
			class HandleAttacked {};
		};

		
	    class SupportUI
		{	
			file = "JP\functions\supportui";
			class SupportInit {};
			class addSupportUi {};
			class UpdateScore {};
			class Afford {};
			class displaySupportUiDialog {};
			class DisplayScore {};
			class GetCrateItems {};
			class BuildingKit {};
			class TriggerSupport {};
			class vehicleLift {};
		};

		class Medical
		{	
			file = "JP\functions\medical";
			class medicalInit{};
			class SpawnHelo {};
			class SpawnHeloCrew {};
			class SpawnHeloReplacement {};
			class HandleDamage {};
			class HandleKilled {};
			class findCloseMedic{};
			class heal {};
			class carry {};
			class chopperpath {};
			class calculateTimeToHeal {};
			class spawnHealEquipement {};
			class spawnObject {};
			class dropInHelo {};
			class help {};
			class removeFAKS {};
			class deleteMedevac {};
			class caller {};
			class FirstAid {};
			class injured {};
			class removeActionHeal {};
			class addActionHeal {};
			class resetState {};
			class resetStateAI {};
		};

		
		class Building
		{	
			file = "JP\functions\building";
			class buildingDialog {};
			class affordObject {};
			class grabObject {};
			class placeObject {};
			class sellObject {};
			class addActionObject {};
			class recruitDialog {};
			class getUnitCost {};
			class affordRecruit {};
		};

	};
};