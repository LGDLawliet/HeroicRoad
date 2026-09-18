chaotic_night_dance = class({})
LinkLuaModifier("modifier_chaotic_night_dance", "chaotic_spell/class_7/chaotic_night_dance", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_night_dance_rune_1_buff", "chaotic_spell/class_7/chaotic_night_dance", LUA_MODIFIER_MOTION_NONE)

function chaotic_night_dance:GetIntrinsicModifierName() return "modifier_chaotic_night_dance" end

function chaotic_night_dance:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", context )
end



function chaotic_night_dance:GetCooldown(iLevel)
	if self:GetRuneType()==1 then
		return self:GetSpecialValueFor("rune_1_cooldown")
	end
	return 0
end

function chaotic_night_dance:GetHealthCost(iLevel)
	if self:GetRuneType()==1 then
		return self:GetSpecialValueFor("rune_1_health_cost")
	end
	return 0
end

function chaotic_night_dance:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
	end
	return self.BaseClass.GetBehavior(self)
end

function chaotic_night_dance:OnSpellStart()


	local caster =self:GetCaster()

	-- local infest_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_summon_wild_bear/effects.vpcf", PATTACH_POINT, caster)
	-- ParticleManager:SetParticleControl(infest_particle, 0, unit_pos)
	-- ParticleManager:ReleaseParticleIndex(infest_particle)
	if self:GetRuneType()==1 then
		caster:EmitSound("Hero_Luna.Eclipse.Cast")
		local particle_caster_ground_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_night_stalker/nightstalker_ulti.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt( particle_caster_ground_fx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
		local gain = caster:GetModifierDurationGainIndex(1)
		caster:AddNewModifier(caster, self, "modifier_chaotic_night_dance_rune_1_buff", {duration=self:GetSpecialValueFor("rune_1_duration")*gain})
	end
	



end






modifier_chaotic_night_dance = advanced_modifier({})

function modifier_chaotic_night_dance:IsDebuff()			return false end
function modifier_chaotic_night_dance:IsHidden() 		return false end
function modifier_chaotic_night_dance:IsPurgable() 		return false end
function modifier_chaotic_night_dance:IsPurgeException() return false end

function modifier_chaotic_night_dance:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_night_dance:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {nil,self:GetParent()},
		MODIFIER_EVENT_ON_DEATH = {nil, nil},
    }
end

function modifier_chaotic_night_dance:OnCreated() 
	if not IsServer() then
		return
	end

	self.parent = self:GetParent()
    self.miss = self:GetAbility():GetSpecialValueFor("miss")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.bonus_attack_speed_max = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_max")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	self.elite_factor= self:GetAbility():GetSpecialValueFor("elite_factor")
	self.max_bonus_agility = self:GetAbility():GetSpecialValueFor("max_bonus_agility")
	self.bonus_miss = 0
	self.agility = 0
	self.tData = {}
	self.IsInNightTime = false

	self:StartIntervalThink(0.1)
	self:SetHasCustomTransmitterData( true )
end

function modifier_chaotic_night_dance:OnRefresh() 

	if not IsServer() then
		return
	end

	self.parent = self:GetParent()
    self.miss = self:GetAbility():GetSpecialValueFor("miss")
	self.chance = self:GetAbility():GetSpecialValueFor("chance")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.bonus_attack_speed_max = self:GetAbility():GetSpecialValueFor("bonus_attack_speed_max")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
end

function modifier_chaotic_night_dance:OnIntervalThink()
	if self.parent:IsInNightTime() then
		self.IsInNightTime = true
		self.bonus_miss = self.miss
	else
		self.IsInNightTime = false
		self.bonus_miss = 0
	end

	local fGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].GameTime then
			self:SetStackCount(math.max(self:GetStackCount() - self.tData[i].stack, 0))
			table.remove(self.tData, i)
		end
	end
	
	self:SendBuffRefreshToClients()

end

function modifier_chaotic_night_dance:GetModifierEvasion_Constant()
	return self.bonus_miss
end
function modifier_chaotic_night_dance:GetModifierAttackSpeedBonus_Constant()	return self:GetStackCount() end
function modifier_chaotic_night_dance:Advanced_GetModifierBonusStats_Agility()	
	return self.agility
end

function modifier_chaotic_night_dance:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self.parent ~= keys.target then
		return
	end
	if self.parent == keys.attacker then
		return
	end
	if self.parent:PassivesDisabled() then
        return 
    end   
	if not self.IsInNightTime then
        return 
    end   
	if RandomFloat(1, 100) <= self.chance then
		self:SetStackCount(math.min(self:GetStackCount() + self.bonus_attack_speed,self.bonus_attack_speed_max))
		table.insert(self.tData, { 
			GameTime = GameRules:GetGameTime() + self.duration,
			stack = self.bonus_attack_speed,
		})
	end
end

function modifier_chaotic_night_dance:OnDeath(keys)

	if not IsServer() then
		return
	end

	if self.parent == keys.unit or self.parent ~= keys.attacker then
		return
	end
	if self.parent:PassivesDisabled() then
        return 
    end   	
	if not self.IsInNightTime then
        return 
    end   

	local factor = 1
	if keys.unit:IsChaoticEraElite() then
		factor = self.elite_factor
	end
	self.agility = 	math.min(self.max_bonus_agility,self.agility + self.bonus_agility * factor)

	self:SendBuffRefreshToClients()

end

function modifier_chaotic_night_dance:OnTooltip() 

	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self.bonus_miss
	end
	if self._tooltip == 2 then
		return self:GetModifierAttackSpeedBonus_Constant()
	end
	if self._tooltip == 3 then
		return self.agility
	end

end

function modifier_chaotic_night_dance:AddCustomTransmitterData( )
	return
	{
		bonus_miss = self.bonus_miss,
		agility = self.agility,
	}
end

function modifier_chaotic_night_dance:HandleCustomTransmitterData( data )
	self.bonus_miss = data.bonus_miss
	self.agility = data.agility
end











modifier_chaotic_night_dance_rune_1_buff = advanced_modifier({})

function modifier_chaotic_night_dance_rune_1_buff:IsHidden() return false end
function modifier_chaotic_night_dance_rune_1_buff:IsPurgable() return false end
function modifier_chaotic_night_dance_rune_1_buff:IsDebuff() return false end
function modifier_chaotic_night_dance_rune_1_buff:Advanced_GetForceNightState()   return 1  end

function modifier_chaotic_night_dance_rune_1_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_FORCE_NIGHT_STATE,
    }
end







