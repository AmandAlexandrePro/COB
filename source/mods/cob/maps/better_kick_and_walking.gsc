#include common_scripts\utility; 
#include maps\_utility;
#include maps\_zombiemode_utility; 
 
init()
{
	level.kickbackmax = .4;
	level.kickbackmin = .2;
	level.kicksidemax = .3;
	level.kicksidemin = .1;	
 
	players = GetPlayers();
	array_thread(players,::walking);
	array_thread(players,::kick_watch);
}
 
walking()
{
	self endon("disconnect");
	for(;;)
	{
		if(!self adsButtonPressed())
		{
			self SetClientDvar("bg_bobAmplitudeStanding",".1 0.01");
			self SetClientDvar("bg_bobAmplitudeducking",".1 0.01");
			if(self GetStance() == "prone")
				self SetClientDvar("cg_gun_rot_minspeed", 0);
			else
				self SetClientDvar("cg_gun_rot_minspeed", -1000);
			rotvar = self getvelocity() * anglestoright(self GetPlayerAngles());
			rotvar = rotvar[0] + rotvar[1] + rotvar[2];
			rotvar = int(rotvar/20);
			self SetClientDvar("cg_gun_rot_r", rotvar);
		}
		else
		{
			self SetClientDvar("bg_bobAmplitudeStanding","0.01 0.001");
			self SetClientDvar("bg_bobAmplitudeducking","0.01 0.001");
		}
		wait(0.1);
	}
}
 
kick_watch()
{
	self endon("disconnect");
 
	for(;;)
	{
		self waittill("weapon_fired");
		kickBack = RandomfloatRange(level.kickbackmin, level.kickbackmax);
		kickSide = RandomfloatRange(level.kicksidemin, level.kicksidemax);
		kickdown = RandomfloatRange(level.kicksidemin, level.kicksidemax);
		kickback = kickback*-1;
		kickdown = (kickdown/2)*-1;
		if(randomint(2))
			kickside = kickside*-1;
		if(self adsButtonPressed())
		{
			kickback = kickback/3;
			kickside = kickside/3;
			kickdown = kickdown/3;
		}
		else
		{
			self SetClientDvar("cg_gun_rot_p", kickback*-12);
			self SetClientDvar("cg_gun_rot_r", kickside*-12);
			self SetClientDvar("cg_gun_rot_y", kickside*12);
		}
		self SetClientDvar("cg_gun_x", kickBack);
		self SetClientDvar("cg_gun_y", kickside);
		self SetClientDvar("cg_gun_z", kickdown);
		wait 0.1;
		self SetClientDvar("cg_gun_x", 0);
		self SetClientDvar("cg_gun_y", 0);
		self SetClientDvar("cg_gun_z", 0);
		self SetClientDvar("cg_gun_rot_p", 0);
		self SetClientDvar("cg_gun_rot_r", 0);
		self SetClientDvar("cg_gun_rot_y", 0);
	}
}