 
 
// Utilities
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
#include maps\_zombiemode_zone_manager; 
#include maps\_music;
 
// DLC3 Utilities
#include maps\dlc3_code;
#include maps\dlc3_teleporter;
 
main()
{
	//// SETTINGS
 
	level.w_enable = true; // if you want that walking enabled, leave it true
	//DOESNT WORK FOR NOW // level.w_sprint_fix = true; // for some people it may look weird when sprinting, that will fix it
	level.w_ads_fix = true; // for some people the gun sways too much when ADS, this will fix it
	level.w_gun_move_value_fix = true; // this will make all gun movement values to be 0 (doesn't include sprinting and rotating)
	level.w_better_prone = true; // This will enhance prone movement
	level.w_toggle_by_dvar = true; // this will create a dvar named "cg_ray_walking" to make it toggleable through script
 
	// SETTINGS END
 
	if(level.w_toggle_by_dvar == true) SetDvar("cg_ray_walking", 1);
	SetDvar("ray_walking_holster",0);
	SetDvar("ray_walking_holster_r",-25);
	SetDvar("ray_walking_holster_p",5);
	SetDvar("ray_walking_holster_y",20);
	players = GetPlayers();
	array_thread(players,::walking_init);
	array_thread(players,::walking_watch);
	array_thread(players,::event_watch);
	array_thread(players,::prone_watch);
	array_thread(players,::rot_watch);
}
 
rot_watch()
{
        self endon("disconnect");
	for(;;)
	{
		//iPrintLn(weaponClass(self GetCurrentWeapon()));
		roll = self GetVelocity() * anglestoright(self GetPlayerAngles());
		x_pos = self GetVelocity() * anglestoForward(self GetPlayerAngles());
		z_pos = self GetVelocity() * anglestoUp(self GetPlayerAngles());
		pitch = self GetVelocity() * anglestoUp(self GetPlayerAngles());
		x_pos = x_pos/200;
		z_pos = z_pos/150;
		if(weaponClass(self GetCurrentWeapon()) == "mg"){
			if(pitch>0)
				pitch = pitch/7.5;
			else
				pitch = pitch/30;
		}
		else
		{
			pitch = pitch/15;
		}
		roll = roll/15;
		if(isDefined(self.is_diving) && !self.is_diving)
		{
		if(GetDvarInt("ray_walking_holster") == 1)
			self SetClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]+GetDvarInt("ray_walking_holster_r"));
		else
			self SetClientDvar("cg_gun_rot_r",roll[0]+roll[1]+roll[2]);
		if(GetDvarInt("ray_walking_holster") == 1)
			self SetClientDvar("cg_gun_rot_p",pitch[0]+pitch[1]+pitch[2]+GetDvarInt("ray_walking_holster_p"));
		else
			self SetClientDvar("cg_gun_rot_p",pitch[0]+pitch[1]+pitch[2]);
		self SetClientDvar("cg_gun_move_u",z_pos[0]+z_pos[1]+z_pos[2]);
		self SetClientDvar("cg_gun_move_f",x_pos[0]+x_pos[1]+x_pos[2]);
		if(GetDvarInt("ray_walking_holster") == 1)
			self SetClientDvar("cg_gun_rot_y",GetDvarInt("ray_walking_holster_y"));
		else
			self SetClientDvar("cg_gun_rot_y",0);
		}
		wait(0.1);
	}
}
 
walking_init()
{
	self.w_current_value = 1; // leave this or everything breaks
	self.w_value_true = 1; // leave this or everything breaks
	self SetClientDvar("bg_bobAmplitudeStanding", "0.02 0.007");
	if (level.w_gun_move_value_fix == true)
		self SetClientDvar("cg_gun_move_minspeed", -100000);
		self SetClientDvar("cg_gun_rot_minspeed", -100000);
	if (level.w_better_prone == true)
	{
		self SetClientDvar("cg_gun_move_minspeed", -100000);
		self SetClientDvar("cg_gun_rot_minspeed", -100000);
		self SetClientDvar("bg_bobAmplitudeProne","1 0.1");
	}
}
 
prone_watch()
{
        self endon("disconnect");
	for(;;){
		if(level.w_gun_move_value_fix == true && self GetStance() == "prone"){
			self SetClientDvar("cg_gun_move_minspeed", 0);
			self SetClientDvar("cg_gun_rot_minspeed", 0);
		} else if(level.w_gun_move_value_fix == true) {
			self SetClientDvar("cg_gun_move_minspeed", -100000);
			self SetClientDvar("cg_gun_rot_minspeed", -100000);
		}
		wait(0.1);
	}
}
 
walking_watch()
{
        self endon("disconnect");
	if(level.w_enable == true && GetDvar("cg_ray_walking") == 1){
		for(;;)
		{
			if(self.w_current_value > self.w_value_true){
				self.w_value_true += 0.02;
			} else if(self.w_current_value < self.w_value_true){
				self.w_value_true -= 0.02;
			}
			self SetClientDvar("cg_bobWeaponAmplitude", self.w_value_true);
			wait(0.01);
		}
	}
}
 
event_watch()
{
        self endon("disconnect");
	for(;;)
	{
		if(level.w_ads_fix == true && (self adsButtonPressed() == true || self isSprinting())){
			self.w_current_value = 0.16;
		} else {
			self.w_current_value = 0.5;
		}
		wait(0.01);
	}
}
 
isSprinting()
{
	velocity = self GetVelocity(); 
	originHeight = self.origin[2] - 40;
	player_speed = abs(velocity[0]) + abs(velocity[1]); 
	if(player_speed > 225) return true;
	return false;
}