params["_vehicle"];

private _mag = (magazines _vehicle) select 0;  // def = 8Rnd_82mm_Mo_shells

sleep (random 5);

while {sleep 3;alive _vehicle} do {
	sleep 100;
	_vehicle doArtilleryFire [_vehicle modelToWorld [0,1000,200], _mag, 8];
	waitUntil {sleep 1; unitReady _vehicle};
};