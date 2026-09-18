Middle_Chemical_Rage = class({})
LinkLuaModifier( "modifier_Middle_Chemical_Rage", "skills/Middle_Chemical_Rage", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
-- Ability Start
function Middle_Chemical_Rage:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	local ModifierStatusGain = caster:GetModifierDurationGainIndex(1)
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_Chemical_Rage", -- modifier name
		{ duration = duration*ModifierStatusGain } -- kv
	):SetStackCount(0)

	-- play effects
	local sound_cast = "Hero_Alchemist.ChemicalRage.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

--------------------------------------------------------------------------------
function Middle_Chemical_Rage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_heroname/heroname_ability.vpcf"
	local sound_cast = "string"

	-- Get Data

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_NAME, hOwner )
	ParticleManager:SetParticleControl( effect_cast, iControlPoint, vControlVector )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		iControlPoint,
		hTarget,
		PATTACH_NAME,
		"attach_name",
		vOrigin, -- unknown
		bool -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, iControlPoint, vForward )
	SetParticleControlOrientation( effect_cast, iControlPoint, vForward, vRight, vUp )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( vTargetPosition, sound_location, self:GetCaster() )
	EmitSoundOn( sound_target, target )
end



modifier_Middle_Chemical_Rage = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Chemical_Rage:IsHidden()return false end
function modifier_Middle_Chemical_Rage:IsDebuff()return false end
function modifier_Middle_Chemical_Rage:IsStunDebuff()return false end
function modifier_Middle_Chemical_Rage:IsPurgable()return false end
function modifier_Middle_Chemical_Rage:AllowIllusionDuplicate()return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Chemical_Rage:OnCreated( kv )
	-- references
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		self.bat = self.bat -0.15
		self.alchemist_talent = true
	end
	if not IsServer() then return end
	if self.alchemist_talent then
		self:GetParent():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_START)
	end
	-- disjoint & purge
	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )

	-- play effects
	self:PlayEffects()
	self:StartIntervalThink(1)
end

function modifier_Middle_Chemical_Rage:OnRefresh( kv )
	-- references
	self.bat = self:GetAbility():GetSpecialValueFor( "base_attack_time" )
	self.health = self:GetAbility():GetSpecialValueFor( "bonus_health" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "bonus_mana_regen" )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "bonus_movespeed" )
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		self.bat = self.bat -0.15
		self.alchemist_talent = true
	end
	if not IsServer() then return end

	-- disjoint & purge
	ProjectileManager:ProjectileDodge( self:GetParent() )
	self:GetParent():Purge( false, true, false, false, false )
end

function modifier_Middle_Chemical_Rage:OnIntervalThink()

	if IsClient() or self:GetStackCount()>=30 then
		return
	end
	self:IncrementStackCount()
end

function modifier_Middle_Chemical_Rage:OnRemoved()
end

function modifier_Middle_Chemical_Rage:OnDestroy()
	if not IsServer() then return end

	-- stop effects
	local sound_cast = "Hero_Alchemist.ChemicalRage"
	StopSoundOn( sound_cast, self:GetParent() )
	if self.alchemist_talent then
		self:GetParent():StartGesture(ACT_DOTA_ALCHEMIST_CHEMICAL_RAGE_END)
	end
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_Chemical_Rage:DeclareFunctions()
	local funcs = {
	MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
	MODIFIER_PROPERTY_HEALTH_BONUS,
	MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		table.insert(funcs,MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS)

		-- table.insert(funcs,MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs
end

function modifier_Middle_Chemical_Rage:GetModifierBaseAttackTimeConstant()
	return self.bat-self:GetStackCount()*0.01
end
function modifier_Middle_Chemical_Rage:AdvancedGetModifierConstantHealthRegen()
	return self.health_regen
end
function modifier_Middle_Chemical_Rage:GetModifierHealthBonus()
	return self.health
end
function modifier_Middle_Chemical_Rage:GetModifierConstantManaRegen()
	return self.mana_regen
end
function modifier_Middle_Chemical_Rage:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end

function modifier_Middle_Chemical_Rage:GetHeroEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_chemical_rage_hero_effect.vpcf"
end

function modifier_Middle_Chemical_Rage:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_chemical_rage.vpcf"
	local sound_cast = "Hero_Alchemist.ChemicalRage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )

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


function modifier_Middle_Chemical_Rage:GetActivityTranslationModifiers()	
	return "chemical_rage" 
end

-- advanced_modifier
function modifier_Middle_Chemical_Rage:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_alchemist_2") then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)

	end

	return funcs

end
function modifier_Middle_Chemical_Rage:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return 30
end





