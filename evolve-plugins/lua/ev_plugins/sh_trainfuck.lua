/*-------------------------------------------------------------------------------------------------------------------------
	Fuck a player with a train
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Trainfuck"
PLUGIN.Description = "Trainfuck a player."
PLUGIN.Author = "Divran"
PLUGIN.ChatCommand = "trainfuck"
PLUGIN.Usage = "[players]"
PLUGIN.Privileges = { "trainfuck" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "trainfuck" ) ) then
		local players = evolve:FindPlayer( args, ply )
		
		for _, pl in ipairs( players ) do
			pl:SetMoveType( MOVETYPE_WALK )
			pl:GodDisable()
			pl:SetHealth( 100 )
			pl:SetArmor( 0 )
			
			self:SpawnTrain( pl:GetPos() + pl:GetForward() * 1000 + Vector(0,0,50), pl:GetForward() * -1 )
		end
		
		if ( #players > 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " brutally trainfucked ", evolve.colors.red, evolve:CreatePlayerList( players ), evolve.colors.white, "." )
		else
			evolve:Notify( ply, evolve.colors.red, "No matching players found." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

function PLUGIN:SpawnTrain( Pos, Direction )
	local train = ents.Create( "prop_physics" )
	train:SetModel("models/props_vehicles/train_boxcar.mdl")
	train:SetAngles( Direction:Angle() )
	train:SetPos( Pos )
	train:Spawn()
	train:Activate()
	train:EmitSound( "ambient/alarms/train_horn2.wav", 100, 100 )
	train:GetPhysicsObject():SetVelocity( Direction * 50000 )
	
	if NADMOD then
		NADMOD.SetOwnerWorld( train )
	end
	
	timer.Simple( 5, function()
		if IsValid( train ) then
			train:Remove() 
		end
	end )
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "trainfuck", unpack( players ) )
	else
		return "Trainfuck", evolve.category.punishment
	end
end

evolve:RegisterPlugin( PLUGIN )