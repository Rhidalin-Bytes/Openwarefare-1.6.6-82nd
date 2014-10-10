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
	// Initialize the arrays to hold the gametype names and stock map names
	initGametypesAndMaps();

	// Do not thread these initializations
	openwarfare\_eventmanager::eventManagerInit();
			
	// Initialize OpenWarfare modules
	thread openwarfare\_advancedacp::init();
	thread openwarfare\_advancedmvs::init();		
	thread openwarfare\_antibunnyhopping::init();
	thread openwarfare\_anticamping::init();
	thread openwarfare\_bigbrotherbot::init();
	thread openwarfare\_binoculars::init();
	thread openwarfare\_blackscreen::init();
	thread openwarfare\_bloodsplatters::init();
	thread openwarfare\_bodyremoval::init();
	thread openwarfare\_clanvsall::init();
	thread openwarfare\_caceditor::init();
	thread openwarfare\_capeditor::init();
	thread openwarfare\_damageeffect::init();
	thread openwarfare\_daycyclesystem::init();
	thread openwarfare\_disarmexplosives::init();
	thread openwarfare\_dogtags::init();	
	thread openwarfare\_dvarmonitor::init();
	thread openwarfare\_dynamicattachments::init();
	thread openwarfare\_extendedobituaries::init();
	thread openwarfare\_fitnesscs::init();		
	thread openwarfare\_globalchat::init();
	thread openwarfare\_guidcs::init();		
	thread openwarfare\_healthsystem::init();
	thread openwarfare\_hidescores::init();
	thread openwarfare\_idlemonitor::init();
	thread openwarfare\_keybinds::init();		
	thread openwarfare\_killingspree::init();
	thread openwarfare\_limitexplosives::init();
	thread openwarfare\_maprotationcs::init();
	thread openwarfare\_martyrdom::init();
	thread openwarfare\_objoptions::init();
	thread openwarfare\_overtime::init();
	thread openwarfare\_owbattlechatter::init();
	thread openwarfare\_paindeathsounds::init();
	thread openwarfare\_playerdvars::init();
	thread openwarfare\_powerrank::init();
	thread openwarfare\_quickactions::init();
	thread openwarfare\_rangefinder::init();
	thread openwarfare\_realtimestats::init();
	thread openwarfare\_reservedslots::init();
	thread openwarfare\_rng::init();
	thread openwarfare\_rotateifempty::init();
	thread openwarfare\_rsmonitor::init();
	thread openwarfare\_scorebot::init();
	thread openwarfare\_scoresystem::init();
	thread openwarfare\_serverbanners::init();
	thread openwarfare\_servermessages::init();
	thread openwarfare\_sniperzoom::init();
	thread openwarfare\_spawnprotection::init();
	thread openwarfare\_speedcontrol::init();		
	thread openwarfare\_sponsors::init();
	thread openwarfare\_stationaryturrets::init();
	thread openwarfare\_teamstatus::init();
	thread openwarfare\_testbots::init();
	thread openwarfare\_thirdperson::init();
	thread openwarfare\_timeout::init();
	thread openwarfare\_timer::init();
	thread openwarfare\_tkmonitor::init();
	thread openwarfare\_virtualranks::init();
	thread openwarfare\_weapondamagemodifier::init();
	thread openwarfare\_weaponjam::init();
	thread openwarfare\_weaponlocationmodifier::init();
	thread openwarfare\_weaponrangemodifier::init();
	thread openwarfare\_weaponweightmodifier::init();
	thread openwarfare\_welcomerulesinfo::init();
	thread openwarfare\_weaponfiremode::init();
}



