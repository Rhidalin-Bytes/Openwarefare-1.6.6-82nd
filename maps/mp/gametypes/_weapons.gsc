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
#include maps\mp\_utility;
#include openwarfare\_utils;

init()
{
	// assigns weapons with stat numbers from 0-149
	// attachments are now shown here, they are per weapon settings instead

	// Load the module's dvars
	level.scr_betty_show_headicon = getdvarx( "scr_betty_show_headicon", "int", 1, 0, 1 );
	level.scr_betty_show_glow = getdvarx( "scr_betty_show_glow", "int", 1, 0, 1 );
	level.scr_betty_friendly_fire = getdvarx( "scr_betty_friendly_fire", "int", 0, 0, 2 );
	level.scr_betty_arm_time = getdvarx( "scr_betty_arm_time", "float", 0, 0, 10 ) * 1000;
	level.scr_betty_check_plant_distance = getdvarx( "scr_betty_check_plant_distance", "int", 0, 0, 1 );
	level.scr_betty_line_of_sight = getdvarx( "scr_betty_line_of_sight", "int", 0, 0, 1 );
	level.scr_tabun_gas_poisonous = getdvarx( "scr_tabun_gas_poisonous", "int", 0, 0, 5 );

	level.scr_deleteexplosivesondeath = getdvarx( "scr_deleteexplosivesondeath", "int", 0, 0, 1 );
	level.scr_deleteexplosivesonspawn = getdvarx( "scr_deleteexplosivesonspawn", "int", 1, 0, 1 );

	// Drop of grenades
	level.scr_frag_grenades_allowdrop = getdvarx( "scr_frag_grenades_allowdrop", "int", 0, 0, 1 );
	level.scr_sticky_grenades_allowdrop = getdvarx( "scr_sticky_grenades_allowdrop", "int", 0, 0, 1 );
	level.scr_molotovs_allowdrop = getdvarx( "scr_molotovs_allowdrop", "int", 0, 0, 1 );
	level.scr_tabun_gas_grenades_allowdrop = getdvarx( "scr_tabun_gas_grenades_allowdrop", "int", 0, 0, 1 );
	level.scr_signal_flares_allowdrop = getdvarx( "scr_signal_flares_allowdrop", "int", 0, 0, 1 );
	level.scr_smoke_grenades_allowdrop = getdvarx( "scr_smoke_grenades_allowdrop", "int", 0, 0, 1 );
	
	// Drop of explosives
	/*level.scr_bettys_allowdrop = getdvarx( "scr_bettys_allowdrop", "int", 0, 0, 1 );
	level.scr_bazookas_allowdrop = getdvarx( "scr_bazookas_allowdrop", "int", 0, 0, 1 );
	level.scr_satchels_allowdrop = getdvarx( "scr_satchels_allowdrop", "int", 0, 0, 1 );*/

	// Drop of weapons
	level.class_rifleman_allowdrop = getdvarx( "class_rifleman_allowdrop", "int", 1, 0, 1 );
	level.class_lightgunner_allowdrop = getdvarx( "class_lightgunner_allowdrop", "int", 1, 0, 1 );
	level.class_sniper_allowdrop = getdvarx( "class_sniper_allowdrop", "int", 1, 0, 1 );
	level.class_closeassault_allowdrop = getdvarx( "class_closeassault_allowdrop", "int", 1, 0, 1 );
	level.class_heavygunner_allowdrop = getdvarx( "class_heavygunner_allowdrop", "int", 1, 0, 1 );
	
	// generating weaponIDs array
	level.weaponIDs = [];
	max_weapon_num = 149;
	attachment_num = 150;
	for( i = 0; i <= max_weapon_num; i++ )
	{
		weapon_name = tablelookup( "mp/statstable.csv", 0, i, 4 );
		if( !isdefined( weapon_name ) || weapon_name == "" )
		{
			level.weaponIDs[i] = "";
			continue;
		}
		level.weaponIDs[i] = weapon_name + "_mp";
		
		// generating attachment combinations
		attachment = tablelookup( "mp/statstable.csv", 0, i, 8 );
		if( !isdefined( attachment ) || attachment == "" )
			continue;
			
		attachment_tokens = strtok( attachment, " " );
		if( !isdefined( attachment_tokens ) )
			continue;
			
		if( attachment_tokens.size == 0 )
		{
			level.weaponIDs[attachment_num] = weapon_name + "_" + attachment + "_mp";
			attachment_num++;
		}
		else
		{
			for( k = 0; k < attachment_tokens.size; k++ )
			{
				level.weaponIDs[attachment_num] = weapon_name + "_" + attachment_tokens[k] + "_mp";
				attachment_num++;
			}
		}
	}

	// generating weaponNames array
	level.weaponNames = [];
	for ( index = 0; index < max_weapon_num; index++ )
	{
		if ( !isdefined( level.weaponIDs[index] ) || level.weaponIDs[index] == "" )
			continue;
			
		level.weaponNames[level.weaponIDs[index]] = index;
	}
	
	// generating weaponlist array
	level.weaponlist = [];
	assertex( isdefined( level.weaponIDs.size ), "level.weaponIDs is corrupted" );
	for( i = 0; i < level.weaponIDs.size; i++ )
	{
		if( !isdefined( level.weaponIDs[i] ) || level.weaponIDs[i] == "" )
			continue;
		
		level.weaponlist[level.weaponlist.size] = level.weaponIDs[i];
	}

	// based on weaponList array, precache weapons in list
	for ( index = 0; index < level.weaponList.size; index++ )
	{
		resetTimeout();		
		precacheItem( level.weaponList[index] );
		println( "Precached weapon: " + level.weaponList[index] );	
	}

	precacheItem( "frag_grenade_short_mp" );
	
	// precacheItem( "destructible_car" );	
	
	precacheModel( "weapon_mp_bazooka_attach" );
	precacheModel( "weapon_bbetty_mine" );

	// napalmblob_mp is needed for the molitov and flamethrower
	precacheItem( "napalmblob_mp" );	
	
	precacheItem( "t34_mp_explosion_mp" );
	precacheItem( "panzer4_mp_explosion_mp" );
	
	precacheShellShock( "default" );
//	precacheShellShock( "concussion_grenade_mp" );
	precacheShellShock( "tabun_gas_mp" );
	
//	thread maps\mp\_pipebomb::main();
//	thread maps\mp\_ied::main();
	thread maps\mp\_flashgrenades::main();
//	thread maps\mp\_teargrenades::main();
	thread maps\mp\_entityheadicons::init();

	level.bettyDetonateRadius = getdvarx( "scr_betty_detonate_radius", "int", 150, 5, 150 );
	level.bettyUpVelocity = weapons_get_dvar_int ( "bettyUpVelocity", "296" );
	level.bettyTimeBeforeDetonate = weapons_get_dvar ( "bettyTimeBeforeDetonate", "0.45" );

	level.tabunInitialGasShockDuration  = weapons_get_dvar_int( "tabunInitialGasShockDuration", "7");
	level.tabunWalkInGasShockDuration  = weapons_get_dvar_int( "tabunWalkInGasShockDuration", "4");
	level.tabunGasShockRadius = weapons_get_dvar_int( "tabun_shock_radius", "150" );
	level.tabunGasPoisonRadius = weapons_get_dvar_int( "tabun_effect_radius", "150" );	
	
	//Radius of effect of poison gas
	level.tabunGasDuration = weapons_get_dvar_int( "tabunGasDuration", "3" );; // in seconds, after initial shock if you enter, you will get cough, blurred vision if you stay in this length
	level.poisonDuration = weapons_get_dvar_int( "poisonDuration", "8" ); // in seconds you will get poison full screen effect for

	level.slappedWithMolotovDamage = 35; //// how much damage to be applied every second 
	
	level.bettyFXid = loadfx( "weapon/bouncing_betty/fx_betty_trail" );
	
	if ( level.scr_betty_show_glow == 1 )
		level.bettyGlintid = loadfx( "weapon/bouncing_betty/fx_b_betty_glint" );
	
	level thread onPlayerConnect();
	
	level.satchelexplodethisframe = false;
	level.bettyexplodethisframe = false;
}

