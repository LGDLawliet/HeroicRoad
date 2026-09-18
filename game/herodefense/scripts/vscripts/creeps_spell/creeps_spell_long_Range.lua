------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_long_Range = class({})

LinkLuaModifier("modifier_creeps_spell_long_Range_passive", "creeps_spell/creeps_spell_long_Range", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_long_Range_effect", "creeps_spell/creeps_spell_long_Range", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_long_Range_effect_count", "creeps_spell/creeps_spell_long_Range", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_long_Range:GetIntrinsicModifierName() return "modifier_creeps_spell_long_Range_passive" end

modifier_creeps_spell_long_Range_passive = class({})

function modifier_creeps_spell_long_Range_passive:IsHidden() return true end
function modifier_creeps_spell_long_Range_passive:IsAura() return true end
function modifier_creeps_spell_long_Range_passive:IsPurgable() 		return false end
function modifier_creeps_spell_long_Range_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_long_Range_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_long_Range_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_long_Range_passive:GetModifierAura() return "modifier_creeps_spell_long_Range_effect" end
function modifier_creeps_spell_long_Range_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_long_Range_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_RANGED_ONLY end
function modifier_creeps_spell_long_Range_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_long_Range_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_long_Range_effect = advanced_modifier({})

function modifier_creeps_spell_long_Range_effect:IsDebuff()			return false end
function modifier_creeps_spell_long_Range_effect:IsHidden() 			return true end
function modifier_creeps_spell_long_Range_effect:IsPurgable() 			return false end
function modifier_creeps_spell_long_Range_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_long_Range_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_creeps_spell_long_Range_effect:OnCreated()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_long_Range_effect_count", {})
    end
end

function modifier_creeps_spell_long_Range_effect:OnRefresh()
    if IsServer() then

        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_long_Range_effect_count", {})
    end
end


modifier_creeps_spell_long_Range_effect_count = advanced_modifier({})

function modifier_creeps_spell_long_Range_effect_count:IsDebuff()			return false end
function modifier_creeps_spell_long_Range_effect_count:IsHidden() 			return false end
function modifier_creeps_spell_long_Range_effect_count:IsPurgable() 			return false end
function modifier_creeps_spell_long_Range_effect_count:IsPurgeException() 	return false end


function modifier_creeps_spell_long_Range_effect_count:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_creeps_spell_long_Range_effect_count:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_long_Range_effect")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end


function modifier_creeps_spell_long_Range_effect_count:GetTexture()
    return "sniper_take_aim"
end

function modifier_creeps_spell_long_Range_effect_count:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_creeps_spell_long_Range_effect_count:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierAttackRangeBonus()
	end
end

-- advanced_modifier

function modifier_creeps_spell_long_Range_effect_count:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	
    }
end

function modifier_creeps_spell_long_Range_effect_count:Advanced_GetModifierAttackRangeBonus(keys)
	if self:GetParent():PassivesDisabled() then
        return 0
    end
	if self:GetAbility() then
		return math.min(self:GetAbility():GetSpecialValueFor("bonus") * self:GetStackCount(),500)
	else
		return math.min(25 * self:GetStackCount(),500)
	end
end