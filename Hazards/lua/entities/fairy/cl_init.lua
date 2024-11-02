include("shared.lua")


local fairy_material = Material( "effects/strider_muzzle" )
--local fairy_material = Material( "effects/rollerglow" )


function ENT:Initialize()
	self:SetRenderBounds(Vector(-100,-100,0), Vector(100,100,200))
	self.gene = self:EntIndex()/1000
end

function ENT:RenderFairies()
	for i=10,50 do
		local spread = self:GetProgress()/10+1
		local speed = self:GetProgress()/10000+1+self.gene
		local pattern = Vector(
		math.sin(CurTime()/i*speed*12)*i*spread,
		math.cos(CurTime()/i*speed*13)*i*spread,
		math.sin(CurTime()/i*speed*14)*30*spread+30*speed*speed)
	
		local color = Color(200,105+i*3,255)
		local pos = self:GetPos() + pattern
		local size = math.sin(i)*8
		render.SetMaterial( fairy_material )
		render.DrawSprite( pos, size, size, color)
	end
end

function ENT:RenderLight()
	local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.pos = self:GetPos()+Vector(0,0,25)
		dlight.r = 50
		dlight.g = 255
		dlight.b = 200
		dlight.brightness = 1.5
		dlight.decay = 1000
		dlight.size = 400
		dlight.dietime = CurTime() + 0.1
		dlight.style = 1
	end
end

function ENT:Draw()
	if self == halo.RenderedEntity() then return end
	
	self:RenderFairies()
	self:RenderLight()

end