#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_hud_util;

init()
{

	precacheshader("black");
	precacheshader("white");

	// Variables
	level.armor_with_jugg = 450; // Max Health With Armor And Jugg
	level.armor_only = 250; // Max Health With Armor Only
	level.jugg_only = 250; // Max Health With Jugg Only
	level.noarmor_nojugg = 100; // Max Health Without Armor And Jugg
	level.armor_cost = 3000; // Armor Cost
	level.armor_hud_status = 100; // Armor Full Life (Var Not Working)
	level.armor_hud_life = 25; // Armor Damage Taken Steps (Var Not Working)
	level.armor_hud_hurt = (level.armor_hud_status/level.armor_hud_life); // Armor Damage Taken (Var Not Working)


	level thread wait_for_armor_trigger();

}

wait_for_armor_trigger()
{
	armor = getent("armor", "targetname");//trigger_use
	armor sethintstring( "Appuyer et maintenir [{+activate}] pour acheter une armure [Coût: "+level.armor_cost+"]" );
	armor setCursorHint( "HINT_NOICON" );
	armor UseTriggerRequireLookat();

	while(1)
	{

		armor waittill("trigger", player);

		player.renew_armor = true;
		player.first_use = 0;

		if(player.score >= level.armor_cost && player.renew_armor == true && player.first_use == 0)
		{
			if(level.enableCarpenter != 1)
			{
				level.enableCarpenter = 1;
			}
			player maps\_zombiemode_score::minus_to_player_score( level.armor_cost );
			player.dmg_taken = 0;
			player.armor_wait = 0;
			player.empty_hud = false;
			player.first_use = 1;
			player.renew_armor = false;
			player playsound( "cha_ching" );
			player thread armor_hud();
			//player iPrintLnBold("Player Has Armor");
			player thread checking_for_dmg();
			player thread armor_init();
		}
		else if(player.score < level.armor_cost)
		{
			armor sethintstring( "You Need More Money" );
			player playsound( "no_cha_ching" );
			wait 1;
			armor sethintstring( "Appuyer et maintenir [{+activate}] pour acheter une armure [Coût: "+level.armor_cost+"]" );			
		}
		else if(player.score >= level.armor_cost && player.renew_armor == false)
		{
			armor sethintstring( "You Already Have Armor" );
			player playsound( "no_cha_ching" );
			wait 1;
			armor sethintstring( "Appuyer et maintenir [{+activate}] pour acheter une armure [Coût: "+level.armor_cost+"]" );
		}
		else if(player.score >= level.armor_cost && player.renew_armor == true)
		{
			player maps\_zombiemode_score::minus_to_player_score( level.armor_cost );
			player playsound( "cha_ching" );
			player notify("trigger_armor_purchase");
			

		}
		
	}

}

check_for_downed()
{

	if( self maps\_laststand::player_is_in_laststand())
	{
		//self notify("armor_empty");
		//self iPrintLnBold("Player Downed");
		self.empty_hud = true;
		return self.empty_hud;
	}
	else
	{
		self.empty_hud = false;
		return self.empty_hud;
	}			


}

armor_hud()
{

	self.Armor_Hud = Create_Armor_Hud();
	self.armor_width = 100;
	self.armor_status = 100;

	while(1)
	{

		self waittill("armor_damage_taken");
		
		self.armor_status -= 4;

		self.player_downed_two = self check_for_downed();
		
		if( self.dmg_taken < 25 )
		{
			self.Armor_Hud[0] scaleOverTime(0.1, self.armor_width, 6);
			self.Armor_Hud[1] setText(self.armor_status);
			self.armor_width -= 4;
		}
		
		//self iPrintLnBold("DMG_WAIT: " + self.dmg_wait);		

		
		if( self.dmg_taken >= 1 && self.dmg_taken < 2)
		{

			self thread wait_for_hud_renew(self.Armor_Hud);
			

		}

		if( self.dmg_taken >= 25 || self.player_downed_two == true)
		{
			//self iPrintLnBold("EMPTY HUD");
			self.Armor_Hud[0] scaleOverTime(0.1, 4, 6);
			self.Armor_Hud[1] setText("0");
			//self iPrintLnBold("WAITING FOR PURCHASE");	
			self waittill("trigger_armor_purchase");

		}

		
		wait 0.05;


	}


}


wait_for_hud_renew(hud)
{

	self waittill("trigger_armor_purchase");
	hud[0] scaleOverTime(0.5, 104, 6);
	hud[1] setText("100");
	self.armor_status = 100;
	self.armor_width = 100;
	self.dmg_taken = 0;
	self.renew_armor = false;
}


