creeps_spell_skewer = class({})
LinkLuaModifier( "modifier_creeps_spell_skewer", "creeps_spell/creeps_spell_skewer", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_creeps_spell_skewer_debuff", "creeps_spell/creeps_spell_skewer", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_creeps_spell_skewer_slow", "creeps_spell/creeps_spell_skewer", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能
function creeps_spell_skewer:GetCastRange()
	if IsClient() then		-- Indicating no-remnant maximum range
		return self:GetSpecialValueFor("range")
	else					-- So you can click wherever and roll in that direction, even if its out of range
		return 30000
	end
end

function creeps_spell_skewer:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local maxrange = self:GetSpecialValueFor("range")

	local direction = point-caster:GetOrigin()
	if direction:Length2D() > maxrange then
		direction.z = 0
		direction = direction:Normalized()

		point = caster:GetOrigin() + direction * maxrange
	end

	Timers:CreateTimer(0.2, function()
		caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_skewer", -- modifier name
		{
			x = point.x,
			y = point.y,
		} -- kv
	)

	end)
	-- add modifier
	-- caster:AddNewModifier(
	-- 	caster, -- player source
	-- 	self, -- ability source
	-- 	"modifier_creeps_spell_skewer", -- modifier name
	-- 	{
	-- 		x = point.x,
	-- 		y = point.y,
	-- 	} -- kv
	-- )
end








modifier_creeps_spell_skewer = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_skewer:IsHidden()	return false end
function modifier_creeps_spell_skewer:IsDebuff()	return false end
function modifier_creeps_spell_skewer:IsStunDebuff()	return false end
function modifier_creeps_spell_skewer:IsPurgable()	return false end

function modifier_creeps_spell_skewer:IsAura()	return true end
function modifier_creeps_spell_skewer:GetModifierAura()	return "modifier_creeps_spell_skewer_debuff" end
function modifier_creeps_spell_skewer:GetAuraRadius()	return self.radius end
function modifier_creeps_spell_skewer:GetAuraDuration()	return 0.1 end
function modifier_creeps_spell_skewer:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_creeps_spell_skewer:GetAuraSearchType()	return DOTA_UNIT_TARGET_ALL end
function modifier_creeps_spell_skewer:GetAuraSearchFlags()	return 0 end
function modifier_creeps_spell_skewer:GetAuraEntityReject( hEntity )
	if IsServer() then
	end
	return false
end




function modifier_creeps_spell_skewer:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.speed = 1000

	if not IsServer() then return end

	self.origin = self:GetParent():GetOrigin()
	self.point = Vector( kv.x, kv.y, 0 )
	self.direction = self.point - self.origin
	self.distance = self.direction:Length2D()

	self.direction.z = 0
	self.direction = self.direction:Normalized()

	-- init
	self.enemies = {}

	-- motion
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	-- play effects
	self:PlayEffects()
end

function modifier_creeps_spell_skewer:OnRefresh( kv )
	self:OnCreated( kv )
end


function modifier_creeps_spell_skewer:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
	FindClearSpaceForUnit( self:GetParent(), self:GetParent():GetAbsOrigin(), true )
end


function modifier_creeps_spell_skewer:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}

	return funcs
end

function modifier_creeps_spell_skewer:GetOverrideAnimation()
	return ACT_DOTA_RUN
end
function modifier_creeps_spell_skewer:GetOverrideAnimationRate()
	return 3
end

function modifier_creeps_spell_skewer:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}


	return state
end


function modifier_creeps_spell_skewer:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local target = origin + self.direction*self.speed*dt
	me:SetOrigin( target )


	-- check distance
	local dist = (target-self.origin):Length2D()
	if dist>self.distance then
		self:SafeDestroy()
	end
end

function modifier_creeps_spell_skewer:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end




function modifier_creeps_spell_skewer:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf"
	local sound_cast = "Hero_Magnataur.Skewer.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		"attach_horn",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, self:GetParent():GetForwardVector() )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

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





modifier_creeps_spell_skewer_debuff = class({})


function modifier_creeps_spell_skewer_debuff:IsHidden()	return true end
function modifier_creeps_spell_skewer_debuff:IsDebuff()	return true end
function modifier_creeps_spell_skewer_debuff:IsStunDebuff()	return true end
function modifier_creeps_spell_skewer_debuff:IsPurgable()	return true end

function modifier_creeps_spell_skewer_debuff:OnCreated( kv )
	if not IsServer() then return end

	local ability = self:GetAbility()
	self.dist = 100
	self.damage = ability:GetSpecialValueFor("damage")*self:GetCaster():GetDamageMax()
	self.duration = ability:GetSpecialValueFor("duration")

	-- apply motion
	if not self:ApplyHorizontalMotionController() then
		self:SafeDestroy()
		return
	end

	-- play effects
	local sound_cast = "Hero_Magnataur.Skewer.Target"
	EmitSoundOn( sound_cast, self:GetParent() )
end



function modifier_creeps_spell_skewer_debuff:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )

	


	-- damage
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	ApplyDamage(damageTable)
	local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.35)
	local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_creeps_spell_skewer_slow", -- modifier name
		{ duration = self.duration*StatusResistance } -- kv
	)
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_skewer_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_creeps_spell_skewer_debuff:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_creeps_spell_skewer_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_creeps_spell_skewer_debuff:UpdateHorizontalMotion( me, dt )
	local caster = self:GetCaster()
	local target = caster:GetOrigin() + caster:GetForwardVector() * self.dist

	me:SetOrigin( target )
end

function modifier_creeps_spell_skewer_debuff:OnHorizontalMotionInterrupted()
	self:SafeDestroy()
end




modifier_creeps_spell_skewer_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_creeps_spell_skewer_slow:IsHidden()	return false end
function modifier_creeps_spell_skewer_slow:IsDebuff()	return true end
function modifier_creeps_spell_skewer_slow:IsStunDebuff()	return false end
function modifier_creeps_spell_skewer_slow:IsPurgable()	return true end

function modifier_creeps_spell_skewer_slow:OnCreated( kv )
	-- references
	local ability=self:GetAbility()
	self.as_slow = -ability:GetSpecialValueFor("as_slow")
	self.ms_slow = -ability:GetSpecialValueFor("ms_slow")

	if not IsServer() then return end
end


--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_creeps_spell_skewer_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_creeps_spell_skewer_slow:GetModifierAttackSpeedBonus_Constant()	return self.as_slow end
function modifier_creeps_spell_skewer_slow:GetModifierMoveSpeedBonus_Percentage()	return self.ms_slow end
function modifier_creeps_spell_skewer_slow:GetEffectName()	return "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf" end
function modifier_creeps_spell_skewer_slow:GetEffectAttachType()	return PATTACH_ABSORIGIN_FOLLOW end
