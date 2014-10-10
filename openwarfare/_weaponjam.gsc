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

#include maps\mp\gametypes\_hud_util;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;

init()
{
	// Get the main module's dvar
	level.scr_weaponjams_enable = getdvarx( "scr_weaponjams_enable", "int", 0, 0, 1 );

	// If weapon jam is not enabled we'll stay in this module anyway as it's the one handling
	// the weapon sounds when they are empty

	if ( level.scr_weaponjams_enable == 1 ) {
		// Precache some shaders we'll be using and load an array with a shader for each weapon
		precacheShader( "jammed" );
		thread loadWS();
		
		// Get the rest of the module's dvars
		level.scr_weaponjams_probability = getdvarx( "scr_weaponjams_probability", "int", 250, 10, 1000 );	
		level.scr_weaponjams_gap_time = getdvarx( "scr_weaponjams_gap_time", "float", 0, 0, 300 ) * 1000;		
	}

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
		
	// There's no need to start the following thread if we are only playing the empty sounds
	if ( level.scr_weaponjams_enable == 1 ) {
		self thread addNewEvent( "onPlayerKilled", ::onPlayerKilled );
	}
}


onPlayerSpawned()
{
	self thread emptyWeaponSounds();
	
	// Check if we need to start the weapon jammer thread
	if ( level.scr_weaponjams_enable == 1 ) {
		// Initialize some internal variables
		self.jammedWeapon = [];
		self.jammedWeapon["unjamming"] = false;
		self.lastJam = level.scr_weaponjams_gap_time * -1;
		
		// Create the HUD elements will be using to indicate the weapon is jammed
		if ( !isDefined( self.jammedWeapon["shader"] ) ) {
			self.jammedWeapon["shader"] = createIcon( "white", 64, 32 );
			self.jammedWeapon["shader"].alpha = 0;
			self.jammedWeapon["shader"].sort = -1;
			self.jammedWeapon["shader"] setPoint( "CENTER", "BOTTOM", 0, -32 );
			self.jammedWeapon["shader"].archived = true;
			self.jammedWeapon["shader"].hideWhenInMenu = true;
			
			self.jammedWeapon["jammed"] = createIcon( "jammed", 12, 12 );
			self.jammedWeapon["jammed"].alpha = 0;
			self.jammedWeapon["jammed"] setPoint( "CENTER", "BOTTOM", 5, -37 );
			self.jammedWeapon["jammed"].archived = true;
			self.jammedWeapon["jammed"].hideWhenInMenu = true;			
		}
		
		self thread weaponJammer();
		self thread showWeaponJammed();
	}
}


onPlayerKilled()
{
	if ( isDefined( self.jammedWeapon ) && isDefined( self.jammedWeapon["shader"] ) ) {
		self.jammedWeapon["shader"] destroy();
		self.jammedWeapon["jammed"] destroy();
	}
}


emptyWeaponSounds()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	for (;;)
	{
		wait (0.05);
		
		// Get the current weapon
		currentWeapon = self getCurrentWeapon();
		
		// Check if the player is pressing the attack key and the current weapon is empty
		if ( self attackButtonPressed() && self getAmmoCount( currentWeapon ) == 0 ) {
			// Make sure the gun is not empty because it's actually jammed
			if ( level.scr_weaponjams_enable == 0 || !isDefined( self.jammedWeapon[currentWeapon] ) || !isDefined( self.jammedWeapon[currentWeapon]["jammed"] ) || !self.jammedWeapon[currentWeapon]["jammed"] ) {
				
				// Determine which sound we need to play based on the current weapon
				switch ( weaponClass( currentWeapon ) )
				{
					case "pistol":
						emptyFireSound = "dryfire_pistol";
						break;
					case "mg":
					case "smg":
						emptyFireSound = "dryfire_smg";
						break;
					case "spread":
					case "rifle":
						emptyFireSound = "dryfire_rifle";
						break;
					default:
						emptyFireSound = "";
						break;
				}
				// Check if we need to play a sound
				if ( emptyFireSound != "" ) {
					// Play the sound
					self playLocalSound( emptyFireSound );
					
					// Wait for the player to release the attack button
					while( self attackButtonPressed() )
						wait (0.05);
				}
			}
		}				
	}	
}


