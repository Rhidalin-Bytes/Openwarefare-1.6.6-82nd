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

#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

#include openwarfare\_utils;

init()
{
	if( !isDefined( game["class_counts"] ) )
	{
		game["class_counts"] = [];

		game["class_counts"]["allies_grenadier"] = 0;
		game["class_counts"]["allies_rifleman"] = 0;
		game["class_counts"]["allies_gl"] = 0;	
		game["class_counts"]["allies_lightgunner"] = 0;
		game["class_counts"]["allies_heavygunner"] = 0;
		game["class_counts"]["allies_closeassault"] = 0;
		game["class_counts"]["allies_sniper"] = 0;
		
		game["class_counts"]["axis_grenadier"] = 0;
		game["class_counts"]["axis_rifleman"] = 0;
		game["class_counts"]["axis_gl"] = 0;	
		game["class_counts"]["axis_lightgunner"] = 0;
		game["class_counts"]["axis_heavygunner"] = 0;
		game["class_counts"]["axis_closeassault"] = 0;
		game["class_counts"]["axis_sniper"] = 0;
	}

	if( !isDefined( game["perk_counts"] ) )
	{
		game["perk_counts"] = [];

		game["perk_counts"]["allies_betty"] = 0;
		game["perk_counts"]["allies_satchel"] = 0;
		game["perk_counts"]["allies_bazooka"] = 0;
		game["perk_counts"]["allies_flamethrower"] = 0;
		
		game["perk_counts"]["axis_betty"] = 0;
		game["perk_counts"]["axis_satchel"] = 0;
		game["perk_counts"]["axis_bazooka"] = 0;
		game["perk_counts"]["axis_flamethrower"] = 0;
	}

	if( !isDefined( game["misc"] ) )
	{
		game["misc"] = [];

		game["misc"]["allies_smoke"] = 0;
		game["misc"]["axis_smoke"] = 0;
	}
	
	// Initialize arrays
	game["mwf_classes"] = [];
	game["mwf_weapons"] = [];
	game["mwf_weapons_aux"] = [];
	game["mwf_attachments"] = [];
	game["mwf_perks"] = [];

	// Initialize variable to control updateClassLimits()
	level.updateClassLimitsWaiting = false;
	level.updateClassLimitsRunning = false;
	level.ignoreUpdateClassLimit = false;

	//**************************************************************************
	// Grenadier weapons:
	//**************************************************************************
	initWeaponData( "kar98k", "grenadier", "axis", "german" );
	initWeaponData( "mosinrifle", "grenadier", "allies", "russian" );
	initWeaponData( "springfield", "grenadier", "allies", "marines" );
	initWeaponData( "type99rifle", "grenadier", "axis", "japanese" );
	initWeaponAttachments( "grenadier", "none;bayonet;gl" );
		
	//**************************************************************************
	// Rifleman weapons:
	//**************************************************************************
	initWeaponData( "svt40", "rifleman", "allies", "russian" );
	initWeaponData( "gewehr43", "rifleman", "axis", "german" );
	initWeaponData( "m1garand", "rifleman", "allies", "marines" );
	initWeaponData( "m1carbine", "rifleman", "allies", "marines" );
	initWeaponAttachments( "rifleman", "none;aperture;bayonet;bigammo;flash;gl;silenced;telescopic" );
	
	game["attach_gl_limit"] = getdvarx( "attach_gl_limit", "int", 64, 0, 64 );

	//**************************************************************************
	// Light Gunner weapons:
	//**************************************************************************
	initWeaponData( "thompson", "lightgunner", "allies", "marines" );
	initWeaponData( "mp40", "lightgunner", "axis", "german" );
	initWeaponData( "type100smg", "lightgunner", "axis", "japanese" );
	initWeaponData( "ppsh", "lightgunner", "allies", "russian" );
	initWeaponData( "stg44", "lightgunner", "axis", "german" );
	initWeaponAttachments( "lightgunner", "none;aperture;bigammo;silenced;flash;telescopic" );
	
	//**************************************************************************
	// Heavygunner weapons:
	//**************************************************************************
	initWeaponData( "30cal", "heavygunner", "allies", "marines" );
	initWeaponData( "bar", "heavygunner", "allies", "marines" );
	initWeaponData( "dp28", "heavygunner", "allies", "russian" );
	initWeaponData( "fg42", "heavygunner", "axis", "german" );
	initWeaponData( "mg42", "heavygunner", "axis", "german" );
	initWeaponData( "type99lmg", "heavygunner", "axis", "japanese" );
	initWeaponAttachments( "heavygunner", "none;bayonet;bipod;telescopic" );
	
	//**************************************************************************
	// Close Assault weapons:
	//**************************************************************************
	initWeaponData( "shotgun", "closeassault", "allies", game["allies"] );
	initWeaponData( "doublebarreledshotgun", "closeassault", "axis", game["axis"] );
	initWeaponAttachments( "closeassault", "none;bayonet;grip;sawoff" );
	
	//**************************************************************************
	// Sniper weapons:
	//**************************************************************************
	initWeaponData( "kar98k", "sniper", "axis", "german" );
	initWeaponData( "mosinrifle", "sniper", "allies", "russian" );
	initWeaponData( "ptrs41", "sniper", "allies", "russian" );
	initWeaponData( "springfield", "sniper", "allies", "marines" );
	initWeaponData( "type99rifle", "sniper", "axis", "japanese" );
	initWeaponData( "m1garand", "sniper", "allies", "marines" );
		
	//**************************************************************************
	// Handguns
	//**************************************************************************
	initWeaponData( "colt", "all", "allies", "marines" );
	initWeaponData( "nambu", "all", "axis", "japanese" );
	initWeaponData( "walther", "all", "axis", "german" );
	initWeaponData( "tokarev", "all", "allies", "russian" );
	initWeaponData( "357magnum", "all", "all", "all" );
	
	//**************************************************************************
	// Primary and Special Grenades
	//**************************************************************************
	initWeaponData( "frag_grenade", "all", "all", "all" );
	initWeaponData( "sticky_grenade", "all", "all", "all" );
	initWeaponData( "molotov", "all", "all", "all" );
	initWeaponData( "tabun_gas", "all", "all", "all" );
	initWeaponData( "signal_flare", "all", "all", "all" );
	initWeaponData( "m8_white_smoke", "all", "all", "all" );
	
	//**************************************************************************
	// Perks
	//**************************************************************************
	initPerkData( "specialty_specialgrenade" );
	initPerkData( "mine_bouncing_betty_mp", "specialty_weapon_bouncing_betty" );
	initPerkData( "specialty_fraggrenade" );
	initPerkData( "specialty_extraammo" );
	initPerkData( "specialty_detectexplosive" );
	initPerkData( "m2_flamethrower_mp", "specialty_weapon_flamethrower" );
	initPerkData( "bazooka_mp", "specialty_weapon_bazooka" );
	initPerkData( "satchel_charge_mp", "specialty_weapon_satchel_charge" );
	
	game["perk_specialty_weapon_bouncing_betty_limit"] = getdvarx( "perk_specialty_weapon_bouncing_betty_limit", "int", 64, 0, 64 );
	game["perk_specialty_weapon_flamethrower_limit"] = getdvarx( "perk_specialty_weapon_flamethrower_limit", "int", 64, 0, 64 );
	game["perk_specialty_weapon_bazooka_limit"] = getdvarx( "perk_specialty_weapon_bazooka_limit", "int", 64, 0, 64 );
	game["perk_specialty_weapon_satchel_charge_limit"] = getdvarx( "perk_specialty_weapon_satchel_charge_limit", "int", 64, 0, 64 );
	
	game["m8_white_smoke_limit"] = getdvarx( "m8_white_smoke_limit", "int", 64, 0, 64 );
	
	initPerkData( "specialty_bulletdamage" );
	initPerkData( "specialty_armorvest" );
	initPerkData( "specialty_fastreload" );
	initPerkData( "specialty_rof" );
	initPerkData( "specialty_gpsjammer" );
	initPerkData( "specialty_explosivedamage" );
	initPerkData( "specialty_flakjacket" );
	initPerkData( "specialty_shades" );
	initPerkData( "specialty_gas_mask" );
	
	initPerkData( "specialty_longersprint" );
	initPerkData( "specialty_bulletaccuracy" );
	initPerkData( "specialty_pistoldeath" );
	initPerkData( "specialty_grenadepulldeath" );
	initPerkData( "specialty_bulletpenetration" );
	initPerkData( "specialty_holdbreath" );
	initPerkData( "specialty_quieter" );
	initPerkData( "specialty_fireproof" );
	initPerkData( "specialty_reconnaissance" );
	initPerkData( "specialty_pin_back" );
	
	initPerkData( "specialty_water_cooled" );
	initPerkData( "specialty_greased_barrings" );
	initPerkData( "specialty_ordinance" );
	initPerkData( "specialty_boost" );
	initPerkData( "specialty_leadfoot" );


	// Classes
	initClassData( "grenadier", "springfield;springfield;type99rifle;springfield;mosinrifle;kar98k;type99rifle", "bayonet", "colt;colt;walther;colt;tokarev;walther;nambu", "satchel_charge_mp", "specialty_bulletdamage", "specialty_longersprint", "specialty_water_cooled", "frag_grenade", 1, "signal_flare", 1 );
	initClassData( "rifleman", "svt40;m1garand;gewehr43;m1garand;svt40;gewehr43;none", "none", "colt;colt;walther;colt;tokarev;walther;nambu", "satchel_charge_mp", "specialty_bulletdamage", "specialty_longersprint", "specialty_water_cooled", "frag_grenade", 1, "signal_flare", 1 );
	initClassData( "lightgunner", "thompson;thompson;mp40;thompson;ppsh;mp40;type100smg", "none", "colt;colt;walther;colt;tokarev;walther;nambu", "specialty_specialgrenade", "specialty_gas_mask", "specialty_bulletaccuracy", "specialty_water_cooled", "frag_grenade", 1, "signal_flare", 1 );
	initClassData( "heavygunner", "type99lmg;bar;type99lmg;bar;dp28;fg42;type99lmg", "none", "nambu;colt;nambu;colt;tokarev;walther;nambu", "specialty_specialgrenade", "specialty_flakjacket", "specialty_bulletpenetration", "specialty_water_cooled", "frag_grenade", 1, "tabun_gas", 1 );
	initClassData( "closeassault", "shotgun;shotgun;doublebarreledshotgun;shotgun;shotgun;doublebarreledshotgun;doublebarreledshotgun", "none", "walther;colt;walther;colt;tokarev;walther;nambu", "bazooka_mp", "specialty_explosivedamage", "specialty_longersprint", "specialty_greased_barrings", "sticky_grenade", 1, "tabun_gas", 1 );
	initClassData( "sniper", "springfield;springfield;type99rifle;springfield;mosinrifle;kar98k;type99rifle", "scoped", "colt;colt;walther;colt;tokarev;walther;nambu", "satchel_charge_mp", "specialty_bulletdamage", "specialty_bulletpenetration", "specialty_water_cooled", "frag_grenade", 1, "m8_white_smoke", 1 ); 

	// Force "scoped" for sniper class
	if ( game["mwf_classes"]["sniper"]["primary"] != "ptrs41" ) {
		game["mwf_classes"]["sniper"]["primary_attachment"] = "scoped";
	} else {
		game["mwf_classes"]["sniper"]["primary_attachment"] = "none";
	}

	
	level thread onPlayerConnect();
	//level thread openwarfare\unrankedbots::init();
}

