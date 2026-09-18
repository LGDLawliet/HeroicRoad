item_chaotic_shaman_skull = class({})

LinkLuaModifier("modifier_item_chaotic_shaman_skull", "items/item_chaotic_shaman_skull", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_shaman_skull:GetIntrinsicModifierName()
	return "modifier_item_chaotic_shaman_skull"
end


modifier_item_chaotic_shaman_skull = advanced_modifier({})

function modifier_item_chaotic_shaman_skull:IsDebuff() return false end
function modifier_item_chaotic_shaman_skull:IsHidden() return true end
function modifier_item_chaotic_shaman_skull:IsPurgable() return false end


function modifier_item_chaotic_shaman_skull:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_summon = self.ability:GetSpecialValueFor("bonus_summon")
    self.summon_time = self.ability:GetSpecialValueFor("summon_time")
end

function modifier_item_chaotic_shaman_skull:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_item_chaotic_shaman_skull:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon
end
function modifier_item_chaotic_shaman_skull:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.summon_time
end

