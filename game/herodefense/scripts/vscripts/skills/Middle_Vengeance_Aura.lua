Middle_Vengeance_Aura = class({})
LinkLuaModifier( "modifier_Middle_Vengeance_Aura", "skills/Middle_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Middle_Vengeance_Aura_effect", "skills/Middle_Vengeance_Aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Middle_Vengeance_Aura:GetIntrinsicModifierName()
	return "modifier_Middle_Vengeance_Aura"
end


modifier_Middle_Vengeance_Aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Vengeance_Aura:IsHidden()	return true end
function modifier_Middle_Vengeance_Aura:IsDebuff()	return false end
function modifier_Middle_Vengeance_Aura:IsPurgable() 		return false end
function modifier_Middle_Vengeance_Aura:IsPurgeException() 	return false end
function modifier_Middle_Vengeance_Aura:RemoveOnDeath()  return false end
function modifier_Middle_Vengeance_Aura:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_Vengeance_Aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Middle_Vengeance_Aura:GetModifierAura()	return "modifier_Middle_Vengeance_Aura_effect" end
function modifier_Middle_Vengeance_Aura:GetAuraRadius()	return self:GetAbility():GetSpecialValueFor("radius")  end
function modifier_Middle_Vengeance_Aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_Middle_Vengeance_Aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Middle_Vengeance_Aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE  end



modifier_Middle_Vengeance_Aura_effect = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Vengeance_Aura_effect:IsHidden()	return false end
function modifier_Middle_Vengeance_Aura_effect:IsDebuff()	return false end
function modifier_Middle_Vengeance_Aura_effect:GetAttributes() return  MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Middle_Vengeance_Aura_effect:IsPurgable()	return false end
function modifier_Middle_Vengeance_Aura_effect:OnCreated( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )


end

function modifier_Middle_Vengeance_Aura_effect:OnRefresh( kv )
	-- references
	self.bonus_damage = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

end



--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Middle_Vengeance_Aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,    --攻击力百分比
		-- MODIFIER_PROPERTY_BASE_MANA_REGEN,
		-- MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end
function modifier_Middle_Vengeance_Aura_effect:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_DEATH_AGAIN = {nil,self:GetParent()},
		MODIFIER_EVENT_ON_DEATH = {nil,nil}
		
	}
end
function modifier_Middle_Vengeance_Aura_effect:GetModifierBaseDamageOutgoing_Percentage()
	return self.bonus_damage
end

function modifier_Middle_Vengeance_Aura_effect:AdvancedOnDeathAgain(keys)
	if not IsServer() then
        return
    end
	local parent = self:GetParent()
	local ability = self:GetAbility()
	local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil,
    500,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local target = enemies[1]
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle)
	local damage = parent:GetDamageMax()*5
	if parent:IsRealHero() then
		damage =damage *2
	end
	damage = damage* keys.mul_index

	parent:GameTimer(0.2,function()
		if IsValid(self) then
			ApplyDamage({victim = target, attacker = parent, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
			target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
		end
	end)

end

function modifier_Middle_Vengeance_Aura_effect:OnDeath(keys)
    if not IsServer() then
        return
    end

	if not keys.attacker then
		return
	end
    if keys.unit == self:GetParent() and IsEnemy(keys.unit, keys.attacker) then
		local parent = self:GetParent()
		local target = keys.attacker
		local ability = self:GetAbility()


		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf", PATTACH_POINT_FOLLOW, target)
		ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local damage = parent:GetDamageMax()*5
		if parent:IsRealHero() then
			damage =damage *2
		end
		parent:GameTimer(0.2,function()
			if IsValid(self) then
				ApplyDamage({victim = target, attacker = parent, damage = damage, damage_type = ability:GetAbilityDamageType(), ability = ability})
				target:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
			end
		end)


    end
   
end


