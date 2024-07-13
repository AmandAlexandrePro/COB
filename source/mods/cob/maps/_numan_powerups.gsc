#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

////////////////// POWERUP SETUP /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Powerup_Setup()
{
	///////////////////// Powerup Enable/Disable ///////////////////////
	// Numan Powerups
	level.enableRandomPerk				= 1;	// Give a Random Perk.							Always enabled.
	level.enableUpgradeWeapon			= 1;	// Upgrade the player's current weapon.			Always enabled.
	level.enableUnlimitedAmmo			= 1;	// Temporary Unlimited Ammo.					Always enabled.
	level.enableBonusPoints				= 1;	// Bonus Points.								Always enabled. Only gives points to alive players.
	level.enableMinigun					= 1;	// Death Machine.								Always enabled.
	level.enableFireSale				= 1;	// Fire Sale. 									Only enables once box has moved once.
	level.enableRevivePlayers			= 1;	// Revive/Resurrect all downed/dead players. 	Only enables in co-op. Only spawns once a player is downed/dead.
	level.enableRandomGun 				= 1;	// Gives player a random weapon. 				Always enabled.
	level.enableZombieBlood 			= 1;	// Temporarily diverts zombies from player.		Always enabled.

	// Default Powerups
	level.enableNuke					= 1;	// Nuke.
	level.enableInstaKill				= 1;	// Insta Kill.
	level.enableDoublePoints			= 1;	// Double Points.
	level.enableMaxAmmo					= 1;	// Max Ammo.
	level.enableCarpenter				= 1;	// Carpenter.
	////////////////////////////////////////////////////////////////////

	////////////////////////// Powerup Config //////////////////////////
	level.RevivePlayersChance			= 25; 				// Added Chance that Revive All Players will spawn if a player is downed/dead. (Max 100, Min 1) Higher number = More chance.
	level.ReviveDeadPlayers				= 1;				// Revive-All Powerup Brings dead Players Back to life (= 1) or only downed players (= 0).

	level.DogRoundPowerup 				= "full_ammo";		// Must be a valid powerup from the list below and enabled.
	// Power Up List //////////////////////////////
	//	"full_ammo" 		- Max Ammo.
	//	"nuke"				- Nuke.
	//	"insta_kill"		- Insta-Kill.
	//	"double_points"		- Double Points.
	//	"carpenter"			- Carpenter.
	//	"randomperk"		- Random Perk.
	//	"upgrade_weap"		- Upgrade Weapon.
	//	"unlimited_ammo"	- Unlimited Ammo.
	//	"bonus_points"		- Bonus Points.
	//	"firesale"			- Fire Sale.
	//	"minigun"			- Death Machine.
	//	"reviveallplayers"	- Revive All Players.
	//	"randomgun"			- Random Weapon.
	//	"zombie_blood"		- Zombie Blood.
	///////////////////////////////////////////////

	level.BonusPointsAmount				= 50;	// Minimum amount of points for bonus points. This will be randomly multiplied by the Max/Min Bonus Points Multiplier. Make sure this is rounded by 10 (Ends in 0).
	level.BonusPointsMaxMultiplier 		= 10;	// E.G - 50 x 10 = 500
	level.BonusPointsMinMultiplier		= 5;	// E.G - 50 x 5 = 250

	// Minigun Weapon (Should be kept as minigun_zm, or a weapon that does not include _upgraded version AND that cannot be retrieved by other means).
	level.MinigunWeapon 				= "minigun_zm";

	// Set if powerup affects all players (= 1), or just the player that picked it up (= 0).
	level.give_randomperk_all_players 	= 0;	// Random Perk.
	level.give_upgrade_weap_all_players	= 0;	// Weapon Upgrade.
	level.give_bonus_points_all_players = 0;	// Bonus Points.
	level.give_minigun_all_players		= 0;	// Minigun.
	level.give_randomgun_all_players 	= 0;	// Random Gun. Remember, This will replace *ALL* Players' current weapon when grabbed.

	// Timers Config (Probably sensible to keep these above 5).
	level.UnlimitedAmmoTime 			= 20; 	// How long Unlimited Ammo is Active.
	level.FireSaleTime 					= 30;	// How long Fire Sale is Active.
	level.MinigunTime 					= 30;	// How long Minigun is Active.
	level.ZombieBloodTime 				= 30;	// How long Zombie Blood is active.

	// Random Gun Powerup Weapons
	level.magicweapons = [];
	level.magicweapons[0]				= "zombie_colt";
	level.magicweapons[1]				= "zombie_mg42";
	level.magicweapons[2] 				= "zombie_kar98k";
	level.magicweapons[3] 				= "zombie_kar98k_upgraded";
	level.magicweapons[4] 				= "zombie_stg44_upgraded";
	level.magicweapons[5] 				= "zombie_doublebarrel_upgraded";
	level.magicweapons[6] 				= "zombie_bar";
	level.magicweapons[7] 				= "zombie_m1garand";
	level.magicweapons[8] 				= "zombie_colt_upgraded";
	level.magicweapons[9] 				= "ptrs41_zombie";
	level.magicweapons[10] 				= "ray_gun";

	// Enable this if you want to use all box weapons in Random Weapons Powerup. (Not Recommended and MAY have bugs.)
	level.randomgun_uses_all_guns 		= 0;

	// Regular vision settings
	level.zombievisionfile 				= "zombie_factory";
	level.normalfov						= 65;
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// WARNING: DO NOT EDIT ANYTHING BELOW HERE UNLESS YOU KNOW WHAT YOU'RE DOING! //

	PrecacheModel( "zombie_pickup_zombieblood");
	PrecacheModel("t5_weapon_carry_minigun_world");

	set_zombie_var( "zombie_powerup_unlimited_ammo_on", false );
	set_zombie_var( "zombie_powerup_unlimited_ammo_time", level.UnlimitedAmmoTime );
	set_zombie_var( "zombie_powerup_firesale_on", 	false );
	set_zombie_var( "zombie_powerup_firesale_time", level.FireSaleTime );

	level.zombie_treasure_chest_cost = 950;
	level.firesale = undefined;
	level.UnlimitedAmmo = undefined;
	level.fire_sale_allowed = undefined;
	level.num_using_zombieblood = undefined;

	setsaveddvar ( "player_sustainammo", 0 );

	flag_wait("all_players_connected");
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i].UsingMinigun = undefined;
		players[i].UsingZombieBlood = undefined;
		players[i].MinigunTimer = undefined;
		players[i].ZombieBloodTimer = undefined;
		players[i].perknum = undefined;
		players[i].gun_to_up = undefined;
		players[i].playerweapons = undefined;
		players[i] thread Death_Watcher();

		wait 0.05;
	}

	for(i=0;i<level.chests.size;i++)
	{
		level.chests[i].isFireSaleBox = 0;
	}

}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////// RANDOM PERK ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


