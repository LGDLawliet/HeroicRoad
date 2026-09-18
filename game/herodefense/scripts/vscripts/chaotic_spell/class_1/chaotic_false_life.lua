
chaotic_false_life = class({})
LinkLuaModifier("modifier_chaotic_false_life", "chaotic_spell/class_1/chaotic_false_life", LUA_MODIFIER_MOTION_NONE)



function chaotic_false_life:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_false_life/effect_cast/effect.vpcf", context )


end

function chaotic_false_life:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function chaotic_false_life:GetManaCost(iLevel)
	local cost = self.BaseClass.GetManaCost(self,iLevel)
	cost = cost * self:GetManaCostGain()
	return cost
end



function chaotic_false_life:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	-- local target = self:GetCursorTarget() 


	caster:EmitSound("chaotic_false_life_cast")  

	-- local count = self:GetSpecialValueFor("count")-1
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	
	self:ApplyModifier(caster, duration)





	
end

function chaotic_false_life:ApplyModifier(target, duration)
	local caster = self:GetCaster()
	-- local gain = caster:GetModifierDurationGainIndex(1)
	-- local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	-- local StatusResistance = target:GetHDStatusResistanceIndex()*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_chaotic_false_life", {duration = duration})
	local pos = target:GetAbsOrigin()
	local effect_cast1 = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_false_life/effect_cast/effect.vpcf", PATTACH_CUSTOMORIGIN, target )
	-- ParticleManager:SetParticleControl( effect_cast1, 0, pos )
	ParticleManager:SetParticleControlEnt(effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl( effect_cast1, 2, pos )
	-- ParticleManager:SetParticleControl( effect_cast1, 3, pos )
	DestroyParticleByDelay(effect_cast1,3)

end




modifier_chaotic_false_life = modifier_chaotic_false_life or advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_false_life:IsHidden()	return false end
function modifier_chaotic_false_life:IsDebuff()	return false end
function modifier_chaotic_false_life:IsStunDebuff()	return false end
function modifier_chaotic_false_life:IsPurgable()	return true end

--------------------------------------------------------------------------------
-- Initializations
function modifier_chaotic_false_life:OnCreated( kv )
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_health") +self:GetAbility():GetSpecialValueFor("bonus_health_index") * self:GetCaster():HDGetPrimaryStatValue() 
		self.runeType = self:GetAbility():GetRuneType()
		if self.runeType==1 then
			self.rune1_gain = self:GetAbility():GetSpecialValueFor("rune_1_gain")
			bonus = bonus * self.rune1_gain
		end
		self:SetStackCount(bonus*self:GetAbility():GetEffectGain() )

		
	end

end
function modifier_chaotic_false_life:OnRefresh( kv )
	if IsServer() then
		local bonus = self:GetAbility():GetSpecialValueFor("bonus_health") +self:GetAbility():GetSpecialValueFor("bonus_health_index") * self:GetCaster():HDGetPrimaryStatValue() 
		self.runeType = self:GetAbility():GetRuneType()
		if self.runeType==1 then
			self.rune1_gain = self:GetAbility():GetSpecialValueFor("rune_1_gain")
			bonus = bonus * self.rune1_gain
		end
		self:SetStackCount(bonus*self:GetAbility():GetEffectGain() )

	end

end




function modifier_chaotic_false_life:ADDeclareFunctions()
    return 
    {

		-- 临时生命值需要组合使用
		MODIFIER_SPECIAL_Temporary_Health_Points = {nil, self:GetParent()},
		advanced_MODIFIER_PROPERTY_TEMPORARY_HEALTH,


    }
end


function modifier_chaotic_false_life:AdvancedGetModifierTemporaryHealth(keys)
	local stack = self:GetStackCount()
	-- 作为临时生命值加成效果时直接返回
	if keys.temporaryHealthLogic then
		return stack
	end
	if IsClient() then
		return 0
	end
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
	if self.rune1_gain then
		keys.damage = keys.damage *self.rune1_gain
	end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        self:SetStackCount(self:GetStackCount() - math.max(0, keys.damage))
        stack = keys.damage
    end
    return stack

end

