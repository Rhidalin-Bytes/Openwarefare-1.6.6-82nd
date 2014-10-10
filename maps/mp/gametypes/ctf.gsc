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
#include maps\mp\_geometry;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_spawning;
#include maps\mp\_music;
#include openwarfare\_utils;

/*
	CTF
	
	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flag:
			classname				trigger_multiple
			targetname				flagtrigger
			script_gameobjectname	ctf
			script_label				Set to name of flag. This sets the letter shown on the compass in original mode.
			script_team					Set to allies or axis. This is used to set which team a flag is used by.
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used to represent a flag.
			It gets moved to the position of the planted bomb model.
*/

/*QUAKED mp_ctf_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_ctf_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();


	level.scr_ctf_ctfmode = getdvarx( "scr_ctf_ctfmode", "int", 0, 0, 2  );
	level.scr_ctf_endround_on_capture = getdvarx( "scr_ctf_endround_on_capture", "int", 0, 0, 1  );
	level.scr_ctf_flag_carrier_can_return = getdvarx( "scr_ctf_flag_carrier_can_return", "int", 1, 0, 1  );	
	level.scr_ctf_show_flag_carrier = getdvarx( "scr_ctf_show_flag_carrier", "int", 0, 0, 2  );
	level.scr_ctf_scoreboard_flag_carrier = getdvarx( "scr_ctf_scoreboard_flag_carrier", "int", 1, 0, 1 );
	level.scr_ctf_show_flag_carrier_time = getdvarx( "scr_ctf_show_flag_carrier_time", "int", 5, 5, 600 );
	level.scr_ctf_show_flag_carrier_distance = getdvarx( "scr_ctf_show_flag_carrier_distance", "int", 0, 0, 1000 );

	level.scr_ctf_suddendeath_show_enemies = getdvarx( "scr_ctf_suddendeath_show_enemies", "int", 1, 0, 1 );
	level.scr_ctf_suddendeath_timelimit = getdvarx( "scr_ctf_suddendeath_timelimit", "int", 90, 0, 600 );

	level.scr_ctf_idleflagreturntime = getdvarx( "scr_ctf_idleflagreturntime", "float", 60, 0, 120 );	
	if ( level.scr_ctf_idleflagreturntime == 0 && level.scr_ctf_ctfmode == 1 ) {
		level.scr_ctf_ctfmode = 0;
	}	
		
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 2, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 1, 0, 500 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 0, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 20, 0, 1440 );

		
	if ( getdvar("scr_ctf_spawnPointFacingAngle") == "" )
		setdvar("scr_ctf_spawnPointFacingAngle", "60");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
//	level.onScoreLimit = ::onScoreLimit;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onEndGame = ::onEndGame;
	level.onTeamOutcomeNotify = ::onTeamOutcomeNotify;
	
	if ( level.scr_ctf_endround_on_capture == 1 ) {
		level.onTimeLimit = ::onTimeLimit;
	}	

//	level.endGameOnScoreLimit = false;
	level.scoreLimitIsPerRound = true;
	
	if ( !isdefined( game["ctf_teamscore"] ) )
	{
		game["ctf_teamscore"]["allies"] = 0;
		game["ctf_teamscore"]["axis"] = 0;
	}

	game["dialog"]["gametype"] = "ctf";
	game["dialog"]["wetake_flag"] = "wetake_flag";
	game["dialog"]["theytake_flag"] = "theytake_flag";
	game["dialog"]["theydrop_flag"] = "theydrop_flag";
	game["dialog"]["wedrop_flag"] = "wedrop_flag";
	game["dialog"]["wereturn_flag"] = "wereturn_flag";
	game["dialog"]["theyreturn_flag"] = "theyreturn_flag";
	game["dialog"]["theycap_flag"] = "theycap_flag";
	game["dialog"]["wecap_flag"] = "wecap_flag";
	game["dialog"]["offense_obj"] = "ctf_boost";
	game["dialog"]["defense_obj"] = "ctf_boost";

	level.lastDialogTime = getTime();
}

onPrecacheGameType()
{
	game["flag_dropped_sound"] = "mp_war_objective_lost";
	game["flag_recovered_sound"] = "mp_war_objective_taken";
	
	precacheStatusIcon( "hud_status_flag" );
	precacheShader( "compass_waypoint_target" );
	precacheShader( "waypoint_kill" );	
	
	game["flagmodels"] = [];
	game["carry_flagmodels"] = [];
	game["carry_icon"] = [];
	game["waypoints_flag"] = [];
	game["waypoints_base"] = [];
	game["compass_waypoint_flag"] = [];
	game["compass_waypoint_base"] = [];

	if ( game["allies"] == "marines" )
	{
		game["flagmodels"]["allies"] = "prop_flag_american";
		game["carry_flagmodels"]["allies"] = "prop_flag_american_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_american";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_american";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_american";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_american";
		game["carry_icon"]["allies"] = "hudicon_american_ctf_flag_carry";
	}
	else
	{
		game["flagmodels"]["allies"] = "prop_flag_russian";
		game["carry_flagmodels"]["allies"] = "prop_flag_russian_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_russian";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_russian";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_russian";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_russian";
		game["carry_icon"]["allies"] = "hudicon_russian_ctf_flag_carry";
	}
	
	if ( game["axis"] == "german" ) 
	{
		game["flagmodels"]["axis"] = "prop_flag_german";
		game["carry_flagmodels"]["axis"] = "prop_flag_german_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_german";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_german";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_german";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_german";
		game["carry_icon"]["axis"] = "hudicon_german_ctf_flag_carry";
	}
	else
	{
		game["flagmodels"]["axis"] = "prop_flag_japanese";
		game["carry_flagmodels"]["axis"] = "prop_flag_japanese_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_japanese";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_japanese";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_japanese";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_japanese";
		game["carry_icon"]["axis"] = "hudicon_japanese_ctf_flag_carry";
	}
	
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	precacheModel( game["carry_flagmodels"]["allies"] );
	precacheModel( game["carry_flagmodels"]["axis"] );

	precacheShader( game["waypoints_flag"]["allies"] );
	precacheShader( game["waypoints_base"]["allies"] );
	precacheShader( game["compass_waypoint_flag"]["allies"] );
	precacheShader( game["compass_waypoint_base"]["allies"] );
	precacheShader( game["carry_icon"]["allies"] );
	
	precacheShader( game["waypoints_flag"]["axis"] );
	precacheShader( game["waypoints_base"]["axis"] );
	precacheShader( game["compass_waypoint_flag"]["axis"] );
	precacheShader( game["compass_waypoint_base"]["axis"] );
	precacheShader( game["carry_icon"]["axis"] );
	
	precacheString(&"MP_FLAG_TAKEN_BY");
	precacheString(&"MP_ENEMY_FLAG_TAKEN_BY");
	precacheString(&"MP_FLAG_CAPTURED_BY");
	precacheString(&"MP_ENEMY_FLAG_CAPTURED_BY");
	//precacheString(&"MP_FLAG_RETURNED_BY");
	precacheString(&"MP_FLAG_RETURNED");
	precacheString(&"MP_ENEMY_FLAG_RETURNED");
	precacheString(&"MP_YOUR_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_DROPPED_BY");
	precacheString(&"MP_SUDDEN_DEATH");
	precacheString(&"MP_CAP_LIMIT_REACHED");
	precacheString(&"MP_CTF_CANT_CAPTURE_FLAG" );
	
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";

}

onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	/#
	setdebugsideswitch(game["switchedsides"]);
	#/
	
	setClientNameMode("auto_change");

	ctf_setTeamScore( "allies", 0 );
	ctf_setTeamScore( "axis", 0 );

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_CTF" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_CTF" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_CTF_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_CTF_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_axis = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis" );
	level.spawn_allies = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies_start" );

	level.displayRoundEndText = true;

	allowed[0] = "ctf";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread ctf();
}

ctf_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	maps\mp\gametypes\_globallogic::updateTeamScores( team );
}

onRoundSwitch()
{
	level.halftimeType = "halftime";	
	game["switchedsides"] = !game["switchedsides"];
}

onScoreLimit()
{
	if ( maps\mp\gametypes\_globallogic::hitRoundLimit())
	{
		level.endGameOnScoreLimit = true;
		maps\mp\gametypes\_globallogic::default_onScoreLimit();
		return;
	}	
	
	winner = undefined;
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
	
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
}

onEndGame( winningTeam )
{
	game["ctf_teamscore"]["allies"] += maps\mp\gametypes\_globallogic::_getTeamScore( "allies");
	game["ctf_teamscore"]["axis"] += maps\mp\gametypes\_globallogic::_getTeamScore( "axis");
}

onRoundEndGame( winningTeam )
{
	ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
	ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";

	// make sure stats get reported
	maps\mp\gametypes\_globallogic::updateWinLossStats( winner );
	
	return winner;
}

// using this to set the halftime scores to be the total scores if there is more then
// one round per half
// this happens per player but after the first player the ctf_setTeamScore
// should not do anything
onTeamOutcomeNotify( switchtype, isRound, endReasonText )
{
	if ( switchtype == "halftime" || switchtype == "intermission")
	{
		ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
		ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	}
	
	maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchtype, isRound, endReasonText );
}

onSpawnPlayerUnified()
{
	self.isFlagCarrier = false;
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer()
{
	self.isFlagCarrier = false;

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}

createFlag( trigger )
{		
	if ( isDefined( trigger.target ) )
	{
		visuals[0] = getEnt( trigger.target, "targetname" );
	}
	else
	{
		visuals[0] = spawn( "script_model", trigger.origin );
		visuals[0].angles = trigger.angles;
	}

	entityTeam = trigger.script_team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	visuals[0] setModel( game["flagmodels"][entityTeam] );

	flag = maps\mp\gametypes\_gameobjects::createCarryObject( entityTeam, trigger, visuals, (0,0,100) );
	flag maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	flag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flag maps\mp\gametypes\_gameobjects::setVisibleCarrierModel( game["carry_flagmodels"][entityTeam] );
//		flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["carry_icon"][entityTeam] );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["compass_waypoint_flag"][entityTeam] );
	flag.objIDPingFriendly = true;

	/*if ( level.enemyCarrierVisible == 2 )
	{
		flag.objIDPingFriendly = true;
	}*/
	flag.allowWeapons = true;
	flag.onPickup = ::onPickup;
	flag.onPickupFailed = ::onPickup;
	flag.onDrop = ::onDrop;
	flag.onReset = ::onReset;
			
	if ( level.scr_ctf_ctfmode == 1 )	{
		flag.autoResetTime = level.scr_ctf_idleflagreturntime;
	}
	
	return flag;
}