randomperk(power_up_name)
{
	if( self maps\_laststand::player_is_in_laststand() )
	{
		return;
	}

	playerweapon = self GetCurrentWeapon();
	if(	playerweapon == "zombie_perk_bottle_doubletap" 	||
		playerweapon == "zombie_perk_bottle_jugg" 		||
		playerweapon == "zombie_perk_bottle_revive" 	||
		playerweapon == "zombie_perk_bottle_sleight" 	||
		playerweapon == "zombie_bo2_perk_bottles"		)
	{
		self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
		wait 0.5;
	}

	if(!isdefined(self.perknum) || self.perknum <= 0) // if player doesnt have any perks
	{
		self resetperkdefs();
	}

	if( self.perknum == self.perkarray.size )
	{
		self thread play_sound_2d("sam_nospawn");
		return;
	}

	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );

	while(self HasPerk( self.perkarray[self.perknum] ) || self.perknum == self.perkarray.size )
	{
		self.perknum++;
		wait 0.05;
	}
	perk = self.perkarray[self.perknum];
	sound = "laugh_child";
	switch( perk )
	{
		case "specialty_armorvest":
			sound = "mx_jugger_sting";
			break;

		case "specialty_quickrevive":
			sound = "mx_revive_sting";
			break;

		case "specialty_fastreload":
			sound = "mx_speed_sting";
			break;

		case "specialty_rof":
			sound = "mx_doubletap_sting";
			break;

		/*default:
			sound = "laugh_child";
			break;*/
	}
	self thread play_sound_2d(sound);
	gun = self maps\_zombiemode_perks::perk_give_bottle_begin( perk );
	self.is_drinking = 1;
	self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	self maps\_zombiemode_perks::perk_give_bottle_end( gun, perk );
	self.is_drinking = undefined;

	self SetPerk( perk );
	self thread maps\_zombiemode_perks::perk_vo(perk);
	self thread maps\_zombiemode_perks::perk_think( perk );
	self thread maps\_zombiemode_perks::perk_hud_create( perk );
	self setblur( 4, 0.1 );
	wait 0.1;
	self setblur( 0, 0.1 );
	self.perknum++; // add 1 perk to counter
	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );
}

