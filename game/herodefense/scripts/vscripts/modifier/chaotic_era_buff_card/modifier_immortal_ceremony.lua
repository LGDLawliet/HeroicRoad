
modifier_immortal_ceremony = advanced_modifier({})

function modifier_immortal_ceremony:IsHidden()return false end
function modifier_immortal_ceremony:IsDebuff()return false end
function modifier_immortal_ceremony:IsPurgable()return false end
function modifier_immortal_ceremony:IsPurgeException() 	return false end
function modifier_immortal_ceremony:RemoveOnDeath() return true end
function modifier_immortal_ceremony:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
-- function modifier_immortal_ceremony:GetTexture() return self.texture end

function modifier_immortal_ceremony:OnCreated(keys)
    if IsServer() then
        -- print("okkkkkkkkkkkk")
        self.value1 = GetChaticEra_BuffCardSpecial(self,"value1",keys.level or 1)
        self.value2 = GetChaticEra_BuffCardSpecial(self,"value2",keys.level or 1)
        self.value3 = GetChaticEra_BuffCardSpecial(self,"value3",keys.level or 1)

    end
end



function modifier_immortal_ceremony:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_RunePorgressBonus,
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Undeath_StackGain,

    }
end



function modifier_immortal_ceremony:Advanced_GetChaotic_Era_RunePorgressBonus(keys)
    if IsUndead(keys.UnitName) then
        if self.value2>=RandomInt(1, 100) then
            print("产生增益")
            return self.value3
        end
    end
	return 0
end



function modifier_immortal_ceremony:Advanced_Chaotic_Era_Undeath_StackGain(keys)
	return  self.value1
end