createFlagZone( trigger )
{
	visuals = [];
	
	entityTeam = trigger.script_team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	flagZone = maps\mp\gametypes\_gameobjects::createUseObject( entityTeam, trigger, visuals, (0,0,100) );
	flagZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	flagZone maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	flagZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
	//flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconTakenEnemy2D );
	flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconTakenEnemy3D );

	enemyTeam = getOtherTeam( entityTeam );
	//flagZone maps\mp\gametypes\_gameobjects::setKeyObject( level.teamFlags[enemyTeam] );
	flagZone.onUse = ::onCapture;
	
	flag = level.teamFlags[entityTeam];
	flag.flagBase = flagZone;
	flagZone.flag = flag;
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	flagZone.baseeffectforward = anglesToForward( upangles );
	flagZone.baseeffectright = anglesToRight( upangles );
	
	flagZone.baseeffectpos = trace["position"];
	
	flagZone thread resetFlagBaseEffect();
	
	flagZone createFlagSpawnInfluencer( entityTeam );
	
	return flagZone;
//		flag resetIcons();
}

createFlagHint( team, origin )
{
	radius = 128;
	height = 64;
	
	trigger = spawn("trigger_radius", origin, 0, radius, height);
	trigger setHintString( &"MP_CTF_CANT_CAPTURE_FLAG" );
	trigger setcursorhint("HINT_NOICON");
	trigger.original_origin = origin;
	
	trigger turn_off();
	
	return trigger;
}