resetperkdefs()
{	
	self.perkarray = [];
	self.perkarray[0] = "specialty_armorvest"; 				// Juggernog
	self.perkarray[1] = "specialty_rof";					// Double Tap
	self.perkarray[2] = "specialty_fastreload";				// Speed Cola
	self.perkarray[3] = "specialty_quickrevive";			// Quick Revive

	self.perkarray = array_randomize( self.perkarray );
	self.perknum = 0;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// UPGRADE WEAPON /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


upgrade_weap(power_up_name)
{
	if( self maps\_laststand::player_is_in_laststand() )
	{
		return;
	}
	
	self.gun_to_up = self GetCurrentWeapon();
	self.playerweapons = self GetWeaponsListPrimaries();
	if( isdefined( level.zombie_include_weapons[self.gun_to_up + "_upgraded"] ) && !self HasWeapon(self.gun_to_up + "_upgraded") && !self maps\_laststand::player_is_in_laststand() && isalive(self))
	{
		self DisableWeaponCycling();

		if(self.playerweapons.size >= 2) // player has 2 guns or more
		{
			self TakeWeapon(self.gun_to_up);
		}
		else if(self.gun_to_up == "zombie_colt")
		{
			vending_upgrade_trigger = GetEntArray("zombie_vending_upgrade", "targetname");
			if ( vending_upgrade_trigger.size >= 1 )
			{
				array_thread( vending_upgrade_trigger, ::colt_watcher, self );;
			}
		}

		self GiveWeapon(self.gun_to_up + "_upgraded");
		self GiveMaxAmmo(self.gun_to_up + "_upgraded");
		self SwitchToWeapon(self.gun_to_up + "_upgraded");
		self EnableWeaponCycling();
		self thread HudElementMaker("Upgraded Weapon!");
	}
	else
	{
		power_up_name = "full_ammo";
		self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );
		self SetWeaponAmmoClip( self.gun_to_up, WeaponClipSize( self.gun_to_up ) );
		self GiveMaxAmmo(self.gun_to_up);
		self playsound("full_ammo");
		self play_sound_2d("ma_vox");
		//wait 3;
		self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );
	}
}