initWeaponData( weaponName, weaponClass, weaponTeam, weaponCountry )
{
	// Check if we already have this class
	if ( !isDefined( game["mwf_weapons"][weaponClass] ) ) {
		game["mwf_weapons"][weaponClass] = [];
		game["mwf_weapons_aux"][weaponClass] = [];
	}
	
	// Get the new element
	newElement = game["mwf_weapons"][weaponClass].size;
	
	// Save the new index for quick access
	game["mwf_weapons_aux"][weaponClass][weaponName] = newElement;
	
	game["mwf_weapons"][weaponClass][newElement] = [];
	game["mwf_weapons"][weaponClass][newElement]["name"] = weaponName;
	
	if ( weaponClass != "all" )
		game["mwf_weapons"][weaponClass][newElement]["allow"] = getdvarx( "weap_allow_" + weaponClass + "_" + weaponName, "int", 1, 0, 3 );
	else
		game["mwf_weapons"][weaponClass][newElement]["allow"] = getdvarx( "weap_allow_" + weaponName, "int", 1, 0, 3 );
		
	game["mwf_weapons"][weaponClass][newElement]["team"] = weaponTeam;
	game["mwf_weapons"][weaponClass][newElement]["country"] = weaponCountry;
}

isWeaponAllowed( weaponClass, weaponName, playerTeam, playerCountry )
{
	weaponAllowed = 0;
	
	iWeapon = game["mwf_weapons_aux"][weaponClass][weaponName];
	if ( isDefined( iWeapon ) ) {
		// 0 = Not allowed, 1 = Allowed for all, 2 = Allowed for team, 3 = Allowed for country 
		if ( game["mwf_weapons"][weaponClass][iWeapon]["allow"] == 1 ) {
			weaponAllowed = 1;
		} else if ( game["mwf_weapons"][weaponClass][iWeapon]["allow"] == 2 && ( game["mwf_weapons"][weaponClass][iWeapon]["team"] == "all" || game["mwf_weapons"][weaponClass][iWeapon]["team"] == playerTeam ) ) {
			weaponAllowed = 1;
		} else if ( game["mwf_weapons"][weaponClass][iWeapon]["allow"] == 3 && ( game["mwf_weapons"][weaponClass][iWeapon]["country"] == "all" || game["mwf_weapons"][weaponClass][iWeapon]["country"] == playerCountry ) ) {
			weaponAllowed = 1;
		}						
	}
	
	return weaponAllowed;	
}