ctf()
{
	level.flags = [];
	level.teamFlags = [];
	level.flagZones = [];
	level.teamFlagZones = [];
	
	level.iconCapture3D = "waypoint_capture";
	level.iconCapture2D = "compass_waypoint_capture";
	level.iconDefend3D = "waypoint_defend";
	level.iconDefend2D = "compass_waypoint_defend";
	level.iconTakenFriendly3D = "waypoint_taken_friendly";
	level.iconTakenEnemy3D = "waypoint_taken_enemy";
	level.iconTakenFriendly2D = "compass_waypoint_taken_friendly";
	level.iconTakenEnemy2D = "compass_waypoint_taken_enemy";
	level.iconDropped3D = "waypoint_defend";
	level.iconCarrier3D = "waypoint_flag_yellow";
	level.iconEnemyCarrier3D = "waypoint_kill";
	level.iconReturn3D = "waypoint_return";
	level.iconBase3D = "waypoint_capture";
	
	precacheShader( level.iconCapture3D );
	precacheShader( level.iconDefend3D );

	precacheShader( level.iconCapture2D );
	precacheShader( level.iconDefend2D );

	precacheShader( level.iconTakenFriendly3D );
	precacheShader( level.iconTakenEnemy3D );
	precacheShader( level.iconTakenFriendly2D );
	precacheShader( level.iconTakenEnemy2D );
	precacheShader( level.iconDropped3D );
	precacheShader( level.iconCarrier3D );
	precacheShader( level.iconReturn3D );
	precacheShader( level.iconBase3D );
	precacheShader( level.iconEnemyCarrier3D );

	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_blue";
	flagBaseFX["japanese"] = "misc/ui_flagbase_red";
	flagBaseFX["german"] = "misc/ui_flagbase_gold";
	flagBaseFX["russian"] = "misc/ui_flagbase_orange";
	
	level.flagBaseFXid[ "allies" ] = loadfx( flagBaseFX[ game[ "allies" ] ] );
	level.flagBaseFXid[ "axis"   ] = loadfx( flagBaseFX[ game[ "axis"   ] ] );

	flag_triggers = getEntArray( "ctf_flag_pickup_trig", "targetname" );
	if ( !isDefined( flag_triggers ) || flag_triggers.size != 2)
	{
		maps\mp\_utility::error("Not enough ctf_flag_pickup_trig triggers found in map.  Need two.");
		return;
	}

	for ( index = 0; index < flag_triggers.size; index++ )
	{
		trigger = flag_triggers[index];
		
		flag = createFlag( trigger );
		
		team = flag maps\mp\gametypes\_gameobjects::getOwnerTeam();
		level.flags[level.flags.size] = flag;
		level.teamFlags[team] = flag;
		
	}

	flag_zones = getEntArray( "ctf_flag_zone_trig", "targetname" );
	if ( !isDefined( flag_zones ) || flag_zones.size != 2)
	{
		maps\mp\_utility::error("Not enough ctf_flag_zone_trig triggers found in map.  Need two.");
		return;
	}

	for ( index = 0; index < flag_zones.size; index++ )
	{
		trigger = flag_zones[index];
		
		flagZone = createFlagZone( trigger );

		team = flagZone maps\mp\gametypes\_gameobjects::getOwnerTeam();
		level.flagZones[level.flagZones.size] = flagZone;		
		level.teamFlagZones[team] = flagZone;		

		level.flagHints[team] = createFlagHint( team, trigger.origin );		

		facing_angle = getdvarint("scr_ctf_spawnPointFacingAngle");
		
		// the opposite team will want to face this point
		if ( team == "axis" )
		{
			setspawnpointsbaseweight( level.spawnsystem.iSPAWN_TEAMMASK_ALLIES, trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
		}
		else
		{
			setspawnpointsbaseweight( level.spawnsystem.iSPAWN_TEAMMASK_AXIS, trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
		}
	}
	
	// once all the flags have been registered with the game,
	// give each spawn point a baseline score for each objective flag,
	// based on whether or not player will be looking in the direction of that flag upon spawning
	//generate_baseline_spawn_point_scores();

	if ( level.scr_ctf_ctfmode == 1 ) {
		createReturnMessageElems();
	}
}

onTimeLimit()
{
	if ( level.inOvertime )
		return;

	thread onOvertime();
}

onOvertime()
{
	level endon ( "game_ended" );

	level.timeLimitOverride = true;
	level.inOvertime = true;

	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] notify("force_spawn");
		level.players[index] thread maps\mp\gametypes\_hud_message::oldNotifyMessage( &"MP_SUDDEN_DEATH", &"MP_NO_RESPAWN", undefined, (1, 0, 0), "mp_last_stand" );

		if ( level.scr_ctf_suddendeath_show_enemies == 1 ) {
			level.players[index] setClientDvars("cg_deadChatWithDead", 1,
								"cg_deadChatWithTeam", 0,
								"cg_deadHearTeamLiving", 0,
								"cg_deadHearAllLiving", 0,
								"cg_everyoneHearsEveryone", 0,
								"g_compassShowEnemies", 1 );
		}
	}

	if ( level.scr_ctf_suddendeath_timelimit > 0 ) {
		waitTime = 0;
		while ( waitTime < level.scr_ctf_suddendeath_timelimit ) {
			waitTime += 1;
			setGameEndTime( getTime() + ( ( level.scr_ctf_suddendeath_timelimit - waitTime ) * 1000 ) );
			wait ( 1.0 );
		}
		thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["tie"] );
		
	} else {
		level.timelimit = 0;
	}
}