colt_watcher(player)
{
	while(1)
	{
		self waittill_either("pap_taken","pap_timeout");
		player.playerweapons = player GetWeaponsListPrimaries();
		if(player HasWeapon("zombie_colt_upgraded") && player.playerweapons.size == 1)
		{
			player GiveWeapon("zombie_colt");
		}
		player.playerweapons = player GetWeaponsListPrimaries();
		if(player.playerweapons.size > 2)
		{
			player TakeWeapon("zombie_colt");
		}
		break;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// REVIVE ALL PLAYERS /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


ReviveAllPlayers()
{
	self PlaySound("ann_reviveall");
	if( self maps\_laststand::player_is_in_laststand() )
	{
		self maps\_laststand::revive_success( self );
	}
	else if(self.sessionstate == "spectator" && isdefined(level.ReviveDeadPlayers) && level.ReviveDeadPlayers)
	{
		self maps\_zombiemode::spectators_respawn();
	}
	else
	{
		self thread HudElementMaker("Réanimation de tous les joueurs");
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// UNLIMITED AMMO /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


UnlimitedAmmo(power_up_name)
{
	if(isDefined(level.UnlimitedAmmo) && level.UnlimitedAmmo == 1)
	{
		level.zombie_vars["zombie_powerup_unlimited_ammo_time"] = level.UnlimitedAmmoTime;
		return;
	}

	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );

	unlimitedammo_sound_player = Spawn("script_origin",(0,0,0));
	unlimitedammo_sound_player PlayLoopSound("double_point_loop");

	level.zombie_vars["zombie_powerup_unlimited_ammo_on"] = 1;
	level notify("zombie_powerup_timer");

	level.UnlimitedAmmo = 1;
	setsaveddvar ( "player_sustainammo", 1 );
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread give_ply_ammo();
	}

	level.zombie_vars["zombie_powerup_unlimited_ammo_time"] = level.UnlimitedAmmoTime;
	while(level.zombie_vars["zombie_powerup_unlimited_ammo_time"] > 0)
	{
		level.zombie_vars["zombie_powerup_unlimited_ammo_time"]--;
		wait 1;
	}

	unlimitedammo_sound_player StopLoopSound();
	unlimitedammo_sound_player Delete();

	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );

	setsaveddvar ( "player_sustainammo", 0 );
	level.UnlimitedAmmo = 0;
	level.zombie_vars["zombie_powerup_unlimited_ammo_on"] = 0;
	level notify("zombie_powerup_timer");
}

give_ply_ammo()
{
	self.CurrentWeapons = self GetWeaponsListPrimaries();
	self.CurrentWeapon = self GetCurrentWeapon();
	self.AmmoAmmount = self GetAmmoCount(self.CurrentWeapon);

	for(i=0;i<self.CurrentWeapons.size;i++) // give player some ammo if they have none
	{
		self.AmmoAmmount = self GetAmmoCount(self.CurrentWeapons[i]);
		if(self.AmmoAmmount == 0)
		{
			self SetWeaponAmmoClip(self.CurrentWeapons[i],1);
		}
		wait 0.05;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// Bonus Points ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


BonusPoints(power_up_name)
{
	self thread bonuspointshud(power_up_name);
	if(!self maps\_laststand::player_is_in_laststand() && self.sessionstate != "spectator")
	{
		players = getPlayers();
		for(i=0;i<players.size;i++)
		{
			if(players[i] == self)
			{
				setClientSysState( "levelNotify", "ann_bonuspoints", players[i] );
			}
		}
		PointsToGive = level.BonusPointsAmount * RandomIntRange(level.BonusPointsMinMultiplier,level.BonusPointsMaxMultiplier);
		self maps\_zombiemode_score::add_to_player_score( PointsToGive ); 
	}
}

bonuspointshud(power_up_name)
{
	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );
	wait 3;
	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// Fire Sale //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


FireSale(power_up_name)
{
	if(isDefined(level.firesale) && level.firesale == 1)
	{
		level.zombie_vars["zombie_powerup_firesale_time"] = level.FireSaleTime;
		return;
	}

	level.zombie_vars["zombie_powerup_firesale_on"] = 1;
	level notify("zombie_powerup_timer");

	level.firesale = 1;
	level.zombie_treasure_chest_cost = 10;

	level.chests thread maps\_zombiemode_weapons::treasure_chest_think();

	level thread maps\_zombiemode_powerups::play_devil_dialog("ann_firesale");

	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );

	if(level.chests.size == 1)
	{
		level.chests[0] SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 10]" );
		level.chests[0].isFireSaleBox = 1;
		level.chests[0] notify("fire_sale");
		if(!isdefined(level.chests[0].sound_player))
		{
			level.chests[0].sound_player = Spawn("script_origin",level.chests[0].origin);
		}
		level.chests[0].sound_player PlayLoopSound("numan_firesale");
	}
	else
	{
		for(i=0;i<level.chests.size;i++) // first loop - show loop
		{
			if(!isdefined(level.chests[i].boxisinuse) || level.chests[i].boxisinuse == 0)
			{
				level.chests[i] SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 10]" );
			}
			level.chests[i].isFireSaleBox = 1;
			level.chests[i] notify("fire_sale");

			if(level.chests[i] != level.chests[level.chest_index])
			{
				level.chests[i] SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 10]" );
				level thread maps\_zombiemode_weapons::unhide_magic_box( i );
				level.chests[i] thread maps\_zombiemode_weapons::show_magic_box();
			}
			if(!isdefined(level.chests[i].sound_player))
			{
				level.chests[i].sound_player = Spawn("script_origin",level.chests[i].origin);
			}
			level.chests[i].sound_player PlayLoopSound("numan_firesale");
			wait 0.05;
		}
	}

	level.zombie_vars["zombie_powerup_firesale_time"] = level.FireSaleTime;
	while(level.zombie_vars["zombie_powerup_firesale_time"] > 0)
	{
		level.zombie_vars["zombie_powerup_firesale_time"]--;
		wait 1;
	}

	if(level.chests.size == 1)
	{
		level.chests[0] SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 950]" );
		level.chests[0].isFireSaleBox = 0;
		level.chests[0].sound_player StopLoopSound();
		level.chests[0].sound_player Delete();
	}
	else
	{
		for(i=0;i<level.chests.size;i++) // second loop - hide loop
		{
			if(isDefined(level.chests[i].boxisinuse) && level.chests[i].boxisinuse == 1 && level.chests[i] != level.chests[level.chest_index])
			{
				level.chests[i] thread Check_For_Box_Use();
			}
			else if(level.chests[i] != level.chests[level.chest_index])
			{
				level.chests[i] thread firesale_hide_chest();
			}
			else if(level.chests[i] == level.chests[level.chest_index])
			{
				level.chests[i] SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 950]" );
				level.chests[i].isFireSaleBox = 0;
			}
			level.chests[i].sound_player StopLoopSound();
			level.chests[i].sound_player Delete();
			wait 0.05;
		}
	}
	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );
	level.zombie_treasure_chest_cost = 950;
	level.firesale = 0;
	level.zombie_vars["zombie_powerup_firesale_on"] = 0;
	level notify("zombie_powerup_timer");
}

