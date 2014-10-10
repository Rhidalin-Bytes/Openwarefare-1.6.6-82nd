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
	game["menu_ow_cac_editor"] = "ow_cac_editor";
	precacheMenu( game["menu_ow_cac_editor"] );
	
	level thread addNewEvent( "onPlayerConnected", ::onPlayerConnected );
}

onPlayerConnected()
{
	self thread cacResponseHandler();
}

cacResponseHandler()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill( "menuresponse", menu, response );

		if ( menu == "class" && response == "ow_cac_editor" ) 
		{
			self openAllClasses();
			self initializeEditor();
			self openMenu( game["menu_ow_cac_editor"] );
		}
		
		if ( menu == game["menu_ow_cac_editor"] )
		{
			//Restart loop if custom classes aren't unlocked. 
			//The class can be unlocked in game so we still 
			//want to give player the ability to edit their class.
			if ( self getStat( 260 ) > 0 )
			{
				switch( response )
				{					
					case "cacClassNext":
						self class( "next" );
						break;
					case "cacClassPrev":
						self class( "prev" );
						break;					
					case "cacPrimaryNext":
						self primary( "next" );
						break;
					case "cacPrimaryPrev":
						self primary( "prev" );
						break;
					case "cacSecondaryNext":
						self secondary( "next" );
						break;
					case "cacSecondaryPrev":
						self secondary( "prev" );
						break;	
					case "cacPAttachmentNext":
						self primaryAttachment( "next" );
						break;
					case "cacPAttachmentPrev":
						self primaryAttachment( "prev" );
						break;	
					case "cacSAttachmentNext":
						self secondaryAttachment( "next" );
						break;
					case "cacSAttachmentPrev":
						self secondaryAttachment( "prev" );
						break;
					case "cacPerk1Next":
						self perk1( "next" );
						break;	
					case "cacPerk1Prev":
						self perk1( "prev" );
						break;	
					case "cacPerk2Next":
						self perk2( "next" );
						break;
					case "cacPerk2Prev":
						self perk2( "prev" );
						break;	
					case "cacPerk3Next":
						self perk3( "next" );
						break;	
					case "cacPerk3Prev":
						self perk3( "prev" );
						break;		
					case "cacPerk4Next":
						self perk4( "next" );
						break;	
					case "cacPerk4Prev":
						self perk4( "prev" );
						break;	
					case "cacPGrenadeNext":
						self primaryGrenade( "next" );
						break;
					case "cacPGrenadePrev":
						self primaryGrenade( "prev" );
						break;		
					case "cacSGrenadeNext":
						self specialGrenade( "next" );
						break;
					case "cacSGrenadePrev":
						self specialGrenade( "prev" );
						break;		
					case "cacSubmit":
						self submitUpdate();
						break;
				}		
			}
		}
	}
}

initializeEditor()
{
	//Set up arrays and starting indexes
	self.classesIndex = 0;
	self.primariesIndex = 0;
	self.primaries2Index = 0;
	self.pattachmentsIndex = 0;
	self.pattachments2Index = 0;
	self.secondariesIndex = 0;
	self.perk1Index = 0;
	self.perk2Index = 0;
	self.perk3Index = 0;
	self.perk4Index = 0;
	self.pgrenadesIndex = 0;
	self.sgrenadesIndex = 0;
	self.cacEdit_classes = [];
	self.cacEdit_primaries = [];
	self.cacEdit_pattachments = [];
	self.cacEdit_secondaries = [];
	self.cacEdit_perk1 = [];
	self.cacEdit_perk2 = [];
	self.cacEdit_perk3 = [];
	self.cacEdit_perk4 = [];
	self.cacEdit_pgrenades = [];
	self.cacEdit_sgrenades = [];
	
	//For Overkill
	self.isUsingOverkill = false;
	
	//Add data to arrays
	self addClasses();
	self addPrimaries();
	self addPrimaryAttachments();
	self addSecondaries();
	self addPerk1();
	self addPerk2();
	self addPerk3();
	self addPerk4();
	self addPGrenades();
	self addSGrenades();
	
	//On startup this will display customclass1
	self displayDefaultLoadout();
}

