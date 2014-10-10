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
	// Use this variable to know if players have switched teams
	if ( !isDefined( game["switchedteams"] ) )
		game["switchedteams"] = false;

	// Make sure the mapper has defined the teams correctly
	if ( !isDefined( game["allies"] ) || ( game["allies"] != "marines" && game["allies"] != "russian" ) ) {
		game["allies"] = "russian";
	}
	if ( !isDefined( game["axis"] ) || ( game["axis"] != "german" && game["axis"] != "japanese" ) ) {
		game["axis"] = "german";
	}	

	// Get some variables
	level.scr_custom_teams_enable = getdvarx( "scr_custom_teams_enable", "int", 0, 0, 1 );
	level.scr_custom_teams_maintain_on_switch = getdvarx( "scr_custom_teams_maintain_on_switch", "int", 1, 0, 1 );
	
	level.scr_custom_teams_strings = getdvarx( "scr_custom_teams_strings", "string", "have won the match!;have won the round!;mission accomplished;eliminated;forfeited" );
	level.scr_custom_teams_strings = strtok( level.scr_custom_teams_strings, ";" );
	
	level.scr_custom_allies_name = getdvarx( "scr_custom_allies_name", "string", "" );
	level.scr_custom_allies_logo = getdvarx( "scr_custom_allies_logo", "string", "" );
	level.scr_custom_allies_headicon = getdvarx( "scr_custom_allies_headicon", "string", "" );
	level.scr_custom_axis_name = getdvarx( "scr_custom_axis_name", "string", "" );
	level.scr_custom_axis_logo = getdvarx( "scr_custom_axis_logo", "string", "" );
	level.scr_custom_axis_headicon = getdvarx( "scr_custom_axis_headicon", "string", "" );

	// Set default resources
	teamNames["marines"] = &"MPUI_MARINE_SHORT";
	teamNames["russian"] = &"MPUI_RUSSIAN_SHORT";
	teamNames["german"] = &"MPUI_GERMAN_SHORT";
	teamNames["japanese"] = &"MPUI_JAPANESE_SHORT";
	
	logoNames["marines"] = "faction_128_american";
	logoNames["russian"] = "faction_128_soviet";
	logoNames["german"] = "faction_128_german";
	logoNames["japanese"] = "faction_128_japan";
	
	headIconNames["marines"] = "headicon_american";
	headIconNames["russian"] = "headicon_russian";
	headIconNames["german"] = "headicon_german";
	headIconNames["japanese"] = "headicon_japanese";

	switch ( game["allies"] )
	{
		case "marines":
			game["strings"]["allies_win"] = &"MP_MARINE_WIN_MATCH";
			game["strings"]["allies_win_round"] = &"MP_MARINE_WIN_ROUND";
			game["strings"]["allies_mission_accomplished"] = &"MP_MARINE_MISSION_ACCOMPLISHED";
			game["strings"]["allies_eliminated"] = &"MP_MARINE_ELIMINATED";
			game["strings"]["allies_forfeited"] = &"MP_MARINE_FORFEITED";
			break;
			
		case "russian":
		default:
			game["strings"]["allies_win"] = &"MP_RUSSIAN_WIN_MATCH";
			game["strings"]["allies_win_round"] = &"MP_RUSSIAN_WIN_ROUND";
			game["strings"]["allies_mission_accomplished"] = &"MP_RUSSIAN_MISSION_ACCOMPLISHED";
			game["strings"]["allies_eliminated"] = &"MP_RUSSIAN_ELIMINATED";
			game["strings"]["allies_forfeited"] = &"MP_RUSSIAN_FORFEITED";
			break;
	}
	
	switch ( game["axis"] )
	{
		case "german":
			game["strings"]["axis_win"] = &"MP_GERMAN_WIN_MATCH";
			game["strings"]["axis_win_round"] = &"MP_GERMAN_WIN_ROUND";
			game["strings"]["axis_mission_accomplished"] = &"MP_GERMAN_MISSION_ACCOMPLISHED";
			game["strings"]["axis_eliminated"] = &"MP_GERMAN_ELIMINATED";
			game["strings"]["axis_forfeited"] = &"MP_GERMAN_FORFEITED";
			break;
				
		case "japanese":
		default:
			game["strings"]["axis_win"] = &"MP_JAPANESE_WIN_MATCH";
			game["strings"]["axis_win_round"] = &"MP_JAPANESE_WIN_ROUND";
			game["strings"]["axis_mission_accomplished"] = &"MP_JAPANESE_MISSION_ACCOMPLISHED";
			game["strings"]["axis_eliminated"] = &"MP_JAPANESE_ELIMINATED";
			game["strings"]["axis_forfeited"] = &"MP_JAPANESE_FORFEITED";
			break;
	}				
				
	// Check if we should use custom content or not
	if ( level.scr_custom_teams_enable == 1 ) {
		// Check value by value and change the default one when set
		if ( level.scr_custom_allies_name != "" )
			teamNames[ game[ "allies" ] ] = level.scr_custom_allies_name;

		if ( level.scr_custom_axis_name != "" )
			teamNames[ game[ "axis" ] ] = level.scr_custom_axis_name;			
			
		if ( level.scr_custom_allies_logo != "" )
			logoNames[ game[ "allies" ] ] = level.scr_custom_allies_logo;

		if ( level.scr_custom_axis_logo != "" )
			logoNames[ game[ "axis" ] ] = level.scr_custom_axis_logo;

		if ( level.scr_custom_allies_headicon != "" )
			headIconNames[ game[ "allies" ] ] = level.scr_custom_allies_headicon;

		if ( level.scr_custom_axis_headicon != "" )
			headIconNames[ game[ "axis" ] ] = level.scr_custom_axis_headicon;								

		// Change the localized strings
		game["strings"]["allies_win"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[0];
		game["strings"]["allies_win_round"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[1];
		game["strings"]["allies_mission_accomplished"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[2];
		game["strings"]["allies_eliminated"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[3];
		game["strings"]["allies_forfeited"] = level.scr_custom_allies_name + " " + level.scr_custom_teams_strings[4];	

		game["strings"]["axis_win"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[0];
		game["strings"]["axis_win_round"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[1];
		game["strings"]["axis_mission_accomplished"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[2];
		game["strings"]["axis_eliminated"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[3];
		game["strings"]["axis_forfeited"] = level.scr_custom_axis_name + " " + level.scr_custom_teams_strings[4];
	}

	// Set the values that we'll be using
	level.scr_team_allies_name = teamNames[ game[ "allies" ] ];
	level.scr_team_allies_logo = logoNames[ game[ "allies" ] ];
	level.scr_team_allies_headicon = headIconNames[ game[ "allies" ] ];
	
	level.scr_team_axis_name = teamNames[ game[ "axis" ] ];
	level.scr_team_axis_logo = logoNames[ game[ "axis" ] ];
	level.scr_team_axis_headicon = headIconNames[ game[ "axis" ] ];	


	// Set variables and internal values according to team sides
	level thread setTeamResources();
	
	// Set the colors for names
	switch(game["allies"])
	{
		case "marines":
			setDvar( "g_TeamColor_Allies", ".5 .5 .5" );
			setDvar( "g_ScoresColor_Allies", "0 0 0" );
			break;
		
		default:
			setDvar( "g_TeamColor_Allies", "0.6 0.64 0.69" );
			setDvar( "g_ScoresColor_Allies", "0.6 0.64 0.69" );
			break;
	}


	switch(game["axis"])
	{
		case "german":
			setDvar( "g_TeamColor_Axis", "0.65 0.57 0.41" );		
			setDvar( "g_ScoresColor_Axis", "0.65 0.57 0.41" );
			break;
		
		default:
			setDvar( "g_TeamColor_Axis", "0.52 0.28 0.28" );		
			setDvar( "g_ScoresColor_Axis", "0.52 0.28 0.28" );
			break;
	}
	
	setDvar( "g_ScoresColor_Spectator", ".25 .25 .25" );
	setDvar( "g_ScoresColor_Free", ".76 .78 .10" );
	setDvar( "g_teamColor_MyTeam", ".6 .8 .6" );
	setDvar( "g_teamColor_EnemyTeam", "1 .45 .5" );	
	setdvar( "g_teamColor_MyTeamAlt", ".35 1 1" ); //cyan
	setdvar( "g_teamColor_EnemyTeamAlt", "1 .5 0" ); //orange	
	setdvar( "g_teamColor_Squad", ".315 0.35 1" );	
}


setTeamResources()
{
	// Check if we should switch names/icons
	if ( level.scr_custom_teams_maintain_on_switch == 1 && game["switchedteams"] ) {
		// Switch names
		if ( level.scr_custom_allies_name != "" || level.scr_custom_axis_name != "" ) {
			tempName = level.scr_team_axis_name;
			level.scr_team_axis_name = level.scr_team_allies_name;
			level.scr_team_allies_name = tempName;

			// Switch strings
			axisWin = game["strings"]["axis_win"];
			axisWinRound = game["strings"]["axis_win_round"];
			axisMissionAccomplished = game["strings"]["axis_mission_accomplished"];
			axisEliminated = game["strings"]["axis_eliminated"];
			axisForfeited = game["strings"]["axis_forfeited"];
	
			game["strings"]["axis_win"] = game["strings"]["allies_win"];
			game["strings"]["axis_win_round"] = game["strings"]["allies_win_round"];
			game["strings"]["axis_mission_accomplished"] = game["strings"]["allies_mission_accomplished"];
			game["strings"]["axis_eliminated"] = game["strings"]["allies_eliminated"];
			game["strings"]["axis_forfeited"] = game["strings"]["allies_forfeited"];		
					
			game["strings"]["allies_win"] = axisWin;
			game["strings"]["allies_win_round"] = axisWinRound;
			game["strings"]["allies_mission_accomplished"] = axisMissionAccomplished;
			game["strings"]["allies_eliminated"] = axisEliminated;
			game["strings"]["allies_forfeited"] = axisForfeited;	
		}
				
		// Switch logos
		if ( level.scr_custom_allies_logo != "" || level.scr_custom_axis_logo != "" ) {
			tempLogo = level.scr_team_axis_logo;
			level.scr_team_axis_logo = level.scr_team_allies_logo;
			level.scr_team_allies_logo = tempLogo;
		}
		
		// Switch Head Icons
		if ( level.scr_custom_allies_headicon != "" || level.scr_custom_axis_headicon != "" ) {
			tempHeadIcon = level.scr_team_axis_headicon;
			level.scr_team_axis_headicon = level.scr_team_allies_headicon;
			level.scr_team_allies_headicon = tempHeadIcon;
		}
	}

	// Set server and internal variables
	precacheShader( level.scr_team_allies_logo );
	setDvar( "g_TeamIcon_Allies", level.scr_team_allies_logo );
	setDvar( "g_TeamName_Allies", level.scr_team_allies_name );	
	game["strings"]["allies_name"] = level.scr_team_allies_name;
	game["icons"]["allies"] = level.scr_team_allies_logo;		
	
	precacheShader( level.scr_team_axis_logo );
	setDvar( "g_TeamIcon_Axis", level.scr_team_axis_logo );
	setDvar( "g_TeamName_Axis", level.scr_team_axis_name );
	game["strings"]["axis_name"] = level.scr_team_axis_name;			
	game["icons"]["axis"] = level.scr_team_axis_logo;		
}


