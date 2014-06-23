--[[

Team Charlie Server-Side init.

]]

DeriveGamemode( "Base" )

include( "resource.lua" )
include( "net.lua" )

function GM:Initialize( )
	gamemode.LastBigThink = 0
	gamemode.LastSmallThink = 0
	
	gamemode.TopSpawnPos = 0
	
	gamemode.plySpawns = {}
	gamemode.plySpawnTime = {}
	
	gamemode.AllModels = {
		"models/player/group01/female_06.mdl",
		"models/player/group01/female_01.mdl",
		"models/player/group01/female_07.mdl",
		"models/player/group01/female_04.mdl",
		"models/player/group03/female_06.mdl",
		"models/player/group01/female_02.mdl",
		"models/player/group03/male_07.mdl",
		"models/player/group03/female_03.mdl",
		"models/player/group01/male_01.mdl",
		"models/player/group01/male_03.mdl",
		"models/player/group03/female_04.mdl",
		"models/player/group01/male_02.mdl",
		"models/player/group03/female_01.mdl",
		"models/player/group01/male_09.mdl",
		"models/player/group03/male_04.mdl",
		"models/player/group03/male_01.mdl",
		"models/player/group01/male_06.mdl",
		"models/player/group03/female_02.mdl",
		"models/player/group01/male_07.mdl",
		"models/player/group01/female_03.mdl",
		"models/player/group01/male_08.mdl",
		"models/player/group01/male_04.mdl",
		"models/player/group03/female_07.mdl",
		"models/player/group03/male_02.mdl",
		"models/player/group03/male_06.mdl",
		"models/player/group03/male_03.mdl",
		"models/player/group03/male_05.mdl",
		"models/player/group03/male_09.mdl",
		"models/player/group01/male_05.mdl",
		"models/player/group03/male_08.mdl"
	}
	
	gamemode.Weapons = {
		"weapon_minecraft_torch_mod",
		"weapon_crowbar"
	}
end

function GM:PlayerInitialSpawn( pl )
	pl.ChickList = {}
end

function GM:PlayerSay( pl, text, team )
	local useLocalSpawnPos = false
	
	if text == "/reset" and useLocalSpawnPos then
		gamemode.plySpawns[ pl:SteamID() ] = nil
		pl:ChatPrint( "Spawnpoint reset!" )
		if gamemode.plySpawnTime[ pl:SteamID() ] != nil and gamemode.plySpawnTime[ pl:SteamID() ] > RealTime() - 10 then
			pl:SetPos( gamemode.Call( "PlayerSelectSpawn", pl ):GetPos() )
		end
		return ""		
	end
end

function GM:PlayerInitialSpawn( pl )
	pl.model = table.Random( gamemode.AllModels )
end

function GM:PlayerSpawn( pl )
	
	
	
	gamemode.plySpawnTime[ pl:SteamID() ] = RealTime()
	
	--if gamemode.plySpawns[pl:SteamID()] != nil then
	--	pl:SetPos( gamemode.plySpawns )
	--	pl:ChatPrint( "Spawned at death point, type /reset to reset." )
	--else
	--	
	--end
	pl:SetPos( gamemode.Call( "PlayerSelectSpawn", pl ):GetPos() )
	
	player_manager.SetPlayerClass( pl, "player_sandbox" )
	
	pl:SetModel( pl.model )
	
	pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	gamemode.Call( "PlayerLoadout", pl )
	
end

function GM:PlayerLoadout( pl )
	pl:StripWeapons()
	for _, wep in pairs( gamemode.Weapons ) do
		pl:Give( wep )
	end
	return true
end

function GM:PlayerSwitchFlashlight( pl, onoff )
	return !onoff
end

function GM:PlayerNoClip( pl )
	return false
end

function GM:PlayerDeath( pl )
	gamemode.plySpawns[ pl:SteamID() ] = pl:GetPos() + Vector( 0, 0, 8 )
end

function GM:PlayerCanPickupWeapon( pl, weapon )
	if not weapon:IsValid() then return false end
	if table.HasValue( gamemode.Weapons, string.lower( weapon:GetClass() ) ) then
		return true
	else
		return false
	end
end