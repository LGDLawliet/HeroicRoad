------
---该技能可直接复制作为可以多重叠加的光环技能 但可能单位死亡后会丢失图标
creeps_spell_Golem = class({})

LinkLuaModifier("modifier_creeps_spell_Golem_passive", "creeps_spell/creeps_spell_Golem", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Golem_effect", "creeps_spell/creeps_spell_Golem", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Golem:GetIntrinsicModifierName() return "modifier_creeps_spell_Golem_passive" end

modifier_creeps_spell_Golem_passive = class({})

function modifier_creeps_spell_Golem_passive:IsHidden() return true end
function modifier_creeps_spell_Golem_passive:IsAura() return true end
function modifier_creeps_spell_Golem_passive:GetAuraDuration() return 0.5 end
function modifier_creeps_spell_Golem_passive:GetModifierAura() return "modifier_creeps_spell_Golem_effect" end
function modifier_creeps_spell_Golem_passive:GetAuraRadius() return self:GetAbility():GetSpecialValueFor("radius") end
function modifier_creeps_spell_Golem_passive:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_creeps_spell_Golem_passive:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_Golem_passive:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end

modifier_creeps_spell_Golem_effect = class({})

function modifier_creeps_spell_Golem_effect:IsDebuff()			return true end
function modifier_creeps_spell_Golem_effect:IsHidden() 			return true end
function modifier_creeps_spell_Golem_effect:IsPurgable() 			return false end
function modifier_creeps_spell_Golem_effect:IsPurgeException() 	return false end
function modifier_creeps_spell_Golem_effect:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end


function modifier_creeps_spell_Golem_effect:OnCreated()
    if IsServer() then
        self:StartIntervalThink(1)
    end
end

function modifier_creeps_spell_Golem_effect:OnIntervalThink()
    local ability = self:GetAbility()
	if not ability  then
		return
	end
	local caster = self:GetCaster()
	local damage = caster:GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor("damage")

			
			
	local damage_table = {
		victim = self:GetParent(),
		attacker = caster,
		ability = self:GetAbility(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damage_table)
	
end

