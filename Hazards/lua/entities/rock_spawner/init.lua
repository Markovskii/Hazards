AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


-- Server-side initialization function for the entity
function ENT:Initialize()

	self:SetModel( "models/hunter/blocks/cube05x05x05.mdl" )
	if IsValid(self:GetCreator()) then
		self:PhysicsInit( SOLID_VPHYSICS )
		self:EnableCustomCollisions()
		self:SetCollisionGroup( COLLISION_GROUP_WORLD )
		self:DrawShadow(false)
		
	else self:SetNoDraw(true)
	end

	
	self.next_rock = CurTime()+math.random(30,60)
end



--This is the example from the wiki page
--"Allows players to shoot through the entity, but still stand on it and use the Physics Gun on it, etc."
local sent_contents = CONTENTS_DEBRIS
local sent_contents2 = CONTENTS_SOLID
function ENT:TestCollision( startpos, delta, isbox, extents, mask )
	if bit.band( mask, sent_contents ) != 0 then return true end
end


function ENT:Think()
	if math.floor(self.next_rock - CurTime()) == 3 then
		self.next_rock = self.next_rock-1
		self:EmitSound("npc/antlion/rumble1.wav", 85, 100, 1)
		self:EmitSound("ambient/levels/streetwar/building_rubble"..math.random(1,5)..".wav", 85, 100, 1)
		self:EmitSound("physics/wood/wood_strain"..math.random(1,8)..".wav", 85, 30, 1)
	end
	if CurTime() < self.next_rock then return end
	
	local rock = ents.Create("rock")
	rock:SetPos(self:GetPos()+Vector(0,0,30))
	rock:Spawn()
	
	self.next_rock = CurTime()+math.random(30,60)
	
end