Create_Armor_Hud()
{

	Armor_Hud_Bar = [];

	self.armorProgressBar_Background = newClientHudElem( self );
	self.armorProgressBar_Background.x = 629; //625
	self.armorProgressBar_Background.y = -225; //10
	self.armorProgressBar_Background.hidewheninmenu = false;
	self.armorProgressBar_Background.alignX = "left";
	self.armorProgressBar_Background.alignY = "middle";
	self.armorProgressBar_Background.horzAlign = "left";
	self.armorProgressBar_Background.vertAlign = "middle";
	self.armorProgressBar_Background.sort = -6;
	self.armorProgressBar_Background SetShader("black", 110, 10);

	self.armorProgressBar = newClientHudElem( self );
	self.armorProgressBar.x =  631; //628  258
	self.armorProgressBar.y =  -226; //12  -226
	self.armorProgressBar.hidewheninmenu = false;
	self.armorProgressBar.alignX = "left";
	self.armorProgressBar.alignY = "middle";
	self.armorProgressBar.horzAlign = "left";
	self.armorProgressBar.vertAlign = "middle";
	self.armorProgressBar.sort = -5;
	self.armorProgressBar.color = (0,0.50,1);
	self.armorProgressBar SetShader("white", 104, 6);

	self.armorProgressBar_Line_One = newClientHudElem( self );
	self.armorProgressBar_Line_One.x = 662; //659
	self.armorProgressBar_Line_One.y = -225; //10
	self.armorProgressBar_Line_One.hidewheninmenu = false;
	self.armorProgressBar_Line_One.alignX = "left";
	self.armorProgressBar_Line_One.alignY = "middle";
	self.armorProgressBar_Line_One.horzAlign = "left";
	self.armorProgressBar_Line_One.vertAlign = "middle";
	self.armorProgressBar_Line_One.sort = -4;
	self.armorProgressBar_Line_One SetShader("black", 3, 10);

	self.armorProgressBar_Line_Two = newClientHudElem( self );
	self.armorProgressBar_Line_Two.x = 700; //700
	self.armorProgressBar_Line_Two.y = -225; //10
	self.armorProgressBar_Line_Two.sort = -3;
	self.armorProgressBar_Line_Two.hidewheninmenu = false;
	self.armorProgressBar_Line_Two.alignX = "left";
	self.armorProgressBar_Line_Two.alignY = "middle";
	self.armorProgressBar_Line_Two.horzAlign = "left";
	self.armorProgressBar_Line_Two.vertAlign = "middle";
	self.armorProgressBar_Line_Two SetShader("black", 3, 10);

	/*self.armorText = newClientHudElem( self );
	self.armorText.x = 576; //184 590
	self.armorText.y = -225; //-225 9
	self.armorText.hidewheninmenu = false;
	self.armorText.alignX = "left";
	self.armorText.alignY = "middle";
	self.armorText.horzAlign = "left";
	self.armorText.vertAlign = "middle";	
	self.armorText.sort = -2;
	self.armorText.color = (1,1,1);
	self.armorText SetText("Armure");*/

	self.armorProgressNum = newClientHudElem( self );
	self.armorProgressNum.x = 608; //590
	self.armorProgressNum.y = -225; //9
	self.armorProgressNum.hidewheninmenu = false;
	self.armorProgressNum.alignX = "left";
	self.armorProgressNum.alignY = "middle";
	self.armorProgressNum.horzAlign = "left";
	self.armorProgressNum.vertAlign = "middle";	
	self.armorProgressNum.sort = -1;
	self.armorProgressNum.color = (1,1,1);
	self.armorProgressNum SetText(100);

	Armor_Hud_Bar[0] = self.armorProgressBar;
	Armor_Hud_Bar[1] = self.armorProgressNum;
	return Armor_Hud_Bar;
}

armor_init()
{

	
	while ( 1 )
	{
		if( self hasPerk( "specialty_armorvest") && self.dmg_taken < 25 && self.armor_wait == 0 )
		{
			self.maxhealth = level.armor_with_jugg;
			//self iPrintLnBold("Max Health Armor With Jugg " + self.maxhealth );
		}
		else if( !self hasperk( "specialty_armorvest" ) && self.dmg_taken < 25 && self.armor_wait == 0 )
		{
			self.maxhealth = level.armor_only;
			//self iPrintLnBold("Max Health Armor Only " + self.maxhealth );
		}
		else if( self hasPerk( "specialty_armorvest") && self.armor_wait == 1 )
		{
			self.maxhealth = level.jugg_only;
			//self iPrintLnBold("Max Health With Jugg No Armor " + self.maxhealth );
		}
		else if( !self hasperk( "specialty_armorvest" ) && self.armor_wait == 1 )
		{
			self.maxhealth = level.noarmor_nojugg;
			//self iPrintLnBold("Max Health No Jugg No Armor " + self.maxhealth );
		}
		wait 0.5;
		
	}
	

}

checking_for_dmg()
{

	while ( 1 )
	{
		self waittill( "damage");
		self.dmg_taken += 1;

		self notify("armor_damage_taken");

		self.player_downed = self check_for_downed();

		if( self.dmg_taken >= 1 && self.dmg_taken < 25 )
		{
			self.renew_armor = true;		

		}

		if( self.dmg_taken >= 25 || self.player_downed == true )
		{

			self.armor_wait = 1;
			self waittill("trigger_armor_purchase");
			self.dmg_taken = 0;
			self.renew_armor = false;
			self.armor_wait = 0;	

		}

		wait 0.05;		
	}	
	
}

	
