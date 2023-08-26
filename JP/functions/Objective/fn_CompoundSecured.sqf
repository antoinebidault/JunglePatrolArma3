/*
  Author: 
    Bidass

  Version:
    {VERSION}

  Description:
    triggered when a compound is secured

  Parameters:
    0: ARRAY - the compound's data array (In MARKERS global scope variable)

*/


params["_compound"];
// Set the correct state

[_compound,"secured"] spawn JP_fnc_setCompoundState;
[_compound,50,10] spawn JP_fnc_setCompoundSupport;
