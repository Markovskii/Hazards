local fairy_material = Material( "effects/strider_muzzle" )

function EFFECT:Init( data )
	-- Because CEffectData is a shared object, we can't just store it and use its' properties later
	-- Instead, we store the properties themselves
	self.entity = data:GetEntity()
end

function EFFECT:Think()
	return false
end

function EFFECT:Generate_Fairies()
	local pos = self:GetPos()
	local emitter = ParticleEmitter( self.entity:GetPos(), false )
	for i=10,50 do
		local spread = self.entity:GetProgress()/10+1
		local speed = self.entity:GetProgress()/10000+1+self.entity.gene
		local pattern = Vector(
		math.sin(CurTime()/i*speed*12)*i*spread,
		math.cos(CurTime()/i*speed*13)*i*spread,
		math.sin(CurTime()/i*speed*14)*30*spread+30*speed*speed)
	
		local color = Color(200,105+i*3,255)
		local pos = self.entity:GetPos() + pattern
		local size = math.sin(i)*4
		
--		render.SetMaterial( fairy_material )
--		render.DrawSprite( pos, size, size, color)

		local particle = emitter:Add(fairy_material, pos+Vector(0,0,10))
		if particle then
--			particle:SetAngles(Angle(0,0,0))
			particle:SetVelocity(Vector(math.random(-150,150),math.random(-150,150),math.random(-150,150)))
--			particle:SetAirResistance( 5 )
--			particle:SetAngleVelocity(Angle(math.random(50,100),0,0))
			particle:SetColor(color.r, color.b, color.g)
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 3 )
			particle:SetStartAlpha(255)
			particle:SetEndAlpha( 0 )
			particle:SetStartSize(size)
			particle:SetEndSize(0)
		end
	end
	emitter:Finish()
end

function EFFECT:Render()
	self:Generate_Fairies()
end