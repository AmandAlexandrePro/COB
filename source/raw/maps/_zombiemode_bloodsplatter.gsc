#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility;
#include maps\_hud_util;

/*
//	Zombie Blood Effect
//	This script adds a blood splatter effect to the player's screen when they hit a zombie with a melee.
//	Scriptor: JBird632
*/

init()
{
	level.bloodShaders = [];													// 	Don't edit this line!
	
	/* 	=== Editable Variables === */
	level.bloodFadeTime = 0.35;													//	<int> The time it takes for the  blood to fade in/out of the player's screen
	level.bloodTime = 2;														//	<int> The time the blood lasts on the player's screen
	level.bloodShaders[level.bloodShaders.size] = "vfx_blood_screen_splatter";	// 	<string> The sting of the name for the shader
	/* 	=== 	   End		   === */
	
	thread setupBloodShader();
}

/*
//	Setup The Blood Shader
//	@param shader The string name of the shader that is used when knifing a zombie
*/
setupBloodShader()
{	
	flag_wait( "all_players_connected" );
	players = GetPlayers();
	
	for( i = 0; i < players.size; i++ )
	{
		players[i].bloodHud = create_simple_hud(players[i]);
		players[i].bloodHud.x = 0; 
		players[i].bloodHud.y = 0; 
		players[i].bloodHud.horzAlign = "fullscreen"; 
		players[i].bloodHud.vertAlign = "fullscreen"; 
		players[i].bloodHud.foreground = true;
		players[i].bloodHud.alpha = 0;
		players[i].bloodHud SetShader( level.bloodShaders[0], 640, 480 );
		players[i].bloodHud.sort = 1;
	}
}

/*
//	Watch the player's knifing
//	@ref self is a reference variable of the player
*/
playerBloodsplatter()
{
	self notify("active_bloodsplatter");
	self endon("active_bloodsplatter");

	level.bloodShaders = array_randomize(level.bloodShaders);
	self.bloodHud setShader( level.bloodShaders[0], 640, 480 );
	self.bloodHud FadeOverTime( level.bloodFadeTime );
	self.bloodHud.alpha = 0.75;
	wait( level.bloodTime );
	self.bloodHud FadeOverTime( level.bloodFadeTime );
	self.bloodHud.alpha = 0;
}