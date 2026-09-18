LinkLuaModifier( "modifier_nevermore_challenge_finally_attack", "creeps_spell/nevermore_challenge_finally_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_challenge_finally_attack_end", "creeps_spell/nevermore_challenge_finally_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_challenge_finally_attack_during", "creeps_spell/nevermore_challenge_finally_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_challenge_finally_attack_check", "creeps_spell/nevermore_challenge_finally_attack", LUA_MODIFIER_MOTION_NONE )

require('internal/timers')
nevermore_challenge_finally_attack = class({})

function nevermore_challenge_finally_attack:GetIntrinsicModifierName()
	return "modifier_nevermore_challenge_finally_attack"
end

function nevermore_challenge_finally_attack:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/creeps_spell/sf/final_end.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/spell/chronoshere/effect2/faceless_void_chronosphere.vpcf", context )
    --PrecacheResource( "particle", "particles/rebuild/creeps_spell/time_dialate_changing/effect_purple.vpcf", context )
end
---------------------------------------------------------------------

modifier_nevermore_challenge_finally_attack = advanced_modifier({})
function modifier_nevermore_challenge_finally_attack:IsDebuff() return false end
function modifier_nevermore_challenge_finally_attack:IsHidden() return true end
function modifier_nevermore_challenge_finally_attack:IsPurgable() return false end

function modifier_nevermore_challenge_finally_attack:OnCreated(params)
	self.cd = self:GetAbility():GetSpecialValueFor("limit_time")
	self.final_interval = self:GetAbility():GetSpecialValueFor("final_interval")
	if IsServer() then
		self:GetCaster():GameTimer(0.3,function ()
			self:GetAbility():StartCooldown(self.cd)
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nevermore_challenge_finally_attack_check",{duration = self.cd})
		end)
		self:StartIntervalThink(1)
	end
end
function modifier_nevermore_challenge_finally_attack:OnIntervalThink()
	if self:GetAbility():IsCooldownReady() then
		
		if not self:GetCaster():FindModifierByName("modifier_nevermore_challenge_finally_attack_end") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nevermore_challenge_finally_attack_end",{})
		end
		if not self:GetCaster():FindModifierByName("modifier_nevermore_challenge_finally_attack_during") then
			self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_nevermore_challenge_finally_attack_during",{duration = 3})
		end
	end
end

---------------------------------------------------------------------

modifier_nevermore_challenge_finally_attack_end = advanced_modifier({})
function modifier_nevermore_challenge_finally_attack_end:IsDebuff() return false end
function modifier_nevermore_challenge_finally_attack_end:IsHidden() return true end
function modifier_nevermore_challenge_finally_attack_end:IsPurgable() return false end
function modifier_nevermore_challenge_finally_attack_end:RemoveOnDeath() return true end

function modifier_nevermore_challenge_finally_attack_end:OnCreated(params)
	self.final_interval = self:GetAbility():GetSpecialValueFor("final_interval")
	local caster = self:GetCaster()
	if IsServer() then
		self:GetCaster():GameTimer(1,function ()
			self:GetCaster():SetOrigin(Vector(-300,-1053,64))
			self:GetCaster():AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) --提供相位，防止卡位
			
			local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
			
			local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
			ParticleManager:SetParticleShouldCheckFoW(effect_cast,false )
			ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
			ParticleManager:ReleaseParticleIndex(effect_cast)

			self:StartIntervalThink(self.final_interval)
		end)
	end
end
function modifier_nevermore_challenge_finally_attack_end:OnIntervalThink()
	local caster = self:GetCaster()

	local effect_name = "particles/rebuild/creeps_spell/sf/final_end.vpcf"
	local effect_cast = ParticleManager:CreateParticle( effect_name, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleShouldCheckFoW( effect_cast,false )
	ParticleManager:SetParticleControl(effect_cast,0,caster:GetOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast)

	local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 100000,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC ,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES , FIND_ANY_ORDER, false )
	local damage = self:GetAbility():GetSpecialValueFor("final_damage") * self:GetCaster():GetAverageTrueAttackDamage(nil)
	for _,enemy in pairs(enemies)do
		self.damageTable = {
			victim = enemy,
			attacker = self:GetCaster(),
			--damage = ,
			damage_type = self:GetAbility():GetAbilityDamageType(),
			ability = self:GetAbility(), --Optional.
			--hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		if enemy:IsMagicImmune() then
			self.damageTable.damage = damage *0.5
		else
			self.damageTable.damage = damage
		end
		ApplyDamage(self.damageTable)
	end
end
-----------------------------------------------------------------------
modifier_nevermore_challenge_finally_attack_during = advanced_modifier({})

function modifier_nevermore_challenge_finally_attack_during:IsHidden()	return true end
function modifier_nevermore_challenge_finally_attack_during:IsDebuff()	return true end
function modifier_nevermore_challenge_finally_attack_during:RemoveOnDeath()	return true end

function modifier_nevermore_challenge_finally_attack_during:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end

function modifier_nevermore_challenge_finally_attack_during:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_nevermore_challenge_finally_attack_during:GetOverrideAnimationRate( params )
	return 0.7
end

function modifier_nevermore_challenge_finally_attack_during:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_6
end

-----------------------------------------------------------------------
modifier_nevermore_challenge_finally_attack_check = advanced_modifier({})

function modifier_nevermore_challenge_finally_attack_check:IsHidden()	return false end
function modifier_nevermore_challenge_finally_attack_check:IsDebuff()	return false end
function modifier_nevermore_challenge_finally_attack_check:RemoveOnDeath()	return true end
