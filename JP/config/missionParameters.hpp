class Params
{
	
	class AISkill
	{
		title = $STR_JP_missionParameters_AiSkill; // Param name visible in the list
		values[] = {0,1,2}; // Values; must be integers; has to have the same number of elements as 'texts'
		texts[] = {$STR_JP_missionParameters_recruit,$STR_JP_missionParameters_regular,$STR_JP_missionParameters_veteran}; // Description of each selectable item
		default = 2; // Default value; must be listed in 'values' array, otherwise 0 is used
	};
	class Debug
	{
		title = $STR_JP_missionParameters_debug;
		texts[] = {$STR_JP_missionParameters_yes,$STR_JP_missionParameters_no};
		values[] = {1,0};
		default = 0;
		isGlobal = 1; 
	};
	class Respawn
	{
		title = $STR_JP_missionParameters_respawn;
		texts[] = {$STR_JP_missionParameters_yesdefault,$STR_JP_missionParameters_no};
		values[] = {1,0};
		default = 1;
		isGlobal = 1; 
	};
	class Reviving
	{
		title = $STR_JP_missionParameters_reviving;
		texts[] = {$STR_JP_missionParameters_yesdefault,$STR_JP_missionParameters_no};
		values[] = {1,0};
		default = 1;
		isGlobal = 1; 
	};
	class NumberRespawn
	{
		title = $STR_JP_missionParameters_numberRespawn;
		texts[] = {$STR_JP_configDialogFunctions_respawnNone,"1","2","3",$STR_JP_missionParameters_4default,"5","10","50",$STR_JP_missionParameters_unlimited};
		values[] = {0,1,2,4,5,10,50,9999};
		default = 4;
		isGlobal = 0; 
	};
	class Daytime
	{
		title = $STR_JP_missionParameters_time;
		texts[] = {$STR_JP_missionParameters_earlyMorning,$STR_JP_missionParameters_sunRise,$STR_JP_missionParameters_morning,$STR_JP_missionParameters_morningAdvanced,$STR_JP_missionParameters_noon,$STR_JP_missionParameters_startAfternoon,$STR_JP_missionParameters_afternoon,$STR_JP_missionParameters_endAfternoon,$STR_JP_missionParameters_sunset,$STR_JP_missionParameters_evening,$STR_JP_missionParameters_midnight,$STR_JP_missionParameters_darknight};
		values[] = {4,6,8,10,12,14,16,18,20,22,0,2};
		default = 12;
		function = "BIS_fnc_paramDaytime"; // (Optional) [[Functions_Library_(Arma_3)|Function]] [[call]]ed when player joins, selected value is passed as an argument
		isGlobal = 1; // (Optional) 1 to execute script / function locally for every player who joins, 0 to do it only on server
	};
	//#include "\a3\Functions_F\Params\paramRevive.hpp"
};
