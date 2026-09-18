creeps_spell_Fury_Strike = class({})

LinkLuaModifier("modifier_creeps_spell_Fury_Strike_slow", "creeps_spell/creeps_spell_Fury_Strike", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Fury_Strike_buff", "creeps_spell/creeps_spell_Fury_Strike", LUA_MODIFIER_MOTION_NONE)

function creeps_spell_Fury_Strike:IsHiddenWhenStolen() 		return false end
function creeps_spell_Fury_Strike:IsRefreshable() 			return true  end
function creeps_spell_Fury_Strike:IsStealable() 			return true  end


function creeps_spell_Fury_Strike:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("radius") end

function creeps_spell_Fury_Strike:OnSpellStart()
	local caster = self:GetCaster()
	local pfx_name = "particles/units/heroes/hero_monkey_king/monkey_king_jump_stomp.vpcf"
	local sound_name = {
		"n_creep_Centaur.Stomp",
		"n_creep_Thunderlizard_Big.Stomp"
	}
	caster:EmitSound(sound_name[RandomInt(1, 2)])
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(pfx)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damage = self:GetSpecialValueFor("damage") * self:GetCaster():GetBaseDamageMax()
	for _, enemy in pairs(enemies) do
		local damageTable = {
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = self:GetAbilityDamageType(),
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
			}
        ApplyDamage(damageTable)
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self, "modifier_creeps_spell_Fury_Strike_slow", {duration = self:GetSpecialValueFor("duration")*StatusResistance})

		
	end
end

modifier_creeps_spell_Fury_Strike_slow = class({})

function modifier_creeps_spell_Fury_Strike_slow:IsDebuff()			return true end
function modifier_creeps_spell_Fury_Strike_slow:IsHidden() 			return false end
function modifier_creeps_spell_Fury_Strike_slow:IsPurgable() 			return true end
function modifier_creeps_spell_Fury_Strike_slow:IsPurgeException() 	return true end
function modifier_creeps_spell_Fury_Strike_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end
function modifier_creeps_spell_Fury_Strike_slow:GetModifierMoveSpeedBonus_Percentage() return self.slow end


function modifier_creeps_spell_Fury_Strike_slow:OnCreated(table)
	self.slow = -self:GetAbility():GetSpecialValueFor("move_slow")
end

