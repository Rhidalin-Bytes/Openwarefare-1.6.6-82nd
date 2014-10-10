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
#include maps\mp\gametypes\_hud_util;
#include openwarfare\_utils;

init()
{
	// Get the main module's dvar
	level.scr_allowbattlechatter = getdvarx( "scr_allowbattlechatter", "int", 1, 0, 1 );

	if ( game["allies"] == "russian" )
		level.teamPrefix["allies"] = "RU";
	else
	level.teamPrefix["allies"] = "US";

	if ( game["axis"] == "japanese" )
		level.teamPrefix["axis"] = "JA";
	else
	level.teamPrefix["axis"] = "GE";

	level.speakers["allies"] = [];
	level.speakers["axis"] = [];
		
	// Load the rest of the module's variables
	level.scr_battlechatter_reload_probability = getdvarx( "scr_battlechatter_reload_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_frag_out_probability = getdvarx( "scr_battlechatter_frag_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_sticky_out_probability = getdvarx( "scr_battlechatter_sticky_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_flare_out_probability = getdvarx( "scr_battlechatter_flare_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_smoke_out_probability = getdvarx( "scr_battlechatter_smoke_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_molotov_out_probability = getdvarx( "scr_battlechatter_molotov_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_gas_out_probability = getdvarx( "scr_battlechatter_gas_out_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_satchel_planted_probability = getdvarx( "scr_battlechatter_satchel_planted_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_betty_planted_probability = getdvarx( "scr_battlechatter_betty_planted_probability", "int", 75, 0, 100 );
	level.scr_battlechatter_kill_probability = getdvarx( "scr_battlechatter_kill_probability", "int", 75, 0, 100 );

	// If battlechatter is not enabled there's nothing else to do here
	if ( level.scr_allowbattlechatter == 0 )
		return;
	
	level.isTeamSpeaking["allies"] = false;
	level.isTeamSpeaking["axis"] = false;
	
	level.bcSounds["reload"] = "inform_reloading_generic";
	level.bcSounds["frag_out"] = "inform_attack_grenade";
	level.bcSounds["sticky_out"] = "inform_attack_sticky";
	level.bcSounds["molotov_out"] = "inform_attack_molotov";
	level.bcSounds["flare_out"] = "inform_attack_flare";
	level.bcSounds["smoke_out"] = "inform_attack_smoke";	
	level.bcSounds["gas_out"] = "inform_attack_gas";
	level.bcSounds["satchel_plant"] = "inform_attack_satchel";
	level.bcSounds["betty_plant"] = "inform_plant_shoebox";
	level.bcSounds["kill"] = "inform_killfirm_infantry";	
	
	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );
		player thread onPlayerSpawned();
		player thread onJoinedTeam();
	}
}


onJoinedTeam()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "joined_team" );

		if( self.pers["team"] == "axis" )
			self.pers["bcVoiceNumber"] = randomIntRange( 0, 2 );
		else
			self.pers["bcVoiceNumber"] = randomIntRange( 0, 3 );
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );

	for(;;)
	{
		self waittill( "spawned_player" );

		// help players be stealthy in splitscreen by not announcing their intentions
		if ( level.splitscreen )
			continue;

		self thread bettyTracking();
		self thread reloadTracking();
		self thread grenadeTracking();
	}
}


bettyTracking()
{
	self endon ( "death_or_disconnect" );
	
	while(1)
	{
		self waittill( "begin_firing" );
		weaponName = self getCurrentWeapon();
		if ( weaponName == "mine_bouncing_betty_mp" && shouldPlayBattlechatter( level.scr_battlechatter_betty_planted_probability ) )
			level thread sayLocalSound( self, "betty_plant" );
	}
}


reloadTracking()
{
	self endon ( "death_or_disconnect" );

	for( ;; )
	{
		self waittill ( "reload_start" );
		if ( shouldPlayBattlechatter( level.scr_battlechatter_reload_probability ) )
			level thread sayLocalSound( self, "reload" );
	}
}


