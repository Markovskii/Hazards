AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local rocks = {Model("models/props_foliage/rock_forest01.mdl"),Model("models/props_foliage/rock_forest01a.mdl"),Model("models/props_foliage/rock_forest02.mdl")}

-- Server-side initialization function for the entity
function ENT:Initialize()
	self:SetModel(rocks[math.random(1,3)])
	self:PhysicsInit( SOLID_VPHYSICS )
	self:PhysWake()
	
	self.physobj = self:GetPhysicsObject()
	self.physobj:SetMass(20)
	
	self.rotation = Vector(math.random(-50,50),math.random(-50,50),math.random(-50,50))
	self.spawned_at = CurTime()
	
	self:Flake()
	self:EmitSound("physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav", 80, 100, 1)
end





function ENT:Hurt()
	for _, entity in pairs(ents.FindInSphere(self:GetPos(), 200)) do
	
	
		if !IsValid(entity) then continue end
		if entity == self then continue end
		if !self:Visible(entity) then continue end
		if !(entity:IsNPC() or entity:IsPlayer() or entity:GetClass() == "prop_physics") then continue end
		--if entity == self:GetOwner() then continue end
		--if entity:Health() <= 0 then continue end
		
		local diff = entity:GetPos()-self:GetPos()
		local dist = diff:LengthSqr()
		local danger = math.abs((40000-dist)/40000)
		local velocity = (diff:GetNormal())*danger*30
		
	
		local dmg = DamageInfo() -- Create a server-side damage information class
		dmg:SetDamage(danger*50)
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_CLUB)
		dmg:SetDamageForce(-velocity)
		entity:TakeDamageInfo(dmg)
		
		
		
		if entity:IsPlayer() then 
			entity:SetVelocity(velocity*10)
		end
	end
end

function ENT:Flake()
		local sfx = EffectData()
		sfx:SetEntity(self)
		sfx:SetOrigin(self:GetPos())
		util.Effect("hazard_flake", sfx, nil, true)
end

function ENT:Burst()
		self:EmitSound("physics/concrete/boulder_impact_hard"..math.random(1,4)..".wav", 80, 100, 1)
		local sfx = EffectData()
		sfx:SetEntity(self)
		sfx:SetOrigin(self:GetPos())
		util.Effect("hazard_burst", sfx, nil, true)
end

function ENT:Crumble()
		local sfx = EffectData()
		sfx:SetEntity(self)
		sfx:SetOrigin(self:GetPos())
		util.Effect("hazard_crumble", sfx, nil, true)
end

function ENT:Detonate()
		self:Burst()
		self:Hurt()
		self:Remove()
end

function ENT:Hit()
	local tracedata = {}
	tracedata.start = self:GetPos()
	tracedata.endpos = self:GetPos() + Vector(0,0,-40)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	if !trace.Hit then return end
	if trace.HitWorld then
		local velocity = self:GetVelocity()
		self.physobj:SetVelocity(velocity*2 + Vector(0,0,100))
		if trace.HitNormal.z > 0.8 then
			self:Detonate()
		end
	end
--	if trace.Entity:GetClass() == "prop_physics" or trace.Entity:GetClass() == "prop_dynamic" then
--		self:Explode()
--	end
end

function ENT:Touch(entity)
	self:Detonate()
end

function ENT:Think()
	self:Crumble()
	self:Hit()
	self.physobj:AddAngleVelocity(self.rotation)
	--self:Hit()
	
	local time_passed = CurTime() - self.spawned_at
	if time_passed > 10 then
		self:Remove()
	end
	
	self:NextThink(CurTime()+0.05)
	return true 
end

function ENT:OnRemove()
	self:SetModel( "models/hunter/blocks/cube05x05x05.mdl" )
end

