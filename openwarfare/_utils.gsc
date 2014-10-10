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

#include maps\mp\gametypes\_hud_util;

// Function to get extended dvar values
getdvarx( dvarName, dvarType, dvarDefault, minValue, maxValue )
{
	// Check variables from lowest to highest priority
	if ( !isDefined( level.gametype ) ) {
		level.script = toLower( getDvar( "mapname" ) );
		level.gametype = toLower( getDvar( "g_gametype" ) );
		level.serverLoad = getDvar( "_sl_current" );
	}
	
	// scr_variable_name_<load>
	if ( getdvar( dvarName + "_" + level.serverLoad ) != "" )
		dvarName = dvarName + "_" + level.serverLoad;
			
	// scr_variable_name_<gametype>
	if ( getdvar( dvarName + "_" + level.gametype ) != "" )
		dvarName = dvarName + "_" + level.gametype;

	// scr_variable_name_<gametype>_<load>
	if ( getdvar( dvarName + "_" + level.gametype + "_" + level.serverLoad ) != "" )
		dvarName = dvarName + "_" + level.gametype + "_" + level.serverLoad;		

	// scr_variable_name_<mapname>
	if ( getdvar( dvarName + "_" + level.script ) != "" )
		dvarName = dvarName + "_" + level.script;

	// scr_variable_name_<mapname>_<load>
	if ( getdvar( dvarName + "_" + level.script + "_" + level.serverLoad ) != "" )
		dvarName = dvarName + "_" + level.script + "_" + level.serverLoad;

	// scr_variable_name_<gametype>_<mapname>
	if ( getdvar( dvarName + "_" + level.gametype + "_" + level.script ) != "" )
		dvarName = dvarName + "_" + level.gametype + "_" + level.script;

	// scr_variable_name_<gametype>_<mapname>_<load>
	if ( getdvar( dvarName + "_" + level.gametype + "_" + level.script + "_" + level.serverLoad ) != "" )
		dvarName = dvarName + "_" + level.gametype + "_" + level.script + "_" + level.serverLoad;

	return getdvard( dvarName, dvarType, dvarDefault, minValue, maxValue );
}


// Function to get extended dvar values (only with server load)
getdvarl( dvarName, dvarType, dvarDefault, minValue, maxValue, useLoad )
{
	// scr_variable_name_<load>
	if ( isDefined( level.serverLoad ) && useLoad && getdvar( dvarName + "_" + level.serverLoad ) != "" )
		dvarName = dvarName + "_" + level.serverLoad;

	return getdvard( dvarName, dvarType, dvarDefault, minValue, maxValue );
}


// Function to get dvar values (not extended)
getdvard( dvarName, dvarType, dvarDefault, minValue, maxValue )
{
	// Initialize the return value just in case an invalid dvartype is passed
	dvarValue = "";

	// Assign the default value if the dvar is empty
	if ( getdvar( dvarName ) == "" ) {
		dvarValue = dvarDefault;
	} else {
		// If the dvar is not empty then bring the value
		switch ( dvarType ) {
			case "int":
				dvarValue = getdvarint( dvarName );
				break;
			case "float":
				dvarValue = getdvarfloat( dvarName );
				break;
			case "string":
				dvarValue = getdvar( dvarName );
				break;
		}
	}

	// Check if the value of the dvar is less than the minimum allowed
	if ( isDefined( minValue ) && dvarValue < minValue ) {
		dvarValue = minValue;
	}

	// Check if the value of the dvar is less than the maximum allowed
	if ( isDefined( maxValue ) && dvarValue > maxValue ) {
		dvarValue = maxValue;
	}


	return ( dvarValue );
}


// Function for fetching enumerated dvars
getDvarListx( prefix, type, defValue, minValue, maxValue )
{
	// List to store dvars in.
	list = [];

	while (true)
	{
		// We don't need any defailt value since they just won't be added to the list.
		temp = getdvarx( prefix + (list.size + 1), type, defValue, minValue, maxValue );

		if ( isDefined( temp ) && temp != defValue )
			list[list.size] = temp;
		else
			break;
	}

	return list;
}


updateSecondaryProgressBar( curProgress, useTime, forceRemove, barText )
{
	// Check if we need to remove the bar
	if ( forceRemove )
	{
		if ( isDefined( self.proxBar2 ) )
			self.proxBar2 hideElem();

		if ( isDefined( self.proxBarText2 ) )
			self.proxBarText2 hideElem();
		return;
	}

	// Check if the player has the primary progress bar object
	if ( !isDefined( self.proxBar2 ) )
	{
		self.proxBar2 = createSecondaryProgressBar();
	}

	if ( self.proxBar2.hidden )
	{
		self.proxBar2 showElem();
	}

	// Check if the player has the primary progress bar text object
	if ( !isDefined( self.proxBarText2 ) )
	{
		self.proxBarText2 = createSecondaryProgressBarText();
		self.proxBarText2 setText( barText );
	}

	if ( self.proxBarText2.hidden )
	{
		self.proxBarText2 showElem();
		self.proxBarText2 setText( barText );
	}

	// Make sure we are not going over the limit
	if( curProgress > useTime)
		curProgress = useTime;

	// Update the progress bar
	self.proxBar2 updateBar( curProgress / useTime , undefined );
}