displayDefaultLoadout()
{
	//Class name
	self setClientDvar( "ow_cac_class", self.cacEdit_classes[self.classesIndex].text );
	
	//Get current class' stats
	def_pgrenade = self getStat( self.cacEdit_classes[self.classesIndex].stat );
	def_primary = self getStat( self.cacEdit_classes[self.classesIndex].stat + 1 );
	def_pattach = self getStat( self.cacEdit_classes[self.classesIndex].stat + 2 );
	def_secondary = self getStat( self.cacEdit_classes[self.classesIndex].stat + 3 );
	def_sattach = self getStat( self.cacEdit_classes[self.classesIndex].stat + 4 );
	def_perk1 = self getStat( self.cacEdit_classes[self.classesIndex].stat + 5 );
	def_perk2 = self getStat( self.cacEdit_classes[self.classesIndex].stat + 6 );
	def_perk3 = self getStat( self.cacEdit_classes[self.classesIndex].stat + 7 );
	def_perk4 = self getStat( self.cacEdit_classes[self.classesIndex].stat + 105 );
	def_sgrenade = self getStat( self.cacEdit_classes[self.classesIndex].stat + 8 );
	
	//Check if class is using overkill
	if ( def_perk2 == 158 )
		self.isUsingOverkill = true;
	else
		self.isUsingOverkill = false;
	
	//Set default primary index
	for ( i = 0; i < self.cacEdit_primaries.size; i++ )
	{
		if ( self.cacEdit_primaries[i].stat == def_primary )
		{
			self.primariesIndex = i;
			self setClientDvar( "ow_cac_stat_primary", def_primary );
			break;
		}
	}
	//Set default primary attachment index
	for ( i = 0; i < self.cacEdit_pattachments.size; i++ )
	{
		if ( self.cacEdit_pattachments[i].stat == def_pattach )
		{
			self.pattachmentsIndex = i;
			self setClientDvar( "ow_cac_stat_pattachment", def_pattach );
			break;
		}
	}
	//Set default secondary index
	if ( !self.isUsingOverkill )
	{
		for ( i = 0; i < self.cacEdit_secondaries.size; i++ )
		{
			if ( self.cacEdit_secondaries[i].stat == def_secondary )
			{
				self.secondariesIndex = i;
				self setClientDvar( "ow_cac_stat_secondary", def_secondary );
				break;
			}
		}
	}
	else
	{
		for ( i = 0; i < self.cacEdit_primaries.size; i++ )
		{
			if ( self.cacEdit_primaries[i].stat == def_secondary )
			{
				self.primaries2Index = i;
				self setClientDvar( "ow_cac_stat_secondary", def_secondary );
				break;
			}
		}
	}
	//Set default secondary attachment index
	if ( self.isUsingOverkill )
	{
		for ( i = 0; i < self.cacEdit_pattachments.size; i++ )
		{
			if ( self.cacEdit_pattachments[i].stat == def_sattach )
			{
				self.pattachments2Index = i;
				self setClientDvar( "ow_cac_stat_sattachment", def_sattach );
				break;
			}
		}		
	}
	//Set default perk1 index
	for ( i = 0; i < self.cacEdit_perk1.size; i++ )
	{
		if ( self.cacEdit_perk1[i].stat == def_perk1 )
		{
			self.perk1Index = i;
			self setClientDvar( "ow_cac_stat_perk1", def_perk1 );
			break;
		}
		else if ( def_perk1 == 190 || def_perk1 == 191 || def_perk1 == 192 || def_perk1 == 193 )
		{
			self.perk1Index = -1;
			self setClientDvar( "ow_cac_stat_perk1", def_perk1 );
			break;
		}
	}
	//Set default perk2 index
	for ( i = 0; i < self.cacEdit_perk2.size; i++ )
	{
		if ( self.cacEdit_perk2[i].stat == def_perk2 )
		{
			self.perk2Index = i;
			self setClientDvar( "ow_cac_stat_perk2", def_perk2 );
			break;
		}
	}
	//Set default perk3 index
	for ( i = 0; i < self.cacEdit_perk3.size; i++ )
	{
		if ( self.cacEdit_perk3[i].stat == def_perk3 )
		{
			self.perk3Index = i;
			self setClientDvar( "ow_cac_stat_perk3", def_perk3 );
			break;
		}
	}
	//Set default perk4 index
	for ( i = 0; i < self.cacEdit_perk4.size; i++ )
	{
		if ( self.cacEdit_perk4[i].stat == def_perk4 )
		{
			self.perk4Index = i;
			self setClientDvar( "ow_cac_stat_perk4", def_perk4 );
			break;
		}
	}
	//Set default primary grenade index
	for ( i = 0; i < self.cacEdit_pgrenades.size; i++ )
	{
		if ( self.cacEdit_pgrenades[i].stat == def_pgrenade )
		{
			self.pgrenadesIndex = i;
			self setClientDvar( "ow_cac_stat_pgrenade", def_pgrenade );
			break;
		}
	}	
	//Set default special grenade index
	for ( i = 0; i < self.cacEdit_sgrenades.size; i++ )
	{
		if ( self.cacEdit_sgrenades[i].stat == def_sgrenade )
		{
			self.sgrenadesIndex = i;
			self setClientDvar( "ow_cac_stat_sgrenade", def_sgrenade );
			break;
		}
	}
}

class( direction )
{
	if ( direction == "next" )
		self.classesIndex++;
	else
		self.classesIndex--;
		
	if ( self.classesIndex < 0 )
		self.classesIndex = self.cacEdit_classes.size - 1;
	else if ( self.classesIndex >= self.cacEdit_classes.size )
		self.classesIndex = 0;
		
	self displayDefaultLoadout();	
}

