
Middle_uproar =Middle_uproar or class({})
LinkLuaModifier("modifier_Middle_uproar", "skills/Middle_uproar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_uproar_buff", "skills/Middle_uproar", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_uproar_debuff", "skills/Middle_uproar", LUA_MODIFIER_MOTION_NONE)


function Middle_uproar:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf", context )
end

function Middle_uproar:Spawn()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Custom KV
function Middle_uproar:GetBehavior()
	if self:GetCaster():GetModifierStackCount( "modifier_Middle_uproar", self:GetCaster() )<1 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end

	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function Middle_uproar:GetAbilityTextureName(  )
	local stack = self:GetCaster():GetModifierStackCount( "modifier_Middle_uproar", self:GetCaster() )
	if stack==0 then
		return "primal_beast_uproar_none"
	elseif stack== self:GetSpecialValueFor("stack_limit") then
		return "primal_beast_uproar_max"
	else
		return "primal_beast_uproar_mid"
	end
end

function Middle_uproar:IsRefreshable()
	return false
end

function Middle_uproar:GetIntrinsicModifierName()
	return "modifier_Middle_uproar"
end

function Middle_uproar:CastFilterResult()
	if self:GetCaster():GetModifierStackCount( "modifier_Middle_uproar", self:GetCaster() )<1 then
		return UF_FAIL_CUSTOM
	end

	return UF_SUCCESS
end

function Middle_uproar:GetCustomCastError( hTarget )
	if self:GetCaster():GetModifierStackCount( "modifier_Middle_uproar", self:GetCaster() )<1 then
		return "#DOTA_CUSTOM_CAST_DENY_NO_stack"
	end

	return ""
end

function Middle_uproar:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor( "roar_duration" ) * caster:GetModifierDurationGainIndex(1)
	local radius = self:GetSpecialValueFor( "radius" )
	local slow = self:GetSpecialValueFor( "slow_duration" )
	local stack = 0
	local modifier = caster:FindModifierByName( "modifier_Middle_uproar" )
	if modifier then
		stack = modifier:GetStackCount()
		modifier:ResetStack()
	end

	caster:AddNewModifier(caster, self,"modifier_Middle_uproar_buff", 
		{
			duration = duration,
			stack = stack,
		}
	)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_Middle_uproar_debuff", -- modifier name
			{
				duration = slow,
				stack = stack,
			} -- kv
		)
	end

	self:StartCooldown( duration )
	self:PlayEffects( radius )
	self:PlayEffects2()
end

--------------------------------------------------------------------------------
-- Effects
function Middle_uproar:PlayEffects( radius )
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf"
	local sound_cast = "Hero_PrimalBeast.Uproar.Cast"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function Middle_uproar:PlayEffects2()
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_roar.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end








modifier_Middle_uproar =modifier_Middle_uproar or  advanced_modifier({})
function modifier_Middle_uproar:IsHidden()	return self:GetStackCount()<1 end
function modifier_Middle_uproar:IsDebuff()	return false end
function modifier_Middle_uproar:IsPurgable()	return false end
function modifier_Middle_uproar:RemoveOnDeath()	return false end
function modifier_Middle_uproar:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_uproar:OnCreated( kv )
	self.parent = self:GetParent()
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.stack_chance = self:GetAbility():GetSpecialValueFor("stack_chance")

	if not IsServer() then return end
end

function modifier_Middle_uproar:OnRefresh( kv )
	self.stack_limit = self:GetAbility():GetSpecialValueFor( "stack_limit" )
	self.duration = self:GetAbility():GetSpecialValueFor( "stack_duration" )	
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.stack_chance = self:GetAbility():GetSpecialValueFor("stack_chance")
end

function modifier_Middle_uproar:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}

	return funcs
end

function modifier_Middle_uproar:OnTakeDamage( params )
	if self.parent:PassivesDisabled() then return end
	if self.parent:HasModifier( "modifier_Middle_uproar_buff" ) then return end
	if params.unit~=self.parent then return end
	if self.stack_chance>=RandomInt(1, 100) then
		if self:GetStackCount()<self.stack_limit then
			self:IncrementStackCount()
	
			if self:GetStackCount()==self.stack_limit then
				EmitSoundOn( "Hero_PrimalBeast.Uproar.MaxStacks", self.parent )
			end
		end
		self:SetDuration( self.duration, true )
		self:StartIntervalThink(self.duration)
	end

	