// Based on maps\_utility::player_looking_at() function (adapted for multiplayer)
IsLookingAt( gameEntity )
{
	entityPos = gameEntity.origin;
	playerPos = self getEye();

	entityPosAngles = vectorToAngles( entityPos - playerPos );
	entityPosForward = anglesToForward( entityPosAngles );

	playerPosAngles = self getPlayerAngles();
	playerPosForward = anglesToForward( playerPosAngles );

	newDot = vectorDot( entityPosForward, playerPosForward );

	if ( newDot < 0.72 ) {
		return false;
	} else {
		return true;
	}

	/*traceResult = bullettrace( entityPos, playerPos, false, undefined );
	self iprintln( "newDOT = "+newDot+"   /   traceResult[fraction]="+traceResult["fraction"] );
	return ( traceResult["fraction"] == 1 );*/
}


createSecondaryProgressBar()
{
	bar = createBar( (1, 1, 1), level.secondaryProgressBarWidth, level.secondaryProgressBarHeight );
	if ( level.splitScreen )
		bar setPoint("TOP", undefined, level.secondaryProgressBarX, level.secondaryProgressBarY);
	else
		bar setPoint("CENTER", undefined, level.secondaryProgressBarX, level.secondaryProgressBarY);

	return bar;
}


createSecondaryProgressBarText()
{
	text = createFontString( "objective", level.secondaryProgressBarFontSize );
	if ( level.splitScreen )
		text setPoint("TOP", undefined, level.secondaryProgressBarTextX, level.secondaryProgressBarTextY);
	else
		text setPoint("CENTER", undefined, level.secondaryProgressBarTextX, level.secondaryProgressBarTextY);

	text.sort = -1;
	return text;
}


createTimer( font, fontScale )
{
	// Creates a timer only for the player
	timerElem = newClientHudElem( self );
	timerElem.elemType = "timer";
	timerElem.font = font;
	timerElem.fontscale = fontScale;
	timerElem.x = 0;
	timerElem.y = 0;
	timerElem.width = 0;
	timerElem.height = int(level.fontHeight * fontScale);
	timerElem.xOffset = 0;
	timerElem.yOffset = 0;
	timerElem.children = [];
	timerElem setParent( level.uiParent );
	timerElem.hidden = false;

	return timerElem;
}


addLeagueRuleset( leagueName, gameType, functionPointer )
{
	level.matchRules[ leagueName ][ gameType ] = functionPointer;

	return;
}


giveNadesAfterDelay( nadeType, nadeCount, nadePrimary )
{
	self endon("disconnect");
	self endon("death");

	playSound = false;

	
	// Check what type of grenade is it?
	switch ( nadeType )
	{
		case "frag_grenade_mp":
			timeToUse = level.scr_delay_frag_grenades * 1000;
			break;
		case "sticky_grenade_mp":
			timeToUse = level.scr_delay_sticky_grenades * 1000;
			break;
		case "molotov_mp":
			timeToUse = level.scr_delay_molotovs * 1000;
			break;
		case "smoke_grenade_mp":
			timeToUse = level.scr_delay_smoke_grenades * 1000;
			break;
		case "tabun_gas_mp":
			timeToUse = level.scr_delay_tabun_gas_grenades * 1000;
			break;
		case "signal_flare_mp":
			timeToUse = level.scr_delay_signal_flares * 1000;
			break;
		default:
			timeToUse = 0;
			break;
	}

	if ( timeToUse > 0 ) {
		playSound = true;

		// Check if we need to delay every time the player spawns
		if ( !level.scr_delay_only_round_start ) {
			timeToUse += openwarfare\_timer::getTimePassed();
		}

		while ( timeToUse > openwarfare\_timer::getTimePassed() )
			wait (0.05);
	}

	if ( nadeType == "frag_grenade_mp" )
	{
		nadeType = checkNadeType( nadeType );
	}
	
	// Give the stuff to the player
	self giveWeapon( nadeType );
	self setWeaponAmmoClip( nadeType, nadeCount );

	// Play a sound so the players know they can use grenades
	if ( playSound && level.scr_delay_sound_enable == 1 ) {
		self playLocalSound( "ammo_pickup" );
	}

	if( nadePrimary )
		self switchToOffhand( nadeType );

	return;
}


giveActionSlot3AfterDelay( slotWeapon )
{
	self endon("disconnect");
	self endon("death");

	playSound = false;

	// Check what kind of delay we should be using
	switch ( slotWeapon )
	{
		case "altMode":
			// We do not give the greande launcher if it's disabled (condition here for ranked servers)
			if ( level.rankedMatch && level.attach_allow_rifleman_gl == 0 )
				return;
			timeToUse = level.scr_delay_grenade_launchers * 1000;
			break;
			
		case "bazooka_mp":
			// We do not give Bazookas if it's disabled (condition here for ranked servers)
			if ( level.perk_allow_bazooka_mp == 0 )
				return;
			timeToUse = level.scr_delay_bazookas * 1000;
			break;
			
		case "satchel_charge_mp":
			// We do not give Satchel charges if it's disabled (condition here for ranked servers)
			if ( level.perk_allow_satchel_mp == 0 )
				return;
			timeToUse = level.scr_delay_satchels * 1000;
			break;
			
		case "mine_bouncing_betty_mp":
			// We do not give Bouncing bettys if it's disabled (condition here for ranked servers)
			if ( level.perk_allow_bouncing_betty_mp == 0 )
				return;
			timeToUse = level.scr_delay_bettys * 1000;
			break;
			
		case "m2_flamethrower_mp":
			// We do not give Flame throwers if it's disabled (condition here for ranked servers)
			if ( level.perk_allow_flamethrower_mp == 0 )
				return;
			timeToUse = level.scr_delay_flamethrower * 1000;
			break;
			
		default:
			timeToUse = 0;
	}

	if ( timeToUse > 0 ) {
		playSound = true;

		// Check if we need to delay every time the player spawns
		if ( !level.scr_delay_only_round_start ) {
			timeToUse += openwarfare\_timer::getTimePassed();
		}

		while ( timeToUse > openwarfare\_timer::getTimePassed() )
			wait (0.05);
	}
	/*
	if ( slotWeapon == "bazooka_mp" )
	{
		slotWeapon = checkProjType( slotWeapon );
	}
	self iprintln ( slotWeapon );
	*/
	// Activate the alternate mode in the weapons
	if ( slotWeapon == "altMode" ) {
		self SetActionSlot( 3, "altMode" );
	} else {
		self SetActionSlot( 3, "weapon", slotWeapon );
	}

	// Play a sound so the players know they can use grenades
	if ( playSound && level.scr_delay_sound_enable == 1 ) {
		self playLocalSound( "ammo_pickup" );
	}

	return;
}


