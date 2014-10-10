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

#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;


init()
{
	precacheItem( "frag_grenade_rus_mp" );
	precacheItem( "frag_grenade_ger_mp" );
	precacheItem( "frag_grenade_jap_mp" );
	//precacheItem( "panzerschrek_mp" );
	
	// Load some OpenWarfare variables
	level.specialty_fraggrenade_ammo_count = getdvarx( "specialty_fraggrenade_ammo_count", "int", 2, 1, 3 );
	level.specialty_specialgrenade_ammo_count = getdvarx( "specialty_specialgrenade_ammo_count", "int", 2, 1, 3 );

	level.classMap["grenadier_mp"] = "CLASS_GRENADIER";
	level.classMap["rifleman_mp"] = "CLASS_CLASS1";
	level.classMap["lightgunner_mp"] = "CLASS_CLASS2";
	level.classMap["heavygunner_mp"] = "CLASS_CLASS3";
	level.classMap["closeassault_mp"] = "CLASS_CLASS4";
	level.classMap["sniper_mp"] = "CLASS_CLASS5";

	level.classMap["offline_class1_mp"] = "OFFLINE_CLASS1";
	level.classMap["offline_class2_mp"] = "OFFLINE_CLASS2";
	level.classMap["offline_class3_mp"] = "OFFLINE_CLASS3";
	level.classMap["offline_class4_mp"] = "OFFLINE_CLASS4";
	level.classMap["offline_class5_mp"] = "OFFLINE_CLASS5";
	level.classMap["offline_class6_mp"] = "OFFLINE_CLASS6";
	level.classMap["offline_class7_mp"] = "OFFLINE_CLASS7";
	level.classMap["offline_class8_mp"] = "OFFLINE_CLASS8";
	level.classMap["offline_class9_mp"] = "OFFLINE_CLASS9";
	level.classMap["offline_class10_mp"] = "OFFLINE_CLASS10";

	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	level.classMap["custom4"] = "CLASS_CUSTOM4";
	level.classMap["custom5"] = "CLASS_CUSTOM5";

	setShadesModels();
	
	precacheModel( level.alliesShadesModel );
	precacheModel( level.axisShadesModel );

	level.perkNames = [];
	level.perkIcons = [];

	// generating perk data vars collected from statsTable.csv
	for( i=150; i<194; i++ )
	{
		reference_s = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if( reference_s != "" )
		{
			perkName = tableLookup( "mp/statsTable.csv", 0, i, 6 );
			level.perkNames[perkName] = tableLookupIString( "mp/statsTable.csv", 6, perkName, 3 );
			level.perkIcons[perkName] = perkName;
			precacheShader( perkName );
		}
		else
			continue;
	}
	
	// Add the special ones manually
	level.perkNames[ "mine_bouncing_betty_mp" ] = &"PERKS_BETTY_X_2";
	level.perkIcons[ "mine_bouncing_betty_mp" ] = "specialty_weapon_bouncing_betty";
	precacheShader( level.perkIcons[ "mine_bouncing_betty_mp" ] );
	
	level.perkNames[ "m2_flamethrower_mp" ] = &"PERKS_FLAMETHROWER";
	level.perkIcons[ "m2_flamethrower_mp" ] = "specialty_weapon_flamethrower";
	precacheShader( level.perkIcons[ "m2_flamethrower_mp" ] );
	
	level.perkNames[ "bazooka_mp" ] = &"PERKS_BAZOOKA_X_2";
	level.perkIcons[ "bazooka_mp" ] = "specialty_weapon_bazooka";
	precacheShader( level.perkIcons[ "bazooka_mp" ] );
	
	level.perkNames[ "satchel_charge_mp" ] = &"PERKS_SATCHEL_CHARGE";
	level.perkIcons[ "satchel_charge_mp" ] = "specialty_weapon_satchel_charge";
	precacheShader( level.perkIcons[ "satchel_charge_mp" ] );
	
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		weapon = tableLookup( "mp/statsTable.csv", 0, i, 4 );
		if ( !isDefined( weapon ) || weapon == "" )
			continue;

		weapon_type = tableLookup( "mp/statsTable.csv", 0, i, 2 );
		attachment = tableLookup( "mp/statsTable.csv", 0, i, 8 );

		weapon_class_register( weapon+"_mp", weapon_type );

		if( !isdefined( attachment ) || attachment == "" )
			continue;

		attachment_tokens = strTok( attachment, " " );
		if( !isDefined( attachment_tokens ) )
			continue;

		if( attachment_tokens.size == 0 )
		{
			weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );
		}
		else
		{
			// multiple attachment options
			for( k = 0; k < attachment_tokens.size; k++ )
				weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
		}
	}

	precacheShader( "waypoint_bombsquad" );
	precacheShader( "waypoint_second_chance" );

	level thread onPlayerConnecting();
}

weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_hmg weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = weapon_type;
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}


getClassChoice( response )
{
	tokens = strtok( response, "," );

	assert( isDefined( level.classMap[tokens[0]] ) );

	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}


giveLoadout( team, class )
{
	self takeAllWeapons();
	self setClass( class );

	// initialize specialty array
	self.specialty = [];
	self.specialty[0] = self.pers[class]["loadout_perk1"];
	self.specialty[1] = self.pers[class]["loadout_perk2"];
	self.specialty[2] = self.pers[class]["loadout_perk3"];
	self.specialty[3] = self.pers[class]["loadout_perk4"];

	self maps\mp\gametypes\_class_unranked::register_perks();

	self maps\mp\gametypes\_teams::playerModelForClass( class );

	sidearmWeapon = self.pers[class]["loadout_secondary"];

	if ( sideArmWeapon != "none" )
	{
		sidearmWeapon = sidearmWeapon + "_mp";

		self giveWeapon( sidearmWeapon );
		if ( self maps\mp\gametypes\_class_unranked::cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( sidearmWeapon );
			
		self setSpawnWeapon( sidearmWeapon );
	}

	primaryWeapon = self.pers[class]["loadout_primary"];
	if ( primaryWeapon != "none" )
	{
		if ( self.pers[class]["loadout_primary_attachment"] != "none" )
			primaryWeapon = primaryWeapon + "_" + self.pers[class]["loadout_primary_attachment"] + "_mp";
		else
			primaryWeapon = primaryWeapon + "_mp";

		self giveWeapon( primaryWeapon );

		self setSpawnWeapon( primaryWeapon );

		if ( self maps\mp\gametypes\_class_unranked::cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( primaryWeapon );
	}

	// Control amount of ammo for perk1 explosives
	switch ( self.pers[class]["loadout_perk1"] )
	{
		case "mine_bouncing_betty_mp":
			ammoCount = getdvarx( "scr_betty_ammo_count", "int", 2, 1, 2 );
			break;
		case "bazooka_mp":
			ammoCount = getdvarx( "scr_bazooka_ammo_count", "int", 2, 1, 4 );
			break;
		case "satchel_charge_mp":
			ammoCount = getdvarx( "scr_satchel_ammo_count", "int", 2, 1, 2 );
			break;
		default:
			ammoCount = 2;
			break;
	}

	switch ( self.pers[class]["loadout_perk1"] )
	{
		case "mine_bouncing_betty_mp":
		case "bazooka_mp":
		case "satchel_charge_mp":
		case "m2_flamethrower_mp":
			self giveWeapon( self.pers[class]["loadout_perk1"] );
			self maps\mp\gametypes\_class_unranked::setWeaponAmmoOverall( self.pers[class]["loadout_perk1"], ammoCount );
			self thread giveActionSlot3AfterDelay( self.pers[class]["loadout_perk1"] );
			self setActionSlot( 4, "" );
			break;
		default:
			self thread giveActionSlot3AfterDelay( "altMode" );
			self setActionSlot( 4, "" );
			break;
	}

	// give frag grenade
	grenadeCount = game["mwf_classes"][class]["pgrenade_count"];
	if ( self.pers[class]["loadout_pgrenade"] != "none" )
	{
		if ( self maps\mp\gametypes\_class_unranked::cac_hasSpecialty( "specialty_fraggrenade" ) )
			grenadeCount += level.specialty_fraggrenade_ammo_count;

		// [0.0.4] Give grenades after a dvar specified delay
		if ( grenadeCount )
			self thread giveNadesAfterDelay( self.pers[class]["loadout_pgrenade"] + "_mp", grenadeCount, true );
	}

	// give special grenade
	grenadeCount = game["mwf_classes"][class]["sgrenade_count"];
	if ( self.pers[class]["loadout_sgrenade"] != "none" )
	{
		//TODO: dvar grenade count control
		if ( self maps\mp\gametypes\_class_unranked::cac_hasSpecialty( "specialty_specialgrenade" ) )
			grenadeCount += level.specialty_specialgrenade_ammo_count;

		if ( self.pers[class]["loadout_sgrenade"] == "flash_grenade" )
			self setOffhandSecondaryClass("flash");
		else
			self setOffhandSecondaryClass("smoke");

		// [0.0.4] Give grenades after a dvar specified delay
		if ( grenadeCount )
			self thread giveNadesAfterDelay( self.pers[class]["loadout_sgrenade"] + "_mp", grenadeCount, false );
	}

	switch ( class )
	{
		case "grenadier":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_grenadier_movespeed", "float", 0.95, 0.5, 1.5 ) );
			break;
		case "rifleman":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_rifleman_movespeed", "float", 0.95, 0.5, 1.5 ) );
			break;
		case "lightgunner":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_lightgunner_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "heavygunner":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_heavygunner_movespeed", "float", 0.875, 0.5, 1.5 ) );
			break;
		case "closeassault":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_closeassault_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		case "sniper":
			self thread openwarfare\_speedcontrol::setBaseSpeed( getdvarx( "class_sniper_movespeed", "float", 1.0, 0.5, 1.5 ) );
			break;
		default:
			self thread openwarfare\_speedcontrol::setBaseSpeed( 1.0 );
			break;
	}

	// cac specialties that require loop threads
	self maps\mp\gametypes\_class_unranked::cac_selector();
		
	[[level.onLoadoutGiven]]();
}


// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) )
	{
		self setWeaponAmmoClip( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}


onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !level.oldschool )
		{
			if ( !isDefined( player.pers["class"] ) ) {
				player.pers["class"] = undefined;
			}
			player.class = player.pers["class"];
			player.lastClass = "";
		}
		player.detectExplosives = false;
		player.bombSquadIcons = [];
		player.bombSquadIds = [];	
		player.reviveIcons = [];
		player.reviveIds = [];
	}
}


fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;

	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}


setClass( newClass )
{
	self setClientDvar( "loadout_curclass", newClass );
	self.curClass = newClass;
}


// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

initPerkDvars()
{
	level.cac_bulletdamage_data = getdvarx( "perk_bulletdamage", "int", 40, 10, 100 );		// increased bullet damage by this %
	level.cac_fireproof_data = getdvarx( "perk_fireproof", "int", 55, 10, 100 );  // reduced flame damage by this %
	level.cac_armorvest_data = getdvarx( "perk_armorvest", "int", 75, 10, 100 );		// multipy damage by this %	
	level.cac_explosivedamage_data = getdvarx( "perk_explosivedamage", "int", 25, 10, 100 ); 	// increased explosive damage by this %
	level.cac_flakjacket_data = getdvarx( "perk_flakjacket", "int", 75, 10, 100 );			// explosive damage is this % of original
	level.cac_flakjacketmaxdamage_data = getdvarx( "perk_flakjacketmaxdamage", "int", 75, 10, 100 );  	// max damage caused by grenade in %
	
}

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	perks = self.specialty;

	self.detectExplosives = false;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
			self.detectExplosives = true;
	}
	
	if (cac_hasSpecialty("specialty_shades") )
	{
		if ( self.pers["team"] == "axis" )
		{
			shadesModel = level.axisShadesModel;
		}
		else
		{
			shadesModel = level.alliesShadesModel;
		}
		self attach(shadesModel, "J_Head", true);
	}
	
	maps\mp\gametypes\_weapons::setupBombSquad();

	self.canreviveothers = false;
	if (cac_hasSpecialty( "specialty_pistoldeath" ) )
	{
		self.canreviveothers = true;
		maps\mp\_laststand::setupRevive();
	}
}

