
Primary_lunar_blessing = class({})

LinkLuaModifier("modifier_Primary_lunar_blessing_passive", "skills/Primary_lunar_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_lunar_blessing_effect", "skills/Primary_lunar_blessing", LUA_MODIFIER_MOTION_NONE)


function Primary_lunar_blessing:GetIntrinsicModifierName() return "modifier_Primary_lunar_blessing_passive" end

modifier_Primary_lunar_blessing_passive = advanced_modifier({})

function modifier_Primary_lunar_blessing_passive:IsHidden() return true end
function modifier_Primary_lunar_blessing_passive:IsAura() return not self:GetCaster():PassivesDisabled() end
function modifier_Primary_lunar_blessing_passive:GetAuraDuration() return 0.5 end
function modifier_Primary_lunar_blessing_passive:GetModifierAura() return "modifier_Primary_lunar_blessing_effect" end
function modifier_Primary_lunar_blessing_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
-- function modifier_Primary_lunar_blessing_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_Primary_lunar_blessing_passive:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end

function modifier_Primary_lunar_blessing_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Primary_lunar_blessing_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
function modifier_Primary_lunar_blessing_passive:IsPurgable()	return false end
function modifier_Primary_lunar_blessing_passive:IsPurgeException() return false end
function modifier_Primary_lunar_blessing_passive:RemoveOnDeath() return false end
-- advanced_modifier
function modifier_Primary_lunar_blessing_passive:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_BONUS_NIGHT_VISION


    }
end

function modifier_Primary_lunar_blessing_passive:Advanced_GetBonusNightVision()	
	return self:GetCaster():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("self_night_vision_bonus")
end



modifier_Primary_lunar_blessing_effect = class({})

function modifier_Primary_lunar_blessing_effect:IsDebuff()			return false end
function modifier_Primary_lunar_blessing_effect:IsHidden() 			return false end
function modifier_Primary_lunar_blessing_effect:IsPurgable() 			return false end
function modifier_Primary_lunar_blessing_effect:IsPurgeException() 	return false end
function modifier_Primary_lunar_blessing_effect:OnCreated(table)
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	
end
function modifier_Primary_lunar_blessing_effect:OnRefresh()
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_Primary_lunar_blessing_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,     


	}
end


function modifier_Primary_lunar_blessing_effect:GetModifierBaseAttack_BonusDamage()	
	return self.bonus_damage  
end

