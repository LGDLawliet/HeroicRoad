------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_Shield_Wall = class({})

LinkLuaModifier("modifier_creeps_spell_Shield_Wall_passive", "creeps_spell/creeps_spell_Shield_Wall", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Shield_Wall_effect", "creeps_spell/creeps_spell_Shield_Wall", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_Shield_Wall_effect_count", "creeps_spell/creeps_spell_Shield_Wall", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Shield_Wall:GetIntrinsicModifierName() return "modifier_creeps_spell_Shield_Wall_passive" end

modifier_creeps_spell_Shield_Wall_passive = class({})

function modifier_creeps_spell_Shield_Wall_passive:IsHidden() return true end
function modifier_creeps_spell_Shield_Wall_passive:IsAura() return true end
function modifier_creeps_spell_Shield_Wall_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Shield_Wall_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Shield_Wall_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Shield_Wall_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Shield_Wall_passive:GetModifierAura() return "modifier_creeps_spell_Shield_Wall_effect" end
function modifier_creeps_spell_Shield_Wall_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Shield_Wall_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Shield_Wall_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_Shield_Wall_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_Shield_Wall_effect = class({})

function modifier_creeps_spell_Shield_Wall_effect:IsDebuff()			return false end
function modifier_creeps_spell_Shield_Wall_effect:IsHidden() 			return true end
function modifier_creeps_spell_Shield_Wall_effect:IsPurgable() 			return false end
function modifier_creeps_spell_Shield_Wall_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Shield_Wall_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_creeps_spell_Shield_Wall_effect:OnCreated()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Shield_Wall_effect_count", {})
    end
end

function modifier_creeps_spell_Shield_Wall_effect:OnRefresh()
    if IsServer() then
        -- local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Shield_Wall_effect_count")
        -- buffs[1]:SafeDestroy()
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_Shield_Wall_effect_count", {})
    end
end


modifier_creeps_spell_Shield_Wall_effect_count = advanced_modifier({})

function modifier_creeps_spell_Shield_Wall_effect_count:IsDebuff()			return false end
function modifier_creeps_spell_Shield_Wall_effect_count:IsHidden() 			return false end
function modifier_creeps_spell_Shield_Wall_effect_count:IsPurgable() 			return false end
function modifier_creeps_spell_Shield_Wall_effect_count:IsPurgeException() 	return false end


function modifier_creeps_spell_Shield_Wall_effect_count:OnCreated()
	self.bonus = -self:GetAbility():GetSpecialValueFor("bonus")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_creeps_spell_Shield_Wall_effect_count:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_Shield_Wall_effect")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end


function modifier_creeps_spell_Shield_Wall_effect_count:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
		

	}
end

function modifier_creeps_spell_Shield_Wall_effect_count:OnTooltip()	
	return self:Advanced_GetModifierIncomingDamage_Percentage()

end

function modifier_creeps_spell_Shield_Wall_effect_count:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_creeps_spell_Shield_Wall_effect_count:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self:GetParent():PassivesDisabled() then
        return 0
    end

	return math.max(self.bonus * self:GetStackCount(),-90)


end
