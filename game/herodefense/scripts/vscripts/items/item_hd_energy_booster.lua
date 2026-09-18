item_hd_energy_booster = class({})
-- LinkLuaModifier("modifier_item_hd_energy_booster_arua", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_energy_booster_arua_effect", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_energy_booster", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_energy_booster_active", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_energy_booster_active_effect", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier("modifier_item_hd_energy_booster_active_standby", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_energy_booster_active_debuff", "items/item_hd_energy_booster", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_energy_booster:GetIntrinsicModifierName()
	return "modifier_item_hd_energy_booster"
end





modifier_item_hd_energy_booster = class({})

function modifier_item_hd_energy_booster:IsDebuff() return false end
function modifier_item_hd_energy_booster:IsHidden() return true end
function modifier_item_hd_energy_booster:IsPurgable() return false end



function modifier_item_hd_energy_booster:OnCreated(keys)
    self.ability = self:GetAbility()
	-- print("555555")
 
    local parent = self:GetParent()


	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.bonus_mana_regeneration = self.ability:GetSpecialValueFor("bonus_mana_regeneration")


    if IsServer() then

	end
end


function modifier_item_hd_energy_booster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,              --魔法基础恢复

		

	}
end

function modifier_item_hd_energy_booster:GetModifierManaBonus()	return self.bonus_mana end
-- function modifier_item_hd_energy_booster:GetModifierMPRegenAmplify_Percentage() 	return self.bonus_Mana_regeneration end
function modifier_item_hd_energy_booster:GetModifierConstantManaRegen()	return self.bonus_mana_regeneration end
-- function modifier_item_hd_energy_booster:GetModifierPercentageCooldown()    return self.bonus_cooldown end