onDrop( player )
{
	level notify( self.ownerTeam + "_flag_dropped", self, player );	

	level.teamFlagZones[self.ownerTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	if ( level.scr_ctf_ctfmode == 0 || level.scr_ctf_ctfmode == 2 )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		level.flagHints[getOtherTeam( self.ownerTeam )] turn_off();
	}

	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wedrop_flag", getOtherTeam( self.ownerTeam ) );
		maps\mp\gametypes\_globallogic::leaderDialog( "theydrop_flag", self.ownerTeam );
		level.lastDialogTime = getTime();
	}

	if ( isDefined( player ) ) {
		player.isFlagCarrier = false;
		player deleteBaseIcon();
	
		printAndSoundOnEveryone( self.ownerTeam, "none", &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", player );		
	
		if ( level.scr_ctf_scoreboard_flag_carrier == 1 && isAlive( player ) ) {
			player.statusicon = "";
		}
		
	 	player logString( self.ownerTeam + " flag dropped" );
	 	player playLocalSound("flag_drop_plr");
	 	
	} else {
	 	logString( self.ownerTeam + " flag dropped" );
	}	

//	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );

	if ( level.scr_ctf_ctfmode == 0 || level.scr_ctf_ctfmode == 2 )
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconReturn3D );
	}
	else
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDropped3D );
	}	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

	thread maps\mp\_utility::playSoundOnPlayers( game["flag_dropped_sound"], game["attackers"] );

	if ( level.scr_ctf_ctfmode == 1 ) {
		self thread returnFlagHudElems();
	}
}


