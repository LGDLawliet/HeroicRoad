LinkLuaModifier("modifier_chaotic_aid_from_the_future_per", "chaotic_spell/class_5/chaotic_aid_from_the_future", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_aid_from_the_future", "chaotic_spell/class_5/chaotic_aid_from_the_future", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_aid_from_the_future_debuff", "chaotic_spell/class_5/chaotic_aid_from_the_future", LUA_MODIFIER_MOTION_NONE)


chaotic_aid_from_the_future = class({})
function chaotic_aid_from_the_future:Precache( context )
	-- PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_aid_from_the_future/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_strike_end.vpcf", context )
end

function chaotic_aid_from_the_future:CastFilterResult()
	if self:GetCaster():HasModifier("modifier_chaotic_aid_from_the_future") or self:GetCaster():HasModifier("modifier_chaotic_aid_from_the_future_debuff") then
		self.error = "HUD_chaotic_aid_from_the_future_error"
		return UF_FAIL_CUSTOM
	end

	local result = self.BaseClass.CastFilterResult(self)
	return result or UF_SUCCESS
end

function chaotic_aid_from_the_future:GetCustomCastError()
	return self.error
end


function chaotic_aid_from_the_future:OnSpellStart()
	local caster = self:GetCaster()
	self:PlayEffect(caster)

end


function chaotic_aid_from_the_future:PlayEffect(target)
	local effect_cast1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin_persona/pa_persona_phantom_strike_end.vpcf", PATTACH_CUSTOMORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast1, 0, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex(effect_cast1)
	target:EmitSound("chaotic_aid_from_the_future_cast")

	target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_aid_from_the_future_per", {duration =0.03}) --用于加属性然后获取
	target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_aid_from_the_future", {duration =self:GetSpecialValueFor("duration")}) --用于加属性然后获取

end


modifier_chaotic_aid_from_the_future_per = advanced_modifier({})

function modifier_chaotic_aid_from_the_future_per:IsHidden()	return true end
function modifier_chaotic_aid_from_the_future_per:IsDebuff()	return false end
function modifier_chaotic_aid_from_the_future_per:IsPurgable()	return false end
function modifier_chaotic_aid_from_the_future_per:OnCreated(keys)
	local gain = self:GetAbility():GetEffectGain()
	self.level_step = math.floor(self:GetAbility():GetSpecialValueFor("level_step"))*gain
end


function modifier_chaotic_aid_from_the_future_per:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_BONUS_ATTRIBUTE_LEVEL,
    }
end

function modifier_chaotic_aid_from_the_future_per:Advanced_GetModifierBonusAttributeLevel()
    return self.level_step
end




modifier_chaotic_aid_from_the_future = advanced_modifier({})

function modifier_chaotic_aid_from_the_future:IsHidden() return false end
function modifier_chaotic_aid_from_the_future:IsPurgable() return false end
function modifier_chaotic_aid_from_the_future:IsDebuff() return false end
function modifier_chaotic_aid_from_the_future:IsPurgeException() return false end
function modifier_chaotic_aid_from_the_future:RemoveOnDeath() return false end
function modifier_chaotic_aid_from_the_future:OnCreated(keys)
	if IsServer() then
		local bonus_attribute = self:GetAbility():GetSpecialValueFor("bonus_attribute")*0.01
		local bonus_primary_attribute = self:GetAbility():GetSpecialValueFor("bonus_primary_attribute")*0.01


		local parent = self:GetParent()
		local mainAttribute = parent:GetPrimaryAttribute()
		if mainAttribute==DOTA_ATTRIBUTE_ALL  then
			self.bonus_str = parent:GetStrength() * (bonus_attribute+bonus_primary_attribute)/2
			self.bonus_agi = parent:GetAgility() * (bonus_attribute+bonus_primary_attribute)/2
			self.bonus_int = parent:GetIntellect(false) * (bonus_attribute+bonus_primary_attribute)/2
			
		end

		if mainAttribute==DOTA_ATTRIBUTE_STRENGTH  then
			self.bonus_str = parent:GetStrength() * bonus_primary_attribute
			self.bonus_agi = parent:GetAgility() * bonus_attribute
			self.bonus_int = parent:GetIntellect(false) * bonus_attribute
			
		end
		if mainAttribute==DOTA_ATTRIBUTE_AGILITY   then
			self.bonus_str = parent:GetStrength() * bonus_attribute
			self.bonus_agi = parent:GetAgility() * bonus_attribute
			self.bonus_int = parent:GetIntellect(false) * bonus_primary_attribute
			
		end
		if mainAttribute==DOTA_ATTRIBUTE_INTELLECT   then
			self.bonus_str = parent:GetStrength() * bonus_attribute
			self.bonus_agi = parent:GetAgility() * bonus_attribute
			self.bonus_int = parent:GetIntellect(false) * bonus_primary_attribute
			
		end

		self:SetHasCustomTransmitterData( true )
	end
