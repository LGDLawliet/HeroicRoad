item_hd_heart = class({})
-- LinkLuaModifier("modifier_item_hd_heart_arua", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_arua_effect", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_heart", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_active", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_effect", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_effect2", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_active_standby", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_debuff", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_heart_thinker", "items/item_hd_heart", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_heart:GetIntrinsicModifierName()
	return "modifier_item_hd_heart"
end






modifier_item_hd_heart = advanced_modifier({})

function modifier_item_hd_heart:IsDebuff() return false end
function modifier_item_hd_heart:IsHidden() return true end
function modifier_item_hd_heart:IsPurgable() return false end



function modifier_item_hd_heart:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	-- self.pierce_proc 			= false   --用于金箍棒
	-- self.pierce_records			= {}      --用于金箍棒
	-- self.PrimaryAttribute =parent:GetPrimaryAttribute()
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_HPRegenAmplify_Percentage = self.ability:GetSpecialValueFor("bonus_HPRegenAmplify_Percentage")
end



function modifier_item_hd_heart:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值


	}
end


function modifier_item_hd_heart:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_heart:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_heart:AdvancedGetModifierConstantHealthRegenPercentage() return self.bonus_HPRegenAmplify_Percentage end

function modifier_item_hd_heart:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end