creeps_spell_fiery_soul = class({})
LinkLuaModifier( "modifier_creeps_spell_fiery_soul", "creeps_spell/creeps_spell_fiery_soul", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function creeps_spell_fiery_soul:GetIntrinsicModifierName()
	return "modifier_creeps_spell_fiery_soul"
end

modifier_creeps_spell_fiery_soul = modifier_creeps_spell_fiery_soul or  class({})
function modifier_creeps_spell_fiery_soul:IsHidden()	return self:GetStackCount()==0 end
function modifier_creeps_spell_fiery_soul:IsDebuff()	return false end
function modifier_creeps_spell_fiery_soul:IsPurgable()	return false end
function modifier_creeps_spell_fiery_soul:IsPurgeException() return false end
function modifier_creeps_spell_fiery_soul:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_fiery_soul:OnCreated( kv )
	-- references
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stack" )
	self.duration = 15

	if not IsServer() then return end
	-- play effects
    self:PlayEffects2()
	self:PlayEffects()
end

function modifier_creeps_spell_fiery_soul:OnRefresh( kv )
	-- references
    self.as_bonus = self:GetAbility():GetSpecialValueFor( "bonus_attack_speed" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "bonus_move_speed" )
	self.max_stacks = self:GetAbility():GetSpecialValueFor( "max_stack" )
	self.duration = 15
end

function modifier_creeps_spell_fiery_soul:OnRemoved()
end

function modifier_creeps_spell_fiery_soul:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_fiery_soul:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end

function modifier_creeps_spell_fiery_soul:GetModifierMoveSpeedBonus_Percentage( params )
	return self:GetStackCount() * self.ms_bonus
end

function modifier_creeps_spell_fiery_soul:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount() * self.as_bonus
end

function modifier_creeps_spell_fiery_soul:OnAbilityExecuted( params )
	if not IsServer() then return end
	-- filter
	if params.unit~=self:GetParent() then return end
	if self:GetParent():PassivesDisabled() then return end
	if not params.ability then return end
	if params.ability:IsItem() or params.ability:IsToggle() then return end

	-- increment stack
	if self:GetStackCount()<self.max_stacks then
		self:IncrementStackCount()
	end

	-- refresh duration
	self:SetDuration( self.duration, true )
	self:StartIntervalThink( self.duration )

	-- Change Effects
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_creeps_spell_fiery_soul:OnIntervalThink()
	-- Expire
	self:StartIntervalThink( -1 )
	self:SetStackCount( 0 )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_creeps_spell_fiery_soul:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_fiery_soul.vpcf"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self:GetStackCount(), 0, 0 ) )

	-- buff particle
	self:AddParticle(
		self.effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end

function modifier_creeps_spell_fiery_soul:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/lina_ambient/lina_ambient_fire_root.vpcf"

	-- Create Particle
    -- local parent = self:GetParent()
    self.nFXIndex2 = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( self.nFXIndex2, 1, Vector(5, 0, 0 ) )
    -- ParticleManager:SetParticleControlEnt( self.nFXIndex2, 4, parent, PATTACH_POINT_FOLLOW, "attach_attack1",parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.nFXIndex2, 5, parent, PATTACH_POINT_FOLLOW, "attach_attack2",parent:GetAbsOrigin(), true )
    -- ParticleManager:SetParticleControlEnt( self.nFXIndex2, 6, parent, PATTACH_POINT_FOLLOW, "attach_neck",parent:GetAbsOrigin(), true )

	-- buff particle
	self:AddParticle(
		self.nFXIndex2,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end