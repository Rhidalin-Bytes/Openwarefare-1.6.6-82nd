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
	level.scr_realtime_stats_enable = getdvarx( "scr_realtime_stats_enable", "int", 0, 0, 1 );
	level.scr_endofgame_stats_enable = getdvarx( "scr_endofgame_stats_enable", "int", 0, 0, 1 );

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );

	// If real time stats are not enabled then there's nothing else to do here
	if ( level.scr_realtime_stats_enable == 0 && level.scr_endofgame_stats_enable == 0 )
		return;

	level.scr_realtime_stats_default_on = getdvarx( "scr_realtime_stats_default_on", "int", 1, 0, 1 );
	
	level.scr_realtime_stats_unit = getdvarx( "scr_realtime_stats_unit", "string", "meters" );
	if ( level.scr_realtime_stats_unit != "meters" && level.scr_realtime_stats_unit != "yards" ) {
		level.scr_realtime_stats_unit = "meters";
	}
	
	// Check if we should show the end of game statistics
	if ( level.scr_endofgame_stats_enable == 1 ) {
		game["menu_eog_stats"] = "eog_statistics";
		precacheMenu( game["menu_eog_stats"] );
		level thread onGameEnded();
	}
}


onGameEnded()
{
	level waittill("game_ended");	

	// Wait some time to let all the events be processed
	wait (1.0);

	// Initialize array for best/worst values
	level.eogBest = [];
	level.eogBest["accuracy"]["name"] = "";
	level.eogBest["accuracy"]["value"] = 0;

	level.eogBest["kills"]["name"] = "";
	level.eogBest["kills"]["value"] = 0;
	
	level.eogBest["teamkills"]["name"] = "";
	level.eogBest["teamkills"]["value"] = 0;	
	
	level.eogBest["killstreak"]["name"] = "";
	level.eogBest["killstreak"]["value"] = 0;	
	
	level.eogBest["longest"]["name"] = "";
	level.eogBest["longest"]["value"] = 0;	

	level.eogBest["melee"]["name"] = "";
	level.eogBest["melee"]["value"] = 0;

	level.eogBest["headshots"]["name"] = "";
	level.eogBest["headshots"]["value"] = 0;

	level.eogBest["longesths"]["name"] = "";
	level.eogBest["longesths"]["value"] = 0;

	level.eogBest["deaths"]["name"] = "";
	level.eogBest["deaths"]["value"] = 0;

	level.eogBest["suicides"]["name"] = "";
	level.eogBest["suicides"]["value"] = 0;

	level.eogBest["deathstreak"]["name"] = "";
	level.eogBest["deathstreak"]["value"] = 0;	

	level.eogBest["radar"]["name"] = "";
	level.eogBest["radar"]["value"] = 0;

	level.eogBest["artillery"]["name"] = "";
	level.eogBest["artillery"]["value"] = 0;

	level.eogBest["artillery_kills"]["name"] = "";
	level.eogBest["artillery_kills"]["value"] = 0;

	level.eogBest["dogs"]["name"] = "";
	level.eogBest["dogs"]["value"] = 0;
	
	level.eogBest["dog_kills"]["name"] = "";
	level.eogBest["dog_kills"]["value"] = 0;

	level.eogBest["distance"]["name"] = "";
	level.eogBest["distance"]["value"] = 0;	
				
	// Get all the best/worst players for each stat item we monitor and display at the end of the game
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	
		
		if ( isDefined( player ) && isDefined( player.pers["stats"] ) ) {	
			if ( player.pers["stats"]["accuracy"]["total_shots"] != 0 ) {
				player checkStatItem( int( player.pers["stats"]["accuracy"]["hits"] / player.pers["stats"]["accuracy"]["total_shots"] * 100 ), "accuracy" );
			} else {
				player checkStatItem( 0, "accuracy" );
			}
			
			player checkStatItem( player.pers["stats"]["kills"]["total"], "kills" );
			player checkStatItem( player.pers["stats"]["kills"]["teamkills"], "teamkills" );
			player checkStatItem( player.pers["stats"]["kills"]["killstreak"], "killstreak" );
			player checkStatItem( player.pers["stats"]["kills"]["longest"], "longest" );
			player checkStatItem( player.pers["stats"]["kills"]["knife"], "melee" );
			player checkStatItem( player.pers["stats"]["kills"]["headshots"], "headshots" );
			player checkStatItem( player.pers["stats"]["kills"]["longesths"], "longesths" );
			
			player checkStatItem( player.pers["stats"]["deaths"]["total"], "deaths" );
			player checkStatItem( player.pers["stats"]["deaths"]["suicides"], "suicides" );
			player checkStatItem( player.pers["stats"]["deaths"]["deathstreak"], "deathstreak" );
			
			player checkStatItem( player.pers["stats"]["hardpoints"]["radar"], "radar" );
			player checkStatItem( player.pers["stats"]["hardpoints"]["artillery"], "artillery" );
			player checkStatItem( player.pers["stats"]["hardpoints"]["artillery_kills"], "artillery_kills" );
			player checkStatItem( player.pers["stats"]["hardpoints"]["dogs"], "dogs" );
			player checkStatItem( player.pers["stats"]["hardpoints"]["dog_kills"], "dog_kills" );

			player checkStatItem( player.pers["stats"]["misc"]["distance"], "distance" );
		}
	}

	if ( level.scr_realtime_stats_unit == "meters" ) {
		level.eogBest["distance"]["value"] = int( level.eogBest["distance"]["value"] * 0.0254 * 10 ) / 10;
		longestUnit = " m";
	} else {
		level.eogBest["distance"]["value"] = int( level.eogBest["distance"]["value"] * 0.0278 * 10 ) / 10;
		longestUnit = " yd";
	}
	
	// Send the data to each player
	for ( index = 0; index < level.players.size; index++ )
	{
		player = level.players[index];	
		
		if ( isDefined( player ) ) {
			player setClientDvars(
				"ps_n", player.name,
				"gs_pg", 1,
				"gs_an", level.eogBest["accuracy"]["name"],
				"gs_a", level.eogBest["accuracy"]["value"],
				"gs_kn", level.eogBest["kills"]["name"],
				"gs_k", level.eogBest["kills"]["value"],
				"gs_tn", level.eogBest["teamkills"]["name"],
				"gs_t", level.eogBest["teamkills"]["value"],
				"gs_ksn", level.eogBest["killstreak"]["name"],
				"gs_ks", level.eogBest["killstreak"]["value"],
				"gs_ln", level.eogBest["longest"]["name"],
				"gs_l", level.eogBest["longest"]["value"] + longestUnit,
				"gs_mn", level.eogBest["melee"]["name"],
				"gs_m", level.eogBest["melee"]["value"],
				"gs_hn", level.eogBest["headshots"]["name"],
				"gs_h", level.eogBest["headshots"]["value"],
				"gs_lhn", level.eogBest["longesths"]["name"]				
			);
			player setClientDvars(
				"gs_lh", level.eogBest["longesths"]["value"] + longestUnit,
				"gs_dn", level.eogBest["deaths"]["name"],
				"gs_d", level.eogBest["deaths"]["value"],
				"gs_sn", level.eogBest["suicides"]["name"],
				"gs_s", level.eogBest["suicides"]["value"],
				"gs_dsn", level.eogBest["deathstreak"]["name"],
				"gs_ds", level.eogBest["deathstreak"]["value"],
				"gs_h1n", level.eogBest["radar"]["name"],
				"gs_h1", level.eogBest["radar"]["value"],
				"gs_h2n", level.eogBest["artillery"]["name"],
				"gs_h2", level.eogBest["artillery"]["value"],
				"gs_h2kn", level.eogBest["artillery_kills"]["name"],
				"gs_h2k", level.eogBest["artillery_kills"]["value"],
				"gs_h3n", level.eogBest["dogs"]["name"],
				"gs_h3", level.eogBest["dogs"]["value"],
				"gs_h3kn", level.eogBest["dog_kills"]["name"],
				"gs_h3k", level.eogBest["dog_kills"]["value"]
			);
			player setClientDvars(
				"gs_dtn", level.eogBest["distance"]["name"],
				"gs_dt", level.eogBest["distance"]["value"] + longestUnit
			);	
		}
	}	
}


