Middle_Vampiric_Spirit = class({})
LinkLuaModifier( "modifier_Middle_Vampiric_Spirit", "skills/Middle_Vampiric_Spirit", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Vampiric_Spirit_effect", "skills/Middle_Vampiric_Spirit", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Middle_Vampiric_Spirit:GetIntrinsicModifierName()
	return "modifier_Middle_Vampiric_Spirit"
end


modifier_Middle_Vampiric_Spirit = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Vampiric_Spirit:IsHidden()	return true end
function modifier_Middle_Vampiric_Spirit:IsDebuff()	return false end
function modifier_Middle_Vampiric_Spirit:IsPurgable() 		return false end
function modifier_Middle_Vampiric_Spirit:IsPurgeException() 	return false end
function modifier_Middle_Vampiric_Spirit:RemoveOnDeath()  return false end
function modifier_Middle_Vampiric_Spirit:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_Vampiric_Spirit:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Middle_Vampiric_Spirit:GetModifierAura()	return "modifier_Middle_Vampiric_Spirit_effect" end
function modifier_Middle_Vampiric_Spirit:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Middle_Vampiric_Spirit:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Vampiric_Spirit:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Middle_Vampiric_Spirit:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_Middle_Vampiric_Spirit_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Vampiric_Spirit_effect:IsHidden()	return false end
function modifier_Middle_Vampiric_Spirit_effect:IsDebuff()	return false end
function modifier_Middle_Vampiric_Spirit_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_Vampiric_Spirit_effect:IsPurgable()	return false end
function modifier_Middle_Vampiric_Spirit_effect:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,                       --受到伤害事件
		MODIFIER_PROPERTY_HEALTH_BONUS,                     --生命值
	}
end

function modifier_Middle_Vampiric_Spirit_effect:OnCreated(table)
	if IsServer() then
		self.bonus_health = self:GetCaster():HDGetPrimaryStatValue()*5

		self:StartIntervalThink(1)
		
	end
end
function modifier_Middle_Vampiric_Spirit_effect:OnIntervalThink(table)
	self.bonus_health = self:GetCaster():HDGetPrimaryStatValue()*5

end
function modifier_Middle_Vampiric_Spirit_effect:OnTakeDamage( params )

	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit

		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Target == nil then
			return 0
		end

		if params.damage_category == 0 then   --DOTA_DAMAGE_CATEGORY_SPELL = 0 只能是攻击伤害
			return
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end
		if flDamage<=0 then
			return
		end

		if Attacker:GetHealthPercent()>=100 then
			return
		end

		local ability = self:GetAbility()
		if not ability then
			return
		end
		local bonus_life_steal = ability:GetSpecialValueFor("bonus_life_steal")*0.01
		local gain = Attacker:GetModifierLifeStealGain(1)
		local flLifesteal =( flDamage * bonus_life_steal+ability:GetSpecialValueFor("bonus_life_steal_constant"))*gain

		if flLifesteal<=0 then
			return
		end
		Attacker:Heal( flLifesteal, self:GetAbility() )
		self:PlayEffects( Attacker )
	end

	return 0.0

end
function modifier_Middle_Vampiric_Spirit_effect:GetModifierHealthBonus() return self:GetParent():IsRealHero() and self.bonus_health or 0 end

function modifier_Middle_Vampiric_Spirit_effect:PlayEffects( target )
	-- get resource
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf"

	-- play effects
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end