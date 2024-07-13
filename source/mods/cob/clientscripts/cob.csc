#include clientscripts\_utility;
#include clientscripts\_music;
#include clientscripts\_fx;

main()
{
	level.DLC3_Client = spawnStruct(); // Leave This Line Or Else It Breaks Everything

	// Must Change These For Your Map
	level.DLC3_Client.createFX = clientscripts\createfx\cob_fx::main;
	level.DLC3_Client.myFX = ::preCacheMyFX; 

	clientscripts\_load::main();

	println("Registering zombify");
	clientscripts\_utility::registerSystem("zombify", clientscripts\dlc3_code::zombifyHandler);

	clientscripts\dlc3_teleporter::main();
	
	clientscripts\dlc3_code::DLC3_FX();
	
	clientscripts\_zombiemode_tesla::init();

	thread clientscripts\_audio::audio_init(0);

	// Change For Your Map!
	thread clientscripts\cob_amb::main();

	thread player_init();

	level._zombieCBFunc = clientscripts\_zombie_mode::zombie_eyes;
	
	thread waitforclient(0);

	println("*** Client : zombie running...or is it chasing? Muhahahaha");
	
}

preCacheMyFX()
{
	// LEVEL SPECIFIC - FEEL FREE TO REMOVE/EDIT
	
	level._effect["snow_thick"]	= LoadFx( "env/weather/fx_snow_blizzard_intense" );
}

player_init()
{
	waitforclient( 0 );
	
	players = GetLocalPlayers();
	for( i = 0; i < players.size; i++ )
	{
		players[i] thread minigun_ann_vox( i );
		players[i] thread bonuspoints_ann_vox( i );
		players[i] thread randomgun_ann_vox( i );
		players[i] thread zombieblood_ann_vox( i );
	}
}

minigun_ann_vox(localclientnum)
{
	for(;;)
	{
		level waittill("ann_minigun", localclientnum);
		playsound(localclientnum,"ann_minigun",(0,0,0));
	}
}

bonuspoints_ann_vox(localclientnum)
{
	for(;;)
	{
		level waittill("ann_bonuspoints", localclientnum);
		playsound(localclientnum,"ann_bonus_points",(0,0,0));
	}
}

randomgun_ann_vox(localclientnum)
{
	for(;;)
	{
		level waittill("ann_randomgun", localclientnum);
		playsound(localclientnum,"ann_randomgun_00",(0,0,0));
	}
}

zombieblood_ann_vox(localclientnum)
{
	for(;;)
	{
		level waittill("ann_zombieblood", localclientnum);
		playsound(localclientnum,"ann_zombie_blood",(0,0,0));
	}
}