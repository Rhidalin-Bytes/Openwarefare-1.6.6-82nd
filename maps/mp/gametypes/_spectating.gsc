//******************************************************************************
//  _____                  _    _             __
// |  _  |                | |  | |           / _|
// | | | |_ __   ___ _ __ | |  | | __ _ _ __| |_ __ _ _ __ ___
// | | | | '_ \ / _ \ '_ \| |/\| |/ _` | '__|  _/ _` | '__/ _ \
// \ \_/ / |_) |  __/ | | \  /\  / (_| | |  | || (_| | | |  __/
//  \___/| .__/ \___|_| |_|\/  \/ \__,_|_|  |_| \__,_|_|  \___|
//       | |               We don't make the game you play.
//       |_|                 We make the game you play BETTER.
// Website  : http://openwarfaremod.com/
// 82ndAB Changes:	function added: loadclantags() - loads clan tags
//					function changes: setSpectatePermissions() - allows clan members to freespec
//******************************************************************************

#include openwarfare\_utils;

init()
{
	// Load the module's dvars
	spectateType = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "spectatetype" );
	// Pel - Added 1 to the max to make it 3
	level.scr_game_spectatetype = getdvarx( "scr_game_spectatetype", "int", 0, 0, 4 );
	if ( spectatetype == 4 )
	{
		thread loadclantags();
	}

	level.scr_game_spectatetype_spectators = getdvarx( "scr_game_spectatetype_spectators", "int", 0, 0, 2 );
	level.scr_game_spectators_guids = getdvarx( "scr_game_spectators_guids", "string", "" );

	level.spectateOverride["allies"] = spawnstruct();
	level.spectateOverride["axis"] = spawnstruct();

	level thread onPlayerConnect();
}


loadclantags()
{
	clantagsforspec = getdvarx( "scr_game_spectate_clantags", "string", "" );
	level.clantagsforspec = strtok ( clantagsforspec, ";" );
}


onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);
		
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
		player thread onPlayerSpawned();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");
		self setSpectatePermissions();
	}
}

//Pel - Need this for strategy mode
onPlayerKilled_Strategy()
{
	self endon("disconnect");
	for(;;)
	{
		self waittill("killed_player");
		self setSpectatePermissions();
	}
}

onJoinedTeam()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_team");
		self setSpectatePermissions();
	}
}

onJoinedSpectators()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("joined_spectators");
		self setSpectatePermissions();
	}
}


updateSpectateSettings()
{
	level endon ( "game_ended" );
	
	for ( index = 0; index < level.players.size; index++ )
		level.players[index] setSpectatePermissions();
}


getOtherTeam( team )
{
	if ( team == "axis" )
		return "allies";
	else if ( team == "allies" )
		return "axis";
	else
		return "none";
}



