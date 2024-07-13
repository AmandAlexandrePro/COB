#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init()
{
	PrecacheShader( "specialty_nuke_zombies" );
	PrecacheShader( "specialty_doublepoints_zombies" );
	PrecacheShader( "specialty_instakill_zombies" );
	PrecacheShader( "specialty_full_ammo_zombies" );
	PrecacheShader( "specialty_carpenter_zombies" );
	PrecacheShader( "specialty_randomperk_zombies" );
	PrecacheShader( "specialty_unlimitedammo" );
	PrecacheShader( "specialty_bonus_points_zombies" );
	PrecacheShader( "specialty_firesale_zombies" );
	PrecacheShader( "zom_icon_bullets" );
	PrecacheShader( "specialty_zombie_blood" ); // NO CW zombie_blood
	// NO upgrade_weap
	// NO randomgun

	level thread maps\_numan_powerups::Powerup_Setup();


	
	PrecacheShader( "black" ); 
	// powerup Vars
	set_zombie_var( "zombie_insta_kill", 				0 );
	set_zombie_var( "zombie_point_scalar", 				1 );
	set_zombie_var( "zombie_drop_item", 				0 );
	set_zombie_var( "zombie_timer_offset", 				350 );	// hud offsets
	set_zombie_var( "zombie_timer_offset_interval", 	30 );
	set_zombie_var( "zombie_powerup_insta_kill_on", 	false );
	set_zombie_var( "zombie_powerup_point_doubler_on", 	false );
	set_zombie_var( "zombie_powerup_point_doubler_time", 30 );	// length of point doubler
	set_zombie_var( "zombie_powerup_insta_kill_time", 	30 );	// length of insta kill
	set_zombie_var( "zombie_powerup_drop_increment", 	2000 );	// lower this to make drop happen more often
	set_zombie_var( "zombie_powerup_drop_max_per_round", 5 );	// lower this to make drop happen more often

	// powerups
	level.putimer = [];
	level.putimer["dptimeremaining"] = 1;
	level._effect["powerup_on"] 				= loadfx( "misc/fx_zombie_powerup_on" );
	level._effect["powerup_grabbed"] 			= loadfx( "misc/fx_zombie_powerup_grab" );
	level._effect["powerup_grabbed_wave"] 		= loadfx( "misc/fx_zombie_powerup_wave" );
	level._effect["powerup_on_solo"] 				= loadfx( "misc/fx_zombie_powerup_on_solo" );
	level._effect["powerup_grabbed_solo"] 			= loadfx( "misc/fx_zombie_powerup_grab_solo" );
	level._effect["powerup_grabbed_wave_solo"] 		= loadfx( "misc/fx_zombie_powerup_wave_solo" );

	init_powerups();

	thread watch_for_drop();
}

init_powerups()
{
	if( !IsDefined( level.zombie_powerup_array ) )
	{
		level.zombie_powerup_array = [];
	}
	if ( !IsDefined( level.zombie_special_drop_array ) )
	{
		level.zombie_special_drop_array = [];
	}

	// Random Drops
	//add_zombie_powerup( "nuke", 		"zombie_bomb",		&"ZOMBIE_POWERUP_NUKE", 			"misc/fx_zombie_mini_nuke" );
//	add_zombie_powerup( "nuke", 		"zombie_bomb",		&"ZOMBIE_POWERUP_NUKE", 			"misc/fx_zombie_mini_nuke_hotness" );
	//add_zombie_powerup( "insta_kill", 	"zombie_skull",		&"ZOMBIE_POWERUP_INSTA_KILL" );
	//add_zombie_powerup( "double_points","zombie_x2_icon",	&"ZOMBIE_POWERUP_DOUBLE_POINTS" );
	//add_zombie_powerup( "full_ammo",  	"zombie_ammocan",	&"ZOMBIE_POWERUP_MAX_AMMO");
	//add_zombie_powerup( "carpenter",  	"zombie_carpenter",	&"ZOMBIE_POWERUP_MAX_AMMO");

	// Default Powerups
	if(level.enableNuke == 1)
	{
		add_zombie_powerup( "nuke","zombie_bomb",&"ZOMBIE_POWERUP_NUKE","misc/fx_zombie_mini_nuke","specialty_nuke_zombies" );
	}

	if(level.enableInstaKill == 1)
	{
		add_zombie_powerup( "insta_kill","zombie_skull",&"ZOMBIE_POWERUP_INSTA_KILL",undefined, "specialty_instakill_zombies", "zombie_powerup_insta_kill_time" );
	}

	if(level.enableDoublePoints == 1)
	{
		add_zombie_powerup( "double_points","zombie_x2_icon",&"ZOMBIE_POWERUP_DOUBLE_POINTS",undefined, "specialty_doublepoints_zombies", "zombie_powerup_point_doubler_time" );
	}

	if(level.enableMaxAmmo == 1)
	{
		add_zombie_powerup( "full_ammo","zombie_ammocan",&"ZOMBIE_POWERUP_MAX_AMMO",undefined,"specialty_full_ammo_zombies");
	}

	if(level.enableCarpenter == 1)
	{
		add_zombie_powerup( "carpenter","zombie_carpenter",&"ZOMBIE_POWERUP_MAX_AMMO",undefined,"specialty_carpenter_zombies");
	}

	// Numan Powerups
	if(level.enableRandomPerk == 1)
	{
		add_zombie_powerup( "randomperk","zombie_pickup_perkbottle","Atout aléatoire",undefined,"specialty_randomperk_zombies" );
	}

	if(level.enableUpgradeWeapon == 1)
	{
		add_zombie_powerup( "upgrade_weap","zombie_pickup_bonfire","Amélioration d'arme" );
	}

	if(level.enableUnlimitedAmmo == 1)
	{
		add_zombie_powerup( "unlimited_ammo","zombie_pickup_unlimitedammo","Munitions illimitées",undefined,"specialty_unlimitedammo" );
	}

	if(level.enableBonusPoints == 1)
	{
		add_zombie_powerup( "bonus_points","zombie_pickup_money","Points bonus",undefined,"specialty_bonus_points_zombies" );
	}

	if(level.enableFireSale == 1)
	{
		add_zombie_powerup( "firesale","zombie_pickup_firesale","Braderie",undefined,"specialty_firesale_zombies","zombie_powerup_firesale_time" );
	}

	if(level.enableMinigun == 1)
	{
		add_zombie_powerup( "minigun","zombie_pickup_minigun","Minigun",undefined,"zom_icon_bullets","zombie_powerup_minigun_time" );
	}

	if(level.enableRevivePlayers == 1)
	{
		add_zombie_powerup( "reviveallplayers","zombie_pickup_revive","Réanimation de tous les joueurs");
	}

	if(level.enableRandomGun == 1)
	{
		add_zombie_powerup( "randomgun","zombie_randomgun","Arme aléatoire");
	}

	if(level.enableZombieBlood == 1)
	{
		add_zombie_powerup( "zombie_blood","zombie_pickup_zombieblood","Sang de zombie",undefined,"specialty_zombie_blood");
	}

	//	add_zombie_special_powerup( "monkey" );

	// additional special "drops"
//	add_zombie_special_drop( "nothing" );
	add_zombie_special_drop( "dog" );

	// Randomize the order
	randomize_powerups();

	level.zombie_powerup_index = 0;
	randomize_powerups();

	//level thread powerup_hud_overlay();
}  

