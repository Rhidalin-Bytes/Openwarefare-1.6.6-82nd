//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
//
//            Website: http://openwarfaremod.com/
// 82ndAB	: onDamageTaken() - Warning player broke their ankle. player can break other ankle
//								Dvar added: scr_de_break_ankle_on_fall_percent - adjusts the percentage of speed player loses from broken ankle
//******************************************************************************

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	// Load the the module's dvars
	level.scr_de_dropweapon_on_arm_hit = getdvarx( "scr_de_dropweapon_on_arm_hit", "int", 0, 0, 3 );
	level.scr_de_dropweapon_chance = getdvarx( "scr_de_dropweapon_chance", "int", 50, 0, 100 );
	
	level.scr_de_falldown_on_leg_hit = getdvarx( "scr_de_falldown_on_leg_hit", "int", 0, 0, 2 );
	level.scr_de_falldown_chance = getdvarx( "scr_damage_effect_falldown_chance", "int", 50, 0, 100 );
	
	level.scr_de_shiftview_on_damage = getdvarx( "scr_de_shiftview_on_damage", "int", 0, 0, 50 );
	
	level.scr_de_break_ankle_on_fall = getdvarx( "scr_de_break_ankle_on_fall", "int", 0, 0, 75 );
	level.scr_de_break_ankle_on_fall_percent = getdvarx( "scr_de_break_ankle_on_fall_percent", "int", 50, 0, 75);
	level.scr_de_slowdown_on_leg_hit = getdvarx( "scr_de_slowdown_on_leg_hit", "int", 0, 0, 75 );

	// Make sure we need to still stay here
	if ( level.scr_de_dropweapon_on_arm_hit == 0 && level.scr_de_falldown_on_leg_hit == 0 && level.scr_de_shiftview_on_damage == 0 && level.scr_de_break_ankle_on_fall == 0 && level.scr_de_slowdown_on_leg_hit == 0 )
		return;

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
	precacheShader( "hud_ankle_break" );
	precacheShader( "hud_ankle_strap" );
}

onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );

}

onPlayerSpawned()
{
	self thread onDamageTaken();
	self.hud_ankleBreak_icon = newClientHudElem( self );
	self.hud_ankleBreak_icon.x = -360;
	self.hud_ankleBreak_icon.y = 200;
	self.hud_ankleBreak_icon.alignX = "center";
	self.hud_ankleBreak_icon.alignY = "middle";
	self.hud_ankleBreak_icon.horzAlign = "center_safearea";
	self.hud_ankleBreak_icon.vertAlign = "center_safearea";
	self.hud_ankleBreak_icon.archived = true;
	self.hud_ankleBreak_icon.hideWhenInMenu = true;
	self.hud_ankleBreak_icon setShader( "hud_ankle_break", 24, 24);
	self.hud_ankleBreak_icon.alpha = 0;
	
	self.ankleBroken = false;
	self.bothAnklesBroken = false;
	self.ankleFail = false;
}

