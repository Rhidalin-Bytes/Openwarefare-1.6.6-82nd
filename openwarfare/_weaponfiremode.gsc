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
//******************************************************************************

#include openwarfare\_eventmanager;
#include openwarfare\_utils;


init()
{

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );	
	precacheShader( "hud_fire_mode_s" );
	precacheShader( "hud_fire_mode_f" );
	precacheShader( "hud_fire_mode_b" );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerDeath", ::onPlayerDeath );
}	


onPlayerSpawned()
{
	//self.altFireMode = "semi";
	self.semiAction = false;
	
	//create hud icon
	/* 
	if (!isDefined(self.hud_fireMode_icon))
	{
		self.hud_fireMode_icon = newClientHudElem( self );
		self.hud_fireMode_icon.x = 350;
		self.hud_fireMode_icon.y = 130;
		self.hud_fireMode_icon.alignX = "center";
		self.hud_fireMode_icon.alignY = "middle";
		self.hud_fireMode_icon.horzAlign = "center_safearea";
		self.hud_fireMode_icon.vertAlign = "center_safearea";
		self.hud_fireMode_icon.archived = false;
		self.hud_fireMode_icon.hideWhenInMenu = true;
		self.hud_fireMode_icon.alpha = 0;
	}
	currentWeapon = self getCurrentWeapon();
	
	//switch hud icon when weapon state changes
	for(;;)
	{
		currentWeapon = self getCurrentWeapon();
		if (isDefined( currentWeapon))
		{ 
			if ( isSubStr( "mp40_mp;ppsh_mp;fg42_mp;stg44_mp;thompson_mp;type100smg_mp;bar_mp;bar_bipod_mp;fg42_bipod_mp;fg42_telescopic_mp;mp40_bigammo_mp;ppsh_bigammo_mp;stg44_telescopic_mp;thompson_bigammo_mp;type100smg_bigammo_mp", currentWeapon ) )
			{
				self.hud_fireMode_icon.alpha = 1;
				self.hud_fireMode_icon setShader( "hud_fire_mode_f", 48, 24);
				
			}
			else if ( isSubStr( "mp40_silenced_mp;ppsh_aperture_mp;mp40_aperture_mp;stg44_flash_mp;thompson_silenced_mp;type100smg_silenced_mp;stg44_aperture_mp;gewehr43_silenced_mp;gewehr43_aperture_mp;gewehr43_telescopic_mp;m1garand_scoped_mp;m1carbine_aperture_mp;svt40_aperture_mp;thompson_aperture_mp;type100smg_aperture_mp", currentWeapon ) ) 
			{
				self.hud_fireMode_icon.alpha = 1;
				self.hud_fireMode_icon setShader( "hud_fire_mode_s", 48, 24);

			}
			else
			{
				self.hud_fireMode_icon.alpha = 0;
			}
			
		}

		wait (0.05);
	}
	*/
}


