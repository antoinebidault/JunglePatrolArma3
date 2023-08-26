
class CfgSentences
{
	class JP
	{
		class Briefing
		{
			file = "Briefing\CfgSentences.bikb";
			#include "Briefing\CfgSentences.bikb" // avoids a double declaration
		};
		class Team
		{
			file = "Team\CfgSentences.bikb";
			#include "Team\CfgSentences.bikb" // avoids a double declaration
		};
	};
};