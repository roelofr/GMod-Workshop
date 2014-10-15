/*-------------------------------------------------------------------------------------------------------------------------
	Shows a player's {TMG} Profile
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Remove world ropes"
PLUGIN.Description = "Removes all ropes attached to the world, and the world only"
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "removeropes"
PLUGIN.Usage = ""
PLUGIN.Privileges = { "Cleanup" }

function PLUGIN:Call( ply, args )
	if not ply:EV_HasPrivilege( "Cleanup" ) then
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	else
		local rmC = 0
		
		local tbl = ents.FindByClass( "keyframe_rope" )
		for _, rope in pairs( tbl ) do
		
			local subtable = rope:GetTable()
			
			local e1, e2 = subtable["Ent1"], subtable["Ent2"]
			if e1 != e2 then continue end
			
			if e1 == game.GetWorld() then
				rope:Remove()
				rmC = rmC + 1
			end
		end
		
		if rmC > 0 then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has removed ", evolve.colors.red, tostring( rmC ), evolve.colors.white, " ", Either( rmC == 1, "rope", "ropes" ), " that were attached to the world." )
		else
			evolve:Notify( ply, evolve.colors.red, "No ropes are attached to the world." )
		end
	end
	
end

evolve:RegisterPlugin( PLUGIN )