
modifier_emitsound_thinker = class({})

function modifier_emitsound_thinker:ModifierEmitSound(sound)
    self.sound = sound
	self:GetParent():EmitSound(sound)
end

function modifier_emitsound_thinker:OnDestroy(params)

    if self.sound then
        self:GetParent():StopSound(self.sound)
    end
	if not IsServer() then
		return
	end
	UTIL_Remove( self:GetParent() )
end
