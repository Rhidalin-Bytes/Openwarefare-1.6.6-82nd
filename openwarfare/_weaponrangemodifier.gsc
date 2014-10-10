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
	level.scr_wrm_enabled = getdvarx( "scr_wrm_enabled", "int", 0, 0, 1 );

	// If weapon range modifier is disabled then there's nothing else to do here
	if ( level.scr_wrm_enabled == 0 )
		return;

	thread loadWRM();

	return;
}


wrmDamage( eAttacker, iDamage, sWeapon, sHitLoc, sMeansOfDeath )
{
	// By default we won't change the iDamage value
	PlayerInRange = 1.0;

	// Make sure it was not a knife kill
	if ( sMeansOfDeath != "MOD_MELEE" ) {
		// Check if we support wrm for this weapon
		if ( isDefined( level.wrm[ sWeapon ] ) ) {
			rangeModifier = getdvarx( level.wrm[ sWeapon ], "float", 215.0, 5.0, 215.0 );
		
	 		//check if target is out of range
	 		if(isplayer(eAttacker)){
		 		targetDist = distance(eAttacker.origin, self.origin)* 0.0254;
		 		
		 		if( targetDist > rangeModifier){
		 	 		PlayerInRange = 0 ;}
			}
		} else {
			// Just for testing. Remove this line on release version!
			//self iprintln( "No range defined for " + sWeapon );
		}		
	}
		return int( iDamage * PlayerInRange );
}


