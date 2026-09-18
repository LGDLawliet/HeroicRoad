nevermore_challenge_dark_lord = class({})

LinkLuaModifier("modifier_nevermore_challenge_dark_lord", "creeps_spell/nevermore_challenge_dark_lord", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_nevermore_challenge_dark_lord_effect", "creeps_spell/nevermore_challenge_dark_lord", LUA_MODIFIER_MOTION_NONE)
function nevermore_challenge_dark_lord:IsHiddenWhenStolen() 		return false end
function nevermore_challenge_dark_lord:IsRefreshable() 			return true end
function nevermore_challenge_dark_lord:IsStealable() 				return true end
function nevermore_challenge_dark_lord:IsNetherWardStealable()		return true end
function nevermore_challenge_dark_lord:GetIntrinsicModifierName() return "modifier_nevermore_challenge_dark_lord" end

-- require('internal/timers')

modifier_nevermore_challenge_dark_lord = class({})

function modifier_nevermore_challenge_dark_lord:IsDebuff()			 return false end
function modifier_nevermore_challenge_dark_lord:IsHidden() 		     return true end
function modifier_nevermore_challenge_dark_lord:IsPurgable() 		 return false end
function modifier_nevermore_challenge_dark_lord:IsPurgeException() 	 return false end
function modifier_nevermore_challenge_dark_lord:RemoveOnDeath()       return false end
function modifier_nevermore_challenge_dark_lord:GetEffectName() return "particles/new_effect/new_effect/nevermore_wings.vpcf" end
function modifier_nevermore_challenge_dark_lord:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_nevermore_challenge_dark_lord:IsAura()	return true end
function modifier_nevermore_challenge_dark_lord:GetModifierAura()	return  "modifier_nevermore_challenge_dark_lord_effect" end
function modifier_nevermore_challenge_dark_lord:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_nevermore_challenge_dark_lord:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_nevermore_challenge_dark_lord:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_nevermore_challenge_dark_lord:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE end



modifier_nevermore_challenge_dark_lord_effect = advanced_modifier({})

--------------------------------------------------------------------------------
function modifier_nevermore_challenge_dark_lord_effect:IsDebuff() return true end
function modifier_nevermore_challenge_dark_lord_effect:IsHidden() return false end
function modifier_nevermore_challenge_dark_lord_effect:IsPurgable()	return false end
-- function modifier_nevermore_challenge_dark_lord_effect:GetEffectName()	return "particles/items4_fx/spirit_vessel_damage.vpcf" end

function modifier_nevermore_challenge_dark_lord_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_nevermore_challenge_dark_lord_effect:OnCreated(keys)
    self.armor_down = self:GetAbility():GetSpecialValueFor("armor_down")*0.01
	if IsServer() then
		self:SetStackCount(self:GetParent():GetPhysicalArmorValue(false) *  self.armor_down)
	end
end

function modifier_nevermore_challenge_dark_lord_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_nevermore_challenge_dark_lord_effect:Advanced_GetModifierPhysicalArmorBonus()
	return self:GetCaster():PassivesDisabled() and -self:GetStackCount()*0.5 or -self:GetStackCount()
end