/*powerup_hud_overlay()
{

	level.powerup_hud_array = [];
	level.powerup_hud_array[0] = true;
	level.powerup_hud_array[1] = true;

	level.powerup_hud = [];
	level.powerup_hud_cover = [];
	level endon ("disconnect");


	for(i = 0; i < 2; i++)
	{
		level.powerup_hud[i] = create_simple_hud();
		level.powerup_hud[i].foreground = true; 
		level.powerup_hud[i].sort = 2; 
		level.powerup_hud[i].hidewheninmenu = false; 
		level.powerup_hud[i].alignX = "center"; 
		level.powerup_hud[i].alignY = "bottom";
		level.powerup_hud[i].horzAlign = "center"; 
		level.powerup_hud[i].vertAlign = "bottom";
		level.powerup_hud[i].x = -32 + (i * 15); 
		level.powerup_hud[i].y = level.powerup_hud[i].y - 35; 
		level.powerup_hud[i].alpha = 0.8;
		//hud SetShader( shader_inst, 24, 24 );
	}

	shader_2x = "specialty_doublepoints_zombies";
	shader_insta = "specialty_instakill_zombies";
//	shader_white = "black";
	



	//for(i = 0; i < 2; i++)
	//{
	//	level.powerup_hud_cover[i] = create_simple_hud();
	//	level.powerup_hud_cover[i].foreground = true; 
	//	level.powerup_hud_cover[i].sort = 1; 
	//	level.powerup_hud_cover[i].hidewheninmenu = false; 
	//	level.powerup_hud_cover[i].alignX = "center"; 
	//	level.powerup_hud_cover[i].alignY = "bottom";
	//	level.powerup_hud_cover[i].horzAlign = "center"; 
	//	level.powerup_hud_cover[i].vertAlign = "bottom";
	//	level.powerup_hud_cover[i].x = -32 + (i * 34); 
	//	level.powerup_hud_cover[i].y = level.powerup_hud_cover[i].y - 30; 
	//	level.powerup_hud_cover[i].alpha = 1;
	//	//hud SetShader( shader_inst, 24, 24 );
	//}



	//increment = 0;
	

	while(true)
	{
		if(level.zombie_vars["zombie_powerup_insta_kill_time"] < 5)
		{
			wait(0.1);		
			level.powerup_hud[1].alpha = 0;
			wait(0.1);
			

		}
		else if(level.zombie_vars["zombie_powerup_insta_kill_time"] < 10)
		{
			wait(0.2);
			level.powerup_hud[1].alpha = 0;
			wait(0.18);
			
		}
		
		if(level.zombie_vars["zombie_powerup_point_doubler_time"] < 5)
		{
			wait(0.1);	
			level.powerup_hud[0].alpha = 0;
			wait(0.1);
			

		}
		else if(level.zombie_vars["zombie_powerup_point_doubler_time"] < 10)
		{
			wait(0.2);
			level.powerup_hud[0].alpha = 0;
			wait(0.18);
		}
		

		//if(level.zombie_vars["zombie_powerup_insta_kill_time"] != 0)
		//	iprintlnbold(level.zombie_vars["zombie_powerup_insta_kill_time"]);

		//if(level.zombie_vars["zombie_powerup_point_doubler_time"] != 0)
		//	iprintlnbold(level.zombie_vars["zombie_powerup_point_doubler_time"]);


		//wait(0.01);
		
		if(level.zombie_vars["zombie_powerup_point_doubler_on"] == true && level.zombie_vars["zombie_powerup_insta_kill_on"] == true)
		{

			level.powerup_hud[0].x = -24;
			level.powerup_hud[1].x = 24;
			level.powerup_hud[0].alpha = 1;
			level.powerup_hud[1].alpha = 1;
			level.powerup_hud[0] setshader(shader_2x, 32, 32);
			level.powerup_hud[1] setshader(shader_insta, 32, 32);
			/*level.powerup_hud_cover[0].x = -36;
			level.powerup_hud_cover[1].x = 36;
			level.powerup_hud_cover[0] setshader(shader_white, 32, i);
			level.powerup_hud_cover[1] setshader(shader_white, 32, j);
			level.powerup_hud_cover[0].alpha = 1;
			level.powerup_hud_cover[1].alpha = 1;*/
		/*
		}
		else if(level.zombie_vars["zombie_powerup_point_doubler_on"] == true && level.zombie_vars["zombie_powerup_insta_kill_on"] == false)
		{
			level.powerup_hud[0].x = 0; 
			//level.powerup_hud[0].y = level.powerup_hud[0].y - 70; 
			level.powerup_hud[0] setshader(shader_2x, 32, 32);
			level.powerup_hud[1].alpha = 0;
			level.powerup_hud[0].alpha = 1;

		}
		else if(level.zombie_vars["zombie_powerup_insta_kill_on"] == true && level.zombie_vars["zombie_powerup_point_doubler_on"] == false)
		{

			level.powerup_hud[1].x = 0; 
			//level.powerup_hud[1].y = level.powerup_hud[1].y - 70; 
			level.powerup_hud[1] setshader(shader_insta, 32, 32);
			level.powerup_hud[0].alpha = 0;
			level.powerup_hud[1].alpha = 1;
		}
		else
		{
			
			level.powerup_hud[1].alpha = 0;
			level.powerup_hud[0].alpha = 0;

		}

		wait(0.01);


	
		//increment += 1;

		//if(increment >= 20)
		//{
		//	level.powerup_hud[0].alpha = 0;
		//	level.powerup_hud[1].alpha = 0;
		////	level.powerup_hud_cover[0].alpha = 0;
		////	level.powerup_hud_cover[1].alpha = 0;
		//}
		//
		//if(increment == 30)
		//{

		//	level.powerup_hud_array[1] = false;
		//	level.powerup_hud_array[0] = false;

		//}
		//wait(0.5);

		




	/*	if(randomint(100) > 50)
			level.powerup_hud_array[0] = false;
		else 
			level.powerup_hud_array[0] = true;
	

		if(randomint(100) > 50)
			level.powerup_hud_array[1] = false;
		else
			level.powerup_hud_array[1] = true;*/
	/*
	}


	

	//for(i = 0; i < 2; i++)
	//{
	//	level.powerup_hud_cover[i] = create_simple_hud();
	//	level.powerup_hud_cover[i].foreground = true; 
	//	level.powerup_hud_cover[i].sort = 1; 
	//	level.powerup_hud_cover[i].hidewheninmenu = false; 
	//	level.powerup_hud_cover[i].alignX = "center"; 
	//	level.powerup_hud_cover[i].alignY = "bottom";
	//	level.powerup_hud_cover[i].horzAlign = "center"; 
	//	level.powerup_hud_cover[i].vertAlign = "bottom";
	//	level.powerup_hud_cover[i].x = -32 + (i * 34); 
	//	level.powerup_hud_cover[i].y = level.powerup_hud_cover[i].y - 79; 
	//	level.powerup_hud_cover[i].alpha = 0.5;
	//	//hud SetShader( shader_inst, 24, 24 );
	//}


	//while(true)
	//{
	//	/*	for(i = 0; i < 2; i++)
	//	{
	//	level.powerup_hud[i].y = level.powerup_hud[i].y - 5;

	//	}*/
/*



	//	wait(1);
	//}

}*/

