
chaotic_bless = class({})
LinkLuaModifier("modifier_chaotic_bless", "chaotic_spell/class_1/chaotic_bless", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_bless_rune_3", "chaotic_spell/class_1/chaotic_bless", LUA_MODIFIER_MOTION_NONE)

function chaotic_bless:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_beacon_of_hope/cast_effect/effect_target.vpcf", context )

end

function chaotic_bless:GetIntrinsicModifierName()
	return "modifier_chaotic_bless_rune_3"
end

function chaotic_bless:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_bless:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_bless:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 


	-- caster:EmitSound("chaotic_bless_cast")  

	local count = self:GetSpecialValueFor("count")-1
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	
	self:ApplyModifier(target, duration)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if not unit:HasModifier("modifier_chaotic_bless") then
			count = count - 1
			self:ApplyModifier(unit, duration)
			if count<=0 then
				break
			end
		end
	end



	
end

function chaotic_bless:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_bless", {duration = duration})
	target:EmitSound("chaotic_bless_cast") 
	local pos = target:GetAbsOrigin()
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_beacon_of_hope/cast_effect/effect_target.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,5)

end




modifier_chaotic_bless = modifier_chaotic_bless or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_bless:IsHidden()	return false end
function modifier_chaotic_bless:IsDebuff()	return false end
function modifier_chaotic_bless:IsStunDebuff()	return false end
function modifier_chaotic_bless:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_bless:OnCreated( kv )
	
	local gain = self:GetAbility():GetEffectGain()

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*gain
	self.bonus_healing = self:GetAbility():GetSpecialValueFor("bonus_healing")*gain
	if self:GetAbility():GetRuneType()==2 then
		self.bonus_atb = self:GetAbility():GetSpecialValueFor("rune_2_bonus_atb")
	else
		self.bonus_atb = 0
	end
	if IsServer() then
		self.deelayTime = 0.1
		if self:GetAbility():GetRuneType()==1 then
			self.deelayTime = self:GetAbility():GetSpecialValueFor("rune_1_delay")
		end
	end

end

function modifier_chaotic_bless:OnRefresh( kv )
	
	local gain = self:GetAbility():GetEffectGain()

	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")*gain
	self.bonus_healing = self:GetAbility():GetSpecialValueFor("bonus_healing")*gain
	if self:GetAbility():GetRuneType()==2 then
		self.bonus_atb = self:GetAbility():GetSpecialValueFor("rune_2_bonus_atb")
	else
		self.bonus_atb = 0
	end
	if IsServer() then
		self.deelayTime = 0.1
		if self:GetAbility():GetRuneType()==1 then
			self.deelayTime = self:GetAbility():GetSpecialValueFor("rune_1_delay")
		end
	end
end




function modifier_chaotic_bless:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		advanced_MODIFIER_PROPERTY_HEAL_AMP_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_bless:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if IsServer() then
		if not self.deelay then
			self.deelay = true
			self:GetParent():GameTimer(self.deelayTime, function()
				if IsValid(self) then
					self:Destroy()
				end
			end)
		end
	end
	return self.bonus_damage
end

function modifier_chaotic_bless:Advanced_GetModifierHealAMP_Percentage(keys)
	if IsServer() then
		if not self.deelay then
			self.deelay = true
			self:GetParent():GameTimer(self.deelayTime, function()
				if IsValid(self) then
					self:Destroy()
				end
			end)
		end
	end
	return self.bonus_healing
end

function modifier_chaotic_bless:Advanced_GetModifierBonusStats_Strength()

	return self.bonus_atb
end
function modifier_chaotic_bless:Advanced_GetModifierBonusStats_Agility()

	return self.bonus_atb
end
function modifier_chaotic_bless:Advanced_GetModifierBonusStats_Intellect()

	return self.bonus_atb
end



modifier_chaotic_bless_rune_3 = modifier_chaotic_bless_rune_3 or advanced_modifier({})

function modifier_chaotic_bless_rune_3:IsHidden()	return true end
function modifier_chaotic_bless_rune_3:IsDebuff()	return false end
function modifier_chaotic_bless_rune_3:IsPurgable()	return false end
function modifier_chaotic_bless_rune_3:OnCreated()
	if IsServer() and self:GetAbility():GetRuneType()==3 then
		self.interval = self:GetAbility():GetSpecialValueFor("rune_3_interval")
		self:StartIntervalThink(self.interval)
	end
end

function modifier_chaotic_bless_rune_3:OnIntervalThink()
	local caster = self:GetCaster()
	local target = caster 


	-- caster:EmitSound("chaotic_bless_cast")  

	local count = self:GetAbility():GetSpecialValueFor("count")-1
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetAbility():GetSpecialValueFor("duration")*gain
	
	self:GetAbility():ApplyModifier(target, duration)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetAOERadius(), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _, unit in ipairs(units) do
		if not unit:HasModifier("modifier_chaotic_bless") then
			count = count - 1
			self:GetAbility():ApplyModifier(unit, duration)
			if count<=0 then
				break
			end
		end
	end
end