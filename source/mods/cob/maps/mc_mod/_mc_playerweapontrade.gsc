#include common_scripts\utility;
#include maps\_zombiemode_utility;
#include maps\_utility;
#include maps\_hud_util;

/*
#####################
by: M.A.K.E C E N T S
#####################
Script:
Place the following
    maps\mc_mod\_mc_playerweapontrade::init(  );
above
    maps\_zombiemode::main();
in your mapname.gsc
###############################################################################
*/

init(){
	PrecacheShader("weapontrade");
	level.costtotrade = undefined;
	level.tradeguntimer = 2;
	thread SetUp();
}

SetUp(){
	players = get_players();
	for( i=0;i<players.size;i++ ){
		players[i] thread CheckLooking();
		// players[i] thread TradeHud("testing");
	}
}

CheckLooking(){
	self.trading = 0;
	while(1){
		players = get_players();//maps\_utility.gsc:
		if(players.size<=1) return;
		for( i=0;i<players.size;i++ ){
			if(self == players[i]) continue;
			if(self CanTrade(players[i]) && !self.trading && !players[i].trading){
				while(self CanTrade(players[i])){
					wait(.1);
					self thread TradeHud("Appuyez et maintenez [{+activate}] pour échanger votre arme");
					// IPrintLnBold( "set hint string to we can trade" );
					if(self UseButtonPressed()) self ProgressTrade(players[i]);
				}
				self.trading = 0;
			}
		}
		wait(.1);
	}
}

ProgressTrade(player){
	self endon( "disconnect" );
	player endon( "disconnect" );
	self DisableWeaponCycling(  );
	timer = level.tradeguntimer;
	self.PBar = self CreatePrimaryProgressBar();
	self.PBar.color = ( .5, 1, 1 );
	self.PBar UpdateBar( 0.01, 1/level.tradeguntimer );
	while(self UseButtonPressed() && timer>0 && self CanTrade(player)){
		wait(.1);
		timer = timer-.1;
	}
	if(timer>0){
		self thread KillHuds();
		return;
	}
	self.trading = 1;
	while(self UseButtonPressed() && self CanTrade(player) && !player.trading){
		self thread TradeHud("Attente de l'autre joueur");
		wait(.1);
	}
	self thread KillHuds();
	if(self.trading && player.trading){
		self Trade(player);
		while(self UseButtonPressed()) wait(.1);
	}
	self.trading = 0;
	
}

KillHuds(){
	self EnableWeaponCycling(  );
	if(IsDefined( self.PBar )){
		self.PBar destroyElem();
		self.PBar = undefined;
	}
	if(IsDefined( self.tradehud )){
		self.tradehud destroy();
		self.weapontrader destroy();
		self.weapontrader = undefined;
		self.tradehud = undefined;

	}
}

Trade(player){
	selfweapon = self GetCurrentWeapon();
	playerweapon = player GetCurrentWeapon();
	stockammo = player GetWeaponAmmoStock(playerweapon);
	clipammo = player GetWeaponAmmoClip(playerweapon);
	self.trading = 2;
	while(player.trading==1) wait(.1);//wait to make sure the other player gets current weapons too.
	self thread KillHuds();
	if(IsDefined( level.costtotrade )) self maps\_zombiemode_score::minus_to_player_score( level.costtotrade );
	self TakeWeapon( selfweapon );
	self GiveWeapon( playerweapon );
	self SetWeaponAmmoStock(playerweapon, stockammo);
	self SetWeaponAmmoClip(playerweapon, clipammo);
	self switchToWeapon(playerweapon);
}

