/*-------------------------------------------------------------------------------------------------------------------------
	Ask the helix fossil
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Ask Helix"
PLUGIN.Description = "Ask the almighty Helix Fossil a question"
PLUGIN.Author = "Nosjo"
PLUGIN.ChatCommand = "helix"
PLUGIN.Usage = "<question>"
PLUGIN.Privileges = { "Ask Helix Fossil" }

PLUGIN.HelixAnswers = {"It is certain.", "It is decidedly so.", "Without a doubt.",
"Yes, definitely.", "You may rely on it.", "As I see it, yes.","Most likely.", "Outlook: good.", "Yes.",
"Signs point to yes.", "Reply hazy, try again.","Ask again later.", "Better not tell you now.",
"Cannot predict now.", "Concentrate and ask again.","Don't count on it.", "My reply is no.", "My sources say no.",
"Outlook: not so good.", "Very doubtful.", "No.", "START", "A", "B", "UP","DOWN", "LEFT", "RIGHT", "SELECT"}

PLUGIN.SpecialAnswers = { "START", "A", "B", "UP","DOWN", "LEFT", "RIGHT", "SELECT" }

function PLUGIN:Call( ply, args )
	if not ply:EV_HasPrivilege( "Ask Helix Fossil" ) then
		return evolve:Notify( ply, evolve.colors.red, "The almighty Helix Fossil has no time for your shenanigans!" )
	end
	
	local question = string.lower( string.Trim( table.concat( args, " " ) ) )
	
	if string.len( question ) == 0 then
		return evolve:Notify( ply, evolve.colors.red, "No question specified." )
	end
	
	question = string.upper( string.Left( question, 1 ) ) .. string.sub( question, 2 )
	
	local rankColor = ( evolve.ranks[ ply:EV_GetRank() ].Color or team.GetColor( ply:Team() ) )
	evolve:Notify( rankColor, ply:Nick(), evolve.colors.white, ": Oh almighty Helix Fossil, " .. question )
	
	if table.HasValue(self.SpecialAnswers, string.upper( question ) ) then
		evolve:Notify( Color( 255, 201, 0, 255 ), "The Almighty Helix Fossil", evolve.colors.white, ": " .. string.upper( question ) )
	else
		local answer = util.CRC(question)
		answer = answer % table.Count( self.HelixAnswers )
		if answer == 0 then answer = 14 end
		
		evolve:Notify( Color( 255, 201, 0, 255 ), "The Almighty Helix Fossil", evolve.colors.white, ": " .. self.HelixAnswers[answer] )
	end
end

evolve:RegisterPlugin( PLUGIN )