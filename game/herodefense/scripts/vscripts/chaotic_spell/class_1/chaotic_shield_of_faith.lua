
chaotic_shield_of_faith = class({})
LinkLuaModifier("modifier_chaotic_shield_of_faith", "chaotic_spell/class_1/chaotic_shield_of_faith", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_shield_of_faith_rune_2", "chaotic_spell/class_1/chaotic_shield_of_faith", LUA_MODIFIER_MOTION_NONE)


function chaotic_shield_of_faith:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_shield_of_faith/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_shield_of_faith/effect_hit/effect.vpcf", context )

end


function chaotic_shield_of_faith:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_shield_of_faith:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	
	self:ApplyModifier(target, duration)
	if self:GetRuneType()==3 then
		local heroes = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 30000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		for _ , hero in pairs(heroes) do
			if #heroes == 1 then
				self:ApplyModifier(caster, duration * (1+self:GetSpecialValueFor("rune_3_duration_up")*0.01))
			else
				if hero~=caster then
					self:ApplyModifier(hero, duration * (1+self:GetSpecialValueFor("rune_3_duration_up")*0.01))
					break
				end
			end
		end
	end
end



function chaotic_shield_of_faith:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_shield_of_faith/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,2)
end










function chaotic_shield_of_faith:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_shield_of_faith", {duration = duration})
	target:EmitSound("chaotic_shield_of_faith_target") 
	local pos = target:GetAbsOrigin()
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_shield_of_faith/effect_hit/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 1, pos )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(effect_cast1, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl( effect_cast1, 2, Vector(300,0,0) )
	DestroyParticleByDelay(effect_cast1,5)

end




modifier_chaotic_shield_of_faith = modifier_chaotic_shield_of_faith or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_shield_of_faith:IsHidden()	return false end
function modifier_chaotic_shield_of_faith:IsDebuff()	return false end
function modifier_chaotic_shield_of_faith:IsStunDebuff()	return false end
function modifier_chaotic_shield_of_faith:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_shield_of_faith:OnCreated( kv )
	local gain = self:GetAbility():GetEffectGain()
	if self:GetAbility():GetRuneType()==1 then
		self.lifesteal = self:GetAbility():GetSpecialValueFor("rune_1_lifesteal")*gain
		self.bonus_magic_resistance = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance")*(1-self:GetAbility():GetSpecialValueFor("rune_1_defense_down")*0.01) *gain
		self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")*(1-self:GetAbility():GetSpecialValueFor("rune_1_defense_down")*0.01) *gain
	else
		self.bonus_magic_resistance = self:GetAbility():GetSpecialValueFor("bonus_magic_resistance") *gain
		self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")*gain
		self.lifesteal = 0
	end
end

function modifier_chaotic_shield_of_faith:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage,
    }
end

function modifier_chaotic_shield_of_faith:Advanced_GetModifierPhysicalArmorBonusPercentage(keys)
	return self.bonus_armor
end

function modifier_chaotic_shield_of_faith:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end

function modifier_chaotic_shield_of_faith:GetModifierMagicalResistanceBonus()	return self.bonus_magic_resistance end


function modifier_chaotic_shield_of_faith:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if self:GetAbility():GetRuneType()~=2 then
		return
	end
	if keys.attacker:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end
	keys.attacker:AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_chaotic_shield_of_faith_rune_2",{duration = 1.5})
end

function modifier_chaotic_shield_of_faith:Advanced_GetModifier_LifeSteal_AttackDamage()
	return self.lifesteal
end
-----------

modifier_chaotic_shield_of_faith_rune_2 = modifier_chaotic_shield_of_faith_rune_2 or advanced_modifier({})


function modifier_chaotic_shield_of_faith_rune_2:IsHidden()	return false end
function modifier_chaotic_shield_of_faith_rune_2:IsDebuff()	return true end
function modifier_chaotic_shield_of_faith_rune_2:IsStunDebuff()	return false end
function modifier_chaotic_shield_of_faith_rune_2:IsPurgable()	return false end
function modifier_chaotic_shield_of_faith_rune_2:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_chaotic_shield_of_faith_rune_2:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	return -self:GetAbility():GetSpecialValueFor("rune_2_damage_down")
end