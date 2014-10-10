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

#define LOADOUT_WIDTH 			270

#ifdef PC
	#define ORIGIN_LOADOUT			((-(LOADOUT_WIDTH - RIGHTITEM_OFFSET))-10) 75	
#else
	#define ORIGIN_LOADOUT			(-(LOADOUT_WIDTH - RIGHTITEM_OFFSET)) 38
#endif

#define RATEBAR_FRAME_BORDER		0//WINDOW_BORDER_SUNKEN
#define RATEBAR_FRAME_BORDERSIZE	2
#define RATEBAR_FRAME_BORDERCOLOR	0.4 0.4 0.425 1

#define RATEBAR_BAR_SHADER			"gradient_fadein"
#define RATEBAR_BAR_COLOR			1 1 1 0.3

#define ATTRIBUTE_BACK_COLOR		0.1804 0.1961 0.2078 0.5
#define ATTRIBUTE_FILL_COLOR		0.2862 0.3098 0.3098 0.8

#define RATE_BAR_WIDTH				98
#define RATE_BAR_HEIGHT				12

#define LOADOUT_IMAGE_X			100
#define LOADOUT_IMAGE_Y			0

#define LOADOUT_TITLE_X			30
#define LOADOUT_TITLE_Y			(LOADOUT_IMAGE_Y + 100)

#define LOADOUT_DESC_X			(LOADOUT_TITLE_X)
#define LOADOUT_DESC_Y			(LOADOUT_TITLE_Y + 20)
	
#define VIS_WHEN_ATTACH_PLUS(pweapon,pattribute) visible when( (dvarint(ow_cac_stat_pattachment) != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) )
#define VIS_WHEN_ATTACH_MINUS(pweapon,pattribute) visible when( (dvarint(ow_cac_stat_pattachment) != 0) && (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) ) 

#define VIS_WHEN_ATTACH_PLUS_PREVIEW(pweapon,pattribute,extraArg) visible when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) > 0) && extraArg )
#define VIS_WHEN_ATTACH_MINUS_PREVIEW(pweapon,pattribute,extraArg) visible when( (int(tablelookup("mp/attributesTable.csv",1,pweapon,pattribute)) < 0) && extraArg ) 

#define VIS_WHEN_ONE_PRIME visible when( "specialty_twoprimaries" != tablelookup( "mp/statstable.csv", 1, dvarint(ow_cac_stat_perk2), 4 ) ) 
#define VIS_WHEN_TWO_PRIME visible when( "specialty_twoprimaries" == tablelookup( "mp/statstable.csv", 1, dvarint(ow_cac_stat_perk2), 4 ) ) 

#define IS_ONE_PRIME ("specialty_twoprimaries" != tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk2 ), 4 ) )
#define IS_TWO_PRIME ("specialty_twoprimaries" == tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk2 ), 4 ) )

/* ================================================================================= */
/* ================================ LOADOUT DISPLAY ================================ */
/* ================================================================================= */
// UI art: Julian version 2 - first pass

// CAC loadout main frame =================

	#define LOADOUT_ALIGN 	HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP
	#define PERK_ALIGN		
	
	#define LOADOUT_PLATING( py, ph, vis_gradient_top, vis_gradient_bottom ) \
			LOADOUT_PLATING_RAW( ORIGIN_LOADOUT, 0, py, (LOADOUT_WIDTH+8), ph, LOADOUT_ALIGN, vis_gradient_top, vis_gradient_bottom )
	
	// custom class name 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(customclass1), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "customclass1" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(customclass2), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "customclass2" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(customclass3), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "customclass3" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(customclass4), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "customclass4" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(customclass5), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "customclass5" ); )
	
	// prestige class names
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(prestigeclass1), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "prestigeclass1" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(prestigeclass2), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "prestigeclass2" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(prestigeclass3), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "prestigeclass3" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(prestigeclass4), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "prestigeclass4" ); )
	PREPROC_TEXT_DRAW_ALIGNED_EXP( -4 -4 (LOADOUT_WIDTH+8) -35 LOADOUT_ALIGN, ORIGIN_LOADOUT, dvarString(prestigeclass5), TEXTSIZE_TITLE, 0, 0, ITEM_ALIGN_MIDDLE_CENTER, CHOICE_TEXTCOLOR visible when( dvarString( ow_cac_class ) == "prestigeclass5" ); )

