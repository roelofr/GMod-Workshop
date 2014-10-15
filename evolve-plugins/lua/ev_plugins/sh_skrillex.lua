/*-------------------------------------------------------------------------------------------------------------------------
	Ear rape a player
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Basedrop"
PLUGIN.Description = "Drop the bass"
PLUGIN.Author = "Roelof"
PLUGIN.ChatCommand = "drop"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "Drop the base" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Drop the base" ) ) then
		local players = evolve:FindPlayer( args, ply, true )
		local enabled = ( tonumber( args[ #args ] ) or 1 ) > 0
				
		net.Start( "evolve_dropthebass" )
		net.Send( players )
		
		for _, pl in ipairs( players ) do
			pl.DropBaseTime = RealTime()
		end
		
		if table.Count( players ) > 0 then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " has dropped the bass on ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:HUDPaint()
	local move = RealTime() - Either( LocalPlayer().DropBaseTime, LocalPlayer().DropBaseTime, 0 )
	if move < 17 and move > 1.5 then
		local mul = math.Clamp( 17 - move, 0, 2 ) / 2 * 100
		
		surface.SetDrawColor( Color( math.random( 10, 250 ),  math.random( 10, 250 ),  math.random( 10, 250 ), mul ) )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end
end

function PLUGIN:HUDShouldDraw( name )
	local move = RealTime() - Either( LocalPlayer().DropBaseTime, LocalPlayer().DropBaseTime, 0 )
	if move < 19 and move > 1.5 then
		local no = { "CHudDeathNotice", "CHudHealth", "CHudSecondaryAmmo", "CHudAmmo", "CHudCrosshair", "CHudBattery" }
		if table.HasValue( no, name ) then
			return false
		end
	end
end

function PLUGIN:CalcView( ply, origin, angles, fov, znear, zfar )
	local move = RealTime() - Either( ply.DropBaseTime, ply.DropBaseTime, 0 )
	
	if move < 17 and move > 1.5 then
		local view = {}
		view.origin 		= origin
		view.angles			= angles
		view.fov 			= fov
		view.znear			= znear
		view.zfar			= zfar
		view.drawviewer		= false
	
		local mul = math.Clamp( 17 - move, 0, 2 ) / 2
		
		view.angles:RotateAroundAxis( view.angles:Right(), ( math.sin( math.pi * 10 * move ) * 22.5 * mul ) )
		view.angles:RotateAroundAxis( view.angles:Up(), ( math.sin( math.pi * (30/17) * move ) * 11 * mul ) )
		
		return view
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		table.insert( players, arg )
		RunConsoleCommand( "ev", "drop", unpack( players ) )
	else
		return "Drop the bass", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )

if SERVER then
	resource.AddFile( "sound/evolve/dropthebass.mp3" )
	util.AddNetworkString( "evolve_dropthebass" )
else
	util.PrecacheSound( "evolve/dropthebass.mp3" )
	net.Receive( "evolve_dropthebass", function()
			surface.PlaySound( "evolve/dropthebass.mp3" )	
			LocalPlayer().DropBaseTime = RealTime()
	end )
end