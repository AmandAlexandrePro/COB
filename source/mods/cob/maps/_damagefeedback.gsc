#include maps\_hud_util;
// MikeD (12/17/2007): Not called anywhere
init()
{
	//precacheShader( "damage_feedback" );
	
	//if ( getDvar( "scr_damagefeedback" ) == "" )
	//	setDvar( "scr_damagefeedback", "0" );

	//if ( !getDvarInt( "scr_damagefeedback" ) )
	//	return;

	self.hud_damagefeedback = newClientHUDElem( self );
	self.hud_damagefeedback.horzAlign = "center";
	self.hud_damagefeedback.vertAlign = "middle";
	self.hud_damagefeedback.x = -12;
	self.hud_damagefeedback.y = -12;
	self.hud_damagefeedback.alpha = 0;
	self.hud_damagefeedback.archived = true;
	self.hud_damagefeedback SetShader( "damage_feedback", 24, 48 );
}

monitorDamage()
{
	//if ( !getDvarInt( "scr_damagefeedback" ) )
	//	return;
	
}

updateDamageFeedback( Zomb )
{
	if ( !IsPlayer( self ) || !IsDefined( self ) )
		return;
	if( !IsDefined( self.hud_damagefeedback ) )
		return;

	self notify( "updatefeedback" );
	self endon( "updatefeedback" );
	
	if( IsDefined( Zomb ) && Zomb animscripts\utility::damageLocationIsAny( "head", "helmet", "neck" ) )
		self playlocalsound( "bullet_impact_headshot_helmet_nodie" );
	else	
		self playlocalsound( "MP_hit_alert" );
	
	self.hud_damagefeedback.alpha = 1;
	self.hud_damagefeedback fadeOverTime( 1 );
	self.hud_damagefeedback.alpha = 0;
}