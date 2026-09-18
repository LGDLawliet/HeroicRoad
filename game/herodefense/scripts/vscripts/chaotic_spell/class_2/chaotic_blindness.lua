chaotic_blindness = class({})
LinkLuaModifier("modifier_chaotic_blindness_debuff", "chaotic_spell/class_2/chaotic_blindness", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_blindness_rune_2", "chaotic_spell/class_2/chaotic_blindness", LUA_MODIFIER_MOTION_NONE)


function chaotic_blindness:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_dust_hit_ring.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf", context )

end

function chaotic_blindness:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_blindness:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	if self:GetAutoCastState() then
		cost = cost * (1+self:GetSpecialValueFor("extra_mana_cost")*0.01)
	end
	return cost * self:GetManaCostGain()
end


function chaotic_blindness:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 

	if target:TriggerSpellAbsorb(self) then
		return
	end
	caster:EmitSound("chaotic_blindness_cast")  

	local duration = self:GetSpecialValueFor("duration")
	if self:GetRuneType()==1 then
		duration = duration * (1+0.01*self:GetSpecialValueFor("rune_1_bonus_gain"))

	end
	
	
	if self:GetRuneType()==2 then
		target:AddNewModifier(caster,self,"modifier_chaotic_blindness_rune_2",{duration = self:GetSpecialValueFor("rune_2_duration")})
	end
	
	self:ApplyModifier(target, duration)
	if self:GetRuneType()==3 then
		caster:GameTimer(self:GetSpecialValueFor("rune_3_time"),function ()
			if target:IsAlive() then
				local count = self:GetSpecialValueFor("base_count") * self:GetEffectGain()
				local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
				for _, unit in ipairs(enemies) do
			
					count = count - 1
					self:ApplyModifier(unit, duration)
					if count<=0 then
						break
					end
				end
			end
		end)
	end

	local count = self:GetSpecialValueFor("base_count") * self:GetEffectGain()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, unit in ipairs(enemies) do
		--if not unit:HasModifier("modifier_chaotic_blindness_debuff") then
		--if not unit == target then
			count = count - 1
			self:ApplyModifier(unit, duration)
			if count<=0 then
				break
			end
		--end
	end
end

function chaotic_blindness:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_blindness_debuff", {duration = duration*StatusResistance})


	local particle_cast1 = "particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_dust_hit_ring.vpcf"
	target:EmitSound("Hero_KeeperOfTheLight.BlindingLight")
	local effect_cast1 = ParticleManager:CreateParticle( particle_cast1, PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	DestroyParticleByDelay(effect_cast1,2)

	local damage = self:GetSpecialValueFor("damage") + self:GetSpecialValueFor("bonus_damage")*self:GetCaster():HDGetPrimaryStatValue()
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage*self:GetEffectGain(),
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		--hd_flags = ,
	}
	ApplyDamage(damageTable)
end




modifier_chaotic_blindness_debuff = modifier_chaotic_blindness_debuff or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_blindness_debuff:IsHidden()	return false end
function modifier_chaotic_blindness_debuff:IsDebuff()	return true end
function modifier_chaotic_blindness_debuff:IsStunDebuff()	return true end
function modifier_chaotic_blindness_debuff:IsPurgable()	return true end
function modifier_chaotic_blindness_debuff:RemoveOnDeath()	return false end
function modifier_chaotic_blindness_debuff:GetEffectName() return "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_blinding_light_debuff.vpcf" end
--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_blindness_debuff:OnCreated( kv )
	

	self.miss_chance = self:GetAbility():GetSpecialValueFor("miss_chance")
	if not IsServer() then return end
	
end



function modifier_chaotic_blindness_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}

	return funcs
end

function modifier_chaotic_blindness_debuff:GetModifierMiss_Percentage()
	return self.miss_chance
end

function modifier_chaotic_blindness_debuff:OnTooltip()
	return self:GetModifierMiss_Percentage()
end

-----------
modifier_chaotic_blindness_rune_2 = modifier_chaotic_blindness_rune_2 or advanced_modifier({})


function modifier_chaotic_blindness_rune_2:IsHidden()	return true end
function modifier_chaotic_blindness_rune_2:IsDebuff()	return true end
function modifier_chaotic_blindness_rune_2:IsStunDebuff()	return true end
function modifier_chaotic_blindness_rune_2:IsPurgable()	return false end
function modifier_chaotic_blindness_rune_2:RemoveOnDeath()	return false end
function modifier_chaotic_blindness_rune_2:CheckState()
	return
	{
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_chaotic_blindness_rune_2:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_chaotic_blindness_rune_2:GetModifierMagicalResistanceBonus()
	return -self:GetAbility():GetSpecialValueFor("rune_2_magicres_down")
end