giveActionSlot4AfterDelay( hardpointType, streak )
{
	self endon("disconnect");
	self endon("death");

	// Check what kind of delay we should be using
	if ( !isDefined( streak ) ) {
		switch ( hardpointType )
		{
			case "artillery_mp":
				timeToUse = level.scr_artillery_delay * 1000;
				break;
			case "dogs_mp":
				timeToUse = level.scr_dogs_delay * 1000;
				break;
			default:
				timeToUse = 0;
		}
	
		if ( timeToUse > 0 ) {
			playSound = true;
	
			while ( timeToUse > openwarfare\_timer::getTimePassed() )
				wait (0.05);
		}
	}

	// Assign the weapon slot 4
	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;

	// Check if we should remind the player about having the hardpoint
	if ( level.scr_hardpoint_show_reminder != 0 ) {
		self thread maps\mp\gametypes\_hardpoints::hardpointReminder( hardpointType );
	}
	
	// Check if we need to show the message or play a sound
	self thread maps\mp\gametypes\_hardpoints::hardpointNotify( hardpointType, streak );

	return;
}


// Trims left spaces from a string
trimLeft( stringToTrim )
{
	stringIdx = 0;
	while ( stringToTrim[ stringIdx ] == " " && stringIdx < stringToTrim.size )
		stringIdx++;

	newString = getSubStr( stringToTrim, stringIdx, stringToTrim.size - stringIdx );

	return newString;
}


// Trims right spaces from a string
trimRight( stringToTrim )
{
	stringIdx = stringToTrim.size;
	while ( stringToTrim[ stringIdx ] == " " && stringIdx > 0 )
		stringIdx--;

	newString = getSubStr( stringToTrim, 0, stringIdx );

	return newString;

}


// Trims all the spaces left and right from a string
trim( stringToTrim )
{
	return ( trimLeft( trimRight ( stringToTrim ) ) );
}


// As we cannot reference native engine functions we have to use a wrapper to do this.
// This way we can easily attach it to an event, which is useful for debugging.
iPrintLnWrapper( message )
{
	self iPrintLn( message );
}

// Removes an element from the array and reindexes it.
removeIndexArray(orgArray, index)
{
	newArray = [];

	for(i = 0; i < orgArray.size; i++) {
		if(i < index) {
			newArray[i] = orgArray[i];
		} else if(i > index) {
			newArray[i - 1] = orgArray[i];
		}
	}

	return newArray;
}

/*
   Note that getArrayKeys() returns the list of keys in reverse order,
   therefore we need to iterate through them in reverse as well to get
   the correct order.
*/

// Removes all instances of an element from the array
/*array_remove( array, item )
{
	temp = [];

	keys = getArrayKeys( array );
	for (i = keys.size - 1; i >= 0; i--)
	{
		if (array[keys[i]] != item)
			temp[keys[i]] = array[keys[i]];
	}

	return temp;
}*/

// Removes the first instances of an element from the array
array_remove_first( array, item )
{
	temp = [];
	removed = false;

	keys = getArrayKeys( array );
	for (i = keys.size - 1; i >= 0; i--)
	{
		if (array[keys[i]] != item || removed == true)
		{
			temp[keys[i]] = array[keys[i]];
		}
		else
		{
			removed = true;
		}
	}

	return temp;
}

// Extracts a sub-array from an array with numeral indicies.
array_slice( array, start, end )
{
	temp = [];
	for (i = start; i <= end; i++)
	{
		temp[temp.size] = array[i];
	}

	return temp;
}

// Replaces a sub-array from an array with a new item.
array_splice( array, start, end, item )
{
	temp = [];
	for (i = 0; i < array.size; i++)
	{
		if (i < start || i > end)
			temp[temp.size] = array[i];
		if (i == start)
			temp[temp.size] = item;
	}

	return temp;
}

// Performs 'func' on each element in the array with an optional argument.
each( array, func, arg )
{
	keys = getArrayKeys( array );
	if (isDefined( arg ))
	{
		for (i = keys.size - 1; i >= 0; i--)
		{
			self [[ func ]]( array[keys[i]], arg );
		}
	}
	else
	{
		for (i = keys.size - 1; i >= 0; i--)
		{
			self [[ func ]]( array[keys[i]] );
		}
	}
}

// Same as 'each' but will also pass the index of the item to 'func'
each_with_index( array, func, arg )
{
	keys = getArrayKeys( array );
	if (isDefined( arg ))
	{
		for (i = keys.size - 1; i >= 0; i--)
		{
			self [[ func ]]( array[keys[i]], arg, i );
		}
	}
	else
	{
		for (i = keys.size - 1; i >= 0; i--)
		{
			self [[ func ]]( array[keys[i]], i );
		}
	}
}