// attributes box ======================

#ifndef HIDE_WEAPON_ATTRIBUTE		

	#define INFO_BOX_ORIENT			0
	#define INFO_BOX_WIDTH			222
	#define INFO_BOX_HEIGHT			126
	#define INFO_BOX_X				(CHOICE_X_START+CHOICE_SIZE_X-INFO_BOX_WIDTH)

	#ifdef PC  
		#define INFO_BOX_Y				310//320
	#else     
		#define INFO_BOX_Y				274
	#endif     

	#define INFO_TEXT				""
	#define INFO_TITLE				"@MENU_PRIMARY_ATTRIBUTES" //"Primary Attributes"
	#define INFO_TITLE_COLOR		CHOICE_TEXTCOLOR
	#include "ui_mp/info_box.inc"
	
	#define ORIGIN_ATTRIBUTE_LABEL	(INFO_BOX_X) (INFO_BOX_Y+2)
		
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 0, text "@MENU_ACCURACY1", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 20, text "@MENU_DAMAGE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 40, text "@MENU_RANGE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 60, text "@MENU_FIRE_RATE", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )
	PREPROC_TEXT_DRAW_ALIGNED( ORIGIN_ATTRIBUTE_LABEL INFO_BOX_WIDTH 20 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, -60 80, text "@MENU_MOBILITY", TEXTSIZE_SMALL, -68, 16, ITEM_ALIGN_RIGHT, CHOICE_TEXTCOLOR )

	// meter bar unit dividers
	#define ATTRIBUTE_UNITS( px, py ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+(RATE_BAR_WIDTH/4)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+(RATE_BAR_WIDTH/2)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ALIGNED( (px+((RATE_BAR_WIDTH/4)*3)) py 1 3 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 RATE_BAR_HEIGHT, "line_vertical", 1 1 1 0.2, 0, 0, 0 0 0 0 )
		
	// weapon attribut meter bars
	#define ATTRIBUTE_BAR_FORMAT( px, py, pnum ) \
		ATTRIBUTE_UNITS( px, py )\
		PREPROC_SHADER_DRAW_ALIGNED( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 0, "white", ATTRIBUTE_BACK_COLOR, 0, 0, 0 0 0 0 ) \
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT, pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", ATTRIBUTE_FILL_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT, pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		RATEBAR_BAR_SHADER, ATTRIBUTE_BACK_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP ) \
		/* attachment delta bar -*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4), pnum )))*RATE_BAR_WIDTH/100+\
		((int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100), py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.4 0.15 0.15 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR VIS_WHEN_ATTACH_MINUS(tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT,pnum) rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		/* attachment delta bar +*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4), pnum )))*RATE_BAR_WIDTH/100, py, \
		(int(tablelookup("mp/attributestable.csv", 1, tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT, pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.3 0.8 0.3 0.5, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR VIS_WHEN_ATTACH_PLUS(tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),4)+"_"+ \
		CAC_PRI_ATTACHMENT_SLOT,pnum) rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\

	#define PREVIEW_VIS_CONDITION visible when( PREVIEW_VIS_CONDITION_RAW );
	#define PREVIEW_VIS_CONDITION_RAW dvarInt( ui_show_preview )

	#define ATTRIBUTE_BAR_FORMAT_PREVIEW( px, py, pnum ) \
		ATTRIBUTE_UNITS( px, py )\
		PREPROC_SHADER_DRAW_ALIGNED( px py (-(RATE_BAR_WIDTH)) RATE_BAR_HEIGHT CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP, 0 0, "white", 0 0 0 1, 0, 0, 0 0 0 0 PREVIEW_VIS_CONDITION ) \
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum ))+ \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum ))))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white",ATTRIBUTE_FILL_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP PREVIEW_VIS_CONDITION )\
		PREPROC_SHADER_DRAW_ADV( px, py, \
		(100)*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		RATEBAR_BAR_SHADER, ATTRIBUTE_BACK_COLOR, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP PREVIEW_VIS_CONDITION ) \
		/* attachment delta bar -*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100+\
		((int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100), py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.4 0.15 0.15 1, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR \
		VIS_WHEN_ATTACH_MINUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ) \
		rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )\
		/* attachment delta bar +*/ \
		PREPROC_SHADER_DRAW_ADV( px+(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted), pnum )))*RATE_BAR_WIDTH/100, py, \
		(int(tablelookup("mp/attributestable.csv", 1, dvarString(ui_primary_highlighted)+"_"+ \
		dvarString(ui_attachment_highlighted), pnum )))*RATE_BAR_WIDTH/100, RATE_BAR_HEIGHT, \
		"white", 0.3 0.8 0.3 0.5, RATEBAR_FRAME_BORDER, RATEBAR_FRAME_BORDERSIZE, RATEBAR_FRAME_BORDERCOLOR \
		VIS_WHEN_ATTACH_PLUS_PREVIEW(dvarString(ui_primary_highlighted)+"_"+dvarString(ui_attachment_highlighted),pnum, PREVIEW_VIS_CONDITION_RAW ) \
		rect 0 0 0 0 CHOICE_HORIZONTAL_ALIGN VERTICAL_ALIGN_TOP )
		
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+6), 2 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+26), 3 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+46), 4 ) 
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+66), 5 )
	ATTRIBUTE_BAR_FORMAT( (INFO_BOX_X+100), (INFO_BOX_Y+86), 6 )
	
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+6), 2 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+26), 3 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+46), 4 ) 
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+66), 5 )
	ATTRIBUTE_BAR_FORMAT_PREVIEW( (INFO_BOX_X+100), (INFO_BOX_Y+86), 6 )
	