primary( direction )
{
	if ( direction == "next" )
		self.primariesIndex++;
	else
		self.primariesIndex--;
		
	if ( self.primariesIndex < 0 )
		self.primariesIndex = self.cacEdit_primaries.size - 1;
	else if ( self.primariesIndex >= self.cacEdit_primaries.size )
		self.primariesIndex = 0;	
		
	weapon_stat = self getStat( self.cacEdit_primaries[self.primariesIndex].stat + 3000 );
	while ( weapon_stat < 1 || ( self.isUsingOverkill && ( self.cacEdit_primaries[self.primariesIndex].stat == self.cacEdit_primaries[self.primaries2Index].stat ) ) )
	{
		if ( direction == "next" )
			self.primariesIndex++;
		else
			self.primariesIndex--;
		
		if ( self.primariesIndex < 0 )
			self.primariesIndex = self.cacEdit_primaries.size - 1;
		else if ( self.primariesIndex >= self.cacEdit_primaries.size )
			self.primariesIndex = 0;

		weapon_stat = self getStat( self.cacEdit_primaries[self.primariesIndex].stat + 3000 );
	}
		
	//Display new weapon
	self.pattachmentsIndex = 0;
	if ( self.perk1Index == -1 )
	{
		if ( self.cacEdit_primaries[self.primaries2Index].label == "bolt" && self.pattachments2Index == 3 )
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		else if ( self.cacEdit_primaries[self.primaries2Index].label == "shotgun" && self.pattachments2Index == 1 )
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		else if ( self.cacEdit_primaries[self.primaries2Index].stat == 21 && self.pattachments2Index == 4 ) //G43
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		else if ( self.cacEdit_primaries[self.primaries2Index].stat == 22 && self.pattachments2Index == 4 ) //Garand
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		else 
			self setClientDvar( "ow_cac_stat_perk1", 190 );
	}	
	self setClientDvar( "ow_cac_stat_primary", self.cacEdit_primaries[self.primariesIndex].stat );
	self setClientDvar( "ow_cac_stat_pattachment", self.cacEdit_pattachments[self.pattachmentsIndex].stat );
}

primaryAttachment( direction )
{
	if ( direction == "next" )
		self.pattachmentsIndex++;
	else
		self.pattachmentsIndex--;
		
	if ( self.pattachmentsIndex < 0 )
		self.pattachmentsIndex = self.cacEdit_pattachments.size - 1;
	else if ( self.pattachmentsIndex >= self.cacEdit_pattachments.size )
		self.pattachmentsIndex = 0;
	
	//We have to check to make sure the camo is unlocked for this weapon
	addonMask = int( tableLookup( "mp/attachmenttable.csv", 9, self.cacEdit_pattachments[self.pattachmentsIndex].stat, 10 ) );
	weaponStat = self getStat( self.cacEdit_primaries[self.primariesIndex].stat + 3000 );
	while( ( int(weaponStat) & addonMask ) == 0 )
	{
		if ( direction == "next" )
			self.pattachmentsIndex++;
		else
			self.pattachmentsIndex--;
		
		if ( self.pattachmentsIndex < 0 )
			self.pattachmentsIndex = self.cacEdit_pattachments.size - 1;
		else if ( self.pattachmentsIndex >= self.cacEdit_pattachments.size )
			self.pattachmentsIndex = 0;

		addonMask = int( tableLookup( "mp/attachmenttable.csv", 9, self.cacEdit_pattachments[self.pattachmentsIndex].stat, 10 ) );
	}	
	
	self setClientDvar( "ow_cac_stat_pattachment", self.cacEdit_pattachments[self.pattachmentsIndex].stat );
	
	//Perk1 Hack
	if ( self.cacEdit_primaries[self.primariesIndex].label == "bolt" && self.pattachmentsIndex == 3 )
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].label == "shotgun" && self.pattachmentsIndex == 1 )
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 21 && self.pattachmentsIndex == 4 ) //G43
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 22 && self.pattachmentsIndex == 4 ) //Garand
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.perk1Index == -1 ) //Reset Perk1 to None (Non-Attachment)
	{
		self setClientDvar( "ow_cac_stat_perk1", 190 );
	}
}

secondary( direction )
{
	if ( !self.isUsingOverkill )
	{
		if ( direction == "next" )
			self.secondariesIndex++;
		else
			self.secondariesIndex--;
		
		if ( self.secondariesIndex < 0 )
			self.secondariesIndex = self.cacEdit_secondaries.size - 1;
		else if ( self.secondariesIndex >= self.cacEdit_secondaries.size )
			self.secondariesIndex = 0;
			
		weapon_stat = self getStat( self.cacEdit_secondaries[self.secondariesIndex].stat + 3000 );
		while ( weapon_stat < 1 )
		{
			if ( direction == "next" )
				self.secondariesIndex++;
			else
				self.secondariesIndex--;
		
			if ( self.secondariesIndex < 0 )
				self.secondariesIndex = self.cacEdit_secondaries.size - 1;
			else if ( self.secondariesIndex >= self.cacEdit_secondaries.size )
				self.secondariesIndex = 0;
				
			weapon_stat = self getStat( self.cacEdit_secondaries[self.secondariesIndex].stat + 3000 );
		}

		//Display new weapon
		self setClientDvar( "ow_cac_stat_secondary", self.cacEdit_secondaries[self.secondariesIndex].stat );
	}
	else
	{
		if ( direction == "next" )
			self.primaries2Index++;
		else
			self.primaries2Index--;
		
		if ( self.primaries2Index < 0 )
			self.primaries2Index = self.cacEdit_primaries.size - 1;
		else if ( self.primaries2Index >= self.cacEdit_primaries.size )
			self.primaries2Index = 0;
			
		weapon_stat = self getStat( self.cacEdit_primaries[self.primaries2Index].stat + 3000 );
		while ( weapon_stat < 1 || ( self.cacEdit_primaries[self.primariesIndex].stat == self.cacEdit_primaries[self.primaries2Index].stat ) )
		{
			if ( direction == "next" )
				self.primaries2Index++;
			else
				self.primaries2Index--;
		
			if ( self.primaries2Index < 0 )
				self.primaries2Index = self.cacEdit_primaries.size - 1;
			else if ( self.primaries2Index >= self.cacEdit_primaries.size )
				self.primaries2Index = 0;
				
			weapon_stat = self getStat( self.cacEdit_primaries[self.primaries2Index].stat + 3000 );
		}		
		
		//Display new weapon
		self.pattachments2Index = 0;
		if ( self.perk1Index == -1 )
		{
			if ( self.cacEdit_primaries[self.primaries2Index].label == "bolt" && self.pattachments2Index == 3 )
				self setClientDvar( "ow_cac_stat_perk1", 193 );
			else if ( self.cacEdit_primaries[self.primaries2Index].label == "shotgun" && self.pattachments2Index == 1 )
				self setClientDvar( "ow_cac_stat_perk1", 193 );
			else if ( self.cacEdit_primaries[self.primaries2Index].stat == 21 && self.pattachments2Index == 4 ) //G43
				self setClientDvar( "ow_cac_stat_perk1", 193 );
			else if ( self.cacEdit_primaries[self.primaries2Index].stat == 22 && self.pattachments2Index == 4 ) //Garand
				self setClientDvar( "ow_cac_stat_perk1", 193 );
			else 
				self setClientDvar( "ow_cac_stat_perk1", 190 );
		}			
		self setClientDvar( "ow_cac_stat_secondary", self.cacEdit_primaries[self.primaries2Index].stat );
		self setClientDvar( "ow_cac_stat_sattachment", self.cacEdit_pattachments[self.pattachments2Index].stat );
	}
}