isStrStart( string1, subStr )
{
	return ( getSubStr( string1, 0, subStr.size ) == subStr );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player.usedWeapons = false;
		player.hits = 0;

		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		self.concussionEndTime = 0;
		self.hasDoneCombat = false;
		self thread watchWeaponUsage();
		self thread watchGrenadeUsage();
		self thread watchWeaponChange();
		
		self.droppedDeathWeapon = undefined;
		self.tookWeaponFrom = [];
		
		self thread updateStowedWeapon();
	}
}

watchWeaponChange()
{
	//self endon("death");
	//self endon("disconnect");
	self endon("death_or_disconnect");
	
	self.lastDroppableWeapon = self getCurrentWeapon();
	
	while(1)
	{
		self waittill( "weapon_change", newWeapon );
		
		if ( mayDropWeapon( newWeapon ) )
			self.lastDroppableWeapon = newWeapon;
	}
}

onPlayerKilled()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("killed_player");
		if ( level.scr_deleteexplosivesondeath == 1 )
		{
			self deleteExplosives();
		}
	}
}

isPistol( weapon )
{
	return isdefined( level.side_arm_array[ weapon ] );
}

isSniper( weapon )
{
	if ( isSubStr( weapon, "_scoped_" ) )
		return true;
	if ( weapon == "ptrs41_mp" )
		return true;		

	return false;
}

isBolt( weapon )
{
	if ( isSubStr( weapon, "kar98k_" ) )
		return true;
	if ( isSubStr( weapon, "mosinrifle_" ) )
		return true;
	if ( isSubStr( weapon, "springfield_" ) )
		return true;
	if ( isSubStr( weapon, "type99rifle_" ) )
		return true;				

	return false;
}

hasScope( weapon )
{
	if ( isSubStr( weapon, "_telescopic_" ) )
		return true;
	if ( isSubStr( weapon, "_scoped_" ) )
		return true;
	if ( weapon == "ptrs41_mp" )
		return true;

	return false;
}

isHackWeapon( weapon )
{
	if ( weapon == "radar_mp" || weapon == "artillery_mp" || weapon == "dogs_mp" )
		return true;
	if ( weapon == "briefcase_bomb_mp" )
		return true;
	return false;
}

mayDropWeapon( weapon )
{
	if ( weapon == "none" )
		return false;

	if ( isHackWeapon( weapon ) )
		return false;
	
	invType = WeaponInventoryType( weapon );
	if ( invType != "primary" )
		return false;
	
	if ( weapon == "none" )
		return false;
		
	if ( level.gametype == "gg" )
		return false;

	if ( isPrimaryWeapon( weapon ) && !level.rankedMatch )
	{
		switch ( level.primary_weapon_array[weapon] )
		{
			case "weapon_assault":
				return ( level.class_rifleman_allowdrop );
			case "weapon_smg":
				return ( level.class_lightgunner_allowdrop );
			case "weapon_sniper":
				return ( level.class_sniper_allowdrop );
			case "weapon_shotgun":
				return ( level.class_closeassault_allowdrop );
			case "weapon_lmg":
			case "weapon_hmg":
				return ( level.class_heavygunner_allowdrop );
		}
	}
	
	return true;
}

dropWeaponForDeath( attacker )
{
	weapon = self.lastDroppableWeapon;
	
	if ( isdefined( self.droppedDeathWeapon ) )
		return;
	
	if ( !isdefined( weapon ) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: not defined" );
		#/
		return;
	}

	if ( weapon == "none" )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: weapon == none" );
		#/
		return;
	}
	
	if ( !self hasWeapon( weapon ) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: don't have it anymore (" + weapon + ")" );
		#/
		return;
	}

	if ( !(self AnyAmmoForWeaponModes( weapon )) )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo for weapon modes" );
		#/
		return;
	}
	
	clipAmmo = self GetWeaponAmmoClip( weapon );
	if ( !clipAmmo )
	{
		/#
		if ( getdvar("scr_dropdebug") == "1" )
			println( "didn't drop weapon: no ammo in clip" );
		#/
		return;
	}

	stockAmmo = self GetWeaponAmmoStock( weapon );
	stockMax = WeaponMaxAmmo( weapon );
	if ( stockAmmo > stockMax )
		stockAmmo = stockMax;

	item = self dropItem( weapon );
	/#
	if ( getdvar("scr_dropdebug") == "1" )
		println( "dropped weapon: " + weapon );
	#/
	
	self.droppedDeathWeapon = true;

	item ItemWeaponSetAmmo( clipAmmo, stockAmmo );
	item itemRemoveAmmoFromAltModes();
	
	item.owner = self;
	item.ownersattacker = attacker;
	
	item thread watchPickup();
	
	item thread deletePickupAfterAWhile();
}

deletePickupAfterAWhile()
{
	self endon("death");
	
	wait 60;

	if ( !isDefined( self ) )
		return;

	self delete();
}

getItemWeaponName()
{
	classname = self.classname;
	assert( getsubstr( classname, 0, 7 ) == "weapon_" );
	weapname = getsubstr( classname, 7 );
	return weapname;
}

watchPickup()
{
	self endon("death");
	
	weapname = self getItemWeaponName();
	
	while(1)
	{
		self waittill( "trigger", player, droppedItem );
		
		if ( isdefined( droppedItem ) )
			break;
		// otherwise, player merely acquired ammo and didn't pick this up
	}
	
	/#
	if ( getdvar("scr_dropdebug") == "1" )
		println( "picked up weapon: " + weapname + ", " + isdefined( self.ownersattacker ) );
	#/

	assert( isdefined( player.tookWeaponFrom ) );
	
	// make sure the owner information on the dropped item is preserved
	droppedWeaponName = droppedItem getItemWeaponName();
	if ( isdefined( player.tookWeaponFrom[ droppedWeaponName ] ) )
	{
		droppedItem.owner = player.tookWeaponFrom[ droppedWeaponName ];
		droppedItem.ownersattacker = player;
		player.tookWeaponFrom[ droppedWeaponName ] = undefined;
	}
	droppedItem thread watchPickup();
	
	// take owner information from self and put it onto player
	if ( isdefined( self.ownersattacker ) && self.ownersattacker == player )
	{
		player.tookWeaponFrom[ weapname ] = self.owner;
	}
	else
	{
		player.tookWeaponFrom[ weapname ] = undefined;
	}
}

watchGrenadePickup( grenadeType )
{
	self endon("death");

	while(1)
	{
		self waittill( "trigger", player );

		// Check if need to activate martyrdom for this player again
		if ( grenadeType == "frag_grenade_mp" && isDefined( player.hasMartyrdom ) && player.hasMartyrdom && !player.hasFragsForMartyrdom ) {
			player.hasFragsForMartyrdom = true;
			player setPerk( "specialty_grenadepulldeath" );
		}
	}
}

itemRemoveAmmoFromAltModes()
{
	origweapname = self getItemWeaponName();
	
	curweapname = weaponAltWeaponName( origweapname );
	
	altindex = 1;
	while ( curweapname != "none" && curweapname != origweapname )
	{
		self itemWeaponSetAmmo( 0, 0, altindex );
		curweapname = weaponAltWeaponName( curweapname );
		altindex++;
	}
}

