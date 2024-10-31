function EFFECT:Init( data )
	-- Because CEffectData is a shared object, we can't just store it and use its' properties later
	-- Instead, we store the properties themselves
	self.offset = data:GetOrigin()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	local emitter = ParticleEmitter( self.offset, false )
		for i=0, 1 do
			local direction = Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10))
			local particle = emitter:Add("effects/muzzleflash1", self.offset)
			if particle then
				particle:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
				particle:SetVelocity(direction)
				particle:SetColor( 155, 200, 0)
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 1 )
				particle:SetStartAlpha(200)
				particle:SetEndAlpha( 0 )
				particle:SetStartSize(50)
				particle:SetEndSize(0)
			end
		end
	emitter:Finish()
end