
if (SERVER) then
	resource.AddFile( "models/minecraft/torch.mdl" )
	resource.AddFile( "materials/entities/ent_minecraft_torch.png" )
	resource.AddFile( "materials/entities/weapon_minecraft_torch.png" )
	resource.AddFile( "materials/minecraft/torch.vmt" )
	resource.AddFile( "materials/minecraft/torch_break.vmt" )

	for i = 1, 4 do
		resource.AddFile( "sound/minecraft/wood" .. i .. ".wav" )
		resource.AddFile( "materials/minecraft/particle" .. i .. ".vmt" )
	end
end

AddCSLuaFile()

SWEP.PrintName = "Minecraft Torch"
SWEP.Author = "Robotboy655"
SWEP.Category = "Robotboy655's Weapons"
SWEP.Contact = "robotboy655@gmail.com"
SWEP.Purpose = "To spread fire!"
SWEP.Instructions = "Primary break torch, secondary place, reload delete all."

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.ViewModel = "models/minecraft/torch.mdl"
SWEP.WorldModel = "models/minecraft/torch.mdl"
SWEP.ViewModelFOV = 55
SWEP.HoldType = "melee"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )

	if ( SERVER ) then return end 

	self.SmoothLight = math.random( 256, 512 )
	self.Emitter = ParticleEmitter( Vector( 0, 0, 0 ) )
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

-- Yeah, the reload thingy is really dirty.
SWEP.LastReload = 0
function SWEP:Reload()
end

function SWEP:OnRemove()
	if ( CLIENT && self.Emitter ) then self.Emitter:Finish() end
end

SWEP.NextEffect = 0.1
function SWEP:DrawEffects(TPos)
	if ( IsValid( self.Owner ) && self.Owner:WaterLevel() > 2 ) then return end
	if ( !IsValid( self.Owner ) ) then TPos = TPos + self:GetAngles():Up() * 10 end

	self.SmoothLight = math.Approach( self.SmoothLight, math.random( 256, 512 ), 2.5 )
	
	local iTorchLight = DynamicLight( self:EntIndex() )
	if ( iTorchLight ) then
		iTorchLight.Pos = TPos
		iTorchLight.r = 255
		iTorchLight.g = 128
		iTorchLight.b = 0
		iTorchLight.Brightness = 1
		iTorchLight.Size = self.SmoothLight
		iTorchLight.Decay = 2500
		iTorchLight.DieTime = CurTime() + 0.1
	end

	if ( CurTime() > self.NextEffect ) then
		self.NextEffect = CurTime() + math.Rand( 0.1, 0.5 )
		if ( self.Emitter ) then
			local particle = self.Emitter:Add( "minecraft/particle" .. math.random( 1, 4 ), TPos )
			if ( particle ) then
				particle:SetDieTime( 0.8 )
				particle:SetStartAlpha( 255 )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 4 )
				particle:SetEndSize( 1 )
				particle:SetAirResistance( 256 )
				particle:SetGravity( Vector( 0, 0, 128 ) )
			end
		end
	end
end

function SWEP:Deploy()
	self:SetModelScale( 0.5, 0 )
	return true
end

function SWEP:DrawWorldModel()
	if ( IsValid( self.Owner ) ) then
		local attachment = self.Owner:GetAttachment( self.Owner:LookupAttachment( "anim_attachment_RH" ) )
		if ( attachment ) then
			local pos, ang = attachment.Pos, attachment.Ang
			ang:RotateAroundAxis( ang:Up(), 12 )
			ang:RotateAroundAxis( ang:Forward(), -16 )
			self:SetRenderOrigin( pos - ang:Up() * 3 )
			self:SetRenderAngles( ang )
		end
	end
	self:DrawModel()
	self:DrawEffects( self:GetPos() + self:GetAngles():Up() * 8 )
end

function SWEP:GetViewModelPosition( pos, ang )
	local anim = math.min( math.max( ( self:GetNextPrimaryFire() - CurTime() ) * 2, 0 ), 1 )
	local VMPos = pos + ang:Forward() * 32 * ( anim + 1 ) + ang:Right() * 16 + ang:Up() * ( -24 + anim * 8 )
	local VMAng = ang + Angle( anim * 64, anim * 48, 0 )

	if ( !LocalPlayer():ShouldDrawLocalPlayer() ) then self:DrawEffects( VMPos + VMAng:Up() * 20 + VMAng:Forward() * -20 + VMAng:Right() * -4 ) end

	return VMPos, VMAng
end
