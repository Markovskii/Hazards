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

	
	self.next_fireball = CurTime()+math.random(5,60)
end



--This is the example from the wiki page
--"Allows players to shoot through the entity, but still stand on it and use the Physics Gun on it, etc."
local sent_contents = CONTENTS_DEBRIS
local sent_contents2 = CONTENTS_SOLID
function ENT:TestCollision( startpos, delta, isbox, extents, mask )
	if bit.band( mask, sent_contents ) != 0 then return true end
end


function ENT:Think()
	if CurTime() < self.next_fireball then return end
	
	for i=1,math.random(2,3) do
		local fireball = ents.Create("fireball")
		fireball:SetPos(self:GetPos()-Vector(0,0,20))
		fireball:Spawn()
	end
	
	self.next_fireball = CurTime()+math.random(5,60)
end