secondaryAttachment( direction )
{
	if ( self.isUsingOverkill )
	{
		if ( direction == "next" )
			self.pattachments2Index++;
		else
			self.pattachments2Index--;
		
		if ( self.pattachments2Index < 0 )
			self.pattachments2Index = self.cacEdit_pattachments.size - 1;
		else if ( self.pattachments2Index >= self.cacEdit_pattachments.size )
			self.pattachments2Index = 0;
			
		//We have to check to make sure the camo is unlocked for this weapon
		addonMask = int( tableLookup( "mp/attachmenttable.csv", 9, self.cacEdit_pattachments[self.pattachments2Index].stat, 10 ) );
		weaponStat = self getStat( self.cacEdit_primaries[self.primaries2Index].stat + 3000 );
		while( ( int(weaponStat) & addonMask ) == 0 )
		{
			if ( direction == "next" )
				self.pattachments2Index++;
			else
				self.pattachments2Index--;
		
			if ( self.pattachments2Index < 0 )
				self.pattachments2Index = self.cacEdit_pattachments.size - 1;
			else if ( self.pattachments2Index >= self.cacEdit_pattachments.size )
				self.pattachments2Index = 0;
				
			addonMask = int( tableLookup( "mp/attachmenttable.csv", 9, self.cacEdit_pattachments[self.pattachments2Index].stat, 10 ) );
		}
	
		//Perk1 Hack
		if ( self.cacEdit_primaries[self.primaries2Index].label == "bolt" && self.pattachments2Index == 3 )
		{
			self.perk1Index = -1;
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		}
		else if ( self.cacEdit_primaries[self.primaries2Index].label == "shotgun" && self.pattachments2Index == 1 )
		{
			self.perk1Index = -1;
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		}
		else if ( self.cacEdit_primaries[self.primaries2Index].stat == 21 && self.pattachments2Index == 4 ) //G43
		{
			self.perk1Index = -1;
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		}
		else if ( self.cacEdit_primaries[self.primaries2Index].stat == 22 && self.pattachments2Index == 4 ) //Garand
		{
			self.perk1Index = -1;
			self setClientDvar( "ow_cac_stat_perk1", 193 );
		}
		else if ( self.perk1Index == -1 ) //Reset Perk1 to None (Non-Attachment)
		{
			self setClientDvar( "ow_cac_stat_perk1", 190 );
		}
	
		//Display new attachment
		self setClientDvar( "ow_cac_stat_sattachment", self.cacEdit_pattachments[self.pattachments2Index].stat );
	}
}	

perk1( direction )
{
	if ( direction == "next" )
		self.perk1Index++;
	else
		self.perk1Index--;
		
	if ( self.perk1Index < 0 )
		self.perk1Index = self.cacEdit_perk1.size - 1;
	else if ( self.perk1Index >= self.cacEdit_perk1.size )
		self.perk1Index = 0;
		
	while ( self getStat( self.cacEdit_perk1[self.perk1Index].stat ) < 1 || ( self.sgrenadesIndex == 2 && self.cacEdit_perk1[self.perk1Index].stat == 182 ) )
	{
		if ( direction == "next" )
			self.perk1Index++;
		else
			self.perk1Index--;
		
		if ( self.perk1Index < 0 )
			self.perk1Index = self.cacEdit_perk1.size - 1;
		else if ( self.perk1Index >= self.cacEdit_perk1.size )
			self.perk1Index = 0;
	}
	
	//Perk1 Hack
	if ( self.cacEdit_primaries[self.primariesIndex].label == "bolt" && self.pattachmentsIndex == 3 )
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].label == "shotgun" && self.pattachmentsIndex == 1 )
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 21 && self.pattachmentsIndex == 4 ) //G43
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 22 && self.pattachmentsIndex == 4 ) //Garand
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 193 );
	}
	
	//Display new perk
	if ( self.perk1Index != -1 )
	{
		self setClientDvar( "ow_cac_stat_perk1", self.cacEdit_perk1[self.perk1Index].stat );
	}
}