RemovePowerUpHud( powerup_name )
{
	for(i = 0; i < self.powerup_hud.size ; i++)
	{
		if(IsDefined(self.powerup_hud[i].powerup_name) && self.powerup_hud[i].powerup_name == powerup_name)
		{
			self.hud_is_being_deleted = true;
			self.powerup_hud[i] notify("hud_gone");
			// IPrintLnBold(self.powerup_hud[i].powerup_name ); // Debug Purposes
			self.powerup_hud[i].alpha = 1;
			wait 0.1;
			self.powerup_hud[i] FadeOverTime(0.5);
			self.powerup_hud[i].alpha = 0;
			wait 0.6;
			self.powerup_hud[i] destroy_hud();
			self.powerup_hud[i] Delete();
			self.powerup_hud = array_remove(self.powerup_hud, self.powerup_hud[i]);
			self.current_powerups = array_remove(self.current_powerups, self.current_powerups[powerup_name]);
			self.hud_is_being_deleted = false;
		}
	}
 
	for(i = 0; i < self.powerup_hud.size ; i++)
		self.powerup_hud[i] thread MoveThyHUD(i, self.powerup_hud.size);
}

CreatePowerUpHud( powerup )
{
	if(IsDefined(self.current_powerups))
		self.current_powerups = [];
	if(!IsDefined( self.powerup_hud))
		self.powerup_hud = [];
 
	while(IsDefined(self.current_powerups[powerup])) // Check because from testing if the player is fast enough (Though very rare for it to happen), 2 elements can spawn for same HUD.
		wait 0.05;
 
	self.current_powerups[powerup] = create_simple_hud( self ); // Made Client HUD so we modify per player for things like Minigun, etc.
	self.current_powerups[powerup].timer = 10; 
	self.current_powerups[powerup].powerup_name = powerup;
	self.current_powerups[powerup].foreground = true; 
	self.current_powerups[powerup].sort = 2;
	self.current_powerups[powerup].hidewheninmenu = false; 
	self.current_powerups[powerup].alignX = "center";
	self.current_powerups[powerup].alignY = "bottom";
	self.current_powerups[powerup].horzAlign = "center"; 
	self.current_powerups[powerup].vertAlign = "bottom";
	self.current_powerups[powerup].x = self.current_powerups[powerup].x; 
	self.current_powerups[powerup].y = self.current_powerups[powerup].y - 35; 
	self.current_powerups[powerup].alpha = 0;
	self.current_powerups[powerup] setshader(level.zombie_powerups[powerup].shader, 48, 48);
	self.current_powerups[powerup] scaleOverTime( .3, 32, 32 );
	self.current_powerups[powerup] FadeOverTime(0.3);
	self.current_powerups[powerup].alpha = 1;
	self.current_powerups[powerup] thread LowTimeFade(self);
 
	self.powerup_hud[self.powerup_hud.size] = self.current_powerups[powerup];
 
	for(i = 0; i < self.powerup_hud.size ; i++)
		self.powerup_hud[i] thread MoveThyHUD(i, self.powerup_hud.size);
}
 
LowTimeFade(player)
{
	self endon("hud_gone");
	while(IsDefined(self))
	{
		if (self.powerup_name == "minigun" && player.MinigunTimer > 0)
		{
			self.timer = player.MinigunTimer;
		}
		else if (self.powerup_name == "zombie_blood" && player.ZombieBloodTimer > 0)
		{
			self.timer = player.ZombieBloodTimer;
		}
		else
		{
			self.timer = level.zombie_vars[level.zombie_powerups[self.powerup_name].timer];
		}
		if(!isNumber(self.timer))
		{
			wait 0.1;
			continue;
		}
		else if(self.timer < 5)
		{
			fade_time = 0.2;
		}
		else if(self.timer < 10)
		{
			fade_time = 0.6;
		}
		else
		{
			wait 0.1;
			continue;
		}
 
		self FadeOverTime(fade_time);
		self.alpha = 0.1;
		wait fade_time;
		self FadeOverTime(fade_time);
		self.alpha = 1;
		wait fade_time;
 
	}
}
 
MoveThyHUD(i, array_size) // Mjáá
{
	self MoveOverTime(0.5);
	self.x = (24 + (-24 * array_size + (i * 48))); // Jáám
	self.y = self.y;
}

randomize_powerups()
{
	level.zombie_powerup_array = array_randomize( level.zombie_powerup_array );
}

check_next_powerup(powerup)
{
	if( !isDefined(level.NewPowerUp) || level.zombie_powerup_index >= level.NewPowerUp.size )
	{
		level.zombie_powerup_index = 0;
		randomize_powerups();
		level.NewPowerUp = [];
		level.NewPowerUp = level.zombie_powerup_array;
	}

	deadplayers = false;
	perksplayers = 0;
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		player = players[i];
		if(!isdefined(player.perknum) || player.perknum <= 0)
		{
			player maps\_numan_powerups::resetperkdefs();
		}
		else if(player.perknum == player.perkarray.size)
		{
			perksplayers++;
		}
		if(!maps\_zombiemode_utility::is_player_valid( player ))
		{
			deadplayers = true;
		}
	}

	if( is_in_array(level.NewPowerUp,"randomperk") && perksplayers == players.size )
	{
		level.NewPowerUp = array_remove(level.NewPowerUp,"randomperk");
		return check_next_powerup(level.NewPowerUp[randomint(level.NewPowerUp.size)]);
	}

	if( is_in_array(level.NewPowerUp,"reviveallplayers") && players.size == 1 || !deadplayers )
	{
		level.NewPowerUp = array_remove(level.NewPowerUp,"reviveallplayers");
		return check_next_powerup(level.NewPowerUp[randomint(level.NewPowerUp.size)]);
	}

	if(is_in_array(level.NewPowerUp,"firesale") && (!isDefined(level.fire_sale_allowed) || !level.fire_sale_allowed) && level.chests.size > 1)
	{
		level.NewPowerUp = array_remove(level.NewPowerUp,"firesale");
		return check_next_powerup(level.NewPowerUp[randomint(level.NewPowerUp.size)]);
	}

	if(players.size > 1 && deadplayers && isdefined(level.enableRevivePlayers) && level.enableRevivePlayers)
	{
		randomchance = RandomInt(100);
		if(randomchance > level.RevivePlayersChance)
		{
			powerup = "reviveallplayers";
		}
	}

	return powerup;
}

get_next_powerup()
{
	level.NewPowerUp = [];
	level.NewPowerUp = level.zombie_powerup_array;

	//powerup = level.zombie_powerup_array[level.zombie_powerup_index];

	powerup = check_next_powerup(level.NewPowerUp[level.zombie_powerup_index]);

	/#
		if( isdefined( level.zombie_devgui_power ) && level.zombie_devgui_power == 1 )
			return powerup;

	#/

	//level.windows_destroyed = get_num_window_destroyed();

	while( powerup == "carpenter" && get_num_window_destroyed() < 5)
	{	
		
		
		/*if( level.zombie_powerup_index >= level.zombie_powerup_array.size )
		{
			level.zombie_powerup_index = 0;
			randomize_powerups();
		}*/
		
		powerup = check_next_powerup(level.zombie_powerup_array[level.zombie_powerup_index]);
		level.zombie_powerup_index++;
			
		if( powerup != "carpenter" )
			return powerup;
		
		wait(0.05);
	}

	level.zombie_powerup_index++;

	return powerup;
}

