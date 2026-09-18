
--------------------------------------------------------------------------------
slark_challenge_pounce = class({})
LinkLuaModifier( "modifier_slark_challenge_pounce", "creeps_spell/slark_challenge_pounce", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_slark_challenge_pounce_debuff", "creeps_spell/slark_challenge_pounce", LUA_MODIFIER_MOTION_BOTH )

LinkLuaModifier( "modifier_generic_leashed_lua", "modifier/generic/modifier_generic_leashed_lua", LUA_MODIFIER_MOTION_BOTH )



function slark_challenge_pounce:OnAbilityPhaseStart()
	-- self:GetCaster():StartGesture(ACT_DOTA_ATTACK)
	self.pre_spell = ParticleManager:CreateParticle( "particles/rebuild/alert/alert_1/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( self.pre_spell, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
	ParticleManager:SetParticleControl( self.pre_spell, 1, Vector(2,0,0) )
	return true
end

---------------------------------------------------------------

function slark_challenge_pounce:OnAbilityPhaseInterrupted()
	if self.pre_spell then
		ParticleManager:DestroyParticle(self.pre_spell, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell )
		self.pre_spell = nil
	end

end





--------------------------------------------------------------------------------
-- Ability Start
function slark_challenge_pounce:OnSpellStart()
	if self.pre_spell then
		ParticleManager:DestroyParticle(self.pre_spell, false)
		ParticleManager:ReleaseParticleIndex( self.pre_spell )
		self.pre_spell = nil
	end
	-- unit identifier
	local caster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	-- pounce
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_challenge_pounce", -- modifier name
		{unit_entindex	= hTarget:entindex()} -- kv
	)

	-- play effects
	local sound_cast = "Hero_Slark.Pounce.Cast"
	EmitSoundOn( sound_cast, caster )
end


modifier_slark_challenge_pounce = class({})

function modifier_slark_challenge_pounce:IsHidden()	return true end
function modifier_slark_challenge_pounce:IsDebuff()	return false end
function modifier_slark_challenge_pounce:IsStunDebuff()	return false end
function modifier_slark_challenge_pounce:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_challenge_pounce:OnCreated( kv )
	self.parent = self:GetParent()

	-- references
	local speed = 1500
	local distance = 1500

	self.radius = 250   --检测范围
	self.leash_radius = 300   --移动范围
	self.leash_duration = 7

	local duration = distance/speed
	local height = 160

	if not IsServer() then return end

	self.target = EntIndexToHScript(kv.unit_entindex)

	self.arc = self.parent:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			speed = speed,
			duration = duration,
			distance = distance,
			height = height,
		} -- kv
	)
	self.arc:SetEndCallback(function( interrupted )
		-- destroy this modifier when arc ends
		if self:IsNull() then return end
		self.arc = nil
		self:SafeDestroy()
	end)

	-- set duration
	self:SetDuration( duration, true )

	-- set inactive
	self:GetAbility():SetActivated( false )

	-- Start interval
	self:StartIntervalThink( 0.1 )
	self:OnIntervalThink()

	-- play effects
	self:PlayEffects()
end


function modifier_slark_challenge_pounce:OnDestroy()
	if not IsServer() then return end

	-- set active
	self:GetAbility():SetActivated( true )

	-- destroy arc modifier
	if self.arc and not self.arc:IsNull() then
		self.arc:SafeDestroy()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_slark_challenge_pounce:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_slark_challenge_pounce:OnIntervalThink()
	-- find units
	-- local enemies = FindUnitsInRadius(
	-- 	self.parent:GetTeamNumber(),	-- int, your team number
	-- 	self.parent:GetOrigin(),	-- point, center point
	-- 	nil,	-- handle, cacheUnit. (not known)
	-- 	self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	-- 	DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	-- 	0,	-- int, flag filter
	-- 	FIND_CLOSEST,	-- int, order filter
	-- 	false	-- bool, can grow cache
	-- )

	local target
	local dis = CalculateDistance(self.parent, self.target)
	if dis<=self.radius then
		target = self.target
	end
	-- for _,enemy in pairs(enemies) do
	-- 	if not enemy:IsIllusion() then
	-- 		target = enemy
	-- 		break
	-- 	end
	-- end

	if not target then return end

	-- add leash
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	local StatusResistance = self.target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	target:AddNewModifier(
		self.parent, -- player source
		self:GetAbility(), -- ability source
		"modifier_slark_challenge_pounce_debuff", -- modifier name
		{
			duration = self.leash_duration*StatusResistance,
			radius = self.leash_radius,
			purgable = false,
		} -- kv
	)

	-- play effects
	local sound_cast = "Hero_Slark.Pounce.Impact"
	EmitSoundOn( sound_cast, target )

	-- destroy
	self:SafeDestroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_challenge_pounce:GetEffectName()
	return "particles/units/heroes/hero_slark/slark_pounce_trail.vpcf"
end

function modifier_slark_challenge_pounce:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_slark_challenge_pounce:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_start.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

end







--束缚状态

modifier_slark_challenge_pounce_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_slark_challenge_pounce_debuff:IsHidden()	return false end
function modifier_slark_challenge_pounce_debuff:IsDebuff()	return true end
function modifier_slark_challenge_pounce_debuff:IsStunDebuff()	return false  end
function modifier_slark_challenge_pounce_debuff:IsPurgable()	return false end
function modifier_slark_challenge_pounce_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_slark_challenge_pounce_debuff:CheckState()
	local state = {[MODIFIER_STATE_TETHERED] = true}

	return state
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_challenge_pounce_debuff:OnCreated( kv )
	if not IsServer() then return end
	self.radius = kv.radius

	self.leash = self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_generic_leashed_lua", -- modifier name
		kv -- kv
	)
	self.leash:SetEndCallback(function()
		-- destroy this modifier when leash ends
		if self:IsNull() then return end
		self.leash = nil
		self:SafeDestroy()
	end)

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end


function modifier_slark_challenge_pounce_debuff:OnDestroy()
	if not IsServer() then return end
	-- destroy leash modifier
	if self.leash and not self.leash:IsNull() then
		self.leash:SafeDestroy()
	end

	local sound_cast = "Hero_Slark.Pounce.Leash"
	local sound_end = "Hero_Slark.Pounce.End"
	StopSoundOn( sound_cast, self:GetParent() )
	EmitSoundOn( sound_end, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_slark_challenge_pounce_debuff:GetStatusEffectName()	return "particles/status_fx/status_effect_frost.vpcf" end
function modifier_slark_challenge_pounce_debuff:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end
function modifier_slark_challenge_pounce_debuff:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_ground.vpcf"
	local sound_cast = "Hero_Slark.Pounce.Leash"

	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_WORLDORIGIN,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius, 0, 0 ) )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_slark_challenge_pounce_debuff:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_pounce_leash.vpcf"

	local caster = self:GetCaster()
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		parent,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 3, self:GetParent():GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)
end