perk2( direction )
{
	if ( direction == "next" )
		self.perk2Index++;
	else
		self.perk2Index--;
		
	if ( self.perk2Index < 0 )
		self.perk2Index = self.cacEdit_perk2.size - 1;
	else if ( self.perk2Index >= self.cacEdit_perk2.size )
		self.perk2Index = 0;
		
	while ( self getStat( self.cacEdit_perk2[self.perk2Index].stat ) < 1 )
	{
		if ( direction == "next" )
			self.perk2Index++;
		else
			self.perk2Index--;
		
		if ( self.perk2Index < 0 )
			self.perk2Index = self.cacEdit_perk2.size - 1;
		else if ( self.perk2Index >= self.cacEdit_perk2.size )
			self.perk2Index = 0;
	}
	
	//Overkill Hack
	if ( self.cacEdit_perk2[self.perk2Index].stat == 158 )
	{
		self.isUsingOverkill = true;
		if ( self.cacEdit_primaries[self.primariesIndex].stat == 20 )
		{
			self.primaries2Index = 1; //G43
			self.pattachments2Index = 0;
			self setClientDvar( "ow_cac_stat_secondary", self.cacEdit_primaries[self.primaries2Index].stat );
			self setClientDvar( "ow_cac_stat_sattachment", self.cacEdit_pattachments[self.pattachments2Index].stat );
		}
		else 
		{
			self.primaries2Index = 0; //SVT40
			self.pattachments2Index = 0;			
			self setClientDvar( "ow_cac_stat_secondary", self.cacEdit_primaries[self.primaries2Index].stat );
			self setClientDvar( "ow_cac_stat_sattachment", self.cacEdit_pattachments[self.pattachments2Index].stat );			
		}
	}
	else if ( self.cacEdit_perk2[self.perk2Index].stat != 158 && self.isUsingOverkill )
	{
		self.isUsingOverkill = false;
		self.primaries2Index = 0;
		self.secondaryIndex = 0;
		self.pattachments2Index = 0;
		self setClientDvar( "ow_cac_stat_secondary", self.cacEdit_secondaries[self.secondariesIndex].stat );
		self setClientDvar( "ow_cac_stat_sattachment", self.cacEdit_pattachments[self.pattachments2Index].stat );
	}
	
	//Display new perk
	self setClientDvar( "ow_cac_stat_perk2", self.cacEdit_perk2[self.perk2Index].stat );
}

perk3( direction )
{
	if ( direction == "next" )
		self.perk3Index++;
	else
		self.perk3Index--;
		
	if ( self.perk3Index < 0 )
		self.perk3Index = self.cacEdit_perk3.size - 1;
	else if ( self.perk3Index >= self.cacEdit_perk3.size )
		self.perk3Index = 0;	
		
	while ( self getStat( self.cacEdit_perk3[self.perk3Index].stat ) < 1 )
	{
		if ( direction == "next" )
			self.perk3Index++;
		else
			self.perk3Index--;
		
		if ( self.perk3Index < 0 )
			self.perk3Index = self.cacEdit_perk3.size - 1;
		else if ( self.perk3Index >= self.cacEdit_perk3.size )
			self.perk3Index = 0;
	}
	
	//Display new perk
	self setClientDvar( "ow_cac_stat_perk3", self.cacEdit_perk3[self.perk3Index].stat );
}

perk4( direction )
{
	if ( direction == "next" )
		self.perk4Index++;
	else
		self.perk4Index--;
		
	if ( self.perk4Index < 0 )
		self.perk4Index = self.cacEdit_perk4.size - 1;
	else if ( self.perk4Index >= self.cacEdit_perk4.size )
		self.perk4Index = 0;	
		
	while ( self getStat( self.cacEdit_perk4[self.perk4Index].stat ) < 1 )
	{
		if ( direction == "next" )
			self.perk4Index++;
		else
			self.perk4Index--;
		
		if ( self.perk4Index < 0 )
			self.perk4Index = self.cacEdit_perk4.size - 1;
		else if ( self.perk4Index >= self.cacEdit_perk4.size )
			self.perk4Index = 0;
	}
	
	//Display new perk
	self setClientDvar( "ow_cac_stat_perk4", self.cacEdit_perk4[self.perk4Index].stat );
}

primaryGrenade( direction )
{
	if ( direction == "next" )
		self.pGrenadesIndex++;
	else
		self.pGrenadesIndex--;
		
	if ( self.pGrenadesIndex < 0 )
		self.pGrenadesIndex = self.cacEdit_pGrenades.size - 1;
	else if ( self.pGrenadesIndex >= self.cacEdit_pGrenades.size )
		self.pGrenadesIndex = 0;
	
	//Display new grenade
	self setClientDvar( "ow_cac_stat_pgrenade", self.cacEdit_pgrenades[self.pgrenadesIndex].stat );
}

specialGrenade( direction )
{
	if ( direction == "next" )
		self.sgrenadesIndex++;
	else
		self.sgrenadesIndex--;
		
	if ( self.sgrenadesIndex < 0 )
		self.sgrenadesIndex = self.cacEdit_sgrenades.size - 1;
	else if ( self.sgrenadesIndex >= self.cacEdit_sgrenades.size )
		self.sgrenadesIndex = 0;

	//Smoke Hack
	if ( self.sgrenadesIndex == 2 && ( self.perk1Index != -1 && self.cacEdit_perk1[self.perk1Index].stat == 182 ) )
	{
		self.perk1Index = -1;
		self setClientDvar( "ow_cac_stat_perk1", 190 );
	}
	
	//Display new grenade
	self setClientDvar( "ow_cac_stat_sgrenade", self.cacEdit_sgrenades[self.sgrenadesIndex].stat );
}