get_num_window_destroyed()
{
	num = 0;
	for( i = 0; i < level.exterior_goals.size; i++ )
	{
		/*targets = getentarray(level.exterior_goals[i].target, "targetname");

		barrier_chunks = []; 
		for( j = 0; j < targets.size; j++ )
		{
			if( IsDefined( targets[j].script_noteworthy ) )
			{
				if( targets[j].script_noteworthy == "clip" )
				{ 
					continue; 
				}
			}

			barrier_chunks[barrier_chunks.size] = targets[j];
		}*/


		if( all_chunks_destroyed( level.exterior_goals[i].barrier_chunks ) )
		{
			num += 1;
		}

	}

	return num;
}

watch_for_drop()
{
	players = get_players();
	score_to_drop = ( players.size * level.zombie_vars["zombie_score_start"] ) + level.zombie_vars["zombie_powerup_drop_increment"];

	while (1)
	{
		players = get_players();

		curr_total_score = 0;

		for (i = 0; i < players.size; i++)
		{
			curr_total_score += players[i].score_total;
		}

		if (curr_total_score > score_to_drop )
		{
			level.zombie_vars["zombie_powerup_drop_increment"] *= 1.14;
			score_to_drop = curr_total_score + level.zombie_vars["zombie_powerup_drop_increment"];
			level.zombie_vars["zombie_drop_item"] = 1;
		}

		wait( 0.5 );
	}
}

add_zombie_powerup( powerup_name, model_name, hint, fx, shader, timer_var )
{
	if( IsDefined( level.zombie_include_powerups ) && !IsDefined( level.zombie_include_powerups[powerup_name] ) )
	{
		return;
	}

	PrecacheModel( model_name );
	PrecacheString( hint );

	struct = SpawnStruct();

	if( !IsDefined( level.zombie_powerups ) )
	{
		level.zombie_powerups = [];
	}

	struct.powerup_name = powerup_name;
	struct.model_name = model_name;
	struct.weapon_classname = "script_model";
	struct.hint = hint;
	if(IsDefined(shader))
		struct.shader = shader;
	if(IsDefined(timer_var))
		struct.timer = timer_var;

	if( IsDefined( fx ) )
	{
		struct.fx = LoadFx( fx );
	}

	level.zombie_powerups[powerup_name] = struct;
	level.zombie_powerup_array[level.zombie_powerup_array.size] = powerup_name;
	add_zombie_special_drop( powerup_name );
}


// special powerup list for the teleporter drop
add_zombie_special_drop( powerup_name )
{
	level.zombie_special_drop_array[ level.zombie_special_drop_array.size ] = powerup_name;
}

include_zombie_powerup( powerup_name )
{
	if( !IsDefined( level.zombie_include_powerups ) )
	{
		level.zombie_include_powerups = [];
	}

	level.zombie_include_powerups[powerup_name] = true;
}

powerup_round_start()
{
	level.powerup_drop_count = 0;
}

powerup_drop(drop_point)
{
	rand_drop = randomint(100);

	if( level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"] )
	{
		println( "^3POWERUP DROP EXCEEDED THE MAX PER ROUND!" );
		return;
	}
	
	if( !isDefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0 )
	{
		return;
	}

	// some guys randomly drop, but most of the time they check for the drop flag
	if (rand_drop > 2)
	{
		if (!level.zombie_vars["zombie_drop_item"])
		{
			return;
		}

		debug = "score";
	}
	else
	{
		debug = "random";
	}	

	// never drop unless in the playable area
	playable_area = getentarray("playable_area","targetname");

	powerup = maps\_zombiemode_net::network_safe_spawn( "powerup", 1, "script_model", drop_point + (0,0,40));
	
	//chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
	valid_drop = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = true;
		}
	}

	if(flag( "dog_round" )) // forces a dog max ammo, sometimes dogs can be register as outside of the map but because they always spawn inside the map its ok we dont need to check this
	{
		valid_drop = true;
	}
	
	if(!valid_drop)
	{
		powerup delete();
		return;
	}

	powerup powerup_setup();
	level.powerup_drop_count++;

	print_powerup_drop( powerup.powerup_name, debug );

	powerup thread powerup_timeout();
	powerup thread powerup_wobble();
	powerup thread powerup_grab();

	level.zombie_vars["zombie_drop_item"] = 0;

	if(randomint(100) < 20)
		powerup thread random_powerup_powerup();


	//powerup = powerup_setup(); 


	// if is !is touching trig
	// return

	// spawn the model, do a ground trace and place above
	// start the movement logic, spawn the fx
	// start the time out logic
	// start the grab logic
}


//
//	Special power up drop - done outside of the powerup system.
special_powerup_drop(drop_point)
{
// 	if( level.powerup_drop_count == level.zombie_vars["zombie_powerup_drop_max_per_round"] )
// 	{
// 		println( "^3POWERUP DROP EXCEEDED THE MAX PER ROUND!" );
// 		return;
// 	}

	if( !isDefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0 )
	{
		return;
	}

	powerup = spawn ("script_model", drop_point + (0,0,40));

	// never drop unless in the playable area
	playable_area = getentarray("playable_area","targetname");
	//chris_p - fixed bug where you could not have more than 1 playable area trigger for the whole map
	valid_drop = false;
	for (i = 0; i < playable_area.size; i++)
	{
		if (powerup istouching(playable_area[i]))
		{
			valid_drop = true;
			break;
		}
	}

	if(!valid_drop)
	{
		powerup Delete();
		return;
	}

	powerup special_drop_setup();
}


//
//	Pick the next powerup in the list
powerup_setup()
{
	powerup = get_next_powerup();

	if(isdefined(level.dog_intermission) && level.dog_intermission)
	{
		powerup = level.DogRoundPowerup;
	}

	if(!isdefined(powerup))
	{
		self delete();
		return;
	}

	struct = level.zombie_powerups[powerup];

	if(powerup == "randomgun")
	{
		if(isdefined(level.randomgun_uses_all_guns) && level.randomgun_uses_all_guns)
		{
			keys = GetArrayKeys(level.zombie_weapons);
			self.randomweapon = keys[RandomInt(keys.size)];
		}
		else
		{
			self.randomweapon = level.magicweapons[RandomInt(level.magicweapons.size)];
		}
		struct.model_name = GetWeaponModel(self.randomweapon);
	}

	self SetModel( struct.model_name );

	//TUEY Spawn Powerup
	playsoundatposition("spawn_powerup", self.origin);

	self.powerup_name 	= struct.powerup_name;
	self.hint 			= struct.hint;

	if( IsDefined( struct.fx ) )
	{
		self.fx = struct.fx;
	}

	self PlayLoopSound("spawn_powerup_loop");
}


