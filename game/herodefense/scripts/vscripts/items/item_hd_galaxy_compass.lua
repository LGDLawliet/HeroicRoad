item_hd_galaxy_compass = class({})

LinkLuaModifier("modifier_item_hd_galaxy_compass", "items/item_hd_galaxy_compass", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_galaxy_compass_active", "items/item_hd_galaxy_compass", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_galaxy_compass:GetIntrinsicModifierName()
	return "modifier_item_hd_galaxy_compass"
end


modifier_item_hd_galaxy_compass = advanced_modifier({})

function modifier_item_hd_galaxy_compass:IsDebuff() return false end
function modifier_item_hd_galaxy_compass:IsHidden() return true end
function modifier_item_hd_galaxy_compass:IsPurgable() return false end
function modifier_item_hd_galaxy_compass:IsPurgeException() return false end
function modifier_item_hd_galaxy_compass:RemoveOnDeath() return false end

function modifier_item_hd_galaxy_compass:OnCreated(keys)
	self.bonus_all_attribute = self:GetAbility():GetSpecialValueFor("bonus_all_attribute")
	self.bonus = self:GetAbility():GetSpecialValueFor("bonus_probability")
	if IsServer() then
		_G.GAME_BOSS_SPELL_INDEX = _G.GAME_BOSS_SPELL_INDEX +0.3
	end
end
function modifier_item_hd_galaxy_compass:OnDestroy(keys)
	if IsServer() then
		_G.GAME_BOSS_SPELL_INDEX = _G.GAME_BOSS_SPELL_INDEX -0.3
	end
end
function modifier_item_hd_galaxy_compass:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷                  

	}
end
function modifier_item_hd_galaxy_compass:GetModifierBonusStats_Strength()return self.bonus_all_attribute end
function modifier_item_hd_galaxy_compass:GetModifierBonusStats_Intellect()return self.bonus_all_attribute end
function modifier_item_hd_galaxy_compass:GetModifierBonusStats_Agility()return self.bonus_all_attribute end



-- advanced_modifier
function modifier_item_hd_galaxy_compass:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_RandomEffectGain,
    }
end
function modifier_item_hd_galaxy_compass:Advanced_GetModifier_RandomEffectGain(keys)
	return self.bonus
end


