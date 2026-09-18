item_chaotic_shaman_necklace = class({})

LinkLuaModifier("modifier_item_chaotic_shaman_necklace", "items/item_chaotic_shaman_necklace", LUA_MODIFIER_MOTION_NONE)

function item_chaotic_shaman_necklace:GetIntrinsicModifierName()
	return "modifier_item_chaotic_shaman_necklace"
end


modifier_item_chaotic_shaman_necklace = advanced_modifier({})

function modifier_item_chaotic_shaman_necklace:IsDebuff() return false end
function modifier_item_chaotic_shaman_necklace:IsHidden() return true end
function modifier_item_chaotic_shaman_necklace:IsPurgable() return false end


function modifier_item_chaotic_shaman_necklace:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_summon = self.ability:GetSpecialValueFor("bonus_summon")
    self.summon_time = self.ability:GetSpecialValueFor("summon_time")
end

function modifier_item_chaotic_shaman_necklace:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
    }
end
function modifier_item_chaotic_shaman_necklace:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon
end
function modifier_item_chaotic_shaman_necklace:Advanced_GetModifier_SummonTime_Intensity(keys)
	return self.summon_time
end

