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

init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_class_allies"] = "class_marines";
	game["menu_changeclass_allies"] = "changeclass_marines";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_class_axis"] = "class_opfor";
	game["menu_changeclass_axis"] = "changeclass_opfor";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass";
	game["menu_changeclass_offline"] = "changeclass_offline";
	
	game["menu_callvote"] = "callvote";
	game["menu_muteplayer"] = "muteplayer";
	precacheMenu(game["menu_callvote"]);
	precacheMenu(game["menu_muteplayer"]);
	
	// ---- back up one folder to access game_summary.menu ----
	// game summary menu file precache
	game["menu_eog_main"] = "endofgame";
	
	// menu names (do not precache since they are in game_summary_ingame which should be precached
	game["menu_eog_unlock"] = "popup_unlock";
	game["menu_eog_summary"] = "popup_summary";
	game["menu_eog_unlock_page1"] = "popup_unlock_page1";
	game["menu_eog_unlock_page2"] = "popup_unlock_page2";
	
	precacheMenu(game["menu_eog_main"]);
	precacheMenu(game["menu_eog_unlock"]);
	precacheMenu(game["menu_eog_summary"]);
	precacheMenu(game["menu_eog_unlock_page1"]);
	precacheMenu(game["menu_eog_unlock_page2"]);

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_class_allies"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_initteam_allies"]);
	precacheMenu(game["menu_class_axis"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_initteam_axis"]);
	precacheMenu(game["menu_changeclass_offline"]);
	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player setClientDvar("ui_3dwaypointtext", "1");
		player.enable3DWaypoints = true;
		player setClientDvar("ui_deathicontext", "1");
		player.enableDeathIcons = true;
		
		player thread onMenuResponse();
	}
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if( self.pers["team"] == "allies" )
						self openMenu( game["menu_class_allies"] );
					if( self.pers["team"] == "axis" )
						self openMenu( game["menu_class_axis"] );
				}
				else if ( menu == "class" )
				{
					self [[level.showsquadinfo]]();
				}
			}
			continue;
		}
		
		if(response == "showsquadinfo")
		{
			self [[level.showsquadinfo]]();
		}

		
		if(response == "leavesquad")
		{
			self closeMenu();
			self [[level.leavesquad]]();
		}

		if(response == "joinsquad")
		{
			self [[level.joinsquad]]();
		}
		
		if(response == "createsquad")
		{
			self [[level.createsquad]]();
		}

		if(response == "locksquad")
		{
			self closeMenu();
			self [[level.locksquad]]();
		}
		
		if(response == "unlocksquad")
		{
			self closeMenu();
			self [[level.unlocksquad]]();
		}
		
		if(response == "changeteam")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openMenu( "changeclass_opfor_splitscreen" );
					
		// rank update text options
		if(response == "xpTextToggle")
		{
			self.enableText = !self.enableText;
			if (self.enableText)
				self setClientDvar( "ui_xpText", "1" );
			else
				self setClientDvar( "ui_xpText", "0" );
			continue;
		}

		// 3D Waypoint options
		if(response == "waypointToggle")
		{
			self.enable3DWaypoints = !self.enable3DWaypoints;
			if (self.enable3DWaypoints)
				self setClientDvar( "ui_3dwaypointtext", "1" );
			else
				self setClientDvar( "ui_3dwaypointtext", "0" );
//			self maps\mp\gametypes\_objpoints::updatePlayerObjpoints();
			continue;
		}

		// 3D death icon options
		if(response == "deathIconToggle")
		{
			self.enableDeathIcons = !self.enableDeathIcons;
			if (self.enableDeathIcons)
				self setClientDvar( "ui_deathicontext", "1" );
			else
				self setClientDvar( "ui_deathicontext", "0" );
			self maps\mp\gametypes\_deathicons::updateDeathIconsEnabled();
			continue;
		}
		
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				if ( level.console )
					endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_globallogic::forceEnd();
				}
			}
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"])
		{
			switch(response)
			{
			case "allies":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.leavesquad]]();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.leavesquad]]();
				self [[level.axis]]();
				break;

			case "autoassign":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.leavesquad]]();
				self [[level.autoassign]]();
				break;

			case "spectator":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.leavesquad]]();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] )
		{
			self closeMenu();
			self closeInGameMenu();

			self.selectedClass = true;
			self [[level.class]](response);
		}
		else if ( !level.console )
		{
			if(menu == game["menu_quickcommands"])
				maps\mp\gametypes\_quickmessages::quickcommands(response);
			else if(menu == game["menu_quickstatements"])
				maps\mp\gametypes\_quickmessages::quickstatements(response);
			else if(menu == game["menu_quickresponses"])
				maps\mp\gametypes\_quickmessages::quickresponses(response);
		}
		
		// ======== catching response for create-a-class events ========
		
		responseTok = strTok( response, ":" );
		
		if( isdefined( responseTok ) && responseTok.size > 1 )
		{   
			if ( !isDefined( self.stat_offset ) )
				self.stat_offset = 0;
      
			if ( responseTok[0] == "stat" )
				self.stat_offset = int( responseTok[1] );
      
			if( responseTok[0] == "loadout_primary" )
			{	
				// primary weapon selection
				assertex( responseTok.size != 2, "Primary weapon selection in create-a-class-ingame is sending bad response:" + response );
				
				self setstat( self.stat_offset+201, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if( responseTok[0] == "loadout_primary_attachment" )
			{	
				// primary weapon attachment selection
				assertex( responseTok.size != 2, "Weapon attachment selection in create-a-class-ingame is sending bad response:" + response );	
        
				self setstat( self.stat_offset+202, int( responseTok[1] ) );
			}
			else if( responseTok[0] == "loadout_secondary_attachment" )
			{
				// secondary weapon attachment selection
				assertex( responseTok.size != 2, "Weapon attachment selection in create-a-class-ingame is sending bad response:" + response );	
							
				self setstat( self.stat_offset+204, int( responseTok[1] ) );
			}
			else if( responseTok[0] == "loadout_secondary" )
			{
				// secondary weapon selection
				assertex( responseTok.size != 2, "Secondary weapon selection in create-a-class-ingame is sending bad response:" + response );
				
				self setstat( self.stat_offset+203, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if ( responseTok[0] == "loadout_pgrenade" )
			{
				// primary grenade
				assertex( responseTok.size != 2, "Primary grenade selection in create-a-class-ingame is sending bad response:" + response );
        
				self setstat( self.stat_offset+200, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}
			else if( responseTok[0] == "loadout_perk" )
			{
				// all 3 perks selection
				assertex( responseTok.size != 2, "Perks selection in create-a-class-ingame is sending bad response:" + response );
						
				perkslot = tableLookUp( "mp/statsTable.csv", 4, responseTok[1], 8 );			
			
				if ( perkslot == "perk1" )
					self setstat( self.stat_offset+205, int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) );
				else if ( perkslot == "perk2" )
					self setstat( self.stat_offset+206, int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) );
				else if ( perkslot == "perk3" )
					self setstat( self.stat_offset+207, int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) );
				else
					self setstat( self.stat_offset+305, int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) );
        
			}
			else if( responseTok[0] == "loadout_sgrenade" )
			{
				assertex( responseTok.size != 2, "Special grenade selection in create-a-class-ingame is sending bad response:" + response );
				
				self setstat( self.stat_offset+208, ( int( tableLookup( "mp/statsTable.csv", 4, responseTok[1], 1 ) ) - 3000 ) );
			}	
		}
	}
}