dropOffhand()
{
	grenadeTypes = [];
	
	if ( level.gametype == "gg" )
		return;
	
	if ( level.scr_frag_grenades_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "frag_grenade_mp";
	}
	if ( level.scr_sticky_grenades_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "sticky_grenade_mp";
	}
	if ( level.scr_molotovs_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "molotov_mp";
	}	
	if ( level.scr_tabun_gas_grenades_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "tabun_gas_mp";
	}
	if ( level.scr_signal_flares_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "signal_flare_mp";
	}
	if ( level.scr_smoke_grenades_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "smoke_grenade_mp";
	}
	/*if ( level.scr_bettys_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "mine_bouncing_betty_mp";
	}
	if ( level.scr_bazookas_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "bazooka_mp";
	}
	if ( level.scr_satchels_allowdrop ) {
		grenadeTypes[grenadeTypes.size] = "satchel_charge_mp";
	}*/

	for ( index = 0; index < grenadeTypes.size; index++ )
	{
		if ( !self hasWeapon( grenadeTypes[index] ) )
			continue;
			
		count = self getAmmoCount( grenadeTypes[index] );
		
		if ( !count )
			continue;

		// No matter how many grenades the player has it only drops one
		self setWeaponAmmoClip( grenadeTypes[index], 1 );
			
		item = self dropItem( grenadeTypes[index] );
		item thread watchGrenadePickup( grenadeTypes[index] );
		item thread deletePickupAfterAWhile();
	}
}

getWeaponBasedGrenadeCount(weapon)
{
	return 2;
}

getWeaponBasedSmokeGrenadeCount(weapon)
{
	return 1;
}

