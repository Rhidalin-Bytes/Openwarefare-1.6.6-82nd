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


#include openwarfare\_utils;


init()
{
	// Get the main module's dvar
	level.scr_wdm_enabled = getdvarx( "scr_wdm_enabled", "int", 0, 0, 1 );

	// If weapon damage modifier is disabled then there's nothing else to do here
	if ( level.scr_wdm_enabled == 0 )
		return;

	thread loadWDM();

	return;
}


wdmDamage( iDamage, sWeapon, sHitLoc, sMeansOfDeath )
{
	// By default we won't change the iDamage value
	damageModifier = 1.0;

	// Make sure it was not a knife kill or a headshot
	if ( sMeansOfDeath != "MOD_MELEE" && !maps\mp\gametypes\_globallogic::isHeadShot( sWeapon, sHitLoc, sMeansOfDeath ) ) {
		// Check if we support wdm for this weapon
		if ( isDefined( level.wdm[ sWeapon ] ) ) {
			damageModifier = getdvarx( level.wdm[ sWeapon ], "float", 100.0, 0.0, 200.0 ) / 100;
		} else {
			// Just for testing. Remove this line on release version!
			//self iprintln( "No damage defined for " + sWeapon );
		}
	}

	return int( iDamage * damageModifier );
}


loadWDM()
{
	// Load all the weapons with their corresponding dvar controlling it
	level.wdm = [];

	// Bolt Action Rifles
	level.wdm[ "springfield_bayonet_mp" ] = "scr_wdm_springfield";
	level.wdm[ "springfield_gl_mp" ] = "scr_wdm_springfield";
	level.wdm[ "springfield_mp" ] = "scr_wdm_springfield";
	level.wdm[ "springfield_scoped_mp" ] = "scr_wdm_springfield";

	level.wdm[ "type99rifle_bayonet_mp" ] = "scr_wdm_type99rifle";
	level.wdm[ "type99rifle_gl_mp" ] = "scr_wdm_type99rifle";
	level.wdm[ "type99rifle_mp" ] = "scr_wdm_type99rifle";
	level.wdm[ "type99rifle_scoped_mp" ] = "scr_wdm_type99rifle";
	
	level.wdm[ "mosinrifle_bayonet_mp" ] = "scr_wdm_mosinrifle";
	level.wdm[ "mosinrifle_gl_mp" ] = "scr_wdm_mosinrifle";
	level.wdm[ "mosinrifle_mp" ] = "scr_wdm_mosinrifle";
	level.wdm[ "mosinrifle_scoped_mp" ] = "scr_wdm_mosinrifle";
	
	level.wdm[ "kar98k_bayonet_mp" ] = "scr_wdm_kar98k";
	level.wdm[ "kar98k_gl_mp" ] = "scr_wdm_kar98k";
	level.wdm[ "kar98k_mp" ] = "scr_wdm_kar98k";
	level.wdm[ "kar98k_scoped_mp" ] = "scr_wdm_kar98k";
	
	level.wdm[ "ptrs41_mp" ] = "scr_wdm_ptrs41";


	// Rifles
	level.wdm[ "svt40_aperture_mp" ] = "scr_wdm_svt40";
	level.wdm[ "svt40_mp" ] = "scr_wdm_svt40";
	level.wdm[ "svt40_telescopic_mp" ] = "scr_wdm_svt40";
	level.wdm[ "svt40_flash_mp" ] = "scr_wdm_svt40_silenced";
	
	level.wdm[ "gewehr43_aperture_mp" ] = "scr_wdm_gewehr43";
	level.wdm[ "gewehr43_gl_mp" ] = "scr_wdm_gewehr43";
	level.wdm[ "gewehr43_mp" ] = "scr_wdm_gewehr43";
	level.wdm[ "gewehr43_telescopic_mp" ] = "scr_wdm_gewehr43";
	level.wdm[ "gewehr43_silenced_mp" ] = "scr_wdm_gewehr43_silenced";
	
	level.wdm[ "m1garand_bayonet_mp" ] = "scr_wdm_m1garand";
	level.wdm[ "m1garand_gl_mp" ] = "scr_wdm_m1garand";
	level.wdm[ "m1garand_mp" ] = "scr_wdm_m1garand";
	level.wdm[ "m1garand_scoped_mp" ] = "scr_wdm_m1garand";
	level.wdm[ "m1garand_flash_mp" ] = "scr_wdm_m1garand_silenced";

	level.wdm[ "stg44_aperture_mp" ] = "scr_wdm_stg44";
	level.wdm[ "stg44_mp" ] = "scr_wdm_stg44";
	level.wdm[ "stg44_telescopic_mp" ] = "scr_wdm_stg44";
	level.wdm[ "stg44_flash_mp" ] = "scr_wdm_stg44_silenced";
	
	level.wdm[ "m1carbine_aperture_mp" ] = "scr_wdm_m1carbine";
	level.wdm[ "m1carbine_bayonet_mp" ] = "scr_wdm_m1carbine";
	level.wdm[ "m1carbine_bigammo_mp" ] = "scr_wdm_m1carbine";
	level.wdm[ "m1carbine_mp" ] = "scr_wdm_m1carbine";
	level.wdm[ "m1carbine_flash_mp" ] = "scr_wdm_m1carbine_silenced";
	
	
	// Submachine guns
	level.wdm[ "thompson_aperture_mp" ] = "scr_wdm_thompson";
	level.wdm[ "thompson_bigammo_mp" ] = "scr_wdm_thompson";
	level.wdm[ "thompson_mp" ] = "scr_wdm_thompson";
	level.wdm[ "thompson_silenced_mp" ] = "scr_wdm_thompson_silenced";
	
	level.wdm[ "mp40_aperture_mp" ] = "scr_wdm_mp40";
	level.wdm[ "mp40_bigammo_mp" ] = "scr_wdm_mp40";
	level.wdm[ "mp40_mp" ] = "scr_wdm_mp40";
	level.wdm[ "mp40_silenced_mp" ] = "scr_wdm_mp40_silenced";
	
	level.wdm[ "type100smg_aperture_mp" ] = "scr_wdm_type100smg";
	level.wdm[ "type100smg_bigammo_mp" ] = "scr_wdm_type100smg";
	level.wdm[ "type100smg_mp" ] = "scr_wdm_type100smg";
	level.wdm[ "type100smg_silenced_mp" ] = "scr_wdm_type100smg_silenced";
	
	level.wdm[ "ppsh_aperture_mp" ] = "scr_wdm_ppsh";
	level.wdm[ "ppsh_bigammo_mp" ] = "scr_wdm_ppsh";
	level.wdm[ "ppsh_mp" ] = "scr_wdm_ppsh";
	
	
	// Shotguns
	level.wdm[ "shotgun_bayonet_mp" ] = "scr_wdm_shotgun";
	level.wdm[ "shotgun_grip_mp" ] = "scr_wdm_shotgun";
	level.wdm[ "shotgun_mp" ] = "scr_wdm_shotgun";
	
	level.wdm[ "doublebarreledshotgun_grip_mp" ] = "scr_wdm_doublebarreledshotgun";
	level.wdm[ "doublebarreledshotgun_mp" ] = "scr_wdm_doublebarreledshotgun";
	level.wdm[ "doublebarreledshotgun_sawoff_mp" ] = "scr_wdm_doublebarreledshotgun";
	
	
	// Machine guns
	level.wdm[ "type99lmg_bayonet_mp" ] = "scr_wdm_type99lmg";
	level.wdm[ "type99lmg_bipod_mp" ] = "scr_wdm_type99lmg";
	level.wdm[ "type99lmg_bipod_crouch_mp" ] = "scr_wdm_type99lmg";
	level.wdm[ "type99lmg_bipod_prone_mp" ] = "scr_wdm_type99lmg";
	level.wdm[ "type99lmg_bipod_stand_mp" ] = "scr_wdm_type99lmg";
	level.wdm[ "type99lmg_mp" ] = "scr_wdm_type99lmg";
	
	level.wdm[ "bar_bipod_mp" ] = "scr_wdm_bar";
	level.wdm[ "bar_bipod_crouch_mp" ] = "scr_wdm_bar";
	level.wdm[ "bar_bipod_prone_mp" ] = "scr_wdm_bar";
	level.wdm[ "bar_bipod_stand_mp" ] = "scr_wdm_bar";
	level.wdm[ "bar_mp" ] = "scr_wdm_bar";
	
	level.wdm[ "dp28_bipod_mp" ] = "scr_wdm_dp28";
	level.wdm[ "dp28_bipod_crouch_mp" ] = "scr_wdm_dp28";
	level.wdm[ "dp28_bipod_prone_mp" ] = "scr_wdm_dp28";
	level.wdm[ "dp28_bipod_stand_mp" ] = "scr_wdm_dp28";
	level.wdm[ "dp28_mp" ] = "scr_wdm_dp28";
	
	level.wdm[ "mg42_bipod_mp" ] = "scr_wdm_mg42";
	level.wdm[ "mg42_bipod_crouch_mp" ] = "scr_wdm_mg42";
	level.wdm[ "mg42_bipod_prone_mp" ] = "scr_wdm_mg42";
	level.wdm[ "mg42_bipod_stand_mp" ] = "scr_wdm_mg42";
	level.wdm[ "mg42_mp" ] = "scr_wdm_mg42";
	
	level.wdm[ "fg42_bipod_mp" ] = "scr_wdm_fg42";
	level.wdm[ "fg42_bipod_crouch_mp" ] = "scr_wdm_fg42";
	level.wdm[ "fg42_bipod_prone_mp" ] = "scr_wdm_fg42";
	level.wdm[ "fg42_bipod_stand_mp" ] = "scr_wdm_fg42";
	level.wdm[ "fg42_mp" ] = "scr_wdm_fg42";
	level.wdm[ "fg42_telescopic_mp" ] = "scr_wdm_fg42";
	
	level.wdm[ "30cal_bipod_mp" ] = "scr_wdm_30cal";
	level.wdm[ "30cal_bipod_crouch_mp" ] = "scr_wdm_30cal";
	level.wdm[ "30cal_bipod_prone_mp" ] = "scr_wdm_30cal";
	level.wdm[ "30cal_bipod_stand_mp" ] = "scr_wdm_30cal";
	level.wdm[ "30cal_mp" ] = "scr_wdm_30cal";
	
	
	// Handguns
	level.wdm[ "colt_mp" ] = "scr_wdm_colt";
	level.wdm[ "nambu_mp" ] = "scr_wdm_nambu";
	level.wdm[ "walther_mp" ] = "scr_wdm_walther";
	level.wdm[ "tokarev_mp" ] = "scr_wdm_tokarev";
	level.wdm[ "357magnum_mp" ] = "scr_wdm_357magnum";


	// Grenade launcher
	level.wdm[ "gl_gewehr43_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_kar98k_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_m1garand_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_mosinrifle_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_springfield_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_type99rifle_mp" ] = "scr_wdm_gl";
	level.wdm[ "gl_mp" ] = "scr_wdm_gl";

	// Primary grenades
	level.wdm[ "frag_grenade_mp" ] = "scr_wdm_frag_grenades";
	level.wdm[ "frag_grenade_short_mp" ] = "scr_wdm_frag_grenades";  // This one is the one used in Martyrdom
	level.wdm[ "sticky_grenade_mp" ] = "scr_wdm_sticky_grenades";
	level.wdm[ "molotov_mp" ] = "scr_wdm_molotovs";

	// Explosives
	level.wdm[ "satchel_charge_mp" ] = "scr_wdm_satchels";
	level.wdm[ "mine_bouncing_betty_mp" ] = "scr_wdm_bettys";
	level.wdm[ "bazooka_mp" ] = "scr_wdm_bazookas";
	
	// Misc
	level.wdm[ "destructible_car" ] = "scr_wdm_vehicles";
	level.wdm[ "explodable_barrel" ] = "scr_wdm_barrels";

	return;
}