checkStatItem( value, statItem )
{
	// Check if this stat item is blank or if the value is higher than the current one
	if ( level.eogBest[statItem]["name"] == "" || value > level.eogBest[statItem]["value"] ) {
		level.eogBest[statItem]["name"] = self.name;
		level.eogBest[statItem]["value"] = value;		
	}	
}


onPlayerConnected()
{
	// Check if real time stats are disabled
	if ( level.scr_realtime_stats_enable == 0 ) {
		self setClientDvar( "ui_hud_showstats", 0 );
		// If End Of Game statistics are also disabled will just leave at this point
		if ( level.scr_endofgame_stats_enable == 0 ) {
			return;		
		}
	}
	
	self thread onPlayerKilled();
	self thread onRefreshAccuracy();
	self thread onHardpointCalled();
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	
	// Make sure the initialization happens only at the beginning of the map
	if ( !isDefined( self.pers["stats"] ) ) {
	
		if ( level.scr_realtime_stats_unit == "meters" ) {
			longestDefault = "0 m";
		} else {
			longestDefault = "0 yd";
		}
			
		// Initialize the values
		self setClientDvars(
			"ui_hud_showstats", ( level.scr_realtime_stats_default_on && level.scr_realtime_stats_enable ),
			"ps_a", "",												// Accuracy
			"ps_r", 0,												// Kill/Deaths ratio
			"ps_k", 0,												// Kills
			"ps_t", 0,												// Teamkills
			"ps_cks", 0, 											// Current Killstreak
			"ps_ks", 0, 											// Highest Killstreak
			"ps_l", longestDefault,						// Longest Kill
			"ps_mk", 0,												// Melee Kills
			"ps_dt", longestDefault						// Distance Travelled
		);
		self setClientDvars(
			"ps_h", 0,												// Headshots
			"ps_lh", longestDefault,					// Longest Headshot
			"ps_d", 0, 												// Deaths
			"ps_s", 0,												// Suicides
			"ps_cds", 0,											// Current Deathstreak
			"ps_ds", 0,												// Highest Deathstreak
			"ps_h1", 0,												// Radar
			"ps_h2", 0,												// Artillery
			"ps_h2k", 0,											// Artillery Kills
			"ps_h3", 0,												// Dogs
			"ps_h3k", 0												// Dog Kills
		);
		
		// Initialize variables to keep stats
		self.pers["stats"] = [];
		self.pers["stats"]["show"] = level.scr_realtime_stats_default_on;
		
		// Accuracy
		self.pers["stats"]["accuracy"] = [];
		self.pers["stats"]["accuracy"]["total_shots"] = 0;
		self.pers["stats"]["accuracy"]["hits"] = 0;
		
		// Kills
		self.pers["stats"]["kills"] = [];
		self.pers["stats"]["kills"]["total"] = 0;
		self.pers["stats"]["kills"]["teamkills"] = 0;
		self.pers["stats"]["kills"]["consecutive"] = 0;
		self.pers["stats"]["kills"]["killstreak"] = 0;
		self.pers["stats"]["kills"]["longest"] = 0;
		self.pers["stats"]["kills"]["knife"] = 0;
		self.pers["stats"]["kills"]["headshots"] = 0;
		self.pers["stats"]["kills"]["longesths"] = 0;
		
		// Deaths
		self.pers["stats"]["deaths"] = [];
		self.pers["stats"]["deaths"]["total"] = 0;
		self.pers["stats"]["deaths"]["suicides"] = 0;
		self.pers["stats"]["deaths"]["consecutive"] = 0;
		self.pers["stats"]["deaths"]["deathstreak"] = 0;
		
		// Hardpoints
		self.pers["stats"]["hardpoints"] = [];
		self.pers["stats"]["hardpoints"]["radar"] = 0;
		self.pers["stats"]["hardpoints"]["artillery"] = 0;
		self.pers["stats"]["hardpoints"]["artillery_kills"] = 0;
		self.pers["stats"]["hardpoints"]["dogs"] = 0;
		self.pers["stats"]["hardpoints"]["dog_kills"] = 0;

		// Misc
		self.pers["stats"]["misc"] = [];
		self.pers["stats"]["misc"]["distance"] = 0;	
	}	
}