weaponJammer()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );
	
	for (;;)
	{
		wait (0.05);

		if ( openwarfare\_timer::getTimePassed() - self.lastJam > level.scr_weaponjams_gap_time ) {
			// Get the current weapon
			currentWeapon = self getCurrentWeapon();		

			// Check if this weapon can jam and that it's not already jammed
			if ( isDefined( level.ws[ currentWeapon ] ) && ( !isDefined( self.jammedWeapon[currentWeapon] ) || !self.jammedWeapon[currentWeapon]["jammed"] ) ) {
				// Make sure this weapon has more than one round of ammo left
				currentAmmo = self getAmmoCount( currentWeapon );
				if ( currentAmmo > 1 ) {
					// Check if we should jam the weapon or not
					if ( self attackButtonPressed() && randomInt( level.scr_weaponjams_probability ) == 1 && !self isPlayerNearTurret() ) {
						// We need to jam the weapon!! I hope the poor guy is not in a big firefight... 
						if ( !isDefined( self.jammedWeapon[currentWeapon] ) ) {
							self.jammedWeapon[currentWeapon] = [];
						}
						self.jammedWeapon[currentWeapon]["jammed"] = true;
						self.jammedWeapon[currentWeapon]["ammo"] = self getAmmoCount( currentWeapon ) - 1;
						
						// Remove the ammo from the weapon
						self setWeaponAmmoStock( currentWeapon, 0 );
						self setWeaponAmmoClip( currentWeapon, 0 );	
						wait (0.5);
						//self playLocalSound( game["voice"][self.pers["team"]] + "rsp_comeon" );
					}				
				}
			}
		}
	}	
}


showWeaponJammed()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	blinkState = 0;
	
	for (;;)
	{
		wait (0.05);

		// Get the current weapon
		currentWeapon = self getCurrentWeapon();

		// Check if the current weapon is jammed and display the shaders
		if ( isDefined( self.jammedWeapon[currentWeapon] ) && isDefined( self.jammedWeapon[currentWeapon]["jammed"] ) && self.jammedWeapon[currentWeapon]["jammed"] ) {
			// Remove any ammo that the player might pick up while the gun is jammed
			currentAmmo = self getAmmoCount( currentWeapon );
			if ( currentAmmo > 0 && !self.jammedWeapon["unjamming"] ) {
				self.jammedWeapon[currentWeapon]["ammo"] += currentAmmo;
				self setWeaponAmmoStock( currentWeapon, 0 );
				self setWeaponAmmoClip( currentWeapon, 0 );					
			}
			
			self.jammedWeapon["shader"] setShader( level.ws[currentWeapon], 64, 32);
			blinkState = !blinkState;
			self.jammedWeapon["shader"].alpha = blinkState;
			self.jammedWeapon["jammed"].alpha = blinkState;
			wait (0.5);
		} else {
			blinkState = 0;
			self.jammedWeapon["shader"].alpha = 0;
			self.jammedWeapon["jammed"].alpha = 0;				
		}
	}		
}


unjamWeapon()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Get the current weapon
	currentWeapon = self getCurrentWeapon();
	
	// Check if weapon jam is enabled, the player is not already unjamming the weapon and that the current weapon is really jammed
	if ( level.scr_weaponjams_enable == 0 || self.jammedWeapon["unjamming"] || !isDefined( self.jammedWeapon[currentWeapon] ) || !isDefined( self.jammedWeapon[currentWeapon]["jammed"] ) || !self.jammedWeapon[currentWeapon]["jammed"] ) 
		return;

	// Unjam the weapon
	self.jammedWeapon["unjamming"] = true;
	self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
	self setWeaponAmmoStock( currentWeapon, self.jammedWeapon[currentWeapon]["ammo"] );
	self playLocalSound( "scramble" );

	xWait(1.5);

	self.jammedWeapon[currentWeapon]["ammo"] = 0;
	self.jammedWeapon[currentWeapon]["jammed"] = false;
	self.jammedWeapon["unjamming"] = false;
	self thread maps\mp\gametypes\_gameobjects::_enableWeapon();	
}