submitUpdate()
{
	class_offset = self.cacEdit_classes[self.classesIndex].stat; //Custom Class

	self setStat( class_offset, self.cacEdit_pgrenades[self.pgrenadesIndex].stat ); //Primary Grenade
	self setStat( class_offset + 1, self.cacEdit_primaries[self.primariesIndex].stat ); //Primary Weapon
	self setStat( class_offset + 2, self.cacEdit_pattachments[self.pattachmentsIndex].stat ); //Primary Attachment
	if ( self.cacEdit_perk2[self.perk2Index].stat != 158 )
	{
		self setStat( class_offset + 3, self.cacEdit_secondaries[self.secondariesIndex].stat ); //Secondary Weapon
		self setStat( class_offset + 4, 0 );
	}
	else
	{
		self setStat( class_offset + 3, self.cacEdit_primaries[self.primaries2Index].stat ); //Secondary Weapon (When Overkill)
		self setStat( class_offset + 4, self.cacEdit_pattachments[self.pattachments2Index].stat ); //Secondary Attachment (When Overkill)
	}
	if ( self.perk1Index != -1 )
		self setStat( class_offset + 5, self.cacEdit_perk1[self.perk1Index].stat ); //Perk 1 
	else if ( self.cacEdit_primaries[self.primariesIndex].label == "bolt" && self.pattachmentsIndex == 3 )
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primariesIndex].label == "shotgun" && self.pattachmentsIndex == 1 )
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 21 && self.pattachmentsIndex == 4 ) //G43
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primariesIndex].stat == 21 && self.pattachmentsIndex == 4 ) //Garand
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primaries2Index].label == "bolt" && self.pattachments2Index == 3 )
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primaries2Index].label == "shotgun" && self.pattachments2Index == 1 )
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primaries2Index].stat == 21 && self.pattachments2Index == 4 ) //G43
		self setStat( class_offset + 5, 193 );
	else if ( self.cacEdit_primaries[self.primaries2Index].stat == 21 && self.pattachments2Index == 4 ) //Garand
		self setStat( class_offset + 5, 193 );
	else if ( self.perk1Index == -1 ) //Reset Perk1 to None (Non-Attachment)
		self setStat( class_offset + 5, 190 );
	
	self setStat( class_offset + 6, self.cacEdit_perk2[self.perk2Index].stat ); //Perk 2
	self setStat( class_offset + 7, self.cacEdit_perk3[self.perk3Index].stat ); //Perk 3
	self setStat( class_offset + 8, self.cacEdit_sgrenades[self.sgrenadesIndex].stat ); //Special Grenade
	
	self.cac_initialized = undefined;
}

addClasses()
{
	//Add classes ( name, class_stat )
	self addCACClasses( "customclass1", 200 ); //Custom class 1
	self addCACClasses( "customclass2", 210 ); //Custom class 2
	self addCACClasses( "customclass3", 220 ); //Custom class 3
	self addCACClasses( "customclass4", 230 ); //Custom class 4
	self addCACClasses( "customclass5", 240 ); //Custom class 5
	
	//Prestige Classes
	if ( self getStat( 252 ) > 64 )
		self addCACClasses( "prestigeclass1", 1200 ); //Prestige class 1
	if ( self getStat( 252 ) > 65 )
		self addCACClasses( "prestigeclass2", 1210 ); //Prestige class 2
	if ( self getStat( 252 ) > 67 )
		self addCACClasses( "prestigeclass3", 1220 ); //Prestige class 3
	if ( self getStat( 252 ) > 70 )
		self addCACClasses( "prestigeclass4", 1230 ); //Prestige class 4
	if ( self getStat( 252 ) > 73 )
		self addCACClasses( "prestigeclass5", 1240 ); //Prestige class 5
		
}
	

addPrimaries()
{
	//Add Primaries ( numAttachments, weapon_stat )
	//Rifle Weapons
	self addCACPrimaries( "rifle", 20 ); //SVT40
	self addCACPrimaries( "rifle", 21 ); //G43
	self addCACPrimaries( "rifle", 22 ); //M1 Garand
	self addCACPrimaries( "rifle", 24 ); //MP44
	self addCACPrimaries( "rifle", 23 ); //M1 Carbine
	//Sub-Machine Weapons
	self addCACPrimaries( "smg", 10 ); //Thompson
	self addCACPrimaries( "smg", 11 ); //MP40
	self addCACPrimaries( "smg", 12 ); //Type100
	self addCACPrimaries( "smg", 13 ); //PPsh
	//LMG Weapons
	self addCACPrimaries( "lmg", 80 ); //Type99
	self addCACPrimaries( "lmg", 82 ); //BAR
	self addCACPrimaries( "lmg", 83 ); //DP28
	self addCACPrimaries( "lmg", 41 ); //MG42
	self addCACPrimaries( "lmg", 81 ); //FG42
	self addCACPrimaries( "lmg", 40 ); //30cal
	//Shotgun Weapons
	self addCACPrimaries( "shotgun", 70 ); //Shotgun
	self addCACPrimaries( "shotgun", 71 ); //Double Barrel
	//Sharpshooter Weapons
	self addCACPrimaries( "bolt", 60 ); //Springfield
	self addCACPrimaries( "bolt", 62 ); //Type99
	self addCACPrimaries( "bolt", 61 ); //Mosin
	self addCACPrimaries( "bolt", 63 ); //Kar98k
	self addCACPrimaries( "bolt", 64 ); //PTRS41
}

