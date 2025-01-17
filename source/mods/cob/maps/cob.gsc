#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
#include maps\_zombiemode_zone_manager; 
#include maps\_music;
#include maps\dlc3_code;
#include maps\dlc3_teleporter;

main()
{

	level.DLC3 = spawnStruct(); // Leave This Line Or Else It Breaks Everything
	
	// Must Change These To Your Maps
	level.DLC3.createArt = maps\createart\cob_art::main;
	level.DLC3.createFX = maps\createfx\cob_fx::main;
	level.DLC3.myFX = ::preCacheMyFX;
	
	/*--------------------
	 FX
	----------------------*/
	DLC3_FX();
	
	/*--------------------
	 LEVEL VARIABLES
	----------------------*/	
	
	// Variable Containing Helpful Text For Modders -- Don't Remove
	level.modderHelpText = [];
	
	//
	// Change Or Tweak All Of These LEVEL.DLC3 Variables Below For Your Level If You Wish
	//
	
	// Edit The Value In Mod.STR For Your Level Introscreen Place
	level.DLC3.introString = "COB - Crée par AMAND Alexandre";
	
	// Weapons. Pointer function automatically loads weapons used in Der Riese.
	level.DLC3.weapons = maps\dlc3_code::include_weapons;
	
	// Power Ups. Pointer function automatically loads power ups used in Der Riese.
	level.DLC3.powerUps =  maps\dlc3_code::include_powerups;
	
	// Adjusts how much melee damage a player with the perk will do, needs only be set once. Stock is 1000.
	level.DLC3.perk_altMeleeDamage = 1000; 
	
	// Adjusts barrier search override. Stock is 400.
	level.DLC3.barrierSearchOverride = 400;
	
	// Adjusts power up drop max per round. Stock is 3.
	level.DLC3.powerUpDropMax = 5;
	
	// _loadout Variables
	level.DLC3.useCoopHeroes = true;
	
	// Bridge Feature
	level.DLC3.useBridge = false;
	
	// Hell Hounds
	level.DLC3.useHellHounds = true;
	
	// Mixed Rounds
	level.DLC3.useMixedRounds = true;
	
	// Magic Boxes -- The Script_Noteworthy Value Names On Purchase Trigger In Radiant
	boxArray = [];
	boxArray[ boxArray.size ] = "chest1";
	level.DLC3.PandoraBoxes = boxArray;
	
	// Initial Zone(s) -- Zone(s) You Want Activated At Map Start
	zones = [];
	zones[ zones.size ] = "start_zone";
	level.DLC3.initialZones = zones;
	
	// Electricity Switch -- If False Map Will Start With Power On
	level.DLC3.useElectricSwitch = true;
	
	// Electric Traps
	level.DLC3.useElectricTraps = false;
	
	// _zombiemode_weapons Variables
	level.DLC3.usePandoraBoxLight = true;
	level.DLC3.useChestPulls = true;
	level.DLC3.useChestMoves = false;
	level.DLC3.useWeaponSpawn = true;
	level.DLC3.useGiveWeapon = true;
	
	// _zombiemode_spawner Varibles
	level.DLC3.riserZombiesGoToDoorsFirst = true;
	level.DLC3.riserZombiesInActiveZonesOnly = true;
	level.DLC3.assureNodes = true;
	
	// _zombiemode_perks Variables
	level.DLC3.perksNeedPowerOn = true;
	
	// _zombiemode_devgui Variables
	level.DLC3.powerSwitch = true;
	
	// Snow Feature
	level.DLC3.useSnow = false;
	
	/*--------------------
	 FUNCTION CALLS - PRE _Load
	----------------------*/
	level thread DLC3_threadCalls();	
	
	/*--------------------
	 ZOMBIE MODE
	----------------------*/
	/*if( isDefined( level.DLC3.useElectricSwitch ) && level.DLC3.useElectricSwitch )
	{
		level thread maps\dlc3_code::power_electric_switch();
	}
	else
	{
		level thread maps\dlc3_code::power_electric_switch_on();
	}*/
	level thread maps\dlc3_code::power_electric_switch();
	[[level.DLC3.weapons]]();
	[[level.DLC3.powerUps]]();

	precacheShader( "damage_feedback" );
	
	maps\ugx_easy_fx::fx_setup();
	maps\_character_randomize::init();
	maps\cod_walking::main();
	maps\_knee_slide::main();
	maps\_zombiemode::main();
	players = get_players();
	array_thread(players, ::zombie_hug_fix);
	level thread maps\ugx_easy_fx::fx_start();
	
	
	/*--------------------
	 FUNCTION CALLS - POST _Load
	----------------------*/
	level.zone_manager_init_func = ::dlc3_zone_init;
	level thread DLC3_threadCalls2();
}

dlc3_zone_init()
{
	/*
	=============
	///ScriptDocBegin
	"Name: add_adjacent_zone( <zone_1>, <zone_2>, <flag>, <one_way> )"
	"Summary: Sets up adjacent zones."
	"MandatoryArg: <zone_1>: Name of first Info_Volume"
	"MandatoryArg: <zone_2>: Name of second Info_Volume"
	"MandatoryArg: <flag>: Flag to be set to initiate zones"
	"OptionalArg: <one_way>: Make <zone_1> adjacent to <zone_2>. Defaults to false."
	"Example: add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );"
	///ScriptDocEnd
	=============
	*/

	// Outside East Door
	//add_adjacent_zone( "receiver_zone",		"outside_east_zone",	"enter_outside_east" );
}

preCacheMyFX()
{
	// LEVEL SPECIFIC - FEEL FREE TO REMOVE/EDIT
	
	// level._effect["snow_thick"]			= LoadFx ( "env/weather/fx_snow_blizzard_intense" );
}

zombie_hug_fix()
{
	self endon( "disconnect");
    	for( ;; )
    	{
    		if(getDvarInt("aim_automelee_range") != 64)
    		{
    			self SetClientDvar("aim_automelee_range", "64");
    		}
        	zombies = getaiarray( "axis" );
        	for(i=0; i < zombies.size; i++)
    		{
           		if(Distance( self.origin, zombies[i].origin ) <= 96 && self maps\_laststand::player_is_in_laststand())
            		{
                		zombies[i] PushPlayer( true );
            		}
			else
			{
                		zombies[i] PushPlayer( false );
            		}
        	}
	wait 0.1;
	}
}