firesale_hide_chest()
{
	self SetHintString( "Appuyez sur &&1 pour obtenir une arme aléatoire [Coût : 950]" );
	PlaySoundAtPosition( "box_poof", self.origin );
	playfx( level._effect["poltergeist"],self.origin);
	self.isFireSaleBox = 0;
	self thread maps\_zombiemode_weapons::hide_chest();
	self thread box_show_rubble();
}

Check_For_Box_Use()
{
	self endon("fire_sale");

	self waittill_any("user_grabbed_weapon","weapon_timed_out");
	if(isdefined(self.timedout) && self.timedout)
	{
		wait 1;
		self firesale_hide_chest();
	}
	wait 1;
	self firesale_hide_chest();

}

box_show_rubble()
{
	rubble = getentarray(self.script_noteworthy + "_rubble", "script_noteworthy");
	
	if ( IsDefined( rubble ) )
	{
		for (i = 0; i < rubble.size; i++)
		{
			rubble[i] show();
		}
	}
	else
	{
		println( "^3Warning: No rubble found for magic box" );
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// Minigun ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


MiniGun(power_up_name)
{
	if(self maps\_laststand::player_is_in_laststand())
	{
		return;
	}

	if(isDefined(self.UsingMinigun) && self.UsingMinigun == 1)
	{
		self.MinigunTimer = level.MinigunTime;
		return;
	}

	self.is_drinking = 1;
	self.UsingMinigun = 1;

	players = getPlayers();
	for(i=0;i<players.size;i++)
	{
		if(players[i] == self)
		{
			setClientSysState( "levelNotify", "ann_minigun", players[i] );
		}
	}

	self.MinigunTimer = level.MinigunTime;
	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );

	self.hasminigunweapon = 0;
	prev_weapon = self GetCurrentWeapon();

	self DisableOffhandWeapons();
	self DisableWeaponCycling();
	self GiveWeapon(level.MinigunWeapon);
	self SwitchToWeapon(level.MinigunWeapon);

	wait 0.55;

	self.minigun_sound_player = undefined;
	if(isdefined(level.MinigunWeapon) && level.MinigunWeapon == "minigun_zm")
	{
		self PlaySound("wpn_minigun_start_plr");
		self Attach("t5_weapon_carry_minigun_world","tag_weapon_right");
		self.minigun_sound_player = Spawn("script_origin",self.origin);
		self.minigun_sound_player LinkTo(self,self GetTagOrigin("tag_weapon_right"));
		self.minigun_sound_player PlayLoopSound("wpn_minigun_loop_plr");
	}

	wait 1;

	self EnableWeaponCycling();
	self.currweapon = level.MinigunWeapon;

	while(self.MinigunTimer >= 1 && self.currweapon == level.MinigunWeapon)
	{
		if(self maps\_laststand::player_is_in_laststand())
		{
			break;
		}
		self.currweapon = self GetCurrentWeapon();
		if(self.currweapon != level.MinigunWeapon)
		{
			break;
		}
		self.MinigunTimer = self.MinigunTimer - 0.1;
		wait 0.1;
	}

	self.is_drinking = undefined;

	if(isdefined(level.MinigunWeapon) && level.MinigunWeapon == "minigun_zm")
	{
		self.minigun_sound_player StopLoopSound(2);
		self.minigun_sound_player Delete();
		self Detach("t5_weapon_carry_minigun_world","tag_weapon_right");
	}

	self.currweapon = self GetCurrentWeapon();
	self.MinigunTimer = 0;
	self.UsingMinigun = 0;
	self.minigun_shader.alpha = 0;

	if(	self.currweapon == "zombie_perk_bottle_doubletap" ||
		self.currweapon == "zombie_perk_bottle_jugg" ||
		self.currweapon == "zombie_perk_bottle_revive" ||
		self.currweapon == "zombie_perk_bottle_sleight" ||
		self.currweapon == "zombie_knuckle_crack" ||
		self.currweapon == "syrette" )
	{
		self DisableWeaponCycling();
		self waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
		self EnableWeaponCycling();
	}

	self EnableOffhandWeapons();

	if(self maps\_laststand::player_is_in_laststand())
	{
		self waittill("player_revived");
		self TakeWeapon(level.MinigunWeapon);
	}

	self TakeWeapon(level.MinigunWeapon);

	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );

	self SwitchToWeapon(prev_weapon);
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// Random Weapon //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Random_Gun(struct)
{
	if( self maps\_laststand::player_is_in_laststand() )
	{
		return;
	}

	if(isdefined(self.UsingMinigun) && self.UsingMinigun)
	{
		return;
	}

	self.currentgun = self GetCurrentWeapon();
	if(	self.currentgun == "zombie_perk_bottle_doubletap" ||
		self.currentgun == "zombie_perk_bottle_jugg" ||
		self.currentgun == "zombie_perk_bottle_revive" ||
		self.currentgun == "zombie_perk_bottle_sleight" ||
		self.currentgun == "zombie_knuckle_crack" ||
		self.currentgun == "syrette" )
	{
		return;
	}
	newweapon = level.magicweapons[RandomInt(level.magicweapons.size)];
	if(isDefined(struct))
	{
		newweapon = struct.randomweapon;
	}
	playerweapons = self GetWeaponsListPrimaries();
	if(self maps\_zombiemode_weapons::has_upgrade( newweapon ) || self HasWeapon(newweapon))
	{
		return;
	}
	if(playerweapons.size >= 2 && WeaponType(newweapon) != "grenade") // must provide support for gympies mule kick
	{
		self DisableWeaponCycling();
		self TakeWeapon(self.currentgun);
	}
	players = getPlayers();
		for(i=0;i<players.size;i++)
		{
			if(players[i] == self)
			{
				setClientSysState( "levelNotify", "ann_randomgun", players[i] );
			}
		}
	self GiveWeapon(newweapon);
	if(WeaponType(newweapon) != "grenade")
	{
		self SwitchToWeapon(newweapon);
	}
	self EnableWeaponCycling();
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// Zombie Blood ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Zombie_Blood(power_up_name)
{
	if(self maps\_laststand::player_is_in_laststand())
	{
		return;
	}
	if(isDefined(self.UsingZombieBlood) && self.UsingZombieBlood == 1)
	{
		self.ZombieBloodTimer = level.ZombieBloodTime;
		return;
	}

	self PlaySound("zombie_blood_start");

	self thread maps\_zombiemode_powerups::CreatePowerUpHud( power_up_name );

	self.zombieblood_sound_player = Spawn("script_origin",self.origin);
	self.zombieblood_sound_player LinkTo(self,self GetTagOrigin("tag_origin"));
	self.zombieblood_sound_player PlayLoopSound("zombie_blood_loop");

	setClientSysState("lsm", "1", self);
	setClientSysState( "levelNotify", "ann_zombieblood", self );
	self VisionSetNaked("zombie_blood",1);
	self thread fov_waiter();

	self.ignoreme = 1;
	self.UsingZombieBlood = 1;
	self thread level_blood_counter();
	self.ZombieBloodTimer = level.ZombieBloodTime;
	while(self.ZombieBloodTimer >= 1)
	{
		if(self maps\_laststand::player_is_in_laststand() || self.sessionstate == "spectator")
		{
			break;
		}
		self.ZombieBloodTimer = self.ZombieBloodTimer - 0.1;
		wait 0.1;
	}

	self PlaySound("zombie_blood_end");
	self thread maps\_zombiemode_powerups::RemovePowerUpHud( power_up_name );
	wait 0.5;
	self.zombieblood_sound_player StopLoopSound(2);

	setClientSysState("lsm", "0", self);
	self VisionSetNaked(level.zombievisionfile,1);
	self setClientDvar("cg_fov",level.normalfov);
	if(!self maps\_laststand::player_is_in_laststand())
	{
		self.ignoreme = 0;
	}
	self.zombieblood_shader.alpha = 0;
	self.UsingZombieBlood = 0;
	self thread level_blood_counter();
}

fov_waiter()
{
	wait 0.2;
	self setClientDvar("cg_fov",level.normalfov + 15);
}

level_blood_counter()
{
	level.num_using_zombieblood = 0;
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if(isdefined(players[i].UsingZombieBlood) && players[i].UsingZombieBlood)
		{
			level.num_using_zombieblood++;
		}
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////// MISC ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


HudElementMaker(perktext)
{
	hudelemn = maps\_hud_util::createFontString( "objective", 2, self );
	hudelemn maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelemn.sort = 0.5;
	hudelemn.alpha = 0;
	hudelemn fadeovertime(0.5);
	hudelemn.alpha = 1;
	hudelemn.label = perktext;

	wait 0.5;
	move_fade_time = 1.5;

	hudelemn FadeOverTime( move_fade_time ); 
	hudelemn MoveOverTime( move_fade_time );
	hudelemn.y = 270;
	hudelemn.alpha = 0;

	wait move_fade_time;

	hudelemn destroy();
}

numan_shader_hud()
{
	self.minigun_shader = create_simple_hud(self);
	self.minigun_shader.foreground = true; 
	self.minigun_shader.sort = 4; 
	self.minigun_shader.hidewheninmenu = false; 
	self.minigun_shader.alignX = "center"; 
	self.minigun_shader.alignY = "bottom";
	self.minigun_shader.horzAlign = "center"; 
	self.minigun_shader.vertAlign = "bottom";
	self.minigun_shader.x = -24;
	self.minigun_shader.y = -70; 
	self.minigun_shader.alpha = 0;
	self.minigun_shader MoveOverTime( 0.05 );
	self.minigun_shader FadeOverTime( 0.05 );
	self.minigun_shader setshader("specialty_minigun_zombies", 32, 32);

	self.zombieblood_shader = create_simple_hud(self);
	self.zombieblood_shader.foreground = true; 
	self.zombieblood_shader.sort = 4; 
	self.zombieblood_shader.hidewheninmenu = false; 
	self.zombieblood_shader.alignX = "center"; 
	self.zombieblood_shader.alignY = "bottom";
	self.zombieblood_shader.horzAlign = "center"; 
	self.zombieblood_shader.vertAlign = "bottom";
	self.zombieblood_shader.x = 24;
	self.zombieblood_shader.y = -70;
	self.zombieblood_shader.alpha = 0;
	self.zombieblood_shader MoveOverTime( 0.05 );
	self.zombieblood_shader FadeOverTime( 0.05 );
	self.zombieblood_shader setshader("specialty_zombie_blood", 32, 32);
}

Death_Watcher()
{
	while(1)
	{
		self waittill_any("death","player_downed","fake_death");
		self TakeWeapon(level.MinigunWeapon);
		self.perknum = undefined;
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////