Middle_return = class({})
LinkLuaModifier( "modifier_Middle_return", "skills/Middle_return", LUA_MODIFIER_MOTION_NONE )


function Middle_return:GetIntrinsicModifierName()	return "modifier_Middle_return" end



modifier_Middle_return = class({})


function modifier_Middle_return:IsHidden()	return true end
function modifier_Middle_return:IsPurgable() 		return false end
function modifier_Middle_return:IsPurgeException() 	return false end
function modifier_Middle_return:RemoveOnDeath()  return false end



function modifier_Middle_return:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_return:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_Middle_return:OnAttackLanded( keys )
	if IsServer() then
		if self:GetParent():IsIllusion() or self:GetParent():PassivesDisabled() then
			return
		end
		if keys.target~=self:GetParent() or keys.attacker:GetTeamNumber()==keys.target:GetTeamNumber() then
			return
		end
		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end

		if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end

		if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) +self:GetParent():GetStrength()*self:GetAbility():GetSpecialValueFor( "damage_index" )
		-- get damage
		local damage = math.min(self.damage+keys.damage*0.10, self:GetParent():GetStrength()*150)
		self:PlayEffects( keys.attacker )
		-- Apply Damage
		local damageTable = {
			victim = keys.attacker,
			attacker = self:GetParent(),
			damage = damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self:GetAbility(), --Optional.
		}
		ApplyDamage(damageTable)

		-- Play effects
		
	end
end


function modifier_Middle_return:PlayEffects( target )
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_return.vpcf"
	local particle_return_fx = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN,  self:GetParent())
	ParticleManager:SetParticleControlEnt(particle_return_fx, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(particle_return_fx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle_return_fx)
end