getFragGrenadeCount()
{
	grenadetype = "frag_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}

getSmokeGrenadeCount()
{
	grenadetype = "smoke_grenade_mp";

	count = self getammocount(grenadetype);
	return count;
}


watchWeaponUsage()
{
	//self endon( "death" );
	//self endon( "disconnect" );
	self endon("death_or_disconnect");
	level endon ( "game_ended" );
	
	self.firingWeapon = false;
	
	for ( ;; )
	{	
		self waittill ( "begin_firing" );
		
		if ( !level.inReadyUpPeriod )
			self.hasDoneCombat = true;
					
		self.firingWeapon = true;	
		
		curWeapon = self getCurrentWeapon();
		
		switch ( weaponClass( curWeapon ) )
		{
			case "rifle":
			case "pistol":
			case "mg":
			case "smg":
			case "spread":
				self thread watchCurrentFiring( curWeapon );
				break;
			default:
				break;
		}
		self waittill ( "end_firing" );
		self.firingWeapon = false;
		if ( curWeapon == "bazooka_mp" )
		{
				self setStatLBByName( curWeapon, 1, "shots" );
		}
	}
}

watchCurrentFiring( curWeapon )
{
	self endon("disconnect");
	
	startAmmo = self getWeaponAmmoClip( curWeapon );
	wasInLastStand = isDefined( self.lastStand );

		self waittill ( "end_firing" );		
	
	if ( !self hasWeapon( curWeapon ) )
		return;
	
	// ignore the case where a player is firing as they enter last stand.
	// it makes it too hard to calculate shotsFired properly.
	if ( isDefined( self.lastStand ) && !wasInLastStand )
		return;
	
	shotsFired = startAmmo - (self getWeaponAmmoClip( curWeapon )) + 1;

	if ( isDefined( self.lastStandParams ) && self.lastStandParams.lastStandStartTime == getTime() )
	{
		self.hits = 0;
		return;
	}

	assertEx( shotsFired >= 0, shotsFired + " startAmmo: " + startAmmo + " clipAmmo: " + self getWeaponAmmoclip( curWeapon ) + " w/ " + curWeapon  );	
	if ( shotsFired <= 0 )
		return;
		
	self setStatLBByName( curWeapon, shotsFired, "shots" );
	self setStatLBByName( curWeapon, self.hits, "hits");
	
	
	statTotal = self maps\mp\gametypes\_persistence::statGet( "total_shots" ) + shotsFired;		
	statHits  = self maps\mp\gametypes\_persistence::statGet( "hits" ) + self.hits;
	statMisses = self maps\mp\gametypes\_persistence::statGet( "misses" ) + shotsFired - self.hits;

	// Check if we should keep track of these statistics
	if ( level.scr_realtime_stats_enable == 1 || level.scr_endofgame_stats_enable == 1 ) {
		self notify( "refresh_accuracy", shotsFired, self.hits );
	}
		
	self maps\mp\gametypes\_persistence::statSet( "total_shots", statTotal );
	self maps\mp\gametypes\_persistence::statSet( "hits", statHits );
	self maps\mp\gametypes\_persistence::statSet( "misses", int(max( 0, statMisses )) );
	self maps\mp\gametypes\_persistence::statSet( "accuracy", int(statHits * 10000 / statTotal) );
/*
	printLn( "total:    " + statTotal );
	printLn( "hits:     " + statHits );
	printLn( "misses:   " + statMisses );
	printLn( "accuracy: " + int(statHits * 10000 / statTotal) );
*/
	self.hits = 0;
}

checkHit( sWeapon )
{
	// Hack for Artillery
	if ( sWeapon == "artillery_mp" )
		return;
		
	switch ( weaponClass( sWeapon ) )
	{
		case "rifle":
		case "pistol":
		case "mg":
		case "smg":
			self.hits++;
			break;
		case "spread":
			self.hits = 1;
			break;
		default:
			break;
	}
	
	if ( ( sWeapon == "bazooka_mp" ) || isStrStart( sWeapon, "t34" ) || isStrStart( sWeapon, "panzer" ) )
	{
		self setStatLBByName( sWeapon, 1, "hits" );
	}
}
/*
updateWeaponUsageStats( startAmmo, endAmmo )
{
	shotsFired = startAmmo - endAmmo + 1;

	if ( shotsFired == 0 )
		return;

	assert( shotsFired >= 0 );

	total = self maps\mp\gametypes\_persistence::statGet( "total_shots" ) + shotsFired;				
	hits  = self maps\mp\gametypes\_persistence::statGet( "hits" );				
	self maps\mp\gametypes\_persistence::statSet( "misses", total - hits );
	self maps\mp\gametypes\_persistence::statSet( "total_shots", total );
	self maps\mp\gametypes\_persistence::statSet( "accuracy", int(hits * 10000 / total) );

	self.clipammo = 0;
	self.weapon = "none";
}
*/

// returns true if damage should be done to the item given its owner and the attacker
friendlyFireCheck( owner, attacker, forcedFriendlyFireRule )
{
	if ( !isdefined(owner) ) // owner has disconnected? allow it
		return true;
	
	if ( !level.teamBased ) // not a team based mode? allow it
		return true;
	
	friendlyFireRule = level.friendlyfire;
	if ( isdefined( forcedFriendlyFireRule ) )
		friendlyFireRule = forcedFriendlyFireRule;
	
	if ( friendlyFireRule != 0 ) // friendly fire is on? allow it
		return true;
	
	if ( attacker == owner ) // owner may attack his own items
		return true;
	
	if ( isplayer( attacker ) )
	{
		if ( !isdefined(attacker.pers["team"])) // attacker not on a team? allow it
			return true;
		
		if ( attacker.pers["team"] != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
			return true;
	}
	else if ( isai(attacker) )
	{
		if ( attacker.aiteam != owner.pers["team"] ) // attacker not on the same team as the owner? allow it
			return true; 
	}	
	
	return false; // disallow it
}

inPoisonArea(player, gasEffectArea)
{
	player endon( "disconnect" );
	
	player.inPoisonArea = true;
	player startPoisoning();
	
	poisonTime = 0;
	offSetTime = gettime();
	
	while ( (isdefined (gasEffectArea) ) &&	player istouching(gasEffectArea) && player.sessionstate == "playing")
	{
		wait(0.25);
		
		if ( level.scr_tabun_gas_poisonous != 0 && !player hasPerk("specialty_gas_mask") ) {
			//player iprintln( "In poison gas...");
			poisonTime++;
			if ( poisonTime == 4 ) {
				poisonTime = 0;
				player.health -= level.scr_tabun_gas_poisonous;	
				if ( player.health <= 0 ) {
					player.useLastStandParams = true;
					player.lastStandParams = spawnstruct();
					player.lastStandParams.eInflictor = undefined;
					player.lastStandParams.attacker = player.lastPoisonedBy;
					player.lastStandParams.iDamage = 0;
					player.lastStandParams.sMeansOfDeath = "MOD_BURNED";
					player.lastStandParams.sWeapon = "tabun_gas_mp";
					player.lastStandParams.vDir = undefined;
					player.lastStandParams.sHitLoc = "none";
					player.lastStandParams.lastStandStartTime = offSetTime;
					player.lastStandParams.fDistance = 0;
					player maps\mp\_laststand::ensureLastStandParamsValidity();
					player suicide();
				}							
			}			
		}
	}
	player stopPoisoning();
	player.inPoisonArea = false;
}

watchTabunGrenadeDetonation( owner )
{	
	self waittill( "explode", position );
	
	level.tabunGasPoisonRadius = weapons_get_dvar_int( "tabun_effect_radius", level.tabunGasPoisonRadius );
	level.tabunGasShockRadius  = weapons_get_dvar_int( "tabun_shock_radius", level.tabunGasShockRadius );
	level.tabunInitialGasShockDuration  = weapons_get_dvar_int( "tabunInitialGasShockDuration", level.tabunInitialGasShockDuration);
	level.tabunWalkInGasShockDuration  = weapons_get_dvar_int( "tabunWalkInGasShockDuration", level.tabunWalkInGasShockDuration);
	//level.tabunGasDuration  = weapons_get_dvar_int( "tabunGasDuration", level.tabunGasDuration);
	
	shockEffectArea = spawn("trigger_radius", position, 0, level.tabunGasShockRadius, level.tabunGasShockRadius*2);
	
	players = get_players();
	for (i = 0; i < players.size; i++)
	{
		if ( players[i] player_is_driver() )
				continue;
		
		if ( players[i] istouching(shockEffectArea) && players[i].sessionstate == "playing" && !level.inReadyUpPeriod )
		{
			players[i].lastPoisonedBy = owner;
			tabunInitialGasShockDuration = level.tabunInitialGasShockDuration;
			if ( ! players[i] hasPerk ("specialty_gas_mask") )
				players[i] shellShock( "tabun_gas_mp", tabunInitialGasShockDuration );
			thread inPoisonArea( players[i], shockEffectArea );
			//players[i]  thread maps\mp\gametypes\_battlechatter_mp::incomingSpecialGrenadeTracking( "gas" );
		}	
	}	
	
	owner thread maps\mp\_dogs::flash_dogs( shockEffectArea );
		
	gasEffectArea = spawn("trigger_radius", position, 0, level.tabunGasPoisonRadius, level.tabunGasPoisonRadius*2);
	
	loopWaitTime = 0.5;
	durationOfTabun = level.tabunGasDuration;
	
	while (durationOfTabun > 0)
	{
		players = get_players();
		for (i = 0; i < players.size; i++)
		{	
			if ( players[i] player_is_driver() )
				continue;
			if ((!isDefined (players[i].inPoisonArea)) || (players[i].inPoisonArea == false) )
			{
				if ( players[i] istouching(gasEffectArea) && players[i].sessionstate == "playing" && !level.inReadyUpPeriod )
				{
					players[i].lastPoisonedBy = owner;
					if ( ! ( players[i] hasPerk ("specialty_gas_mask") ) )
						players[i] shellShock( "tabun_gas_mp", level.tabunWalkInGasShockDuration );
					thread inPoisonArea( players[i], gasEffectArea );
				}	
			}
		}
	
		owner thread maps\mp\_dogs::flash_dogs( gasEffectArea );
		
		wait (loopWaitTime);
		durationOfTabun -= loopWaitTime;
	}

	if ( level.tabunGasDuration < level.poisonDuration )
		wait ( level.poisonDuration - level.tabunGasDuration );

	shockEffectArea delete();
	gasEffectArea delete();	
}	

watchGrenadeUsage()
{
	//self endon( "death" );
	//self endon( "disconnect" );
	self endon("death_or_disconnect");
	
	self.throwingGrenade = false;
	self.gotPullbackNotify = false;
	
	if ( level.scr_deleteexplosivesonspawn == 1 )
	{
		self deleteExplosives();
	}
	else
	{
		if ( !isdefined( self.bettyarray ) )
			self.bettyarray = [];
		if ( !isdefined( self.satchelarray ) )
			self.satchelarray = [];
	}
	
	thread watchBettys();
	thread deleteSatchelAndBettysOnDisconnect();
	thread watchSatchel();
	thread watchSatchelDetonation();
	thread watchSatchelAltDetonation();
	thread deleteSatchelsAndBettysOnDisconnect();
	self thread beginSpecialGrenadeTracking();
	
	self thread watchForThrowbacks();

	for ( ;; )
	{
		self waittill ( "grenade_pullback", weaponName );
		
		self setStatLBByName( weaponName, 1, "shots" );
		
		if ( !level.inReadyUpPeriod )
			self.hasDoneCombat = true;

		 if ( weaponName == "mine_bouncing_betty_mp" )
	 		continue;
		
		self.throwingGrenade = true;
		self.gotPullbackNotify = true;
		

		if ( weaponName == "satchel_charge_mp" )
			self beginSatchelTracking();
		else {
			if ( level.inReadyUpPeriod ) {
				self thread dontAllowSuicide();
			}			
			self beginGrenadeTracking();
		}
	}
}

dontAllowSuicide()
{
	limitTime = gettime() + 3000;

	while ( self.throwingGrenade && limitTime > gettime() )
		wait (0.05);

	if ( limitTime <= gettime() ) {
		self freezeControls( true ); wait( 0.1 );	self freezeControls( false );
	}

	return;
}

beginGrenadeTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon("death_or_disconnect");
	
	startTime = getTime();
	
	self waittill ( "grenade_fire", grenade, weaponName );
	
	if ( (getTime() - startTime > 1000) )
		grenade.isCooked = true;
	
	if ( weaponName == "frag_grenade_mp" )
	{
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
	}
		
	self.throwingGrenade = false;
}

beginSpecialGrenadeTracking()
{
	self notify( "grenadeTrackingStart" );
	
	self endon( "grenadeTrackingStart" );
	self endon( "disconnect" );
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weaponName, parent );
		
		if (weaponName == "tabun_gas_mp" )
		{
			grenade thread watchTabunGrenadeDetonation( self );
		}
		else if (weaponName == "signal_flare_mp")
		{
			grenade thread maps\mp\_flare::watchFlareDetonation( self );
		}
		else if ( weaponName == "sticky_grenade_mp" || weaponName == "satchel_charge_mp" )
		{
			grenade thread checkStuckToPlayer();
		}
	}
}

checkStuckToPlayer()
{
	self waittill( "stuck_to_player" );
	
	self.stuckToPlayer = true;
}

beginSatchelTracking()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon("death_or_disconnect");
	
	self waittill_any ( "grenade_fire", "weapon_change" );
	self.throwingGrenade = false;
}

