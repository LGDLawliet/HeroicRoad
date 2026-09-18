slark_challenge_shadow_dance = class({})
LinkLuaModifier( "modifier_slark_challenge_shadow_dance", "creeps_spell/slark_challenge_shadow_dance", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_shadow_dance_buff", "creeps_spell/slark_challenge_shadow_dance", LUA_MODIFIER_MOTION_NONE )

function slark_challenge_shadow_dance:GetIntrinsicModifierName()
	return "modifier_slark_challenge_shadow_dance"
end



modifier_slark_challenge_shadow_dance = class({})

function modifier_slark_challenge_shadow_dance:IsHidden()	return false end
function modifier_slark_challenge_shadow_dance:IsDebuff()	return false end
function modifier_slark_challenge_shadow_dance:IsPurgable()	return false end
function modifier_slark_challenge_shadow_dance:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_slark_challenge_shadow_dance:OnIntervalThink()
	local caster = self:GetCaster()
	if self:GetStackCount()<50 and caster:GetHealthPercent()<=10 then
		caster:AddNewModifier(
			caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_slark_shadow_dance_buff", -- modifier name
			{ duration = 0.55} -- kv
		)
		self:IncrementStackCount()
	end

end





modifier_slark_shadow_dance_buff = advanced_modifier({})
function modifier_slark_shadow_dance_buff:IsHidden()	return true end
function modifier_slark_shadow_dance_buff:IsDebuff()	return false end
function modifier_slark_shadow_dance_buff:IsPurgable()	return false end
function modifier_slark_shadow_dance_buff:GetPriority()	return MODIFIER_PRIORITY_HIGH end

--------------------------------------------------------------------------------
-- Initializations
function modifier_slark_shadow_dance_buff:OnCreated( kv )

	if not IsServer() then return end
	self:PlayEffects1()
	self:PlayEffects2()
	self:StartIntervalThink(FrameTime())
end


function modifier_slark_shadow_dance_buff:OnDestroy( kv )
	if IsServer() then
		local sound_cast = "Hero_Slark.ShadowDance"
		StopSoundOn( sound_cast, self:GetParent() )
	end
end

function modifier_slark_shadow_dance_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
	return funcs
end

function modifier_slark_shadow_dance_buff:GetModifierInvisibilityLevel()	return 2 end


function modifier_slark_shadow_dance_buff:CheckState()
	local state = {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_TRUESIGHT_IMMUNE] = true,
	}
	return state
end

function modifier_slark_shadow_dance_buff:OnIntervalThink()
	ParticleManager:SetParticleControl( self.effect_cast, 1, self:GetParent():GetOrigin() )
end


function modifier_slark_shadow_dance_buff:GetStatusEffectName()	return "particles/status_fx/status_effect_slark_shadow_dance.vpcf" end
function modifier_slark_shadow_dance_buff:StatusEffectPriority()	return MODIFIER_PRIORITY_NORMAL end

function modifier_slark_shadow_dance_buff:PlayEffects1()

	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf"
	local sound_cast = "Hero_Slark.ShadowDance"
	local parent = self:GetParent()
	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_ABSORIGIN_FOLLOW, parent, parent:GetTeamNumber() )
	ParticleManager:SetParticleControlEnt(	effect_cast,1,parent,PATTACH_ABSORIGIN_FOLLOW,"attach_hitloc",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,3,parent,PATTACH_POINT_FOLLOW,"attach_eyeR",Vector(0,0,0),true)
	ParticleManager:SetParticleControlEnt(effect_cast,4,parent,PATTACH_POINT_FOLLOW,"attach_eyeL",Vector(0,0,0), true )

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	EmitSoundOn( sound_cast, parent )
end

function modifier_slark_shadow_dance_buff:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf"

	-- Get Data
	local parent = self:GetParent()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, parent )
	ParticleManager:SetParticleControl( effect_cast, 0, parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, parent:GetOrigin() )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	self.effect_cast = effect_cast
end

function modifier_slark_shadow_dance_buff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end


function modifier_slark_shadow_dance_buff:AdvancedGetModifierConstantHealthRegenPercentage()
	return 1
end