//	Selects only elements of an array which have been evaluated to "true"
//	by the evaluator function and returns them as a new array
select( array, evaluator )
{
	temp = [];

	keys = getArrayKeys( array );

	for (i = keys.size - 1; i >= 0; i--)
	{
		if ([[ evaluator ]]( array[keys[i]] ))
			temp[temp.size] = array[keys[i]];
	}

	return temp;
}


/*
   The observer pattern is a design pattern used for dispatching events to so called 'listeners'
   which have been registered in advance. Several functions can trigger an event and several
   listener can handle the events.
*/

// To attach a listener to an event you use the eventAttach() function giving the name of the event and
// a callback to run as the arguments. You can also specify an optional argument to be passed along to the callback function.
eventAttach( event, callback, arg )
{
	if (!isDefined( level._event_callbacks ))
		level._event_callbacks = [];

	if (!isDefined( level._event_callbacks[event] ))
		level._event_callbacks[event] = [];

	callback_struct = [];
	callback_struct["proc"] = callback;
	callback_struct["arg"] = arg;

	level._event_callbacks[event][level._event_callbacks[event].size] = callback_struct;
}

// Detaches the last handler that matches the callback
eventDetach( event, callback )
{
	// In case we don't find a match.
	last_callback = -1;

	for (i = 0; i < level._event_callbacks[event].size; i++)
	{
		if (level._event_callbacks[event][i]["proc"] == callback)
			last_callback = i;
	}

	// If we found a callback we want to remove the last one.
	if (last_callback != -1)
		level._event_callbacks[event] = removeIndexArray( level._event_callbacks[event], last_callback );
}

// To trigger an event you call eventNotify() with the name of the event as the single argument or with an
// optional argument to send to the callback function.
eventNotify( event, arg )
{
	if (!isDefined( level._event_callbacks ) || !isDefined( level._event_callbacks[event] ))
		return;

	for (i = 0; i < level._event_callbacks[event].size; i++)
	{
		if (isDefined( level._event_callbacks[event][i]["arg"] ))
		{
			if (isDefined( arg ))
				self thread [[ level._event_callbacks[event][i]["proc"] ]]( arg, level._event_callbacks[event][i]["arg"] );
			else
				self thread [[ level._event_callbacks[event][i]["proc"] ]]( level._event_callbacks[event][i]["arg"] );
		}
		else
		{
			if (isDefined( arg ))
				self thread [[ level._event_callbacks[event][i]["proc"] ]]( arg );
			else
				self thread [[ level._event_callbacks[event][i]["proc"] ]]();
		}
	}
}


deleteExplosives()
{
	// delete c4
	if ( isdefined( self.satchelarray ) )
	{
		for ( i = 0; i < self.satchelarray.size; i++ )
		{
			if ( isdefined(self.satchelarray[i]) )
				self.satchelarray[i] delete();
		}
	}
	self.satchelarray = [];

	// delete claymores
	if ( isdefined( self.bettyarray ) )
	{
		for ( i = 0; i < self.bettyarray.size; i++ )
		{
			if ( isdefined(self.bettyarray[i]) )
				self.bettyarray[i] delete();
		}
	}
	self.bettyarray = [];

	return;
}

ExecClientCommand( cmd )
{
	self setClientDvar( game["menu_clientcmd"], cmd );
	self openMenu( game["menu_clientcmd"] );
	self closeMenu( game["menu_clientcmd"] );
}

weaponPause(waittime)
{
	/*---------------------------------------------------------------------
	 Inuitively obvious to the casual observer (and used as thread)
	---------------------------------------------------------------------*/
	self endon("killed_player");
	self endon("spawned");
	self endon("disconnect");
	level endon("intermission");

	self thread maps\mp\gametypes\_gameobjects::_disableWeapon();
	wait waittime;
	self thread maps\mp\gametypes\_gameobjects::_enableWeapon();
}

percentChance(chance)
// Random function
{
	if(chance == 0) return false;
	if(chance > 100) chance = 100;
	percent = randomint(100);
	if(percent < chance)
		return true;
	else
		return false;
}

Distort()
{
//Gunsway
	self endon("killed_player");
	self endon("spawned");
	self endon("disconnect");
	level endon("intermission");

	horiz[1] = .26;
	horiz[2] = .26;
	horiz[3] = .25;
	horiz[4] = .25;
	horiz[5] = .25;
	horiz[6] = .25;
	horiz[7] = .25;
	horiz[8] = .25;
	horiz[9] = .25;
	horiz[10] = .25;
	horiz[11] = .25;
	horiz[12] = .15;
	horiz[13] = .13;
	vert[1] = 0.0;
	vert[2] = 0.025;
	vert[3] = 0.036;
	vert[4] = 0.037;
	vert[5] = 0.053;
	vert[6] = 0.072;
	vert[7] = 0.080;
	vert[8] = 0.100;
	vert[9] = 0.11;
	vert[10] = 0.15;
	vert[11] = 0.244;
	vert[12] = 0.238;
	vert[13] = 0.085;

	wait 2;
	i = 1;
	idir = 0;
	pshift = 0;
	yshift = 0;


	for(;;)
	{
		VMag = self.VaxisMag;
		YMag = self.YaxisMag;

		if(i >= 1 && i <= 13)
 		{
			pShift = horiz[i]*VMag;
			yShift = (0 - vert[i])*YMag;
		}
		else if(i >= 14 && i <= 26)
		{
			j = 14 - (i -13);
			pShift = (0 - horiz[j])*VMag;
			yShift = (0 - vert[j])*YMag;
		}
		else if(i >= 27 && i <= 39)
		{
			pShift = (0-horiz[i-26])*VMag;
			yShift = (vert[i-26])*YMag;
		}
		else if(i >= 40 && i <= 52)
		{
			j = 14 - (i -39);
			pShift = (horiz[j])*VMag;
			yShift = (vert[j])*YMag;
		}
		angles = self getplayerangles();
		self setPlayerAngles(angles + (pShift, yShift, 0));
		if(randomInt(50) == 0)
		{
			if(idir == 0) idir = 1;
			else idir = 0;
			i = i + 26;
		}
		if(idir == 0) i++;
		if(idir == 1) i--;
		if( i > 52) i = i - 52;
		if( i < 0) i = 52 - i;
		wait 0.05;
	}
}

