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

init()
{
	game["menu_clientcmd"] = "clientcmd";
		
	// OpenWarfare
	precacheMenu( game["menu_clientcmd"] );

	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self thread onMenuResponse();
}

onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "menuresponse", menu, response);
		
		if( menu == "-1" )
		{
			switch( response )
			{
				case "zoomin":
					self thread openwarfare\_sniperzoom::zoomIn();
					break;
					
				case "zoomout":
					self thread openwarfare\_sniperzoom::zoomOut();
					break;
					
				case "changeclass":
					self openMenu( game[ "menu_changeclass_" + self.pers["team"] ] );
					break;

				case "attachdetach":
					self thread openwarfare\_dynamicattachments::attachDetachAttachment();
					break;	
					
				case "objectdrop":
					if ( isDefined( self.carryObject ) ) {
						self.carryObject thread maps\mp\gametypes\_gameobjects::setDropped();
						if ( level.gametype == "sd" )
							self.isBombCarrier = false;
						self thread maps\mp\gametypes\_gameobjects::pickupObjectDelayTime( 3.0 );
					}
					break;
					
				case "weapondrop":
					if ( level.gametype != "gg" ) {
						self thread openwarfare\_utils::weaponDrop();
					}
					break;
					
				case "bandage":
					if ( isDefined( self.isBleeding ) && self.isBleeding )
					self thread openwarfare\_healthsystem::bandageSelf();
					else if ( isDefined( self.ankleBroken ) && self.ankleBroken  && !self.isBleeding )
					self thread openwarfare\_healthsystem::splintSelf();
					else
					self thread openwarfare\_healthsystem::medic(); 
					break;	
									
				case "unjam":
					self thread openwarfare\_weaponjam::unjamWeapon();
					break;	
									
				case "calltimeout":
					self thread openwarfare\_timeout::timeoutCalled();
					break;

				case "redirect":
					self thread openwarfare\_reservedslots::disconnectPlayer( true );
					break;					
										
				case "cyclefpslag":
					self thread openwarfare\_cyclefpslag::cycleFPSLagometer();
					break;		

				case "togglestats":
					if ( level.scr_realtime_stats_enable == 1 ) {
						self.pers["stats"]["show"] = !self.pers["stats"]["show"];
						self setClientDvar( "ui_hud_showstats", self.pers["stats"]["show"] );
						self playLocalSound( "mouse_click" );
					}
					break;	
										
				case "advancedacp":
					if ( level.scr_aacp_enable == 1 ) {
						if ( isDefined( self.aacpAccess ) && self.aacpAccess != "" ) {
							self openMenu( "advancedacp" );
						} else {
							self iprintln( &"OW_AACP_NOACCESS", self getGUID() );
						}
					} else {
						self iprintln( &"OW_AACP_NOTENABLED" );
					}
					break;
				
				case "togglefiremode":
					self thread openwarfare\_weaponfiremode::toggleFireMode();
					break;	
													
				default:
					break;
			}
			continue;
		}
	}
}