--[[

Team Charlie Client-Side init.

]]

include( "net.lua" )

local isPlaying = false

net.Receive( "startMusic", function( length )
	chat.AddText( "Starting music!" )
	if not isPlaying then
		isPlaying = true
		surface.PlaySound( "teamcharlie/chickenrun/main.mp3" )
	end
end )
net.Receive( "stopMusic", function( length )
	chat.AddText( "Stopping music!" )
	isPlaying = false
	RunConsoleCommand( "stopsound" )
end )