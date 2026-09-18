item_hd_crimson_guard = class({})
-- LinkLuaModifier("modifier_item_hd_crimson_guard_arua", "items/item_hd_crimson_guard", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_crimson_guard_arua_effect", "items/item_hd_crimson_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_crimson_guard", "items/item_hd_crimson_guard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_crimson_guard_active", "items/item_hd_crimson_guard", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_crimson_guard:GetIntrinsicModifierName()
	return "modifier_item_hd_crimson_guard"
end




modifier_item_hd_crimson_guard = advanced_modifier({})

function modifier_item_hd_crimson_guard:IsDebuff() return false end
function modifier_item_hd_crimson_guard:IsHidden() return true end
function modifier_item_hd_crimson_guard:IsPurgable() return false end
function modifier_item_hd_crimson_guard:IsAura() return true end
function modifier_item_hd_crimson_guard:GetAuraDuration() return 0.5 end
function modifier_item_hd_crimson_guard:GetModifierAura() return "modifier_item_hd_crimson_guard_active" end
function modifier_item_hd_crimson_guard:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_crimson_guard:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_crimson_guard:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_hd_crimson_guard:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_crimson_guard:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_health = self.ability:GetSpecialValueFor("bonus_health")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

end


function modifier_item_hd_crimson_guard:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end


function modifier_item_hd_crimson_guard:GetModifierHealthBonus()	return self.bonus_health end
function modifier_item_hd_crimson_guard:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end

function modifier_item_hd_crimson_guard:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end
function modifier_item_hd_crimson_guard:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end


modifier_item_hd_crimson_guard_active = advanced_modifier({})

function modifier_item_hd_crimson_guard_active:IsDebuff() return false end
function modifier_item_hd_crimson_guard_active:IsHidden() return false end
function modifier_item_hd_crimson_guard_active:IsPurgable() return false end
function modifier_item_hd_crimson_guard_active:GetTexture()return "item_crimson_guard" end
function modifier_item_hd_crimson_guard_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_MAXIMUM
	}
end
function modifier_item_hd_crimson_guard_active:Advanced_GetModifierTotalBlockConstantMaximum(keys)
	if IsClient() then
		return 0
	end
	if keys.block_disabled then
        return 0 
    end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then
		return 0
	end
	local parent = self:GetParent()
	if parent:IsRealHero() then
		return 100
	else
		return 150
	end
	return 0

end