setSpectatePermissions()
{
	team = self.sessionteam;

	spectateType = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "spectatetype" );
	if ( self.pers["team"] == "spectator" && spectateType !=4 ) {
		// If we have GUIDs setup then we'll check for matches
		if ( level.scr_game_spectators_guids != "" ) {
			if ( issubstr( level.scr_game_spectators_guids, self getGuid() ) ) {
				spectateType = level.scr_game_spectatetype_spectators;
			} else {
				spectateType = level.scr_game_spectatetype;
			}				
		} else {
      if ( level.scr_game_spectatetype == 3 ) 
        spectateType = level.scr_game_spectatetype;
      else
        spectateType = level.scr_game_spectatetype_spectators; 
		}
	} else
		spectateType = level.scr_game_spectatetype;
	
	switch( spectateType )
	{
		case 0: // disabled
			self allowSpectateTeam( "allies", false );
			self allowSpectateTeam( "axis", false );
			self allowSpectateTeam( "freelook", false );
			self allowSpectateTeam( "none", false );
			break;
		case 1: // team only
			if ( !level.teamBased )
			{
				self allowSpectateTeam( "allies", true );
				self allowSpectateTeam( "axis", true );
				self allowSpectateTeam( "none", true );
				self allowSpectateTeam( "freelook", false );
			}
			else if ( isDefined( team ) && (team == "allies" || team == "axis") )
			{
				self allowSpectateTeam( team, true );
				self allowSpectateTeam( getOtherTeam( team ), false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			else
			{
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			break;
		case 2: // free
			self allowSpectateTeam( "allies", true );
			self allowSpectateTeam( "axis", true );
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );
			break;
		case 3: // strategy
			for ( index = 0; index < level.players.size; index++ ) 
			{
				player = level.players[index];

				if ( self.pers["team"] == "spectator" )
				{
					if ( level.scr_game_spectate_strategy != 2 )
					{ 
						player hide( );
				  }
					else 
					{
						if ( player.pers["team"] == "allies" || player.pers["team"] == "axis" )
              player show( );
					}
			
				}
				else if ( !isAlive( self ) )
				{
					if ( level.scr_game_spectate_strategy == 0 ) 
						player hide( );
					else if ( level.scr_game_spectate_strategy == 1 )
					{
						if ( player.pers["team"] != team )
							player hide( );
					}
					else 
					{
						if ( player.pers["team"] == team )
							player hide( );
					}
			
				}
				else
					player show( );
			}
			if ( level.scr_game_spectate_strategy == 2 )
			{
				if ( isDefined( team ) && team == "allies" )
				{
					self allowSpectateTeam( "allies", false );
					self allowSpectateTeam( "axis", true );
				}
				else if (isDefined( team ) && team == "axis" )
				{
					self allowSpectateTeam( "allies", true );
					self allowSpectateTeam( "axis", false );
				}
				else //Spectator
				{
          self allowSpectateTeam( "allies", true );
					self allowSpectateTeam( "axis", true );
				}
			}
			else 
			{
				if ( isDefined( team ) && team == "allies" )
				{
					self allowSpectateTeam( "allies", true );
					self allowSpectateTeam( "axis", false );
				}
				else if ( isDefined( team ) && team == "axis" )
				{
					self allowSpectateTeam( "allies", false );
					self allowSpectateTeam( "axis", true );
				}
				else //Spectator
				{
          self allowSpectateTeam( "allies", false );
					self allowSpectateTeam( "axis", false );
				}
			}
			self allowSpectateTeam( "freelook", true );
			self allowSpectateTeam( "none", true );

			if( !isAlive( self ) || self.pers["team"] == "spectator" )
				self thread onPlayerSpawned();
			else
				self thread onPlayerKilled_Strategy();
			break;
	case 4:  //Clan Spectate
			clantag = 0;

			for (tagix = 0; tagix < level.clantagsforspec.size; tagix++ )
			{
				if ( isSubStr ( self.name, level.clantagsforspec[tagix] ) )
				{
					clantag = 1;
				}
			}
			if (clantag == 1 ) 
			{
				self allowSpectateTeam( "allies", true );
				self allowSpectateTeam( "axis", true );
				self allowSpectateTeam( "freelook", true );
				self allowSpectateTeam( "none", true );
			}
			else if ( !level.teamBased )

			{
				self allowSpectateTeam( "allies", true );
				self allowSpectateTeam( "axis", true );
				self allowSpectateTeam( "none", true );
				self allowSpectateTeam( "freelook", false );
			}
			else if ( isDefined( team ) && (team == "allies" || team == "axis") )

			{
				self allowSpectateTeam( team, true );
				self allowSpectateTeam( getOtherTeam( team ), false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}

			else
			{
				self allowSpectateTeam( "allies", false );
				self allowSpectateTeam( "axis", false );
				self allowSpectateTeam( "freelook", false );
				self allowSpectateTeam( "none", false );
			}
			break;
	}
	
	if ( isDefined( team ) && (team == "axis" || team == "allies") )
	{
		if ( isdefined(level.spectateOverride[team].allowFreeSpectate) )
			self allowSpectateTeam( "freelook", true );
		
		if (isdefined(level.spectateOverride[team].allowEnemySpectate))
			self allowSpectateTeam( getOtherTeam( team ), true );
	}
}