watchForThrowbacks()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon("death_or_disconnect");
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapname );
		if ( self.gotPullbackNotify )
		{
			self.gotPullbackNotify = false;
			continue;
		}
		if ( !isSubStr( weapname, "frag_" ) )
			continue;
		
		// no grenade_pullback notify! we must have picked it up off the ground.
		grenade.threwBack = true;
		
		grenade thread maps\mp\gametypes\_shellshock::grenade_earthQuake();
		grenade.originalOwner = self;
	}
}


watchSatchel()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );

	//maxSatchels = 2;

	while(1)
	{
		self waittill( "grenade_fire", satchel, weapname );
		if ( weapname == "satchel_charge" || weapname == "satchel_charge_mp" )
		{
			if ( !self.satchelarray.size )
				self thread watchsatchelAltDetonate();
			self.satchelarray[self.satchelarray.size] = satchel;
			satchel.owner = self;
			if ( level.teamBased )
				satchel.targetname = "satchel_charge_mp_" + self.pers["team"];			
			satchel thread bombDetectionTrigger_wait( self.pers["team"] );
			satchel thread maps\mp\gametypes\_shellshock::satchel_earthQuake();
			satchel thread satchelDamage();
		}
	}
}


watchBettys()
{
	self endon( "spawned_player" );
	self endon( "disconnect" );
	
	self.bettyarray = [];
	while(1)
	{
		self waittill( "grenade_fire", betty, weapname );
		if ( weapname == "mine_bouncing_betty_mp" )
		{
			self.bettyarray[self.bettyarray.size] = betty;
			betty.owner = self;
			betty.planttime = openwarfare\_timer::getTimePassed();
			if ( level.teamBased )
				betty.targetname = "mine_bouncing_betty_mp_" + self.pers["team"];			
			betty thread bettyDetonation();
			if ( level.scr_betty_show_glow )
				betty thread playbettyEffects();
			betty thread bombDetectionTrigger_wait( self.pers["team"] );
			
			if ( level.scr_betty_show_headicon == 1 )
				betty maps\mp\_entityheadicons::setEntityHeadIcon(self.pers["team"], (0,0,20));
			betty thread bettyDamage();
		}
	}
}

waitTillNotMoving()
{
	prevorigin = self.origin;
	while(1)
	{
		wait .15;
		if ( self.origin == prevorigin )
			break;
		prevorigin = self.origin;
	}
}
	
bettyDetonation()
{
	self endon("death");
	
	self waitTillNotMoving();
	
	// Should we check the planting distance?
	if ( level.scr_betty_check_plant_distance == 1 ) {
		// Check if this is an invalid plant
		if ( distance( self.origin, self.owner.origin ) > 35 ) {
			// Remove the claymore and give it back to the player
			currentAmmo = self.owner getAmmoCount( "mine_bouncing_betty_mp" );
			if ( currentAmmo == 0 ) {
				self.owner giveWeapon( "mine_bouncing_betty_mp" );
			}
			currentAmmo++;
			self.owner setWeaponAmmoStock( "mine_bouncing_betty_mp", currentAmmo );
			self.owner switchToWeapon( "mine_bouncing_betty_mp" );
			self delete();

			return;
		}
	}	
	
	level.bettyUpVelocity = weapons_get_dvar_int ( "bettyUpVelocity", level.bettyUpVelocity);
	level.bettyTimeBeforeDetonate = weapons_get_dvar ( "bettyTimeBeforeDetonate", level.bettyTimeBeforeDetonate);	
	
	damagearea = spawn("trigger_radius", self.origin + (0,0,0-level.bettyDetonateRadius), level.aiTriggerSpawnFlags, level.bettyDetonateRadius, level.bettyDetonateRadius + 36 );
	self thread deleteOnDeath( damagearea );
	
	rangeOrigin = damagearea.origin + ( 0,0,level.bettyDetonateRadius );
		
	while(1)
	{
		damagearea waittill("trigger", triggerer);
	
		if ( getdvarint("scr_bettydebug") != 1 )
		{
			if ( openwarfare\_timer::getTimePassed() - self.planttime < level.scr_betty_arm_time )
				continue;
			if ( isPlayer( triggerer) && triggerer getStance() == "prone" && ( isDefined( level.scr_explosives_allow_disarm ) && level.scr_explosives_allow_disarm == 1 ) ) 
				continue;
			if ( isdefined( self.owner ) && triggerer == self.owner && ( level.scr_betty_friendly_fire != 2 || triggerer getStance() == "prone" ) )
				continue;
			if ( !friendlyFireCheck( self.owner, triggerer, level.scr_betty_friendly_fire ) )
				continue;
			if ( triggerer.origin[2] < rangeOrigin[2] - 24 )
				continue;
			if ( lengthsquared( triggerer getVelocity() ) < 10 )
				continue;	
			if ( level.scr_betty_line_of_sight && !bulletTracePassed( self.origin, triggerer.origin, false, undefined ) )
				continue;
		}
		break;
	}
		
	// check if triggerer has survived the betty for the challenges
	triggerer thread deathDodger();
	
	detonateTime = gettime();
	
	self playsound ("betty_activated");
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");

	self shootup( level.bettyUpVelocity );
	
	fx = PlayFXOnTag( level.bettyFXid, self, "tag_flash" );

	level.bettyTimeBeforeDetonate = weapons_get_dvar ( "bettyTimeBeforeDetonate", level.bettyTimeBeforeDetonate );
	
	self thread waitAndDetonate( level.bettyTimeBeforeDetonate );

}


deathDodger()
{
	//self endon("death");
	//self endon("disconnect");
	self endon("death_or_disconnect");
	
	wait(0.2 + level.bettyTimeBeforeDetonate );
	self notify("death_dodger");
}
	
	

deleteOnDeath(ent)
{
	self waittill("death");
		wait .05;
	if ( isdefined(ent) )
		ent delete();
}


watchSatchelAltDetonation()
{
	//self endon("death");
	//self endon("disconnect");
	self endon("death_or_disconnect");

	while(1)
	{
		self waittill( "alt_detonate" );
		weap = self getCurrentWeapon();
		if ( weap != "satchel_charge_mp" )
		{
			newarray = [];
			for ( i = 0; i < self.satchelarray.size; i++ )
			{
				satchel = self.satchelarray[i];
				if ( isdefined(self.satchelarray[i]) )
					satchel thread waitAndDetonate( 0.1 );
			}
			self.satchelarray = newarray;
			self notify ( "detonated" );
		}
	}
}

watchSatchelAltDetonate()
{
	//self endon("death");
	//self endon( "disconnect" );	
	self endon("death_or_disconnect");
	self endon( "detonated" );
	level endon( "game_ended" );
	
	buttonTime = 0;
	for( ;; )
	{
		if ( self UseButtonPressed() )
		{
			buttonTime = 0;
			while( self UseButtonPressed() )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}
	
			println( "pressTime1: " + buttonTime );
			if ( buttonTime >= 0.5 )
				continue;
	
			buttonTime = 0;				
			while ( !self UseButtonPressed() && buttonTime < 0.5 )
			{
				buttonTime += 0.05;
				wait( 0.05 );
			}
		
			println( "delayTime: " + buttonTime );
			if ( buttonTime >= 0.5 )
			continue;
		
			if ( !self.satchelarray.size )
			return;
				
			self notify ( "alt_detonate" );
		}
		wait ( 0.05 );
	}
}

watchSatchelDetonation()
{
	//self endon("death");
	//self endon("disconnect");
	self endon("death_or_disconnect");

	while(1)
	{
		self waittill( "detonate" );
		weap = self getCurrentWeapon();
		if ( weap == "satchel_charge_mp" )
		{
			for ( i = 0; i < self.satchelarray.size; i++ )
			{
				if ( isdefined(self.satchelarray[i]) )
					self.satchelarray[i] thread waitAndDetonate( 0.1 );
			}
			self.satchelarray = [];
		}
	}
}


