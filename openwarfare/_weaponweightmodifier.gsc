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
	// Get the main module's dvar
	level.scr_wwm_enabled = getdvarx( "scr_wwm_enabled", "int", 0, 0, 1 );

	// If weapon weight modifier is disabled then there's nothing else to do here
	if ( level.scr_wwm_enabled == 0 )
		return;

	thread loadWWM();

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}


onPlayerSpawned()
{
	self thread weaponWeightMonitoring();
}

weaponWeightMonitoring()
{
	self endon("disconnect");	
	self endon( "death" );
	level endon( "game_ended" );

	for (;;)
	{
		wait (0.5);

		// Make sure the player is alive after the wait time is over
		if ( !isDefined( self) )
			return;

		// Initialize variable to keep the total weight
		totalWeight = 0;

		// Get all the things that the player is carrying
		weaponsList = self getWeaponsList();
		for( i = 0; i < weaponsList.size; i++ )
		{
			// Get the weapon's name and type
			weapon = weaponsList[ i ];
			weaponType = weaponInventoryType( weapon );

			// If it's a grenade or item like C4, claymore or RPG get the ammo available
			if ( weaponType == "offhand" || weaponType == "item" ) {
				itemCount = self getAmmoCount( weapon );
			} else {
				itemCount = 1;
			}

			// Get the weight assigned to the weapon
			if ( isDefined( level.wwm[ weapon ] ) ) {
				totalWeight += getdvarx( level.wwm[ weapon ], "float", 0.0, 0.0, 10.0 ) * itemCount;
			} else {
				// Just for testing. Remove this line on release version!
				//self iprintln( "No weight defined for " + weapon );
			}
		}

		// Set the player's speed based on the weight of the items being carried
		rangeToUse = 0;
		while ( totalWeight > level.wwmWeights[ rangeToUse ] && rangeToUse < level.wwmWeights.size ) {
			rangeToUse++;
		}
		// If we reached the higher value we'll go back one
		if ( rangeToUse >= level.wwmWeights.size ) {
			rangeToUse--;
		}
		
		// Get the new speed
		newSpeed = level.wwmSpeeds[ rangeToUse ];
		//self iprintln( "wwmSpeeds.size: " + level.wwmSpeeds.size + "  wwmWeights.size: " + level.wwmWeights.size );
		//self iprintln( "Range used: " + rangeToUse + "  Total weight: " + totalWeight + "  New speed: " + newSpeed );
		
		// Make sure we are allowed to change the player's speed
		self thread openwarfare\_speedcontrol::setBaseSpeed( newSpeed );
	}
}


