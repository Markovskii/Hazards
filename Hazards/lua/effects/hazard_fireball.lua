function EFFECT:Init( data )
	-- Because CEffectData is a shared object, we can't just store it and use its' properties later
	-- Instead, we store the properties themselves
	self.offset = data:GetOrigin()
end

function EFFECT:Think()
	return false
end

material = Material("effects/fire_cloud1")

function EFFECT:Render()
	local emitter = ParticleEmitter( self.offset, false )
		for i=0, 20 do
			local direction = Vector(math.random(-600,600),math.random(-600,600),math.random(-600,600))
			local particle = emitter:Add(material, self.offset)
			if particle then
				particle:SetAngles(Angle(math.random(0,360),math.random(0,360),math.random(0,360)))
				particle:SetVelocity(direction)
				particle:SetColor( math.random(100,255), math.random(100,200), 0)
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.3 )
				particle:SetStartAlpha(255)
				particle:SetEndAlpha( 0 )
				particle:SetStartSize(math.random(0,100))
				particle:SetEndSize(math.random(0,100))
			end
		end
	emitter:Finish()
end