//
//	Get the special teleporter drop
special_drop_setup()
{
	powerup = undefined;
	is_powerup = true;
	// Always give something at lower rounds or if a player is in last stand mode.
	if ( level.round_number <= 10 || maps\_laststand::player_num_in_laststand() )
	{
		powerup = get_next_powerup();
	}
	// Gets harder now
	else
	{
		powerup = level.zombie_special_drop_array[ RandomInt(level.zombie_special_drop_array.size) ];
		if ( level.round_number > 15 &&
			 ( RandomInt(100) < (level.round_number - 15)*5 ) )
		{
			powerup = "nothing";
		}
	}

	level.tele_reward = powerup;

	//MM test  Change this if you want the same thing to keep spawning
//	powerup = "dog";
	switch ( powerup )
	{
	// Don't need to do anything special
	case "nuke":
	case "insta_kill":
	case "double_points":
	case "carpenter":
		break;

	// Limit max ammo drops because it's too powerful
	case "full_ammo":
		if ( level.round_number > 10 &&
			 ( RandomInt(100) < (level.round_number - 10)*5 ) )
		{
			// Randomly pick another one
			powerup = level.zombie_powerup_array[ RandomInt(level.zombie_powerup_array.size) ];
		}
		break;

	case "dog":
		if ( level.round_number >= 15 )
		{
			is_powerup = false;
			dog_spawners = GetEntArray( "special_dog_spawner", "targetname" );
			maps\_zombiemode_dogs::special_dog_spawn( dog_spawners, 1, undefined );
			//iprintlnbold( "Samantha Sez: No Powerup For You!" );
			thread play_sound_2d( "sam_nospawn" );
		}
		else
		{
			powerup = get_next_powerup();
		}
		break;

	// Nothing drops!!
	default:	// "nothing"
		is_powerup = false;
		Playfx( level._effect["lightning_dog_spawn"], self.origin );
		playsoundatposition( "pre_spawn", self.origin );
		wait( 1.5 );
		playsoundatposition( "bolt", self.origin );

		Earthquake( 0.5, 0.75, self.origin, 1000);
		PlayRumbleOnPosition("explosion_generic", self.origin);
		playsoundatposition( "spawn", self.origin );

		wait( 1.0 );
		//iprintlnbold( "Samantha Sez: No Powerup For You!" );
		thread play_sound_2d( "sam_nospawn" );
		self Delete();
	}

	if ( is_powerup )
	{
		Playfx( level._effect["lightning_dog_spawn"], self.origin );
		playsoundatposition( "pre_spawn", self.origin );
		wait( 1.5 );
		playsoundatposition( "bolt", self.origin );

		Earthquake( 0.5, 0.75, self.origin, 1000);
		PlayRumbleOnPosition("explosion_generic", self.origin);
		playsoundatposition( "spawn", self.origin );

//		wait( 0.5 );

		struct = level.zombie_powerups[powerup];
		self SetModel( struct.model_name );

		//TUEY Spawn Powerup
		playsoundatposition("spawn_powerup", self.origin);

		self.powerup_name 	= struct.powerup_name;
		self.hint 			= struct.hint;

		if( IsDefined( struct.fx ) )
		{
			self.fx = struct.fx;
		}

		self PlayLoopSound("spawn_powerup_loop");

		self thread powerup_timeout();
		self thread powerup_wobble();
		self thread powerup_grab();
	}
}

powerup_grab()
{
	self endon ("powerup_timedout");
	self endon ("powerup_grabbed");

	while (isdefined(self))
	{
		players = get_players();

		for (i = 0; i < players.size; i++)
		{
			if (distance (players[i].origin, self.origin) < 64)
			{
				varcheck = undefined;
				canbesolo = 0;

				switch(self.powerup_name)
				{
					case "minigun":
						varcheck = level.give_minigun_all_players;
						canbesolo = 1;
						break;

					case "randomperk":
						varcheck = level.give_randomperk_all_players;
						canbesolo = 1;
						break;

					case "upgrade_weap":
						varcheck = level.give_upgrade_weap_all_players;
						canbesolo = 1;
						break;

					case "bonus_points":
						varcheck = level.give_bonus_points_all_players;
						canbesolo = 1;
						break;

					case "randomgun":
						varcheck = level.give_randomgun_all_players;
						canbesolo = 1;
						break;

					default:
						break;
				}

				if(isdefined(self) && canbesolo && (!isdefined(varcheck) || !varcheck))
				{
					playfx (level._effect["powerup_grabbed_solo"], self.origin);
					playfx (level._effect["powerup_grabbed_wave_solo"], self.origin);
				}
				else
				{
					playfx (level._effect["powerup_grabbed"], self.origin);
					playfx (level._effect["powerup_grabbed_wave"], self.origin);	
				}

				if( IsDefined( level.zombie_powerup_grab_func ) )
				{
					level thread [[level.zombie_powerup_grab_func]]();
				}
				else
				{
					switch (self.powerup_name)
					{
					case "nuke":
						level thread nuke_powerup( self );
						
						//chrisp - adding powerup VO sounds
						players[i] thread powerup_vo("nuke");
						zombies = getaiarray("axis");
						players[i].zombie_nuked = get_array_of_closest( self.origin, zombies );
						players[i] notify("nuke_triggered");
						
						break;
					case "full_ammo":
						level thread full_ammo_powerup( self );
						players[i] thread powerup_vo("full_ammo");
						break;
					case "double_points":
						level thread double_points_powerup( self );
						players[i] thread powerup_vo("double_points");
						break;
					case "insta_kill":
						level thread insta_kill_powerup( self );
						players[i] thread powerup_vo("insta_kill");
						break;
					case "carpenter":
						level thread start_carpenter( self.origin, self.powerup_name );
						players[i] thread powerup_vo("carpenter");
						break;
					case "randomperk":
						if(isdefined(level.give_randomperk_all_players) && level.give_randomperk_all_players)
						{
							for(i=0;i<players.size;i++)
							{
								players[i] thread maps\_numan_powerups::randomperk(self.powerup_name);
							}
						}
						else
						{
							players[i] thread maps\_numan_powerups::randomperk(self.powerup_name);
						}
						break;
					case "upgrade_weap":
						if(isdefined(level.give_upgrade_weap_all_players) && level.give_upgrade_weap_all_players)
						{
							for(i=0;i<players.size;i++)
							{
								players[i] thread maps\_numan_powerups::upgrade_weap(self.powerup_name);
							}
						}
						else
						{
							players[i] thread maps\_numan_powerups::upgrade_weap(self.powerup_name);
						}
						break;
					case "reviveallplayers":
						for(i=0;i<players.size;i++)
						{
							players[i] thread maps\_numan_powerups::ReviveAllPlayers(self.powerup_name);
						}
						break;
					case "unlimited_ammo":
						level thread maps\_numan_powerups::UnlimitedAmmo(self.powerup_name);
						break;
					case "bonus_points":
						if(isdefined(level.give_bonus_points_all_players) && level.give_bonus_points_all_players)
						{
							for(i=0;i<players.size;i++)
							{
								players[i] thread maps\_numan_powerups::BonusPoints(self.powerup_name);
							}
						}
						else
						{
							players[i] thread maps\_numan_powerups::BonusPoints(self.powerup_name);
						}
						break;
					case "minigun":
						if(isdefined(level.give_minigun_all_players) && level.give_minigun_all_players)
						{
							for(i=0;i<players.size;i++)
							{
								players[i] thread maps\_numan_powerups::Minigun(self.powerup_name);
							}
						}
						else
						{
							players[i] thread maps\_numan_powerups::Minigun(self.powerup_name);
						}
						break;
					case "firesale":
						for(i=0;i<players.size;i++)
						{
							players[i] thread maps\_numan_powerups::FireSale(self.powerup_name);
						}
						break;
					case "randomgun":
						if(isdefined(level.give_randomgun_all_players) && level.give_randomgun_all_players)
						{
							for(i=0;i<players.size;i++)
							{
								players[i] thread maps\_numan_powerups::Random_Gun(self,self.powerup_name);
							}
						}
						else
						{
							players[i] thread maps\_numan_powerups::Random_Gun(self,self.powerup_name);
						}
						break;
					case "zombie_blood":
						players[i] thread maps\_numan_powerups::Zombie_Blood(self.powerup_name);
						break;
					default:
						println ("Unrecognized powerup.");
						break;
					}
				}

				wait( 0.1 );

				playsoundatposition("powerup_grabbed", self.origin);
				self stoploopsound();

				self delete();
				self notify ("powerup_grabbed");
			}
		}
		wait 0.1;
	}	
}

