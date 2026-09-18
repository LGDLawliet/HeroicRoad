Middle_astral_step = class({})

LinkLuaModifier( "modifier_Middle_astral_step", "skills/Middle_astral_step", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_astral_step_buff", "skills/Middle_astral_step", LUA_MODIFIER_MOTION_NONE )



function Middle_astral_step:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local origin = caster:GetOrigin()
	local min_dist = 200
	local max_dist = self:GetSpecialValueFor( "distance" )+ caster:GetCastRangeBonus()
	max_dist = math.max(max_dist,100)
	max_dist = math.min(max_dist,2000)
	local radius = 250
	local delay = 3

	local direction = (point-origin)
	local dist = math.max( math.min( max_dist, direction:Length2D() ), min_dist )
	direction.z = 0
	direction = direction:Normalized()

	local target = GetGroundPosition( origin + direction*dist, nil )
	FindClearSpaceForUnit( caster, target, true )


	local enemies = FindUnitsInLine(self:GetCaster():GetTeamNumber(),	origin,	target,	nil,	radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES	
	)
	caster:AddNewModifier(caster, self,"modifier_Middle_astral_step_buff", { duration = 3 })
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
	for _,enemy in pairs(enemies) do

		caster:PerformAttack( enemy, true, true, true, false, false, false, true )


		enemy:AddNewModifier(caster, self,"modifier_Middle_astral_step", { duration = delay })


		self:PlayEffects2( enemy )
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end


	self:PlayEffects1( origin, target )
	if self:GetCurrentAbilityCharges()<=0 then
		local ability = caster:FindAbilityByName("heroTalent_npc_dota_hero_void_spirit_2")
		if ability and ability:GetCurrentAbilityCharges()>=1 then
			ability:SetCurrentAbilityCharges(ability:GetCurrentAbilityCharges()-1)
			ability:OnCostCharge()
			ability:AddCount()
			self:SetCurrentAbilityCharges(1)
		end
	end
end

--------------------------------------------------------------------------------
function Middle_astral_step:PlayEffects1( origin, target )
	
	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"
	local sound_start = "Hero_VoidSpirit.AstralStep.Start"
	local sound_end = "Hero_VoidSpirit.AstralStep.End"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, origin )
	ParticleManager:SetParticleControl( effect_cast, 1, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )


	EmitSoundOnLocationWithCaster( origin, sound_start, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target, sound_end, self:GetCaster() )
end

function Middle_astral_step:PlayEffects2( target )

	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end



modifier_Middle_astral_step = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_astral_step:IsHidden()	return false end
function modifier_Middle_astral_step:IsDebuff()	return true end
function modifier_Middle_astral_step:IsStunDebuff()	return false end
function modifier_Middle_astral_step:IsPurgable()	return true end
function modifier_Middle_astral_step:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_astral_step:OnCreated( kv )
	-- references
	local ablity = self:GetAbility()
	self.damage = ablity:GetSpecialValueFor("damage")+ablity:GetSpecialValueFor("damage_index")*self:GetCaster():GetIntellect(false)
	self.slow = -ablity:GetSpecialValueFor("slow")
end


function modifier_Middle_astral_step:OnDestroy()
	if not IsServer() then return end

	-- Apply damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)

	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_astral_step:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_Middle_astral_step:GetModifierMoveSpeedBonus_Constant()	return self.slow end

function modifier_Middle_astral_step:GetEffectName()
	return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_Middle_astral_step:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Middle_astral_step:GetStatusEffectName()
	return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_Middle_astral_step:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end

function modifier_Middle_astral_step:PlayEffects()

	local particle_cast = "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf"
	local sound_target = "Hero_VoidSpirit.AstralStep.MarkExplosion"


	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_target, self:GetParent() )
end








modifier_Middle_astral_step_buff = class({})
function modifier_Middle_astral_step_buff:IsHidden()	return false end
function modifier_Middle_astral_step_buff:IsDebuff()	return false end
function modifier_Middle_astral_step_buff:IsPurgable()	return false end


function modifier_Middle_astral_step_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

function modifier_Middle_astral_step_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_Middle_astral_step_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end

