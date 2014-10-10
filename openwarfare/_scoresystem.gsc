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

/*
** KNOWN ISSUES:
** - the death of a player driving the tank will always have the MOD of the 
**   weapon used by the attacker. The MOD is set before the tank blows off.
**   Any idea how to catch the trigger before?
**
** REMARKS:
** to save dvars the following scores will not be published but will
** still kept in the sources:
**   scr_score_bayonet_kill -> same as scr_score_melee_kill
**   scr_score_tank_mg_kill -> same as scr_score_standard_kill
**   scr_score_tank_explosion_kill -> same as scr_score_vehicle_explosion_kill
**   scr_score_dogassist -> same as scr_score_assist_kill
*/

init()
{  
  if ( level.teamBased )
    {
      vKill      = 10;
      vAssist_75 = 8;
      vAssist_50 = 6;
      vAssist_25 = 4;
      vAssist    = 2;
      vDogKill   = 3;
      vDogAssist = 1;
    }
  else
    {
      vKill      = 5;
      vAssist_75 = 0;
      vAssist_50 = 0;
      vAssist_25 = 0;
      vAssist    = 0;
      vDogKill   = 2;
      vDogAssist = 0;
    }

  vWin         = 1.0;
  vLoss        = 0.5;
  vTie         = 0.75;
  vCapture     = 30;
  vDefend      = 30;
  vDefendAss   = 1;
  vPlant       = 20;
  vDefuse      = 15;
  vTake        = 7;
  vHolding     = 5;
  vAssault     = 5;
  vAssaultAss  = 1;
  vKillCarrier = 5;

  level.scr_enable_scoresystem = getdvarx("scr_enable_scoresystem", "int", 0, 0, 1);

  // if the scoring system is enabled, read the dvars otherwise use the standard scores 
  // and ignore possible set dvars
  if (level.scr_enable_scoresystem == 1)
    {
      // general settings
      scr_score_hardpoint_used    = getdvarx("scr_score_hardpoint_used", "int", 10, 0, 50);

      // types of kills
      scr_score_standard_kill = getdvarx("scr_score_standard_kill", "int", vKill, 0, 50);
      scr_score_headshot_kill = getdvarx("scr_score_headshot_kill", "int", vKill, 0, 50);
      scr_score_assist_75_kill = getdvarx("scr_score_assist_75_kill", "int",  vAssist_75, 0, 10);
      scr_score_assist_50_kill = getdvarx("scr_score_assist_50_kill", "int",  vAssist_50, 0, 10);
      scr_score_assist_25_kill = getdvarx("scr_score_assist_25_kill", "int",  vAssist_25, 0, 10);
      scr_score_assist_kill = getdvarx("scr_score_assist_kill", "int",  vAssist, 0, 10);
      scr_score_melee_kill = getdvarx("scr_score_melee_kill", "int", vKill, 0, 50);
      scr_score_grenade_kill = getdvarx("scr_score_grenade_kill", "int", vKill, 0, 50);
      scr_score_tank_grenade_kill = getdvarx("scr_score_tank_grenade_kill", "int", vKill, 0, 50);
      scr_score_knock_over_kill = getdvarx("scr_score_knock_over_kill", "int",  vKill, 0, 50);
      scr_score_vehicle_explosion_kill = getdvarx("scr_score_vehicle_explosion_kill", "int", vKill, 0, 50);
      scr_score_barrel_explosion_kill = getdvarx("scr_score_barrel_explosion_kill", "int", vKill, 0, 50);
      scr_score_satchel_kill = getdvarx("scr_score_satchel_kill", "int", vKill, 0, 50);
      scr_score_betty_kill = getdvarx("scr_score_betty_kill", "int", vKill, 0, 50);
      scr_score_rpg_kill = getdvarx("scr_score_rpg_kill", "int", vKill, 0, 50);
      scr_score_grenade_launcher_kill = getdvarx("scr_score_grenade_launcher_kill", "int", vKill, 0, 50);
      scr_score_flamethrower_kill = getdvarx("scr_score_flamethrower_kill", "int", vKill, 0, 50);
      scr_score_artillery_kill = getdvarx("scr_score_artillery_kill", "int", vKill, 0, 50);
      scr_score_dog_kill = getdvarx("scr_score_dog_kill", "int",  vDogKill, 0, 50);

      scr_score_tank_mg_kill = scr_score_standard_kill;
      scr_score_bayonet_kill = scr_score_melee_kill;
      scr_score_dogassist = scr_score_assist_kill;
      scr_score_tank_explosion_kill = scr_score_vehicle_explosion_kill;

      // penalties
      scr_score_player_death = getdvarx("scr_score_player_death", "int", 0, -50, 0);
      scr_score_player_suicide = getdvarx("scr_score_player_suicide", "int", 0, -50, 0);
      level.scr_score_tk_affects_teamscore = getdvarx("scr_score_tk_affects_teamscore", "int", 0, 0, 1);
      scr_score_player_teamkill = getdvarx("scr_score_player_teamkill", "int", 0, -50, 0);

      // gametypes
      scr_score_capture_objective = getdvarx("scr_score_capture_objective", "int", 30, 0, 100);
      scr_score_take_objective = getdvarx("scr_score_take_objective", "int", 7, 0, 100);
      scr_score_return_objective = getdvarx("scr_score_return_objective", "int", 7, 0, 100);
      scr_score_defend_objective = getdvarx("scr_score_defend_objective", "int", 30, 0, 100);
      scr_score_carrier_assist_objective = getdvarx("scr_score_carrier_assist_objective", "int", 15, 0, 100);
      scr_score_holding_objective = getdvarx("scr_score_holding_objective", "int", 5, 0, 100);
      scr_score_kill_objective_carrier = getdvarx("scr_score_kill_objective_carrier", "int", 5, 0, 100);
      scr_score_assault_objective = getdvarx("scr_score_assault_objective", "int", 5, 0, 100);
      scr_score_plant_bomb = getdvarx("scr_score_plant_bomb", "int", 20, 0, 100);
      scr_score_defuse_bomb = getdvarx("scr_score_defuse_bomb", "int", 15, 0, 100);

      if (level.gametype == "sd" || level.gametype == "re" )
	{
	  scr_score_win = 2.0;
	  scr_score_loss = 1.0;
	  scr_score_tie = 1.5;
	}
      else
	{
	  scr_score_win = 1.0;
	  scr_score_loss = 0.5;
	  scr_score_tie = 0.75;
	}
    }
  else
    {
      // we need to handle special scores for every gametype :(
      switch (level.gametype)
	{
	case "ch":
	  vKill        = 5; //headshot = vKill
	  vAssist      = 1;
	  vAssist_75   = vAssist;
	  vAssist_50   = vAssist;
	  vAssist_25   = vAssist;
	  vTake        = 5;
	  vHolding     = 5;
	  vDefend      = 2;
	  vKillCarrier = 5;
	  break;
	case "ctf":
	  vCapture     = 50;
	  vDefend      = 10;
	  vKillCarrier = 10;
	  break;
	case "dm":
	case "lms":
	  vKill        = 5; //headshot = vKill
	  vAssist      = 1;
	  vAssist_75   = vAssist;
	  vAssist_50   = vAssist;
	  vAssist_25   = vAssist;
	  vSuicide     = 0;
	  vTeamkill    = 0;
	  break;
	case "dom":
	  vKill        = 5; //headshot = vKill
	  vAssist_75   = 4;
	  vAssist_50   = 3;
	  vAssist_25   = 2;
	  vAssist      = 1;
	  vCapture     = 15;
	  vDefend      = 5;
	  vAssault     = 5;
	  break;
	case "koth":
	  vKill        = 5; //headshot = vKill
	  vAssist_75   = 4;
	  vAssist_50   = 3;
	  vAssist_25   = 2;
	  vAssist      = 1;
	  vCapture     = 15;
	  vDefend      = 5;
	  vAssault     = 5;	  
	  break;
	case "sab":
	  vPlant       = 20;
	  vDefuse      = 15;
	  break;
	case "sd":
	case "re":
	  vWin         = 2.0;
	  vLoss        = 1.0;
	  vTie         = 1.5;
	  vKill        = 50; //headshot = vKill
	  vPlant       = 100;
	  vDefuse      = 100;
	  vAssist_75   = 25;
	  vAssist_50   = 25;
	  vAssist_25   = 25;
	  vAssist      = 25;
	  break;
	case "sur":
	  vKill        = 5; //headshot = vKill
	  vDefend      = 5;
	  vAssault     = 5;
	  vCapture     = 15;
	  vAssist_75   = 4;
	  vAssist_50   = 3;
	  vAssist_25   = 2;
	  vAssist      = 1;
	  break;
	case "twar":
	  vKill        = 5; //headshot = vKill
	  vAssist_75   = 4;
	  vAssist_50   = 3;
	  vAssist_25   = 2;
	  vAssist      = 1;
	  vCapture     = 30;
	  vDefend      = 0;
	  vDefendAss   = 0;
	  vAssault     = 5;
	  vAssaultAss  = 1;
	  break;
	default:
	  break;
	} // switch

      scr_game_deathpointloss    = getdvarx("scr_game_deathpointloss", "int", 0, 0, 1);
      scr_game_suicidepointloss  = getdvarx("scr_game_suicidepointloss", "int", 0, 0, 1);
      scr_team_teamkillpointloss = getdvarx("scr_team_teamkillpointloss", "int", 0, 0, 1);

      // general settings
      scr_score_hardpoint_used    = 10;

      // types of kills
      scr_score_standard_kill = vKill;
      scr_score_headshot_kill = vKill;
      scr_score_assist_75_kill = vAssist_75;
      scr_score_assist_50_kill = vAssist_50;
      scr_score_assist_25_kill = vAssist_25;
      scr_score_assist_kill = vAssist;
      scr_score_melee_kill = vKill;
      scr_score_bayonet_kill = vKill;
      scr_score_grenade_kill = vKill;
      scr_score_tank_grenade_kill = vKill;
      scr_score_tank_mg_kill = vKill;
      scr_score_knock_over_kill = vKill;
      scr_score_vehicle_explosion_kill = vKill;
      scr_score_tank_explosion_kill = vKill;
      scr_score_barrel_explosion_kill = vKill;
      scr_score_satchel_kill = vKill;
      scr_score_betty_kill = vKill;
      scr_score_rpg_kill = vKill;
      scr_score_grenade_launcher_kill = vKill;
      scr_score_flamethrower_kill = vKill;
      scr_score_artillery_kill = vKill;
      scr_score_dog_kill = vDogKill;
      scr_score_dogassist = vDogAssist;

      // penalties
      if (scr_game_deathpointloss == 1)
	scr_score_player_death = vKill * -1;
      else
	scr_score_player_death = 0;

      if ((scr_game_suicidepointloss == 1) && (level.gametype != "dm"))
	scr_score_player_suicide = vKill * -1;
      else
	scr_score_player_suicide = 0;

      if ((scr_team_teamkillpointloss == 1) && (level.gametype != "dm"))
	scr_score_player_teamkill = vKill * -1;
      else
	scr_score_player_teamkill = 0;

      level.scr_score_tk_affects_teamscore = 0;

      // gametypes
      scr_score_capture_objective = vCapture;
      scr_score_take_objective = vTake;
      scr_score_return_objective = 7;
      scr_score_defend_objective = vDefend;
      scr_score_carrier_assist_objective = 0;
      scr_score_holding_objective = vHolding;
      scr_score_kill_objective_carrier = vKillCarrier;
      scr_score_assault_objective = vAssault;
      scr_score_plant_bomb = vPlant;
      scr_score_defuse_bomb = vDefuse;

      scr_score_win = vWin;
      scr_score_loss = vLoss;
      scr_score_tie = vTie;
    }

  // general settings
  maps\mp\gametypes\_rank::registerScoreInfo( "hardpoint", scr_score_hardpoint_used );

  // types of kills
  maps\mp\gametypes\_rank::registerScoreInfo( "kill", scr_score_standard_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "headshot", scr_score_headshot_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", scr_score_assist_75_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", scr_score_assist_50_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", scr_score_assist_25_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "assist", scr_score_assist_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "melee", scr_score_melee_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "bayonet", scr_score_bayonet_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "blast", scr_score_grenade_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "tankgrenade", scr_score_tank_grenade_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "vehicleblast", scr_score_vehicle_explosion_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "tankblast", scr_score_tank_explosion_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "barrelblast", scr_score_barrel_explosion_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "satchelblast", scr_score_satchel_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "bettyblast", scr_score_betty_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "rpgblast", scr_score_rpg_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "launcher", scr_score_grenade_launcher_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "flamethrower", scr_score_flamethrower_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "tank_mg", scr_score_tank_mg_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "knockover", scr_score_knock_over_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "artillery", scr_score_artillery_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "dogkill", scr_score_dog_kill );
  maps\mp\gametypes\_rank::registerScoreInfo( "dogassist", scr_score_dogassist );

  // penalties
  maps\mp\gametypes\_rank::registerScoreInfo( "death", scr_score_player_death );  	
  maps\mp\gametypes\_rank::registerScoreInfo( "suicide", scr_score_player_suicide );	
  maps\mp\gametypes\_rank::registerScoreInfo( "teamkill", scr_score_player_teamkill );	

  // the different gametypes 
  maps\mp\gametypes\_rank::registerScoreInfo( "capture",  scr_score_capture_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "take", scr_score_take_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "return", scr_score_return_objective);
  maps\mp\gametypes\_rank::registerScoreInfo( "defend", scr_score_defend_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "defend_assist", vDefendAss );
  maps\mp\gametypes\_rank::registerScoreInfo( "carrier_assist", scr_score_carrier_assist_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "assault", scr_score_assault_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "assault_assist", vAssaultAss );
  maps\mp\gametypes\_rank::registerScoreInfo( "holding", scr_score_holding_objective );
  maps\mp\gametypes\_rank::registerScoreInfo( "killcarrier", scr_score_kill_objective_carrier );
  maps\mp\gametypes\_rank::registerScoreInfo( "plant", scr_score_plant_bomb );
  maps\mp\gametypes\_rank::registerScoreInfo( "defuse", scr_score_defuse_bomb );

  maps\mp\gametypes\_rank::registerScoreInfo( "win", scr_score_win );
  maps\mp\gametypes\_rank::registerScoreInfo( "loss", scr_score_loss );
  maps\mp\gametypes\_rank::registerScoreInfo( "tie", scr_score_tie );
  maps\mp\gametypes\_rank::registerScoreInfo( "challenge", 250 );

  return;
}

getPointsForKill( pMeansOfDeath, pWeapon, pAttacker)
{
  scoreInfo = [];
  scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
  scoreInfo["type"] = "kill";

  if ( pMeansOfDeath == "MOD_HEAD_SHOT" ) 
    {
      pAttacker  maps\mp\gametypes\_globallogic::incPersStat( "headshots", 1 );
      pAttacker.headshots = pAttacker  maps\mp\gametypes\_globallogic::getPersStat( "headshots" );
      
      if ( isDefined( pAttacker.lastStand ) )
	scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) * 2;
      else
	scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" );
      
      if ( level.scr_play_headshot_impact_sound == 1 )
      	pAttacker playLocalSound( "bullet_impact_headshot_2" );
      	
      scoreInfo["type"] = "headshot";
    }
  else if (( pMeansOfDeath == "MOD_RIFLE_BULLET" ) && issubstr( pWeapon, "gunner_front_mp" ))
    {
      // tank coaxial mg
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "tank_mg" );
      scoreInfo["type"] = "tank_mg";
    }
  else if ( pMeansOfDeath == "MOD_MELEE" )
    {
      // melee
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "melee" );
      scoreInfo["type"] = "melee";
    }
  else if ( pMeansOfDeath == "MOD_BAYONET" )
    {
      // bayonet
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "bayonet" );
      scoreInfo["type"] = "bayonet";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_GRENADE" ) && issubstr( pWeapon, "grenade_mp" ))
    {
      // frag and sticky nades
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "blast" );
      scoreInfo["type"] = "blast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_GRENADE" ) && pWeapon == "molotov_mp")
    {
      // molotov -> no special handling so far
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "blast" );
      scoreInfo["type"] = "blast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_PROJECTILE" ) && issubstr( pWeapon, "turret_mp" ))
    {
      // tank grenade
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "tankgrenade" );
      scoreInfo["type"] = "tankgrenade";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_CRUSH" ) && issubstr( pWeapon, "turret_mp" ))
    {
      // tank knocking over someone
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "knockover" );
      scoreInfo["type"] = "knockover";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_GRENADE" ) && pWeapon == "satchel_charge_mp")
    {
      // satchel charge
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "satchelblast" );
      scoreInfo["type"] = "satchelblast";
    }
  else if (( issubstr( pMeansOfDeath, "MOD_GRENADE" ) && pWeapon == "mine_bouncing_betty_mp"))
    {
      // bouncing betty
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "bettyblast" );
      scoreInfo["type"] = "bettyblast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_GRENADE" ) && issubstr( pWeapon, "gl_"))
    {
      // grenade launcher
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "launcher" );
      scoreInfo["type"] = "launcher";
    }
  else if (( issubstr( pMeansOfDeath, "MOD_EXPLOSIVE" ) && pWeapon == "destructible_car" ))
    {
      // exploding vehicles
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "vehicleblast" );
      scoreInfo["type"] = "vehicleblast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_EXPLOSIVE" ) && issubstr(pWeapon,"mp_explosion_mp"))
    {
      // exploding tank
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "tankblast" );
      scoreInfo["type"] = "tankblast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_EXPLOSIVE" ) && pWeapon == "explodable_barrel" )
    {
      // exploding barrel
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "barrelblast" );
      scoreInfo["type"] = "barrelblast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_PROJECTILE" ) && pWeapon == "bazooka_mp")
    {
      // bazooka
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "rpgblast" );
      scoreInfo["type"] = "rpgblast";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_PISTOL_BULLET" ) && pWeapon == "dog_bite_mp")
    {
      // dogbite
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "dogkill" );
      scoreInfo["type"] = "dogkill";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_PROJECTILE" ) && pWeapon == "artillery_mp")
    {
      // artillery
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "artillery" );
      scoreInfo["type"] = "artillery";
    }
  else if ( issubstr( pMeansOfDeath, "MOD_BURNED" ) && pWeapon == "m2_flamethrower_mp")
    {
      // flamethrower
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "flamethrower" );
      scoreInfo["type"] = "flamethrower";
    }
  else
    {
      // just to be sure
      scoreInfo["score"] = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
      if ( isDefined( pAttacker.lastStand ) )
	scoreInfo["score"] = scoreInfo["score"] * 2;
    }
  return scoreInfo;
}