start_carpenter( origin, power_up_name )
{

	level thread play_devil_dialog("carp_vox");
	//window_boards = getstructarray( "exterior_goal", "targetname" ); 
	total = level.exterior_goals.size;

	players = GetPlayers();

	for( i = 0; i < players.size; i ++ )
	{
		player = players[i];
		if (player.first_use > 0 && player.renew_armor == true)
		{
			player notify("trigger_armor_purchase");
		}
		player thread CreatePowerUpHud( power_up_name );
	}

	wait 3;
	
	/*
	//COLLIN
	carp_ent = spawn("script_origin", (0,0,0));
	carp_ent playloopsound( "carp_loop" );
	
	while(true)
	{
		windows = get_closest_window_repair(window_boards, origin);
		if( !IsDefined( windows ) )
		{
			carp_ent stoploopsound( 1 );
			carp_ent playsound( "carp_end", "sound_done" );
			carp_ent waittill( "sound_done" );
			break;
		}
		
		else
			window_boards = array_remove(window_boards, windows);


		while(1)
		{
			if( all_chunks_intact( windows.barrier_chunks ) )
			{
				break;
			}

			chunk = get_random_destroyed_chunk( windows.barrier_chunks ); 

			if( !IsDefined( chunk ) )
				break;

			windows thread maps\_zombiemode_blockers_new::replace_chunk( chunk, false, true );
			windows.clip enable_trigger(); 
			windows.clip DisconnectPaths();
			wait_network_frame();
			wait(0.05);
		}
 

		wait_network_frame();
		
	}*/

	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		player = players[i];
		if (player.first_use > 0 && player.renew_armor == true)
		{
			player notify("trigger_armor_purchase");
		}
		player thread RemovePowerUpHud( power_up_name );
		player.score += 200;
		player.score_total += 200;
		player maps\_zombiemode_score::set_player_score_hud(); 
	}


	//carp_ent delete();


}
get_closest_window_repair( windows, origin )
{
	current_window = undefined;
	shortest_distance = undefined;
	for( i = 0; i < windows.size; i++ )
	{
		if( all_chunks_intact(windows[i].barrier_chunks ) )
			continue;

		if( !IsDefined( current_window ) )	
		{
			current_window = windows[i];
			shortest_distance = DistanceSquared( current_window.origin, origin );
		}
		else
		{
			if( DistanceSquared(windows[i].origin, origin) < shortest_distance )
			{

				current_window = windows[i];
				shortest_distance =  DistanceSquared( windows[i].origin, origin );
			}

		}

	}

	return current_window;


}

powerup_vo(type)
{
	self endon("death");
	self endon("disconnect");
	
	index = maps\_zombiemode_weapons::get_player_index(self);
	//sound = undefined;
	sound_to_play = undefined;
	rand = randomintrange(0,3);
	carp_rand = randomintrange(0,6);
	vox_rand = randomintrange(1,101);  //RARE: This is to setup the Rare devil response lines
	percentage = 3;  //What percent chance the rare devil response line has to play
	
	if(!isdefined (level.player_is_speaking))
	{
		level.player_is_speaking = 0;
	}
	
	wait(randomfloatrange(1.5,2));

	plr = "plr_" + index + "_";	
	waittime = 0.6;
	switch(type)
	{
		case "nuke":
			if( vox_rand <= percentage )
			{
				sound_to_play = "vox_resp_dev_rare_" + rand;
				//sound = "plr_" + index + "_vox_resp_dev_rare_" + rand;
				//iprintlnbold( "Whoopdedoo, rare Devil Response line" );
			}
			else
			{
				//sound = "plr_" + index + "_vox_powerup_nuke_" + rand;
				sound_to_play = "vox_powerup_insta_" + rand;
			}
			break;
		case "insta_kill":
			if( vox_rand <= percentage )
			{
				sound_to_play = "vox_resp_dev_rare_" + rand;
				//sound = "plr_" + index + "_vox_resp_dev_rare_" + rand;
				//iprintlnbold( "Whoopdedoo, rare Devil Response line" );
			}
			else
			{
				//sound = "plr_" + index + "_vox_powerup_insta_" + rand;
				sound_to_play = "vox_powerup_insta_" + rand;
			}
			break;
		case "full_ammo":
			if( vox_rand <= percentage )
			{
				sound_to_play = "vox_resp_dev_rare_" + rand;
				//sound = "plr_" + index + "_vox_resp_dev_rare_" + rand;
				//iprintlnbold( "Whoopdedoo, rare Devil Response line" );
			}
			else
			{
				//sound = "plr_" + index + "_vox_powerup_ammo_" + rand;
				sound_to_play = "vox_powerup_ammo_" + rand;
			}
			break;
		case "double_points":
			if( vox_rand <= percentage )
			{
				sound_to_play = "vox_resp_dev_rare_" + rand;
				//sound = "plr_" + index + "_vox_resp_dev_rare_" + rand;
				//iprintlnbold( "Whoopdedoo, rare Devil Response line" );
			}
			else
			{
				//sound = "plr_" + index + "_vox_powerup_double_" + rand;
				sound_to_play = "vox_powerup_double_" + rand;
			}
			break; 		
		case "carpenter":
			if( vox_rand <= percentage )
			{
				sound_to_play = "vox_resp_dev_rare_" + rand;
				//sound = "plr_" + index + "_vox_resp_dev_rare_" + rand;
				//iprintlnbold( "Whoopdedoo, rare Devil Response line" );
			}
			else
			{
				//sound = "plr_" + index + "_vox_powerup_carp_" + rand;
				sound_to_play = "vox_powerup_carp_" + carp_rand;
			}
			waittime = 0.85;
			break;
	}
	
	//This keeps multiple voice overs from playing on the same player (both killstreaks and headshots).
	/*if (level.player_is_speaking != 1 && isDefined(sound))
	{	
		level.player_is_speaking = 1;
		self playsound(sound, "sound_done");			
		self waittill("sound_done");
		level.player_is_speaking = 0;
	}*/	
	self maps\_zombiemode_spawner::do_player_playdialog(plr, sound_to_play, waittime);
	
}

powerup_wobble()
{
	self endon ("powerup_grabbed");
	self endon ("powerup_timedout");

	varcheck = undefined;
	canbesolo = 0;

	switch(self.powerup_name)
	{
		case "minigun":
			varcheck = level.give_minigun_all_players;
			canbesolo = 1;
			break;

		case "randomperk":
			varcheck = level.give_randomperk_all_players;
			canbesolo = 1;
			break;

		case "upgrade_weap":
			varcheck = level.give_upgrade_weap_all_players;
			canbesolo = 1;
			break;

		case "bonus_points":
			varcheck = level.give_bonus_points_all_players;
			canbesolo = 1;
			break;

		case "randomgun":
			varcheck = level.give_randomgun_all_players;
			canbesolo = 1;
			break;

		default:
			break;
	}

	if(isdefined(self) && canbesolo && (!isdefined(varcheck) || !varcheck) || self.powerup_name == "zombie_blood")
	{
		playfxontag (level._effect["powerup_on_solo"], self, "tag_origin");
	}
	else if (isdefined(self))
	{
		playfxontag (level._effect["powerup_on"], self, "tag_origin");
	}

	while (isdefined(self))
	{
		waittime = randomfloatrange(2.5, 5);
		yaw = RandomInt( 360 );
		if( yaw > 300 )
		{
			yaw = 300;
		}
		else if( yaw < 60 )
		{
			yaw = 60;
		}
		yaw = self.angles[1] + yaw;
		self rotateto ((-60 + randomint(120), yaw, -45 + randomint(90)), waittime, waittime * 0.5, waittime * 0.5);
		wait randomfloat (waittime - 0.1);
	}
}