initGametypesAndMaps()
{
	// ********************************************************************
	// WE DO NOT USE LOCALIZED STRINGS TO BE ABLE TO USE THEM IN MENU FILES
	// ********************************************************************

	// Define some default values for other modules
	level.defaultGametypeList = "ass;bel;ch;ctf;dom;dm;ftag;gg;koth;lms;lts;re;sab;sd;tdm;twar"; 
	level.defaultMapList = "mp_airfield;mp_asylum;mp_kwai;mp_drum;mp_bgate;mp_castle;mp_shrine;mp_stalingrad;mp_courtyard;mp_dome;mp_downfall;mp_hangar;mp_kneedeep;mp_makin;mp_makin_day;mp_nachtfeuer;mp_outskirts;mp_vodka;mp_roundhouse;mp_seelow;mp_subway;mp_docks;mp_suburban";

	// Load all the gametypes we currently support
	level.supportedGametypes = [];
	level.supportedGametypes["ass"] = "Assassination";
	level.supportedGametypes["bel"] = "Behind Enemy Lines";
	level.supportedGametypes["ch"] = "Capture and Hold";
	level.supportedGametypes["ctf"] = "Capture the Flag";
	level.supportedGametypes["dm"] = "Free for All";
	level.supportedGametypes["dom"] = "Domination";
	level.supportedGametypes["ftag"] = "Freeze Tag";
	level.supportedGametypes["gg"] = "Gun Game";
	level.supportedGametypes["koth"] = "Headquarters";
	level.supportedGametypes["lms"] = "Last Man Standing";
	level.supportedGametypes["lts"] = "Last Team Standing";
	level.supportedGametypes["re"] = "Retrieval";	
	level.supportedGametypes["sab"] = "Sabotage";
	level.supportedGametypes["sd"] = "Search and Destroy";
	level.supportedGametypes["tdm"] = "Team Deathmatch";
	level.supportedGametypes["twar"] = "War";
	
	// Gametypes in capitalized form
	level.supportedGametypesCaps = [];
	level.supportedGametypesCaps["ass"] = "ASSASSINATION";
	level.supportedGametypesCaps["bel"] = "BEHIND ENEMY LINES";
	level.supportedGametypesCaps["ch"] = "CAPTURE AND HOLD";
	level.supportedGametypesCaps["ctf"] = "CAPTURE THE FLAG";
	level.supportedGametypesCaps["dm"] = "FREE FOR ALL";
	level.supportedGametypesCaps["dom"] = "DOMINATION";
	level.supportedGametypesCaps["ftag"] = "FREEZE TAG";
	level.supportedGametypesCaps["gg"] = "GUN GAME";
	level.supportedGametypesCaps["koth"] = "HEADQUARTERS";
	level.supportedGametypesCaps["lms"] = "LAST MAN STANDING";
	level.supportedGametypesCaps["lts"] = "LAST TEAM STANDING";	
	level.supportedGametypesCaps["re"] = "RETRIEVAL";	
	level.supportedGametypesCaps["sab"] = "SABOTAGE";
	level.supportedGametypesCaps["sd"] = "SEARCH AND DESTROY";
	level.supportedGametypesCaps["tdm"] = "TEAM DEATHMATCH";
	level.supportedGametypesCaps["twar"] = "WAR";
	
	// Load the name of the stock maps
	level.stockMapNames = [];
	level.stockMapNames["mp_airfield"] = "Airfield";
	level.stockMapNames["mp_asylum"] = "Asylum";
	level.stockMapNames["mp_kwai"] = "Banzai";
	level.stockMapNames["mp_drum"] = "Battery";
	level.stockMapNames["mp_bgate"] = "Breach";
	level.stockMapNames["mp_castle"] = "Castle";
	level.stockMapNames["mp_shrine"] = "Cliffside";
	level.stockMapNames["mp_stalingrad"] = "Corrosion";	
	level.stockMapNames["mp_courtyard"] = "Courtyard";
	level.stockMapNames["mp_dome"] = "Dome";
	level.stockMapNames["mp_downfall"] = "Downfall";
	level.stockMapNames["mp_hangar"] = "Hangar";
	level.stockMapNames["mp_kneedeep"] = "Knee Deep";	
	level.stockMapNames["mp_makin"] = "Makin";
	level.stockMapNames["mp_makin_day"] = "Makin Day";
	level.stockMapNames["mp_nachtfeuer"] = "Nightfire";
	level.stockMapNames["mp_outskirts"] = "Outskirts";
	level.stockMapNames["mp_vodka"] = "Revolution";
	level.stockMapNames["mp_roundhouse"] = "Roundhouse";
	level.stockMapNames["mp_seelow"] = "Seelow";
	level.stockMapNames["mp_subway"] = "Station";
	level.stockMapNames["mp_docks"] = "Sub Pens";
	level.stockMapNames["mp_suburban"] = "Upheaval";
	
	// Maps in capitalized form
	level.stockMapNamesCaps = [];
	level.stockMapNamesCaps["mp_airfield"] = "AIRFIELD";
	level.stockMapNamesCaps["mp_asylum"] = "ASYLUM";
	level.stockMapNamesCaps["mp_kwai"] = "BANZAI";
	level.stockMapNamesCaps["mp_drum"] = "BATTERY";
	level.stockMapNamesCaps["mp_bgate"] = "BREACH";
	level.stockMapNamesCaps["mp_castle"] = "CASTLE";
	level.stockMapNamesCaps["mp_shrine"] = "CLIFFSIDE";
	level.stockMapNamesCaps["mp_stalingrad"] = "CORROSION";	
	level.stockMapNamesCaps["mp_courtyard"] = "COURTYARD";
	level.stockMapNamesCaps["mp_dome"] = "DOME";
	level.stockMapNamesCaps["mp_downfall"] = "DOWNFALL";
	level.stockMapNamesCaps["mp_hangar"] = "HANGAR";
	level.stockMapNamesCaps["mp_kneedeep"] = "KNEE DEEP";	
	level.stockMapNamesCaps["mp_makin"] = "MAKIN";
	level.stockMapNamesCaps["mp_makin_day"] = "MAKIN DAY";
	level.stockMapNamesCaps["mp_nachtfeuer"] = "NIGHTFIRE";
	level.stockMapNamesCaps["mp_outskirts"] = "OUTSKIRTS";
	level.stockMapNamesCaps["mp_vodka"] = "REVOLUTION";
	level.stockMapNamesCaps["mp_roundhouse"] = "ROUNDHOUSE";
	level.stockMapNamesCaps["mp_seelow"] = "SEELOW";
	level.stockMapNamesCaps["mp_subway"] = "STATION";
	level.stockMapNamesCaps["mp_docks"] = "SUB PENS";
	level.stockMapNamesCaps["mp_suburban"] = "UPHEAVAL";
}