loadWWM()
{
	// Load the speed ranges
	level.wwmSpeeds = getDvarListx( "scr_wwm_range_speed_", "float", 0.0, 0.0, 1.5 );
	level.wwmWeights = getDvarListx( "scr_wwm_range_weight_", "float", 0.0, 0.0, 20.0 );
	// Make sure we have at least one element
	if ( level.wwmSpeeds.size == 0 || level.wwmWeights.size == 0 || level.wwmSpeeds.size != level.wwmWeights.size ) {
		level.wwmSpeeds[0] = 1.0;
		level.wwmWeights[0] = 20.0;
	}	

	// Load all the weapons with their corresponding dvar controlling it
	level.wwm = [];

	// Bolt Action Rifles
	level.wwm[ "springfield_bayonet_mp" ] = "scr_wwm_springfield";
	level.wwm[ "springfield_gl_mp" ] = "scr_wwm_springfield_gl";
	level.wwm[ "springfield_mp" ] = "scr_wwm_springfield";
	level.wwm[ "springfield_scoped_mp" ] = "scr_wwm_springfield";

	level.wwm[ "type99rifle_bayonet_mp" ] = "scr_wwm_type99rifle";
	level.wwm[ "type99rifle_gl_mp" ] = "scr_wwm_type99rifle_gl";
	level.wwm[ "type99rifle_mp" ] = "scr_wwm_type99rifle";
	level.wwm[ "type99rifle_scoped_mp" ] = "scr_wwm_type99rifle";
	
	level.wwm[ "mosinrifle_bayonet_mp" ] = "scr_wwm_mosinrifle";
	level.wwm[ "mosinrifle_gl_mp" ] = "scr_wwm_mosinrifle_gl";
	level.wwm[ "mosinrifle_mp" ] = "scr_wwm_mosinrifle";
	level.wwm[ "mosinrifle_scoped_mp" ] = "scr_wwm_mosinrifle";
	
	level.wwm[ "kar98k_bayonet_mp" ] = "scr_wwm_kar98k";
	level.wwm[ "kar98k_gl_mp" ] = "scr_wwm_kar98k_gl";
	level.wwm[ "kar98k_mp" ] = "scr_wwm_kar98k";
	level.wwm[ "kar98k_scoped_mp" ] = "scr_wwm_kar98k";
	
	level.wwm[ "ptrs41_mp" ] = "scr_wwm_ptrs41";


	// Rifles
	level.wwm[ "svt40_aperture_mp" ] = "scr_wwm_svt40";
	level.wwm[ "svt40_mp" ] = "scr_wwm_svt40";
	level.wwm[ "svt40_telescopic_mp" ] = "scr_wwm_svt40";
	level.wwm[ "svt40_flash_mp" ] = "scr_wwm_svt40";
	
	level.wwm[ "gewehr43_aperture_mp" ] = "scr_wwm_gewehr43";
	level.wwm[ "gewehr43_gl_mp" ] = "scr_wwm_gewehr43_gl";
	level.wwm[ "gewehr43_mp" ] = "scr_wwm_gewehr43";
	level.wwm[ "gewehr43_telescopic_mp" ] = "scr_wwm_gewehr43";
	level.wwm[ "gewehr43_silenced_mp" ] = "scr_wwm_gewehr43";
	
	level.wwm[ "m1garand_bayonet_mp" ] = "scr_wwm_m1garand";
	level.wwm[ "m1garand_gl_mp" ] = "scr_wwm_m1garand_gl";
	level.wwm[ "m1garand_mp" ] = "scr_wwm_m1garand";
	level.wwm[ "m1garand_scoped_mp" ] = "scr_wwm_m1garand";
	level.wwm[ "m1garand_flash_mp" ] = "scr_wwm_m1garand";

	level.wwm[ "stg44_aperture_mp" ] = "scr_wwm_stg44";
	level.wwm[ "stg44_mp" ] = "scr_wwm_stg44";
	level.wwm[ "stg44_telescopic_mp" ] = "scr_wwm_stg44";
	level.wwm[ "stg44_flash_mp" ] = "scr_wwm_stg44";
	
	level.wwm[ "m1carbine_aperture_mp" ] = "scr_wwm_m1carbine";
	level.wwm[ "m1carbine_bayonet_mp" ] = "scr_wwm_m1carbine";
	level.wwm[ "m1carbine_bigammo_mp" ] = "scr_wwm_m1carbine";
	level.wwm[ "m1carbine_mp" ] = "scr_wwm_m1carbine";
	level.wwm[ "m1carbine_flash_mp" ] = "scr_wwm_m1carbine";
	
	
	// Submachine guns
	level.wwm[ "thompson_aperture_mp" ] = "scr_wwm_thompson";
	level.wwm[ "thompson_bigammo_mp" ] = "scr_wwm_thompson";
	level.wwm[ "thompson_mp" ] = "scr_wwm_thompson";
	level.wwm[ "thompson_silenced_mp" ] = "scr_wwm_thompson";
	
	level.wwm[ "mp40_aperture_mp" ] = "scr_wwm_mp40";
	level.wwm[ "mp40_bigammo_mp" ] = "scr_wwm_mp40";
	level.wwm[ "mp40_mp" ] = "scr_wwm_mp40";
	level.wwm[ "mp40_silenced_mp" ] = "scr_wwm_mp40";
	
	level.wwm[ "type100smg_aperture_mp" ] = "scr_wwm_type100smg";
	level.wwm[ "type100smg_bigammo_mp" ] = "scr_wwm_type100smg";
	level.wwm[ "type100smg_mp" ] = "scr_wwm_type100smg";
	level.wwm[ "type100smg_silenced_mp" ] = "scr_wwm_type100smg";
	
	level.wwm[ "ppsh_aperture_mp" ] = "scr_wwm_ppsh";
	level.wwm[ "ppsh_bigammo_mp" ] = "scr_wwm_ppsh";
	level.wwm[ "ppsh_mp" ] = "scr_wwm_ppsh";
	
	
	// Shotguns
	level.wwm[ "shotgun_bayonet_mp" ] = "scr_wwm_shotgun";
	level.wwm[ "shotgun_grip_mp" ] = "scr_wwm_shotgun";
	level.wwm[ "shotgun_mp" ] = "scr_wwm_shotgun";
	
	level.wwm[ "doublebarreledshotgun_grip_mp" ] = "scr_wwm_doublebarreledshotgun";
	level.wwm[ "doublebarreledshotgun_mp" ] = "scr_wwm_doublebarreledshotgun";
	level.wwm[ "doublebarreledshotgun_sawoff_mp" ] = "scr_wwm_doublebarreledshotgun";
	
	
	// Machine guns
	level.wwm[ "type99lmg_bayonet_mp" ] = "scr_wwm_type99lmg";
	level.wwm[ "type99lmg_bipod_mp" ] = "scr_wwm_type99lmg_bipod";
	level.wwm[ "type99lmg_mp" ] = "scr_wwm_type99lmg";
	
	level.wwm[ "bar_bipod_mp" ] = "scr_wwm_bar_bipod";
	level.wwm[ "bar_mp" ] = "scr_wwm_bar";
	
	level.wwm[ "dp28_bipod_mp" ] = "scr_wwm_dp28_bipod";
	level.wwm[ "dp28_mp" ] = "scr_wwm_dp28";
	
	level.wwm[ "mg42_bipod_mp" ] = "scr_wwm_mg42_bipod";
	level.wwm[ "mg42_mp" ] = "scr_wwm_mg42";
	
	level.wwm[ "fg42_bipod_mp" ] = "scr_wwm_fg42_bipod";
	level.wwm[ "fg42_mp" ] = "scr_wwm_fg42";
	level.wwm[ "fg42_telescopic_mp" ] = "scr_wwm_fg42_bipod";
	
	level.wwm[ "30cal_bipod_mp" ] = "scr_wwm_30cal_bipod";
	level.wwm[ "30cal_mp" ] = "scr_wwm_30cal";
	
	
	// Handguns
	level.wwm[ "colt_mp" ] = "scr_wwm_colt";
	level.wwm[ "nambu_mp" ] = "scr_wwm_nambu";
	level.wwm[ "walther_mp" ] = "scr_wwm_walther";
	level.wwm[ "tokarev_mp" ] = "scr_wwm_tokarev";
	level.wwm[ "357magnum_mp" ] = "scr_wwm_357magnum";
	
	
	// Miscellaneous
	level.wwm[ "briefcase_bomb_mp" ] = "scr_wwm_bomb";

	// Grenades
	level.wwm[ "frag_grenade_mp" ] = "scr_wwm_frag_grenade";
	level.wwm[ "sticky_grenade_mp" ] = "scr_wwm_sticky_grenade";
	level.wwm[ "molotov_mp" ] = "scr_wwm_molotov";
	
	level.wwm[ "smoke_grenade_mp" ] = "scr_wwm_smoke_grenade";
	level.wwm[ "signal_flare_mp" ] = "scr_wwm_signal_flare";	
	level.wwm[ "tabun_gas_mp" ] = "scr_wwm_tabun_gas_grenade";

	// Explosives
	level.wwm[ "satchel_charge_mp" ] = "scr_wwm_satchel";
	level.wwm[ "mine_bouncing_betty_mp" ] = "scr_wwm_betty";
	level.wwm[ "bazooka_mp" ] = "scr_wwm_bazooka";

	return;
}
