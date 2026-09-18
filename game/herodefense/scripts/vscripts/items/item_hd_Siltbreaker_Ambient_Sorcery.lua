item_hd_Siltbreaker_Ambient_Sorcery = class({})
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Ambient_Sorcery_arua", "items/item_hd_Siltbreaker_Ambient_Sorcery", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_Siltbreaker_Ambient_Sorcery_arua_effect", "items/item_hd_Siltbreaker_Ambient_Sorcery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Ambient_Sorcery", "items/item_hd_Siltbreaker_Ambient_Sorcery", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_Siltbreaker_Ambient_Sorcery_active", "items/item_hd_Siltbreaker_Ambient_Sorcery", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_Siltbreaker_Ambient_Sorcery:GetIntrinsicModifierName()
	return "modifier_item_hd_Siltbreaker_Ambient_Sorcery"
end





modifier_item_hd_Siltbreaker_Ambient_Sorcery = class({})

function modifier_item_hd_Siltbreaker_Ambient_Sorcery:IsDebuff() return false end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:IsHidden() return true end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:IsPurgable() return false end
-- function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetTexture()return "item_phase_boots2" end
-- function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:IsAura() return true end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAuraDuration() return 0.5 end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetModifierAura() return "modifier_item_hd_Siltbreaker_Ambient_Sorcery_active" end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("aura_radius") end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end


function modifier_item_hd_Siltbreaker_Ambient_Sorcery:OnCreated(keys)
    self.ability = self:GetAbility()



	self.bonus_int = self.ability:GetSpecialValueFor("bonus_int")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	
end



function modifier_item_hd_Siltbreaker_Ambient_Sorcery:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MANA_BONUS,                       --魔法值
		

	}
end



function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetModifierBonusStats_Intellect()	return self.bonus_int end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery:GetModifierManaBonus()	return self.bonus_mana end


modifier_item_hd_Siltbreaker_Ambient_Sorcery_active = class({})

function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:IsDebuff() return true end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:IsHidden() return false end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:IsPurgable() return false end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:GetTexture()return "item_Siltbreaker_Ambient_Sorcery_icon" end

function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:DeclareFunctions()
	return {
			MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	

	}
end
function modifier_item_hd_Siltbreaker_Ambient_Sorcery_active:GetModifierMagicalResistanceBonus() return -10 end