onPickup( player )
{
	// Make sure this player is not already a flag carrier
	if ( level.scr_ctf_ctfmode == 2 && player.isFlagCarrier )
		return;
	
	self notify("picked_up");

	playerTeam = player.pers["team"];
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );

	// If the player is in the same team as the flag then we need to return the flag
	if ( playerTeam == self.ownerTeam && level.scr_ctf_ctfmode == 0 ) {
		// Check if this player can return its own flag
		if ( !player.isFlagCarrier || level.scr_ctf_flag_carrier_can_return == 1 ) {
			player setStatLBByName( "CTF_Flags", 1, "Returned");
			
			printAndSoundOnEveryone( team, "none", &"MP_FLAG_RETURNED_BY", "", "mp_obj_returned", "", player );
	
			// want to return the flag here
			self returnFlag( player );
			if ( isDefined( player ) ) {
				player logString( team + " flag returned" );
				
				lpselfnum = player getEntityNumber();
				lpGuid = player getGuid();
				logPrint("FR;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");
			}	else {
			 	logString( team + " flag returned" );
			}
		}
		return;
	}

	// Set this player as the flag carrier, set up the scoreboard status and give the proper score
	player.isFlagCarrier = true;
	if ( level.scr_ctf_scoreboard_flag_carrier == 1 ) {
		player.statusicon = "hud_status_flag";
	}
	
	// We only give "take" points when it's taken from the enemy's base
	if ( playerTeam != self.ownerTeam && self.curOrigin == self.trigger.baseOrigin ) {
		if ( level.scr_enable_scoresystem ) 
		  player thread giveScoreForObjective ( player, "take" );
		  		
		player setStatLBByName( "CTF_Flags", 1, "Picked Up");
	}	

	// Play the corresponding sounds for players
	if ( playerTeam != self.ownerTeam ) {
		thread printAndSoundOnEveryone( otherteam, team, &"MP_ENEMY_FLAG_TAKEN_BY", &"MP_FLAG_TAKEN_BY", "mp_obj_taken", "mp_enemy_obj_taken", player );
	} else {
		level.teamFlagZones[self.ownerTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
		thread printAndSoundOnEveryone( playerTeam, getOtherTeam( playerTeam ), &"OW_FLAG_RECOVERED_BY", &"OW_ENEMY_FLAG_RECOVERED_BY", "mp_obj_taken", "mp_enemy_obj_taken", player );
	}

	if( playerTeam != self.ownerTeam && getTime() - level.lastDialogTime > 1500 )
	{
		//check if we want to do the squad line
		squadID = getplayersquadid( player );
		if( isDefined( squadID ) )
			maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam, undefined, undefined, "squad_take", squadID );
		else
			maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam );

		maps\mp\gametypes\_globallogic::leaderDialog( "theytake_flag", team );
		level.lastDialogTime = getTime();
	}
	
	player playLocalSound("flag_pickup_plr");
	
	// Set the new icons to be displayed
	if ( level.scr_ctf_show_flag_carrier == 0 || level.scr_ctf_show_flag_carrier == 2 ) {
		// Only friendlies see the flag carrier in the minimap
		if ( playerTeam != self.ownerTeam ) {
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "enemy" );
		} else {
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
		}
	} else {
		// Kill waypoint is always enabled
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		if ( playerTeam != self.ownerTeam ) {
			self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_target" );
			self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_kill" );
		} else {
			self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
			self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_kill" );
		}
	}

	// Check if we need to monitor the player carrying the flag
	if ( level.scr_ctf_show_flag_carrier ==  2 ) {
		self thread monitorFlagCarrier( player );
	}

	if ( playerTeam != self.ownerTeam ) {
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" );
	} else {
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
	}
		
	player thread claim_trigger( level.flagHints[otherTeam] );
	
	player setupBaseIcon( playerTeam != self.ownerTeam );
	player updateBaseIcon();
	
	update_hints();

	if ( playerTeam != self.ownerTeam ) {
		player logString( team + " flag taken" );
		lpselfnum = player getEntityNumber();
		lpGuid = player getGuid();
		logPrint("FT;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");
	} else {
		player logString( team + " flag recovered" );
		lpselfnum = player getEntityNumber();
		lpGuid = player getGuid();
		logPrint("FV;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");		
	}	
}


returnFlag( player )
{
	level notify( self.ownerTeam + "_flag_dropped", self, player );	
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = level.otherTeam[team];
	
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	update_hints();
	
	self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	self maps\mp\gametypes\_gameobjects::returnHome( player );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );	
	
	
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wereturn_flag", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "theyreturn_flag", otherTeam );
		level.lastDialogTime = getTime();
	}

	if ( level.scr_enable_scoresystem  && isDefined( player ) )
	  player thread giveScoreForObjective ( player, "return" );
}