grenadeTracking()
{
	self endon ( "death_or_disconnect" );

	for( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );

		if ( weaponName == "frag_grenade_mp" && shouldPlayBattlechatter( level.scr_battlechatter_frag_out_probability ) )
			level thread sayLocalSound( self, "frag_out" );
		
		else if ( weaponName == "signal_flare_mp" && shouldPlayBattlechatter( level.scr_battlechatter_flare_out_probability ) ) 
			level thread sayLocalSound( self, "flare_out" );
			
		else if ( weaponName == "m8_white_smoke_mp" && shouldPlayBattlechatter( level.scr_battlechatter_smoke_out_probability ) ) 
			level thread sayLocalSound( self, "smoke_out" );

		else if ( weaponName == "napalmblob_mp" && shouldPlayBattlechatter( level.scr_battlechatter_molotov_out_probability ) ) 
			level thread sayLocalSound( self, "molotov_out" );

		else if ( weaponName == "tabun_gas_mp" && shouldPlayBattlechatter( level.scr_battlechatter_gas_out_probability ) ) 
			level thread sayLocalSound( self, "gas_out" );
			
		else if ( weaponName == "satchel_charge_mp" && shouldPlayBattlechatter( level.scr_battlechatter_satchel_planted_probability ) ) 
			level thread sayLocalSound( self, "satchel_plant" );
			
		else if ( weaponName == "sticky_grenade_mp" && shouldPlayBattlechatter( level.scr_battlechatter_sticky_out_probability ) ) 
			level thread sayLocalSound( self, "sticky_out" );
	}
}


sayLocalSoundDelayed( player, soundType, delay )
{
	player endon ( "death_or_disconnect" );
	
	wait ( delay );
	
	sayLocalSound( player, soundType );
}


sayLocalSound( player, soundType )
{
	player endon ( "death_or_disconnect" );

	if ( level.scr_allowbattlechatter == 0 )
		return;

	if ( isSpeakerInRange( player ) )
		return;
		
	if( player.pers["team"] != "spectator" )
	{
		soundAlias = level.teamPrefix[player.pers["team"]] + "_" + player.pers["bcVoiceNumber"] + "_" + level.bcSounds[soundType];
		player thread doSound( soundAlias );
	}
}


doSound( soundAlias )
{
	team = self.pers["team"];
	level addSpeaker( self, team );
	self thread xPlaySoundToTeam( soundAlias, team );
	self thread timeHack( soundAlias ); // workaround because soundalias notify isn't happening
	self waittill_any( soundAlias, "death", "disconnect" );
	level removeSpeaker( self, team );
}


timeHack( soundAlias )
{
	self endon ( "death_or_disconnect" );

	wait ( 2.0 );
	self notify ( soundAlias );
}


isSpeakerInRange( player )
{
	player endon ( "death_or_disconnect" );

	distSq = 1000 * 1000;

	// to prevent player switch to spectator after throwing a granade causing damage to someone and result in attacker.pers["team"] = "spectator"
	if( isdefined( player ) && isdefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
	{
		for ( index = 0; index < level.speakers[player.pers["team"]].size; index++ )
		{
			teammate = level.speakers[player.pers["team"]][index];
			if ( teammate == player )
				return true;
				
			if ( distancesquared( teammate.origin, player.origin ) < distSq )
				return true;
		}
	}

	return false;
}


addSpeaker( player, team )
{
	level.speakers[team][level.speakers[team].size] = player;
}


// this is lazy... fix up later by tracking ID's and doing array slot swapping
removeSpeaker( player, team )
{
	newSpeakers = [];
	for ( index = 0; index < level.speakers[team].size; index++ )
	{
		if ( level.speakers[team][index] == player )
			continue;
			
		newSpeakers[newSpeakers.size] = level.speakers[team][index]; 
	}
	
	level.speakers[team] = newSpeakers;
}


shouldPlayBattlechatter( bcProbability )
{
	if ( bcProbability == 0 )
		return false;
	else if ( bcProbability == 100 || randomIntRange( 1, 101 ) <= bcProbability )
		return true;
		
	return false;	
}


// Dummy function so we don't need to add couple files calling this function to the project
onPlayerNearExplodable( param1, param2 )
{
	return;
}


xPlaySoundToTeam( soundAlias, team )
{
	// Play the sound to all the players in the same team
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	
		if ( player.pers["team"] == team ) {
			self playSoundToPlayer( soundAlias, player );
		}
	}	
}