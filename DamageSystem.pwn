// *********************************************************************
//                             Damage System
//
//
//  Script Information
//                         (M/D/Y)
//       Start Date.....: 2/10/2018             Script Author..: ZiiM
//       Script Type....: Filterscript          Saving.........: INI
//       File Type......: .pwn                  Archive Type...: .amx
//
//
// *********************************************************************

/*---------------------------------------------------------------------
                            Includes 
--------------------------------------------------------------------- */
#include <a_samp>
#include <izcmd>
#include <sscanf2>
#include <YSI\y_ini>

/*---------------------------------------------------------------------
                            Settings 
--------------------------------------------------------------------- */
#define MAX_DAMAGE 100

/*---------------------------------------------------------------------
                            Dialogs 
--------------------------------------------------------------------- */
#define DIALOG_DEFAULT 			0
#define DIALOG_DAMAGES 			1
#define DIALOG_SETTINGS 		2
#define DIALOG_WEP_LIST 		3
#define DIALOG_SET_DAMAGE 		4
#define DIALOG_ENABLE_DISABLE 	5

#define BODY_PART_TORSO 3
#define BODY_PART_GROIN 4
#define BODY_PART_LEFT_ARM 5
#define BODY_PART_RIGHT_ARM 6
#define BODY_PART_LEFT_LEG 7
#define BODY_PART_RIGHT_LEG 8
#define BODY_PART_HEAD 9

/*---------------------------------------------------------------------
                            Debugging 
--------------------------------------------------------------------- */
#define debug 0


/*---------------------------------------------------------------------
                            Variables 
--------------------------------------------------------------------- */
enum dmgData {
	dmgExist,
	dmgDamage,
	dmgBodypart,
	dmgWeapon,
	dmgArmour,
	dmgTime,
}
new DamageData[MAX_PLAYERS][MAX_DAMAGE][dmgData];
new TotalDamages[MAX_PLAYERS];

new bool:dmgEnabled;
new WepDamage[43];

/*---------------------------------------------------------------------
                            Script Start 
--------------------------------------------------------------------- */
INI:wepdmg[Damages](name[], value[])
{
    for(new i = 0; i < 19; i++)
    {
        INI_Int(GetWepName(i), WepDamage[i]);
    }
    for(new i = 22; i < 39; i++)
    {
       INI_Int(GetWepName(i), WepDamage[i]); 
    }
    return 0;
}

INI:wepdmg[SystemToggle](name[], value[])
{
    INI_Bool("System", dmgEnabled);
    return 0;
}

public OnFilterScriptInit()
{
    INI_Load("wepdmg.ini");
	print("\n|----------------------------------|");
	print("|  Damage System by ZiiM               |");
	print("|----------------------------------|\n");
	return 1;
}

public OnFilterScriptExit()
{
    SaveAll();
	return 1;
}