end

function modifier_Middle_uproar:GetModifierPreAttack_BonusDamage()	return self.parent:PassivesDisabled() and 0 or self.damage end


function modifier_Middle_uproar:OnIntervalThink()	
	self:ResetStack() 
end
function modifier_Middle_uproar:ResetStack()	self:SetStackCount(0) end







-- function modifier_Middle_uproar:GetModifierPhysical_ConstantBlock(keys)  
-- 	if self.parent:PassivesDisabled() then
-- 		return
-- 	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
-- 	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end

-- 	local block = keys.damage * 0.1
-- 	if self.parent:HasModifier("modifier_Middle_uproar_buff") then
-- 		block = block *2
-- 	end
-- 	return block 
-- end



function modifier_Middle_uproar:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
function modifier_Middle_uproar:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if self.parent:PassivesDisabled() then
		return 0
	end
	local block = -10
	if self.parent:HasModifier("modifier_Middle_uproar_buff") then
		block = block *2
	end

	if IsClient() then
		return block
	end


	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then		return 0	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) == DOTA_DAMAGE_FLAG_HPLOSS then return 0	end
	if bit.band( keys.damage_flags, DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT ) == DOTA_CUSTOM_DAMAGE_FLAG_NO_ADDITIONAL_EFFECT then return 0 end


	return block 

end








modifier_Middle_uproar_buff = modifier_Middle_uproar_buff or advanced_modifier({})

function modifier_Middle_uproar_buff:IsHidden()	return false end
function modifier_Middle_uproar_buff:IsDebuff()	return false end
function modifier_Middle_uproar_buff:IsPurgable()	return true end
function modifier_Middle_uproar_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" )
	self.armor = self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )

	if not IsServer() then return end
	self:StartIntervalThink(0.1)
	self:SetStackCount(kv.stack)

	self:PlayEffects()
end

function modifier_Middle_uproar_buff:OnRefresh( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "bonus_damage_per_stack" )
	self.armor = self:GetAbility():GetSpecialValueFor( "roared_bonus_armor" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_Middle_uproar_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_Middle_uproar_buff:GetModifierPreAttack_BonusDamage()
	return self.damage * self:GetStackCount()
end

function modifier_Middle_uproar_buff:OnIntervalThink()
	self:GetAbility():StartCooldown(math.max(self:GetRemainingTime()-0.1,0))
end

function modifier_Middle_uproar_buff:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_primal_beast/primal_beast_uproar_magic_resist.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_OVERHEAD_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		2,
		self:GetParent(),
		PATTACH_OVERHEAD_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end


function modifier_Middle_uproar_buff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Middle_uproar_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Middle_uproar_buff:Advanced_GetModifierPhysicalArmorBonus()
    return self.armor * self:GetStackCount()
end






modifier_Middle_uproar_debuff = modifier_Middle_uproar_debuff or class({})
function modifier_Middle_uproar_debuff:IsHidden()	return false end
function modifier_Middle_uproar_debuff:IsDebuff()	return true end
function modifier_Middle_uproar_debuff:IsPurgable()	return true end
function modifier_Middle_uproar_debuff:GetTexture()	return "primal_beast_uproar" end
function modifier_Middle_uproar_debuff:OnCreated( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	self.attack_slow = -self:GetAbility():GetSpecialValueFor( "attack_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end

function modifier_Middle_uproar_debuff:OnRefresh( kv )
	self.slow = -self:GetAbility():GetSpecialValueFor( "move_slow_per_stack" )
	self.attack_slow = -self:GetAbility():GetSpecialValueFor( "attack_slow_per_stack" )
	if not IsServer() then return end
	self:SetStackCount(kv.stack)
end


function modifier_Middle_uproar_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_Middle_uproar_debuff:GetModifierMoveSpeedBonus_Constant()
	return math.max(self.slow * self:GetStackCount(),-90)
end
function modifier_Middle_uproar_debuff:GetModifierAttackSpeedBonus_Constant() 	return self.attack_slow * self:GetStackCount() end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Middle_uproar_debuff:GetStatusEffectName()
	return "particles/units/heroes/hero_primal_beast/primal_beast_status_effect_slow.vpcf"
end

function modifier_Middle_uproar_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end