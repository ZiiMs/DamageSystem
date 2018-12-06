#include <a_samp>
#include <foreach>
#include <easyDialog>
#include <izcmd>
#include <sscanf2>


#define MAX_DAMAGE 100

// --Dialogs--
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

// Debuging //

#define debug 1


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
new dmgEnabled;
new WepDamage[43];


public OnFilterScriptInit()
{
	print("\n|----------------------------------|");
	print("|  Damage System by ZiiM               |");
	print("|----------------------------------|\n");
	for(new i = 0; i < 43; i++)
	{
		WepDamage[i] = -1;
	}
	return 1;
}

public OnFilterScriptExit()
{
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
                        if(dmgEnabled == 0)
                        {
                            dmgEnabled = 1;
                            format(msg, sizeof(msg), "%s just {A30104}Disabled{FFFFFF} the damage system", ReturnName(playerid));
                            SendClientMessage(playerid, 0xFFFFFFAA, msg);
                        }
                        else if(dmgEnabled == 1)
                        {
                            format(msg, sizeof(msg), "%s just {219A01}Enabled{FFFFFF} the damage system", ReturnName(playerid));
                            SendClientMessage(playerid, 0xFFFFFFAA, msg);
                            dmgEnabled = 0;
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
        		switch(listitem)
        		{
        			case 0:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 1:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 2:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 3:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 4:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 5:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 6:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 7:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 8:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 9:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 10:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 11:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 12:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 13:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 14:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 15:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 16:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 17:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 18:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(listitem));
        				SetPVarInt(playerid, "WepEdit", listitem);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 19:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(22));
        				SetPVarInt(playerid, "WepEdit", 22);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 20:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(23));
        				SetPVarInt(playerid, "WepEdit", 23);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 21:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(24));
        				SetPVarInt(playerid, "WepEdit", 24);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 22:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(25));
        				SetPVarInt(playerid, "WepEdit", 25);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 23:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(26));
        				SetPVarInt(playerid, "WepEdit", 26);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 24:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(27));
        				SetPVarInt(playerid, "WepEdit", 27);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 25:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(28));
        				SetPVarInt(playerid, "WepEdit", 28);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 26:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(29));
        				SetPVarInt(playerid, "WepEdit", 29);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 27:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(30));
        				SetPVarInt(playerid, "WepEdit", 30);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 28:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(31));
        				SetPVarInt(playerid, "WepEdit", 31);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 29:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(32));
        				SetPVarInt(playerid, "WepEdit", 32);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 30:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(33));
        				SetPVarInt(playerid, "WepEdit", 33);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 31:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(34));
        				SetPVarInt(playerid, "WepEdit", 34);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 32:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(35));
        				SetPVarInt(playerid, "WepEdit", 35);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 33:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(36));
        				SetPVarInt(playerid, "WepEdit", 36);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 34:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(37));
        				SetPVarInt(playerid, "WepEdit", 37);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 35:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(38));
        				SetPVarInt(playerid, "WepEdit", 38);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 36:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(40));
        				SetPVarInt(playerid, "WepEdit", 40);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 37:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(41));
        				SetPVarInt(playerid, "WepEdit", 41);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 38:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(42));
        				SetPVarInt(playerid, "WepEdit", 42);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        			case 39:
        			{
        				new caption[32];
        				format(caption, sizeof(caption), "%s", GetWepName(42));
        				SetPVarInt(playerid, "WepEdit", 42);
        				ShowPlayerDialog(playerid, DIALOG_SET_DAMAGE, DIALOG_STYLE_INPUT, caption, "Please input weapon damage\n{FF0000}For default damage set the damage to -1", "Enter", "Close");
        			}
        		}
            }

		}
		case DIALOG_SET_DAMAGE:
		{
			new EditWep = GetPVarInt(playerid, "WepEdit");
			new Damage = strval(inputtext);
			WepDamage[EditWep] = Damage;

			#if debug == 1 
                printf("Editing Wep: %s(%d) | Weapon Damage: %d(%d)", GetWepName(EditWep), EditWep, WepDamage[EditWep], Damage);
            #endif
		}
		case DIALOG_ENABLE_DISABLE:
		{

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
        if(dmgEnabled == 0)
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
    		}
    		else
    		{
    			DamageData[playerid][id][dmgDamage] = WepDamage[weaponid];
                cdam = 1;
                #if debug == 1
    			 printf("Wep: %d", WepDamage[weaponid]);
                #endif
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
            switch(weaponid)
            {

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
    if(dmgEnabled == 1) return SendClientMessage(playerid, 0xFFFFFFAA, "The damage system is disabled. Ask for an admin to renable it.");
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

CMD:checkteam(playerid, params[])
{
    new playa;
    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000AA,"You are not a admin");
        return 1;
    }
    if (!sscanf(params, "u", playa))
    {
        new string[128];
        format(string, sizeof(string), "%s is on team %d", ReturnName(playa), GetPlayerTeam(playa));
        SendClientMessageToAll(0xFF0000AA, string);

    } else {
        SendClientMessage(playerid, 0xFF0000AA, "[SYNTAX] /checkteam [playerid/name]");
    }
    return 1;
}

CMD:setteam(playerid, params[])
{
    new playa, team;
    if(!IsPlayerAdmin(playerid))
    {
        SendClientMessage(playerid, 0xFF0000AA,"You are not a admin");
        return 1;
    }
    if (!sscanf(params, "ud", playa, team))
    {
        new string[128];
        format(string, sizeof(string), "%s set %s to team %d", ReturnName(playerid), ReturnName(playa), team);
        SendClientMessageToAll(0xFF0000AA, string);
        SetPlayerTeam(playa, team);

    } else {
        SendClientMessage(playerid, 0xFF0000AA, "[SYNTAX] /checkteam [playerid/name]");
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
    if(dmgEnabled == 1) return SendClientMessage(playerid, 0xFFFFFFAA, "The damage system is disabled. Ask for an admin to renable it.");
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
    if(dmgEnabled == 0)
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