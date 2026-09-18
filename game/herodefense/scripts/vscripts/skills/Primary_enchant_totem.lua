
Primary_enchant_totem = class({})
LinkLuaModifier( "modifier_Primary_enchant_totem", "skills/Primary_enchant_totem", LUA_MODIFIER_MOTION_NONE )

function Primary_enchant_totem:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf", context )


end
--------------------------------------------------------------------------------
-- Behavior
-- function Primary_enchant_totem:GetBehavior()
-- 	if self:GetCaster():HasScepter() then
-- 		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE
-- 	end
-- 	return self.BaseClass.GetBehavior( self )
-- end

--------------------------------------------------------------------------------
-- Custom KV
-- function Primary_enchant_totem:GetAOERadius()
-- 	return self:GetSpecialValueFor( "aftershock_range" )
-- end

-- function Primary_enchant_totem:GetCastRange( point, target )
-- 	local caster = self:GetCaster()
-- 	if caster:HasScepter() then
-- 		return self:GetSpecialValueFor( "distance_scepter" )
-- 	end

-- 	return self.BaseClass.GetCastPoint( self )
-- end

-- function Primary_enchant_totem:GetCastPoint()
-- 	if not IsServer() then
-- 		if self:GetCaster():HasScepter() then
-- 			return self:GetSpecialValueFor( "scepter_leap_duration" )
-- 		end
-- 		return self.BaseClass.GetCastPoint( self )
-- 	end

-- 	local caster = self:GetCaster()
-- 	local target = self:GetCursorTarget()

-- 	if caster:HasScepter() and target~=caster then
-- 		return self:GetSpecialValueFor( "scepter_leap_duration" )
-- 	end

-- 	return self.BaseClass.GetCastPoint( self )
-- end

--------------------------------------------------------------------------------
-- Ability Cast Filter
-- function Primary_enchant_totem:CastFilterResultTarget( hTarget )
-- 	return UF_SUCCESS
-- end

--------------------------------------------------------------------------------
-- Ability Phase Start
-- function Primary_enchant_totem:OnAbilityPhaseStart()
-- 	local caster = self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	local point = self:GetCursorPosition()

-- 	-- do normal
-- 	if not caster:HasScepter() then return true end
-- 	if target==caster then return true end

-- 	-- load data
-- 	local duration = self:GetSpecialValueFor( "scepter_leap_duration" )
-- 	local height = self:GetSpecialValueFor( "scepter_height" )
-- 	local distance = (point - caster:GetOrigin()):Length2D()

-- 	-- add arc modifier
-- 	local arc = caster:AddNewModifier(
-- 		caster, -- player source
-- 		self, -- ability source
-- 		"modifier_generic_arc_lua", -- modifier name
-- 		{
-- 			target_x = point.x,
-- 			target_y = point.y,
-- 			distance = distance,
-- 			duration = duration,
-- 			height = height,
-- 			fix_end = false,
-- 			isForward = true,
-- 			-- isRestricted = true,
-- 		} -- kv
-- 	)
-- 	arc:SetEndCallback(function()
-- 		if not self.interrupted then return end
-- 		self.interrupted = nil

-- 		-- do normal
-- 		self:OnSpellStart()
-- 		self:UseResources( true, false, true )
-- 	end)

-- 	return true
-- end
-- function Primary_enchant_totem:OnAbilityPhaseInterrupted()
-- 	self.interrupted = true
-- end
--------------------------------------------------------------------------------
-- Ability Start
function Primary_enchant_totem:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor("duration")


	local Gain = caster:GetModifierDurationGainIndex(1)
	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_enchant_totem", -- modifier name
		{ duration = duration*Gain } -- kv
	)

	-- Effects
	local sound_cast = "Hero_EarthShaker.Totem"
	EmitSoundOn( sound_cast, caster )
end





modifier_Primary_enchant_totem = advanced_modifier({})


function modifier_Primary_enchant_totem:IsHidden()	return false end
function modifier_Primary_enchant_totem:IsDebuff()	return false end
function modifier_Primary_enchant_totem:IsPurgable()	return false end
function modifier_Primary_enchant_totem:OnCreated( kv )
	-- references
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) 
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" ) 
	if IsServer() then
		self:PlayEffects()
	end
end

function modifier_Primary_enchant_totem:OnRefresh( kv )
	self.bonus = self:GetAbility():GetSpecialValueFor( "bonus_damage" ) 
	self.range = self:GetAbility():GetSpecialValueFor( "bonus_attack_range" )
end

function modifier_Primary_enchant_totem:OnDestroy( kv )

end


function modifier_Primary_enchant_totem:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,

	}

	return funcs
end

function modifier_Primary_enchant_totem:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus
end
function modifier_Primary_enchant_totem:GetActivityTranslationModifiers( params )
	return "enchant_totem"
end

function modifier_Primary_enchant_totem:GetModifierProcAttack_Feedback( params )
	if IsServer() then
		-- effects
		if params.damage<=0 then
			return
		end
		local sound_cast = "Hero_EarthShaker.Totem.Attack"
		EmitSoundOn( sound_cast, params.target )
		self:Destroy()
	end
end

function modifier_Primary_enchant_totem:Advanced_GetModifierAttackRangeBonus()
	return self.range
end

function modifier_Primary_enchant_totem:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_enchant_totem:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )

	local attach = "attach_attack1"
	if self:GetCaster():ScriptLookupAttachment( "attach_totem" )~=0 then attach = "attach_totem" end
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetParent(),
		PATTACH_POINT_FOLLOW,
		attach,
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
end


function modifier_Primary_enchant_totem:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
	
    }
end

function modifier_Primary_enchant_totem:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then
		return 
	end

	if keys.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then
		return -60
	end
end