forward WipeDamages(playerid);
public WipeDamages(playerid) {
	for(new i=0; i < MAX_DAMAGE; i++)
	{
		if(DamageData[playerid][i][dmgExist] != 0 && DamageData[playerid][i][dmgDamage] != 0)
		{
			DamageData[playerid][i][dmgExist] = 0;
			DamageData[playerid][i][dmgDamage] = 0;
			DamageData[playerid][i][dmgBodypart] = 0;
			DamageData[playerid][i][dmgWeapon] = 0;
			DamageData[playerid][i][dmgArmour] = 0;
			DamageData[playerid][i][dmgTime] = 0;
			TotalDamages[playerid] = 0;
			
		}
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
    SetPlayerTeam(playerid, 0);
	WipeDamages(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerTeam(playerid, 0);
    return 1;
}



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
		case DIALOG_SETTINGS: 
		{
			if(response)
			{
				switch(listitem)
				{
					case 0: //Set Weapon Damage
					{
						new diastring[1024], tempstr[128];
						for(new i = 0; i < 19; i++)
						{
							format(tempstr, sizeof(tempstr), "%s\n", GetWepName(i));
							strcat(diastring, tempstr, sizeof(diastring));

						} 
						for(new i = 22; i < 39; i++)
						{
							format(tempstr, sizeof(tempstr), "%s\n", GetWepName(i));
							strcat(diastring, tempstr, sizeof(diastring));

						}
						format(tempstr, sizeof(tempstr), "Bomb\nSpraycan\nFireExtinguisher");
						strcat(diastring, tempstr, sizeof(diastring));
						ShowPlayerDialog(playerid, DIALOG_WEP_LIST, DIALOG_STYLE_LIST, "Set Weaopn Damages: ", diastring, "Enter", "Close");
					}
					case 1: //Enable/Disable weapon system
					{
                        new msg[128];
                        if(dmgEnabled == true)
                        {
                            dmgEnabled = false;
                            format(msg, sizeof(msg), "%s just {A30104}Disabled{FFFFFF} the damage system", ReturnName(playerid));
                            SendClientMessage(playerid, 0xFFFFFFAA, msg);
                            SaveAll();
                        }
                        else if(dmgEnabled == false)
                        {
                            format(msg, sizeof(msg), "%s just {219A01}Enabled{FFFFFF} the damage system", ReturnName(playerid));
                            SendClientMessage(playerid, 0xFFFFFFAA, msg);
                            dmgEnabled = true;
                            SaveAll();
                        }
					}
                }
			}
			return 1;

		}
		case DIALOG_WEP_LIST:
		{
            if(response)
            {
                new caption[32], dia[256];
        		switch(listitem)
        		{
        			case 0:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 1:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 2:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 3:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 4:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 5:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 6:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 7:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 8:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 9:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
                        format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 10:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 11:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 12:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 13:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 14:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 15:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 16:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 17:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 18:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 19:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(22));
        				SetPVarInt(playerid, "WepEdit", 22);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 20:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(23));
        				SetPVarInt(playerid, "WepEdit", 23);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 21:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(24));
        				SetPVarInt(playerid, "WepEdit", 24);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 22:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(25));
        				SetPVarInt(playerid, "WepEdit", 25);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 23:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(26));
        				SetPVarInt(playerid, "WepEdit", 26);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 24:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(27));
        				SetPVarInt(playerid, "WepEdit", 27);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 25:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(28));
        				SetPVarInt(playerid, "WepEdit", 28);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 26:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(29));
        				SetPVarInt(playerid, "WepEdit", 29);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 27:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(30));
        				SetPVarInt(playerid, "WepEdit", 30);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 28:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(31));
        				SetPVarInt(playerid, "WepEdit", 31);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 29:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(32));
        				SetPVarInt(playerid, "WepEdit", 32);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 30:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(33));
        				SetPVarInt(playerid, "WepEdit", 33);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 31:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(34));
        				SetPVarInt(playerid, "WepEdit", 34);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 32:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(35));
        				SetPVarInt(playerid, "WepEdit", 35);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 33:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(36));
        				SetPVarInt(playerid, "WepEdit", 36);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 34:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(37));
        				SetPVarInt(playerid, "WepEdit", 37);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 35:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(38));
        				SetPVarInt(playerid, "WepEdit", 38);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 36:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(40));
        				SetPVarInt(playerid, "WepEdit", 40);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 37:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(41));
        				SetPVarInt(playerid, "WepEdit", 41);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 38:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(42));
        				SetPVarInt(playerid, "WepEdit", 42);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        			case 39:
        			{
        				
        				format(caption, sizeof(caption), "%s", GetWepName(42));
        				SetPVarInt(playerid, "WepEdit", 42);
        				format(dia, sizeof(dia), "Please input weapon damage\n{FF0000}For default damage set the damage to -1\n{FFFFFF}Current DMG for %s is {FF0000}%s.", caption, ReturnWepDMG(GetPVarInt(playerid, "WepEdit")));
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, dia, "Enter", "Close");
        			}
        		}
            }

		}
		case DIALOG_SET_DAMAGE:
		{
            if(response)
            {
    			new EditWep = GetPVarInt(playerid, "WepEdit");
    			new Damage = strval(inputtext);
    			WepDamage[EditWep] = Damage;
    			#if debug == 1 
                    printf("Editing Wep: %s(%d) | Weapon Damage: %d(%d)", GetWepName(EditWep), EditWep, WepDamage[EditWep], Damage);
                #endif
                SaveAll();
            }
		}
	}
	return 1;
}

public OnPlayerDeath(playerid)
{
	WipeDamages(playerid);
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
	if(IsPlayerConnected(playerid))
	{
		new Float: HP, Float: armour, damage = floatround(amount, floatround_round), id, cdam = 0;
		GetPlayerHealth(playerid, HP);
		GetPlayerArmour(playerid, armour);
        if(dmgEnabled == true)
        {
    		TotalDamages[playerid] ++;
    		for(new i = 0; i < MAX_DAMAGE; i++)
    		{
    			if(DamageData[playerid][i][dmgExist] == 0)
    			{
    				id = i;
    				break;
    			}
    		}
    		if(WepDamage[weaponid] == -1)
    		{
    			DamageData[playerid][id][dmgDamage] = damage;
                printf("Damage: %d", damage);
    		}
    		else
    		{
    			DamageData[playerid][id][dmgDamage] = WepDamage[weaponid];
                cdam = 1;
                //#if debug == 1
    			printf("Wep: %d", WepDamage[weaponid]);
                //#endif
    		}
    		DamageData[playerid][id][dmgExist] = 1;
    		DamageData[playerid][id][dmgWeapon] = weaponid;
    		DamageData[playerid][id][dmgBodypart] = bodypart;
    		DamageData[playerid][id][dmgTime] = gettime();
    		if(armour > 0)
    		{
    			DamageData[playerid][id][dmgArmour] = 1;
    		}
    		else if(armour < 1)
    		{
    			DamageData[playerid][id][dmgArmour] = 0;
    		}
            if(cdam == 1)
            {
                if(armour > WepDamage[weaponid]) SetPlayerArmour(playerid, armour-WepDamage[weaponid]);
                else if(armour == WepDamage[weaponid]) SetPlayerArmour(playerid, 0);
                else if(armour < WepDamage[weaponid] && armour > 0)
                {
                    new subval = floatround(armour)-WepDamage[weaponid];
                    SetPlayerArmour(playerid, 0);
                    SetPlayerHealth(playerid, HP+subval);
                    #if debug == 1
                        printf("Subval: %d | Arm: %f | Arm+sub: %f", subval, armour, armour+subval);
                    #endif
                }
                else SetPlayerHealth(playerid, HP-WepDamage[weaponid]);
            }
            else
            {
                if(armour > damage) SetPlayerArmour(playerid, armour-damage);
                else if(armour == damage) SetPlayerArmour(playerid, 0);
                else if(armour < damage && armour > 0)
                {
                    new subval = floatround(armour)-damage;
                    #if debug == 1
                        printf("Subval: %d | Arm: %f | Arm+sub: %f", subval, armour, armour+subval);
                    #endif
                    SetPlayerArmour(playerid, 0);
                    SetPlayerHealth(playerid, HP+subval);
                }
                else SetPlayerHealth(playerid, HP-damage);
                #if debug == 1
                    printf("Default: %d", damage);
                #endif
            }
        }
        else
        {
            if(armour > damage) SetPlayerArmour(playerid, armour-damage);
            else if(armour == damage) SetPlayerArmour(playerid, 0);
            else if(armour < damage && armour > 0)
            {
                new subval = floatround(armour)-damage;
                SetPlayerArmour(playerid, 0);
                SetPlayerHealth(playerid, HP+subval);
            }
            else SetPlayerHealth(playerid, HP-damage);
            #if debug == 1
                printf("Default: %d", damage);
            #endif
        }
	}
	return 1;
}

stock BPName(bodypart)
{
	new bpn[32];
	switch(bodypart)
	{
		case 3: 
		{
			format(bpn, sizeof(bpn), "TORSO");
		}
		case 4: 
		{
			format(bpn, sizeof(bpn), "GROIN");
		}
		case 5: 
		{
			format(bpn, sizeof(bpn), "LEFT ARM");
		}
		case 6: 
		{
			format(bpn, sizeof(bpn), "RIGHT ARM");
		}
		case 7: 
		{
			format(bpn, sizeof(bpn), "LEFT LEG");
		}
		case 8: 
		{
			format(bpn, sizeof(bpn), "RIGHT LEG");
		}
		case 9: 
		{
			format(bpn, sizeof(bpn), "HEAD");
		}

	}
	return bpn;
}

CMD:damages(playerid, params[])
{
	new playa;
    if(dmgEnabled == false) return SendClientMessage(playerid, 0xFFFFFFAA, "The damage system is disabled. Ask for an admin to renable it.");
	if (!sscanf(params, "u", playa))
    {
    	new Float:x, Float:y, Float:z, vw, interior;
    	GetPlayerPos(playa, Float:x, Float:y, Float:z);
    	vw = GetPlayerVirtualWorld(playa);
    	interior = GetPlayerInterior(playa);
    	if(IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z) && GetPlayerVirtualWorld(playerid) == vw && GetPlayerInterior(playerid) == interior)
    	{
    		ShowPlayerDamages(playa, playerid);
    		
    	} else {
    		SendClientMessage(playerid, 0xFF0000AA, "You are not in range of that player.");
    	}

    } else {
    	SendClientMessage(playerid, 0xFF0000AA, "[SYNTAX] /damages [playerid/name]");
    }
    return 1;
}