onPlayerSpawned()
{
	self endon("disconnect");

	if ( level.scr_realtime_stats_unit == "meters" ) {
		mUnit = " m";
	} else {
		mUnit = " yd";
	}
	
	oldPosition = self.origin;
	oldValue = self.pers["stats"]["misc"]["distance"];
	updateLoop = 0;
	
	// Monitor this player until he/she dies or the round ends
	while ( isAlive( self ) && game["state"] != "postgame" ) {
		wait (0.1);
		
		// Make sure the player is not jumping
		if ( self isOnGround() || self isOnLadder() ) {
			// Calculate the distance between the last knows position and the current one
			travelledDistance = distance( oldPosition, self.origin );
			
			// If we have a positive travelled distance add it up 
			if ( travelledDistance > 0 ) {
				oldPosition = self.origin;
				self.pers["stats"]["misc"]["distance"] += travelledDistance;
			}			
		}
		
		// We update every second
		updateLoop++;
		if ( updateLoop == 10 ) {
			updateLoop = 0;
			if ( oldValue != self.pers["stats"]["misc"]["distance"] ) {
				oldValue = self.pers["stats"]["misc"]["distance"];
				if ( level.scr_realtime_stats_unit == "meters" ) {
					travelledDistance = int( oldValue * 0.0254 * 10 ) / 10;
				} else {
					travelledDistance = int( oldValue * 0.0278 * 10 ) / 10;
				}
				self setClientDvar( "ps_dt", travelledDistance + mUnit );
			}
		}		
	}
	
	// Update one more time once the player dies
	if ( oldValue != self.pers["stats"]["misc"]["distance"] ) {
		oldValue = self.pers["stats"]["misc"]["distance"];
		if ( level.scr_realtime_stats_unit == "meters" ) {
			travelledDistance = int( oldValue * 0.0254 * 10 ) / 10;
		} else {
			travelledDistance = int( oldValue * 0.0278 * 10 ) / 10;
		}
		self setClientDvar( "ps_dt", travelledDistance + mUnit );
	}	
}


