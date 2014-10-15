/*-------------------------------------------------------------------------------------------------------------------------
	Opens the MOTD on a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "MOTD"
PLUGIN.Description = "Opens the message of the day on a player or on the user itself."
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "motd"
PLUGIN.Usage = "<player>"
PLUGIN.Privileges = { "MOTD", "MOTDSelf" }

function PLUGIN:Call( ply, args )
	if ply:EV_HasPrivilege( "MOTD" ) or ply:EV_HasPrivilege( "MOTDSelf" ) then
	
		local target = nil
		if args[1] == nil or string.len( args[1] ) == 0 then
			target = ply
		else
			local players = evolve:FindPlayer( args[1] )
			if table.Count( players ) == 1 then
				target = players[1]
			elseif table.Count( players ) > 1 then
				evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?" )
			else
				evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
			end
		end
		
		if target != nil and IsValid( target ) then
			net.Start( "tmg_openMOTD" )
			net.Send( target )
			evolve:Notify( ply, evolve.colors.white, "From ", Color( 100, 100, 100 ), "Console", evolve.colors.white, ": Opening the MOTD on ", target:Name(), "." )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "motd", players[1], arg )
	else
		return "(Re-)open MOTD", evolve.category.administration
	end
end

evolve:RegisterPlugin( PLUGIN )