onCapture( player )
{
	// Check if this player is the flag carrier
	if ( player.isFlagCarrier ) {

		level notify( getOtherTeam( player.pers["team"] ) + "_flag_captured", player.carryObject, player );
		
		team = player.pers["team"];
		enemyTeam = getOtherTeam( team );
		
		playerTeamsFlag = level.teamFlags[team];

		// Player is returning their flag or capturing the enemy's when theirs is at home
		if ( team == player.carryObject.ownerTeam || !playerTeamsFlag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() ) {
			player.isFlagCarrier = false;
			
			if ( level.scr_ctf_scoreboard_flag_carrier == 1 ) {
				player.statusicon = "";
			}
		
			// Give the player the capture score and the team 1 point
			if ( team != player.carryObject.ownerTeam ) {					
				printAndSoundOnEveryone( team, enemyTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player );
			
				thread playSoundOnPlayers( "mx_CTF_score"+"_"+level.teamPrefix[team] );
				if( getTime() - level.lastDialogTime > 1500 )
				{
					maps\mp\gametypes\_globallogic::leaderDialog( "wecap_flag", team );
					maps\mp\gametypes\_globallogic::leaderDialog( "theycap_flag", enemyTeam );
					level.lastDialogTime = getTime();
				}
				
				player setStatLBByName( "CTF_Flags", 1, "Captured");
			
				player thread giveScoreForObjective ( player, "capture" );
			
				player logString( enemyTeam + " flag captured" );
			
				lpselfnum = player getEntityNumber();
				lpGuid = player getGuid();
				logPrint("FC;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");
				
				flag = player.carryObject;
				
				flag.dontAnnounceReturn = true;
				flag.onReset = undefined;
				flag maps\mp\gametypes\_gameobjects::returnHome();
				flag.onReset = ::onReset;
				
				update_hints();
				flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
				flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
				flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
				level.teamFlagZones[flag.ownerTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
						
				flag.dontAnnounceReturn = undefined;
				
				level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
				level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
				//level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::returnHome();
							
				player deleteBaseIcon();
			
				[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );
			
				//if( game["teamScores"]["allies"] == level.scoreLimit - 1 || game["teamScores"]["axis"] == level.scoreLimit - 1 )
				//	setMusicState( "MATCH_END" );
				
				// Check if we need to end the round or not
				if ( level.scr_ctf_endround_on_capture == 1 ) {
					thread maps\mp\gametypes\_globallogic::endGame( player.pers["team"], game["strings"][player.pers["team"] + "_win_round"] );
				}
			
			
			} else {
				player setStatLBByName( "CTF_Flags", 1, "Returned");
				flag = player.carryObject;
				update_hints();
				flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
				flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
				flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );				
				level.teamFlagZones[flag.ownerTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
					
				// want to return the flag here
				player.carryObject returnFlag( player );
				player deleteBaseIcon();				
				
				if ( isDefined( player ) ) {
					player logString( team + " flag returned" );
					
					lpselfnum = player getEntityNumber();
					lpGuid = player getGuid();
					logPrint("FR;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");
				}	else {
				 	logString( team + " flag returned" );
				}				
			}
		}
	}
}

giveScoreForObjective( player, credit )
{
  if ((credit != "capture") && (credit != "take") && (credit != "defend") && (credit != "return") && (credit != "killcarrier") && (credit != "carrier_assist"))
    return;

  wait .05;
  player thread [[level.onXPEvent]]( credit );
  maps\mp\gametypes\_globallogic::givePlayerScore( credit, player );
}

onReset( player )
{	
	self notify( "returned", player );
	
	update_hints();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
		
	// Play the corresponding sounds for players
	if ( isDefined( player ) ) {
		
		thread printAndSoundOnEveryone( self.ownerTeam, getOtherTeam( self.ownerTeam ), &"MP_FLAG_RETURNED_BY", &"OW_ENEMY_FLAG_RETURNED_BY", "mp_obj_returned", "mp_enemy_obj_returned", player );
		player logString( self.ownerTeam + " flag returned" );

		lpselfnum = player getEntityNumber();
		lpGuid = player getGuid();
		logPrint("FR;" + lpGuid + ";" + lpselfnum + ";" + player.name + "\n");
		
	} else {
		thread printAndSoundOnEveryone( self.ownerTeam, getOtherTeam( self.ownerTeam ), &"MP_FLAG_RETURNED", &"MP_ENEMY_FLAG_RETURNED", "mp_obj_returned", "mp_enemy_obj_returned", "" );
		logString( self.ownerTeam + " flag returned" );
	}
	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
}

getOtherFlag( flag )
{
	if ( flag == level.flags[0] )
	 	return level.flags[1];
	 	
	return level.flags[0];
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( level.scr_enable_scoresystem ) {
	 
	  // did the attacker kill the flag carrier?
	  if (( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] ) &&
	      ( isDefined( self.isFlagCarrier ) && self.isFlagCarrier )) {
	    attacker thread giveScoreForObjective ( attacker, "killcarrier" );
	  } else {
	    // attacker defended the flag....
	    // Make sure the attacker is not in the same team
	    if ( isDefined( attacker ) && isPlayer( attacker ) && self.pers["team"] != attacker.pers["team"] ) {
	      
	      // Get the distance between the victim and the attacker's flag
	      distanceToEnemyFlag = distance( self.origin, level.teamFlags[attacker.pers["team"]].curOrigin );
	      
	      // 197 units = 5 meters
	      if ( distanceToEnemyFlag <= 197 ) {
		attacker thread giveScoreForObjective ( attacker, "defend" );
	      }

	      // attacker saved his flagcarrier
	      flagcarrier = GetTeamFlagCarrier( attacker.pers["team"] );
	      
	      if ( isdefined(flagcarrier) ) {
		// get the distance between the victim and the own flag carrier
		distanceToOwnFlagCarrier = distance( self.origin, flagcarrier.origin );
		
		// 394 units = 10 meters
		if ( distanceToOwnFlagCarrier <= 394 ) {
		  attacker thread giveScoreForObjective ( attacker, "carrier_assist" );
		}
	      }
	    }
	  }
	} else {
	  if ( !isDefined( self.isFlagCarrier ) || !self.isFlagCarrier )
	    return;

	  if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] ) {
	    // jinxter [1.5.0]: error in stock: "kill_carrier" never defined -> changed to "killcarrier"
	    attacker thread [[level.onXPEvent]]( "killcarrier" );
	    maps\mp\gametypes\_globallogic::givePlayerScore( "killcarrier", attacker );
	    }
	}
}

