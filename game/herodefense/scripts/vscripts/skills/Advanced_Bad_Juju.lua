--特效优化 √
Advanced_Bad_Juju = class({})
require("internal/timers")
LinkLuaModifier("modifier_Advanced_Bad_Juju_passive", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bad_Juju_attack_reduction", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bad_Juju_armor_reduction", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bad_Juju_attack_reduction2", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bad_Juju_armor_reduction2", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Bad_Juju_passive2", "skills/Advanced_Bad_Juju", LUA_MODIFIER_MOTION_NONE)
function Advanced_Bad_Juju:CheckKV(key)
	local table = {
		cooldown_reduction = 0.4,




	}
	local value = table[key] or -1
	return value

end
function Advanced_Bad_Juju:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock1",{})
	return true
end
function Advanced_Bad_Juju:UnlockSecondCore(key)	
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_aphotic_shield_unlock2_aura",{})
	return true
end
function Advanced_Bad_Juju:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Untouchable_unlock3",{})
	return true
end



function Advanced_Bad_Juju:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_dazzle/dazzle_lucky_charm.vpcf", context )

end



function Advanced_Bad_Juju:GetIntrinsicModifierName() return "modifier_Advanced_Bad_Juju_passive" end
function Advanced_Bad_Juju:GetAOERadius()
	return self:GetSpecialValueFor("radius") 
end




modifier_Advanced_Bad_Juju_passive = advanced_modifier({})

function modifier_Advanced_Bad_Juju_passive:IsDebuff()			return false end
function modifier_Advanced_Bad_Juju_passive:IsHidden() 			return false end
function modifier_Advanced_Bad_Juju_passive:IsPurgable() 		return false end
function modifier_Advanced_Bad_Juju_passive:IsPurgeException() 	return false end
function modifier_Advanced_Bad_Juju_passive:AllowIllusionDuplicate() return false end
function modifier_Advanced_Bad_Juju_passive:RemoveOnDeath() return false end
function modifier_Advanced_Bad_Juju_passive:DeclareFunctions() 
    return {
        -- MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
 end
-- function modifier_Advanced_Bad_Juju_passive:GetModifierPercentageCooldown() return (self:GetStackCount() +self:GetAbility():GetSpecialValueFor("cooldown_reduction")) end
--减少冷却
function modifier_Advanced_Bad_Juju_passive:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
    }
end
function modifier_Advanced_Bad_Juju_passive:Advanced_GetModifierCooldownReduction(keys)
    local reduction = 100-(100-self:GetAbility():GetSpecialValueFor("cooldown_reduction"))*0.01 * (100-self:GetStackCount())
    return reduction
end





function modifier_Advanced_Bad_Juju_passive:OnAbilityFullyCast(keys)

    -- print(keys.ability:GetCooldown(1))
	if not IsServer() or keys.unit ~= self:GetParent() then
		return
    end
    local cooldown = keys.ability:GetCooldown(keys.ability:GetLevel()) 
    if cooldown>=5 then
        local caster = self:GetParent()
        local units1 = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("radius"), 
            DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
        local num = self:GetAbility():GetSpecialValueFor("effect_number")
        local sum = 0
        local attack_red = self:GetAbility():GetSpecialValueFor("attack_reduction_index") * caster:GetIntellect(false)
        local duration1 = self:GetAbility():GetSpecialValueFor("duration")
        self.advanced_level = self:GetAbility().advanced_level
        --LV5解锁邪神之力+
        if self.advanced_level>=5 then
            duration1 = duration1 + 5
        end
        --LV15解锁渗透
        if self.advanced_level>=15 then
            local max_stack = 15
            -- caster:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Bad_Juju_passive2", {duration = 15})
            -- LV20解锁渗透+
            if self.advanced_level>=20 then
                max_stack = 25
            end
            if self:GetStackCount()<max_stack then
                self:IncrementStackCount()
                local modifier = self
                Timers:CreateTimer(15, function()
                    if not modifier or modifier:IsNull() then
                        return
                    end
                    self:DecrementStackCount()
      
                end)
            end

        end
        local duration2 = self:GetAbility():GetSpecialValueFor("duration")*2
        --LV10解锁编织+
        if self.advanced_level>=10 then
            duration2 =duration2 + 10
        end
        for _, units in pairs(units1) do
            local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.25)
            local StatusResistance =  units:GetHDStatusResistanceIndex(0.25)*ModifierStatusNegativeGain
            local modifier = units:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Bad_Juju_attack_reduction", {duration = duration1*StatusResistance})
            if modifier and not modifier:IsNull() then
                modifier:SetStackCount(attack_red)
            end
            units:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Bad_Juju_armor_reduction", {duration = duration1*2*StatusResistance})
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
            local StatusResistance =units:GetHDStatusResistanceIndex(0.25)*0.01*ModifierStatusNegativeGain
            local modifier = units:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Bad_Juju_attack_reduction", {duration = duration2*StatusResistance})
            if modifier and not modifier:IsNull() then
                modifier:SetStackCount(attack_red)
            end
            units:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Bad_Juju_armor_reduction", {duration = duration2*2*StatusResistance})
            sum = sum + 1
            if sum >= num then
                break
            end
        end
    end
    if cooldown>=3 then
        self:CheckUnlock1(keys.ability)
        if keys.target then
            self:CheckUnlock2(keys.target)
        end
        self:CheckUnlock3()
    end
  
    
