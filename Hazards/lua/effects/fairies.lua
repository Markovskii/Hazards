local fairy = Material("effects/yellowflare")

function EFFECT:Init( data )
	-- Because CEffectData is a shared object, we can't just store it and use its' properties later
	-- Instead, we store the properties themselves
	self.entity = data:GetEntity()
	self.offset = self.entity:GetPos() + Vector( 0, 0, 30 )
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	local emitter = ParticleEmitter( self.offset, false )
		for i=0, 3 do
			direction = Vector(math.random(-20,20), math.random(-20,20), math.random(-5,10))
			--direction = Vector(100,0,0)
			
			local particle = emitter:Add(fairy, self.offset+direction)
			if particle then
				particle:SetAngles(Angle(0,0,0))
				particle:SetVelocity(direction)
				particle:SetAirResistance( 5 )
				particle:SetAngleVelocity(Angle(math.random(50,100),0,0))
				particle:SetColor(math.random(100,255), 255, math.random(100,255))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 5 )
				particle:SetStartAlpha(255)
				particle:SetEndAlpha( 0 )
				particle:SetStartSize(0)
				particle:SetEndSize(4)
				
				local function particle_twist(par)
					difference = self.entity:GetPos() - par.GetPos()
					difference:Rotate(Angle(1,0,0))
					par:SetPos(self.entity:GetPos() + difference)
					par:SetNextThink( CurTime() )
				end
				
				particle:SetThinkFunction( particle_twist )
				particle:SetNextThink( CurTime() )
			end
		end
	emitter:Finish()
end