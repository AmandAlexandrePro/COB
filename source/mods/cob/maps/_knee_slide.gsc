//================================================================================================//
// File Name  : Knee Slide (Movement Ghosts and AW)												  //
// Author        : Espi_thekiller																  //
// Notes          : call before zombiemode main													  //
//      																						  //
//================================================================================================//
 
#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
 
main()
{
	set_knee_slide_var( "ready_knee_time", 				1.3 ); 				//TIME BETWEEN KNEE SLIDES
	set_knee_slide_var( "knee_sliding_time", 			1 );				//THE DURATION OF THE SLIDE
	set_knee_slide_var( "knee_slide_force", 			300 );				//THE FORCE WITH WHICH YOU SLIDE
	thread add_weapons_main();												//DEFAULTS MOVE SPEED SCALE = 1
	level thread on_player_connect();
}
 
add_weapons_main()
{
	//Search \moveSpeedScale\ in your weapon file and copy the value
	//EXAMPLE: add_weaps("zombie_colt", 1); 
 
	//add_weaps(<weap>, <movescale>); 
	add_weaps("zombie_sw_357", 0.9);
	add_weaps("zombie_sw_357_upgraded", 0.9);
	add_weaps("zombie_kar98k", 0.9);
	add_weaps("zombie_kar98k_upgraded", 0.9);
	add_weaps("zombie_m1carbine", 0.9);
	add_weaps("zombie_m1carbine_upgraded", 0.9);
	add_weaps("zombie_m1garand", 0.9);
	add_weaps("zombie_m1garand_upgraded", 0.9);
	add_weaps("zombie_gewehr43", 0.9);
	add_weaps("zombie_gewehr43_upgraded", 0.9);
	add_weaps("ptrs41_zombie", 0.75);
	add_weaps("ptrs41_zombie_upgraded", 0.75);
	add_weaps("m1garand_gl_zombie", 0.9);
	add_weaps("m1garand_gl_zombie_upgraded", 0.9);
	add_weaps("m2_flamethrower_zombie", 0.67);
	add_weaps("m2_flamethrower_zombie_upgraded", 0.67);
	add_weaps("zombie_30cal", 0.75);
	add_weaps("zombie_30cal_upgraded", 0.75);
	add_weaps("zombie_mg42", 0.75);
	add_weaps("zombie_mg42_upgraded", 0.75);
	add_weaps("panzerschrek_zombie", 0.75);
	add_weaps("panzerschrek_zombie_upgraded", 0.75);
}
 
on_player_connect()
{
	while(1)
	{
		level waittill( "connecting", player );
		player thread ready_to_slide();
	}
}
 
ready_to_slide()
{
	flag_wait( "all_players_connected" );
	self.is_sliding = false;
	self.is_ready_to_slide = true;
	while(1)
	{
		if(self IsSprinting() && self isonground())
			self thread knee_slide();
		wait 0.001;
	}
}
 
knee_slide()
{
	wait 0.1;
	if(self getstance() == "crouch" && !self.is_sliding && self.is_ready_to_slide && self isonground())
	{
		self.is_sliding = true;
		self.is_drinking = 1;
		self setstance( "crouch" );
		dvar = [];
		dvar[0] = GetDvar("cg_gun_ofs_r");
		dvar[1] = GetDvar("cg_gun_ofs_u");
		dvar[2] = get_move_speed_scale(get_weap_index(self GetCurrentWeapon()));
		self thread SetKneeSlideVars(dvar);
		self AllowProne(false);
		self AllowStand(false);
		self AllowAds(false);
		self AllowMelee(false);
		self do_knee_slide(dvar,level._knee_slide_var["knee_slide_force"],level._knee_slide_var["knee_sliding_time"]);
		self.is_drinking = undefined;
		self AllowAds(true);
		self AllowMelee(true);
		self AllowProne(true);
		self AllowStand(true);
	}
}
 
do_knee_slide(dvar,force,time)
{
	force = force*dvar[2];
	angles = self GetPlayerAngles();
	angles = (0,(angles[1]),0);
	vec = AnglesToForward(angles);
	i = 0;
	self SetClientDvar("cg_gun_ofs_r",dvar[0]-5);
	self SetClientDvar("cg_gun_ofs_u",dvar[1]+3);
	time = time*0.18;
	dist = 20;
	while(i < time && self isonground() && dist > 5)
	{
		mo = self.origin;
		i += 0.01;
		wait 0.01;
		self SetVelocity(vec * force);
		dist = distance(mo, self.origin);
	}
	self end_knee_slide();
}
 
end_knee_slide()
{
	self.is_sliding = false;
	dvar = self GetKneeSlideVars();
	self SetClientDvar("cg_gun_ofs_r",dvar[0]);
	self SetClientDvar("cg_gun_ofs_u",dvar[1]);
	self thread between_knee_slides();
	self thread CleanKneeSlideVars();
}
 
between_knee_slides()
{
	if(!self.is_sliding)
	{
		self.is_ready_to_slide = false;
		if(level._knee_slide_var["ready_knee_time"] > 0)
			wait level._knee_slide_var["ready_knee_time"];
		self.is_ready_to_slide = true;
	}
}
 
SetKneeSlideVars(dvar)
{
	if(dvar.size > 1)
		for(i=0;i<dvar.size;i++)
			self.knee_slide_vars[i] = dvar[i];
	else
		self.knee_slide_vars[0] = dvar;
}
 
GetKneeSlideVars()
{
	return self.knee_slide_vars;
}
 
CleanKneeSlideVars()
{
	for(i=0;i<self.knee_slide_vars.size;i++)
		if(IsDefined(self.knee_slide_vars[i]))
			self.knee_slide_vars[i] = undefined;
}
 
get_weap_index(w)
{
	for(i=0;i<level._knee_slide_weaps.size;i++)
		if(level._knee_slide_weaps[i].weap == w)
			return i;
	return -1;
}
 
get_move_speed_scale(index)
{
	if(index < 0)
		return 1;
	return level._knee_slide_weaps[index].movespeedscale;
}
 
set_knee_slide_var(var, value)
{
	if(!IsDefined(level._knee_slide_var))
		level._knee_slide_var = [];
	level._knee_slide_var[var] = value;
}
 
add_weaps(weap, movespeedscale)
{
	if(!IsDefined(level._knee_slide_weaps))
		level._knee_slide_weaps = [];
 
	struct = SpawnStruct();
	struct.weap = weap;
	struct.movespeedscale = movespeedscale;
	level._knee_slide_weaps[level._knee_slide_weaps.size] = struct;
}
 
IsSprinting()
{
	max_v = 280;
	mas_v_vector = 110;
	index = get_weap_index(self GetCurrentWeapon());
	move_scale = get_move_speed_scale(index);
	v = self getVelocity();
	v1_c2 = abs(v[0])*abs(v[0]);
	v2_c2 = abs(v[1])*abs(v[1]);
	total_velocidad = sqrt(v1_c2 + v2_c2);
	max_v12 = Int(max_v*move_scale);
	if(total_velocidad >= max_v12)
	{
		mas_v_vector2 = Int(mas_v_vector*move_scale);
		if(abs(v[0]) > mas_v_vector2 || abs(v[1]) > mas_v_vector2)
			return true;
	}
	return false;
}