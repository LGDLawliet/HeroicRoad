LinkLuaModifier("modifier_chaotic_insight", "chaotic_spell/class_4/chaotic_insight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_insight_bonus_buff", "chaotic_spell/class_4/chaotic_insight", LUA_MODIFIER_MOTION_NONE)

chaotic_insight = chaotic_insight or class({})

function chaotic_insight:Spawn()
	local caster = self:GetCaster()
	caster:GameTimer(0.03,function ()
		caster:AddNewModifier(caster, self, "modifier_chaotic_insight", {})
	end)

end

function chaotic_insight:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_insight/eff_all.vpcf", context )
end

modifier_chaotic_insight = advanced_modifier({})
function modifier_chaotic_insight:IsDebuff() 		return false end
function modifier_chaotic_insight:IsPurgable() 		return false end
function modifier_chaotic_insight:IsPurgeException() 	return false end
function modifier_chaotic_insight:IsHidden() return false end
function modifier_chaotic_insight:RemoveOnDeath()  return false end

function modifier_chaotic_insight:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.time_require = self.ability:GetSpecialValueFor("time_require")
	self.all_attribute_reduction = self.ability:GetSpecialValueFor("all_attribute_reduction") * 0.01
	self.incoming = self.ability:GetSpecialValueFor("incoming")
	self.type = self.ability:GetRuneType()

	if self.type == 2 then
		self.incoming = self.incoming + self.ability:GetSpecialValueFor("rune_2_incoming")
		self.time_require = self.time_require * (1- self.ability:GetSpecialValueFor("rune_2_time_down") * 0.01)
	end

	if not IsServer() then
		return
	end
	self:StartIntervalThink(0.1)
	self.strength_reduction = self.parent:GetStrength() * self.all_attribute_reduction
	self.agility_reduction = self.parent:GetAgility() * self.all_attribute_reduction
	self.intellect_reduction = self.parent:GetIntellect(false) * self.all_attribute_reduction
	
	self.parent:GameTimer(0.03,function ()
		self:SetDuration(self.time_require, true)
	end)
	self:SetHasCustomTransmitterData( true )
end
function modifier_chaotic_insight:OnIntervalThink()
	if not self:GetAbility() then self:Destroy() end
	if not self.parent:IsAlive() then
		self:SetDuration(self.time_require, true)
	end
end
function modifier_chaotic_insight:OnDestroy()
	if not IsServer() then return end
	if not self:GetAbility() or not self.parent:IsAlive() then return end
	if self:GetRemainingTime() > 0 then return end

	local parent = self:GetParent()
	local ability =self:GetAbility()
	
	parent:AddNewModifier(parent,ability, "modifier_chaotic_insight_bonus_buff", {})
	chaotic_era:InSertDisableAbility(parent:GetPlayerOwnerID(),ability:GetAbilityName())
	-- self:PlayEffect(parent)
	parent:RemoveAbility("chaotic_insight")
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_insight/eff_all.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControl(effect_cast,0,parent:GetOrigin() )
	ParticleManager:SetParticleControl(effect_cast,1,parent:GetOrigin() )
	ParticleManager:SetParticleControlEnt(effect_cast,3,parent,PATTACH_POINT_FOLLOW,nil,parent:GetAbsOrigin(),true)
	ParticleManager:SetParticleControlForward(effect_cast, 3, parent:GetForwardVector())
	DestroyParticleByDelay(effect_cast,1.5)
	parent:EmitSound("CNY_Beast.HandOfGodHealHero")

	if self.type == 1 then
		self.parent:HeroLevelUp(true)
	end
	local artifact = self.parent:FindModifierByName("modifier_item_hd_future_stone_effects")
	if artifact and artifact.level and artifact.level >= 100 then
		local newbuff = parent:AddNewModifier(parent,ability, "modifier_item_hd_future_stone_effects_lv100", {})
		newbuff:SetStackCount(artifact.bonus_10)
	end
end

function modifier_chaotic_insight:CheckRune1()
	if self:GetAbility():GetRuneType()==1 then
		local time = self:GetAbility():GetSpecialValueFor("rune_1_time")
		self:SetDuration(self:GetRemainingTime()*(1-time*0.01), true)
	end
end

function modifier_chaotic_insight:AddCustomTransmitterData( )
	return
	{
		strength_reduction = self.strength_reduction,
		agility_reduction = self.agility_reduction,
		intellect_reduction = self.intellect_reduction,
	}
end

function modifier_chaotic_insight:HandleCustomTransmitterData( data )
	self.strength_reduction = data.strength_reduction
	self.agility_reduction = data.agility_reduction
	self.intellect_reduction = data.intellect_reduction
end

function modifier_chaotic_insight:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_EVENT_ON_DEATH = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_chaotic_insight:Advanced_GetModifierBonusStats_Strength()	
	return -self.strength_reduction
end
function modifier_chaotic_insight:Advanced_GetModifierBonusStats_Agility()	
	return -self.agility_reduction
end
function modifier_chaotic_insight:Advanced_GetModifierBonusStats_Intellect()	
	return -self.intellect_reduction
end
function modifier_chaotic_insight:Advanced_GetModifierIncomingDamage_Percentage()	
	return self.incoming
end
function modifier_chaotic_insight:OnDeath(keys)
	if not IsServer() then return end
	local unit = keys.unit
	if unit ~= self.parent then return end
	self:SetDuration(self.time_require, true)
end
function modifier_chaotic_insight:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_insight:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 3 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierBonusStats_Agility()
    end
	if self._tooltip == 3 then
        return self:Advanced_GetModifierBonusStats_Intellect()
    end
end

modifier_chaotic_insight_bonus_buff = advanced_modifier({})

function modifier_chaotic_insight_bonus_buff:IsPurgable() 		return false end
function modifier_chaotic_insight_bonus_buff:IsPurgeException() 	return false end
function modifier_chaotic_insight_bonus_buff:IsHidden() return false end
function modifier_chaotic_insight_bonus_buff:RemoveOnDeath()  return false end
function modifier_chaotic_insight_bonus_buff:GetTexture() return "chaotic_era_spell/chaotic_insight" end

function modifier_chaotic_insight_bonus_buff:OnCreated()

	self.parent = self:GetParent()
	local ability = self:GetAbility()
	self.bonus_spell_count = ability:GetSpecialValueFor("bonus_spell_count")
	self.all_attribute_bonus = ability:GetSpecialValueFor("all_attribute_bonus")
end


function modifier_chaotic_insight_bonus_buff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount,
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end

function modifier_chaotic_insight_bonus_buff:Advanced_GetChaotic_Era_Spell_GenerateCount()
	local count = self.bonus_spell_count
	return count
end

function modifier_chaotic_insight_bonus_buff:Advanced_GetModifierBonusStats_Strength()	
	return self.all_attribute_bonus
end
function modifier_chaotic_insight_bonus_buff:Advanced_GetModifierBonusStats_Agility()	
	return self.all_attribute_bonus
end
function modifier_chaotic_insight_bonus_buff:Advanced_GetModifierBonusStats_Intellect()	
	return self.all_attribute_bonus
end

function modifier_chaotic_insight_bonus_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,  
	}
end

function modifier_chaotic_insight_bonus_buff:OnTooltip() 
    self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
        return self:Advanced_GetChaotic_Era_Spell_GenerateCount()
    end
    if self._tooltip == 2 then
        return self:Advanced_GetModifierBonusStats_Strength()
    end
    if self._tooltip == 3 then
        return self:Advanced_GetModifierBonusStats_Agility()
    end
	if self._tooltip == 4 then
        return self:Advanced_GetModifierBonusStats_Intellect()
    end
end