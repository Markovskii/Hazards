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
		for i=0, 20 do
			local angle = (2*math.pi/20)*i
			local direction = Vector(math.sin(angle)*200, math.cos(angle)*200, math.random(-20,50))
			local particle = emitter:Add("particles/smokey", self.offset)
			if particle then
				particle:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
				particle:SetVelocity(direction)
				particle:SetColor( 155, 155, 155)
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.7 )
				particle:SetStartAlpha(50)
				particle:SetEndAlpha( 0 )
				particle:SetStartSize(20)
				particle:SetEndSize(40)
			end
		end
	emitter:Finish()
end