CanTrade(player){
	self endon( "disconnect" );
	player endon( "disconnect" );
	if(IsDefined( player.sessionstate) && player.sessionstate == "spectator") return false;
	if(IsDefined( self.sessionstate) && self.sessionstate == "spectator") return false;
	if(!is_player_valid( player )) return false;
	if(!is_player_valid( self )) return false;
	if(IsSubStr( self getCurrentWeapon(), "minigun_zm") || IsSubStr( self getCurrentWeapon(),"bottle" ) || IsSubStr( player getCurrentWeapon(), "minigun_zm") || IsSubStr( player getCurrentWeapon(),"bottle" )) return false;
	if(IsDefined( level.costtotrade ) && (player.score+5) < level.costtotrade) return false;
	if(!self isOnGround() || self maps\_laststand::player_is_in_laststand()  || player maps\_laststand::player_is_in_laststand() || !self isLookingAtMe( player ) || !player isLookingAtMe( self )){
		self thread TradeHud("");
		if(IsDefined( self.tradehud )){
			self.tradehud destroy();
			self.tradehud = undefined;
			self.weapontrader destroy();
		self.weapontrader = undefined;
		}
		return false;
	}
	if(Distance( self.origin,player.origin )<50 ){
		if(self CheckHasWeapon(player)) return false;
		// if(player CheckHasWeapon(self)) return false;
		return true;
	}
	return false;
}

CheckHasWeapon(player){
	gun = self GetCurrentWeapon();
	if(IsSubStr(gun,"bottle") || gun == "mine_bouncing_betty" || gun == "minigun_zm") {
		self thread TradeHud("Échange indisponible contre cette arme");
		player thread TradeHud("Échange indisponible contre cette arme");
		return true;//add other weapons not to trade here
	}
	if(gun == "none" || WeaponClass(gun) == "grenade") return true;
	if(!isDefined(gun) || !isDefined(self) || !isDefined(player) ) return true;
	if(player HasWeapon( gun )){
		if(self Hasweapon(player getCurrentWeapon())){
			self thread TradeHud("L'autre joueur possède cette arme");
		}else{
			self thread TradeHud("L'autre joueur possède cette arme");
			player thread TradeHud("Vous possédez déjà l'arme que l'autre veut échanger");
		}
		return true;
	}
	if(self Hasweapon(player getCurrentWeapon())){

		return true;
	}
	return false;
}

isLookingAtMe(trig){
	if(Distance2d( self.origin,trig.origin )>50) return false;
	angles = vectortoAngles((trig.origin+(0,0,50)) - self.origin);
	trigangle = angles[1];
	myangle = self.angles[1];
	if(trigangle > 180){
		trigangle = trigangle - 360;
	}
	looking = (myangle-trigangle);
	if(looking>340){
		looking = looking - 360;
	}
	if(looking < -340){
		looking = looking + 360;
	}
	if(looking > -35 && looking < 35 ){ 
		return 1;
	}
	return 0;
}

TradeHud(text){
	if(IsDefined( self.tradehud )){
		self.tradehud SetText( text );
		return;
	}


	self.weapontrader = create_simple_hud( self );
	self.weapontrader.foreground = true; 
	self.weapontrader.sort = 1; 
	self.weapontrader.hidewheninmenu = false; 
	self.weapontrader.alignX = "center"; 
	self.weapontrader.alignY = "middle";
	self.weapontrader.horzAlign = "center"; 
	self.weapontrader.vertAlign = "middle";
	self.weapontrader.x = 0; 
	self.weapontrader.y = 75; 
	self.weapontrader.alpha = 1;
	self.weapontrader SetShader( "weapontrade", 50, 50 );


	self.tradehud = create_simple_hud(self);
   	self.tradehud.horzAlign = "center";
   	self.tradehud.vertAlign = "middle";
   	self.tradehud.alignX = "center";
   	self.tradehud.alignY = "middle";
   	self.tradehud.y = 125;
   	self.tradehud.x = 0;
   	self.tradehud.foreground = 1;
   	self.tradehud.fontscale = 8.0;
   	self.tradehud.alpha = 1;
   	self.tradehud.color = ( .5, 1, 1 );
   	self.tradehud SetText(text);
}