initWeaponAttachments( weaponClass, weaponAttachments )
{
	game["mwf_attachments"][weaponClass] = [];
	
	// Spam list of attachments
	weaponAttachments = strtok( weaponAttachments, ";" );
	for ( iAttach = 0; iAttach < weaponAttachments.size; iAttach++ ) {		
		game["mwf_attachments"][weaponClass][weaponAttachments[iAttach]] = getdvarx( "attach_allow_" + weaponClass + "_" + weaponAttachments[iAttach], "int", 1, 0, 1 );
	}
}

isAttachmentAllowed( weaponClass, attachmentName )
{
	return game["mwf_attachments"][weaponClass][attachmentName];	
}

initClassData( className, primary, attachment, secondary, perk1, perk2, perk3, perk4, pgrenade, pgrenade_count, sgrenade, sgrenade_count )
{
	// Load class limits
	game[ "allies_" + className + "_limit" ] = getdvarx( "class_allies_" + className + "_limit", "int", 64, 0, 64 );
	game[ "axis_" + className + "_limit" ] = getdvarx( "class_axis_" + className + "_limit", "int", 64, 0, 64 );
	
	// Add new element
	game["mwf_classes"][className] = [];
	game["mwf_classes"][className]["primary"] = getdvarx( "class_" + className + "_primary", "string", primary );
	game["mwf_classes"][className]["primary_attachment"] = getdvarx( "class_" + className + "_primary_attachment", "string", attachment );
	game["mwf_classes"][className]["secondary"] = getdvarx( "class_" + className + "_secondary", "string", secondary );
	game["mwf_classes"][className]["perk1"] = getDefaultPerk( className, 1, perk1 );
	game["mwf_classes"][className]["perk2"] = getDefaultPerk( className, 2, perk2 );
	game["mwf_classes"][className]["perk3"] = getDefaultPerk( className, 3, perk3 );
	game["mwf_classes"][className]["perk4"] = getDefaultPerk( className, 4, perk4 );
	game["mwf_classes"][className]["pgrenade"] = getdvarx( "class_" + className + "_pgrenade", "string", pgrenade );
	game["mwf_classes"][className]["pgrenade_count"] = getdvarx( "class_" + className + "_pgrenade_count", "int", pgrenade_count, 0, 4 );
	game["mwf_classes"][className]["sgrenade"] = getdvarx( "class_" + className + "_sgrenade", "string", sgrenade );
	game["mwf_classes"][className]["sgrenade_count"] = getdvarx( "class_" + className + "_sgrenade_count", "int", sgrenade_count, 0, 4 );	

	// Lock menu options
	game["mwf_classes"][className]["lock_primary"] = getdvarx( "class_" + className + "_lock_primary", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_primary_attachment"] = getdvarx( "class_" + className + "_lock_primary_attachment", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_secondary"] = getdvarx( "class_" + className + "_lock_secondary", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_perk1"] = getdvarx( "class_" + className + "_lock_perk1", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_perk2"] = getdvarx( "class_" + className + "_lock_perk2", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_perk3"] = getdvarx( "class_" + className + "_lock_perk3", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_perk4"] = getdvarx( "class_" + className + "_lock_perk4", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_pgrenade"] = getdvarx( "class_" + className + "_lock_pgrenade", "int", 0, 0, 1 );
	game["mwf_classes"][className]["lock_sgrenade"] = getdvarx( "class_" + className + "_lock_sgrenade", "int", 0, 0, 1 );
}

getDefaultPerk( className, perkNumber, defaultValue )
{
	// Get the default perk to use
	perkName = getdvarx( "class_" + className + "_perk" + perkNumber, "string", defaultValue );
	// Validate the perk
	if ( !isPerkAllowed( perkName, className ) ) {
		perkName = "specialty_null";
	}
	return perkName;	
}

initPerkData( perkName, varName )
{
	if ( !isDefined( varName ) ) {
		varName = perkName;
	}
	
	game["mwf_perks"][perkName] = [];
	perkAllowed = getdvarx( "perk_allow_" + varName, "int", 1, 0, 1 );	
	
	// Check if the perk status for the classes
	game["mwf_perks"][perkName]["grenadier"] = ( perkAllowed && getdvarx( "perk_grenadier_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	game["mwf_perks"][perkName]["rifleman"] = ( perkAllowed && getdvarx( "perk_rifleman_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	game["mwf_perks"][perkName]["lightgunner"] = ( perkAllowed && getdvarx( "perk_lightgunner_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	game["mwf_perks"][perkName]["heavygunner"] = ( perkAllowed && getdvarx( "perk_heavygunner_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	game["mwf_perks"][perkName]["closeassault"] = ( perkAllowed && getdvarx( "perk_closeassault_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	game["mwf_perks"][perkName]["sniper"] = ( perkAllowed && getdvarx( "perk_sniper_allow_" + varName, "int", perkAllowed, 0, 1 ) );	
	
}

isPerkAllowed( perkName, className )
{
	if ( isDefined( game["mwf_perks"][perkName] ) && isDefined( game["mwf_perks"][perkName][className] ) ) 
		return ( game["mwf_perks"][perkName][className] );	
	else
		return 0;
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connected", player );
		
		player thread onPlayerDisconnect();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();		
		
		player thread setNonClassSpecificDvars();		
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
	level thread updateClassLimits();
}

onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		// If this player already has a class it means it switched teams 
		if ( isDefined( self.pers["class"] ) && self resetPlayerClassOnTeamSwitch( false ) ) {
			self thread setLoadoutForClass( self.pers["class"] );
		}
		
		// Get player's team and country
		playerTeam = self.pers["team"];
		if ( playerTeam == "allies" ) {
			playerCountry = game["allies"];
		} else {
			playerCountry = game["axis"];
		}
		
		self thread setClassIndependent( playerTeam, playerCountry );
		self thread setClassDependent( playerTeam, playerCountry );
		
		if ( !level.ignoreUpdateClassLimit ) {
			level thread updateClassLimits();
		}
	}
}

onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		level thread updateClassLimits();
	}
}

updateClassLimits()
{
	// Check if there's another thread waiting
	if ( level.updateClassLimitsWaiting )
		return;
		
	// Check if there's another thread running
	if ( level.updateClassLimitsRunning ) {
		// Flag that the thread is waiting and wait for the running thread to finish
		level.updateClassLimitsWaiting = true;
		while ( level.updateClassLimitsRunning )
			wait (0.05);
		// Flag that we stopped waiting
		level.updateClassLimitsWaiting = false;
	}
	
	// Flag that we are running
	level.updateClassLimitsRunning = true;	
	
	counts = [];

	counts["axis_grenadier"] = 0;
	counts["axis_rifleman"] = 0;
	counts["axis_gl"] = 0;
	counts["axis_lightgunner"] = 0;
	counts["axis_heavygunner"] = 0;
	counts["axis_closeassault"] = 0;
	counts["axis_sniper"] = 0;

	counts["allies_grenadier"] = 0;
	counts["allies_rifleman"] = 0;
	counts["allies_gl"] = 0;
	counts["allies_lightgunner"] = 0;
	counts["allies_heavygunner"] = 0;
	counts["allies_closeassault"] = 0;
	counts["allies_sniper"] = 0;

	perkcounts = [];
	perkcounts["allies_betty"] = 0;
	perkcounts["allies_satchel"] = 0;
	perkcounts["allies_bazooka"] = 0;
	perkcounts["allies_flamethrower"] = 0;
	
	perkcounts["axis_betty"] = 0;
	perkcounts["axis_satchel"] = 0;
	perkcounts["axis_bazooka"] = 0;
	perkcounts["axis_flamethrower"] = 0;

	misc = [];
	misc["allies_smoke"] = 0;
	misc["axis_smoke"] = 0;

	players = level.players;
	for( i=0; i<players.size; i++ )
	{
		player = players[i];
		if( isDefined( player ) && isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" && isDefined( player.pers["class"] ) )
		{
			counts[ player.pers["team"] + "_" + player.pers["class"] ]++;
			
			// Check if this player is using the rifle grenade
			if ( ( player.pers["class"] == "grenadier" && player.pers["grenadier"]["loadout_primary_attachment"] == "gl" ) || ( player.pers["class"] == "rifleman" ) && player.pers["rifleman"]["loadout_primary_attachment"] == "gl" ) {
				counts[ player.pers["team"] + "_gl" ]++;
			}
			
			// Check for perk1 
			switch ( player.pers[player.pers["class"]]["loadout_perk1"] ) {
				case "mine_bouncing_betty_mp":
					perkcounts[ player.pers["team"] + "_betty" ]++;
					break;
				case "m2_flamethrower_mp":
					perkcounts[ player.pers["team"] + "_flamethrower" ]++;
					break;
				case "bazooka_mp":
					perkcounts[ player.pers["team"] + "_bazooka" ]++;
					break;
				case "satchel_charge_mp":
					perkcounts[ player.pers["team"] + "_satchel" ]++;
					break;															
			}
			
			// Check for special grenades
			switch ( player.pers[player.pers["class"]]["loadout_sgrenade"] ) {
				case "m8_white_smoke":
					misc[ player.pers["team"] + "_smoke" ]++;
					break;
			}
						
		}
	}

	game["class_counts"] = counts;
	game["perk_counts"] = perkcounts;
	game["misc"] = misc;

	players = level.players;
	for( i=0; i<players.size; i++ )
		players[i] thread updateAvailableClasses();
		
	// Thread completed
	level.updateClassLimitsRunning = false;
}

setNonClassSpecificDvars()
{
	self endon("disconnect");
	
	// Wait until the player joins a team to delay settings of variables
	self waittill("joined_team");
	
	self setClientDvars( 
		"attach_allow_grenadier_none", game["mwf_attachments"]["grenadier"]["none"],
		"attach_allow_grenadier_bayonet", game["mwf_attachments"]["grenadier"]["bayonet"],
	
		"attach_allow_rifleman_none", game["mwf_attachments"]["rifleman"]["none"],
		"attach_allow_rifleman_aperture", game["mwf_attachments"]["rifleman"]["aperture"],
		"attach_allow_rifleman_bayonet", game["mwf_attachments"]["rifleman"]["bayonet"],
		"attach_allow_rifleman_bigammo", game["mwf_attachments"]["rifleman"]["bigammo"],
		"attach_allow_rifleman_flash", game["mwf_attachments"]["rifleman"]["flash"],
		"attach_allow_rifleman_silenced", game["mwf_attachments"]["rifleman"]["silenced"],
		"attach_allow_rifleman_telescopic", game["mwf_attachments"]["rifleman"]["telescopic"]
	);

	self setClientDvars( 
		"attach_allow_lightgunner_none", game["mwf_attachments"]["lightgunner"]["none"],
		"attach_allow_lightgunner_aperture", game["mwf_attachments"]["lightgunner"]["aperture"],
		"attach_allow_lightgunner_bigammo", game["mwf_attachments"]["lightgunner"]["bigammo"],
		"attach_allow_lightgunner_flash", game["mwf_attachments"]["lightgunner"]["flash"],
		"attach_allow_lightgunner_silenced", game["mwf_attachments"]["lightgunner"]["silenced"],
		"attach_allow_lightgunner_telescopic", game["mwf_attachments"]["lightgunner"]["telescopic"],
		
		"attach_allow_heavygunner_none", game["mwf_attachments"]["heavygunner"]["none"],
		"attach_allow_heavygunner_bayonet", game["mwf_attachments"]["heavygunner"]["bayonet"],
		"attach_allow_heavygunner_bipod", game["mwf_attachments"]["heavygunner"]["bipod"],
		"attach_allow_heavygunner_telescopic", game["mwf_attachments"]["heavygunner"]["telescopic"],
		
		"attach_allow_closeassault_none", game["mwf_attachments"]["closeassault"]["none"],
		"attach_allow_closeassault_bayonet", game["mwf_attachments"]["closeassault"]["bayonet"],
		"attach_allow_closeassault_grip", game["mwf_attachments"]["closeassault"]["grip"],
		"attach_allow_closeassault_sawoff", game["mwf_attachments"]["closeassault"]["sawoff"]
	);
}

updateAvailableClasses()
{
	// Get the player's current class
	if ( !isDefined( self.pers["class"] ) ) {
		playerClass = "";
	} else {
		playerClass = self.pers["class"];
	}

	// Item limitations
	playerTeam = self.pers["team"];
	if ( isDefined( playerTeam ) && playerTeam != "spectator" && playerClass != "" ) {
		perkBetty = isUnderLimit( game["mwf_perks"]["mine_bouncing_betty_mp"][playerClass], game["perk_specialty_weapon_bouncing_betty_limit"], game["perk_counts"][playerTeam+"_betty"] );
		perkFlamethrower = isUnderLimit( game["mwf_perks"]["m2_flamethrower_mp"][playerClass], game["perk_specialty_weapon_flamethrower_limit"], game["perk_counts"][playerTeam+"_flamethrower"] );
		perkBazooka = isUnderLimit( game["mwf_perks"]["bazooka_mp"][playerClass], game["perk_specialty_weapon_bazooka_limit"], game["perk_counts"][playerTeam+"_bazooka"] );
		perkSatchel = isUnderLimit( game["mwf_perks"]["satchel_charge_mp"][playerClass], game["perk_specialty_weapon_satchel_charge_limit"], game["perk_counts"][playerTeam+"_satchel"] );
	} else {
		perkBetty = 0;
		perkFlamethrower = 0;
		perkBazooka = 0;
		perkSatchel = 0;
	}

	// Item limitations
	if ( isDefined( playerTeam ) && playerTeam != "spectator" ) {
		grenadierGL = isUnderLimit( game["mwf_attachments"]["grenadier"]["gl"], game["attach_gl_limit"], game["class_counts"][playerTeam + "_gl"] );
		riflemanGL = isUnderLimit( game["mwf_attachments"]["rifleman"]["gl"], game["attach_gl_limit"], game["class_counts"][playerTeam + "_gl"] );
		smokeGrenade = isUnderLimit( isWeaponAllowed( "all", "m8_white_smoke", "all", "all" ), game["m8_white_smoke_limit"], game["misc"][playerTeam +"_smoke"] );
	} else {
		grenadierGl = 0;
		riflemanGL = 0;
		smokeGrenade = 0;
	}
	
	self setClientDvars(
		"perk_allow_mine_bouncing_betty_mp", ( perkBetty ),
		"perk_allow_m2_flamethrower_mp", ( perkFlamethrower ),
		"perk_allow_bazooka_mp", ( perkBazooka ),
		"perk_allow_satchel_charge_mp", ( perkSatchel ),

		"allies_allow_grenadier", ( game["allies_grenadier_limit"] > game["class_counts"]["allies_grenadier"] || playerClass == "grenadier" ),
		"allies_allow_rifleman", ( game["allies_rifleman_limit"] > game["class_counts"]["allies_rifleman"] || playerClass == "rifleman" ),
		"allies_allow_lightgunner", ( game["allies_lightgunner_limit"] > game["class_counts"]["allies_lightgunner"] || playerClass == "lightgunner" ),
		"allies_allow_heavygunner", ( game["allies_heavygunner_limit"] > game["class_counts"]["allies_heavygunner"] || playerClass == "heavygunner" ),
		"allies_allow_closeassault", ( game["allies_closeassault_limit"] > game["class_counts"]["allies_closeassault"] || playerClass == "closeassault" ),
		"allies_allow_sniper", ( game["allies_sniper_limit"] > game["class_counts"]["allies_sniper"] || playerClass == "sniper" ),

		
		"axis_allow_grenadier", ( game["axis_grenadier_limit"] > game["class_counts"]["axis_grenadier"] || playerClass == "grenadier" ),
		"axis_allow_rifleman", ( game["axis_rifleman_limit"] > game["class_counts"]["axis_rifleman"] || playerClass == "rifleman" ),
		"axis_allow_lightgunner", ( game["axis_lightgunner_limit"] > game["class_counts"]["axis_lightgunner"] || playerClass == "lightgunner" ),
		"axis_allow_heavygunner", ( game["axis_heavygunner_limit"] > game["class_counts"]["axis_heavygunner"] || playerClass == "heavygunner" ),
		"axis_allow_closeassault", ( game["axis_closeassault_limit"] > game["class_counts"]["axis_closeassault"] || playerClass == "closeassault" ),
		"axis_allow_sniper", ( game["axis_sniper_limit"] > game["class_counts"]["axis_sniper"] || playerClass == "sniper" ),
						 
		"attach_allow_grenadier_gl", ( grenadierGL ),
		"attach_allow_rifleman_gl", ( riflemanGL ),
		"weap_allow_m8_white_smoke", ( smokeGrenade )
	);
}

isUnderLimit( itemEnabled, itemLimit, itemCount )
{
	if ( itemEnabled == 1 ) {
		if ( itemLimit > itemCount ) {
			itemAllowed = 1;
		} else {
			itemAllowed = 0;
		}
	} else {
		itemAllowed = 0;
	}		
	
	return itemAllowed;
}

setLoadoutForClass( classType )
{
	// Check if this player changed teams
	if ( !isDefined( self.pers["oldteam"] ) || self.pers["team"] != self.pers["oldteam"] ) {
		changedTeam = true;
		self.pers["oldteam"] = self.pers["team"];
	} else {
		changedTeam = false;		
	}
	
	if ( !isDefined( self.pers[classType] ) || changedTeam )
	{
		self.pers[classType]["loadout_primary"] = self getDefaultLoadoutWeapon( classType, game["mwf_classes"][classType]["primary"] );
		self.pers[classType]["loadout_subclass"] = getWeaponSubClass( classType, self.pers[classType]["loadout_primary"] );
		self.pers[classType]["loadout_primary_attachment"] = game["mwf_classes"][classType]["primary_attachment"];
		
		// Hack for snipers
		if ( classType == "sniper" ) {
			if ( self.pers["sniper"]["loadout_primary"] == "ptrs41" ) {
				self.pers[classType]["loadout_primary_attachment"] = "none";
			} else {
				self.pers[classType]["loadout_primary_attachment"] = "scoped";
			}	
		}		
		
		self.pers[classType]["loadout_secondary"] = self getDefaultLoadoutWeapon( "all", game["mwf_classes"][classType]["secondary"] );
		self.pers[classType]["loadout_perk1"] = game["mwf_classes"][classType]["perk1"];
		self.pers[classType]["loadout_perk2"] = game["mwf_classes"][classType]["perk2"];
		self.pers[classType]["loadout_perk3"] = game["mwf_classes"][classType]["perk3"];
		self.pers[classType]["loadout_perk4"] = game["mwf_classes"][classType]["perk4"];
		self.pers[classType]["loadout_pgrenade"] = game["mwf_classes"][classType]["pgrenade"];
		self.pers[classType]["loadout_pgrenade_count"] = game["mwf_classes"][classType]["pgrenade_count"];
		self.pers[classType]["loadout_sgrenade"] = game["mwf_classes"][classType]["sgrenade"];
		self.pers[classType]["loadout_sgrenade_count"] = game["mwf_classes"][classType]["sgrenade_count"];
	}

	self setClientDvars(
		"loadout_class", classType,
		"loadout_subclass", self.pers[classType]["loadout_subclass"],
		"loadout_primary", self.pers[classType]["loadout_primary"],
		"loadout_primary_attachment", self.pers[classType]["loadout_primary_attachment"],
		"loadout_secondary", self.pers[classType]["loadout_secondary"],
		"loadout_perk1", self.pers[classType]["loadout_perk1"],
		"loadout_perk2", self.pers[classType]["loadout_perk2"],
		"loadout_perk3", self.pers[classType]["loadout_perk3"],
		"loadout_perk4", self.pers[classType]["loadout_perk4"],
		"loadout_pgrenade", self.pers[classType]["loadout_pgrenade"],
		"loadout_sgrenade",	self.pers[classType]["loadout_sgrenade"],
		"loadout_pgrenade_count", self.pers[classType]["loadout_pgrenade_count"],
		"loadout_sgrenade_count", self.pers[classType]["loadout_sgrenade_count"]
	);
	
	self setClientDvars(
		"lock_primary", game["mwf_classes"][classType]["lock_primary"],
		"lock_primary_attachment", game["mwf_classes"][classType]["lock_primary_attachment"],
		"lock_secondary", game["mwf_classes"][classType]["lock_secondary"],
		"lock_perk1", game["mwf_classes"][classType]["lock_perk1"],
		"lock_perk2", game["mwf_classes"][classType]["lock_perk2"],
		"lock_perk3", game["mwf_classes"][classType]["lock_perk3"],
		"lock_perk4", game["mwf_classes"][classType]["lock_perk4"],
		"lock_pgrenade", game["mwf_classes"][classType]["lock_pgrenade"],
		"lock_sgrenade", game["mwf_classes"][classType]["lock_sgrenade"]
	);
}

getDefaultLoadoutWeapon( weaponClass, defaultWeapons )
{
	// Get player's team and country
	playerTeam = self.pers["team"];
	if ( playerTeam == "allies" ) {
		playerCountry = game["allies"];
	} else {
		playerCountry = game["axis"];
	}

	// Spam the weapon names
	// [0] = No restriction, [1] = Allies default weapon, [2] = Axis default weapon
	// [3] = Americans default weapon, [4] = Russians default weapon,
	// [5] = Germans default weapon, [6] = Japanese default weapon
	defaultWeapons = strtok( defaultWeapons, ";" );
	defaultWeapon = defaultWeapons[0];
	arrayPosition = 0;
	
	iWeapon = game["mwf_weapons_aux"][weaponClass][defaultWeapon];
	
	if ( isDefined( iWeapon ) ) {
		if ( game["mwf_weapons"][weaponClass][iWeapon]["allow"] == 2 ) {
			if ( playerTeam == "allies" ) {
				arrayPosition = 1;
			} else {
				arrayPosition = 2;					
			}				
		} else if ( game["mwf_weapons"][weaponClass][iWeapon]["allow"] == 3 ) {
			switch ( playerCountry ) {
				case "marines":
					arrayPosition = 3;
					break;
				case "russian":
					arrayPosition = 4;
					break;
				case "german":
					arrayPosition = 5;
					break;
				case "japanese":
					arrayPosition = 6;
					break;
			}				
		}
		
		// Check if the element has been defined
		if ( isDefined( defaultWeapons[arrayPosition] ) ) {
			defaultWeapon = defaultWeapons[arrayPosition];
		}
	}
	
	return defaultWeapon;	
}


verifyClassChoice( teamName, classType )
{
	if( isDefined( self.class ) && self.class == classType && game[teamName+"_"+classType+"_limit"] )
		return true;

	return ( game[teamName+"_"+classType+"_limit"] > game["class_counts"][teamName+"_"+classType] );
}

setClassChoice( classType )
{
	// Check if the player already had a class
	if ( !isDefined( self.pers["class"] ) || self.pers["class"] != classType || self resetPlayerClassOnTeamSwitch( false ) ) {
		self.pers["class"] = classType;
		self.class = classType;
	
		self thread setLoadoutForClass( classType );
	}

	self thread setClassPerks( classType );
	level thread updateClassLimits();
}


setClassPerks( classType )
{
	// Process which perks are allowed under the player's class
	self setClientDvars( 
		"perk_allow_specialty_specialgrenade", game["mwf_perks"]["specialty_specialgrenade"][classType],
		"perk_allow_specialty_fraggrenade", game["mwf_perks"]["specialty_fraggrenade"][classType],
		"perk_allow_specialty_extraammo", game["mwf_perks"]["specialty_extraammo"][classType],
		"perk_allow_specialty_detectexplosive", game["mwf_perks"]["specialty_detectexplosive"][classType],
		"perk_allow_specialty_bulletdamage", game["mwf_perks"]["specialty_bulletdamage"][classType],
		"perk_allow_specialty_armorvest", game["mwf_perks"]["specialty_armorvest"][classType],
		"perk_allow_specialty_fastreload", game["mwf_perks"]["specialty_fastreload"][classType],
		"perk_allow_specialty_rof", game["mwf_perks"]["specialty_rof"][classType],
		"perk_allow_specialty_gpsjammer", game["mwf_perks"]["specialty_gpsjammer"][classType],
		"perk_allow_specialty_explosivedamage", game["mwf_perks"]["specialty_explosivedamage"][classType],
		"perk_allow_specialty_flakjacket", game["mwf_perks"]["specialty_flakjacket"][classType],
		"perk_allow_specialty_shades", game["mwf_perks"]["specialty_shades"][classType],
		"perk_allow_specialty_gas_mask", game["mwf_perks"]["specialty_gas_mask"][classType],
		"perk_allow_specialty_longersprint", game["mwf_perks"]["specialty_longersprint"][classType]
	);
	self setClientDvars( 
		"perk_allow_specialty_bulletaccuracy", game["mwf_perks"]["specialty_bulletaccuracy"][classType],
		"perk_allow_specialty_pistoldeath", game["mwf_perks"]["specialty_pistoldeath"][classType],
		"perk_allow_specialty_grenadepulldeath", game["mwf_perks"]["specialty_grenadepulldeath"][classType],
		"perk_allow_specialty_bulletpenetration", game["mwf_perks"]["specialty_bulletpenetration"][classType],
		"perk_allow_specialty_holdbreath", game["mwf_perks"]["specialty_holdbreath"][classType],
		"perk_allow_specialty_quieter", game["mwf_perks"]["specialty_quieter"][classType],
		"perk_allow_specialty_fireproof", game["mwf_perks"]["specialty_fireproof"][classType],
		"perk_allow_specialty_reconnaissance", game["mwf_perks"]["specialty_reconnaissance"][classType],
		"perk_allow_specialty_pin_back", game["mwf_perks"]["specialty_pin_back"][classType],
		"perk_allow_specialty_water_cooled", game["mwf_perks"]["specialty_water_cooled"][classType],
		"perk_allow_specialty_greased_barrings", game["mwf_perks"]["specialty_greased_barrings"][classType],
		"perk_allow_specialty_ordinance", game["mwf_perks"]["specialty_ordinance"][classType],
		"perk_allow_specialty_boost", game["mwf_perks"]["specialty_boost"][classType],
		"perk_allow_specialty_leadfoot", game["mwf_perks"]["specialty_leadfoot"][classType]
	);		
}

setClassDependent( playerTeam, playerCountry )
{
	// Initialize classes
	classTypes =[];
	classTypes[classTypes.size] = "grenadier";
	classTypes[classTypes.size] = "rifleman";
	classTypes[classTypes.size] = "lightgunner";
	classTypes[classTypes.size] = "heavygunner";
	classTypes[classTypes.size] = "closeassault";
	classTypes[classTypes.size] = "sniper";
	
	for ( iClass = 0; iClass < classTypes.size; iClass++ ) {
		classType = classTypes[iClass];
		
		// Process the weapons for this class
		for ( iWeapon=0; iWeapon < game["mwf_weapons"][classType].size; iWeapon++ ) {
		
			varName = "weap_allow_" + classType + "_" + game["mwf_weapons"][classType][iWeapon]["name"];
			weaponAllowed = isWeaponAllowed( classType, game["mwf_weapons"][classType][iWeapon]["name"], playerTeam, playerCountry );
			
			self setClientDvar( varName, weaponAllowed );		
		}	
	}
}

setClassIndependent( playerTeam, playerCountry )
{
	// Process the weapons that apply for all the classes
	for ( iWeapon=0; iWeapon < game["mwf_weapons"]["all"].size; iWeapon++ ) {
		wait (0.01);
		
		varName = "weap_allow_" + game["mwf_weapons"]["all"][iWeapon]["name"];
		// Make sure we don't do set the smoke grenade here anymore
		if ( varName != "weap_allow_m8_white_smoke" ) {
			weaponAllowed = isWeaponAllowed( "all", game["mwf_weapons"]["all"][iWeapon]["name"], playerTeam, playerCountry );
			self setClientDvar( varName, weaponAllowed );			
		}
	}	
}


// handle script menu responses related to loadout changes
processLoadoutResponse( respString )
{
	commandTokens = strTok( respString, "," );

	// Get player's team and country
	playerTeam = self.pers["team"];
	if ( playerTeam == "allies" ) {
		playerCountry = game["allies"];
	} else {
		playerCountry = game["axis"];
	}

	for ( index = 0; index < commandTokens.size; index++ )
	{
		subTokens = strTok( commandTokens[index], ":" );
		assert( subTokens.size > 1 );

		switch ( subTokens[0] )
		{
			case "loadout_primary":
				if ( isWeaponAllowed( self.class, subTokens[1], playerTeam, playerCountry ) && self verifyWeaponChoice( subTokens[1], self.class ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self.pers[self.class]["loadout_subclass"] = getWeaponSubClass( self.class, subTokens[1] );
					self setClientDvar( subTokens[0], subTokens[1] );
					self setClientDvar( "loadout_subclass", self.pers[self.class]["loadout_subclass"] );
					
					if ( self.class == "sniper" )
					{
						if ( subTokens[1] == "ptrs41" ) {
							self.pers[self.class]["loadout_primary_attachment"] = "none";
							self setClientDvar( "loadout_primary_attachment", "none" );
						} else {
							self.pers[self.class]["loadout_primary_attachment"] = "scoped";
							self setClientDvar( "loadout_primary_attachment", "scoped" );
						}
					} else {
						// Reset the attachment as the previous attachment might not be compatible with the new selection
						self.pers[self.class]["loadout_primary_attachment"] = "none";
						self setClientDvar( "loadout_primary_attachment", "none" );					
					}
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
					self setClientDvar( "loadout_subclass", self.pers[self.class]["loadout_subclass"] );
				}
				break;
				
			case "loadout_secondary":
				if ( isWeaponAllowed( "all", subTokens[1], playerTeam, playerCountry ) && self verifyWeaponChoice( subTokens[1], self.class ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;

			case "loadout_primary_attachment":
				if ( self.class == "sniper" ) {
					if ( self.pers[self.class]["loadout_primary"] == "ptrs41" ) {
						self.pers[self.class]["loadout_primary_attachment"] = "none";
						self setClientDvar( "loadout_primary_attachment", "none" );
					} else {
						self.pers[self.class]["loadout_primary_attachment"] = "scoped";
						self setClientDvar( "loadout_primary_attachment", "scoped" );
					}
					break;
				}	
				
				if ( isAttachmentAllowed( subTokens[1], subTokens[2] ) ) {
					self.pers[self.class][subTokens[0]] = subTokens[2];
					self setClientDvar( subTokens[0], subTokens[2] );
					// grenade launchers and grips take up the perk 1 slot
					if ( subTokens[2] == "gl" || subTokens[2] == "grip" )
					{
						self.pers[self.class]["loadout_perk1"] = "specialty_null";
						self setClientDvar( "loadout_perk1", "specialty_null" );
					}
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				
				level thread updateClassLimits();
				break;

			case "loadout_perk1":
			case "loadout_perk2":
			case "loadout_perk3":
			case "loadout_perk4":
				if ( isPerkAllowed( subTokens[1], self.class ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				
				if ( subTokens[0] == "loadout_perk1" ) {
					level thread updateClassLimits();
				}
				break;

			case "loadout_pgrenade":
			case "loadout_sgrenade":
				if ( isWeaponAllowed( "all", subTokens[1], playerTeam, playerCountry ) )
				{
					self.pers[self.class][subTokens[0]] = subTokens[1];
					self setClientDvar( subTokens[0], subTokens[1] );
					level thread updateClassLimits();
				}
				else
				{
					// invalid selection, so reset them to their class default
					self setClientDvar( subTokens[0], self.pers[self.class][subTokens[0]] );
				}
				break;
		}
	}
}

verifyWeaponChoice( weaponName, classType )
{
	if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_pistol" )
		return true;

	switch ( classType )
	{
		case "grenadier":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_sniper" && weaponName != "ptrs41" )
				return true;
			break;

		case "rifleman":
			if ( ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_assault" && weaponName != "stg44" ) )
				return true;
			break;
		case "lightgunner":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_smg" || ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_assault" && weaponName == "stg44" ) )
				return true;
			break;
		case "heavygunner":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_lmg" || tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_hmg" )
				return true;
			break;
		case "closeassault":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_shotgun" )
				return true;
			break;
		case "sniper":
			if ( tableLookup( "mp/statsTable.csv", 4, weaponName, 2 ) == "weapon_sniper" || weaponName == "m1garand" )
				return true;
			break;
	}

	return false;
}

menuAcceptClass()
{
	self maps\mp\gametypes\_globallogic::closeMenus();

	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	// already playing
	if ( self.sessionstate == "playing" )
	{
		self.pers["primary"] = undefined;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( ( ( level.inGracePeriod || level.inStrategyPeriod ) && !self.hasDoneCombat && ( level.gametype != "ass" || !isDefined( self.isVIP ) || !self.isVIP ) ) || ( level.gametype == "ftag" && self.freezeTag["frozen"] ) )
		{
			self thread deleteExplosives();
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_class_unranked::giveLoadout( self.pers["team"], self.pers["class"] );
		}
		else
		{
			self iPrintLnBold( game["strings"]["change_class"] );

			if ( level.numLives == 1 && !level.inGracePeriod && self.curClass != self.pers["class"] )
			{
				self setClientDvar( "loadout_curclass", "" );
				self.curClass = undefined;
			}
		}
	}
	else
	{
		self.pers["primary"] = undefined;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "postgame" )
			return;

		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread maps\mp\gametypes\_globallogic::updateTeamStatus();
	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}


// The subClass of the weapon determines which attachment menu will be opened
getWeaponSubClass( weaponClass, weaponName )
{
	subClass = "none";
		
	switch ( weaponClass ) {
		case "grenadier":
			subClass = "grenadier1";
			break;
			
		case "rifleman":
			switch ( weaponName ) {
				case "svt40":
					subClass = "rifleman1";
					break;
					
				case "gewehr43":
					subClass = "rifleman2";
					break;
					
				case "m1garand":
					subClass = "rifleman3";
					break;
					
				case "m1carbine":
					subClass = "rifleman4";
					break;
			}
			break;
			
		case "lightgunner":
			switch ( weaponName ) {
				case "thompson":
				case "mp40":
				case "type100smg":
					subClass = "lightgunner1";
					break;
					
				case "ppsh":
					subClass = "lightgunner2";
					break;
					
				case "stg44":
					subClass = "lightgunner3";
					break;										
			}			
			break;
			
		case "heavygunner":
			switch ( weaponName ) {
				case "bar":
				case "dp28":
					subClass = "heavygunner1";
					break;
					
				case "fg42":
					subClass = "heavygunner2";
					break;
					
				case "type99lmg":
					subClass = "heavygunner3";
					break;
					
				case "mg42":
				case "30cal":
					subClass = "heavygunner4";
					break;				
			}			
			break;
			
		case "closeassault":
			switch ( weaponName ) {
				case "shotgun":
					subClass = "closeassault1";
					break;
					
				case "doublebarreledshotgun":
					subClass = "closeassault2";
					break;
			}			
			break;
			
		case "sniper":
			subClass = "none";		
			break;
	}
	
	return subClass;
}