loadWS()
{
	// Load all the weapon shaders
	level.ws = [];

	// Rifles
	level.ws[ "svt40_mp" ] = "weapon_svt40";
	level.ws[ "svt40_telescopic_mp" ] = "weapon_svt40";
	level.ws[ "svt40_flash_mp" ] = "weapon_svt40";
	precacheShader( "weapon_svt40" );

	level.ws[ "gewehr43_gl_mp" ] = "weapon_gewehr43";
	level.ws[ "gewehr43_mp" ] = "weapon_gewehr43";
	precacheShader( "weapon_gewehr43" );

	level.ws[ "m1garand_bayonet_mp" ] = "weapon_m1garand";
	level.ws[ "m1garand_gl_mp" ] = "weapon_m1garand";
	level.ws[ "m1garand_mp" ] = "weapon_m1garand";
	level.ws[ "m1garand_flash_mp" ] = "weapon_m1garand";
	precacheShader( "weapon_m1garand" );

	level.ws[ "svt40_aperture_mp" ] = "weapon_stg44";
	level.ws[ "stg44_mp" ] = "weapon_stg44";
	level.ws[ "stg44_telescopic_mp" ] = "weapon_stg44";
	level.ws[ "stg44_flash_mp" ] = "weapon_stg44";
	precacheShader( "weapon_stg44" );

	level.ws[ "m1carbine_bayonet_mp" ] = "weapon_m1carbine";
	level.ws[ "m1carbine_bigammo_mp" ] = "weapon_m1carbine";
	level.ws[ "m1carbine_mp" ] = "weapon_m1carbine";
	level.ws[ "m1carbine_flash_mp" ] = "weapon_m1carbine";
	precacheShader( "weapon_m1carbine" );


	// Submachine guns
	level.ws[ "thompson_aperture_mp" ] = "weapon_thompson";
	level.ws[ "thompson_bigammo_mp" ] = "weapon_thompson";
	level.ws[ "thompson_mp" ] = "weapon_thompson";
	level.ws[ "thompson_silenced_mp" ] = "weapon_thompson";
	precacheShader( "weapon_thompson" );

	level.ws[ "m1garand_scoped_mp" ] = "weapon_mp40";
	level.ws[ "mp40_aperture_mp" ] = "weapon_mp40";
	level.ws[ "mp40_bigammo_mp" ] = "weapon_mp40";
	level.ws[ "mp40_mp" ] = "weapon_mp40";
	level.ws[ "mp40_silenced_mp" ] = "weapon_mp40";
	precacheShader( "weapon_mp40" );

	level.ws[ "type100smg_aperture_mp" ] = "weapon_type100_smg";
	level.ws[ "type100smg_bigammo_mp" ] = "weapon_type100_smg";
	level.ws[ "type100smg_mp" ] = "weapon_type100_smg";
	level.ws[ "type100smg_silenced_mp" ] = "weapon_type100_smg";
	precacheShader( "weapon_type100_smg" );

	level.ws[ "m1carbine_aperture_mp" ] = "weapon_ppsh";
	level.ws[ "ppsh_aperture_mp" ] = "weapon_ppsh";
	level.ws[ "ppsh_bigammo_mp" ] = "weapon_ppsh";
	level.ws[ "ppsh_mp" ] = "weapon_ppsh";
	precacheShader( "weapon_ppsh" );


	// Shotguns
	level.ws[ "shotgun_bayonet_mp" ] = "weapon_shotgun4";
	level.ws[ "shotgun_grip_mp" ] = "weapon_shotgun4";
	level.ws[ "shotgun_mp" ] = "weapon_shotgun4";
	precacheShader( "weapon_shotgun4" );

	level.ws[ "doublebarreledshotgun_grip_mp" ] = "weapon_double_barreled_shotgun";
	level.ws[ "doublebarreledshotgun_mp" ] = "weapon_double_barreled_shotgun";
	level.ws[ "doublebarreledshotgun_sawoff_mp" ] = "weapon_double_barreled_sawed";
	precacheShader( "weapon_double_barreled_shotgun" );
	precacheShader( "weapon_double_barreled_sawed" );
	

	// Machine guns
	level.ws[ "type99lmg_bayonet_mp" ] = "weapon_type99_lmg";
	level.ws[ "type99lmg_bipod_mp" ] = "weapon_type99_lmg";
	level.ws[ "type99lmg_mp" ] = "weapon_type99_lmg";
	precacheShader( "weapon_type99_lmg" );

	level.ws[ "stg44_aperture_mp" ] = "weapon_bar";
	level.ws[ "gewehr43_silenced_mp" ] = "weapon_bar";
	level.ws[ "bar_bipod_mp" ] = "weapon_bar";
	level.ws[ "bar_mp" ] = "weapon_bar";
	precacheShader( "weapon_bar" );

	level.ws[ "dp28_bipod_mp" ] = "weapon_dp28";
	level.ws[ "dp28_mp" ] = "weapon_dp28";
	precacheShader( "weapon_dp28" );

	level.ws[ "mg42_bipod_mp" ] = "weapon_mg42";
	level.ws[ "mg42_mp" ] = "weapon_mg42";
	precacheShader( "weapon_mg42" );
	
	level.ws[ "gewehr43_telescopic_mp" ] = "weapon_fg42";
	level.ws[ "mp40_aperture_mp" ] = "weapon_fg42";
	level.ws[ "gewehr43_aperture_mp" ] = "weapon_fg42";
	level.ws[ "fg42_bipod_mp" ] = "weapon_fg42";
	level.ws[ "fg42_mp" ] = "weapon_fg42";
	level.ws[ "fg42_telescopic_mp" ] = "weapon_fg42";
	precacheShader( "weapon_fg42" );

	level.ws[ "30cal_bipod_mp" ] = "weapon_30cal";
	level.ws[ "30cal_mp" ] = "weapon_30cal";
	precacheShader( "weapon_30cal" );

	return;
}

weaponJamStatus(currentWeapon)
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Check if the current weapon is jammed
	if ( isDefined( self.jammedWeapon[currentWeapon] ) && isDefined( self.jammedWeapon[currentWeapon]["jammed"] ) && self.jammedWeapon[currentWeapon]["jammed"] ) 
	{
		return true;
	}
	
	else
	{
	return false;
	}

}