CMD:resetdamages(playerid, params[])
{
	new playa;
	if(!IsPlayerAdmin(playerid))
	{
		SendClientMessage(playerid, 0xFF0000AA,"You are not a admin");
		return 1;
	}
    if(dmgEnabled == false) return SendClientMessage(playerid, 0xFFFFFFAA, "The damage system is disabled. Ask for an admin to renable it.");
	if (!sscanf(params, "u", playa))
    {
    	new string[128];
    	format(string, sizeof(string), "%s reset %s damages", ReturnName(playerid), ReturnName(playa));
    	SendClientMessageToAll(0xFF0000AA, string);
    	WipeDamages(playa);

    } else {
    	SendClientMessage(playerid, 0xFF0000AA, "[SYNTAX] /resetdamages [playerid/name]");
    }
    return 1;
}

CMD:settings(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
		ShowSettings(playerid);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, 0xFF0000AA, "You are not a admin");
	}
	return 1;
}

CMD:saveall(playerid, params[])
{
    if(IsPlayerAdmin(playerid))
    {
        SaveAll();
        SendClientMessage(playerid, 0xFF0000AA, "DamageSystem has been saved.");
        return 1;
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000AA, "You are not a admin");
    }
    return 1;
}

stock ShowPlayerDamages(damageid, playerid)
{	
	new caption[33], diastring[3765], tempstr[128];
	format(caption, sizeof(caption), "%s", ReturnName(damageid));

	if (TotalDamages[damageid] < 1)
		return ShowPlayerDialog(playerid, DIALOG_DEFAULT, DIALOG_STYLE_LIST, caption, "There aren't any damages to show.", "<<", ""); 

	for(new i = 0; i < MAX_DAMAGE; i++)
	{
		if(DamageData[damageid][i][dmgExist] == 1)
		{

			format(tempstr, sizeof(tempstr), "%d dmg from %s to %s (Kevlarhit: %d) %d's ago\n", DamageData[damageid][i][dmgDamage], GetWepName(DamageData[damageid][i][dmgWeapon]), BPName(DamageData[damageid][i][dmgBodypart]), DamageData[damageid][i][dmgArmour], gettime() - DamageData[damageid][i][dmgTime]);
			strcat(diastring, tempstr, sizeof(diastring));
		}
	}
	ShowPlayerDialog(playerid, DIALOG_DAMAGES, DIALOG_STYLE_LIST, caption, diastring, "Close", "");
	return 1;
}

stock ShowSettings(playerid)
{
	new diastring[1024];
	format(diastring, sizeof(diastring), "Set Weapon Damages\n%s", dmgEnable());
	ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_LIST, "Damage System Settings: ", diastring, "Enter", "Close");
	return 1;
}

stock ReturnName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock GetWepName(weaponid)
{
	new wep[32];
	if(weaponid == 0)
	{
		format(wep, sizeof(wep), "Fist");
		return wep;
	} else if(weaponid == 10) {
		format(wep, sizeof(wep), "Purple Dildo");
		return wep;
	} else if(weaponid == 13) {
		format(wep, sizeof(wep), "Silver Vibrator");
		return wep;
	} else {
		GetWeaponName(weaponid, wep, sizeof(wep));
		return wep;
	}	
}

stock dmgEnable()
{
    new dia[64];
    if(dmgEnabled == true)
    {
        format(dia, sizeof(dia), "{219A01}Enabled");
        return dia;
    }
    else
    {
        format(dia, sizeof(dia), "{A30104}Disabled");
        return dia;  
    }
}

stock ReturnWepDMG(wep)
{
    new msg[32];
    if(WepDamage[wep] == -1)
    {
        format(msg, sizeof(msg), "default");
        return msg;
    }
    else
    {
        format(msg, sizeof(msg), "%d", WepDamage[wep]);
        #if debug == 1
            printf("WepDMG: %d", WepDamage[wep]);
        #endif
        return msg;
    }
}

SaveAll()
{
    new INI:ini = INI_Open("wepdmg.ini");
    new b = 0;
    INI_SetTag(ini, "Damages");
    for(new i = 0; i < 19; i++)
    {
        if(WepDamage[i] == 0)
        {
            b++;
        }
        INI_WriteInt(ini, GetWepName(i), WepDamage[i]);
    }
    for(new i = 22; i < 39; i++)
    {
        if(WepDamage[i] == 0)
        {
            b++;
        }
        INI_WriteInt(ini, GetWepName(i), WepDamage[i]);
    }
    if(b == 36)
    {
        for(new i = 0; i < 19; i++)
        {
            INI_WriteInt(ini, GetWepName(i), -1);
            WepDamage[i] = -1;
        }
        for(new i = 22; i < 39; i++)
        {
            INI_WriteInt(ini, GetWepName(i), -1);
            WepDamage[i] = -1;
        }
    }
    INI_SetTag(ini, "SystemToggle");
    INI_WriteBool(ini, "System", dmgEnabled);
    INI_Close(ini);
    return 1;
}