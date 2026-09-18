------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_WeLiveTogether_Melee = class({})

LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Melee_passive", "creeps_spell/creeps_spell_WeLiveTogether_Melee", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Melee_effect", "creeps_spell/creeps_spell_WeLiveTogether_Melee", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_creeps_spell_WeLiveTogether_Melee_effect_count", "creeps_spell/creeps_spell_WeLiveTogether_Melee", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_WeLiveTogether_Melee:GetIntrinsicModifierName() return "modifier_creeps_spell_WeLiveTogether_Melee_passive" end

modifier_creeps_spell_WeLiveTogether_Melee_passive = class({})

function modifier_creeps_spell_WeLiveTogether_Melee_passive:IsHidden() return true end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:IsAura() return true end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetModifierAura() return "modifier_creeps_spell_WeLiveTogether_Melee_effect" end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetAuraRadius() return self:GetParent():PassivesDisabled() and 0 or self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_creeps_spell_WeLiveTogether_Melee_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_WeLiveTogether_Melee_effect = advanced_modifier({})

function modifier_creeps_spell_WeLiveTogether_Melee_effect:IsDebuff()			return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:IsHidden() 			return true end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:IsPurgable() 			return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_creeps_spell_WeLiveTogether_Melee_effect:OnCreated()
    if IsServer() then
        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_WeLiveTogether_Melee_effect_count", {})
    end
end

function modifier_creeps_spell_WeLiveTogether_Melee_effect:OnRefresh()
    if IsServer() then

        self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_creeps_spell_WeLiveTogether_Melee_effect_count", {})
    end
end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_creeps_spell_WeLiveTogether_Melee_effect:Advanced_GetModifierPhysicalArmorBonus()
	if self:GetParent():PassivesDisabled() then
        return 0
    end
	if self:GetAbility():GetSpecialValueFor("bonus")~=nil then
		return self:GetAbility():GetSpecialValueFor("bonus")
	else
		return 1
	end
end

modifier_creeps_spell_WeLiveTogether_Melee_effect_count = class({})

function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:IsDebuff()			return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:IsHidden() 			return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:IsPurgable() 			return false end
function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:IsPurgeException() 	return false end


function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1.5)
	end
end
function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:OnIntervalThink()
	local buffs = self:GetParent():FindAllModifiersByName("modifier_creeps_spell_WeLiveTogether_Melee_effect")
	self:SetStackCount(#buffs)
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end


function modifier_creeps_spell_WeLiveTogether_Melee_effect_count:GetTexture()
    return "meepo_divided_we_stand"
end
