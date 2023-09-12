params["_weather"];
// OVERCAST
0 setOvercast _weather;
0 setRain (if (_weather > .7) then {random 1}else{0});
// setWind [10*WEATHER, 10*WEATHER, true];
0 setFog [if (_weather > .8) then {.15}else{0},if (_weather > .8) then {.04}else{0}, 60];
0 setGusts (_weather - .3);
0 setWaves _weather;
forceWeatherChange;