onDamageTaken()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	for(;;)
	{
		self waittill("damage_taken", eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );

		// Make sure there was damage done
		if ( iDamage == 0 )
			continue;

		// Get the player's current weapon
		currentWeapon = self getCurrentWeapon();

		// Check if this a damage from a fall
		if ( sMeansOfDeath == "MOD_FALLING" ) {
			// Check if we need to slow down the player
			if ( level.scr_de_break_ankle_on_fall > 0 && iDamage > level.scr_de_break_ankle_on_fall ) {
				if ( !self.ankleBroken)
				{
					self thread openwarfare\_speedcontrol::setModifierSpeed( "_damageeffect_fall", level.scr_de_break_ankle_on_fall_percent );
					self ExecClientCommand("gocrouch");
				//82ndab: Warning player broke their ankle
					self iprintlnbold( &"OW_DE_BROKEN_ANKLE" );
					self.hud_ankleBreak_icon.alpha = 1;
					self.ankleBroken = true;
					self ExecClientCommand("goprone");
					wait (1);
					self ExecClientCommand("gocrouch");

					self thread maps\mp\gametypes\_gameobjects::_disableJump();
					self thread maps\mp\gametypes\_gameobjects::_disableSprint();

				}
				else
				{
				//82ndAB player breaks other ankle. forced to go prone
					if ( self.bothAnklesBroken )
					{
					self iprintlnbold( &"OW_DE_BROKEN_ANKLE_SERIOUS" );
					self.hud_ankleBreak_icon setShader( "hud_ankle_break", 24, 24);
					self.ankleFail = true;
					}
					else
					self iprintlnbold( &"OW_DE_BROKEN_ANKLE_AGAIN" );
					self thread maps\mp\gametypes\_gameobjects::_disableJump();
					self thread maps\mp\gametypes\_gameobjects::_disableSprint();
					self.ankleSplinted = false;
					self.hud_ankleBreak_icon setShader( "hud_ankle_break", 24, 24);
					
					
					while ( self.ankleBroken == true  && !self.ankleSplinted )
					{
						self.bothAnklesBroken = true;
						self ExecClientCommand("goprone");
						wait (0.05);
					}
				}	
			}			
			
		} else{
			// Check the location of the hit
			switch( sHitLoc )
			{
				case "gun":
				case "left_hand":
				case "right_hand":
					// Player was hit in the hands or the weapon. Check if we need to drop the player's weapon.
					if ( level.scr_de_dropweapon_on_arm_hit >= 1 ) {
						randomChance = randomIntRange( 0, 101 );
						if ( randomChance <= level.scr_de_dropweapon_chance ) {
							self playlocalsound("MP_hit_alert");
							self dropItem( currentWeapon );
						}
					}
					break;
	
				case "left_arm_lower":
				case "right_arm_lower":
					// Player was hit in the arm. Check if we need to drop the player's weapon.
					if ( level.scr_de_dropweapon_on_arm_hit >= 2 ) {
						randomChance = randomIntRange( 0, 101 );
						if ( randomChance <= level.scr_de_dropweapon_chance ) {
							self playlocalsound("MP_hit_alert");
							self dropItem( currentWeapon );
						}
					}
					break;
	
				case "left_arm_upper":
				case "right_arm_upper":
					// Player was hit in the arm. Check if we need to drop the player's weapon.
					if ( level.scr_de_dropweapon_on_arm_hit >= 3 ) {
						randomChance = randomIntRange( 0, 101 );
						if ( randomChance <= level.scr_de_dropweapon_chance ) {
							self playlocalsound("MP_hit_alert");
							self dropItem( currentWeapon );
						}
					}
					break;
	
				case "left_leg_upper":
				case "right_leg_upper":
					// Player was hit in the upper legs. Check if we need to slow him down.
					if ( level.scr_de_slowdown_on_leg_hit > 0 && iDamage >= level.scr_de_slowdown_on_leg_hit ) {
						self thread openwarfare\_speedcontrol::setModifierSpeed( "_damageeffect_leg", 50 );
					}
					break;
									
				case "left_leg_lower":
				case "left_foot":
				case "right_leg_lower":
				case "right_foot":
					// Player was hit in the lower legs. Check if we need to make the player fall to the ground.
					if ( level.scr_de_falldown_on_leg_hit > 0 ) {
						randomChance = randomIntRange( 0, 101 );
						if ( randomChance <= level.scr_de_falldown_chance ) {					
							self ExecClientCommand("gocrouch");
							self ExecClientCommand("goprone");
							if ( level.scr_de_falldown_on_leg_hit == 2 ) {
								self thread maps\mp\gametypes\_gameobjects::_disableSprint();
								self thread maps\mp\gametypes\_gameobjects::_disableJump();
								self thread openwarfare\_speedcontrol::setModifierSpeed( "_damageeffect_leg", 50 );
							}
						}
					}
					break;
			}

			// Check if we need to shift the player's view
			if ( level.scr_de_shiftview_on_damage > 0 &&  iDamage > level.scr_de_shiftview_on_damage ) {
				self shiftPlayerView( iDamage );
			}
		}
	}
}

onPlayerDeath()
{
		self.hud_ankleBreak_icon destroy();
}

strapAnkle()
{
	
	self.hud_ankleBreak_icon setShader( "hud_ankle_strap", 24, 24);
	return 0;
}