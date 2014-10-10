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
	level.scr_dynamic_attachments_enable = getdvarx( "scr_dynamic_attachments_enable", "int", 0, 0, 2 );

	// If dynamic attachments is disabled there's nothing else to do here
	if ( level.scr_dynamic_attachments_enable == 0 )
		return;
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );	
}


onPlayerConnected()
{
	self thread addNewEvent( "onPlayerSpawned", ::onPlayerSpawned );
}	


onPlayerSpawned()
{
	self.attachmentPocket = "";
	self.attachmentAction = false;
}


attachDetachAttachment()
{
	self endon("disconnect");
	self endon("death");
	level endon( "game_ended" );

	// Make sure this module is active
	if ( level.scr_dynamic_attachments_enable == 0 || !isAlive(self) )
		return;
	
	// Make sure the current weapon supports an attach/detach action
	currentWeapon = self getCurrentWeapon();
	detachmentAction = validForDetachmentAction( currentWeapon );
	attachmentAction = validForAttachmentAction( currentWeapon, self.attachmentPocket );
	if ( detachmentAction != "" || attachmentAction ) {
		// Initiate attaching/detaching action. If there's already another action running we'll cancel the request
		if ( self.attachmentAction ) {
			return;
		} else {
			self.attachmentAction = true;
		}
		
		// Get the ammo info for the current weapon
		totalAmmo = self getAmmoCount( currentWeapon );
		clipAmmo = self getWeaponAmmoClip( currentWeapon );
		
		// Disable the player's weapons
		self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
				
		// Wait for certain time to complete the requested action
		self playLocalSound( "scramble" );
		xWait (3);
		
		// Take the current weapon from the player
		self takeWeapon( currentWeapon );
		
		// Check which weapon we should give in exchange
		if ( detachmentAction != "" ) {
			// Construct the name of the weapon without the attachment
			newWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - detachmentAction.size - 2 ) + "_mp";
			self.attachmentPocket = detachmentAction;
			
		} else {
			// Construct the name of the weapon with the attachment
			newWeapon = getSubStr( currentWeapon, 0, currentWeapon.size - 3 ) + self.attachmentPocket + "mp";
			self.attachmentPocket = "";				
		}
		self giveWeapon( newWeapon );
			
		// Assign the proper ammo again
		self setWeaponAmmoClip( newWeapon, clipAmmo );
		self setWeaponAmmoStock( newWeapon, totalAmmo - clipAmmo );
		
		self switchToWeapon( newWeapon );
		self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
		self.attachmentAction = false;		
	}	
}


validForDetachmentAction( currentWeapon )
{
	// Check if the current weapon is valid for detachment
	if ( isSubStr( currentWeapon, "_bayonet_" ) ) {
		return "_bayonet_";
	}  
	else {
		return "";
	}
}


validForAttachmentAction( currentWeapon, playerPocket )
{
	// Check if the current weapon is valid for the attachment that the player has in his pocket
	if ( playerPocket != "" ) {
		if ( playerPocket == "_bayonet_" ) {
			if ( isSubStr( "kar98k_mp;m1carbine_mp;m1garand_mp;mosinrifle_mp;shotgun_mp;springfield_mp;type99lmg_mp;type99rifle_mp", currentWeapon ) ) {
				return true;
			}			
		}	
	}
	
	return false;	
}