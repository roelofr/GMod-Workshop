/*-------------------------------------------------------------------------------------------------------------------------
	Shows a player's {TMG} Profile
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Profile"
PLUGIN.Description = "Show's a user's {TMG} Profile"
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "profile"
PLUGIN.Usage = "<player>"

function PLUGIN:Call( ply, args )
	if tmg_profile == nil then 
		evolve:Notify( ply, evolve.colors.red, "{TMG} Profile isn't available right now!" )
		return
	end
	local pl = evolve:FindPlayer( args[1] )
	if table.Count( pl ) > 1 then
		if table.Count( pl ) == table.Count( player.GetAll() ) then
			evolve:Notify( ply, evolve.colors.white, "You selected ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, ". You can only select one player." )
		else
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
		end
	elseif ( #pl == 1 ) then
		local from = pl[1]:SteamID()
		local to = ply:SteamID()
		tmg_profile.Open( pl[1], ply )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "profile", players[1], arg )
	else
		return "{TMG} Profile", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )