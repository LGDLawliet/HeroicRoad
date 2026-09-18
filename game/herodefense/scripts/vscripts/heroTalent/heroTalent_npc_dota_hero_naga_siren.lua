heroTalent_npc_dota_hero_naga_siren = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_naga_siren", "heroTalent/heroTalent_npc_dota_hero_naga_siren", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_naga_siren_arua", "heroTalent/heroTalent_npc_dota_hero_naga_siren", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff", "heroTalent/heroTalent_npc_dota_hero_naga_siren", LUA_MODIFIER_MOTION_NONE )
-- require('internal/timers')   --计时器功能
function heroTalent_npc_dota_hero_naga_siren:GetIntrinsicModifierName()
	return "modifier_heroTalent_npc_dota_hero_naga_siren"
end

function heroTalent_npc_dota_hero_naga_siren:GetCastRange()
	local caster = self:GetCaster()
	return 700 - caster:GetCastRangeBonus()

end

modifier_heroTalent_npc_dota_hero_naga_siren = class({})

function modifier_heroTalent_npc_dota_hero_naga_siren:IsHidden()	return true end
function modifier_heroTalent_npc_dota_hero_naga_siren:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_naga_siren:RemoveOnDeath() return false end

function modifier_heroTalent_npc_dota_hero_naga_siren:OnCreated(keys)
	if IsServer() then
		if not self:GetParent():IsRealHero() then
			return false
		end
		self:StartIntervalThink(0.5)
	end

end

function modifier_heroTalent_npc_dota_hero_naga_siren:OnIntervalThink()
	local ability = self:GetAbility()
	if ability:IsCooldownReady() and ability:GetAutoCastState() and self:GetParent():IsAlive() then
		local caster = self:GetCaster()
		local modifier = caster:AddNewModifier(
			caster, -- player source
			ability, -- ability source
			"modifier_heroTalent_npc_dota_hero_naga_siren_arua", -- modifier name
			{ duration = 7 } -- kv
		)
		ability:UseResources(true, true, true, true)
	end
end





modifier_heroTalent_npc_dota_hero_naga_siren_arua = class({})

function modifier_heroTalent_npc_dota_hero_naga_siren_arua:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:OnCreated( kv )
	-- references
	self.radius = 700

	if not IsServer() then return end
	self:PlayEffects()
end



function modifier_heroTalent_npc_dota_hero_naga_siren_arua:OnDestroy()
	if not IsServer() then return end

	local sound_cast = "Hero_NagaSiren.SongOfTheSiren"
	local sound_stop = "Hero_NagaSiren.SongOfTheSiren.Cancel"
	StopSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_stop, self:GetCaster() )

end


function modifier_heroTalent_npc_dota_hero_naga_siren_arua:IsAura()	return true end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetModifierAura()
	return "modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff"
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetAuraRadius()
	return self.radius
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetAuraDuration()
	return 0.4
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end


--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_naga_siren_arua:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf"
	local sound_cast = "Hero_NagaSiren.SongOfTheSiren"

	-- Get Data
	local caster = self:GetCaster()

	-- Create Particle 1
	local effect_cast = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- create particle 2
	effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

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
	EmitSoundOn( sound_cast, caster )
end









modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff = advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:IsHidden()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:IsDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:IsStunDebuff()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:IsPurgable()	return false end
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetAttributes()	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE  end


function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:OnCreated( kv )
	self.rate = 1
	if not IsServer() then return end
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		
	}

	return funcs
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetOverrideAnimationRate()
	return self.rate
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:CheckState()
	if self:GetParent()==self:GetCaster() then
		return  {
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_SILENCED] = true,
			[MODIFIER_STATE_MUTED] = true,
			[MODIFIER_STATE_INVULNERABLE] = true,
		}
	end
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetEffectName()
	return "particles/units/heroes/hero_siren/naga_siren_song_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_siren_song.vpcf"
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:StatusEffectPriority()
	return MODIFIER_PRIORITY_NORMAL
end


function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:AdvancedGetModifierConstantHealthRegenPercentage()
	return 10
end

function modifier_heroTalent_npc_dota_hero_naga_siren_arua_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,


    }
end