end

function modifier_Advanced_Bad_Juju_passive:CheckUnlock1(targetAbility)
    local ability = self:GetAbility()
    if not ability.unlock1 then
        return
    end
    local time = ability:GetCooldownTimeRemaining()
    if time>=20 then
        return
    end
    local parent = self:GetParent()
    Timers:CreateTimer(RandomFloat(0.05, 0.3), function()
        local count = 2
        for i=0, parent:GetAbilityCount() - 1 do
            local Ability = parent:GetAbilityByIndex(i)
            if Ability ~= nil and Ability ~= targetAbility and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and not Ability:IsCooldownReady() then
                local newCooldown = Ability:GetCooldownTimeRemaining() - 1.5
                Ability:EndCooldown()
                if newCooldown>=0 then
                    Ability:StartCooldown(newCooldown)
                end
                count = count - 1
                if count<=0 then
                    break
                end
            end
        end
        if not ability:IsNull() then
            ability:StartCooldown(time+2)
        end
        
    
    
        parent:EmitSound("Hero_Dazzle.BadJuJu.Target")
        local particle_cast = "particles/units/heroes/hero_dazzle/dazzle_lucky_charm.vpcf"
        local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, self:GetParent() )
        ParticleManager:SetParticleControlEnt(
            effect_cast,
            0,
            self:GetParent(),
            PATTACH_POINT_FOLLOW,
            "attach_hitloc",
            Vector(0,0,0), -- unknown
            true -- unknown, true
        )
        DestroyParticleByDelay(effect_cast,5)
        -- ParticleManager:DestroyParticle(effect_cast,false)
        -- ParticleManager:ReleaseParticleIndex( effect_cast )
    end)
    
    
    
end


function modifier_Advanced_Bad_Juju_passive:CheckUnlock2(target)
    local ability = self:GetAbility()
    if not ability.unlock2 or not ability:IsCooldownReady() then
        return
    end
    local caster = self:GetCaster()

    if IsEnemy(target,caster) then
        local Advanced_Poison_Touch = caster:FindAbilityByName("Advanced_Poison_Touch")
        if Advanced_Poison_Touch then
            caster:SetCursorCastTarget(target)
            Advanced_Poison_Touch:OnSpellStart()
        end
    else
        local Advanced_Shadow_Wave = caster:FindAbilityByName("Advanced_Shadow_Wave")
        if Advanced_Shadow_Wave then
            Advanced_Shadow_Wave:CastSpell(target)
            -- caster:SetCursorCastTarget(target)
            -- Advanced_Shadow_Wave:OnSpellStart()
        end
    end
    ability:StartCooldown(0.1)
end

function modifier_Advanced_Bad_Juju_passive:CheckUnlock3()
    local ability = self:GetAbility()
    if not ability.unlock3 then
        return
    end
    local time = ability:GetCooldownTimeRemaining()
    if time>=10 then
        return
    end
    local caster = self:GetCaster()
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(), nil,caster:Script_GetAttackRange()+300 , DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
    local count = 8
    for _, enemy in pairs(enemies) do
        caster:PerformAttack(enemy, false, true, true, false, true, false, true)
        count = count - 1
        if count<=0 then
            break
        end
    end




    ability:StartCooldown(time+1)
end


modifier_Advanced_Bad_Juju_attack_reduction = class({})
function modifier_Advanced_Bad_Juju_attack_reduction:IsDebuff()			   return true end
function modifier_Advanced_Bad_Juju_attack_reduction:IsHidden() 			return true end
function modifier_Advanced_Bad_Juju_attack_reduction:IsPurgable() 			return true end
function modifier_Advanced_Bad_Juju_attack_reduction:IsPurgeException() 	return true end
function modifier_Advanced_Bad_Juju_attack_reduction:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_Advanced_Bad_Juju_attack_reduction:DeclareFunctions()
	return {MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,}
end
function modifier_Advanced_Bad_Juju_attack_reduction:GetModifierBaseAttack_BonusDamage() return (0 - self:GetStackCount()) end
function modifier_Advanced_Bad_Juju_attack_reduction:OnCreated()
    if not IsServer() then
        return        
    end
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Bad_Juju_attack_reduction2", {duration =999})
end


modifier_Advanced_Bad_Juju_armor_reduction = advanced_modifier({})
function modifier_Advanced_Bad_Juju_armor_reduction:IsDebuff()			    return true end
function modifier_Advanced_Bad_Juju_armor_reduction:IsHidden() 			    return true end
function modifier_Advanced_Bad_Juju_armor_reduction:IsPurgable() 			return true end
function modifier_Advanced_Bad_Juju_armor_reduction:IsPurgeException() 	    return true end
function modifier_Advanced_Bad_Juju_armor_reduction:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Bad_Juju_armor_reduction:OnCreated()
    if not IsServer() then
        return        
    end
    self:StartIntervalThink(5)
    self.armor = self:GetAbility():GetSpecialValueFor("armor_reduction")
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_Advanced_Bad_Juju_armor_reduction2", {})
end

function modifier_Advanced_Bad_Juju_armor_reduction:OnIntervalThink()
    self:SetStackCount(self:GetStackCount() + self.armor)
end

function modifier_Advanced_Bad_Juju_armor_reduction:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_Bad_Juju_armor_reduction:Advanced_GetModifierPhysicalArmorBonus()
    return  -self:GetStackCount()
end
modifier_Advanced_Bad_Juju_armor_reduction2 = class({})
function modifier_Advanced_Bad_Juju_armor_reduction2:IsDebuff()			    return true end
function modifier_Advanced_Bad_Juju_armor_reduction2:IsHidden() 			return false end
function modifier_Advanced_Bad_Juju_armor_reduction2:IsPurgable() 			return false end
function modifier_Advanced_Bad_Juju_armor_reduction2:IsPurgeException() 	return false end

function modifier_Advanced_Bad_Juju_armor_reduction2:OnCreated()
    if IsServer() then
        local StatusResistance = 1 - self:GetParent():GetStatusResistance()*0.25
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
        self.count = 8
		self:StartIntervalThink(0.3)
	end
end

function modifier_Advanced_Bad_Juju_armor_reduction2:OnRefresh(table)
	if IsServer() then
		local StatusResistance = 1 - self:GetParent():GetStatusResistance()*0.25
	    self:SetDuration(self:GetRemainingTime()*StatusResistance,true)
	end
end
function modifier_Advanced_Bad_Juju_armor_reduction2:OnIntervalThink()
    local buffs = self:GetParent():FindAllModifiersByName("modifier_Advanced_Bad_Juju_armor_reduction")
    local stack = 0
    for _, buff in pairs(buffs) do
        stack = stack + buff:GetStackCount()
    end 
	self:SetStackCount(stack)
    if self:GetStackCount() == 0 then
        self.count = self.count - 1
        if self.count == 0 then
            self:SafeDestroy()
        end
    end
end

modifier_Advanced_Bad_Juju_attack_reduction2 = class({})
function modifier_Advanced_Bad_Juju_attack_reduction2:IsDebuff()			return true end
function modifier_Advanced_Bad_Juju_attack_reduction2:IsHidden() 			return false end
function modifier_Advanced_Bad_Juju_attack_reduction2:IsPurgable() 			return false end
function modifier_Advanced_Bad_Juju_attack_reduction2:IsPurgeException() 	return false end

function modifier_Advanced_Bad_Juju_attack_reduction2:OnCreated()
    if IsServer() then
		self:StartIntervalThink(0.3)
	end
end
function modifier_Advanced_Bad_Juju_attack_reduction2:OnIntervalThink()
    local buffs = self:GetParent():FindAllModifiersByName("modifier_Advanced_Bad_Juju_attack_reduction")
    local stack = 0
    for _, buff in pairs(buffs) do
        stack = stack + buff:GetStackCount()
    end 
	self:SetStackCount(stack)
	if self:GetStackCount() == 0 then
        self:SafeDestroy()
    end
    
end




