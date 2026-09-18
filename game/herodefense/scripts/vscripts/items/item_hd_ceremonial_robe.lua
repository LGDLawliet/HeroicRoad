item_hd_ceremonial_robe = class({})
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_arua", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_arua_effect", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ceremonial_robe", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ceremonial_robe_active", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_effect", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_effect2", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_active_standby", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_debuff", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ceremonial_robe_thinker", "items/item_hd_ceremonial_robe", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ceremonial_robe:GetIntrinsicModifierName()
	return "modifier_item_hd_ceremonial_robe"
end





modifier_item_hd_ceremonial_robe = advanced_modifier({})

function modifier_item_hd_ceremonial_robe:IsDebuff() return false end
function modifier_item_hd_ceremonial_robe:IsHidden() return true end
function modifier_item_hd_ceremonial_robe:IsPurgable() return false end
-- function modifier_item_hd_ceremonial_robe:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_ceremonial_robe:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_ceremonial_robe:IsAura() return true end
function modifier_item_hd_ceremonial_robe:GetAuraDuration() return 0.5 end
function modifier_item_hd_ceremonial_robe:GetModifierAura() return "modifier_item_hd_ceremonial_robe_active" end
function modifier_item_hd_ceremonial_robe:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_ceremonial_robe:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_ceremonial_robe:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_ceremonial_robe:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_ceremonial_robe:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_heal_amplification = self.ability:GetSpecialValueFor("bonus_heal_amplification")



end



function modifier_item_hd_ceremonial_robe:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
	
	}
end


function modifier_item_hd_ceremonial_robe:GetModifierManaBonus()	return self.bonus_mana end

-- advanced_modifier
function modifier_item_hd_ceremonial_robe:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_ceremonial_robe:Advanced_GetModifierHealAMP_Percentage(keys)
	return self.bonus_heal_amplification
end


modifier_item_hd_ceremonial_robe_active = advanced_modifier({})

function modifier_item_hd_ceremonial_robe_active:IsDebuff() return true end
function modifier_item_hd_ceremonial_robe_active:IsHidden() return false end
function modifier_item_hd_ceremonial_robe_active:IsPurgable() return false end
function modifier_item_hd_ceremonial_robe_active:GetTexture()return "item_ceremonial_robe" end

function modifier_item_hd_ceremonial_robe_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,   
	}
end


function modifier_item_hd_ceremonial_robe_active:GetModifierMagicalResistanceBonus() return -15 end
function modifier_item_hd_ceremonial_robe_active:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end



function modifier_item_hd_ceremonial_robe_active:Advanced_GetModifier_StatusResistance(keys)
	return -10
end