toggleFireMode()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	// Make sure the current weapon supports an semi-auto action
	currentWeapon = self getCurrentWeapon();
	autoAction = validForAutoAction( currentWeapon );
	semiAction = validFoSemiAction( currentWeapon);

	if ( autoAction != "" || semiAction ) {
		// Initiate fire mode switch. If there's already another action running we'll cancel the request
		if ( self.semiAction ) {
			return;
		} else {
			self.semiAction = true;
		}
		
		// Get the ammo info for the current weapon
		grenadeLauncherAttachment = weaponAltWeaponName( currentWeapon );
		if ( grenadeLauncherAttachment != "none")
		{
			grenadeLauncherTotalAmmo = self getAmmoCount( grenadeLauncherAttachment );
			grenadeLauncherClipAmmo = self getWeaponAmmoClip( grenadeLauncherAttachment );
		}
		else
		{
			grenadeLauncherTotalAmmo = 0;
			grenadeLauncherClipAmmo = 0;
		}
		totalAmmo = self getAmmoCount( currentWeapon );
		clipAmmo = self getWeaponAmmoClip( currentWeapon );
		
		// Disable the player's weapons
		//self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
				
		// Wait for certain time to complete the requested action
		xWait (0.1);
		
		// Take the current weapon from the player
		self takeWeapon( currentWeapon );
		
		// Check which weapon we should give in exchange
		if ( autoAction != "" ) 
		{
			// Construct the name of the weapon in full-auto mode
			
			if ( isSubStr( currentWeapon, "mp40_silenced_mp" ) )
			{
				newWeapon = "mp40_mp";
			}
			
			else if ( isSubStr( currentWeapon, "ppsh_aperture_mp" ) )
			{
				newWeapon = "ppsh_mp";
			}
			
			else if ( isSubStr( currentWeapon, "mp40_aperture_mp" ) )
			{
				newWeapon = "fg42_mp";
			}
			
			else if ( isSubStr( currentWeapon, "stg44_flash_mp" ) )
			{
				newWeapon = "stg44_mp";
			}
			
			else if ( isSubStr( currentWeapon, "thompson_silenced_mp" ) )
			{
				newWeapon = "thompson_mp";
			}
			
			else if ( isSubStr( currentWeapon, "type100smg_silenced_mp" ) )
			{
				newWeapon = "type100smg_mp";
			}
			
			else if ( isSubStr( currentWeapon, "stg44_aperture_mp" ) )
			{
				newWeapon = "bar_mp";
			}
			else if ( isSubStr( currentWeapon, "gewehr43_silenced_mp" ) )
			{
				newWeapon = "bar_bipod_mp";
			}
			else if ( isSubStr( currentWeapon, "gewehr43_aperture_mp" ) )
			{
				newWeapon = "fg42_bipod_mp";
			}
			else if ( isSubStr( currentWeapon, "gewehr43_telescopic_mp" ) )
			{
				newWeapon = "fg42_telescopic_mp";
			}
			else if ( isSubStr( currentWeapon, "m1garand_scoped_mp" ) )
			{
				newWeapon = "mp40_bigammo_mp";
			}
			else if ( isSubStr( currentWeapon, "m1carbine_aperture_mp" ) )
			{
				newWeapon = "ppsh_bigammo_mp";
			}
			else if ( isSubStr( currentWeapon, "svt40_aperture_mp" ) )
			{
				newWeapon = "stg44_telescopic_mp";
			}
			else if ( isSubStr( currentWeapon, "thompson_aperture_mp" ) )
			{
				newWeapon = "thompson_bigammo_mp";
			}
			else if ( isSubStr( currentWeapon, "type100smg_aperture_mp" ) )
			{
				newWeapon = "type100smg_bigammo_mp";
			}
			
			
			else
			{
				newWeapon = "";
			}
			//newWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - autoAction.size - 2 ) + "_mp";
			self.altFireMode = autoAction;
			/*
			if ( isSubStr( "m16_gl_mp;m16_mp;m16_reflex_mp;m16_silencer_mp", newWeapon ) )
			{
				self.hud_fireMode_icon setShader( "hud_fire_mode_b", 48, 24);
			}
			else
			{
				self.hud_fireMode_icon setShader( "hud_fire_mode_f", 48, 24);
			}
			*/
		} else {
			// Construct the name of the weapon in semi-auto mode
			
			if ( isSubStr( currentWeapon, "mp40_mp" ) )
			{
				newWeapon = "mp40_silenced_mp";
			}
			
			else if ( isSubStr( currentWeapon, "ppsh_mp" ) )
			{
				newWeapon = "ppsh_aperture_mp";
			}
			
			else if ( isSubStr( currentWeapon, "fg42_mp" ) )
			{
				newWeapon = "mp40_aperture_mp";
			}
			
			else if ( isSubStr( currentWeapon, "stg44_mp" ) )
			{
				newWeapon = "stg44_flash_mp";
			}
			
			else if ( isSubStr( currentWeapon, "thompson_mp" ) )
			{
				newWeapon = "thompson_silenced_mp";
			}
			
			else if ( isSubStr( currentWeapon, "type100smg_mp" ) )
			{
				newWeapon = "type100smg_silenced_mp";
			}
			
			else if ( isSubStr( currentWeapon, "bar_mp" ) )
			{
				newWeapon = "stg44_aperture_mp";
			}
			else if ( isSubStr( currentWeapon, "bar_bipod_mp" ) )
			{
				newWeapon = "gewehr43_silenced_mp";
			}
			else if ( isSubStr( currentWeapon, "fg42_bipod_mp" ) )
			{
				newWeapon = "gewehr43_aperture_mp";
			}
			else if ( isSubStr( currentWeapon, "fg42_telescopic_mp" ) )
			{
				newWeapon = "gewehr43_telescopic_mp";
			}
			else if ( isSubStr( currentWeapon, "mp40_bigammo_mp" ) )
			{
				newWeapon = "m1garand_scoped_mp";
			}
			else if ( isSubStr( currentWeapon, "ppsh_bigammo_mp" ) )
			{
				newWeapon = "m1carbine_aperture_mp";
			}
			else if ( isSubStr( currentWeapon, "stg44_telescopic_mp" ) )
			{
				newWeapon = "svt40_aperture_mp";
			}
			else if ( isSubStr( currentWeapon, "thompson_bigammo_mp" ) )
			{
				newWeapon = "thompson_aperture_mp";
			}
			else if ( isSubStr( currentWeapon, "type100smg_bigammo_mp" ) )
			{
				newWeapon = "type100smg_aperture_mp";
			}
			
			
			//newWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - 3 ) + self.altFireMode + "mp";
			else
			{
				newWeapon = "";
			}
			
			//self.altFireMode = "";					
			//self.hud_fireMode_icon setShader( "hud_fire_mode_s", 48, 24);
		}
		
		if ( isDefined( self.camo_num ) ) {
			self giveWeapon( newWeapon, self.camo_num );
		} else {
			self giveWeapon( newWeapon );
		}
			
		// Assign the proper ammo again
		self setWeaponAmmoClip( newWeapon, clipAmmo );
		self setWeaponAmmoStock( newWeapon, totalAmmo - clipAmmo );
		if ( grenadeLauncherAttachment != "none")
		{
			self setWeaponAmmoClip( grenadeLauncherAttachment, grenadeLauncherClipAmmo );
			self setWeaponAmmoStock( grenadeLauncherAttachment, grenadeLauncherTotalAmmo - grenadeLauncherClipAmmo);
		}
			
		self switchToWeapon( newWeapon );
		self playLocalSound("dryfire_rifle");
		//self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self.semiAction = false;		
	}	
}


