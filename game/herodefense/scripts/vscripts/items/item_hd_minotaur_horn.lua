item_hd_minotaur_horn = class({})

LinkLuaModifier("modifier_item_hd_minotaur_horn", "items/item_hd_minotaur_horn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_minotaur_horn_active", "items/item_hd_minotaur_horn", LUA_MODIFIER_MOTION_NONE)


function item_hd_minotaur_horn:GetIntrinsicModifierName()
	return "modifier_item_hd_minotaur_horn"
end



modifier_item_hd_minotaur_horn = advanced_modifier({})

function modifier_item_hd_minotaur_horn:IsDebuff() return false end
function modifier_item_hd_minotaur_horn:IsHidden() return true end
function modifier_item_hd_minotaur_horn:IsPurgable() return false end
-- function modifier_item_hd_minotaur_horn:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_minotaur_horn:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_minotaur_horn:IsAura() return true end
function modifier_item_hd_minotaur_horn:GetAuraDuration() return 0.5 end
function modifier_item_hd_minotaur_horn:GetModifierAura() return "modifier_item_hd_minotaur_horn_active" end
function modifier_item_hd_minotaur_horn:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_minotaur_horn:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_minotaur_horn:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_minotaur_horn:GetAuraSearchType() return DOTA_UNIT_TARGET_BASIC end



function modifier_item_hd_minotaur_horn:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")

	self.bonus_summon_intensity = self.ability:GetSpecialValueFor("bonus_summon_intensity")
	


end



function modifier_item_hd_minotaur_horn:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
	
		

	}
end


function modifier_item_hd_minotaur_horn:GetModifierBonusStats_Intellect()	return self.bonus_int end


-- advanced_modifier
function modifier_item_hd_minotaur_horn:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_item_hd_minotaur_horn:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon_intensity 
end




modifier_item_hd_minotaur_horn_active = advanced_modifier({})

function modifier_item_hd_minotaur_horn_active:IsDebuff() return false end
function modifier_item_hd_minotaur_horn_active:IsHidden() return false end
function modifier_item_hd_minotaur_horn_active:IsPurgable() return false end
function modifier_item_hd_minotaur_horn_active:GetTexture()return "item_minotaur_horn" end
-- function modifier_item_hd_minotaur_horn_active:DeclareFunctions()
-- 	return {
-- 				MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
	

-- 	}
-- end
-- function modifier_item_hd_minotaur_horn_active:GetModifierTotalDamageOutgoing_Percentage()return 100 end


-- advanced_modifier
function modifier_item_hd_minotaur_horn_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_minotaur_horn_active:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 12
end
