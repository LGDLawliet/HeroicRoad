
chaotic_heroism = class({})
LinkLuaModifier("modifier_chaotic_heroism", "chaotic_spell/class_1/chaotic_heroism", LUA_MODIFIER_MOTION_NONE)



function chaotic_heroism:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_heroism/cast_effect/effect_target.vpcf", context )


end


function chaotic_heroism:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_heroism:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local target = self:GetCursorTarget() 
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	self:ApplyModifier(target, duration)

end

function chaotic_heroism:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_heroism", {duration = duration})
	target:EmitSound("chaotic_heroism_target") 
	local pos = target:GetAbsOrigin()
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_heroism/cast_effect/effect_target.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,4)

end




modifier_chaotic_heroism = modifier_chaotic_heroism or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_heroism:IsHidden()	return false end
function modifier_chaotic_heroism:IsDebuff()	return false end
function modifier_chaotic_heroism:IsStunDebuff()	return false end
function modifier_chaotic_heroism:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_heroism:OnCreated( kv )

	local gain = self:GetAbility():GetEffectGain()
	self.bonus = math.min(self:GetAbility():GetSpecialValueFor( "bonus_status_resistance" )*gain,80)


	local type = self:GetAbility():GetRuneType()
	if type==1 then
		self.rune_1_bonus_require = self:GetAbility():GetSpecialValueFor("rune_1_bonus_require")
		self.rune_1_bonus_attribute = self:GetAbility():GetSpecialValueFor("rune_1_bonus_attribute")
	end
	if IsServer() then
		self.max_bonus_health = self:GetAbility():GetSpecialValueFor("max_bonus_health")*gain
		self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")*gain
		self:SetStackCount(self.bonus_health)

		self:StartIntervalThink(self:GetAbility():GetSpecialValueFor("interval"))
	end

end
function modifier_chaotic_heroism:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_chaotic_heroism:OnIntervalThink()
	local type = self:GetAbility():GetRuneType()
	local ability = self:GetAbility()

	if type==2 then
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("rune_2_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			self:SetStackCount(math.min(self:GetStackCount()+2*self.bonus_health,self.max_bonus_health))
		else
			self:SetStackCount(math.min(self:GetStackCount()+self.bonus_health,self.max_bonus_health))
		end
		return
	end
	if type==3 then
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("rune_3_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if #enemies > 0 then
			self:SetStackCount(math.min(self:GetStackCount()+self.bonus_health,self.max_bonus_health))
		else
			local healing = self.bonus_health * ability:GetSpecialValueFor("rune_3_tsf")*0.01
			local fhealing =  HealWithGain(healing,self:GetParent(),self:GetParent(),ability) --返回治疗的数值
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL,self:GetParent(), fhealing, nil) 
		end
		return
	end

	self:SetStackCount(math.min(self:GetStackCount()+self.bonus_health,self.max_bonus_health))
end

function modifier_chaotic_heroism:ADDeclareFunctions()
	local funcs = {
		-- 临时生命值需要组合使用
		MODIFIER_SPECIAL_Temporary_Health_Points = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,
		advanced_MODIFIER_PROPERTY_StatusResistance
	}
	if self:GetAbility():GetRuneType()==1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS)
	end
    return funcs
end


function modifier_chaotic_heroism:AdvancedGetModifierTemporaryHealth(keys)
	local stack = self:GetStackCount()
	-- 作为临时生命值加成效果时直接返回
	if keys.temporaryHealthLogic then
		return stack
	end
	if IsClient() then
		return 0
	end
    if stack <= 0 then
        -- self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
    end
    return stack

end

function modifier_chaotic_heroism:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus
end


function modifier_chaotic_heroism:Advanced_GetModifierBonusStats_Strength(keys)
	if self.rune_1_bonus_require and self:GetStackCount()>=self.rune_1_bonus_require then
		return self.rune_1_bonus_attribute
	end
	return 0
end

function modifier_chaotic_heroism:Advanced_GetModifierBonusStats_Agility(keys)
	if self.rune_1_bonus_require and self:GetStackCount()>=self.rune_1_bonus_require then
		return self.rune_1_bonus_attribute
	end
	return 0
end



function modifier_chaotic_heroism:Advanced_GetModifierBonusStats_Intellect(keys)
	if self.rune_1_bonus_require and self:GetStackCount()>=self.rune_1_bonus_require then
		return self.rune_1_bonus_attribute
	end
	return 0
end

