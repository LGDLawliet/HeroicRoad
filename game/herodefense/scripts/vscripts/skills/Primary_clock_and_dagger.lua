
LinkLuaModifier("modifier_Primary_clock_and_dagger", "skills/Primary_clock_and_dagger", LUA_MODIFIER_MOTION_NONE)

Primary_clock_and_dagger		= Primary_clock_and_dagger or class({})


function Primary_clock_and_dagger:GetIntrinsicModifierName()
	return "modifier_Primary_clock_and_dagger"
end


modifier_Primary_clock_and_dagger	= modifier_Primary_clock_and_dagger or class({})

function modifier_Primary_clock_and_dagger:DestroyOnExpire()	return false end
function modifier_Primary_clock_and_dagger:IsPurgable()		return false end
function modifier_Primary_clock_and_dagger:RemoveOnDeath()	return false end
function modifier_Primary_clock_and_dagger:IsPurgeException() return false end
function modifier_Primary_clock_and_dagger:IsHidden()			return true end


function modifier_Primary_clock_and_dagger:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		

	}
end



function modifier_Primary_clock_and_dagger:GetModifierPreAttack_BonusDamage(keys)
	if keys.attacker == self:GetParent() and keys.target then	
		local ability = self:GetAbility()
		if not self:GetParent():IsRangedAttacker() and not self:GetParent():PassivesDisabled() and not keys.target:IsBuilding() and not keys.target:IsOther() and  math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(CalculateDirection(keys.target:GetAbsOrigin(),self:GetParent():GetAbsOrigin())).y)) <= ability:GetSpecialValueFor("back_angle")*0.5 then

			self.bBackstab = true
			
			if not self:GetParent():IsIllusion() then
				return self:GetParent():GetAgility() * ability:GetSpecialValueFor("backstab_damage_per_agility")
			end
		else
			self.bBackstab = false
		end
	end
end

function modifier_Primary_clock_and_dagger:OnAttackLanded(keys)
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