#endif

// weapon loadout info display ============

#define WEAPON_TITLE_X		-5
#define WEAPON_TITLE_Y		-10

#define WEAPON_IMAGE_X		130//90//74
#define WEAPON_IMAGE_Y		(WEAPON_TITLE_Y+20)

#define ATTACHMENT_TITLE_X	10
#define ATTACHMENT_TITLE_Y	(WEAPON_TITLE_Y+72)//64

#define ATTACHMENT_IMAGE_X	30
#define ATTACHMENT_IMAGE_Y	(WEAPON_IMAGE_Y)//32

#define SECONDARY_OFFSET_Y	92

//#define PRI_ATTACHMENT_SLOT 
//	tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_primary ), int(dvarInt( ow_cac_stat_pattachment ))+11 )
//#define SEC_ATTACHMENT_SLOT
//	tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_secondary ), int(dvarInt( ow_cac_stat_sattachment ))+11 )
	
/* primary weapon name */ 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( WEAPON_TITLE_X WEAPON_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv", 0, dvarInt( ow_cac_stat_primary ), 3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW )
	/* primary weapon attachment name */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( ATTACHMENT_TITLE_X ATTACHMENT_TITLE_Y (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_primary ),3)+"_"+tablelookup("mp/attachmentTable.csv",4,	tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_primary ), int(dvarInt( ow_cac_stat_pattachment ))+11 ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )
	/* primary weapon image */
	PREPROC_SHADER_DRAW_ALIGNED( WEAPON_IMAGE_X WEAPON_IMAGE_Y 140 70 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, dvarInt( ow_cac_stat_primary ), 6 ), 1 1 1 1, 0, 1, 1 1 1 1 )
	/* primary weapon attachment image */
	PREPROC_SHADER_DRAW_ALIGNED( ATTACHMENT_IMAGE_X ATTACHMENT_IMAGE_Y 48 48 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 4, 	tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_primary ), int(dvarInt( ow_cac_stat_pattachment ))+11 ), 6 ), 1 1 1 1, 0, 1, 1 1 1 1 )
	
	/* second weapon name */
	PREPROC_SHADER_DRAW_ALIGNED( (WEAPON_TITLE_X+11) (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( WEAPON_TITLE_X (WEAPON_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 0, dvarInt( ow_cac_stat_secondary ), 3), TEXTSIZE_DEFAULT, 0, 0, ITEM_ALIGN_MIDDLE_RIGHT, COLOR_INFO_YELLOW )
	/* second weapon attachment name */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( ATTACHMENT_TITLE_X (ATTACHMENT_TITLE_Y+SECONDARY_OFFSET_Y) (LOADOUT_WIDTH+8) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statsTable.csv",0,dvarInt( ow_cac_stat_secondary ),3)+"_"+tablelookup("mp/attachmentTable.csv",4,tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_secondary ), int(dvarInt( ow_cac_stat_sattachment ))+11 ),7), TEXTSIZE_SMALL, 0, 0, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )
	/* second weapon image */
	PREPROC_SHADER_DRAW_ALIGNED_VIS( WEAPON_IMAGE_X (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y) 140 70 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, dvarInt( ow_cac_stat_secondary ), 6 ), 1 1 1 1, 0, 1, 1 1 1 1, when( IS_TWO_PRIME ); ) 
	PREPROC_SHADER_DRAW_ALIGNED_VIS( (WEAPON_IMAGE_X+60) (WEAPON_IMAGE_Y+SECONDARY_OFFSET_Y-5) 80 80 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, dvarInt( ow_cac_stat_secondary ), 6 ), 1 1 1 1, 0, 1, 1 1 1 1,  when( IS_ONE_PRIME ); ) 
	/* second weapon attachment image */
	PREPROC_SHADER_DRAW_ALIGNED_VIS( ATTACHMENT_IMAGE_X (ATTACHMENT_IMAGE_Y+SECONDARY_OFFSET_Y) 48 48 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/attachmenttable.csv", 4, tablelookup( "mp/statsTable.csv", 0, dvarInt( ow_cac_stat_secondary ), int(dvarInt( ow_cac_stat_sattachment ))+11 ), 6 ), 1 1 1 1, 0, 1, 1 1 1 1, when( IS_TWO_PRIME ); )	
	
// perk loadout info display =============
	#ifdef PC
		#define PERK_DESC_TEXTSIZE	0.25
	#else
		#define PERK_DESC_TEXTSIZE 	TEXTSIZE_SMALL
	#endif
	
	#define PERK_IMAGE_X		25//(PERK_TITLE_X+25)
	#define PERK_IMAGE_Y		198//196(g@20) //(PERK_TITLE_Y)//190

	#define PERK_TITLE_X		(PERK_IMAGE_X+35)
	#define PERK_TITLE_Y		(PERK_IMAGE_Y)

	#define PERK_DESC_X			(PERK_TITLE_X-4)
	#define PERK_DESC_Y			(PERK_IMAGE_Y+15)

	#define PERK_Y_OFFSET		38//204//206
	#define GRENADE_Y_OFFSET	24//20(d-176)//21//36
 
	/* primary grenade name */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( PERK_TITLE_X (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",0,dvarInt( ow_cac_stat_pgrenade ),3), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) 
	
	/* primary grenade icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X-19) (PERK_IMAGE_Y-GRENADE_Y_OFFSET) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X+5) (PERK_IMAGE_Y-GRENADE_Y_OFFSET) 20 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, dvarInt( ow_cac_stat_pgrenade ), 6 )+"_cac", 1 1 1 1, 0, 1, 1 1 1 1 ) 
	
	/* special grenade name */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_TITLE_X+125) (PERK_TITLE_Y-GRENADE_Y_OFFSET+2) (LOADOUT_WIDTH-20) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@"+tablelookup("mp/statstable.csv",0,dvarInt( ow_cac_stat_sgrenade ),3), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) 
	
	/* special grenade icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X+130) (PERK_IMAGE_Y-GRENADE_Y_OFFSET) 20 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 0, dvarInt( ow_cac_stat_sgrenade ), 6 )+"_cac", 1 1 1 1, 0, 1, 1 1 1 1 ) 
	
	/* perk loadout info display ============= */
	
	/* perk 1 name ------------- */
  PREPROC_TEXT_DRAW_ALIGNED_VIS( PERK_TITLE_X (PERK_TITLE_Y) (LOADOUT_WIDTH-50) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, when( tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 4 ) != "specialty_specialgrenade" && tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 4 ) != "specialty_fraggrenade" ); )
  PREPROC_TEXT_DRAW_ALIGNED_VIS( PERK_TITLE_X (PERK_TITLE_Y) (LOADOUT_WIDTH-50) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@PERKS_3X_" + tablelookup("mp/statstable.csv",0,dvarInt( ow_cac_stat_sgrenade ),3), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, when( tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 4 ) == "specialty_specialgrenade" ); )
  PREPROC_TEXT_DRAW_ALIGNED_VIS( PERK_TITLE_X (PERK_TITLE_Y) (LOADOUT_WIDTH-50) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@PERKS_3X_" + tablelookup("mp/statstable.csv",0,dvarInt( ow_cac_stat_pgrenade ),3), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW, when( tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 4 ) == "specialty_fraggrenade" ); )
	
	/* perk 1 icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X-19) (PERK_IMAGE_Y-4) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_SHADER_DRAW_ALIGNED( PERK_IMAGE_X (PERK_IMAGE_Y) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 6 ), 1 1 1 0.75, 0, 1, 1 1 1 1 ) 
	
	/* perk 1 desc */
	PREPROC_SHADER_DRAW_ALIGNED( PERK_DESC_X (PERK_DESC_Y) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1 ) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_DESC_X+16) (PERK_DESC_Y) (LOADOUT_WIDTH-63) 18 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk1 ), 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) 
	
	/* perk 2 name ------------- */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_TITLE_X) (PERK_TITLE_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk2 ), 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW )
	
	/* perk 2 icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X-19) (PERK_IMAGE_Y+PERK_Y_OFFSET-4) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_SHADER_DRAW_ALIGNED( PERK_IMAGE_X (PERK_IMAGE_Y+PERK_Y_OFFSET) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk2 ), 6 ), 1 1 1 0.75, 0, 1, 1 1 1 1 ) 
	
	/* perk 2 desc */
	PREPROC_SHADER_DRAW_ALIGNED( PERK_DESC_X (PERK_DESC_Y+PERK_Y_OFFSET) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1 ) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_DESC_X+16) (PERK_DESC_Y+PERK_Y_OFFSET) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk2 ), 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR )	
	
	/* perk 3 name ------------- */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( PERK_TITLE_X (PERK_TITLE_Y+PERK_Y_OFFSET*2) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk3 ), 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) 
	
	/* perk 3 icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X-19) (PERK_IMAGE_Y+PERK_Y_OFFSET*2-4) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_SHADER_DRAW_ALIGNED( PERK_IMAGE_X (PERK_IMAGE_Y+PERK_Y_OFFSET*2) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk3 ), 6 ), 1 1 1 0.75, 0, 1, 1 1 1 1 ) 
	
	/* perk 3 desc */
	PREPROC_SHADER_DRAW_ALIGNED( PERK_DESC_X (PERK_DESC_Y+PERK_Y_OFFSET*2) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1 ) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_DESC_X+16) (PERK_DESC_Y+PERK_Y_OFFSET*2) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk3 ), 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) 
	
	/* perk 4 name ------------- */
	PREPROC_TEXT_DRAW_ALIGNED_EXP( PERK_TITLE_X (PERK_TITLE_Y+PERK_Y_OFFSET*3) (LOADOUT_WIDTH-50) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk4 ), 3 ), TEXTSIZE_SMALL, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, COLOR_INFO_YELLOW ) 
	
	/* perk 4 icon */
	PREPROC_SHADER_DRAW_ALIGNED( (PERK_IMAGE_X-19) (PERK_IMAGE_Y+PERK_Y_OFFSET*3-4) (LOADOUT_WIDTH+8) 1 LOADOUT_ALIGN, ORIGIN_LOADOUT, "white", 1 1 1 0.1, 0, 1, 1 1 1 1 ) 
	PREPROC_SHADER_DRAW_ALIGNED( PERK_IMAGE_X (PERK_IMAGE_Y+PERK_Y_OFFSET*3) 32 32 LOADOUT_ALIGN, ORIGIN_LOADOUT, tablelookup( "mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk4 ), 6 ), 1 1 1 0.75, 0, 1, 1 1 1 1 ) 
	
	/* perk 4 desc */
	PREPROC_SHADER_DRAW_ALIGNED( PERK_DESC_X (PERK_DESC_Y+PERK_Y_OFFSET*3) 14 14 LOADOUT_ALIGN, ORIGIN_LOADOUT, "ui_arrow_right", 1 1 1 0.4, 0, 1, 1 1 1 1 ) 
	PREPROC_TEXT_DRAW_ALIGNED_EXP( (PERK_DESC_X+16) (PERK_DESC_Y+PERK_Y_OFFSET*3) (LOADOUT_WIDTH-63) 20 LOADOUT_ALIGN, ORIGIN_LOADOUT, "@" + tablelookup("mp/statstable.csv", 1, dvarInt( ow_cac_stat_perk4 ), 7), PERK_DESC_TEXTSIZE, 0, -2, ITEM_ALIGN_MIDDLE_LEFT, CHOICE_TEXTCOLOR ) 
	