/*-------------------------------------------------------------------------------------------------------------------------
	Ear rape a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Yeah, Miami Style"
PLUGIN.Description = "Gives that nice yeah after making a terrible pun"
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "yeahmiami"
PLUGIN.Usage = ""
PLUGIN.Privileges = { "Very Puny" }

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "Very Puny" ) then
	
		if not IsValid( ply ) then
			print("Not for console, sorry" )
			return
		end
	
		if not evolve.waitForPlayers then evolve.waitForPlayers = {} end
		
		evolve.waitForPlayers[ ply:SteamID() ] = "no"
		
		print("Starting to listen to " .. ply:Nick() .. "." )
		
		net.Start( "evolveYeahMiamiClient" )
		net.Send( ply )
		
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )

if SERVER then
	resource.AddFile( "sound/evolve/yeah-miami-style.mp3" )
	util.AddNetworkString( "evolveYeahMiamiServer" )
	util.AddNetworkString( "evolveYeahMiamiClient" )
	
	net.Receive( "evolveYeahMiamiServer", function( len, pl )
		if not evolve.waitForPlayers then return end
		
		if evolve.waitForPlayers[ pl:SteamID() ] and evolve.waitForPlayers[ pl:SteamID() ] == "no" then
			evolve.waitForPlayers[ pl:SteamID() ] = "yes"
			
			pl:EmitSound( "evolve/yeah-miami-style.mp3" )
		end
	end )
else
	util.PrecacheSound( "evolve/yeah-miami-style.mp3" )
	net.Receive( "evolveYeahMiamiClient", function()
		
		print("Received message" )
		
		if input.LookupBinding( "+voicerecord" ) != "x" then
			chat.AddText( evolve.colors.red, "This script only works when your voice button is the \"X\" on your keyboard." );
		else
			chat.AddText( evolve.colors.blue, "Start talking via voicechat. When you close your mic a YEAH will sound." )
			evolve.yeahMiamiState = "listen"
			
			hook.Add("Think", "YeahMiamiThink", function()
				if evolve.yeahMiamiState == nil or evolve.yeahMiamiState == "none" then return end
		
				if input.IsKeyDown( KEY_X ) and evolve.yeahMiamiState != "speaking" then
					evolve.yeahMiamiState = "speaking"
				end
				if not input.IsKeyDown( KEY_X ) and evolve.yeahMiamiState == "speaking" then
					evolve.yeahMiamiState = "none"
					
					hook.Remove("Think", "YeahMiamiThink" )
					
					net.Start("evolveYeahMiamiServer")
					net.SendToServer()
				end
			end )
		end
	end )
end