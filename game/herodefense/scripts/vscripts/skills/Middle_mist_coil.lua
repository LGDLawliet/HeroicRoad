Middle_mist_coil = class({})

--------------------------------------------------------------------------------
-- Ability Start
LinkLuaModifier("modifier_Middle_mist_coil_active", "skills/Middle_mist_coil", LUA_MODIFIER_MOTION_NONE)

function Middle_mist_coil:CastFilterResultTarget(target)
	-- check nohammer
	if IsClient() then
		return
	end
	if target==self:GetCaster() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Middle_mist_coil:GetCustomCastErrorTarget(target)
	if IsClient() then
		return
	end
	return "#Spells_CustomCastError_NOT_SELF"
end



function Middle_mist_coil:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local self_damage = self:GetSpecialValueFor("self_damage") * (self:GetSpecialValueFor("spell_damage")+self:GetSpecialValueFor("str_index")*caster:GetStrength())*0.01

	local projectile_speed = 1000
	local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"

	-- logic
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- self damage
	local damageTable = {
		victim = caster,
		attacker = caster,
		damage = self_damage,
		damage_type = DAMAGE_TYPE_PURE,
		damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL+DOTA_DAMAGE_FLAG_REFLECTION+DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, --不致死与不触发吸血，技能伤害
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- Play effects
	self:PlayEffects()
end
--------------------------------------------------------------------------------
-- Projectile
function Middle_mist_coil:OnProjectileHit( target, location )
	-- check if enemy or ally
	local ally = false
	if not target then
		return
	end
	if target:GetTeamNumber()==self:GetCaster():GetTeamNumber() then
		ally = true
	end
	local ability = self
	local caster = self:GetCaster()
	local damage = ability:GetSpecialValueFor("spell_damage")+ability:GetSpecialValueFor("str_index")*caster:GetStrength()

	if ally then
		-- ally logic
		--迷雾缠身效果 对友计算正面状态增强
		local gain = caster:GetModifierDurationGainIndex(1)
		local healing = HealWithGain(damage,caster,target,self)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
		target:AddNewModifier(caster, self, "modifier_Middle_mist_coil_active", {duration = 5*gain})



	else
		-- enemy logic
		-- cancel if linken
		if target:IsInvulnerable() or target:TriggerSpellAbsorb( self ) then
			return
		end

		--迷雾缠身效果 对敌计算状态抗性与负面状态增强
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		local StatusResistance = target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		target:AddNewModifier(caster, self, "modifier_Middle_mist_coil_active", {duration = 5*StatusResistance})
		local damageTable = {
			victim = target,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)

	end

	-- Play effects
	local sound_target = "Hero_Abaddon.DeathCoil.Target"
	EmitSoundOn( sound_target, target )
end

--------------------------------------------------------------------------------
function Middle_mist_coil:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_abaddon/abaddon_death_coil_abaddon.vpcf"
	local sound_cast = "Hero_Abaddon.DeathCoil.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end




modifier_Middle_mist_coil_active = advanced_modifier({})

function modifier_Middle_mist_coil_active:IsDebuff() 
	-- if not self:GetCaster() then
	-- 	return false
	-- end
	return self.isDebuff
end
function modifier_Middle_mist_coil_active:IsHidden() return false end
function modifier_Middle_mist_coil_active:IsPurgable() return true end

function modifier_Middle_mist_coil_active:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end



function modifier_Middle_mist_coil_active:OnCreated(keys)
	self.isDebuff = self:GetParent():GetTeamNumber()~=self:GetCaster():GetTeamNumber()
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_regeneration_amplification = -25
	if parent:GetTeamNumber()==self.ability:GetCaster():GetTeamNumber() then
		self.bonus_regeneration_amplification = 30
	end

end




-- advanced_modifier
function modifier_Middle_mist_coil_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_Middle_mist_coil_active:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return self.bonus_regeneration_amplification
end