waitAndDetonate( delay )
{
	self endon("death");
	wait (delay );

	self detonate();
}

deleteSatchelAndbettysOnDisconnect()
{
	self endon("death");
	self waittill("disconnect");
	
	bettyarray = self.bettyarray;
	satchelarray = self.satchelarray;
	
	wait .05;
	

	for ( i = 0; i < bettyarray.size; i++ )
	{
		if ( isdefined(bettyarray[i]) )
			bettyarray[i] delete();
	}
	for ( i = 0; i < satchelarray.size; i++ )
	{
		if ( isdefined(satchelarray[i]) )
			satchelarray[i] delete();
	}
}


deleteSatchelsAndbettysOnDisconnect()
{
	self endon("death");
	self waittill("disconnect");
	
	satchelarray = self.satchelarray;
	bettyarray = self.bettyarray;
	
	wait .05;
	
	for ( i = 0; i < satchelarray.size; i++ )
	{
		if ( isdefined(satchelarray[i]) )
			satchelarray[i] delete();
	}
	for ( i = 0; i < bettyarray.size; i++ )
	{
		if ( isdefined(bettyarray[i]) )
			bettyarray[i] delete();
	}
}

bettyDamage()
{
	self endon( "death" );

	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	starttime = gettime();
	
	while(1)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		if ( !isplayer(attacker) )
			continue;
		
		// don't allow people to destroy satchel on their team if FF is off
		if ( !friendlyFireCheck( self.owner, attacker ) )
			continue;
		
		if ( damage < 5 ) // ignore concussion grenades
			continue;
		
		break;
	}
	
	if ( level.bettyexplodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.bettyexplodethisframe = true;
	
	thread resetbettyExplodeThisFrame();
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	if ( isDefined( type ) && (isSubStr( type, "MOD_GRENADE" ) || isSubStr( type, "MOD_EXPLOSIVE" )) )
		self.wasChained = true;
	
	if ( isDefined( iDFlags ) && (iDFlags & level.iDFLAGS_PENETRATION) )
		self.wasDamagedFromBulletPenetration = true;
	
	self.wasDamaged = true;
	
	// "destroyed_explosive" notify, for challenges
	if ( isdefined( attacker ) && isdefined( attacker.pers["team"] ) && isdefined( self.owner ) && isdefined( self.owner.pers["team"] ) )
	{
		if ( ( attacker.pers["team"] != self.owner.pers["team"] ) || ( ( game["dialog"]["gametype"] == "freeforall" ) && (attacker != self.owner ) ) )
		{
			attacker notify("destroyed_explosive");
		
			detonateTime = gettime();
			
			if ( startTime + 3000 > detonateTime )
			{
				if ( attacker != self.owner )
					self.wasJustPlanted = true;
			}
		}
	
	}
	
	self detonate( attacker );
	// won't get here; got death notify.
}

resetbettyExplodeThisFrame()
{
	wait .05;
	level.bettyexplodethisframe = false;
}

