include("shared.lua")


local materials = {Material( "sprites/flamelet1" ), Material( "sprites/flamelet2" ), Material( "sprites/flamelet3" )}
local glow_material = Material( "particle/particle_glow_05" )


function ENT:Draw()
	self:DrawModel()
	

end