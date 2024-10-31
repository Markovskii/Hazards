AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


fire_ball_sound = Sound("ambient/fire/fire_big_loop1.wav")

-- Server-side initialization function for the entity
function ENT:Initialize()
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow(false)
	self.spawned_at = CurTime()
	self.origin = self:GetPos()
	self.velocity = Vector(math.random(-25,25),math.random(-25,25),math.random(15,30))
	self:EmitSound("ambient/explosions/exp"..math.random(1,4)..".wav", 90, 255, 1)
	self:EmitSound("ambient/levels/labs/electric_explosion"..math.random(1,4)..".wav", 90, 255, 1)
	self:EmitSound(fire_ball_sound, 90, 255, 1)
end





function ENT:Hurt()
	for _, entity in pairs(ents.FindInSphere(self:GetPos(), 300)) do
	
	
		if !IsValid(entity) then continue end
		if entity == self then continue end
		if !self:Visible(entity) then continue end
		if !(entity:IsNPC() or entity:IsPlayer() or entity:IsNextBot() or entity:GetClass() == "prop_physics") then continue end
		--if entity == self:GetOwner() then continue end
		--if entity:Health() <= 0 then continue end
		
		local diff = entity:GetPos()-self:GetPos()
		local dist = diff:LengthSqr()
		local danger = math.abs((90000-dist)/90000)
		local velocity = diff:GetNormal()*danger*300
		
	
		local dmg = DamageInfo() -- Create a server-side damage information class
		dmg:SetDamage(danger*100)
		dmg:SetAttacker(self)
		dmg:SetInflictor(self)
		dmg:SetDamageType(DMG_CLUB)
		dmg:SetDamageForce(-velocity)
		entity:TakeDamageInfo(dmg)
		entity:Ignite(danger*5,0)
		
		
		
		if entity:IsPlayer() then 
			entity:SetVelocity(velocity*10)
		end
	end
end

function ENT:Smoulder()
		local sfx = EffectData()
		sfx:SetEntity(self)
		sfx:SetOrigin(self:GetPos())
		util.Effect("hazard_smoulder", sfx, nil, true)
end

function ENT:FireBall()
		local sfx = EffectData()
		sfx:SetEntity(self)
		sfx:SetOrigin(self:GetPos())
		util.Effect("hazard_fireball", sfx, nil, true)
end

function ENT:Explode()
		self:EmitSound("ambient/explosions/explode_" .. math.random(5, 8) .. ".wav", 85, 255, 1)
		self:FireBall()
		self:Hurt()
		self:Remove()
end

function ENT:Hit()
	local tracedata = {}
	tracedata.start = self:GetPos()
	tracedata.endpos = self:GetPos() + self.velocity*5
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)
	if !trace.Hit then return end
	if trace.HitWorld then
		self:Explode()
	end
	if trace.Entity:GetClass() == "prop_physics" or trace.Entity:GetClass() == "prop_dynamic" then
		self:Explode()
	end
end

function ENT:Fly()
	self:SetPos(self:GetPos() + self.velocity)
	self.velocity = Vector(self.velocity.x/1.01,self.velocity.y/1.01,self.velocity.z-0.5)
end

function ENT:Think()
	self:Smoulder()
	self:Fly()
	self:Hit()
	
	local time_passed = CurTime() - self.spawned_at
	if time_passed > 10 then
		self:Remove()
	end
	
	self:NextThink(CurTime()+0.05)
	return true 
end

function ENT:OnRemove()
	self:StopSound(fire_ball_sound)
end