loadWRM()
{
	// Load all the weapons with their corresponding dvar controlling it
	level.wrm = [];

	// Bolt Action Rifles
	level.wrm[ "springfield_bayonet_mp" ] = "scr_wrm_springfield";
	level.wrm[ "springfield_gl_mp" ] = "scr_wrm_springfield";
	level.wrm[ "springfield_mp" ] = "scr_wrm_springfield";
	level.wrm[ "springfield_scoped_mp" ] = "scr_wrm_springfield";

	level.wrm[ "type99rifle_bayonet_mp" ] = "scr_wrm_type99rifle";
	level.wrm[ "type99rifle_gl_mp" ] = "scr_wrm_type99rifle";
	level.wrm[ "type99rifle_mp" ] = "scr_wrm_type99rifle";
	level.wrm[ "type99rifle_scoped_mp" ] = "scr_wrm_type99rifle";
	
	level.wrm[ "mosinrifle_bayonet_mp" ] = "scr_wrm_mosinrifle";
	level.wrm[ "mosinrifle_gl_mp" ] = "scr_wrm_mosinrifle";
	level.wrm[ "mosinrifle_mp" ] = "scr_wrm_mosinrifle";
	level.wrm[ "mosinrifle_scoped_mp" ] = "scr_wrm_mosinrifle";
	
	level.wrm[ "kar98k_bayonet_mp" ] = "scr_wrm_kar98k";
	level.wrm[ "kar98k_gl_mp" ] = "scr_wrm_kar98k";
	level.wrm[ "kar98k_mp" ] = "scr_wrm_kar98k";
	level.wrm[ "kar98k_scoped_mp" ] = "scr_wrm_kar98k";
	
	level.wrm[ "ptrs41_mp" ] = "scr_wrm_ptrs41";


	// Rifles
	level.wrm[ "svt40_aperture_mp" ] = "scr_wrm_svt40";
	level.wrm[ "svt40_mp" ] = "scr_wrm_svt40";
	level.wrm[ "svt40_telescopic_mp" ] = "scr_wrm_svt40";
	level.wrm[ "svt40_flash_mp" ] = "scr_wrm_svt40_silenced";
	
	level.wrm[ "gewehr43_aperture_mp" ] = "scr_wrm_gewehr43";
	level.wrm[ "gewehr43_gl_mp" ] = "scr_wrm_gewehr43";
	level.wrm[ "gewehr43_mp" ] = "scr_wrm_gewehr43";
	level.wrm[ "gewehr43_telescopic_mp" ] = "scr_wrm_gewehr43";
	level.wrm[ "gewehr43_silenced_mp" ] = "scr_wrm_gewehr43_silenced";
	
	level.wrm[ "m1garand_bayonet_mp" ] = "scr_wrm_m1garand";
	level.wrm[ "m1garand_gl_mp" ] = "scr_wrm_m1garand";
	level.wrm[ "m1garand_mp" ] = "scr_wrm_m1garand";
	level.wrm[ "m1garand_scoped_mp" ] = "scr_wrm_m1garand";
	level.wrm[ "m1garand_flash_mp" ] = "scr_wrm_m1garand_silenced";

	level.wrm[ "stg44_aperture_mp" ] = "scr_wrm_stg44";
	level.wrm[ "stg44_mp" ] = "scr_wrm_stg44";
	level.wrm[ "stg44_telescopic_mp" ] = "scr_wrm_stg44";
	level.wrm[ "stg44_flash_mp" ] = "scr_wrm_stg44_silenced";
	
	level.wrm[ "m1carbine_aperture_mp" ] = "scr_wrm_m1carbine";
	level.wrm[ "m1carbine_bayonet_mp" ] = "scr_wrm_m1carbine";
	level.wrm[ "m1carbine_bigammo_mp" ] = "scr_wrm_m1carbine";
	level.wrm[ "m1carbine_mp" ] = "scr_wrm_m1carbine";
	level.wrm[ "m1carbine_flash_mp" ] = "scr_wrm_m1carbine_silenced";
	
	
	// Submachine guns
	level.wrm[ "thompson_aperture_mp" ] = "scr_wrm_thompson";
	level.wrm[ "thompson_bigammo_mp" ] = "scr_wrm_thompson";
	level.wrm[ "thompson_mp" ] = "scr_wrm_thompson";
	level.wrm[ "thompson_silenced_mp" ] = "scr_wrm_thompson_silenced";
	
	level.wrm[ "mp40_aperture_mp" ] = "scr_wrm_mp40";
	level.wrm[ "mp40_bigammo_mp" ] = "scr_wrm_mp40";
	level.wrm[ "mp40_mp" ] = "scr_wrm_mp40";
	level.wrm[ "mp40_silenced_mp" ] = "scr_wrm_mp40_silenced";
	
	level.wrm[ "type100smg_aperture_mp" ] = "scr_wrm_type100smg";
	level.wrm[ "type100smg_bigammo_mp" ] = "scr_wrm_type100smg";
	level.wrm[ "type100smg_mp" ] = "scr_wrm_type100smg";
	level.wrm[ "type100smg_silenced_mp" ] = "scr_wrm_type100smg_silenced";
	
	level.wrm[ "ppsh_aperture_mp" ] = "scr_wrm_ppsh";
	level.wrm[ "ppsh_bigammo_mp" ] = "scr_wrm_ppsh";
	level.wrm[ "ppsh_mp" ] = "scr_wrm_ppsh";
	
	
	// Shotguns
	level.wrm[ "shotgun_bayonet_mp" ] = "scr_wrm_shotgun";
	level.wrm[ "shotgun_grip_mp" ] = "scr_wrm_shotgun";
	level.wrm[ "shotgun_mp" ] = "scr_wrm_shotgun";
	
	level.wrm[ "doublebarreledshotgun_grip_mp" ] = "scr_wrm_doublebarreledshotgun";
	level.wrm[ "doublebarreledshotgun_mp" ] = "scr_wrm_doublebarreledshotgun";
	level.wrm[ "doublebarreledshotgun_sawoff_mp" ] = "scr_wrm_doublebarreledshotgun";
	
	
	// Machine guns
	level.wrm[ "type99lmg_bayonet_mp" ] = "scr_wrm_type99lmg";
	level.wrm[ "type99lmg_bipod_mp" ] = "scr_wrm_type99lmg";
	level.wrm[ "type99lmg_bipod_crouch_mp" ] = "scr_wrm_type99lmg";
	level.wrm[ "type99lmg_bipod_prone_mp" ] = "scr_wrm_type99lmg";
	level.wrm[ "type99lmg_bipod_stand_mp" ] = "scr_wrm_type99lmg";
	level.wrm[ "type99lmg_mp" ] = "scr_wrm_type99lmg";
	
	level.wrm[ "bar_bipod_mp" ] = "scr_wrm_bar";
	level.wrm[ "bar_bipod_crouch_mp" ] = "scr_wrm_bar";
	level.wrm[ "bar_bipod_prone_mp" ] = "scr_wrm_bar";
	level.wrm[ "bar_bipod_stand_mp" ] = "scr_wrm_bar";
	level.wrm[ "bar_mp" ] = "scr_wrm_bar";
	
	level.wrm[ "dp28_bipod_mp" ] = "scr_wrm_dp28";
	level.wrm[ "dp28_bipod_crouch_mp" ] = "scr_wrm_dp28";
	level.wrm[ "dp28_bipod_prone_mp" ] = "scr_wrm_dp28";
	level.wrm[ "dp28_bipod_stand_mp" ] = "scr_wrm_dp28";
	level.wrm[ "dp28_mp" ] = "scr_wrm_dp28";
	
	level.wrm[ "mg42_bipod_mp" ] = "scr_wrm_mg42";
	level.wrm[ "mg42_bipod_crouch_mp" ] = "scr_wrm_mg42";
	level.wrm[ "mg42_bipod_prone_mp" ] = "scr_wrm_mg42";
	level.wrm[ "mg42_bipod_stand_mp" ] = "scr_wrm_mg42";
	level.wrm[ "mg42_mp" ] = "scr_wrm_mg42";
	
	level.wrm[ "fg42_bipod_mp" ] = "scr_wrm_fg42";
	level.wrm[ "fg42_bipod_crouch_mp" ] = "scr_wrm_fg42";
	level.wrm[ "fg42_bipod_prone_mp" ] = "scr_wrm_fg42";
	level.wrm[ "fg42_bipod_stand_mp" ] = "scr_wrm_fg42";
	level.wrm[ "fg42_mp" ] = "scr_wrm_fg42";
	level.wrm[ "fg42_telescopic_mp" ] = "scr_wrm_fg42";
	
	level.wrm[ "30cal_bipod_mp" ] = "scr_wrm_30cal";
	level.wrm[ "30cal_bipod_crouch_mp" ] = "scr_wrm_30cal";
	level.wrm[ "30cal_bipod_prone_mp" ] = "scr_wrm_30cal";
	level.wrm[ "30cal_bipod_stand_mp" ] = "scr_wrm_30cal";
	level.wrm[ "30cal_mp" ] = "scr_wrm_30cal";
	
	
	// Handguns
	level.wrm[ "colt_mp" ] = "scr_wrm_colt";
	level.wrm[ "nambu_mp" ] = "scr_wrm_nambu";
	level.wrm[ "walther_mp" ] = "scr_wrm_walther";
	level.wrm[ "tokarev_mp" ] = "scr_wrm_tokarev";
	level.wrm[ "357magnum_mp" ] = "scr_wrm_357magnum";


	return;
}