powerup_timeout()
{
	self endon ("powerup_grabbed");

	wait 15;

	for (i = 0; i < 40; i++)
	{
		// hide and show
		if (i % 2)
		{
			self hide();
		}
		else
		{
			self show();
		}

		if (i < 15)
		{
			wait 0.5;
		}
		else if (i < 25)
		{
			wait 0.25;
		}
		else
		{
			wait 0.1;
		}
	}

	self notify ("powerup_timedout");
	self delete();
}

// kill them all!
nuke_powerup( drop_item )
{
	//zombies = getaispeciesarray("axis");
	zombies = GetAISpeciesArray( "axis", "all" );
	location = drop_item.origin;
	power_up_name = drop_item.powerup_name;

	//PlayFx( drop_item.fx, drop_item.origin );
	PlayFX( drop_item.fx, location );
	//	players = get_players();
	//	array_thread (players, ::nuke_flash);
	level thread nuke_flash();

	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread CreatePowerUpHud( power_up_name );

	//zombies = get_array_of_closest( drop_item.origin, zombies );
	zombies = get_array_of_closest( location, zombies );
	zombies_nuked = [];
	for( i = 0; i < zombies.size; i ++ )
	{
		if( IsDefined( zombies[i].marked_for_death ) && zombies[i].marked_for_death )
		{
			continue;
		}
		if( IsDefined( zombies[i].nuke_damage_func ) )
		{
			zombies[i] thread [[ zombies[i].nuke_damage_func ]]();
			continue;
		}
		if( is_magic_bullet_shield_enabled( zombies[i] ) )
		{
			continue;
		}
		zombies[i].marked_for_death = true;
		zombies[i].nuked = true;
		zombies_nuked[ zombies_nuked.size ] = zombies[i];
	}
	for( i = 0; i < zombies_nuked.size; i ++ )
	{
		wait RandomFloatRange( 0.1, 0.7 );
		if( !IsDefined( zombies_nuked[i] ) )
		{
			continue;
		}
		if( is_magic_bullet_shield_enabled( zombies_nuked[i] ) )
		{
			continue;
		}
		if( i < 5 && !zombies[i] enemy_is_dog() )
		{
			zombies_nuked[i] thread animscripts\death::flame_death_fx();
			zombies_nuked[i] PlaySound( "nuked" );
		}
		if( !zombies[i] enemy_is_dog() )
		{
			if( !IsDefined( zombies_nuked[i].no_gib ) || !zombies_nuked[i].no_gib )
			{
				zombies_nuked[i] maps\_zombiemode_spawner::zombie_head_gib();
			}
			zombies_nuked[i] PlaySound( "nuked" );
		}
		zombies_nuked[i] DoDamage( zombies_nuked[i].health + 666, zombies_nuked[i].origin );
	}
	players = GetPlayers();
	for( i = 0; i < players.size; i ++ )
	{
		players[i] thread RemovePowerUpHud( power_up_name );
		players[i] maps\_zombiemode_score::player_add_points( "nuke_powerup", 400 );
	}
}

nuke_flash()
{
	players = getplayers();	
	for(i=0; i<players.size; i ++)
	{
		players[i] play_sound_2d("nuke_flash");
	}
	level thread devil_dialog_delay();
	
	
	fadetowhite = newhudelem();

	fadetowhite.x = 0; 
	fadetowhite.y = 0; 
	fadetowhite.alpha = 0; 

	fadetowhite.horzAlign = "fullscreen"; 
	fadetowhite.vertAlign = "fullscreen"; 
	fadetowhite.foreground = true; 
	fadetowhite SetShader( "white", 640, 480 ); 

	// Fade into white
	fadetowhite FadeOverTime( 0.2 ); 
	fadetowhite.alpha = 0.8; 

	wait 0.5;
	fadetowhite FadeOverTime( 1.0 ); 
	fadetowhite.alpha = 0; 

	wait 1.1;
	fadetowhite destroy();
}

// double the points
double_points_powerup( drop_item )
{
	level notify ("powerup points scaled");
	level endon ("powerup points scaled");

	//	players = get_players();	
	//	array_thread(level,::point_doubler_on_hud, drop_item);
	level thread point_doubler_on_hud( drop_item, drop_item.powerup_name );

	level.zombie_vars["zombie_point_scalar"] = 2;
	wait 30;

	level.zombie_vars["zombie_point_scalar"] = 1;
}

full_ammo_powerup( drop_item )
{
	players = get_players();

	for (i = 0; i < players.size; i++)
	{
		primaryWeapons = players[i] GetWeaponsList(); 

		for( x = 0; x < primaryWeapons.size; x++ )
		{
			if(primaryWeapons[x] != "Stielhandgranate") // Give ammo for every weapon no matter what
			{
				players[i] SetWeaponAmmoClip( primaryWeapons[x], WeaponClipSize( primaryWeapons[x] ) );
				players[i] GiveMaxAmmo( primaryWeapons[x] );
			}
			else if ( !players[i] maps\_laststand::player_is_in_laststand()) // Otherwise, if you are a grenade only give it when the player is alive
			{
				players[i] GiveMaxAmmo( "Stielhandgranate" );
			}
		}

		if(isDefined(players[i].has_betties) && !players[i] maps\_laststand::player_is_in_laststand() )
		{
			players[i]  giveweapon("mine_bouncing_betty");
			players[i]  setactionslot(4,"weapon","mine_bouncing_betty");
			players[i]  setweaponammoclip("mine_bouncing_betty",2);
		}
	}
	//	array_thread (players, ::full_ammo_on_hud, drop_item);
	level thread full_ammo_on_hud( drop_item, drop_item.powerup_name );
}

insta_kill_powerup( drop_item )
{
	level notify( "powerup instakill" );
	level endon( "powerup instakill" );

		
	//	array_thread (players, ::insta_kill_on_hud, drop_item);
	level thread insta_kill_on_hud( drop_item, drop_item.powerup_name );

	level.zombie_vars["zombie_insta_kill"] = 1;
	wait( 30 );
	level.zombie_vars["zombie_insta_kill"] = 0;
	players = get_players();
	for(i = 0; i < players.size; i++)
	{
		players[i] notify("insta_kill_over");
	}
}

check_for_instakill( player, mod )
{
	if( IsDefined( player ) && IsAlive( player ) && level.zombie_vars["zombie_insta_kill"])
	{
		if( is_magic_bullet_shield_enabled( self ) )
		{
			return;
		}

		if( self.animname == "boss_zombie" )
		{
			return;
		}

		if(player.use_weapon_type == "MOD_MELEE")
		{
			player.last_kill_method = "MOD_MELEE";
		}
		else
		{
			player.last_kill_method = "MOD_UNKNOWN";
		}
		modName = remove_mod_from_methodofdeath( mod );
		if( flag( "dog_round" ) )
		{
			self DoDamage( self.health + 666, self.origin, player/*, undefined, modName*/ );
			player notify("zombie_killed");
		}
		else
		{
			self maps\_zombiemode_spawner::zombie_head_gib();
			self DoDamage( self.health + 666, self.origin, player/*, undefined, modName*/ );
			player notify("zombie_killed");
		}
	}
}

