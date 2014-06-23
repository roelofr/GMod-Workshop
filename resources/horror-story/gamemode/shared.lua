--
-- Make BaseClass available
--
DeriveGamemode( "Sandbox" )

GM.Name 	= "Team Charlie"
GM.Author 	= "Roelof"
GM.Email 	= "roelof@tmg-clan.com"
GM.Website 	= "www.tmg-clan.com"

--[[---------------------------------------------------------
   Name: gamemode:PlayerNoClip( player, bool )
   Desc: Player pressed the noclip key, return true if
		  the player is allowed to noclip, false to block
-----------------------------------------------------------]]
function GM:PlayerNoClip( pl, on )
	
	-- Don't allow if player is in vehicle
	if ( pl:InVehicle() ) then return false end
	
	-- Always allow in single player
	if ( game.SinglePlayer() ) then return true end

	return GetConVarNumber( "sbox_noclip" ) > 0
	
end

--[[---------------------------------------------------------
   Name: gamemode:CanProperty( pl, property, ent )
   Desc: Block all tools
-----------------------------------------------------------]]
function GM:CanProperty( pl, property, ent )
	
	return false
	
end

--[[---------------------------------------------------------
   Name: gamemode:CanProperty( pl, property, ent )
   Desc: Can the player do this property, to this entity?
-----------------------------------------------------------]]
function GM:CanDrive( pl, ent )
	--Never allow driving
	return false
	
end