createReturnMessageElems()
{
	level.ReturnMessageElems = [];

	level.ReturnMessageElems["allies"]["axis"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["axis"] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", 0, -105 );
	level.ReturnMessageElems["allies"]["axis"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["axis"].alpha = 0;
	level.ReturnMessageElems["allies"]["axis"].archived = false;
	level.ReturnMessageElems["allies"]["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["allies"] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", 0, -90 );
	level.ReturnMessageElems["allies"]["allies"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["allies"].alpha = 0;
	level.ReturnMessageElems["allies"]["allies"].archived = false;

	level.ReturnMessageElems["axis"]["allies"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["allies"] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", 0, -105 );
	level.ReturnMessageElems["axis"]["allies"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["allies"].alpha = 0;
	level.ReturnMessageElems["axis"]["allies"].archived = false;
	level.ReturnMessageElems["axis"]["axis"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["axis"] setPoint( "BOTTOMRIGHT", "BOTTOMRIGHT", 0, -90 );
	level.ReturnMessageElems["axis"]["axis"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["axis"].alpha = 0;
	level.ReturnMessageElems["axis"]["axis"].archived = false;
}

returnFlagHudElems()
{
	level endon("game_ended");
	
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	assert( !level.ReturnMessageElems["axis"][ownerTeam].alpha );
	level.ReturnMessageElems["axis"][ownerTeam].alpha = 1;
	level.ReturnMessageElems["axis"][ownerTeam] setTimer( level.scr_ctf_idleflagreturntime );
	
	assert( !level.ReturnMessageElems["allies"][ownerTeam].alpha );
	level.ReturnMessageElems["allies"][ownerTeam].alpha = 1;
	level.ReturnMessageElems["allies"][ownerTeam] setTimer( level.scr_ctf_idleflagreturntime );
	
	self waittill_any( "picked_up", "returned" );
	
	level.ReturnMessageElems["allies"][ownerTeam].alpha = 0;
	level.ReturnMessageElems["axis"][ownerTeam].alpha = 0;
}

resetFlagBaseEffect()
{
	// dont spawn first frame
	wait (0.1);
	
	if ( isdefined( self.baseeffect ) )
		self.baseeffect delete();
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	
	triggerFx( self.baseeffect );
}

turn_on()
{
	if ( level.hardcoreMode )
		return;
		
	self.origin = self.original_origin;
}

turn_off()
{
	self.origin = ( self.original_origin[0], self.original_origin[1], self.original_origin[2] - 10000);
}

update_hints()
{
	allied_flag = level.teamFlags["allies"];
	axis_flag = level.teamFlags["axis"];

	if ( isdefined(allied_flag.carrier) )
		allied_flag.carrier updateBaseIcon();
			
	if ( isdefined(axis_flag.carrier) )
		axis_flag.carrier updateBaseIcon();
			
	if ( level.scr_ctf_ctfmode != 0 )
		return;

	if ( isdefined(allied_flag.carrier) && axis_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["axis"] turn_on();		
	}
	else
	{
		level.flagHints["axis"] turn_off();
	}		
	
	if ( isdefined(axis_flag.carrier) && allied_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["allies"] turn_on();		
	}
	else
	{
		level.flagHints["allies"] turn_off();
	}		
}

claim_trigger( trigger )
{
	self endon("disconnect");
	self ClientClaimTrigger( trigger );
	
	self waittill("drop_object");
	self ClientReleaseTrigger( trigger );
}

setupBaseIcon( flagCapture )
{
	zone = level.teamFlagZones[self.pers["team"]];
	self.ctfBaseIcon = newClientHudElem( self );
	self.ctfBaseIcon.x = zone.trigger.origin[0];
	self.ctfBaseIcon.y = zone.trigger.origin[1];
	self.ctfBaseIcon.z = zone.trigger.origin[2] + 100;
	self.ctfBaseIcon.alpha = 1; // needs to be solid to obscure flag icon
	self.ctfBaseIcon.baseAlpha = 1;
	self.ctfBaseIcon.awayAlpha = 0.35;
	self.ctfBaseIcon.archived = true;
	
	if ( flagCapture ) {
		self.ctfBaseIcon setShader( level.iconBase3D, level.objPointSize, level.objPointSize );
		self.ctfBaseIcon setWaypoint( true, level.iconBase3D );
	} else {
		self.ctfBaseIcon setShader( level.iconReturn3D, level.objPointSize, level.objPointSize );
		self.ctfBaseIcon setWaypoint( true, level.iconReturn3D );
	}	
	
	self.ctfBaseIcon.sort = 1; // make sure it sorts on top of the flag icon
}

deleteBaseIcon()
{
	self.ctfBaseIcon destroy();
	self.ctfBaseIcon = undefined;
}

updateBaseIcon()
{
	team = self.pers["team"];
	otherteam = getotherteam(team);
	
	flag = level.teamFlags[team];
	
	visible = false;
	if ( flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		visible = true;
	}
	
	updateBaseIconVisibility( visible );
}

updateBaseIconVisibility( visible )
{
	// can hit here if a friendly team touches flag to return
	if ( !isdefined(self.ctfBaseIcon) )
		return;
		
	if ( visible )
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.awayAlpha;
		self.ctfBaseIcon.isShown = true;
	}
	else
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.baseAlpha;
		self.ctfBaseIcon.isShown = true;
	}
}

createFlagSpawnInfluencer( entityTeam )
{
	// ctf: influencer around friendly base
	ctf_friendly_base_influencer_score= level.spawnsystem.ctf_friendly_base_influencer_score;
	ctf_friendly_base_influencer_score_curve= level.spawnsystem.ctf_friendly_base_influencer_score_curve;
	ctf_friendly_base_influencer_radius= level.spawnsystem.ctf_friendly_base_influencer_radius;
	
	// ctf: influencer around enemy base
	ctf_enemy_base_influencer_score= level.spawnsystem.ctf_enemy_base_influencer_score;
	ctf_enemy_base_influencer_score_curve= level.spawnsystem.ctf_enemy_base_influencer_score_curve;
	ctf_enemy_base_influencer_radius= level.spawnsystem.ctf_enemy_base_influencer_radius;
	
	otherteam = getotherteam(entityTeam);
	team_mask = get_team_mask( entityTeam );
	other_team_mask = get_team_mask( otherteam );
	
	self.spawn_influencer_friendly = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_friendly_base_influencer_radius,
							 ctf_friendly_base_influencer_score,
							 team_mask,
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_friendly_base_influencer_score_curve) );

	self.spawn_influencer_enemy = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_enemy_base_influencer_radius,
							 ctf_enemy_base_influencer_score,
							 other_team_mask,
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_enemy_base_influencer_score_curve) );
}


/*
** returns the flag carrier of the team "pTeam"
*/
GetTeamFlagCarrier( pTeam )
{
  flagCarrier = undefined;
  isFlagCarrier = false;
  n = 0;
  
  while (!isFlagCarrier && n < level.players.size) {

    if ( isdefined(level.players[n].isFlagCarrier) && level.players[n].isFlagCarrier && level.players[n].team == pTeam) {
      isFlagCarrier = true;
      flagCarrier = level.players[n];
    }
    n++;
  }
  return flagCarrier;
}



/*
=============
monitorFlagCarrier

Monitors the flag carrier to displays the KILL icon in case the flag carrier is camping
=============
*/
monitorFlagCarrier( flagCarrier )
{
	level endon( self.ownerTeam + "_flag_dropped" );
	level endon( self.ownerTeam + "_flag_captured" );	
	level endon( self.ownerTeam + "_flag_returned" );	
	flagCarrier endon("disconnect");
	flagCarrier endon("death");	
	
	playerTeam = flagCarrier.pers["team"];

	// Check if we just have to show the KILL icon after certain time
	if ( level.scr_ctf_show_flag_carrier_time > 0 && level.scr_ctf_show_flag_carrier_distance == 0 ) {
		// Wait the time
		xWait( level.scr_ctf_show_flag_carrier_time );

		// Show the KILL icon
		flagCarrier playLocalSound( game["voice"][flagCarrier.pers["team"]] + "new_positions" );
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		if ( playerTeam != self.ownerTeam ) {
			self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_target" );
			self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_kill" );
		} else {
			self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
			self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_kill" );			
		}

		return;
	}

	// Monitor that the player is moving certain amount of distance in a given time or show him on the radar
	oldPlayerPosition = flagCarrier.origin;
	for (;;)
	{
		// Wait for the given time
		xWait( level.scr_ctf_show_flag_carrier_time );

		// Get the distance and update the current's player position
		distanceMoved = distance( oldPlayerPosition, flagCarrier.origin );

		// Check if the player has moved enough distance
		if ( distanceMoved < level.scr_ctf_show_flag_carrier_distance ) {

			// Show the player in the enemies radar for 2 seconds
			flagCarrier playLocalSound( game["voice"][flagCarrier.pers["team"]] + "new_positions" );
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
			if ( playerTeam != self.ownerTeam ) {
				self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_target" );
				self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_kill" );
			} else {
				self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
				self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_kill" );				
			}

			xWait( 5 );

			// Disable the KILL icon
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
			if ( playerTeam != self.ownerTeam ) {
				self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
				self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
			} else {
				self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
				self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
			}				
		}

		// Get the player's current position and start waiting again for the next check
		oldPlayerPosition = flagCarrier.origin;
	}
}