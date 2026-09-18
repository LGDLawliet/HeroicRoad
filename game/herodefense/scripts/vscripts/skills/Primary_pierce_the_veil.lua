Primary_pierce_the_veil = class({})
LinkLuaModifier( "modifier_Primary_pierce_the_veil_buff", "skills/Primary_pierce_the_veil", LUA_MODIFIER_MOTION_NONE )


function Primary_pierce_the_veil:Precache( context )
	PrecacheResource( "model", "models/heroes/muerta/muerta_ult.vmdl", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf", context )
end

function Primary_pierce_the_veil:IsRefreshable() return false end


function Primary_pierce_the_veil:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function Primary_pierce_the_veil:OnSpellStart(talent)
	local caster = self:GetCaster()

	local modifier = caster:FindModifierByName(caster.Form_MODIFIER_NAME)
	if modifier then
		modifier:SafeDestroy()
	end
	caster.Form_MODIFIER_NAME = "modifier_Primary_pierce_the_veil_buff"



	local duration = self:GetSpecialValueFor( "duration" ) * caster:GetModifierDurationGainIndex(0.3)
	local transform_duration = self:GetSpecialValueFor( "transform_duration" )
	caster:Purge(false, true, false, false, false)
	ProjectileManager:ProjectileDodge( caster )
	caster:AddNewModifier(
		caster,
		self,
		"modifier_Primary_pierce_the_veil_buff",
		{duration = duration + transform_duration,talent=talent and 1 or 0}
	)

	EmitSoundOn( "Hero_Muerta.PierceTheVeil.Cast", caster )
end








modifier_Primary_pierce_the_veil_buff = modifier_Primary_pierce_the_veil_buff or advanced_modifier({})

function modifier_Primary_pierce_the_veil_buff:IsHidden()	return false end
function modifier_Primary_pierce_the_veil_buff:IsDebuff()	return false end
function modifier_Primary_pierce_the_veil_buff:IsPurgable()	return false end
function modifier_Primary_pierce_the_veil_buff:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	self.modelscale = self:GetAbility():GetSpecialValueFor( "modelscale" )
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.transform_duration = self:GetAbility():GetSpecialValueFor( "transform_duration" )

	self.transforming = true
	self:StartIntervalThink( self.transform_duration )

	if not IsServer() then return end
	if kv.talent==1 then
		self.talent = true
	end
	self.undisarm_modifier = nil
	self:PlayEffectsStart()
end

function modifier_Primary_pierce_the_veil_buff:OnRefresh( kv )
end

function modifier_Primary_pierce_the_veil_buff:OnRemoved()
end

function modifier_Primary_pierce_the_veil_buff:OnDestroy()
	if not IsServer() then return end

	if self.undisarm_modifier then
		self.undisarm_modifier:Destroy()
		self.undisarm_modifier = nil
	end

	self:PlayEffectsEnd()
end


function modifier_Primary_pierce_the_veil_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MODEL_SCALE,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL, -- allow attack ethereal units
		-- MODIFIER_PROPERTY_ALWAYS_ALLOW_ATTACK, 

	}

	return funcs
end

function modifier_Primary_pierce_the_veil_buff:GetModifierModelChange()
	return "models/heroes/muerta/muerta_ult.vmdl"
end

function modifier_Primary_pierce_the_veil_buff:GetModifierModelScale()
	return self.modelscale
end

function modifier_Primary_pierce_the_veil_buff:GetModifierProjectileName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_projectile.vpcf"
end

function modifier_Primary_pierce_the_veil_buff:GetAttackSound()
	return "Hero_Muerta.PierceTheVeil.Attack"
end

function modifier_Primary_pierce_the_veil_buff:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_Primary_pierce_the_veil_buff:GetOverrideAttackMagical( params )
	return 1
end

-- function modifier_Primary_pierce_the_veil_buff:GetModifierTotalDamageOutgoing_Percentage( params )
-- 	if params.inflictor then return 0 end
-- 	if params.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
-- 	if params.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end

-- 	if not params.target:IsMagicImmune() then
-- 		local damageTable = {
-- 			victim = params.target,
-- 			attacker = self.parent,
-- 			damage = params.original_damage,
-- 			damage_type = DAMAGE_TYPE_MAGICAL,
-- 			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
-- 			ability = self.ability, --Optional.
-- 		}
-- 		ApplyDamage( damageTable )

-- 		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", params.target )
-- 	else
-- 		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact.MagicImmune", params.target )
-- 	end

-- 	return -200
-- end


-- function modifier_Primary_pierce_the_veil_buff:GetAlwaysAllowAttack( params )
-- 	return 1
-- end

-- advanced_modifier
function modifier_Primary_pierce_the_veil_buff:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
function modifier_Primary_pierce_the_veil_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_medusa_4") then return end
	if keys.inflictor then return 0 end
	if keys.damage_category~=DOTA_DAMAGE_CATEGORY_ATTACK then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL then return 0 end

	if not keys.target:IsMagicImmune() then
		local damageTable = {
			victim = keys.target,
			attacker = self.parent,
			damage = keys.original_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flag = DOTA_DAMAGE_FLAG_MAGIC_AUTO_ATTACK+DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			ability = self.ability, --Optional.
		}
		ApplyDamage( damageTable )

		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact", keys.target )
	else
		EmitSoundOn( "Hero_Muerta.PierceTheVeil.ProjectileImpact.MagicImmune", keys.target )
	end

	return -200
end



--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_pierce_the_veil_buff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = self.transforming,
		[MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true,
		-- [MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_DISARMED] = false,
	}
	if not self.talent then
		state[MODIFIER_STATE_ATTACK_IMMUNE] = true
	end

	return state
end

function modifier_Primary_pierce_the_veil_buff:OnIntervalThink()
	self.transforming = false
end

function modifier_Primary_pierce_the_veil_buff:GetEffectName()
	return "particles/units/heroes/hero_muerta/muerta_ultimate_form_ethereal.vpcf"
end

function modifier_Primary_pierce_the_veil_buff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_Primary_pierce_the_veil_buff:PlayEffectsStart()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_screen_effect.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector(1,0,0) )

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

function modifier_Primary_pierce_the_veil_buff:PlayEffectsEnd()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_muerta/muerta_ultimate_form_finish.vpcf"
	local sound_cast = "Hero_Muerta.PierceTheVeil.End"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end