insta_kill_on_hud( drop_item, power_up_name )
{
	self endon ("disconnect");

	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_insta_kill_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
		return;
	}

	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread CreatePowerUpHud( power_up_name );

	level.zombie_vars["zombie_powerup_insta_kill_on"] = true;

	// set up the hudelem
	//hudelem = maps\_hud_util::createFontString( "objective", 2 );
	//hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] + level.zombie_vars["zombie_timer_offset_interval"]);
	//hudelem.sort = 0.5;
	//hudelem.alpha = 0;
	//hudelem fadeovertime(0.5);
	//hudelem.alpha = 1;
	//hudelem.label = drop_item.hint;

	// set time remaining for insta kill
	level thread time_remaning_on_insta_kill_powerup( drop_item, power_up_name );		

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}

time_remaning_on_insta_kill_powerup( drop_item, power_up_name )
{
	//self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );
	level thread play_devil_dialog("insta_vox");
	temp_enta = spawn("script_origin", (0,0,0));
	temp_enta playloopsound("insta_kill_loop");	

	/*
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
	players[i] playloopsound ("insta_kill_loop");
	}
	*/


	// time it down!
	while ( level.zombie_vars["zombie_powerup_insta_kill_time"] >= 0)
	{
		wait 0.1;
		level.zombie_vars["zombie_powerup_insta_kill_time"] = level.zombie_vars["zombie_powerup_insta_kill_time"] - 0.1;
	//	self setvalue( level.zombie_vars["zombie_powerup_insta_kill_time"] );	
	}

	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound (2);

		players[i] playsound("insta_kill");

	}

	temp_enta stoploopsound(2);
	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread RemovePowerUpHud( power_up_name );
	// turn off the timer
	level.zombie_vars["zombie_powerup_insta_kill_on"] = false;

	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_insta_kill_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	//self destroy();
	temp_enta delete();
}

point_doubler_on_hud( drop_item, power_up_name )
{
	self endon ("disconnect");

	// check to see if this is on or not
	if ( level.zombie_vars["zombie_powerup_point_doubler_on"] )
	{
		// reset the time and keep going
		level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
		return;
	}

	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread CreatePowerUpHud( power_up_name );

	level.zombie_vars["zombie_powerup_point_doubler_on"] = true;
	//level.powerup_hud_array[0] = true;
	// set up the hudelem
	//hudelem = maps\_hud_util::createFontString( "objective", 2 );
	//hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] );
	//hudelem.sort = 0.5;
	//hudelem.alpha = 0;
	//hudelem fadeovertime( 0.5 );
	//hudelem.alpha = 1;
	//hudelem.label = drop_item.hint;

	// set time remaining for point doubler
	level thread time_remaining_on_point_doubler_powerup( drop_item, power_up_name );		

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;
}
play_devil_dialog(sound_to_play)
{
	if(!IsDefined(level.devil_is_speaking))
	{
		level.devil_is_speaking = 0;
	}
	if(level.devil_is_speaking == 0)
	{
		level.devil_is_speaking = 1;
		play_sound_2D( sound_to_play );
		wait 2.0;
		level.devil_is_speaking =0;
	}
	
}
time_remaining_on_point_doubler_powerup( drop_item, power_up_name )
{
	//self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );
	
	temp_ent = spawn("script_origin", (0,0,0));
	temp_ent playloopsound ("double_point_loop");
	
	level thread play_devil_dialog("dp_vox");
	
	
	// time it down!
	while ( level.zombie_vars["zombie_powerup_point_doubler_time"] >= 0)
	{
		wait 0.1;
		level.zombie_vars["zombie_powerup_point_doubler_time"] = level.zombie_vars["zombie_powerup_point_doubler_time"] - 0.1;
		//self setvalue( level.zombie_vars["zombie_powerup_point_doubler_time"] );	
	}

	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread RemovePowerUpHud( power_up_name );

	// turn off the timer
	level.zombie_vars["zombie_powerup_point_doubler_on"] = false;
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		//players[i] stoploopsound("double_point_loop", 2);
		players[i] playsound("points_loop_off");
	}
	temp_ent stoploopsound(2);


	// remove the offset to make room for new powerups, reset timer for next time
	level.zombie_vars["zombie_powerup_point_doubler_time"] = 30;
	//level.zombie_timer_offset += level.zombie_timer_offset_interval;
	//self destroy();
	temp_ent delete();
}
devil_dialog_delay()
{
	wait(1.8);
	level thread play_devil_dialog("nuke_vox");
	
}
full_ammo_on_hud( drop_item, power_up_name )
{
	self endon ("disconnect");

	/*
	// set up the hudelem
	hudelem = maps\_hud_util::createFontString( "objective", 2 );
	hudelem maps\_hud_util::setPoint( "TOP", undefined, 0, level.zombie_vars["zombie_timer_offset"] - (level.zombie_vars["zombie_timer_offset_interval"] * 2));
	hudelem.sort = 0.5;
	hudelem.alpha = 0;
	hudelem fadeovertime(0.5);
	hudelem.alpha = 1;
	hudelem.label = drop_item.hint;

	// set time remaining for insta kill
	hudelem thread full_ammo_move_hud();		

	// offset in case we get another powerup
	//level.zombie_timer_offset -= level.zombie_timer_offset_interval;*/
	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread CreatePowerUpHud( power_up_name );

	wait 3;

	for( i = 0; i < GetPlayers().size; i ++ )
		GetPlayers()[i] thread RemovePowerUpHud( power_up_name );
}

full_ammo_move_hud()
{

	players = get_players();
	level thread play_devil_dialog("ma_vox");
	for (i = 0; i < players.size; i++)
	{
		players[i] playsound ("full_ammo");
		
	}
	wait 0.5;
	move_fade_time = 1.5;

	self FadeOverTime( move_fade_time ); 
	self MoveOverTime( move_fade_time );
	self.y = 270;
	self.alpha = 0;

	wait move_fade_time;

	self destroy();
}

//
// DEBUG
//

print_powerup_drop( powerup, type )
{
	/#
		if( !IsDefined( level.powerup_drop_time ) )
		{
			level.powerup_drop_time = 0;
			level.powerup_random_count = 0;
			level.powerup_score_count = 0;
		}

		time = ( GetTime() - level.powerup_drop_time ) * 0.001;
		level.powerup_drop_time = GetTime();

		if( type == "random" )
		{
			level.powerup_random_count++;
		}
		else
		{
			level.powerup_score_count++;
		}

		println( "========== POWER UP DROPPED ==========" );
		println( "DROPPED: " + powerup );
		println( "HOW IT DROPPED: " + type );
		println( "--------------------" );
		println( "Drop Time: " + time );
		println( "Random Powerup Count: " + level.powerup_random_count );
		println( "Random Powerup Count: " + level.powerup_score_count );
		println( "======================================" );
#/
}

random_powerup_powerup()
{
	while(isdefined(self))
	{
		powerup = get_next_powerup();
		struct = level.zombie_powerups[powerup];
 
		self SetModel( struct.model_name );
		self.powerup_name 	= struct.powerup_name;
		self.hint 			= struct.hint;
 
		if( IsDefined( struct.fx ) )
			self.fx = struct.fx;
 
		wait 0.2; // change this to change the cycle time
	}
}