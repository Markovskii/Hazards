include("shared.lua")


local materials = {Material( "sprites/flamelet1" ), Material( "sprites/flamelet2" ), Material( "sprites/flamelet3" )}
local glow_material = Material( "particle/particle_glow_05" )


function ENT:Draw()
	if self == halo.RenderedEntity() then return end
	
	local pos = self:GetPos()
	
	local size = 50
	render.SetMaterial( materials[math.random(1,3)] )
	--render.DrawQuadEasy( pos, normal, size, size, Color(255,255,255,255), math.random(0,360)) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
	render.DrawSprite( pos, size, size, Color(255,255,255))

	render.SetMaterial(glow_material)
	--render.DrawQuadEasy( pos, normal, size, size, Color(255,255,255,255), math.random(0,360)) -- Draw the sprite in the middle of the map, at 16x16 in it's original colour with full alpha.
	render.DrawSprite( pos, size*5, size*5, Color(255,100,0))
	
	
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.brightness = 6
		dlight.decay = 5000
		dlight.size = 400
		dlight.dietime = CurTime() + 0.05
	end
	local dlight = DynamicLight( self:EntIndex()+1 )
	if ( dlight ) then
		dlight.pos = self:GetPos()
		dlight.r = 200
		dlight.g = 255
		dlight.b = 0
		dlight.brightness = 3
		dlight.decay = 5000
		dlight.size = 600
		dlight.dietime = CurTime() + 0.05
	end
end