register_perks()
{
	perks = self.specialty;
	self clearPerks();
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];

		// TO DO: ask code to register the inventory perks and null perk
		// not registering inventory and null perks to code
		if ( perk == "specialty_null" || perk == "specialty_none" || isSubStr( perk, "_mp" ) )
			continue;

		if ( !getDvarInt( "scr_game_perks" ) )
			continue;

		self setPerk( perk );
	}
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;

	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
}

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath, weapon, inflictor )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
			println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
			#/
		}
	}
	else if ( victim cac_hasSpecialty ("specialty_fireproof") && isFireDamage( weapon, meansofdeath ) )
	{
		level.cac_fireproof_data = cac_get_dvar_int( "perk_fireproof", level.cac_fireproof_data );
		
		final_damage = damage*((100-level.cac_fireproof_data)/100);
		/#
		if ( getdvarint("scr_perkdebug") )
		println( "Perk/> " + attacker.name + "'s flames did less damage to " + victim.name );
		#/
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isPlayerExplosiveWeapon( weapon, meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased
		if ( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_flakjacket" ) && meansofdeath != "MOD_PROJECTILE" && !isdefined( inflictor.stucktoplayer ) )
		{
			final_damage = old_damage;
			/#
			if ( getdvarint("scr_perkdebug") )
			println( "Perk/> " + victim.name + "'s flakjacket countered " + attacker.name + "'s increased explosive damage" );
			#/
		}
		else
		{
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			/#
			if ( getdvarint("scr_perkdebug") )
			println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
			#/
		}
	}
	else
	{	
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isdefined( victim ) && isPlayer( victim ) && isdefined( meansofdeath ) && isPrimaryDamage( meansofdeath ) )
		{
			if (victim cac_hasSpecialty( "specialty_armorvest" ) )
			{
				final_damage = old_damage*(level.cac_armorvest_data/100);
			/#
				if ( getdvarint("scr_perkdebug") )
				println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
			#/
			}
		}			
		else if (victim cac_hasSpecialty( "specialty_flakjacket" ) && !isdefined( inflictor.stucktoplayer ) && meansofdeath != "MOD_PROJECTILE"  && weapon != "briefcase_bomb_mp"  )
		{
			if ( isExplosiveDamage( meansofdeath ) || isSubStr( weapon, "explodable_barrel" ) || isSubStr( weapon, "destructible_car" ))
			{
			// will be removing following lines after the tweeking of the system 
				level.cac_flakjacket_data = cac_get_dvar_int( "perk_flakJacket", level.cac_flakjacket_data );
				level.cac_flakjacketmaxdamage_data = cac_get_dvar_int( "perk_flakJacketmaxdamage", level.cac_flakjacketmaxdamage_data  );
				
				final_damage = int(old_damage*( level.cac_flakjacket_data /100));
				if (final_damage > level.cac_flakjacketmaxdamage_data )
				{
					final_damage = level.cac_flakjacketmaxdamage_data ;
				}
			}

			/#
			if ( getdvarint("scr_perkdebug") )
			println( "Perk/> " + victim.name + "'s flak jacket decreased " + attacker.name + "'s grenade damage" );
			#/
		
		}
		else
		{
			final_damage = old_damage;
		}	
	}
	
	// debug
	/#
	if ( getdvarint("scr_perkdebug") )
	println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	#/
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}

isFireDamage( weapon, meansofdeath )
{
	if ( ( isSubStr( weapon, "flame" ) || isSubStr( weapon, "molotov_" ) || isSubStr( weapon, "napalmblob_" ) ) && ( meansofdeath == "MOD_BURNED" || meansofdeath == "MOD_GRENADE" || meansofdeath == "MOD_GRENADE_SPLASH" ) )
		return true;
	return false;
}

isPlayerExplosiveWeapon( weapon, meansofdeath )
{
	if ( !isExplosiveDamage( meansofdeath ) )
		return false;
		
	if ( weapon == "artillery_mp" )
		return false;
	
	// no tank main guns
	if ( issubstr(weapon, "turret" ) )
		return false;
	
	return true;
}

setShadesModels()
{
	level.alliesShadesModel = "char_usa_raider_player_shades";

	if ( game["axis"] == "japanese" )
	{
		level.axisShadesModel  = "char_jap_impinf_player_shades";
	}
	else
	{
		level.axisShadesModel = "char_ger_hnrgd_player_shades";
	}
}