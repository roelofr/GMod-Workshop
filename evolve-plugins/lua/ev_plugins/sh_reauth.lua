/*-------------------------------------------------------------------------------------------------------------------------
	Re-Auth a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Re-Auth"
PLUGIN.Description = "Re-Auth a player."
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "reauth"
PLUGIN.Usage = "<player>"
PLUGIN.Privileges = { "Reauth" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Reauth" ) ) then
		local available = false
		available = tmg != nil and tmg.loading != nil  and tmg.loading.connected == true
		
		if not available then
			evolve:Notify( ply, evolve.colors.red, "{TMG} Sync is currently not available." )
		else
			local pl = evolve:FindPlayer( args[1] )
			if table.Count( pl ) > 0 then
				for _, ply in ipairs( pl ) do
					tmg.loading.Reauthorize( ply )
				end
				evolve:Notify( ply, evolve.colors.white, "From ", Color( 100, 100, 100 ), "Console", evolve.colors.white, ": You've started the re-authorization for ", evolve:CreatePlayerList( pl ), "." )
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
			end
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "reauth", players[1], arg )
	else
		return "Re-Authorize", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )