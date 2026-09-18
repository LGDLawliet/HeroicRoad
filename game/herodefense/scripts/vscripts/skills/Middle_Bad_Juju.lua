Middle_Bad_Juju = class({})

LinkLuaModifier("modifier_Middle_Bad_Juju_passive", "skills/Middle_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Bad_Juju_attack_reduction", "skills/Middle_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Middle_Bad_Juju_attack_reduction2", "skills/Middle_Bad_Juju", LUA_MODIFIER_MOTION_NONE)


function Middle_Bad_Juju:GetIntrinsicModifierName() return "modifier_Middle_Bad_Juju_passive" end
function Middle_Bad_Juju:GetAOERadius()
	return self:GetSpecialValueFor("radius") 
end




modifier_Middle_Bad_Juju_passive = advanced_modifier({})

function modifier_Middle_Bad_Juju_passive:IsDebuff()			return false end
function modifier_Middle_Bad_Juju_passive:IsHidden() 			return true end
function modifier_Middle_Bad_Juju_passive:IsPurgable() 		return false end
function modifier_Middle_Bad_Juju_passive:IsPurgeException() 	return false end
function modifier_Middle_Bad_Juju_passive:RemoveOnDeath()  return false end
function modifier_Middle_Bad_Juju_passive:AllowIllusionDuplicate() return false end
function modifier_Middle_Bad_Juju_passive:DeclareFunctions() return {
    -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, 
    MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
} end
-- function modifier_Middle_Bad_Juju_passive:GetModifierPercentageCooldown() return (self:GetAbility():GetSpecialValueFor("cooldown_reduction")) end
--减少冷却

function modifier_Middle_Bad_Juju_passive:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_Middle_Bad_Juju_passive:Advanced_GetModifierCooldownReduction(keys)
    return self:GetAbility():GetSpecialValueFor("cooldown_reduction")
end



function modifier_Middle_Bad_Juju_passive:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() or keys.ability:GetCooldown(self:GetAbility():GetLevel()) <= 5 then
		return
    end
    local caster = self:GetParent()
    local units1 = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    local num = self:GetAbility():GetSpecialValueFor("effect_number")
    local sum = 0
    local attack_red = self:GetAbility():GetSpecialValueFor("attack_reduction_index") * caster:GetIntellect(false)
    for _, units in pairs(units1) do
        local ModifierStatusNegativeGain = 100+caster:GetModifierStatusNegativeGainIndex(0.25)
        local StatusResistance =  units:GetHDStatusResistanceIndex(0.25)*ModifierStatusNegativeGain
        local modifier = units:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Bad_Juju_attack_reduction", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
        if modifier and not modifier:IsNull()  then
            modifier:SetStackCount(attack_red)
        end
        local pfx = ParticleManager:CreateParticle("particles/new_effect/coup_de_grace/new_bad_juju.vpcf", PATTACH_CUSTOMORIGIN, units)
        ParticleManager:SetParticleControlEnt(pfx, 0, units, PATTACH_POINT_FOLLOW, "attach_hitloc", units:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(pfx)
        sum = sum + 1
        if sum >= num then
            break
        end
	end 
    local units1 = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _, units in pairs(units1) do
        local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.25)
        local StatusResistance =  units:GetHDStatusResistanceIndex(0.25)*ModifierStatusNegativeGain
        local modifier = units:AddNewModifier(caster, self:GetAbility(), "modifier_Middle_Bad_Juju_attack_reduction", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
        if modifier and not modifier:IsNull() then
            modifier:SetStackCount(attack_red)
        end

        sum = sum + 1
        if sum >= num then
            break
        end
    end 
end


modifier_Middle_Bad_Juju_attack_reduction = class({})
function modifier_Middle_Bad_Juju_attack_reduction:IsDebuff()			   return true end
function modifier_Middle_Bad_Juju_attack_reduction:IsHidden() 			return true end
function modifier_Middle_Bad_Juju_attack_reduction:IsPurgable() 			return true end
function modifier_Middle_Bad_Juju_attack_reduction:IsPurgeException() 	return true end
function modifier_Middle_Bad_Juju_attack_reduction:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_Middle_Bad_Juju_attack_reduction:DeclareFunctions()
	return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,}
end
function modifier_Middle_Bad_Juju_attack_reduction:GetModifierBaseAttack_BonusDamage() return (0 - self:GetStackCount()) end
function modifier_Middle_Bad_Juju_attack_reduction:OnCreated()
    if not IsServer() then
        return        
    end
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Middle_Bad_Juju_attack_reduction2", {duration =999})
end


modifier_Middle_Bad_Juju_attack_reduction2 = class({})
function modifier_Middle_Bad_Juju_attack_reduction2:IsDebuff()			return true end
function modifier_Middle_Bad_Juju_attack_reduction2:IsHidden() 			return false end
function modifier_Middle_Bad_Juju_attack_reduction2:IsPurgable() 			return false end
function modifier_Middle_Bad_Juju_attack_reduction2:IsPurgeException() 	return false end

function modifier_Middle_Bad_Juju_attack_reduction2:OnCreated()
    if IsServer() then
		self:StartIntervalThink(0.3)
	end
end
function modifier_Middle_Bad_Juju_attack_reduction2:OnIntervalThink()
    local buffs = self:GetParent():FindAllModifiersByName("modifier_Middle_Bad_Juju_attack_reduction")
    local stack = 0
    for _, buff in pairs(buffs) do
        stack = stack + buff:GetStackCount()
    end 
	self:SetStackCount(stack)
	if self:GetStackCount() == 0 then
        self:SafeDestroy()
    end
    
end