satchelDamage()
{
	self endon( "death" );

	self setcandamage(true);
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	attacker = undefined;
	
	while(1)
	{
		self waittill ( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
		if ( !isplayer(attacker) )
			continue;
		
		// don't allow people to destroy satchel on their team if FF is off
		if ( !friendlyFireCheck( self.owner, attacker ) )
			continue;
		
		if ( damage < 5 ) // ignore concussion grenades
			continue;
		
		break;
	}
	
	if ( level.satchelexplodethisframe )
		wait .1 + randomfloat(.4);
	else
		wait .05;
	
	if (!isdefined(self))
		return;
	
	level.satchelexplodethisframe = true;
	
	thread resetSatchelExplodeThisFrame();
	
	self maps\mp\_entityheadicons::setEntityHeadIcon("none");
	
	if ( isDefined( type ) && (isSubStr( type, "MOD_GRENADE_SPLASH" ) || isSubStr( type, "MOD_GRENADE" ) || isSubStr( type, "MOD_EXPLOSIVE" )) )
		self.wasChained = true;
	
	if ( isDefined( iDFlags ) && (iDFlags & level.iDFLAGS_PENETRATION) )
		self.wasDamagedFromBulletPenetration = true;
	
	self.wasDamaged = true;
	
	// "destroyed_explosive" notify, for challenges
	if ( isdefined( attacker ) && isdefined( attacker.pers["team"] ) && isdefined( self.owner ) && isdefined( self.owner.pers["team"] ) )
	{
		if ( attacker.pers["team"] != self.owner.pers["team"] )
			attacker notify("destroyed_explosive");
	}
	
	self detonate( attacker );
	// won't get here; got death notify.
}

resetSatchelExplodeThisFrame()
{
	wait .05;
	level.satchelexplodethisframe = false;
}

saydamaged(orig, amount)
{
	for (i = 0; i < 60; i++)
	{
		print3d(orig, "damaged! " + amount);
		wait .05;
	}
}




bombDetectionTrigger_wait( ownerTeam )
{
	self endon ( "death" );
	waitTillNotMoving();

	if ( level.oldschool )
		return;

	self thread bombDetectionTrigger( ownerTeam );
}

bombDetectionTrigger( ownerTeam )
{
	trigger = spawn( "trigger_radius", self.origin-(0,0,128), 0, 512, 256 );
	trigger.detectId = "trigger" + getTime() + randomInt( 1000000 );
		
	trigger thread detectIconWaiter( level.otherTeam[ownerTeam] );

	self waittill( "death" );
	trigger notify ( "end_detection" );

	if ( isDefined( trigger.bombSquadIcon ) )
		trigger.bombSquadIcon destroy();
	
	trigger delete();	
}


detectIconWaiter( detectTeam )
{
	self endon ( "end_detection" );
	level endon ( "game_ended" );

	while( !level.gameEnded )
	{
		self waittill( "trigger", player );
		
		if ( isai( player ) )
			continue;
		
		if ( !isdefined ( player ) || !isDefined( player.detectExplosives ) || !player.detectExplosives )
			continue;
			
		// CODER_MOD: Bryce (05/08/08): Don't check team in FFA
		if ( player.team != detectTeam && level.scr_betty_friendly_fire == 0 && game["dialog"]["gametype"] != "freeforall" ) 
			continue;
			
		if ( isDefined( player.bombSquadIds[self.detectId] ) )
			continue;

		player thread showHeadIcon( self );
		/*
		if ( !isDefined( self.bombSquadIcon ) )
		{
			self.bombSquadIcon = newTeamHudElem( player.pers["team"] );
			self.bombSquadIcon.x = self.origin[0];
			self.bombSquadIcon.y = self.origin[1];
			self.bombSquadIcon.z = self.origin[2]+25+128;
			self.bombSquadIcon.alpha = 0;
			self.bombSquadIcon.archived = true;
			self.bombSquadIcon setShader( "waypoint_bombsquad", 14, 14 );
			self.bombSquadIcon setwaypoint( false );
		}

		self.bombSquadIcon fadeOverTime( 0.25 );
		self.bombSquadIcon.alpha = 0.85;

		while( isAlive( player ) && player isTouching( self ) )
			wait ( 0.05 );
		
		self.bombSquadIcon fadeOverTime( 0.25 );
		self.bombSquadIcon.alpha = 0;
		*/
	}
}


setupBombSquad()
{
	self.bombSquadIds = [];
	
	if ( self.detectExplosives && !self.bombSquadIcons.size )
	{
		for ( index = 0; index < 4; index++ )
		{
			self.bombSquadIcons[index] = newClientHudElem( self );
			self.bombSquadIcons[index].x = 0;
			self.bombSquadIcons[index].y = 0;
			self.bombSquadIcons[index].z = 0;
			self.bombSquadIcons[index].alpha = 0;
			self.bombSquadIcons[index].archived = true;
			self.bombSquadIcons[index] setShader( "waypoint_bombsquad", 14, 14 );
			self.bombSquadIcons[index] setWaypoint( false );
			self.bombSquadIcons[index].detectId = "";
		}
	}
	else if ( !self.detectExplosives )
	{
		for ( index = 0; index < self.bombSquadIcons.size; index++ )
			self.bombSquadIcons[index] destroy();
			
		self.bombSquadIcons = [];
	}
}


showHeadIcon( trigger )
{
	triggerDetectId = trigger.detectId;
	useId = -1;
	for ( index = 0; index < 4; index++ )
	{
		detectId = self.bombSquadIcons[index].detectId;

		if ( detectId == triggerDetectId )
			return;
			
		if ( detectId == "" )
			useId = index;
	}
	
	if ( useId < 0 )
		return;

	self.bombSquadIds[triggerDetectId] = true;
	
	self.bombSquadIcons[useId].x = trigger.origin[0];
	self.bombSquadIcons[useId].y = trigger.origin[1];
	self.bombSquadIcons[useId].z = trigger.origin[2]+24+128;

	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 1;
	self.bombSquadIcons[useId].detectId = trigger.detectId;
	
	while ( isAlive( self ) && isDefined( trigger ) && self isTouching( trigger ) )
		wait ( 0.05 );
		
	if ( !isDefined( self ) )
		return;
		
	self.bombSquadIcons[useId].detectId = "";
	self.bombSquadIcons[useId] fadeOverTime( 0.25 );
	self.bombSquadIcons[useId].alpha = 0;
	self.bombSquadIds[triggerDetectId] = undefined;
}


playbettyEffects()
{
	self endon("death");

	while(1)
	{
		self waittillNotMoving();

		org = self getTagOrigin( "tag_flash" );
		ang = self getTagAngles( "tag_flash" );
		fx = spawnFx( level.bettyGlintid, org + anglesToForward( ang ) * 12, anglesToForward( ang ), anglesToUp( ang ) );
		triggerfx( fx );

		self thread clearFXOnDeath( fx );

		originalOrigin = self.origin;

		while(1)
		{
			wait .25;
			if ( self.origin != originalOrigin )
				break;
		}

		fx delete();
	}
}

clearFXOnDeath( fx )
{
	fx endon("death");
	self waittill("death");
	fx delete();
}


// these functions are used with scripted weapons (like satchels, shoeboxs, artillery)
// returns an array of objects representing damageable entities (including players) within a given sphere.
// each object has the property damageCenter, which represents its center (the location from which it can be damaged).
// each object also has the property entity, which contains the entity that it represents.
// to damage it, call damageEnt() on it.
getDamageableEnts(pos, radius, doLOS, startRadius)
{
	ents = [];
	
	if (!isdefined(doLOS))
		doLOS = false;
		
	if ( !isdefined( startRadius ) )
		startRadius = 0;
	
	// players
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]) || players[i].sessionstate != "playing")
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, playerpos, startRadius, undefined)))
		{
			newent = spawnstruct();
			newent.isPlayer = true;
			newent.isADestructable = false;
			newent.entity = players[i];
			newent.damageCenter = playerpos;
			ents[ents.size] = newent;
		}
	}
	
	// grenades
	grenades = getentarray("grenade", "classname");
	for (i = 0; i < grenades.size; i++)
	{
		entpos = grenades[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, grenades[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = grenades[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	destructibles = getentarray("destructible", "targetname");
	for (i = 0; i < destructibles.size; i++)
	{
		entpos = destructibles[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructibles[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = false;
			newent.entity = destructibles[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}

	destructables = getentarray("destructable", "targetname");
	for (i = 0; i < destructables.size; i++)
	{
		entpos = destructables[i].origin;
		dist = distance(pos, entpos);
		if (dist < radius && (!doLOS || weaponDamageTracePassed(pos, entpos, startRadius, destructables[i])))
		{
			newent = spawnstruct();
			newent.isPlayer = false;
			newent.isADestructable = true;
			newent.entity = destructables[i];
			newent.damageCenter = entpos;
			ents[ents.size] = newent;
		}
	}
	
	return ents;
}

weaponDamageTracePassed(from, to, startRadius, ignore)
{
	midpos = undefined;
	
	diff = to - from;
	if ( lengthsquared( diff ) < startRadius*startRadius )
		midpos = to;
	dir = vectornormalize( diff );
	midpos = from + (dir[0]*startRadius, dir[1]*startRadius, dir[2]*startRadius);

	trace = bullettrace(midpos, to, false, ignore);
	
	if ( getdvarint("scr_damage_debug") != 0 )
	{
		if (trace["fraction"] == 1)
		{
			thread debugline(midpos, to, (1,1,1));
		}
		else
		{
			thread debugline(midpos, trace["position"], (1,.9,.8));
			thread debugline(trace["position"], to, (1,.4,.3));
		}
	}
	
	return (trace["fraction"] == 1);
}

// eInflictor = the entity that causes the damage (e.g. a shoebox)
// eAttacker = the player that is attacking
// iDamage = the amount of damage to do
// sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
// sWeapon = string specifying the weapon used (e.g. "mine_shoebox_mp")
// damagepos = the position damage is coming from
// damagedir = the direction damage is moving in
damageEnt(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, damagepos, damagedir)
{
	if (self.isPlayer)
	{
		self.damageOrigin = damagepos;
		self.entity thread [[level.callbackPlayerDamage]](
			eInflictor, // eInflictor The entity that causes the damage.(e.g. a turret)
			eAttacker, // eAttacker The entity that is attacking.
			iDamage, // iDamage Integer specifying the amount of damage done
			0, // iDFlags Integer specifying flags that are to be applied to the damage
			sMeansOfDeath, // sMeansOfDeath Integer specifying the method of death
			sWeapon, // sWeapon The weapon number of the weapon used to inflict the damage
			damagepos, // vPoint The point the damage is from?
			damagedir, // vDir The direction of the damage
			"none", // sHitLoc The location of the hit
			0 // psOffsetTime The time offset for the damage
		);
	}
	else
	{
		// destructable walls and such can only be damaged in certain ways.
		if (self.isADestructable && (sWeapon == "artillery_mp" || sWeapon == "mine_bouncing_betty_mp"))
			return;
		
		self.entity notify("damage", iDamage, eAttacker, (0,0,0), (0,0,0), "mod_explosive", "", "" );
	}
}

debugline(a, b, color)
{
	for (i = 0; i < 30*20; i++)
	{
		line(a,b, color);
		wait .05;
	}
}


onWeaponDamage( eInflictor, sWeapon, meansOfDeath, damage )
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon("death_or_disconnect");

	switch( sWeapon )
	{
		case "concussion_grenade_mp":
			// should match weapon settings in gdt
			radius = 512;
			scale = 1 - (distance( self.origin, eInflictor.origin ) / radius);
			
			if ( scale < 0 )
				scale = 0;
			
			time = 2 + (4 * scale);
			
			wait ( 0.05 );
//			self shellShock( "concussion_grenade_mp", time );
			self.concussionEndTime = getTime() + (time * 1000);
		break;
		default:
			// shellshock will only be done if meansofdeath is an appropriate type and if there is enough damage.
			maps\mp\gametypes\_shellshock::shellshockOnDamage( meansOfDeath, damage );
		break;
	}
	
}

// weapon stowing logic ===================================================================

// weapon class boolean helpers
isPrimaryWeapon( weaponname )
{
	return isdefined( level.primary_weapon_array[weaponname] );
}
isSideArm( weaponname )
{
	return isdefined( level.side_arm_array[weaponname] );
}
isInventory( weaponname )
{
	return isdefined( level.inventory_array[weaponname] );
}
isGrenade( weaponname )
{
	return isdefined( level.grenade_array[weaponname] );
}
getWeaponClass_array( current )
{
	if( isPrimaryWeapon( current ) )
		return level.primary_weapon_array;
	else if( isSideArm( current ) )
		return level.side_arm_array;
	else if( isGrenade( current ) )
		return level.grenade_array;
	else
		return level.inventory_array;
}

// thread loop life = player's life
updateStowedWeapon()
{
	self endon( "spawned" );
	self endon( "killed_player" );
	self endon( "disconnect" );
	
	//detach_all_weapons();
	
	self.tag_stowed_back = undefined;
	self.tag_stowed_hip = undefined;
	
	team = self.pers["team"];
	class = self.pers["class"];
	
	while ( true )
	{
		self waittill( "weapon_change", newWeapon );
		
		// weapon array reset, might have swapped weapons off the ground
		self.weapon_array_primary =[];
		self.weapon_array_sidearm = [];
		self.weapon_array_grenade = [];
		self.weapon_array_inventory =[];
	
		// populate player's weapon stock arrays
		weaponsList = self GetWeaponsList();
		for( idx = 0; idx < weaponsList.size; idx++ )
		{
			if ( isPrimaryWeapon( weaponsList[idx] ) )
				self.weapon_array_primary[self.weapon_array_primary.size] = weaponsList[idx];
			else if ( isSideArm( weaponsList[idx] ) )
				self.weapon_array_sidearm[self.weapon_array_sidearm.size] = weaponsList[idx];
			else if ( isGrenade( weaponsList[idx] ) )
				self.weapon_array_grenade[self.weapon_array_grenade.size] = weaponsList[idx];
			else if ( isInventory( weaponsList[idx] ) )
				self.weapon_array_inventory[self.weapon_array_inventory.size] = weaponsList[idx];
		}

		detach_all_weapons();
		stow_on_back();
		stow_on_hip();
	}
}

forceStowedWeaponUpdate()
{
	detach_all_weapons();
	stow_on_back();
	stow_on_hip();
}

detachCarryObjectModel()
{
	if ( isDefined( self.carryObject ) && isdefined(self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel())  )
	{
		if( isDefined( self.tag_stowed_back ) )
		{
			self detach( self.tag_stowed_back, "tag_stowed_back" );
			self.tag_stowed_back = undefined;
		}
	}
}

detach_all_weapons()
{
	if( isDefined( self.tag_stowed_back ) )
	{
		self detach( self.tag_stowed_back, "tag_stowed_back" );
		self.tag_stowed_back = undefined;
	}
	if( isDefined( self.tag_stowed_hip ) )
	{
		detach_model = getWeaponModel( self.tag_stowed_hip );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.tag_stowed_hip = undefined;
	}
}

stow_on_back()
{
	current = self getCurrentWeapon();

	self.tag_stowed_back = undefined;
	
	//  carry objects take priority
	if ( isDefined( self.carryObject ) && isdefined(self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel())  )
	{
		self.tag_stowed_back = self.carryObject maps\mp\gametypes\_gameobjects::getVisibleCarrierModel();
	}
	else if ( self hasWeapon( "m2_flamethrower_mp" ) )
	{
		// no back stowing if you have flamethrower tanks
		return;
	}	
	//  large projectile weaponry always show
	else if ( self hasWeapon( "bazooka_mp" ) && current != "bazooka_mp" )
	{
		self.tag_stowed_back = "weapon_mp_bazooka_attach";
	}
	else
	{
		for ( idx = 0; idx < self.weapon_array_primary.size; idx++ )
		{
			index_weapon = self.weapon_array_primary[idx];
			assertex( isdefined( index_weapon ), "Primary weapon list corrupted." );
			
			if ( index_weapon == current )
				continue;
				
			/*
			if ( (isSubStr( current, "gl_" ) || isSubStr( current, "_gl_" )) && (isSubStr( self.weapon_array_primary[idx], "gl_" ) || isSubStr( self.weapon_array_primary[idx], "_gl_" )) )
				continue; 
			*/

			if( isSubStr( current, "gl_" ) || isSubStr( index_weapon, "gl_" ) )
			{
				index_weapon_tok = strtok( index_weapon, "_" );
				current_tok = strtok( current, "_" );
				// finding the alt-mode of current weapon; the tokens of both weapons are subsets of each other
				for( i=0; i<index_weapon_tok.size; i++ ) 
				{
					if( !isSubStr( current, index_weapon_tok[i] ) || index_weapon_tok.size != current_tok.size )
	{
						i = 0;
						break;
					}
				}
				if( i == index_weapon_tok.size )
			continue;
	}
	
			// camo only applicable for custom classes
			assertex( isdefined( self.curclass ), "Player missing current class" );
			if ( isDefined( self.custom_class ) && isDefined( self.custom_class[self.class_num]["camo_num"] ) && isSubStr( index_weapon, self.pers["primaryWeapon"] ) && isSubStr( self.curclass, "CUSTOM" ) )
				self.tag_stowed_back = getWeaponModel( index_weapon, self.custom_class[self.class_num]["camo_num"] );
			else
				self.tag_stowed_back = getWeaponModel( index_weapon, 0 );
		}
	}
		
	if ( !isDefined( self.tag_stowed_back ) )
		return;
	
	self attach( self.tag_stowed_back, "tag_stowed_back", true );
}

stow_on_hip()
{
	current = self getCurrentWeapon();

	self.tag_stowed_hip = undefined;
	/*
	for ( idx = 0; idx < self.weapon_array_sidearm.size; idx++ )
	{
		if ( self.weapon_array_sidearm[idx] == current )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_sidearm[idx];
	}
	*/

	for ( idx = 0; idx < self.weapon_array_inventory.size; idx++ )
	{
		if ( self.weapon_array_inventory[idx] == current )
			continue;

		if ( !self GetWeaponAmmoStock( self.weapon_array_inventory[idx] ) )
			continue;
			
		self.tag_stowed_hip = self.weapon_array_inventory[idx];
	}

	if ( !isDefined( self.tag_stowed_hip ) )
		return;

	// getting rid of these until we get attach models
	if ( self.tag_stowed_hip == "satchel_charge_mp" || self.tag_stowed_hip == "mine_bouncing_betty_mp" )
	{
		self.tag_stowed_hip = undefined;
		return;
	}
		
	weapon_model = getWeaponModel( self.tag_stowed_hip );
	self attach( weapon_model, "tag_stowed_hip_rear", true );
}


stow_inventory( inventories, current )
{
	// deatch last weapon attached
	if( isdefined( self.inventory_tag ) )
	{
		detach_model = getweaponmodel( self.inventory_tag );
		self detach( detach_model, "tag_stowed_hip_rear" );
		self.inventory_tag = undefined;
	}

	if( !isdefined( inventories[0] ) || self GetWeaponAmmoStock( inventories[0] ) == 0 )
		return;

	if( inventories[0] != current )
	{
		self.inventory_tag = inventories[0];
		weapon_model = getweaponmodel( self.inventory_tag );
		self attach( weapon_model, "tag_stowed_hip_rear", true );
	}
}


// returns dvar value in int
weapons_get_dvar_int( dvar, def )
{
	return int( weapons_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
weapons_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

player_is_driver()
{
	if ( !isalive(self) )
		return false;
		
	vehicle = self GetVehicleOccupied();
	
	if ( IsDefined( vehicle ) )
	{
		seat = vehicle GetOccupantSeat( self );
		
		if ( isdefined(seat) && seat == 0 )
			return true;
	}
	
	return false;
}
