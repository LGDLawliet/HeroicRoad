
modifier_destiny_fade = advanced_modifier({})

function modifier_destiny_fade:IsHidden()return false end
function modifier_destiny_fade:IsDebuff()return false end
function modifier_destiny_fade:IsPurgable()return false end
function modifier_destiny_fade:IsPurgeException() 	return false end
function modifier_destiny_fade:RemoveOnDeath() return true end
function modifier_destiny_fade:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_destiny_fade:GetTexture() return self.texture end

function modifier_destiny_fade:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)

    end
end



function modifier_destiny_fade:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,
    }
end



function modifier_destiny_fade:Advanced_GetChaotic_Era_RunePorgressBonus()
	return self.value1
end