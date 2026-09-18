------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_WeLiveTogether_Ranger = class({})

LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Ranger_passive", "creeps_spell/creeps_spell_WeLiveTogether_Ranger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Ranger_effect", "creeps_spell/creeps_spell_WeLiveTogether_Ranger", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Ranger_effect_count", "creeps_spell/creeps_spell_WeLiveTogether_Ranger", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_WeLiveTogether_Ranger:GetIntrinsicModifierName() return "modifier_creeps_spell_WeLiveTogether_Ranger_passive" end

modifier_creeps_spell_WeLiveTogether_Ranger_passive = class({})

function modifier_creeps_spell_WeLiveTogether_Ranger_passive:IsHidden() return true end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:IsAura() return true end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetModifierAura() return "modifier_creeps_spell_WeLiveTogether_Ranger_effect" end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_WeLiveTogether_Ranger_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_WeLiveTogether_Ranger_effect = class({})

function modifier_creeps_spell_WeLiveTogether_Ranger_effect:IsDebuff()			return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect:IsHidden() 			return true end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect:IsPurgable() 			return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creeps_spell_WeLiveTogether_Ranger_effect:DeclareFunctions()
	return {MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE}
end

function modifier_creeps_spell_WeLiveTogether_Ranger_effect:GetModifierDamageOutgoing_Percentage()
    if self:GetParent():PassivesDisabled() then
        return 0
    end
    
    if self:GetAbility()~=nil then
        return self:GetAbility():GetSpecialValueFor("bonus")
    else
        return 5
    end
end


function modifier_creeps_spell_WeLiveTogether_Ranger_effect:OnCreated()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_WeLiveTogether_Ranger_effect_count", {})
    end
end

function modifier_creeps_spell_WeLiveTogether_Ranger_effect:OnRefresh()
    if IsServer() then

        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_WeLiveTogether_Ranger_effect_count", {})
    end
end


modifier_creeps_spell_WeLiveTogether_Ranger_effect_count = class({})

function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:IsDebuff()			return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:IsHidden() 			return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:IsPurgable() 			return false end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:IsPurgeException() 	return false end


function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.5)
	end
end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_WeLiveTogether_Ranger_effect")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end
function modifier_creeps_spell_WeLiveTogether_Ranger_effect_count:GetTexture()
    return "meepo_divided_we_stand"
end
