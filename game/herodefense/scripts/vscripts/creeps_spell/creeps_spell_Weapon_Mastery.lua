
creeps_spell_Weapon_Mastery = class({})

LinkLuaModifier("modifier_creeps_spell_Weapon_Mastery_passive", "creeps_spell/creeps_spell_Weapon_Mastery", LUA_MODIFIER_MOTION_NONE)


function creeps_spell_Weapon_Mastery:GetIntrinsicModifierName() return "modifier_creeps_spell_Weapon_Mastery_passive" end

modifier_creeps_spell_Weapon_Mastery_passive = class({})

function modifier_creeps_spell_Weapon_Mastery_passive:IsHidden() return true end
function modifier_creeps_spell_Weapon_Mastery_passive:IsAura() return true end
function modifier_creeps_spell_Weapon_Mastery_passive:IsPurgable() 		return false end
function modifier_creeps_spell_Weapon_Mastery_passive:IsPurgeException() 	return false end
function modifier_creeps_spell_Weapon_Mastery_passive:RemoveOnDeath()  return false end
function modifier_creeps_spell_Weapon_Mastery_passive:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,                    --攻击降临

	}
end



function modifier_creeps_spell_Weapon_Mastery_passive:OnAttackLanded(keys)
	if IsServer() then

		if keys.attacker == self:GetParent() and self:GetAbility():IsCooldownReady() then
			if self:GetCaster():PassivesDisabled() then
				return
			end
			self:GetAbility():UseResources(true, true, true,true)
			self:GetAbility():StartCooldown(1)

			local target =keys.target
			local pos = target:GetAbsOrigin()
			local vDir = Vector(RandomFloat(-1, 1),RandomFloat(-1, 1),0)
			local pos_1 = pos + vDir * 800
			local caster = self:GetCaster()
			local tTargets = FindUnitsInLine(caster:GetTeamNumber(), pos_1, pos, nil, 150,
    		DOTA_UNIT_TARGET_TEAM_ENEMY,
    		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

			local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave = 1,
				iDisableSplit = 1,
		
			}
			local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
    		for i, hTarget in pairs(tTargets) do
        	--造成攻击
        		caster:PerformAttack(hTarget,false, true, true, true, false, false, true)
    		end
			if IsValid(attackEffectRecord) then
				attackEffectRecord:Destroy()
			end
			-- local pos_2 = pos + vDir * -500
			local iPtclID = ParticleManager:CreateParticle('particles/econ/items/void_spirit/void_spirit_immortal_2021/void_spirit_immortal_2021_astral_step.vpcf', PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iPtclID, 0, pos_1)
			ParticleManager:SetParticleControl(iPtclID, 1, pos)
			ParticleManager:ReleaseParticleIndex(iPtclID)

		end
	end
end

