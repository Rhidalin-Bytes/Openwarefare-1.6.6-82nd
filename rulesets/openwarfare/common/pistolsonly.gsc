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
	//******************************************************************************
	// configs/server/rank.cfg
	//******************************************************************************		
	setDvar( "scr_forceunrankedmatch", "1" );

	setDvar( "class_grenadier_primary", "none" );
	setDvar( "class_grenadier_primary_attachment", "none" );
	setDvar( "class_grenadier_lock_primary", "1" );
	setDvar( "class_grenadier_lock_primary_attachment", "1" );
	setDvar( "class_grenadier_perk1", "specialty_extraammo" );

	setDvar( "class_rifleman_primary", "none" );
	setDvar( "class_rifleman_primary_attachment", "none" );
	setDvar( "class_rifleman_lock_primary", "1" );
	setDvar( "class_rifleman_lock_primary_attachment", "1" );
	setDvar( "class_rifleman_perk1", "specialty_extraammo" );
	
	setDvar( "class_lightgunner_primary", "none" );
	setDvar( "class_lightgunner_primary_attachment", "none" );
	setDvar( "class_lightgunner_lock_primary", "1" );
	setDvar( "class_lightgunner_lock_primary_attachment", "1" );	
	setDvar( "class_lightgunner_perk1", "specialty_extraammo" );

	setDvar( "class_heavygunner_primary", "none" );
	setDvar( "class_heavygunner_primary_attachment", "none" );
	setDvar( "class_heavygunner_lock_primary", "1" );
	setDvar( "class_heavygunner_lock_primary_attachment", "1" );
	setDvar( "class_heavygunner_perk1", "specialty_extraammo" );
	
	setDvar( "class_closeassault_primary", "none" );
	setDvar( "class_closeassault_primary_attachment", "none" );
	setDvar( "class_closeassault_lock_primary", "1" );
	setDvar( "class_closeassault_lock_primary_attachment", "1" );
	setDvar( "class_closeassault_perk1", "specialty_extraammo" );

	setDvar( "class_sniper_primary", "none" );
	setDvar( "class_sniper_primary_attachment", "none" );
	setDvar( "class_sniper_lock_primary", "1" );
	setDvar( "class_sniper_lock_primary_attachment", "1" );
	setDvar( "class_sniper_perk1", "specialty_extraammo" );
	
	setDvar( "perk_allow_specialty_weapon_bouncing_betty", "0" );
	setDvar( "perk_allow_specialty_weapon_flamethrower", "0" );
	setDvar( "perk_allow_specialty_weapon_bazooka", "0" );
	setDvar( "perk_allow_specialty_weapon_satchel_charge", "0" );
}