validForAutoAction( currentWeapon )
{
	// Check if the current weapon is valid for auto
	if ( !self thread openwarfare\_weaponjam::weaponJamStatus(currentWeapon) )
	{
		if ( isSubStr( "mp40_silenced_mp;ppsh_aperture_mp;mp40_aperture_mp;stg44_flash_mp;thompson_silenced_mp;type100smg_silenced_mp;stg44_aperture_mp;gewehr43_silenced_mp;gewehr43_aperture_mp;gewehr43_telescopic_mp;m1garand_scoped_mp;m1carbine_aperture_mp;svt40_aperture_mp;thompson_aperture_mp;type100smg_aperture_mp", currentWeapon ) ) {
			return "semi";
		} else {
			return "";
		}
	}
	else
	{
		return "";
	}
}


validFoSemiAction( currentWeapon )
{
	// Check if the current weapon is valid for semi
	if ( !self thread openwarfare\_weaponjam::weaponJamStatus(currentWeapon) )
	{
		if ( isSubStr( "mp40_mp;ppsh_mp;fg42_mp;stg44_mp;thompson_mp;type100smg_mp;bar_mp;bar_bipod_mp;fg42_bipod_mp;fg42_telescopic_mp;mp40_bigammo_mp;ppsh_bigammo_mp;stg44_telescopic_mp;thompson_bigammo_mp;type100smg_bigammo_mp", currentWeapon ) ) {
			return true;
		}
		
		return false;	
	}
	else
	{
		return false;
	}
}

onPlayerDeath()
{
		//self.hud_fireMode_icon.alpha = 0;
}