convertHitLocation( sHitLoc )
{
// Better Names for hitloc
	switch( sHitLoc )
	{
		case "torso_upper":
			sHitLoc = &"OW_UPPER_TORSO";
			break;

		case "torso_lower":
			sHitLoc = &"OW_LOWER_TORSO";
			break;

		case "head":
			sHitLoc = &"OW_HEAD";
			break;

		case "neck":
			sHitLoc = &"OW_NECK";
			break;

		case "left_arm_upper":
		case "left_arm_lower":
		case "left_hand":
			sHitLoc = &"OW_LEFT_ARM";
			break;

		case "right_arm_upper":
		case "right_arm_lower":
		case "right_hand":
			sHitLoc = &"OW_RIGHT_ARM";
			break;

		case "left_leg_upper":
		case "left_leg_lower":
		case "left_foot":
			sHitLoc = &"OW_LEFT_LEG";
			break;

		case "right_leg_upper":
		case "right_leg_lower":
		case "right_foot":
			sHitLoc = &"OW_RIGHT_LEG";
			break;

		case "none":
			sHitLoc = &"OW_MASSIVE_INJURIES";
			break;

		case "bloodloss":
			sHitLoc = &"OW_BLOOD_LOSS";
			break;
	}

	return sHitLoc;
}


convertWeaponName( sWeapon )
{
	// Use the localized strings to get the name of the weapon
	switch( sWeapon ) {
		case "springfield_bayonet_mp":
		case "springfield_gl_mp":
		case "springfield_mp":
		case "springfield_scoped_mp":
			sWeapon = &"WEAPON_SPRINGFIELD";
			break;

		case "type99rifle_bayonet_mp":
		case "type99rifle_gl_mp":
		case "type99rifle_mp":
		case "type99rifle_scoped_mp":
			sWeapon = &"WEAPON_TYPE99_RIFLE";
			break;

		case "mosinrifle_bayonet_mp":
		case "mosinrifle_gl_mp":
		case "mosinrifle_mp":
		case "mosinrifle_scoped_mp":
			sWeapon = &"WEAPON_MOSIN_RIFLE";
			break;

		case "kar98k_bayonet_mp":
		case "kar98k_gl_mp":
		case "kar98k_mp":
		case "kar98k_scoped_mp":
			sWeapon = &"WEAPON_KAR98K";
			break;

		case "ptrs41_mp":
			sWeapon = &"WEAPON_PTRS41";
			break;

		case "svt40_mp":
		case "svt40_telescopic_mp":
		case "svt40_flash_mp":
			sWeapon = &"WEAPON_SVT40";
			break;

		case "gewehr43_gl_mp":
		case "gewehr43_mp":
			sWeapon = &"WEAPON_GEWEHR43";
			break;

		case "m1garand_bayonet_mp":
		case "m1garand_gl_mp":
		case "m1garand_mp":
		case "m1garand_flash_mp":		
			sWeapon = &"WEAPON_M1GARAND";
			break;

		case "stg44_mp":
		case "stg44_telescopic_mp":
		case "stg44_flash_mp":
		case "svt40_aperture_mp":
			sWeapon = &"OW_WEAPON_STG_44";
			break;

		case "m1carbine_bayonet_mp":
		case "m1carbine_bigammo_mp":
		case "m1carbine_mp":
			sWeapon = &"WEAPON_M1A1CARBINE";
			break;


		case "thompson_bigammo_mp":
		case "thompson_mp":
		case "thompson_silenced_mp":
			sWeapon = &"WEAPON_THOMPSON";
			break;

		case "mp40_bigammo_mp":
		case "mp40_mp":
		case "mp40_silenced_mp":
		case "m1garand_scoped_mp":
			sWeapon = &"WEAPON_MP40";
			break;

		case "type100smg_aperture_mp":
		case "type100smg_bigammo_mp":
		case "type100smg_mp":
		case "type100smg_silenced_mp":
			sWeapon = &"WEAPON_TYPE100_SMG";
			break;

		case "ppsh_aperture_mp":
		case "ppsh_bigammo_mp":
		case "ppsh_mp":
		case "m1carbine_aperture_mp":
			sWeapon = &"WEAPON_PPSH";
			break;

		case "shotgun_bayonet_mp":
		case "shotgun_grip_mp":
		case "shotgun_mp":
			sWeapon = &"WEAPON_SHOTGUN";
			break;

		case "doublebarreledshotgun_grip_mp":
		case "doublebarreledshotgun_mp":
			sWeapon = &"WEAPON_SHOTGUN_DOUBLE_BARRELED";
			break;

		case "doublebarreledshotgun_sawoff_mp":
			sWeapon = &"WEAPON_SHOTGUN_DOUBLE_BARRELED_SAWOFF";
			break;
			
		case "type99lmg_bayonet_mp":
		case "type99lmg_bipod_mp":
		case "type99lmg_mp":
			sWeapon = &"WEAPON_TYPE99_LMG";
			break;

		case "bar_bipod_crouch_mp":
		case "bar_bipod_mp":
		case "bar_bipod_prone_mp":			
		case "bar_bipod_stand_mp":
		case "bar_mp":
		case "stg44_aperture_mp":
		case "gewehr43_silenced_mp":			
			sWeapon = &"WEAPON_BAR";
			break;

		case "dp28_bipod_crouch_mp":
		case "dp28_bipod_mp":
		case "dp28_bipod_prone_mp":			
		case "dp28_bipod_stand_mp":
		case "dp28_mp":
			sWeapon = &"WEAPON_DP28";
			break;

		case "mg42_bipod_crouch_mp":
		case "mg42_bipod_mp":
		case "mg42_bipod_prone_mp":			
		case "mg42_bipod_stand_mp":
		case "mg42_mp":
			sWeapon = &"WEAPON_MG42";
			break;

		case "fg42_bipod_crouch_mp":
		case "fg42_bipod_mp":
		case "fg42_bipod_prone_mp":			
		case "fg42_bipod_stand_mp":
		case "fg42_mp":
		case "fg42_telescopic_mp":
		case "mp40_aperture_mp":
		case "gewehr43_aperture_mp":
		case "gewehr43_telescopic_mp":
			sWeapon = &"WEAPON_FG42";
			break;

		case "30cal_bipod_crouch_mp":
		case "30cal_bipod_mp":
		case "30cal_bipod_prone_mp":			
		case "30cal_bipod_stand_mp":
		case "30cal_mp":
			sWeapon = &"WEAPON_30CAL";
			break;

		case "colt_mp":
			sWeapon = &"WEAPON_COLT45";
			break;

		case "nambu_mp":
			sWeapon = &"WEAPON_NAMBU";
			break;

		case "walther_mp":
			sWeapon = &"WEAPON_WALTHER_P38";
			break;

		case "tokarev_mp":
			sWeapon = &"WEAPON_TOKAREV_TT30";
			break;

		case "357magnum_mp":
			sWeapon = &"WEAPON_357MAGNUM";
			break;

		case "gl_gewehr43_mp":
		case "gl_kar98k_mp":
		case "gl_m1garand_mp":
		case "gl_mosinrifle_mp":
		case "gl_springfield_mp":
		case "gl_type99rifle_mp":
		case "gl_mp":
			sWeapon = &"WEAPON_GRENADE_LAUNCHER";
			break;

		case "frag_grenade_mp":
		case "frag_grenade_short_mp":
		case "frag_grenade_ger_mp":
			sWeapon = &"WEAPON_GERMANGRENADE";
			break;
		case "frag_grenade_rus_mp":
			sWeapon = &"WEAPON_RUSSIANGRENADE";
			break;
		case "frag_grenade_jap_mp":
			sWeapon = &"WEAPON_FRAGGRENADE";
			break;

		case "sticky_grenade_mp":
			sWeapon = &"WEAPON_RUSSIANGRENADE";
			break;

		case "molotov_mp":
			sWeapon = &"WEAPON_MOLOTOV";
			break;

		case "signal_flare_mp":
			sWeapon = &"WEAPON_SIGNAL_FLARE";
			break;

		case "smoke_grenade_mp":
			sWeapon = &"WEAPON_SMOKE_GRENADE";
			break;

		case "tabun_gas_mp":
			sWeapon = &"WEAPON_TABUN_GRENADE";
			break;

		case "satchel_charge_mp":
			sWeapon = &"WEAPON_SATCHEL";
			break;

		case "mine_bouncing_betty_mp":
			sWeapon = &"WEAPON_MINE_BOUNCING_BETTY";
			break;

		case "bazooka_mp":
			sWeapon = &"WEAPON_BAZOOKA";
			break;

		case "m2_flamethrower_mp":
			sWeapon = &"WEAPON_M2_FLAMETHROWER";
			break;
			
		case "destructible_car":
			sWeapon = &"OW_DESTRUCTIBLE_CAR";
			break;

		case "knife_mp":
			sWeapon = &"OW_KNIFE";
			break;

		case "bayonet_mp":
			sWeapon = &"WEAPON_TYPE99_RIFLE_BAYONET";
			break;

		case "explodable_barrel":
			sWeapon = &"OW_EXPLODING_BARREL";
			break;

		case "unknown":
			sWeapon = &"MP_UNKNOWN";
			break;

		case "dog_bite_mp":
			sWeapon = &"OW_DOGBITE";
			break;

		case "artillery_mp":
			sWeapon = &"OW_ARTILLERY";
			break;
			
		case "panzer4_turret_mp":
		case "t34_turret_mp":
			sWeapon = &"OW_TANKSHELL";
			break;
			
		case "panzer4_gunner_front_mp":
		case "panzer4_gunner_mp":
		case "t34_gunner_front_mp":
		case "t34_gunner_mp":
			sWeapon = &"OW_TANKMG";
			break;

		case "briefcase_bomb_mp":
			sWeapon = &"OW_BOMB";
			break;
	}

	return sWeapon;
}


