
LinkLuaModifier("modifier_Middle_clock_and_dagger", "skills/Middle_clock_and_dagger", LUA_MODIFIER_MOTION_NONE)

Middle_clock_and_dagger		= Middle_clock_and_dagger or class({})


function Middle_clock_and_dagger:GetIntrinsicModifierName()
	return "modifier_Middle_clock_and_dagger"
end


modifier_Middle_clock_and_dagger	= modifier_Middle_clock_and_dagger or class({})

function modifier_Middle_clock_and_dagger:DestroyOnExpire()	return false end
function modifier_Middle_clock_and_dagger:IsPurgable()		return false end
function modifier_Middle_clock_and_dagger:IsPurgeException() return false end
function modifier_Middle_clock_and_dagger:RemoveOnDeath()	return false end

function modifier_Middle_clock_and_dagger:IsHidden()			return false end


function modifier_Middle_clock_and_dagger:CheckState()
	if self:GetAbility():IsCooldownReady() and not self:GetParent():PassivesDisabled()  then
		return {
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		}
	end
	return
end

function modifier_Middle_clock_and_dagger:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		

	}
end



function modifier_Middle_clock_and_dagger:GetModifierPreAttack_BonusDamage(keys)
	if keys.attacker == self:GetParent() and keys.target then	
		local ability = self:GetAbility()
		if not self:GetParent():IsRangedAttacker() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and not keys.target:IsOther() and  math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(CalculateDirection(keys.target:GetAbsOrigin(),self:GetParent():GetAbsOrigin())).y)) <= ability:GetSpecialValueFor("back_angle")*0.5 then

			self.bBackstab = true
			self:SetStackCount(math.min(self:GetStackCount()+1,30))
			
			if not self:GetParent():IsIllusion() then
				local index = self:GetStackCount()*0.05+1
				return self:GetParent():GetAgility() * (ability:GetSpecialValueFor("backstab_damage_per_agility")*index)
			end
		else
			self:SetStackCount(0)
			self.bBackstab = false
		end
	end
end

function modifier_Middle_clock_and_dagger:OnAttackLanded(keys)
	if keys.attacker == self:GetParent() then
		if self.bBackstab then
			keys.target:EmitSound("Hero_Riki.Backstab")
			
			self.backstab_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControlEnt(self.backstab_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.backstab_particle)
		end
		self:GetAbility():StartCooldown(self:GetAbility():GetSpecialValueFor("delay"))
	
	end
end