onRefreshAccuracy()
{
	self endon("disconnect");
	
	for (;;) {
		self waittill( "refresh_accuracy", shotsFired, hits );

		self.pers["stats"]["accuracy"]["total_shots"] += shotsFired;
		self.pers["stats"]["accuracy"]["hits"] += hits;
		
		// Calculate new accuracy
		newAccuracy = int( self.pers["stats"]["accuracy"]["hits"] / self.pers["stats"]["accuracy"]["total_shots"] * 100 );
		newAccuracy = newAccuracy;
		self setClientDvar( "ps_a", newAccuracy );
	}	
}


onPlayerKilled()
{
	self endon("disconnect");
	
	for (;;) {
		self waittill( "player_killed", eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, fDistance );

		// Make sure the player is not switching teams or being team balanced (our suicides count only when the player kills himself)
		if ( sMeansOfDeath == "MOD_SUICIDE" )
			continue;
			
		// Check if it was a suicide
		if ( sMeansOfDeath == "MOD_FALLING" || ( isPlayer( attacker ) && attacker == self ) ) {
			self.pers["stats"]["deaths"]["suicides"] += 1;
		}

		// Handle the stats for the victim 
		self.pers["stats"]["kills"]["consecutive"] = 0;
		self.pers["stats"]["deaths"]["total"] += 1;
		self.pers["stats"]["deaths"]["consecutive"] += 1;
		if ( self.pers["stats"]["deaths"]["consecutive"] > self.pers["stats"]["deaths"]["deathstreak"] )
			self.pers["stats"]["deaths"]["deathstreak"] = self.pers["stats"]["deaths"]["consecutive"];
		
		// Update stats for the victim
		kdRatio = int( self.pers["stats"]["kills"]["total"] / self.pers["stats"]["deaths"]["total"] * 100 ) / 100;
		self setClientDvars(
			"ps_r", kdRatio,
			"ps_cks", 0,
			"ps_d", self.pers["stats"]["deaths"]["total"], 
			"ps_s", self.pers["stats"]["deaths"]["suicides"], 
			"ps_cds", self.pers["stats"]["deaths"]["consecutive"],
			"ps_ds", self.pers["stats"]["deaths"]["deathstreak"]
		);

		// Handle the stats for the attacker
		if ( isPlayer( attacker ) && attacker != self ) {
			// Check if it was a team kill (team kills don't count towards K/D ratio or total kills, headshots, distances, etc)
			if ( level.teambased && isPlayer( attacker ) && attacker.pers["team"] == self.pers["team"] ) {
				attacker.pers["stats"]["kills"]["teamkills"] += 1;
				// Update the stats for the attacker
				attacker setClientDvars(
					"ps_t", attacker.pers["stats"]["kills"]["teamkills"]
				);				
			} else {
				attacker.pers["stats"]["deaths"]["consecutive"] = 0;
				attacker.pers["stats"]["kills"]["consecutive"] += 1;

				// Check if consecutive kills is higher than the killstreak
				if ( attacker.pers["stats"]["kills"]["consecutive"] > attacker.pers["stats"]["kills"]["killstreak"] ) {
					attacker.pers["stats"]["kills"]["killstreak"] = attacker.pers["stats"]["kills"]["consecutive"];
				}
	
				// Check if this was a headshot
				if ( sMeansOfDeath == "MOD_HEAD_SHOT" ) {
					attacker.pers["stats"]["kills"]["headshots"] += 1;
					
				// Check if this was a melee
				} else if ( sMeansOfDeath == "MOD_MELEE" || sMeansOfDeath == "MOD_BAYONET" ) {
					attacker.pers["stats"]["kills"]["knife"] += 1;
				}				

				// Check if a hardpoint was used
				switch( sWeapon ) {
					case "artillery_mp":
						attacker.pers["stats"]["hardpoints"]["artillery_kills"]++;
						break;
						
					case "dog_bite_mp":
						attacker.pers["stats"]["hardpoints"]["dog_kills"]++;
						break;
						
					default:
						// Should we check the distance
						switch ( weaponClass( sWeapon ) )	{
							case "rifle":
							case "pistol":
							case "mg":
							case "smg":
							case "spread":
								// Check in which unit are we measuring
								if ( level.scr_realtime_stats_unit == "meters" ) {
									shotDistance = int( fDistance * 0.0254 * 10 ) / 10;
								} else {
									shotDistance = int( fDistance * 0.0278 * 10 ) / 10;
								}
								if ( shotDistance > attacker.pers["stats"]["kills"]["longest"] ) {
									attacker.pers["stats"]["kills"]["longest"] = shotDistance;
								}
								if ( sMeansOfDeath == "MOD_HEAD_SHOT" && shotDistance > attacker.pers["stats"]["kills"]["longesths"] ) {
									attacker.pers["stats"]["kills"]["longesths"] = shotDistance;
								}
								break;
						}
						break;
				}	
						
				attacker.pers["stats"]["kills"]["total"] += 1;
				
				// Calculate some intermediary variables
				if ( attacker.pers["stats"]["deaths"]["total"] > 0 ) {
					kdRatio = int( attacker.pers["stats"]["kills"]["total"] / attacker.pers["stats"]["deaths"]["total"] * 100 ) / 100;
				} else {
					kdRatio = attacker.pers["stats"]["kills"]["total"];
				}
				
				if ( level.scr_realtime_stats_unit == "meters" ) {
					longestKill = attacker.pers["stats"]["kills"]["longest"] + " m";
					longestHS = attacker.pers["stats"]["kills"]["longesths"] + " m";
				} else {
					longestKill = attacker.pers["stats"]["kills"]["longest"] + " yd";
					longestHS = attacker.pers["stats"]["kills"]["longesths"] + " yd";
				}
				
				// Update the stats for the attacker
				attacker setClientDvars(
					"ps_r", kdRatio,
					"ps_k", attacker.pers["stats"]["kills"]["total"],
					"ps_cks", attacker.pers["stats"]["kills"]["consecutive"], 
					"ps_ks", attacker.pers["stats"]["kills"]["killstreak"], 
					"ps_l", longestKill,
					"ps_mk", attacker.pers["stats"]["kills"]["knife"],
					"ps_h", attacker.pers["stats"]["kills"]["headshots"],
					"ps_lh", longestHS,
					"ps_cds", attacker.pers["stats"]["deaths"]["consecutive"],
					"ps_h2k", attacker.pers["stats"]["hardpoints"]["artillery_kills"],
					"ps_h3k", attacker.pers["stats"]["hardpoints"]["dog_kills"]
				);			
			}
		}		
	}
}


onHardpointCalled()
{
	self endon("disconnect");
	
	for (;;)
	{
		self waittill( "hardpoint_called", hardpointName );
		
		clientVariable = undefined;
		newValue = undefined;
		
		// Check which hardpoint was used
		switch ( hardpointName )
		{
			case "radar_mp":
				self.pers["stats"]["hardpoints"]["radar"]++;
				clientVariable = "ps_h1";
				newValue = self.pers["stats"]["hardpoints"]["radar"];
				break;
				
			case "artillery_mp":
				self.pers["stats"]["hardpoints"]["artillery"]++;
				clientVariable = "ps_h2";
				newValue = self.pers["stats"]["hardpoints"]["artillery"];
				break;
				
			case "dogs_mp":
				self.pers["stats"]["hardpoints"]["dogs"]++;
				clientVariable = "ps_h3";
				newValue = self.pers["stats"]["hardpoints"]["dogs"];
				break;
		}
		
		// Check if we had a valid hardpoint
		if ( isDefined( clientVariable ) ) {
			self setClientDvar( clientVariable, newValue );
		}		
	}	
}