xWait( timeToWait )
{
	finishWait = openwarfare\_timer::getTimePassed() + timeToWait * 1000;

	while ( finishWait > openwarfare\_timer::getTimePassed() )
		wait (0.05);

	return;
}


getPlayerPrimaryWeapon()
{
	weaponsList = self getWeaponsList();
	for( idx = 0; idx < weaponsList.size; idx++ )
	{
		if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( weaponsList[idx] ) ) {
			return weaponsList[idx];
		}
	}

	return "none";
}


shiftPlayerView( iDamage )
{
	if(iDamage == 0)
		return;
	// Make sure iDamage is between certain range
	if ( iDamage < 3 ) {
		iDamage = randomInt( 10 ) + 5;
	} else if ( iDamage > 45 ) {
		iDamage = 45;
	} else {
		iDamage = int( iDamage );
	}

	// Calculate how much the view will shift
	xShift = randomInt( iDamage ) - randomInt( iDamage );
	yShift = randomInt( iDamage ) - randomInt( iDamage );

	// Shift the player's view
	self setPlayerAngles( self.angles + (xShift, yShift, 0) );

	return;
}


weaponDrop()
{
	// Only allow to drop the weapon after the grace period has ended
	if ( !level.inGracePeriod ) {
		// Make sure it's a weapon they can drop
		currentWeapon = self getCurrentWeapon();

		if ( isSubStr( currentWeapon, "_bipod_" ) && self getVelocity() == (0,0,0) )
			return;
			
		if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( currentWeapon ) || maps\mp\gametypes\_weapons::isPistol( currentWeapon ) ) {
			self dropItem( currentWeapon );
		}
	}

	return;
}


