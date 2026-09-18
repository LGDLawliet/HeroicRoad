
modifier_chaotic_era_self_regen = advanced_modifier({})

function modifier_chaotic_era_self_regen:IsHidden()return false end
function modifier_chaotic_era_self_regen:IsDebuff()return false end
function modifier_chaotic_era_self_regen:IsPurgable()return false end
function modifier_chaotic_era_self_regen:IsPurgeException() 	return false end
function modifier_chaotic_era_self_regen:RemoveOnDeath() return true end
function modifier_chaotic_era_self_regen:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_chaotic_era_self_regen:GetTexture() return self.texture end
-- function modifier_chaotic_era_self_regen:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/spell/chaotic_era_super_boxing/effect_main/effect", context )
-- end
function modifier_chaotic_era_self_regen:OnCreated(keys)
    self.texture = GetChaticEraCreep_BuffTexture(self)
    self.bonus1 = GetChaticEraCreep_BuffSpecial(self,"value1")
	-- self.bonus2 = GetChaticEraCreep_BuffSpecial(self,"value2")
    if IsServer() then
		-- self:SetStackCount(GetChaticEraCreep_BuffSpecial(self,"value1"))
    end
end



function modifier_chaotic_era_self_regen:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_chaotic_era_self_regen:AdvancedGetModifierConstantHealthRegenPercentage()
	return self.bonus1
end



function modifier_chaotic_era_self_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_chaotic_era_self_regen:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self.bonus1
	end
end