end
function modifier_chaotic_aid_from_the_future:OnDestroy()
	if IsServer() then
		local ability = self:GetAbility()
		if ability then
			local debuff_duration = ability:GetSpecialValueFor("debuff_duration")
			local attribute_reduce_rate = ability:GetSpecialValueFor("attribute_reduce_rate")*0.01
			local parent = self:GetParent()
			if ability:GetRuneType()==1 then
				debuff_duration = debuff_duration * parent:GetHDStatusResistanceIndex()
			end
			parent:AddNewModifier(parent, ability, "modifier_chaotic_aid_from_the_future_debuff", {
				duration=debuff_duration,
				bonus_str = self.bonus_str * attribute_reduce_rate,
				bonus_agi = self.bonus_agi * attribute_reduce_rate,
				bonus_int = self.bonus_int * attribute_reduce_rate,
			}) --用于加属性然后获取
		end
	end
end
function modifier_chaotic_aid_from_the_future:AddCustomTransmitterData( )
	return
	{
		bonus_str = self.bonus_str,
		bonus_agi = self.bonus_agi,
		bonus_int = self.bonus_int,
	}
end

function modifier_chaotic_aid_from_the_future:HandleCustomTransmitterData( data )
	self.bonus_str = data.bonus_str
	self.bonus_agi = data.bonus_agi
	self.bonus_int = data.bonus_int
end

function modifier_chaotic_aid_from_the_future:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_chaotic_aid_from_the_future:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierBonusStats_Agility()
	elseif self._tooltip == 3 then
		return self:Advanced_GetModifierBonusStats_Intellect()
	end
end


function modifier_chaotic_aid_from_the_future:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_aid_from_the_future:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus_str 
end
function modifier_chaotic_aid_from_the_future:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus_agi 
end

function modifier_chaotic_aid_from_the_future:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_int 
end









modifier_chaotic_aid_from_the_future_debuff = advanced_modifier({})

function modifier_chaotic_aid_from_the_future_debuff:IsHidden() return false end
function modifier_chaotic_aid_from_the_future_debuff:IsPurgable() return false end
function modifier_chaotic_aid_from_the_future_debuff:IsDebuff() return true end
function modifier_chaotic_aid_from_the_future_debuff:IsPurgeException() return false end
function modifier_chaotic_aid_from_the_future_debuff:RemoveOnDeath() return false end
function modifier_chaotic_aid_from_the_future_debuff:OnCreated(keys)
	if IsServer() then
		self.bonus_str = -keys.bonus_str
		self.bonus_agi = -keys.bonus_agi
		self.bonus_int = -keys.bonus_int

		self:SetHasCustomTransmitterData( true )
	end
end

function modifier_chaotic_aid_from_the_future_debuff:AddCustomTransmitterData( )
	return
	{
		bonus_str = self.bonus_str,
		bonus_agi = self.bonus_agi,
		bonus_int = self.bonus_int,
	}
end

function modifier_chaotic_aid_from_the_future_debuff:HandleCustomTransmitterData( data )
	self.bonus_str = data.bonus_str
	self.bonus_agi = data.bonus_agi
	self.bonus_int = data.bonus_int
end

function modifier_chaotic_aid_from_the_future_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end


function modifier_chaotic_aid_from_the_future_debuff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Strength()
	elseif self._tooltip == 2 then
		return self:Advanced_GetModifierBonusStats_Agility()
	elseif self._tooltip == 3 then
		return self:Advanced_GetModifierBonusStats_Intellect()
	end
end


function modifier_chaotic_aid_from_the_future_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_chaotic_aid_from_the_future_debuff:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus_str 
end
function modifier_chaotic_aid_from_the_future_debuff:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus_agi 
end

function modifier_chaotic_aid_from_the_future_debuff:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus_int 
end


-- "level_step"      "10"
-- "bonus_attribute" "20"
-- "bonus_primary_attribute" "35"

-- "attribute_reduce_rate"  "65"

-- "duration"  "60"
-- "debuff_duration"  "30"