gameTypeDialog( gametype )
{
	// Add more detail to the type of game being played
	if ( level.scr_tactical == 1 ) {
		gametype += ";tactical";
	} else if ( level.oldschool == 1 ) {
		gametype += ";oldschool";
	} else if ( level.hardcoreMode == 1 ) {
		gametype += ";hardcore";
	}

	return gametype;
}


isSpectating()
{
   return ( self.pers["team"] == "spectator" );
}

rulesetDvar( varName, varValue )
{
	// Store the variable for in-game monitoring
	if ( !isDefined( level.dvarMonitor ) )
		level.dvarMonitor = [];

	// Set the variable value
	setDvar( varName, varValue );	
	
	// Store the new variable in the array
	newElement = level.dvarMonitor.size;
	level.dvarMonitor[newElement]["name"] = varName;
	level.dvarMonitor[newElement]["value"] = getDvar( varName );
}


isPlayerClanMember( clanTags )
{
	// Search each tag in the player's name
	for ( tagx = 0; tagx < clanTags.size; tagx++ ) {
		if ( issubstr( self.name, clanTags[tagx] ) ) {
			return (1);
		}
	}

	return (0);
}

isPlayerMP( mpTags )
{
	// Search each tag in the player's name
	for ( tagx = 0; tagx < mpTags.size; tagx++ ) {
		if ( issubstr( self.name, mpTags[tagx] ) ) {
			return (1);
		}
	}

	return (0);
}

isPlayerNearTurret()
{
	// If turrets were removed then there's no way player can be next to one
	if ( level.scr_allow_stationary_turrets == 0 ) {
		return false;
	} else {
		// Classes for turrets (this way if something new comes out we just need to add an entry to the array)
		turretClasses = [];
		turretClasses[0] = "misc_turret";
		turretClasses[1] = "misc_mg42";
	
		// Cycle all the classes used by turrets
		for ( classix = 0; classix < turretClasses.size; classix++ )
		{
			// Get an array of entities for this class
			turretEntities = getentarray( turretClasses[ classix ], "classname" );
	
			// Cycle and check if the player is touching the trigger of the entity
			if ( isDefined ( turretEntities ) ) {
				for ( turretix = 0; turretix < turretEntities.size; turretix++ ) {
					if ( self isTouching( turretEntities[ turretix ] ) ) {
						return true;
					}
				}
			}
		}
		return false;
	}	
}


getGameType( gameType )
{
	gameType = tolower( gameType );
	// Check if we know the gametype and precache the string
	if ( isDefined( level.supportedGametypes[ gameType ] ) ) {
		gameType = level.supportedGametypes[ gameType ];
	}

	return gameType;
}


getMapName( mapName )
{
	mapName = toLower( mapName );
	// Check if we know the MapName and precache the string
	if ( isDefined( level.stockMapNames[ mapName ] ) ) {
		mapName = level.stockMapNames[ mapName ];
	} else if ( isDefined( level.customMapNames[ mapname ] ) ) {
		mapName = level.customMapNames[ mapName ];		
	}

	return mapName;
}


