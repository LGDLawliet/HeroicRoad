
chaotic_communication_among_living_beings = class({})


LinkLuaModifier("modifier_chaotic_communication_among_living_beings", "chaotic_spell/class_3/chaotic_communication_among_living_beings", LUA_MODIFIER_MOTION_NONE)


function chaotic_communication_among_living_beings:GetIntrinsicModifierName() return "modifier_chaotic_communication_among_living_beings" end
-- function chaotic_communication_among_living_beings:Precache( context )
-- 	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_communication_among_living_beings/effect3.vpcf", context )
-- end


modifier_chaotic_communication_among_living_beings = advanced_modifier({})

function modifier_chaotic_communication_among_living_beings:IsDebuff()			return false end
function modifier_chaotic_communication_among_living_beings:IsHidden() 			return true end
function modifier_chaotic_communication_among_living_beings:IsPurgable() 		return false end
function modifier_chaotic_communication_among_living_beings:IsPurgeException() 	return false end
function modifier_chaotic_communication_among_living_beings:RemoveOnDeath() return false end
function modifier_chaotic_communication_among_living_beings:DestroyOnExpire() return false end
function modifier_chaotic_communication_among_living_beings:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")*0.01
end

function modifier_chaotic_communication_among_living_beings:OnRefresh()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.health_regen = self.ability:GetSpecialValueFor("health_regen")*0.01
end

function modifier_chaotic_communication_among_living_beings:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		
    }
	if self:GetAbility():GetRuneType()==1 then
		-- self.rune_active 
		self.rune_1_bonus = self:GetAbility():GetSpecialValueFor("rune_1_bonus")
		table.insert(funcs,advanced_MODIFIER_PROPERTY_Summon_Intensity)
		funcs["MODIFIER_EVENT_ON_SUMMON"] = {self:GetCaster(), nil}
	end
    return funcs
    
end

function modifier_chaotic_communication_among_living_beings:Advanced_GetModifierAttackSpeedPercentage()
	if self.parent:PassivesDisabled() then
		return 0
	end	
    return self.bonus_attack_speed
end

function modifier_chaotic_communication_among_living_beings:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if self.parent:PassivesDisabled() then
		return
	end	
	local units = FindUnitsInRadius( self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.radius, 
										DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST,false 
	)
	local bonus_life_steal =  self.parent:GetAverageTrueAttackDamage(nil) * self.health_regen*self:GetAbility():GetEffectGain()
	for _, unit in pairs(units) do
		if unit:IsHDSummoned() and unit:GetPlayerOwnerID() == self.parent:GetPlayerOwnerID() then
			local fhealing =  HealWithGain(bonus_life_steal,self.parent,unit,nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,unit, fhealing, nil)
			-- local effect_healing = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_communication_among_living_beings/effect3.vpcf", PATTACH_CUSTOMORIGIN, nil )
			-- ParticleManager:SetParticleControl(effect_healing,0,unit:GetOrigin())
			-- DestroyParticleByDelay(effect_healing,1)
			-- local sound_cast = "Hero_ElderTitan.AncestralSpirit.Buff"
			-- EmitSoundOnLocationWithCaster(unit:GetOrigin(),sound_cast, self.parent)
		end
	end
end

function modifier_chaotic_communication_among_living_beings:Advanced_GetModifier_Summon_Intensity(keys)
	-- print("self.rune_active=",self.rune_active)
	-- print("keys.unit=",keys.target)
	if IsValid(self.rune_active) and self.rune_active== keys.target then
		-- print("?")
		return self.rune_1_bonus
	end
	return 0
end




function modifier_chaotic_communication_among_living_beings:AdvancedOnSummon(keys)
	if IsServer() then
		local unit = keys.target
		if not IsValid(self.rune_active ) and not unit:IsRealHero() then
			self:GetAbility():SetActivated(false)
			self:StartIntervalThink(0.5)
			self.rune_active = unit
		end


	end
end


function modifier_chaotic_communication_among_living_beings:OnIntervalThink()
	if not IsValid(self.rune_active) then
		self:GetAbility():SetActivated(true)
		self:StartIntervalThink(-1)
	end
end