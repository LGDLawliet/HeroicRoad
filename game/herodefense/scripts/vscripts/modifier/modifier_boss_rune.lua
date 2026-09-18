modifier_boss_rune = advanced_modifier({})

function modifier_boss_rune:IsHidden()return true end
function modifier_boss_rune:IsDebuff()return true end
function modifier_boss_rune:IsPurgable()return false end
function modifier_boss_rune:IsPurgeException() 	return false end
function modifier_boss_rune:GetTexture() return "chaotic_era_spell/chaotic_summon_advanced_lightning_sphere_element" end
function modifier_boss_rune:RemoveOnDeath() return false end

function modifier_boss_rune:OnCreated(keys)
	self:SetStackCount(0)
end
function modifier_boss_rune:DeclareFunctions(keys)
	return {MODIFIER_PROPERTY_TOOLTIP}
end
function modifier_boss_rune:OnTooltip(keys)
	return self:GetStackCount()
end