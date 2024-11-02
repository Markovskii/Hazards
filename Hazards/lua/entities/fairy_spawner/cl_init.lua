include("shared.lua")

local sprite = Material( "sprites/sprite_fairyspawner" )

function ENT:Draw()
	--self:DrawModel()
	if self == halo.RenderedEntity() then return end
	
	local pos = self:GetPos()
	local size = 25
	
	render.SetMaterial(sprite)
	render.DrawSprite( pos, size, size, Color(255,255,255))

	return
end