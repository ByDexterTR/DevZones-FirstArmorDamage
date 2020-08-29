// ------ #include ------ //

#include <sourcemod>
#include <devzones>
#include <sdkhooks>
#include <multicolors>

// ------ #pragma ------ //

#pragma semicolon 1
#pragma newdecls required

// ------ myinfo ------ //

public Plugin myinfo = 
{
	name = "SM DEV ZONES - First Armor Damage",
	author = "ByDexter",
	description = "",
	version = "1.0",
	url = "https://steamcommunity.com/id/ByDexterTR/"
};

public void OnClientDisconnect(int client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, Event_OnTakeDamage);
}

public void Zone_OnClientEntry(int client, const char[] zone)
{
	if(client < 1 || client > MaxClients || !IsClientInGame(client) ||!IsPlayerAlive(client)) 
		return;
		
	if(StrContains(zone, "firstarmor", false) == 0)
	{
		SDKHook(client, SDKHook_OnTakeDamage, Event_OnTakeDamage);
		CPrintToChat(client, "{darkred}[ByDexter] {green}firstarmor Bölgesine {default}girdiniz, {darkblue}artık hasar yediğinizde önce armorunuz gidecek.");
	}
}

public void Zone_OnClientLeave(int client, const char[] zone)
{
	if(client < 1 || client > MaxClients || !IsClientInGame(client) ||!IsPlayerAlive(client)) 
		return;
		
	if(StrContains(zone, "firstarmor", false) == 0)
	{
		SDKUnhook(client, SDKHook_OnTakeDamage, Event_OnTakeDamage);
		CPrintToChat(client, "{darkred}[ByDexter] {green}firstarmor Bölgesinden {default}ayrıldınız.");
	}
}

// - Credits - // ( https://forums.alliedmods.net/showthread.php?t=312255 )

public Action Event_OnTakeDamage(int victim, int &attacker, int &inflictor, float &damage, int &damagetype)
{ 
	int Armor = GetEntProp(victim, Prop_Send, "m_ArmorValue");
	if(Armor < 0)
		return Plugin_Continue;
	int CleanDamage = RoundFloat(damage);
	if(Armor >= CleanDamage)
	{
		Armor -= CleanDamage;
		SetEntProp(victim, Prop_Send, "m_ArmorValue", Armor);
		damage = 0.0;
		return Plugin_Changed;
	}
	else
	{
		SetEntProp(victim, Prop_Send, "m_ArmorValue", 0);
		damage -= float(Armor);
		return Plugin_Changed;
	}
}