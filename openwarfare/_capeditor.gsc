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
#include openwarfare\_eventmanager;

init()
{
	level.scr_cap_enable = getdvarx( "scr_cap_enable", "int", 0, 0, 1 ); 
	level.scr_cap_time = getdvarx( "scr_cap_time", "float", 5.0, 0.0, 15.0 );
	level.scr_cap_activated = getdvarx( "scr_cap_time_activated", "float", 15.0, 5.0, 30.0 );
	level.scr_cap_firstspawn = getdvarx( "scr_cap_firstspawn", "int", 0, 0, 1 );
	
	if ( !level.scr_cap_enable || level.gametype == "ass" )
		return;
	
	initializeModelsArray();
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

initializeModelsArray()
{
	//Allies
	if ( game["allies_soldiertype"] == "german" )
	{
		game["cap_allies_model"]["function"][0] = mptype\mptype_rus_guard_assault::main;
		game["cap_allies_model"]["body_model"][0] = "char_rus_guard_player_body_assault";
		game["cap_neutral_model"]["function"][0] = mptype\mptype_rus_guard_assault::main;
		game["cap_neutral_model"]["body_model"][0] = "char_rus_guard_player_body_assault";
		
		game["cap_allies_model"]["function"][1] = mptype\mptype_rus_guard_smg::main;
		game["cap_allies_model"]["body_model"][1] = "char_rus_guard_player_body_smg";
		game["cap_neutral_model"]["function"][1] = mptype\mptype_rus_guard_smg::main;
		game["cap_neutral_model"]["body_model"][1] = "char_rus_guard_player_body_smg";
		
		game["cap_allies_model"]["function"][2] = mptype\mptype_rus_guard_lmg::main;
		game["cap_allies_model"]["body_model"][2] = "char_rus_guard_player_body_lmg";
		game["cap_neutral_model"]["function"][2] = mptype\mptype_rus_guard_lmg::main;
		game["cap_neutral_model"]["body_model"][2] = "char_rus_guard_player_body_lmg";
		
		game["cap_allies_model"]["function"][3] = mptype\mptype_rus_guard_cqb::main; 
		game["cap_allies_model"]["body_model"][3] = "char_rus_guard_player_body_cqb";
		game["cap_neutral_model"]["function"][3] = mptype\mptype_rus_guard_cqb::main; 
		game["cap_neutral_model"]["body_model"][3] = "char_rus_guard_player_body_cqb";
		
		game["cap_allies_model"]["function"][4] = mptype\mptype_rus_guard_rifle::main;
		game["cap_allies_model"]["body_model"][4] = "char_rus_guard_player_body_rifle";
		game["cap_neutral_model"]["function"][4] = mptype\mptype_rus_guard_rifle::main;
		game["cap_neutral_model"]["body_model"][4] = "char_rus_guard_player_body_rifle";
	}
	else 
	{
		game["cap_allies_model"]["function"][0] = mptype\mptype_usa_raider_assault::main;
		game["cap_allies_model"]["body_model"][0] = "char_usa_raider_player_body_assault";
		game["cap_neutral_model"]["function"][0] = mptype\mptype_usa_raider_assault::main;
		game["cap_neutral_model"]["body_model"][0] = "char_usa_raider_player_body_assault";
		
		game["cap_allies_model"]["function"][1] = mptype\mptype_usa_raider_smg::main;
		game["cap_allies_model"]["body_model"][1] = "char_usa_raider_player_body_smg";
		game["cap_neutral_model"]["function"][1] = mptype\mptype_usa_raider_smg::main;
		game["cap_neutral_model"]["body_model"][1] = "char_usa_raider_player_body_smg";
		
		game["cap_allies_model"]["function"][2] = mptype\mptype_usa_raider_lmg::main;
		game["cap_allies_model"]["body_model"][2] = "char_usa_raider_player_body_lmg";
		game["cap_neutral_model"]["function"][2] = mptype\mptype_usa_raider_lmg::main;
		game["cap_neutral_model"]["body_model"][2] = "char_usa_raider_player_body_lmg";
		
		game["cap_allies_model"]["function"][3] = mptype\mptype_usa_raider_cqb::main; 
		game["cap_allies_model"]["body_model"][3] = "char_usa_raider_player_body_cqb";
		game["cap_neutral_model"]["function"][3] = mptype\mptype_usa_raider_cqb::main; 
		game["cap_neutral_model"]["body_model"][3] = "char_usa_raider_player_body_cqb";
		
		game["cap_allies_model"]["function"][4] = mptype\mptype_usa_raider_rifle::main;
		game["cap_allies_model"]["body_model"][4] = "char_usa_raider_player_body_rifle";
		game["cap_neutral_model"]["function"][4] = mptype\mptype_usa_raider_rifle::main;
		game["cap_neutral_model"]["body_model"][4] = "char_usa_raider_player_body_rifle";
	}
	
	//Opfor
	if ( game["axis_soldiertype"] == "german" )
	{
		game["cap_axis_model"]["function"][0] = mptype\mptype_ger_hnrgrd_assault::main;
		game["cap_axis_model"]["body_model"][0] = "char_ger_hnrgd_player_body_assault";
		game["cap_neutral_model"]["function"][5] = mptype\mptype_ger_hnrgrd_assault::main;
		game["cap_neutral_model"]["body_model"][5] = "char_ger_hnrgd_player_body_assault";
		
		game["cap_axis_model"]["function"][1] = mptype\mptype_ger_hnrgrd_smg::main;
		game["cap_axis_model"]["body_model"][1] = "char_ger_hnrgd_player_body_smg";
		game["cap_neutral_model"]["function"][6] = mptype\mptype_ger_hnrgrd_smg::main;
		game["cap_neutral_model"]["body_model"][6] = "char_ger_hnrgd_player_body_smg";
		
		game["cap_axis_model"]["function"][2] = mptype\mptype_ger_hnrgrd_lmg::main;
		game["cap_axis_model"]["body_model"][2] = "char_ger_hnrgd_player_body_lmg";
		game["cap_neutral_model"]["function"][7] = mptype\mptype_ger_hnrgrd_lmg::main;
		game["cap_neutral_model"]["body_model"][7] = "char_ger_hnrgd_player_body_lmg";
		
		game["cap_axis_model"]["function"][3] = mptype\mptype_ger_hnrgrd_cqb::main;
		game["cap_axis_model"]["body_model"][3] = "char_ger_hnrgd_player_body_cqb";
		game["cap_neutral_model"]["function"][8] = mptype\mptype_ger_hnrgrd_cqb::main;
		game["cap_neutral_model"]["body_model"][8] = "char_ger_hnrgd_player_body_cqb";
		
		game["cap_axis_model"]["function"][4] = mptype\mptype_ger_hnrgrd_rifle::main;
		game["cap_axis_model"]["body_model"][4] = "char_ger_hnrgd_player_body_rifle";
		game["cap_neutral_model"]["function"][9] = mptype\mptype_ger_hnrgrd_rifle::main;
		game["cap_neutral_model"]["body_model"][9] = "char_ger_hnrgd_player_body_rifle";
	}
	else
	{
		game["cap_axis_model"]["function"][0] = mptype\mptype_jap_impinf_assault::main;
		game["cap_axis_model"]["body_model"][0] = "char_jap_impinf_player_body_assault";
		game["cap_neutral_model"]["function"][5] = mptype\mptype_jap_impinf_assault::main;
		game["cap_neutral_model"]["body_model"][5] = "char_jap_impinf_player_body_assault";
		
		game["cap_axis_model"]["function"][1] = mptype\mptype_jap_impinf_smg::main;
		game["cap_axis_model"]["body_model"][1] = "char_jap_impinf_player_body_smg";
		game["cap_neutral_model"]["function"][6] = mptype\mptype_jap_impinf_smg::main;
		game["cap_neutral_model"]["body_model"][6] = "char_jap_impinf_player_body_smg";
		
		game["cap_axis_model"]["function"][2] = mptype\mptype_jap_impinf_lmg::main;
		game["cap_axis_model"]["body_model"][2] = "char_jap_impinf_player_body_lmg";
		game["cap_neutral_model"]["function"][7] = mptype\mptype_jap_impinf_lmg::main;
		game["cap_neutral_model"]["body_model"][7] = "char_jap_impinf_player_body_lmg";
		
		game["cap_axis_model"]["function"][3] = mptype\mptype_jap_impinf_cqb::main;
		game["cap_axis_model"]["body_model"][3] = "char_jap_impinf_player_body_cqb";
		game["cap_neutral_model"]["function"][8] = mptype\mptype_jap_impinf_cqb::main;
		game["cap_neutral_model"]["body_model"][8] = "char_jap_impinf_player_body_cqb";
		
		game["cap_axis_model"]["function"][4] = mptype\mptype_jap_impinf_rifle::main;
		game["cap_axis_model"]["body_model"][4]= "char_jap_impinf_player_body_rifle";
		game["cap_neutral_model"]["function"][9] = mptype\mptype_jap_impinf_rifle::main;
		game["cap_neutral_model"]["body_model"][9] = "char_jap_impinf_player_body_rifle";
	}
}

onPlayerConnected()
{
	if ( level.scr_cap_firstspawn && !isDefined( self.pers["spawned_once"] ) )
		self.pers["spawned_once"] = false;
		
	self.isInCAP = false;
	
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
	self thread addNewEvent( "onPlayerKilled", ::onPlayerKilled );
}

onPlayerSpawned()
{		
	if ( level.inReadyUpPeriod )
		return;
		
	self.cap_protected = false;
		
	self checkAndChangeModel();
	if ( !isDefined( self.pers["isBot"] ) || ( isDefined( self.pers["isBot"] ) && self.pers["isBot"] == false ) )
	{
		if ( ( level.scr_cap_firstspawn && ( isDefined( self.pers["spawned_once"] ) && self.pers["spawned_once"] == false ) ) || !level.scr_cap_firstspawn )
		{
			if ( level.scr_cap_firstspawn && isDefined( self.pers["spawned_once"] ) )
				self.pers["spawned_once"] = true;	
				
			if ( level.scr_player_forcerespawn == 0 )
				xWait(2);	
			
			self setClientDvar( "cap_enable", "true" );			
			self thread customizePlayer();
		}	
	}
}

onPlayerKilled()
{
	self.isInCAP = false;
	
	if ( level.scr_thirdperson_enable )
		self setClientDvars( "cg_thirdPerson", "1", "cg_thirdPersonAngle", "360", "cg_thirdPersonRange", "72", "cap_enable", "false" );
	else
		self setClientDvars( "cg_thirdPerson", "0", "cg_thirdPersonAngle", "0", "cg_thirdPersonRange", "120", "cap_enable", "false" );
}

checkAndChangeModel()
{
	if ( isDefined( self.pers["current_body_model"] ) )
	{
		self.isHeadOff = false;
		//Detach Head Model (Original snip of script by BionicNipple)
		count = self getattachsize();
		for ( index = 0; index < count; index++ )
		{
			head = self getattachmodelname( index );
		
			if ( isSubStr( head, "head" ) )
			{
				self detach( head );
				self.isHeadOff = true;
				break;
			}
		}
		
		if ( level.teamBased )
		{
			for ( index = 0; index < 5; index++ )
			{
				if ( game["cap_" + self.pers["team"] + "_model"]["body_model"][index] == self.pers["current_body_model"] )
				{
					self [[game["cap_" + self.pers["team"] + "_model"]["function"][index]]]();
					self.isHeadOff = false;
				}
			}
		}
		else
		{
			for ( index = 0; index < 10; index++ )
			{
				if ( game["cap_neutral_model"]["body_model"][index] == self.pers["current_body_model"] )
				{
					self [[game["cap_neutral_model"]["function"][index]]]();
					self.isHeadOff = false;
				}
			}
		}
		
		if ( self.isHeadOff ) //Something went wrong or dvar changed in game
		{
			//set player back to default
			self maps\mp\gametypes\_teams::playerModelForClass( self.pers["class"] );
		}
		
		if ( ( isDefined( level.scr_spawn_protection_invisible ) && level.scr_spawn_protection_invisible == 1 ) && isDefined( self.spawn_protected ) && self.spawn_protected )
			self hide();
	}
	return;
}

customizePlayer()
{
	self endon( "disconnect" );
	self endon( "death" );
		
	//Begin countdown before cap access expires
	passedTime = openwarfare\_timer::getTimePassed();
	maxTime = level.scr_cap_time * 1000;
	timeDifference = 0;
	
	//Display Interface Message
	self setClientDvar( "cap_info", "open" );
	
	while ( !self useButtonPressed() && timeDifference < maxTime )
	{
		timeDifference = openwarfare\_timer::getTimePassed() - passedTime;
		wait .01;
	}
	
	if ( timeDifference >= maxTime )
	{
		self setClientDvar( "cap_enable", "false" );	
		return;	
	}
	
	self setClientDvar( "cap_info", "init", "cap_enable", "true" );
	wait 1;
	
	self.isInCAP = true;
	
	if ( ( isDefined( level.scr_spawn_protection_invisible ) && level.scr_spawn_protection_invisible == 1 ) && isDefined( self.spawn_protected ) && self.spawn_protected )
		self show();

	self setClientDvars( "cg_thirdPerson", "1", "cg_thirdPersonAngle", "180", "cg_thirdPersonRange", "120" );
	
	self thread openwarfare\_speedcontrol::setModifierSpeed( "_capeditor", 100 );
	self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
	self thread maps\mp\gametypes\_gameobjects::_disableJump();
	self thread maps\mp\gametypes\_gameobjects::_disableSprint();

	self setClientDvar( "cap_info", "cycle_close" );
	//Find current model of player
	modelIndex = self getCurrentModelIndex();
	
	//How long player can be in CAP
	passedTime = openwarfare\_timer::getTimePassed();
	maxTime = level.scr_cap_activated * 1000;
	timeDifference = 0;
	
	while( !self meleeButtonPressed() && ( timeDifference < maxTime ) )
	{
		if ( !isDefined( self.cap_protected ) )
			self.cap_protected = true;	
			
		hudTimer = int( ( maxTime - timeDifference ) / 1000 );
		self setClientDvar( "cap_time", hudTimer );
			
		timeDifference = openwarfare\_timer::getTimePassed() - passedTime;
		if ( self useButtonPressed() )
		{
			//Detach Head Model (Original snip of script by BionicNipple)
			count = self getattachsize();
			for ( index = 0; index < count; index++ )
			{
				head = self getattachmodelname( index );
		
				if ( isSubStr( head, "head" ) )
				{
					self detach( head );
					break;
				}
			}
		
			if ( level.teamBased && ( modelIndex + 1 == 5 ) )
				modelIndex = 0;
			else if ( !level.teamBased && ( modelIndex + 1 == 10 ) )
				modelIndex = 0;
			else 
				modelIndex++;
			
			//Change player model
			if ( level.teamBased )
			{
				self [[game["cap_" + self.pers["team"] + "_model"]["function"][modelIndex]]]();
				self.pers["current_body_model"] = game["cap_" + self.pers["team"] + "_model"]["body_model"][modelIndex];
			}	
			else
			{
				self [[game["cap_neutral_model"]["function"][modelIndex]]]();
				self.pers["current_body_model"] = game["cap_neutral_model"]["body_model"][modelIndex];
			}
			
			wait .5;
		}
		wait .01;
	}
	
	self.cap_protected = false;
	
	if ( ( isDefined( level.scr_spawn_protection_invisible ) && level.scr_spawn_protection_invisible == 1 ) && isDefined( self.spawn_protected ) && self.spawn_protected )
		self hide();
	
	if ( level.scr_thirdperson_enable )
		self setClientDvars( "cg_thirdPerson", "1", "cg_thirdPersonAngle", "360", "cg_thirdPersonRange", "72", "cap_enable", "false" );
	else
		self setClientDvars( "cg_thirdPerson", "0", "cg_thirdPersonAngle", "0", "cg_thirdPersonRange", "120", "cap_enable", "false" );
	
	self thread openwarfare\_speedcontrol::setModifierSpeed( "_capeditor", 0 );
	self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
	self thread maps\mp\gametypes\_gameobjects::_enableJump();
	self thread maps\mp\gametypes\_gameobjects::_enableSprint();
		
	wait 1;
	
	self.isInCAP = false;	
}

getCurrentModelIndex()
{
	if ( level.teamBased )
	{
		for ( index = 0; index < 5; index++ )
		{
			if ( isDefined( self.pers["current_body_model"] ) && game["cap_" + self.pers["team"] + "_model"]["body_model"][index] == self.pers["current_body_model"] )
				return index;
			else if ( !isDefined( self.pers["current_body_model"] ) && game["cap_" + self.pers["team"] + "_model"]["body_model"][index] == self.model )
				return index;
		}
	}
	else
	{
		for ( index = 0; index < 10; index++ )
		{
			if ( isDefined( self.pers["current_body_model"] ) && game["cap_neutral_model"]["body_model"][index] == self.pers["current_body_model"] )
				return index;
			else if ( !isDefined( self.pers["current_body_model"] ) && game["cap_neutral_model"]["body_model"][index] == self.model )
				return index;
		}
	}
	
	return 0;
}