addPrimaryAttachments() 
{
	//Add Primary Attachments ( attachment_stat )
	self addCACPrimaryAttachments( 0 ); //None
	self addCACPrimaryAttachments( 1 ); 
	self addCACPrimaryAttachments( 2 ); 
	self addCACPrimaryAttachments( 3 ); 
	self addCACPrimaryAttachments( 4 ); 
	self addCACPrimaryAttachments( 5 );	
}

addSecondaries()
{
	//Add Secondaries ( weapon_stat )
	self addCACSecondaries( 0 ); //Colt45
	self addCACSecondaries( 1 ); //Nambu
	self addCACSecondaries( 2 ); //Walther P38 
	self addCACSecondaries( 3 ); //Tokarev
	self addCACSecondaries( 4 ); //Magnum	
}

addPerk1()
{
	//Add perk1 ( perk_stat )
	//Make sure the perks are allowed before adding them to the list
	if ( getdvarx( "perk_allow_specialty_specialgrenade", "int", 1, 0, 1 ) )
		self addCACPerk1( 182 ); //3x Special
	if ( getdvarx( "perk_allow_specialty_weapon_satchel_charge", "int", 1, 0, 1 ) )	
		self addCACPerk1( 184 ); //Satchel
	if ( getdvarx( "perk_allow_specialty_weapon_bazooka", "int", 1, 0, 1 ) )	
		self addCACPerk1( 186 ); //Bazooka
	if ( getdvarx( "perk_allow_specialty_detectexplosive", "int", 1, 0, 1 ) )	
		self addCACPerk1( 150 ); //Bomb Squad
	if ( getdvarx( "perk_allow_specialty_weapon_bouncing_betty", "int", 1, 0, 1 ) )	
		self addCACPerk1( 185 ); //Betty
	if ( getdvarx( "perk_allow_specialty_extraammo", "int", 1, 0, 1 ) )	
		self addCACPerk1( 151 ); //Bandolier
	if ( getdvarx( "perk_allow_specialty_fraggrenade", "int", 1, 0, 1 ) )	
		self addCACPerk1( 180 ); //2x Frag
	if ( getdvarx( "perk_allow_specialty_weapon_flamethrower", "int", 1, 0, 1 ) )	
		self addCACPerk1( 187 ); //Flamethrower		
}

addPerk2()
{
	//Add perk2 ( perk_stat )
	//Make sure the perks are allowed before adding them to the list
	if ( getdvarx( "perk_allow_specialty_bulletdamage", "int", 1, 0, 1 ) )
		self addCACPerk2( 155 ); //Stopping Power
	if ( getdvarx( "perk_allow_specialty_explosivedamage", "int", 1, 0, 1 ) )	
		self addCACPerk2( 153 ); //Sonic Boom
	if ( getdvarx( "perk_allow_specialty_flakjacket", "int", 1, 0, 1 ) )	
		self addCACPerk2( 154 ); //Flak Jacket
	if ( getdvarx( "perk_allow_specialty_gas_mask", "int", 1, 0, 1 ) )	
		self addCACPerk2( 162 ); //Gas Mask
	if ( getdvarx( "perk_allow_specialty_armorvest", "int", 1, 0, 1 ) )	
		self addCACPerk2( 159 ); //Juggernaut
	if ( getdvarx( "perk_allow_specialty_gpsjammer", "int", 1, 0, 1 ) )	
		self addCACPerk2( 152 ); //GPS Jammer
	if ( getdvarx( "perk_allow_specialty_fastreload", "int", 1, 0, 1 ) )	
		self addCACPerk2( 157 ); //Fast Reload
	if ( getdvarx( "perk_allow_specialty_shades", "int", 1, 0, 1 ) )	
		self addCACPerk2( 161 ); //Shades
	if ( getdvarx( "perk_allow_specialty_rof", "int", 1, 0, 1 ) )	
		self addCACPerk2( 156 ); //Double Tap
	if ( getdvarx( "perk_allow_specialty_twoprimaries", "int", 1, 0, 1 ) )	
		self addCACPerk2( 158 ); //Overkill
}

addPerk3()
{
	//Add perk3 ( perk_stat )
	//Make sure the perks are allowed before adding them to the list
	if ( getdvarx( "perk_allow_specialty_bulletpenetration", "int", 1, 0, 1 ) )
		self addCACPerk3( 168 ); //Deep Impact
	if ( getdvarx( "perk_allow_specialty_longersprint", "int", 1, 0, 1 ) )
		self addCACPerk3( 165 ); //Extreme Conditioning
	if ( getdvarx( "perk_allow_specialty_bulletaccuracy", "int", 1, 0, 1 ) )
		self addCACPerk3( 169 ); //Steady Aim
	if ( getdvarx( "perk_allow_specialty_pin_back", "int", 1, 0, 1 ) )
		self addCACPerk3( 160 ); //Toss Back
	if ( getdvarx( "perk_allow_specialty_pistoldeath", "int", 1, 0, 1 ) )
		self addCACPerk3( 166 ); //Last Stand
	if ( getdvarx( "perk_allow_specialty_grenadepulldeath", "int", 1, 0, 1 ) )
		self addCACPerk3( 167 ); //Martyrdom
	if ( getdvarx( "perk_allow_specialty_fireproof", "int", 1, 0, 1 ) )
		self addCACPerk3( 170); //Fire Proof
	if ( getdvarx( "perk_allow_specialty_quieter", "int", 1, 0, 1 ) )	
		self addCACPerk3( 164 ); //Dead Silence
	if ( getdvarx( "perk_allow_specialty_holdbreath", "int", 1, 0, 1 ) )	
		self addCACPerk3( 163 ); //Iron Lungs
		if ( getdvarx( "perk_allow_specialty_reconnaissance", "int", 1, 0, 1 ) )	
		self addCACPerk3( 171 ); //Reconnaissance
}

