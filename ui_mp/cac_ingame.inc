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

// general definitions

#define CHOICE_X_START			40
#define CHOICE_Y_START			34

#define CHOICE_SEP_1			5
#define CHOICE_SEP_2			9

#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"
 
#define ORIGIN_STATUS			390 64
#define MENU_FONT_COLOR2		1 1 1 0.5

#include "ui_mp/stats_info.inc"
#include "ui_mp/overlaybg.inc"

	// ========================== Perk 1 special cases ===========================
	#define UPDATE_PERK1 \
		execOnDvarStringValue loadout_primary_attachment gl "set loadout_perk1_locked 1;set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_primary_attachment grip "set loadout_perk1_locked 1;set loadout_perk1 specialty_null"; \
		execOnDvarStringValue loadout_primary_attachment none "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment aperture "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment bayonet "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment bigammo "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment bipod "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment flash "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment scoped "set loadout_perk1_locked 0"; \				
		execOnDvarStringValue loadout_primary_attachment silenced "set loadout_perk1_locked 0"; \
		execOnDvarStringValue loadout_primary_attachment telescopic "set loadout_perk1_locked 0";


	menuDef	{
		name			CAC_MENU_NAME
		rect			0 0 640 480 HORIZONTAL_ALIGN_FULLSCREEN VERTICAL_ALIGN_FULLSCREEN
		focuscolor		COLOR_FOCUSED
		style			WINDOW_STYLE_EMPTY
		blurWorld		7.0
		onOpen {			
			setfocus primary_weapon_selection;
			UPDATE_PERK1;
		}
		onEsc {
			scriptMenuResponse "back";
		}

		// background from overlaybg.inc
		BACKGROUND_BLACK_LETTERBOX_BLURWORLD( 1.0 )
		OVERLAY_BACKGROUND

		// ------------------  statics ------------------------

		CHOICE_MENU_TITLE( "@MPUI_CREATE_A_CLASS_CAP" )				
		// ------------------------- buttons ------------------------------
		#define BACK_OPEN ;
		#include "ui_mp/navcontrols.inc"
		#include "ui_mp/teamicon.inc"		
		
		//=========================================================
		//===================== MENU SELECTION ====================
		//=========================================================
		
		// PRIMARY WEAPON BUTTON =============================================================
		#define CAC_SETUP_ACTION1 \
			exec "set ui_menu_selection_title @MPUI_PRIMARY_WEAPON"; \
			play "mouse_click"; \
			execOnDvarStringValue loadout_class grenadier "set selected_weapon_class grenadier;set ui_weapon_class_selected @CLASS_GRENADIER"; \
			execOnDvarStringValue loadout_class rifleman "set selected_weapon_class rifleman;set ui_weapon_class_selected @CLASS_CLASS1"; \
			execOnDvarStringValue loadout_class lightgunner "set selected_weapon_class lightgunner;set ui_weapon_class_selected @CLASS_CLASS2"; \
			execOnDvarStringValue loadout_class heavygunner "set selected_weapon_class heavygunner;set ui_weapon_class_selected @CLASS_CLASS3"; \
			execOnDvarStringValue loadout_class closeassault "set selected_weapon_class closeassault;set ui_weapon_class_selected @CLASS_CLASS4"; \
			execOnDvarStringValue loadout_class sniper "set selected_weapon_class sniper;set ui_weapon_class_selected @CLASS_CLASS5"; \
			uiScript openMenuOnDvar loadout_class grenadier "ocd_popup_cac_grenadier"; \
			uiScript openMenuOnDvar loadout_class rifleman "ocd_popup_cac_rifleman"; \
			uiScript openMenuOnDvar loadout_class lightgunner "ocd_popup_cac_lightgunner"; \
			uiScript openMenuOnDvar loadout_class heavygunner "ocd_popup_cac_heavygunner"; \
			uiScript openMenuOnDvar loadout_class closeassault "ocd_popup_cac_closeassault"; \
			uiScript openMenuOnDvar loadout_class sniper "ocd_popup_cac_sniper";
		
		CHOICE_BUTTON_BG( 1, 1 )
		CHOICE_HIGHLIGHT( 1, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 1, "@MPUI_PRIMARY_WEAPON1", CAC_SETUP_ACTION1, when( !dvarBool( lock_primary ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 1, "@MPUI_PRIMARY_WEAPON1", when( dvarBool( lock_primary ) ) )
		//CHOICE_BUTTON_EX( 1, "@MPUI_PRIMARY_WEAPON1", CAC_SETUP_ACTION1, name primary_weapon_selection )

		#define CAC_SETUP_ACTION_ATTACHMENT \
		  exec "set ui_menu_selection_title @PERKS_ATTACHMENT"; \
			play "mouse_click"; \
			uiScript openMenuOnDvar loadout_subclass grenadier1 "ocd_attachment_popup_grenadier1"; \
			uiScript openMenuOnDvar loadout_subclass rifleman1 "ocd_attachment_popup_rifleman1"; \
			uiScript openMenuOnDvar loadout_subclass rifleman2 "ocd_attachment_popup_rifleman2"; \
			uiScript openMenuOnDvar loadout_subclass rifleman3 "ocd_attachment_popup_rifleman3"; \
			uiScript openMenuOnDvar loadout_subclass rifleman4 "ocd_attachment_popup_rifleman4"; \			
			uiScript openMenuOnDvar loadout_subclass lightgunner1 "ocd_attachment_popup_lightgunner1"; \
			uiScript openMenuOnDvar loadout_subclass lightgunner2 "ocd_attachment_popup_lightgunner2"; \
			uiScript openMenuOnDvar loadout_subclass lightgunner3 "ocd_attachment_popup_lightgunner3"; \
			uiScript openMenuOnDvar loadout_subclass heavygunner1 "ocd_attachment_popup_heavygunner1"; \
			uiScript openMenuOnDvar loadout_subclass heavygunner2 "ocd_attachment_popup_heavygunner2"; \
			uiScript openMenuOnDvar loadout_subclass heavygunner3 "ocd_attachment_popup_heavygunner3"; \
			uiScript openMenuOnDvar loadout_subclass heavygunner4 "ocd_attachment_popup_heavygunner4"; \
			uiScript openMenuOnDvar loadout_subclass closeassault1 "ocd_attachment_popup_closeassault1"; \
			uiScript openMenuOnDvar loadout_subclass closeassault2 "ocd_attachment_popup_closeassault2"; 
			

		CHOICE_BUTTON_BG( 2, 1 )
		CHOICE_HIGHLIGHT( 2, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", CAC_SETUP_ACTION_ATTACHMENT, when( !dvarBool( lock_primary_attachment ) && dvarString( loadout_subclass ) != "none" ) )
		CHOICE_DBUTTON_VIS_NOHI( 2, "@PERKS_ATTACHMENT", when( dvarBool( lock_primary_attachment ) || dvarString( loadout_subclass ) == "none" ) )

		// SECONDARY WEAPON/SIDE ARM BUTTON =============================================================
		#define CAC_SETUP_ACTION2 \
			exec "set ui_menu_selection_title @MPUI_SIDE_ARM1"; \
			play "mouse_click"; \
			open "ocd_popup_cac_secondary";

		CHOICE_BUTTON_BG( 3, 1 )
		CHOICE_HIGHLIGHT( 3, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 3, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2, when( !dvarBool( lock_secondary ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 3, "@MPUI_SIDE_ARM1", when( dvarBool( lock_secondary ) ) )
		//CHOICE_BUTTON( 3, "@MPUI_SIDE_ARM1", CAC_SETUP_ACTION2 )

		// PRIMARY GRENADE BUTTON =============================================================
		#define CAC_SETUP_ACTION3 \
			exec "set ui_menu_selection_title @MPUI_PRIMARY_GRENADE"; \
			play "mouse_click"; \
			open "ocd_popup_cac_pgrenade";

		CHOICE_BUTTON_BG( 4, 1 )
		CHOICE_HIGHLIGHT( 4, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 4, "@MPUI_PRIMARY_GRENADE", CAC_SETUP_ACTION3, when( !dvarBool( lock_pgrenade ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 4, "@MPUI_PRIMARY_GRENADE", when( dvarBool( lock_pgrenade ) ) )	
		//CHOICE_BUTTON( 4, "@MPUI_PRIMARY_GRENADE", CAC_SETUP_ACTION3 )			
	
		// SPECIAL GRENADE BUTTON =============================================================
		#define CAC_SETUP_ACTION4 \
			exec "set ui_menu_selection_title @MPUI_SPECIAL_GRENADE"; \
			play "mouse_click"; \
			open "ocd_popup_cac_sgrenade";

		CHOICE_BUTTON_BG( 5, 1 )
		CHOICE_HIGHLIGHT( 5, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 5, "@MPUI_SPECIAL_GRENADE", CAC_SETUP_ACTION4, when( !dvarBool( lock_sgrenade ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 5, "@MPUI_SPECIAL_GRENADE", when( dvarBool( lock_sgrenade ) ) )	
		//CHOICE_BUTTON( 5, "@MPUI_SPECIAL_GRENADE", CAC_SETUP_ACTION4 )						

		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_1 )
				
		#define CAC_SETUP_ACTION5 \
			exec "set ui_menu_selection_title @MPUI_PERK_1"; \
			play "mouse_click"; \
			open "ocd_popup_cac_perk1";	
		
		// PERK 1 BUTTON =============================================================
		// perk 1 empty warning
		CHOICE_BUTTON_BG_RAW( 6, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk1 ) && dvarString(loadout_perk1) == "specialty_null" && !dvarBool(loadout_perk1_locked) ); )
		CHOICE_BUTTON_FOCUS_VIS_ADV( 6, "@MPUI_PERK_1", CAC_SETUP_ACTION5, ;, ;, when( !dvarBool( lock_perk1 ) && !dvarBool(loadout_perk1_locked) ), !dvarBool(loadout_perk1_locked) )

		CHOICE_BUTTON_FOCUS_VIS_NOHI( 6, "", ;, ;, ;, when( dvarBool( lock_perk1 ) || dvarBool(loadout_perk1_locked) ) )
		CHOICE_DBUTTON_VIS( 6, "@MPUI_PERK_1", when( dvarBool( lock_perk1 ) || dvarBool(loadout_perk1_locked) ) )

		// PERK 2 BUTTON =============================================================
		#define CAC_SETUP_ACTION6 \		
			exec "set ui_menu_selection_title @MPUI_PERK_2"; \
			play "mouse_click"; \
			open "ocd_popup_cac_perk2";		

		CHOICE_BUTTON_BG_RAW( 7, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk2 ) && dvarString(loadout_perk2) == "specialty_null" ); )
		CHOICE_BUTTON_BG( 7, 1 )
		CHOICE_HIGHLIGHT( 7, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 7, "@MPUI_PERK_2", CAC_SETUP_ACTION6, when( !dvarBool( lock_perk2 ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 7, "@MPUI_PERK_2", when( dvarBool( lock_perk2 ) ) )
		//CHOICE_BUTTON( 7, "@MPUI_PERK_2", CAC_SETUP_ACTION6 )
		
		// PERK 3 BUTTON =============================================================
		#define CAC_SETUP_ACTION7 \		
		  exec "set ui_menu_selection_title @MPUI_PERK_3"; \
			play "mouse_click"; \
			open "ocd_popup_cac_perk3";		

		CHOICE_BUTTON_BG_RAW( 8, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk3 ) && dvarString(loadout_perk3) == "specialty_null" ); )
		CHOICE_BUTTON_BG( 8, 1 )
		CHOICE_HIGHLIGHT( 8, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 8, "@MPUI_PERK_3", CAC_SETUP_ACTION7, when( !dvarBool( lock_perk3 ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 8, "@MPUI_PERK_3", when( dvarBool( lock_perk3 ) ) )
		//CHOICE_BUTTON( 8, "@MPUI_PERK_3", CAC_SETUP_ACTION7 )

		// PERK 4 (VEHICLE) BUTTON ===================================================
		#define CAC_SETUP_ACTION8 \		
			exec "set ui_menu_selection_title @MPUI_VEHICLE_PERK"; \
			play "mouse_click"; \
			open "ocd_popup_cac_perk4";		

		CHOICE_BUTTON_BG_RAW( 9, "gradient_fadein", 0.5 0.15 0 0.5, when( !dvarBool( lock_perk4 ) && dvarString(loadout_perk4) == "specialty_null" ); )
		CHOICE_BUTTON_BG( 9, 1 )
		CHOICE_HIGHLIGHT( 9, 1 )		
		CHOICE_BUTTON_VIS_NOHI( 9, "@MPUI_VEHICLE_PERK", CAC_SETUP_ACTION8, when( !dvarBool( lock_perk4 ) ) )
		CHOICE_DBUTTON_VIS_NOHI( 9, "@MPUI_VEHICLE_PERK", when( dvarBool( lock_perk4 ) ) )
		//CHOICE_BUTTON( 9, "@MPUI_VEHICLE_PERK", CAC_SETUP_ACTION8 )
		
		/* separator bar */ CHOICE_SEPARATOR( CHOICE_SEP_2 )

		#define CAC_SETUP_ACTIONGO \		
			play "mouse_click"; \
			scriptMenuResponse "go";

		CHOICE_BUTTON( 10, "@MENU_ACCEPT", CAC_SETUP_ACTIONGO )
				
		/* ================================================================================= */
		/* ================================ LOADOUT DISPLAY ================================ */
		/* ================================================================================= */

		#define STAT_CAC_PRIMARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_primary ), 0)
		#define STAT_CAC_PRIMARY_ATTACHMENT		tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_primary_attachment ), 9)
		#define STAT_CAC_SECONDARY				tableLookup("mp/statstable.csv", 4, dvarString( loadout_secondary ), 0)
		#define STAT_CAC_SECONDARY_ATTACHMENT	tableLookup("mp/attachmentTable.csv", 4, dvarString( loadout_secondary_attachment ), 9)
		#define STAT_CAC_SPECIALTY_EQUIPMENT	tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk1 ), 0)
		#define STAT_CAC_SPECIALTY_WEAPON		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk2 ), 0)
		#define STAT_CAC_SPECIALTY_ABILITY		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk3 ), 0)
		#define STAT_CAC_SPECIALTY_VEHICLE		tableLookup("mp/statstable.csv", 4, dvarString( loadout_perk4 ), 0)
		#define STAT_CAC_PRIMARY_GRENADE		tableLookup("mp/statstable.csv", 4, dvarString( loadout_pgrenade ), 0)
		#define STAT_CAC_SPECIAL_GRENADE		tableLookup("mp/statstable.csv", 4, dvarString( loadout_sgrenade ), 0)
		
		#include "ui_mp/cac_loadout_ingame.inc"
		CAC_LOADOUT_CAC_TITLE1
		CAC_LOADOUT_NORMAL
		CAC_LOADOUT_ATTRIBUTES
		
		#include "ui/safearea.menu"
	}

	// close all 2nd and 3rd layer popups on end action
	#define PREPROC_ATTACH_CLOSEALL \
	close "ocd_popup_cac_grenadier"; \
	close "ocd_popup_cac_rifleman"; \
	close "ocd_popup_cac_lightgunner"; \
	close "ocd_popup_cac_heavygunner"; \
	close "ocd_popup_cac_closeassault"; \
	close "ocd_popup_cac_sniper"; \
	close "ocd_popup_cac_secondary"; \
	close "ocd_popup_cac_pgrenade"; \
	close "ocd_popup_cac_sgrenade"; \
	close "ocd_popup_cac_perk1"; \
	close "ocd_popup_cac_perk2"; \
	close "ocd_popup_cac_perk3"; \
	close "ocd_popup_cac_perk4"; \
	close "ocd_attachment_popup_grenadier1"; \	
	close "ocd_attachment_popup_rifleman1"; \
	close "ocd_attachment_popup_rifleman2"; \
	close "ocd_attachment_popup_rifleman3"; \
	close "ocd_attachment_popup_rifleman4"; \
	close "ocd_attachment_popup_lightgunner1"; \
	close "ocd_attachment_popup_lightgunner2"; \
	close "ocd_attachment_popup_lightgunner3"; \
	close "ocd_attachment_popup_heavygunner1"; \
	close "ocd_attachment_popup_heavygunner2"; \
	close "ocd_attachment_popup_heavygunner3"; \
	close "ocd_attachment_popup_heavygunner4"; \
	close "ocd_attachment_popup_closeassault1"; \	
	close "ocd_attachment_popup_closeassault2";
	
	// including weapon data
	#include "ui_mp/weaponinfo.menu"
	
	#include "ui_mp/popupstyle.inc"	
	#include "ui/choices_setup_popmenu.menu"
	
	#undef CHOICE_SIZE_X
	#define CHOICE_SIZE_X			216
	
	#undef NEW_X_OFFSET			
	#define NEW_X_OFFSET	(0-CHOICE_SIZE_X)
	
	#undef NEW_Y_OFFSET			
	#define NEW_Y_OFFSET	(0-2)

	// ====================================================================================================
	// primary weapon selection ===========================================================================
	// ====================================================================================================
	#define LOCAL_WEAPON_INFO_WINDOW( highlight_dvar ) \
		/* weapon image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( (LOADOUT_IMAGE_X-45) LOADOUT_IMAGE_Y 180 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, 0 0 0 0 visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_primary_hl_unlocked ) ); )
	

	#define LOCAL_PRIMARY_WEAPON_ACTION( suffix, weapClass, weapRef ) \
		play "mouse_click"; \
		execOnDvarStringValue loadout_primary_attachment gl ""; \
		scriptMenuResponse "loadout_primary:"weapRef;\
		setdvar loadout_primary weapRef; \
		PREPROC_ATTACH_CLOSEALL

	#define WI_FOCUS_ACTION( weaponRef, weaponClass ) \
		execOnDvarStringValue "weap_allow_"weaponClass"_"weaponRef 0 "set ui_primary_hl_unlocked 0";\
		execOnDvarStringValue "weap_allow_"weaponClass"_"weaponRef 1 "set ui_primary_hl_unlocked 1";\
		exec "set ui_primary_highlighted "weaponRef;
	
	// hacked to hide the second primary if same weapon is selected in first primary, change weapon description to "Already selected"
	#define LOCAL_WEAPON_ITEM( suffix, itemNum, weaponName, weaponClass, weaponRef )\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, WI_FOCUS_ACTION( weaponRef, weaponClass ), ;, when( !dvarBool( "weap_allow_"weaponClass"_"weaponRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( !dvarBool( "weap_allow_"weaponClass"_"weaponRef ) ); ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_PRIMARY_WEAPON_ACTION( suffix, weaponClass, weaponRef ), \
		WI_FOCUS_ACTION( weaponRef, weaponClass ), ;, when( dvarBool( "weap_allow_"weaponClass"_"weaponRef ) );, \		
		dvarBool( "weap_allow_"weaponClass"_"weaponRef ) ) \

	// primary weapon class dropdown
	menuDef
	{
		IMPROVED_POPUP_SETUP_ONOPEN( "ocd_popup_cac_primary", 5, (CHOICE_X( 1 )-2), (CHOICE_Y( 1 )-4), ;, execnow "set ui_inside_popup weapon_class; set ui_show_preview 1";, 1 )
		onClose{	execnow "set ui_show_preview 0; set ui_primary_highlighted 0; set ui_attachment_highlighted 0" }
		
		#define LOCAL_WEAPON_CLASS( itemNum, ptext, plabel ) \
			CHOICE_BUTTON_EX( itemNum, plabel, play "mouse_click"; execnow "set selected_weapon_class "ptext"; set ui_weapon_class_selected "plabel; open "ocd_popup_cac_"ptext;, name ptext )

		LOCAL_WEAPON_CLASS( 1, "grenadier", "@CLASS_GRENADIER" )
		LOCAL_WEAPON_CLASS( 2, "rifleman", "@CLASS_CLASS1" )
		LOCAL_WEAPON_CLASS( 3, "lightgunner", "@CLASS_CLASS2" )
		LOCAL_WEAPON_CLASS( 4, "heavygunner", "@CLASS_CLASS3" )
		LOCAL_WEAPON_CLASS( 5, "closeassault", "@CLASS_CLASS4" )
		LOCAL_WEAPON_CLASS( 6, "sniper", "@CLASS_CLASS5" )	
	}

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_primary_highlighted"

	// primary weapon items
	#define LOCAL_MASTER_WEAPON_GROUP( suffix, pos, y_offset )\
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_grenadier"suffix, execnow "set "UI_FOCUSFIRST" "REF_SPRINGFIELD"; set ui_inside_popup grenadier", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SPRINGFIELD", "grenadier", REF_SPRINGFIELD )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_TYPE99_RIFLE", "grenadier", REF_TYPE99_RIFLE )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_MOSIN_RIFLE", "grenadier", REF_MOSIN )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_KAR98K", "grenadier", REF_KAR98K )\
	}\	
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_rifleman"suffix, execnow "set "UI_FOCUSFIRST" "REF_SVT40"; set ui_inside_popup rifleman", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SVT40", "rifleman", REF_SVT40 )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_GEWEHR43", "rifleman", REF_GEWEHR43 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_M1GARAND", "rifleman", REF_M1GARAND )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_M1A1CARBINE", "rifleman", REF_M1A1CARBINE )\
	}\	
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_lightgunner"suffix, execnow "set "UI_FOCUSFIRST" "REF_THOMPSON";set ui_inside_popup lightgunner", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_THOMPSON", "lightgunner", REF_THOMPSON )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_MP40", "lightgunner", REF_MP40 )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_TYPE100_SMG", "lightgunner", REF_TYPE100_SMG )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_PPSH", "lightgunner", REF_PPSH )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_STG-44", "lightgunner", REF_STG44 )\
	}\
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_heavygunner"suffix, execnow "set "UI_FOCUSFIRST" "REF_BAR"; set ui_inside_popup heavygunner", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_TYPE99_LMG", "heavygunner", REF_TYPE99_LMG )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_BAR", "heavygunner", REF_BAR )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_DP28", "heavygunner", REF_DP28 )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_MG42", "heavygunner", REF_MG42 )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_FG42", "heavygunner", REF_FG42 )\
		LOCAL_WEAPON_ITEM( suffix, 6, "@WEAPON_30CAL", "heavygunner", REF_30CAL )\
	}\	
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_closeassault"suffix, execnow "set "UI_FOCUSFIRST" "REF_SHOTGUN"; set ui_inside_popup closeassault", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SHOTGUN", "closeassault", REF_SHOTGUN )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_SHOTGUN_DOUBLE_BARRELED", "closeassault", REF_DOUBLE_BARRELED_SHOTGUN )\
	}\
	menuDef	{\
		CAC_POPUP_SWAP( "ocd_popup_cac_sniper"suffix, execnow "set "UI_FOCUSFIRST" "REF_SPRINGFIELD"; set ui_inside_popup sniper", ; )\
		LOCAL_WEAPON_INFO_WINDOW( "ui_primary_highlighted" )\
		LOCAL_WEAPON_ITEM( suffix, 1, "@WEAPON_SPRINGFIELD", "sniper", REF_SPRINGFIELD )\
		LOCAL_WEAPON_ITEM( suffix, 2, "@WEAPON_TYPE99_RIFLE", "sniper", REF_TYPE99_RIFLE )\
		LOCAL_WEAPON_ITEM( suffix, 3, "@WEAPON_MOSIN_RIFLE", "sniper", REF_MOSIN )\
		LOCAL_WEAPON_ITEM( suffix, 4, "@WEAPON_KAR98K", "sniper", REF_KAR98K )\
		LOCAL_WEAPON_ITEM( suffix, 5, "@WEAPON_M1GARAND", "sniper", REF_M1GARAND )\
		LOCAL_WEAPON_ITEM( suffix, 6, "@WEAPON_PTRS41", "sniper", REF_PTRS41 )\
	}	

	#undef CHOICE_X_START
	#define CHOICE_X_START			40

	#undef CHOICE_Y_START
	#define CHOICE_Y_START			115

	// primary and second primary weapon selection popup menus
	LOCAL_MASTER_WEAPON_GROUP( "", 1, 0 )
	
	// ====================================================================================================
	// primary and second primary attachment selection ====================================================
	// ====================================================================================================
	#define LOCAL_ATTACHMENT_INFO_WINDOW( pslot ) \
		/* attachment image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( LOADOUT_IMAGE_X LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),6), 1 1 1 1, 0, 2, 0 0 0 0 visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statsTable.csv",4,dvarString(ui_primary_highlighted),3)+"_"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),7), CHOICE_TEXTSIZE, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW visible when( dvarString(ui_inside_popup) != "camo" ); ) \
		/* attachment desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statsTable.csv",4,dvarString(ui_primary_highlighted),3)+"_"+tablelookup("mp/attachmentTable.csv",4,dvarString(ui_attachment_highlighted),7)+"_DESC", TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible when( dvarBool( ui_attachment_hl_unlocked ) ); )\

	#define LOCAL_ATTACHMENT_ACTION( attachmentDvar, attachmentName, paction, groupArg ) \
		setdvar loadout_primary_attachment attachmentName; \
		scriptMenuResponse "loadout_primary_attachment:"groupArg":"attachmentName;\
		UPDATE_PERK1 \
		PREPROC_ATTACH_CLOSEALL
		
	#define AI_FOCUS_ACTION( groupArg, weaponRef ) \
		execOnDvarStringValue "attach_allow_"groupArg"_"weaponRef 0 "set ui_attachment_hl_unlocked 0";\
		execOnDvarStringValue "attach_allow_"groupArg"_"weaponRef 1 "set ui_attachment_hl_unlocked 1";\
		exec "set ui_attachment_highlighted "weaponRef;

	#define LOCAL_ATTACHMENT_ITEM( itemNum, p_setstat, groupArg ,p_numref, pname, paction, ptype, statDvar, bitMask )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), LOCAL_ATTACHMENT_ACTION( statDvar, pname, paction, groupArg );, AI_FOCUS_ACTION(groupArg,pname), ;, when( ptype == "primary" && dvarBool( "attach_allow_"groupArg"_"pname ) ), ptype == "primary" && dvarBool( "attach_allow_"groupArg"_"pname ) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, AI_FOCUS_ACTION(groupArg,pname), ;, when( !dvarBool( "attach_allow_"groupArg"_"pname ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, "@"+tablelookup("mp/attachmentTable.csv",4,pname,3), when( !dvarBool( "attach_allow_"groupArg"_"pname ) ); )
		
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_attachment_highlighted"

	// primary and second primary attachment items
	#define LOCAL_MASTER_ATTACHMENT_GROUP( stat_slot, suffix, pos, ptype, y_offset, statDvar )\
	menuDef { /* springfield, kar98, mosinrifle, type99rifle attachments */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_grenadier1"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "grenadier", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "grenadier", NUM_ATTACHMENT2, "bayonet", ;, ptype, statDvar, BAYONET_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "grenadier", NUM_ATTACHMENT3, "gl", ;, ptype, statDvar, RG_NEW_BITMASK )\
	}\	
	menuDef { /* svt40 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_rifleman1"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "rifleman", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "rifleman", NUM_ATTACHMENT1, "flash", ;, ptype, statDvar, FLASH_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "rifleman", NUM_ATTACHMENT2, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "rifleman", NUM_ATTACHMENT3, "telescopic", ;, ptype, statDvar, TELESCOPIC_NEW_BITMASK )\
	}\
	menuDef { /* gewehr43 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_rifleman2"suffix,  execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "rifleman", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "rifleman", NUM_ATTACHMENT1, "silenced", ;, ptype, statDvar, SILENCED_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "rifleman", NUM_ATTACHMENT2, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "rifleman", NUM_ATTACHMENT3, "telescopic", ;, ptype, statDvar, TELESCOPIC_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 5, stat_slot, "rifleman", NUM_ATTACHMENT4, "gl", ;, ptype, statDvar, RG_NEW_BITMASK )\
	}\
	menuDef { /* m1garand */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_rifleman3"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "rifleman", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "rifleman", NUM_ATTACHMENT1, "flash", ;, ptype, statDvar, FLASH_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "rifleman", NUM_ATTACHMENT2, "bayonet", ;, ptype, statDvar, BAYONET_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "rifleman", NUM_ATTACHMENT3, "gl", ;, ptype, statDvar, RG_NEW_BITMASK )\
	}\
	menuDef { /* m1carbine */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_rifleman4"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "rifleman", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "rifleman", NUM_ATTACHMENT1, "flash", ;, ptype, statDvar, FLASH_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "rifleman", NUM_ATTACHMENT2, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "rifleman", NUM_ATTACHMENT3, "bayonet", ;, ptype, statDvar, BAYONET_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 5, stat_slot, "rifleman", NUM_ATTACHMENT4, "bigammo", ;, ptype, statDvar, BIGAMMO_NEW_BITMASK )\
	}\	
	menuDef { /* thompson, mp40. type100smg attachments */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_lightgunner1"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "lightgunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "lightgunner", NUM_ATTACHMENT1, "silenced", ;, ptype, statDvar, SILENCED_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "lightgunner", NUM_ATTACHMENT2, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "lightgunner", NUM_ATTACHMENT3, "bigammo", ;, ptype, statDvar, BIGAMMO_NEW_BITMASK )\
	}\
	menuDef { /* ppsh attachments */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_lightgunner2"suffix,  execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "lightgunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "lightgunner", NUM_ATTACHMENT1, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "lightgunner", NUM_ATTACHMENT2, "bigammo", ;, ptype, statDvar, BIGAMMO_NEW_BITMASK )\
	}\
	menuDef { /* stg44 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_lightgunner3"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "lightgunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "lightgunner", NUM_ATTACHMENT1, "flash", ;, ptype, statDvar, FLASH_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "lightgunner", NUM_ATTACHMENT2, "aperture", ;, ptype, statDvar, APERTURE_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 4, stat_slot, "lightgunner", NUM_ATTACHMENT3, "telescopic", ;, ptype, statDvar, TELESCOPIC_NEW_BITMASK )\
	}\	
	menuDef { /* LMGs */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_heavygunner1"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "heavygunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "heavygunner", NUM_ATTACHMENT1, "bipod", ;, ptype, statDvar, BIPOD_NEW_BITMASK )\
	}\
	menuDef { /* FG42 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_heavygunner2"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "heavygunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "heavygunner", NUM_ATTACHMENT1, "bipod", ;, ptype, statDvar, BIPOD_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "heavygunner", NUM_ATTACHMENT2, "telescopic", ;, ptype, statDvar, TELESCOPIC_NEW_BITMASK )\
	}\
	menuDef { /* Type99 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_heavygunner3"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "heavygunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "heavygunner", NUM_ATTACHMENT1, "bipod", ;, ptype, statDvar, BIPOD_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "heavygunner", NUM_ATTACHMENT2, "bayonet", ;, ptype, statDvar, BAYONET_NEW_BITMASK )\
	}\
	menuDef { /* mg30, mg40 */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_heavygunner4"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "heavygunner", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "heavygunner", NUM_ATTACHMENT1, "bipod", ;, ptype, statDvar, BIPOD_NEW_BITMASK )\
	}\
	menuDef { /* shotgun attachments */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_closeassault1"suffix,  execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment", execnow "set ui_inside_popup 0"; )\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "closeassault", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "closeassault", NUM_ATTACHMENT1, "grip", ;, ptype, statDvar, GRIP_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "closeassault", NUM_ATTACHMENT2, "bayonet", ;, ptype, statDvar, BAYONET_NEW_BITMASK )\
	}\
	menuDef { /* doublebarreldshotgun attachments */ \
		CAC_POPUP_SWAP( "ocd_attachment_popup_closeassault2"suffix, execnow "set "UI_FOCUSFIRST" "REF_ATTACHMENT_NONE"; set ui_inside_popup attachment" , execnow "set ui_inside_popup 0";)\
		LOCAL_ATTACHMENT_INFO_WINDOW( stat_slot )\
		LOCAL_ATTACHMENT_ITEM( 1, stat_slot, "closeassault", NUM_NONE, "none", ;, ptype, statDvar, 0 )\
		LOCAL_ATTACHMENT_ITEM( 2, stat_slot, "closeassault", NUM_ATTACHMENT1, "grip", ;, ptype, statDvar, GRIP_NEW_BITMASK )\
		LOCAL_ATTACHMENT_ITEM( 3, stat_slot, "closeassault", NUM_ATTACHMENT2, "sawoff", ;, ptype, statDvar, SAWOFF_NEW_BITMASK )\
	}
	
	// primary and second primary attachment popup menus
	LOCAL_MASTER_ATTACHMENT_GROUP( CAC_PRIMARY_ATTACHMENT, "", 1, "primary", 0, "loadout_primary_attachment" )

	// ====================================================================================================
	// side arm selection ===============================================================================
	// ====================================================================================================
	#define LOCAL_SIDEARM_INFO_WINDOW( highlight_dvar ) \
		/* weapon image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( LOADOUT_IMAGE_X LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, 0 0 0 0 visible when( dvarString(ui_inside_popup) != "attachment" ); ) \
		/* weapon title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW visible when( dvarString(ui_inside_popup) != "attachment" && dvarString(ui_inside_popup) != "camo" ); ) \
		/* weapon desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible 1 )\

	#define LOCAL_SIDEARM_ACTION( pstat, weaponRef ) \
			play "mouse_click"; \
			setdvar	loadout_secondary weaponRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "loadout_secondary:"weaponRef;\
			PREPROC_ATTACH_CLOSEALL

	#define LOCAL_SIDEARM_ACTION2( pstat, weaponRef ) \		
			play "mouse_click"; \
			setdvar	loadout_secondary weaponRef; \
			setdvar	loadout_secondary_attachment none; \
			scriptMenuResponse "loadout_secondary:"weaponRef;\
			PREPROC_ATTACH_CLOSEALL
	
	#define SI_FOCUS_ACTION( weaponRef ) \
		execOnDvarStringValue "weap_allow_"weaponRef 0 "set ui_sidearm_hl_unlocked 0";\
		execOnDvarStringValue "weap_allow_"weaponRef 1 "set ui_sidearm_hl_unlocked 1";\
		exec "set ui_sidearm_highlighted "weaponRef;


	#define LOCAL_SIDEARM_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION( weaponStat, weaponRef ), SI_FOCUS_ACTION( weaponRef ), ;, \
		when( dvarBool( "weap_allow_"weaponRef ) );, \
			  dvarBool( "weap_allow_"weaponRef ) ) \
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, weaponName, LOCAL_SIDEARM_ACTION2( weaponStat, weaponRef ), SI_FOCUS_ACTION( weaponRef ), ;, \
		when( dvarBool( "weap_allow_"weaponRef ) );, \
			  dvarBool( "weap_allow_"weaponRef ) ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, SI_FOCUS_ACTION( weaponRef ), ;, when( !dvarBool( "weap_allow_"weaponRef ) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( !dvarBool( "weap_allow_"weaponRef ) ); )
	// side arm selection popup menu
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_sidearm_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif

	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_secondary", execnow "set "UI_FOCUSFIRST" "REF_COLT"; set selected_weapon_class pistol; set ui_inside_popup pistol", execnow "set ui_inside_popup 0" )
		LOCAL_SIDEARM_INFO_WINDOW( "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 1, "@WEAPON_COLT45", STAT_PISTOL_COLT, REF_COLT, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 2, "@WEAPON_NAMBU", STAT_PISTOL_NAMBU, REF_NAMBU, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 3, "@WEAPON_WALTHER_P38", STAT_PISTOL_WALTHER, REF_WALTHER, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 4, "@WEAPON_TOKAREV", STAT_PISTOL_TOKAREV, REF_TOKAREV, "ui_sidearm_highlighted" )
		LOCAL_SIDEARM_ITEM( 5, "@WEAPON_357MAGNUM", STAT_PISTOL_357MAGNUM, REF_357MAGNUM, "ui_sidearm_highlighted" )
	}

	// ====================================================================================================
	// primary grenade selection ==========================================================================
	// ====================================================================================================
	#define LOCAL_PGRENADE_INFO_WINDOW( highlight_dvar ) \
		/* primary grenade image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( LOADOUT_IMAGE_X LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, 0 0 0 0 ) \
		/* primary grenade title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) \
		/* primary grenade desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR visible 1 )\
		
	#define LOCAL_PGRENADE_ACTION( weaponRef ) \
			play "mouse_click"; \
			setdvar loadout_pgrenade weaponRef; \
			scriptMenuResponse "loadout_pgrenade:"weaponRef;\
			PREPROC_ATTACH_CLOSEALL		
			
	#define LOCAL_PGRENADE_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS( itemNum, weaponName, LOCAL_PGRENADE_ACTION( weaponRef ), execnow "set "highlight_dvar" "weaponRef, CLEAR_WEAP_NEW( weaponRef );, \
		when( dvarBool("weap_allow_"weaponRef) ) ) \
		\
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( !dvarBool("weap_allow_"weaponRef) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( !dvarBool("weap_allow_"weaponRef) ); )			

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#ifdef PC
		#define UI_FOCUSFIRST "ui_pgrenade_highlighted"
	#else
		#define UI_FOCUSFIRST "ui_fake_focus"
	#endif
	
	// primary grenade selection popup menus
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_pgrenade", execnow "set "UI_FOCUSFIRST" "REF_FRAG_X1"; set ui_inside_popup pgrenade", execnow "set ui_inside_popup 0" )
		LOCAL_PGRENADE_INFO_WINDOW( "ui_pgrenade_highlighted" )
		LOCAL_PGRENADE_ITEM( 1, "@WEAPON_FRAGGRENADE", STAT_FRAG_X1, REF_FRAG_X1, "ui_pgrenade_highlighted" )
		LOCAL_PGRENADE_ITEM( 2, "@WEAPON_STICKY_GRENADE", STAT_STICKY_X1, REF_STICKY_X1, "ui_pgrenade_highlighted" )
		LOCAL_PGRENADE_ITEM( 3, "@WEAPON_MOLOTOV", STAT_MOLOTOV_X1, REF_MOLOTOV_X1, "ui_pgrenade_highlighted" )
	}	
	
	// ====================================================================================================
	// special grenade selection ==========================================================================
	// ====================================================================================================
	#define LOCAL_SGRENADE_INFO_WINDOW( highlight_dvar ) \
		/* special grenade image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( LOADOUT_IMAGE_X LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 1, 0, 2, 0 0 0 0 ) \
		/* special grenade title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) \
		/* special grenade desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
			visible when( dvarString(ui_sgrenade_highlighted)!=REF_SMOKE_X1 || dvarString( loadout_perk1 )!=REF_SPECIALGRENADE_X3 ); )\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",4,dvarString(highlight_dvar),10), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_RED_TEXT \
			visible when( (dvarString(ui_sgrenade_highlighted)==REF_SMOKE_X1) && (dvarString( loadout_perk1 )==REF_SPECIALGRENADE_X3) ); )

	#define LOCAL_SGRENADE_ACTION( weaponRef ) \
			play "mouse_click"; \
			setdvar loadout_sgrenade weaponRef; \
			scriptMenuResponse "loadout_sgrenade:"weaponRef;\
			PREPROC_ATTACH_CLOSEALL
		
	#define LOCAL_SGRENADE_ITEM( itemNum, weaponName, weaponStat, weaponRef, highlight_dvar )\
		CHOICE_BUTTON_FOCUS_VIS( itemNum, weaponName, LOCAL_SGRENADE_ACTION( weaponRef ), execnow "set "highlight_dvar" "weaponRef, ;, \
			when( dvarBool("weap_allow_"weaponRef) && (weaponRef!=REF_SMOKE_X1 || dvarString( loadout_perk1 )!=REF_SPECIALGRENADE_X3) ); ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;, execnow "set "highlight_dvar" "weaponRef, ;, when( !dvarBool("weap_allow_"weaponRef) || (weaponRef==REF_SMOKE_X1 && dvarString( loadout_perk1 )==REF_SPECIALGRENADE_X3) ); ) \
		CHOICE_DBUTTON_VIS( itemNum, weaponName, when( !dvarBool("weap_allow_"weaponRef) || (weaponRef==REF_SMOKE_X1 && dvarString( loadout_perk1 )==REF_SPECIALGRENADE_X3) ); ) \
	
	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_sgrenade_highlighted"
	
	// special grenade selection popup menus
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_sgrenade", execnow "set "UI_FOCUSFIRST" "REF_SMOKE_X1"; set ui_inside_popup sgrenade", execnow "set ui_inside_popup 0" )
		LOCAL_SGRENADE_INFO_WINDOW( "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 1, "@WEAPON_M8_WHITE_SMOKE", STAT_SMOKE_X1, REF_SMOKE_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 2, "@WEAPON_TABUN_GRENADE", STAT_TABUN_X1, REF_TABUN_X1, "ui_sgrenade_highlighted" )
		LOCAL_SGRENADE_ITEM( 3, "@WEAPON_SIGNAL_FLARE", STAT_FLARE_X1, REF_FLARE_X1, "ui_sgrenade_highlighted" )
	}	
	
	// ====================================================================================================
	// perk selection =====================================================================================
	// ====================================================================================================
	#define LOCAL_PERK_INFO_WINDOW( highlight_dvar ) \
		/* perk image*/ \
		PREPROC_SHADER_DRAW_ALIGNED( LOADOUT_IMAGE_X  LOADOUT_IMAGE_Y 90 90 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),6), 1 1 1 0.75, 0, 0, 0.2 0.2 0.225 1 ) \
		/* perk title*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_TITLE_X LOADOUT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) \
		/* perk desc unlocked*/\
		PREPROC_TEXT_DRAW_ALIGNED_EXP( LOADOUT_DESC_X LOADOUT_DESC_Y (LOADOUT_WIDTH-30) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT,  "@"+tablelookup("mp/statsTable.csv",4,dvarString(highlight_dvar),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR \
			visible 1 )\

	#define LOCAL_PERK_ACTION( perkDvar, perkRef, paction ) \
			play "mouse_click"; \
			close self \
			exec "set "perkDvar" "perkRef;\
			scriptMenuResponse perkDvar":"perkRef;\
			paction;\
			PREPROC_ATTACH_CLOSEALL
		
	#define LOCAL_PERK_ITEM( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction )\
		LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction, 1 )

	#define PI_FOCUS_ACTION( perkRef ) \
		execOnDvarStringValue "perk_allow_"perkRef 0 "set ui_perk_hl_unlocked 0";\
		execOnDvarStringValue "perk_allow_"perkRef 1 "set ui_perk_hl_unlocked 1";\
		exec "set ui_perk_highlighted "perkRef;
		
	#define LOCAL_PERK_ITEM_VIS( itemNum, camoName, perkDvar, perkRef, pslot, highlight_dvar, paction, visArg )\
		CHOICE_BUTTON_FOCUS_VIS_ADV( itemNum, camoName, LOCAL_PERK_ACTION( perkDvar, perkRef, paction );, PI_FOCUS_ACTION( perkRef ), ;, \
		when( dvarBool( "perk_allow_"perkRef ) && ( dvarString(loadout_sgrenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 )==0 && visArg );, \
			  dvarBool( "perk_allow_"perkRef ) && ( dvarString(loadout_sgrenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 )==0 && visArg ) \
		CHOICE_BUTTON_FOCUS_VIS_NOHI( itemNum, "", ;,PI_FOCUS_ACTION( perkRef ), ;, \
		when( ( !dvarBool( "perk_allow_"perkRef ) || ( dvarString(loadout_sgrenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 ) ) && visArg ); ) \
		CHOICE_DBUTTON_VIS( itemNum, camoName, \
		when( ( !dvarBool( "perk_allow_"perkRef ) || dvarString(loadout_sgrenade)==REF_SMOKE_X1 && perkRef==REF_SPECIALGRENADE_X3 ) && visArg ); )

	// hackaround to work for PC's floating mouse unfocusing
	#undef  UI_FOCUSFIRST
	#define UI_FOCUSFIRST "ui_perk_highlighted"

	// perk1 selection for primary weapon popup menu
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_perk1", execnow "set "UI_FOCUSFIRST" "REF_SPECIALGRENADE_X3"; set ui_inside_popup perk1", execnow "set ui_inside_popup 0" )
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )

		LOCAL_PERK_ITEM( 1, "@PERKS_SPECIAL_GRENADES_X_3", "loadout_perk1", REF_SPECIALGRENADE_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_SATCHEL_CHARGE_X_2", "loadout_perk1", REF_SATCHEL_CHARGE_X_2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_BAZOOKA_X_2", "loadout_perk1", REF_BAZOOKA_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_BOMB_SQUAD", "loadout_perk1", REF_DETECTEXPLOSIVE, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )	
		LOCAL_PERK_ITEM( 5, "@PERKS_BETTY_X_2", "loadout_perk1", REF_BETTY_X2, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_BANDOLIER", "loadout_perk1", REF_EXTRAAMMO, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_PRIMARY_GRENADES_X_2", "loadout_perk1", REF_PRIMARYGRENADE_X3, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 8, "@PERKS_FLAMETHROWER", "loadout_perk1", REF_FLAMETHROWER, CAC_SPECIALTY_EQUIPMENT, "ui_perk_highlighted", ; )
	}
	
	// perk2 selection for primary weapon popup menu
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_perk2", execnow "set "UI_FOCUSFIRST" "REF_BULLETDAMAGE"; set ui_inside_popup perk2", execnow "set ui_inside_popup 0" )
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		
		LOCAL_PERK_ITEM( 1, "@PERKS_STOPPING_POWER", "loadout_perk2", REF_BULLETDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_SONIC_BOOM", "loadout_perk2", REF_EXPLOSIVEDAMAGE, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_FLAK_JACKET", "loadout_perk2", REF_FLAKJACKET, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_GASMASK", "loadout_perk2", REF_GASMASK, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_JUGGERNAUT", "loadout_perk2", REF_ARMORVEST, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_UAV_JAMMER", "loadout_perk2", REF_GPSJAMMER, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_SLEIGHT_OF_HAND", "loadout_perk2", REF_FASTRELOAD, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 8, "@PERKS_SHADES", "loadout_perk2", REF_SHADES, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 9, "@PERKS_DOUBLE_TAP", "loadout_perk2", REF_ROF, CAC_SPECIALTY_WEAPON, "ui_perk_highlighted", ; )
	}
				
	// perk3 selection for primary weapon popup menu
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_perk3", execnow "set "UI_FOCUSFIRST" "REF_LONGERSPRINT"; set ui_inside_popup perk3", execnow "set ui_inside_popup 0" )
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		
		LOCAL_PERK_ITEM( 1, "@PERKS_DEEP_IMPACT", "loadout_perk3", REF_BULLETPENETRATION, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_EXTREME_CONDITIONING", "loadout_perk3", REF_LONGERSPRINT, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_STEADY_AIM", "loadout_perk3", REF_BULLETACCURACY, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_TOSSBACK", "loadout_perk3", REF_TOSSBACK, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_LAST_STAND", "loadout_perk3", REF_PISTOLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 6, "@PERKS_MARTYRDOM", "loadout_perk3", REF_GRENADEPULLDEATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 7, "@PERKS_FIREPROOF", "loadout_perk3", REF_FIREPROOF, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 8, "@PERKS_DEAD_SILENCE", "loadout_perk3", REF_QUIETER, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )	
		LOCAL_PERK_ITEM( 9, "@PERKS_IRON_LUNGS", "loadout_perk3", REF_HOLDBREATH, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 10, "@PERKS_RECONNAISSANCE", "loadout_perk3", REF_RECONNAISSANCE, CAC_SPECIALTY_ABILITY, "ui_perk_highlighted", ; )
	}
	
	// perk4 selection for primary weapon popup menu
	menuDef	
	{
		CAC_POPUP_SWAP( "ocd_popup_cac_perk4", execnow "set "UI_FOCUSFIRST" "REF_LONGERSPRINT"; set ui_inside_popup perk4", execnow "set ui_inside_popup 0" )
		LOCAL_PERK_INFO_WINDOW( "ui_perk_highlighted" )
		LOCAL_PERK_ITEM( 1, "@PERKS_WATER_COOLER", "loadout_perk4", REF_WATERCOOLER, CAC_SPECIALTY_VEHICLE, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 2, "@PERKS_GREASED_BEARINGS", "loadout_perk4", REF_GREASEDBEARINGS, CAC_SPECIALTY_VEHICLE, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 3, "@PERKS_ORDINANCE", "loadout_perk4", REF_ORDINANCE, CAC_SPECIALTY_VEHICLE, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 4, "@PERKS_LEADFOOT", "loadout_perk4", REF_LEADFOOT, CAC_SPECIALTY_VEHICLE, "ui_perk_highlighted", ; )
		LOCAL_PERK_ITEM( 5, "@PERKS_BOOST", "loadout_perk4", REF_BOOST, CAC_SPECIALTY_VEHICLE, "ui_perk_highlighted", ; )
	}		