switchPlayerTeam( newTeam, halfTimeSwitch )
{
	if ( newTeam != self.pers["team"] && ( self.sessionstate == "playing" || self.sessionstate == "dead" ) )
	{
		self.switching_teams = true;
		self.joining_team = newTeam;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	// Change the player to the new team
	self.pers["team"] = newTeam;
	self.team = newTeam;
	self.pers["savedmodel"] = undefined;
	self.pers["teamTime"] = undefined;

	if ( level.teamBased ) {
		self.sessionteam = newTeam;
	} else {
		self.sessionteam = "none";
	}

	// Check if we need to enforce a class reset
	resetClass = self resetPlayerClassOnTeamSwitch( halfTimeSwitch );
	if ( resetClass ) {
		self.pers["weapon"] = undefined;
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["spawnweapon"] = undefined;
	}
	
	self maps\mp\gametypes\_globallogic::updateObjectiveText();
	
	// Log in the system log the team switch
	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpselfteam = newTeam;
	lpselfguid = self getGuid();
	logPrint( "JT;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + "\n" );	
	
	// Notify other modules about the team switch
	self notify("joined_team");
	if ( !halfTimeSwitch ) {
		self thread maps\mp\gametypes\_globallogic::showPlayerJoinedTeam();
	}
	self notify("end_respawn");

	if ( resetClass ) {
		self maps\mp\gametypes\_globallogic::beginClassChoice();
		self setclientdvar( "g_scriptMainMenu", game[ "menu_class_" + self.pers["team"] ] );
	}
}


resetPlayerClassOnTeamSwitch( halfTimeSwitch )
{
	// If the server is ranked there's no need to reset
	if ( level.rankedMatch || !isDefined( self.pers["class"] ) )
		return false;
	
	// Check non-class dependent limits
	if ( !halfTimeSwitch && game["perk_specialty_weapon_bouncing_betty_limit"] != 0 && game["perk_specialty_weapon_bouncing_betty_limit"] != 64 && self.specialty[0] == "satchel_charge_mp" )
		return true;
	if ( !halfTimeSwitch && game["perk_specialty_weapon_flamethrower_limit"] != 0 && game["perk_specialty_weapon_flamethrower_limit"] != 64 && self.specialty[0] == "m2_flamethrower_mp" )
		return true;		
	if ( !halfTimeSwitch && game["perk_specialty_weapon_bazooka_limit"] != 0 && game["perk_specialty_weapon_bazooka_limit"] != 64 && self.specialty[0] == "bazooka_mp" )
		return true;	
	if ( !halfTimeSwitch && game["perk_specialty_weapon_satchel_charge_limit"] != 0 && game["perk_specialty_weapon_satchel_charge_limit"] != 64 && self.specialty[0] == "satchel_charge_mp" )
		return true;			
	if ( !halfTimeSwitch && game["m8_white_smoke_limit"] != 0 && game["m8_white_smoke_limit"] != 64 && self.pers[self.pers["class"]]["loadout_sgrenade"] == "m8_white_smoke" )
		return true;		
	
	// Check class dependent weapons
	for ( i=0; i < game["mwf_weapons_aux"][self.pers["class"]].size; i++ ) {
		// If any weapon in this class can be used only by certain teams/countries the player needs to select a class again
		if ( game["mwf_weapons"][self.pers["class"]][i]["allow"] > 1 ) {
			return true;
		}
	}
				
	// Check class dependent limits
	switch ( self.pers["class"] ) {
		case "grenadier":
			if ( ( !halfTimeSwitch && game[ self.team + "_grenadier_limit"] != 0 && game[ self.team + "_grenadier_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_grenadier_limit"] != game[ "axis_grenadier_limit"] ) )
				return true;
			if ( !halfTimeSwitch && game["attach_gl_limit"] != 0 && game["attach_gl_limit"] != 64 && self.pers["grenadier"]["loadout_primary_attachment"] == "gl" )
				return true;
			break;

		case "rifleman":
			if ( ( !halfTimeSwitch && game[ self.team + "_rifleman_limit"] != 0 && game[ self.team + "_rifleman_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_rifleman_limit"] != game[ "axis_rifleman_limit"] ) )
				return true;
			if ( !halfTimeSwitch && game["attach_gl_limit"] != 0 && game["attach_gl_limit"] != 64 && self.pers["rifleman"]["loadout_primary_attachment"] == "gl" )
				return true;
			break;
						
		case "lightgunner":
			if ( ( !halfTimeSwitch && game[ self.team + "_lightgunner_limit"] != 0 && game[ self.team + "_lightgunner_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_lightgunner_limit"] != game[ "axis_lightgunner_limit"] ) )
				return true;			
			break;
			
		case "heavygunner":
			if ( ( !halfTimeSwitch && game[ self.team + "_heavygunner_limit"] != 0 && game[ self.team + "_heavygunner_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_heavygunner_limit"] != game[ "axis_heavygunner_limit"] ) )
				return true;			
			break;
			
		case "closeassault":
			if ( ( !halfTimeSwitch && game[ self.team + "_closeassault_limit"] != 0 && game[ self.team + "_closeassault_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_closeassault_limit"] != game[ "axis_closeassault_limit"] ) )
				return true;			
			break;
			
		case "sniper":
			if ( ( !halfTimeSwitch && game[ self.team + "_sniper_limit"] != 0 && game[ self.team + "_sniper_limit"] != 64 ) || ( halfTimeSwitch && game[ "allies_sniper_limit"] != game[ "axis_sniper_limit"] ) )
				return true;			
			break;
	}
	
	return false;	
}


waitAndSendEvent( timeToWait, eventToSend )
{
	self endon( eventToSend );
	
	xWait(timeToWait );
	self notify( eventToSend );	
}

checkNadeType( nadeType )
{
	
	// Get player's team and country
	playerTeam = self.pers["team"];
	if ( playerTeam == "allies" ) {
		playerCountry = game["allies"];
	} else {
		playerCountry = game["axis"];
	}
	switch ( playerCountry )
	{
		case "marines":
			nadeType = "frag_grenade_mp";
			break;
		case "russian":
			nadeType = "frag_grenade_rus_mp";
			break;
		case "german":
			nadeType = "frag_grenade_ger_mp";
			break;
		case "japanese":
			nadeType = "frag_grenade_jap_mp";
			break;
	}
	
	return nadeType;
}	

/*checkProjType( proWeapon )
{
	
	// Get player's team and country
	playerTeam = self.pers["team"];
	if ( playerTeam == "allies" ) {
		playerCountry = game["allies"];
	} else {
		playerCountry = game["axis"];
	}
	switch ( playerCountry )
	{
		case "marines":
			proWeapon = "bazooka_mp";
			break;
		case "russian":
			proWeapon = "bazooka_mp";
			break;
		case "german":
			proWeapon = "panzerschrek_mp";
			break;
		case "japanese":
			proWeapon = "bazooka_mp";
			break;
	}
	
	return proWeapon;
}
*/