addPerk4()
{
	//Add perk4 ( perk_stat )
	//Make sure the perks are allowed before adding them to the list
	if ( getdvarx( "perk_allow_specialty_water_cooled", "int", 1, 0, 1 ) )
		self addCACPerk4( 173 ); //Water Cooler
	if ( getdvarx( "perk_allow_specialty_greased_barrings", "int", 1, 0, 1 ) )	
		self addCACPerk4( 172 ); //Grease Bearings
	if ( getdvarx( "perk_allow_specialty_ordinance", "int", 1, 0, 1 ) )	
		self addCACPerk4( 174 ); //Ordinance
	if ( getdvarx( "perk_allow_specialty_boost", "int", 1, 0, 1 ) )	
		self addCACPerk4( 175 ); //Leadfoot
	if ( getdvarx( "perk_allow_specialty_leadfoot", "int", 1, 0, 1 ) )	
		self addCACPerk4( 176 ); //Boost
}

addPGrenades()
{
	//Add Primary Grenades ( pgrenade_stat )
	self addCACPrimaryGrenade( 100 ); //Frag
	self addCACPrimaryGrenade( 104 ); //Sticky
	self addCACPrimaryGrenade( 101 ); //Molotov
}

addSGrenades()
{
	//Add Special Grenades ( sgrenade_stat )
	self addCACSpecialGrenade( 103 ); //Tabun
	self addCACSpecialGrenade( 105 ); //Flare
	self addCACSpecialGrenade( 102 ); //Smoke	
}

addCACClasses( text, stat )
{
	cacClass = spawnstruct();
	cacClass.text = text;
	cacClass.stat = stat;
	self.cacEdit_classes[self.cacEdit_classes.size] = cacClass;
}

addCACPrimaries( label, stat )
{
	cacPrimary = spawnstruct();
	cacPrimary.label = label;
	cacPrimary.stat = stat;
	self.cacEdit_primaries[self.cacEdit_primaries.size] = cacPrimary;
}

addCACPrimaryAttachments( stat )
{
	cacPAttachment = spawnstruct();
	cacPAttachment.stat = stat;
	self.cacEdit_pattachments[self.cacEdit_pattachments.size] = cacPAttachment;
}

addCACSecondaries( stat )
{
	cacSecondary = spawnstruct();
	cacSecondary.stat = stat;
	self.cacEdit_secondaries[self.cacEdit_secondaries.size] = cacSecondary;
}

addCACPerk1( stat )
{
	cacPerk1 = spawnstruct();
	cacPerk1.stat = stat;
	self.cacEdit_perk1[self.cacEdit_perk1.size] = cacPerk1;
}

addCACPerk2( stat )
{
	cacPerk2 = spawnstruct();
	cacPerk2.stat = stat;
	self.cacEdit_perk2[self.cacEdit_perk2.size] = cacPerk2;
}

addCACPerk3( stat )
{
	cacPerk3 = spawnstruct();
	cacPerk3.stat = stat;
	self.cacEdit_perk3[self.cacEdit_perk3.size] = cacPerk3;
}

addCACPerk4( stat )
{
	cacPerk4 = spawnstruct();
	cacPerk4.stat = stat;
	self.cacEdit_perk4[self.cacEdit_perk4.size] = cacPerk4;
}

addCACPrimaryGrenade( stat )
{
	cacPGrenade = spawnstruct();
	cacPGrenade.stat = stat;
	self.cacEdit_pgrenades[self.cacEdit_pgrenades.size] = cacPGrenade;
}

addCACSpecialGrenade( stat )
{
	cacSpecial = spawnstruct();
	cacSpecial.stat = stat;
	self.cacEdit_sgrenades[self.cacEdit_sgrenades.size] = cacSpecial;
}

openAllClasses()
{
	//If the first custom class is unlocked then in order
	//to display all of the classes in the class selection
	//menu without having to exit game and edit them
	//then we need to unlock them on initialization of the menu
	//so players can edit and then select from any custom class.
	if ( self getStat( 210 ) < 1 )
		self setStat( 210, 1 );
	if ( self getStat( 220 ) < 1 )
		self setStat( 220, 1 );
	if ( self getStat( 230 ) < 1 )
		self setStat( 230, 1 );	
	if ( self getStat( 240 ) < 1 )
		self setStat( 240, 1 );
	if ( self getStat( 252 ) > 64 && self getStat( 1200 ) < 1 )
		self setStat( 1200, 1 );		
	if ( self getStat( 252 ) > 65 && self getStat( 1210 ) < 1 )
		self setStat( 1210, 1 );
	if ( self getStat( 252 ) > 67 && self getStat( 1220 ) < 1 )
		self setStat( 1220, 1 );
	if ( self getStat( 252 ) > 70 && self getStat( 1230 ) < 1 )
		self setStat( 1230, 1 );
	if ( self getStat( 252 ) > 73 && self getStat( 1240 ) < 1 )
		self setStat( 1240, 1 );	
}