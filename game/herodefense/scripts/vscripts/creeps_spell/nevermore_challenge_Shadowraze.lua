

LinkLuaModifier("nevermore_challenge_Shadowraze_wait", "creeps_spell/nevermore_challenge_Shadowraze", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("nevermore_challenge_Shadowraze_debuff", "creeps_spell/nevermore_challenge_Shadowraze", LUA_MODIFIER_MOTION_NONE)
nevermore_challenge_Shadowraze = class({})

function nevermore_challenge_Shadowraze:IsHiddenWhenStolen() 		return false end
function nevermore_challenge_Shadowraze:IsRefreshable() 			return true end
function nevermore_challenge_Shadowraze:IsStealable() 			return true end
function nevermore_challenge_Shadowraze:IsNetherWardStealable()	return true end
require('internal/timers')   --计时器功能
------------------------------------------------------------------------------------------------------------------------------------------

function nevermore_challenge_Shadowraze:OnSpellStart()
	local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local point = self:GetCursorPosition()
	if point == caster_pos then
		point = point + self:GetCaster():GetForwardVector()
	end
	local norm = (point - caster_pos):Normalized()
	point.z = point.z +64
	local target_point = caster:GetAbsOrigin() + norm * 2000
	target_point.z = target_point.z+64

	local fx = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_1.vpcf", PATTACH_WORLDORIGIN, caster)
	-- ParticleManager:SetParticleControlEnt(fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", point, true)
	
	ParticleManager:SetParticleControl(fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(fx, 2, Vector(2.4,0,0))
	ParticleManager:SetParticleControl(fx, 1, target_point)

	
	caster:AddNewModifier(caster, self, "nevermore_challenge_Shadowraze_wait", {duration = 1.5})
	local ability = self
	Timers:CreateTimer(1.5, function()
		
		ParticleManager:DestroyParticle( fx, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
		ParticleManager:ReleaseParticleIndex(fx)
		local sound_cast = "Hero_Nevermore.RequiemOfSouls"
		local particle_caster_ground = "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf"
		EmitSoundOn(sound_cast, caster)
		for i = 0, 10, 1 do
			local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
			local target_point = caster_pos + norm * i*200
			ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
			ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(150, 0, 0))
			ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
		end

		local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_pos, caster_pos + norm * 2000, nil, ability:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

		
		local damage = caster:GetAverageTrueAttackDamage(nil)*ability:GetSpecialValueFor("damage")

		for _, enemy in pairs(tTargets) do
			local real_damage = damage
			if enemy:IsMagicImmune() then
				real_damage = real_damage * 0.5
			end

			local damageTable = {
								victim = enemy,
								attacker = caster,
								damage = real_damage,
								damage_type = ability:GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
								ability = ability, --Optional.
								}
			ApplyDamage(damageTable)
			if not caster:IsSilenced() then							
				enemy:AddNewModifier(caster, ability, "nevermore_challenge_Shadowraze_debuff", {duration = ability:GetSpecialValueFor("duration")})
			end
		end
	end)
end
----------------------------------------------------------------------------------
nevermore_challenge_Shadowraze_wait = advanced_modifier({})

function nevermore_challenge_Shadowraze_wait:IsHidden()	return true end
function nevermore_challenge_Shadowraze_wait:IsDebuff()	return true end
function nevermore_challenge_Shadowraze_wait:RemoveOnDeath()	return true end

function nevermore_challenge_Shadowraze_wait:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		-- [MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function nevermore_challenge_Shadowraze_wait:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function nevermore_challenge_Shadowraze_wait:GetOverrideAnimationRate( params )
	return 1.2
end

function nevermore_challenge_Shadowraze_wait:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_6
end

--------------------------------------------------------------------------------
nevermore_challenge_Shadowraze_debuff = advanced_modifier({})


function nevermore_challenge_Shadowraze_debuff:IsHidden()	return false end
function nevermore_challenge_Shadowraze_debuff:IsDebuff()	return true end
function nevermore_challenge_Shadowraze_debuff:IsPurgable()	return false end
function nevermore_challenge_Shadowraze_debuff:IsPurgeException() return false end
function nevermore_challenge_Shadowraze_debuff:RemoveOnDeath()	return false end
function nevermore_challenge_Shadowraze_debuff:GetTexture()	return "attr_damage" end
function nevermore_challenge_Shadowraze_debuff:OnCreated(keys)
	self.outgoing_down = self:GetAbility():GetSpecialValueFor("outgoing_down")
end

function nevermore_challenge_Shadowraze_debuff:OnRefresh(keys)
	self:SetStackCount(math.min(self:GetStackCount()+1 , 10))
end

function nevermore_challenge_Shadowraze_debuff:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
end

function nevermore_challenge_Shadowraze_debuff:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not self:GetAbility() then self:Destroy() return end
	if not IsServer() then
		return 0
	end
	if keys.target == self:GetCaster() then
		return -self.outgoing_down * self:GetStackCount()
	end
	return 0
end

function nevermore_challenge_Shadowraze_debuff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function nevermore_challenge_Shadowraze_debuff:OnTooltip()
	return self.outgoing_down * self:GetStackCount()
end