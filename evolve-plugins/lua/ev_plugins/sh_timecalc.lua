/*-------------------------------------------------------------------------------------------------------------------------
	Calculates the time in a number of seconds
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Time calculation"
PLUGIN.Description = "Calculates the duration of the first argument."
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "timecalc"
PLUGIN.Usage = "<time>"

function PLUGIN:Call( ply, args )
	
	if not ply:EV_IsOwner() then
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
		return
	end
	
	local maxNumValue = math.pow( 2, 1024 ) - 1
	local invalidTxt = "Please specify a number between 0 and " .. maxNumValue .. "."
	
	if table.Count( args ) == 0 or args[1] == nil then
		evolve:Notify( ply, evolve.colors.red, invalidTxt )
		return
	end
	
	local time = math.max( tonumber( args[1] ) or 0, 0 )
	
	evolve:Notify( ply, evolve.colors.blue, tostring( time ) .. " seconds", evolve.colors.white, " is approximately ", evolve.colors.red, evolve:FormatTime( time ), evolve.colors.white, "." )
end

evolve:RegisterPlugin( PLUGIN )