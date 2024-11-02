AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


local fairy_sounds = {
Sound("vo/k_lab2/al_whee_b.wav"), 
Sound("ambient/animal/bird2.wav"), 
Sound("ambient/animal/bird20.wav"), 
Sound("ambient/levels/coast/coastbird5.wav"), 
Sound("ambient/misc/ambulance1.wav"), 
Sound("ambient/machines/heli_pass_distant1.wav"),
Sound("ambient/creatures/town_scared_sob2.wav"),
Sound("ambient/materials/flush1.wav"),
Sound("vo/eli_lab/al_laugh01.wav"),
Sound("vo/eli_lab/al_laugh02.wav"),
Sound("ambient/levels/prison/radio_random4.wav"),
Sound("ambient/levels/prison/radio_random7.wav"),
Sound("ambient/levels/streetwar/heli_distant1.wav")}

-- Server-side initialization function for the entity
function ENT:Initialize()
	self:PhysicsInit( SOLID_NONE )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:DrawShadow(false)
	
	self.spawned_at = CurTime()
	
	self.giggle_at = CurTime()+math.random(0.5,4)
	self.heal_at = CurTime()
	
	self.direction = Vector(0,0,0)
	self.started_flying_at = CurTime()
	self.flying = false
	self:Wander()
--	self:FlyTo(Vector(-32,-1026,-12759))
end

function ENT:Giggle()
	if self.giggle_at < CurTime() then
--		self:SpawnFairies()
		local index = math.random(1,#fairy_sounds)
		self:EmitSound(fairy_sounds[index], 75, 255, 0.6)
		self.giggle_at = CurTime()+math.random(0.5,4)
		
		if math.random(0,5) == 0 then
			self:Wander()
		end
	end
end

function ENT:FlyTo(pos)
	self:EmitSound("ambient/levels/labs/teleport_winddown1.wav", 80, 255, 0.5)
	self.direction = (pos - self:GetPos())/45
	self.started_flying_at = CurTime()
	self.flying = true
end

function ENT:Fly()
	local timescale = (CurTime()-self.started_flying_at)
	if timescale >= math.pi then self.flying = false return end
	
	local step = (math.sin(timescale))
	self:SetProgress(step*10+1)
	self:SetPos(self:GetPos()+step*self.direction)
end

function ENT:Wander()
	local best_direction = -1
	local best_fraction = 0
	local distance = math.random(500,1500)
	local variation = math.random(0,2*math.pi/7)
	for i=0,7 do
		local direction = 2*math.pi/7*i + variation
		direction = Vector(math.sin(direction), math.cos(direction),0)
		local tracedata = {}
		tracedata.start = self:GetPos() + Vector(0,0,25)
		tracedata.endpos = self:GetPos() + Vector(0,0,25) + direction*distance
--		tracedata.filter = self
		tracedata.collisiongroup = COLLISION_GROUP_DEBRIS
		local trace = util.TraceLine(tracedata)
		local fraction = trace.Fraction
		
		if best_fraction > fraction then continue end
		best_direction = direction
		best_fraction = fraction
	end
	if best_direction == -1 then return end
	
	local pos = self:GetPos() + (best_fraction*0.9*best_direction*distance)

	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = pos + Vector(0,0,300)
--	tracedata.filter = self
	tracedata.collisiongroup = COLLISION_GROUP_DEBRIS
	local trace = util.TraceLine(tracedata)
	local hitpos = trace.HitPos

	local tracedata = {}
	tracedata.start = hitpos
	tracedata.endpos = pos + Vector(0,0,-600)
	tracedata.mask = bit.bor(MASK_WATER, MASK_PLAYERSOLID_BRUSHONLY)
--	tracedata.filter = self
	tracedata.collisiongroup = COLLISION_GROUP_DEBRIS
	local trace = util.TraceLine(tracedata)
	local hitpos = trace.HitPos
	
	self:FlyTo(trace.HitPos)
--	self:FlyTo(self:GetPos() + (best_fraction*0.9*best_direction*1000))
end

function ENT:Heal()
	if self.heal_at > CurTime() then return end
	self.heal_at = CurTime()+0.3
	for _, entity in pairs(ents.FindInSphere(self:GetPos()+Vector(0,0,25), 30)) do
		if !IsValid(entity) then continue end
		if entity == self then continue end
		if !(entity:IsNPC() or entity:IsPlayer() or entity:IsNextBot()) then continue end
		local hp = entity:Health()
		local max_hp = entity:GetMaxHealth()
		self:Wander()
		self:EmitSound("ambient/machines/machine1_hit1.wav", 80, 255, 1)
		if hp >= max_hp then continue end
		local new_hp = hp + max_hp/5
		if new_hp > max_hp then new_hp = max_hp end
		entity:SetHealth(new_hp)
	end
end

--function ENT:SpawnFairies()
--	local sfx = EffectData()
--	sfx:SetEntity(self)
--	util.Effect("fairies", sfx, nil, true)
--end

function ENT:GoPoof()
	local sfx = EffectData()
	sfx:SetEntity(self)
	sfx:SetOrigin(self:GetPos())
	util.Effect("fairy_poof", sfx, nil, true)
	self:EmitSound("ambient/levels/prison/inside_battle_antlion4.wav", 80, 255, 0.5)
end

function ENT:Think()
	self:Giggle()
	if self.flying then
		self:Fly()
	else
		self:Heal()
	end
	
	if self.spawned_at+60 < CurTime() then
		self:GoPoof()
		self:Remove()
	end
	
	self:NextThink(CurTime()+0.05)
	return true 
end

