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
#include maps\mp\gametypes\_hud_util;

#include openwarfare\_eventmanager;
#include openwarfare\_utils;


init()
{
	// Get the main module's dvar
	level.scr_power_rank_mode = getdvarx( "scr_power_rank_mode", "int", 0, 0, 2 );

	// Check if we need to run this process
	if ( level.scr_power_rank_mode == 0 || !level.rankedMatch )
		return;
		
	level.scr_power_rank_delay = getdvarx( "scr_power_rank_delay", "float", 0.5, 0.5, 2.0 );

	// Let's load the minimum experience here to make everything faster
	level.maxPower = int(tableLookup( "mp/rankTable.csv", 0, "maxpower", 1 ));
	level.powerRankInfoMinXp = [];
	for ( rankId = 1; rankId <= level.maxPower; rankId++ ) {
		level.powerRankInfoMinXp[ rankId ] = maps\mp\gametypes\_rank::getRankInfoMinXp( rankId );
	}

	precacheString( &"OW_POWER_RANK_ATTACHMENTS" );

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}


onPlayerConnected()
{
	self.powerRanked = false;
	self thread onPlayerSpawned();
}


onPlayerSpawned()
{
	self endon("disconnect");

	self waittill("spawned_player");
	self thread givePowerRankXP();
}


givePowerRankXP()
{
	self endon("disconnect");

	// Check if we need to give XP to the player	
	if ( self.pers["rankxp"] < level.powerRankInfoMinXp[ level.maxPower ] ) {
		
		// Assign enough XP to advance 3 ranks at a time
		for ( rankId = 1; rankId <= level.maxPower; rankId++ ) {
			rankXp = level.powerRankInfoMinXp[ rankId ];
			
			if ( rankXp > self.pers["rankxp"] ) {
				rankXp -= self.pers["rankxp"];
				self maps\mp\gametypes\_rank::giveRankXP( "powerrank", rankXp, true );
				self maps\mp\gametypes\_rank::updateRank();
				wait ( level.scr_power_rank_delay );
			}
		}
		
		// Let the player know about the promotion to max level
		self maps\mp\gametypes\_rank::updateRankAnnounceHUD( true );
	}
	
	// Check if we need to unlock the special attachments and camos for the player
	if ( level.scr_power_rank_mode == 2 ) {
		self unlockSpecialAttachments();
	}

	return;
}


unlockSpecialAttachments()
{
	// Initialize a list of attachments that we need to unlock
	attachmentList = [];
	attachmentList[0] = "thompson silenced;thompson aperture;thompson bigammo;mp40 silenced;mp40 aperture;mp40 bigammo";
	attachmentList[1] = "type100smg silenced;type100smg aperture;type100smg bigammo;ppsh aperture;ppsh bigammo;30cal bipod";
	attachmentList[2] = "svt40 flash;svt40 aperture;svt40 telescopic;gewehr43 silenced;gewehr43 aperture;gewehr43 telescopic;gewehr43 gl";
	attachmentList[3] = "m1garand flash;m1garand bayonet;m1garand gl;m1garand scoped;m1carbine flash;m1carbine aperture;m1carbine bayonet;m1carbine bigammo";
	attachmentList[4] = "stg44 flash;stg44 aperture;stg44 telescopic;mg42 bipod;dp28 bipod;bar bipod";
	attachmentList[5] = "springfield scoped;springfield bayonet;springfield gl;mosinrifle scoped;mosinrifle bayonet;mosinrifle gl";
	attachmentList[6] = "type99rifle scoped;type99rifle bayonet;type99rifle gl;kar98k scoped;kar98k bayonet;kar98k gl";
	attachmentList[7] = "shotgun grip;shotgun bayonet;doublebarreledshotgun grip;doublebarreledshotgun sawoff;type99lmg bipod;type99lmg bayonet";
	attachmentList[8] = "fg42 bipod;fg42 telescopic;dp28 bipod";

	// Get the last array of attachments unlocked for this player
	attachix = self getStat( 3150 );
	
	// Check if we need to unlock attachments
	if ( attachix >= attachmentList.size )
		return;
	
	// Cycle the list of attachments and unlock them
	while( attachix < attachmentList.size ) {
		self maps\mp\gametypes\_rank::unlockAttachment( attachmentList[ attachix ] );
		self setStat( 3150, attachix );
		attachix++;
		wait ( level.scr_power_rank_delay );
	}	
	self setStat( 3150, attachmentList.size );
	self iprintlnbold( &"OW_POWER_RANK_ATTACHMENTS" );
	
	return;
}


