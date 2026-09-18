LinkLuaModifier("modifier_item_act2_slark", "items/item_act2_slark.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_slark_shadow_dance", "items/item_act2_slark.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_slark_shadow_dance_cd", "items/item_act2_slark.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_slark_shadow_dance_active", "items/item_act2_slark.lua", LUA_MODIFIER_MOTION_NONE)
item_act2_slark = class({})

function item_act2_slark:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", context)
    PrecacheResource("particle", "particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", context)
end
function item_act2_slark:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
function item_act2_slark:GetIntrinsicModifierName()
    return "modifier_item_act2_slark"
end

function item_act2_slark:GetBehavior()
    if self:GetCurrentCharges() >= self:GetSpecialValueFor("check2") then
       return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE + DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_MOVEMENT + DOTA_ABILITY_BEHAVIOR_DONT_CANCEL_CHANNEL
    end
    return self.BaseClass.GetBehavior(self)
end

function item_act2_slark:OnSpellStart()
    local caster = self:GetCaster()
    local duration2 = self:GetSpecialValueFor("duration2")
    local outgoing2 = self:GetSpecialValueFor("outgoing2")*self:GetCurrentCharges()
    
    -- 保存当前攻击状态
    local current_target = caster:GetAggroTarget()
    local was_attacking = caster:IsAttacking()
    
    caster:AddNewModifier(caster, self, "modifier_item_act2_slark_shadow_dance_active", {
        duration = duration2, 
        outgoing_bonus = outgoing2,
        was_attacking = was_attacking,
        target_entindex = current_target and current_target:GetEntityIndex() or -1
    })
end

----
modifier_item_act2_slark = advanced_modifier({})

function modifier_item_act2_slark:IsHidden() return true end
function modifier_item_act2_slark:IsDebuff() return false end
function modifier_item_act2_slark:IsPurgable() return false end
function modifier_item_act2_slark:RemoveOnDeath() return false end

function modifier_item_act2_slark:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.line = self.ability:GetSpecialValueFor("line") * 0.01
    self.linecd = self.ability:GetSpecialValueFor("linecd")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.outgoing1 = self.ability:GetSpecialValueFor("outgoing1")
    self.check2 = self.ability:GetSpecialValueFor("check2")
    self:SetStackCount(0)
    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
    end
end

function modifier_item_act2_slark:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
    }
end

function modifier_item_act2_slark:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if (not attacker) or (attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID()) then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_002" then
        self:Check_GainCharge()
    else
        self:SetStackCount(self:GetStackCount()+1)
    end
    --进度满足，点数+1
    if self:GetStackCount() >= self.need then
        self:All_GainCharge()
        self:SetStackCount(0)
    end
end

function modifier_item_act2_slark:All_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do

        local ability = 
        hero:FindItemInInventory("item_act2_nevermore")
        or hero:FindItemInInventory("item_act2_leshrac")
        or hero:FindItemInInventory("item_act2_razor")
        or hero:FindItemInInventory("item_act2_enigma")
        or hero:FindItemInInventory("item_act2_slark")
        or hero:FindItemInInventory("item_act2_wolf")

        if ability then
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_slark:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_slark")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_slark:OnTakeDamage(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if attacker ~= self.parent then return end
    if not IsEnemy(unit, self.parent) then return end
    if params.inflictor == self.ability then return end
    
    local cd = attacker:HasModifier("modifier_item_act2_slark_shadow_dance_cd")
    local main = attacker:HasModifier("modifier_item_act2_slark_shadow_dance_active")
    if cd or main then return end
    
    local damage_percent = params.damage / unit:GetMaxHealth()
    if damage_percent >= self.line then
        self:TriggerShadowDance()
        attacker:AddNewModifier(attacker, self.ability, "modifier_item_act2_slark_shadow_dance_cd", {duration = self.cd})
    end
end

function modifier_item_act2_slark:OnAbilityFullyCast(params)
    if not IsServer() then return end
    local unit = params.unit
    if unit ~= self.parent then return end
    
    local cd = unit:HasModifier("modifier_item_act2_slark_shadow_dance_cd")
    local main = unit:HasModifier("modifier_item_act2_slark_shadow_dance_active")
    if cd or main then return end
    
    local ability = params.ability
    if ability:GetCooldown(ability:GetLevel()) >= self.linecd then
        self:TriggerShadowDance()
        unit:AddNewModifier(unit, self.ability, "modifier_item_act2_slark_shadow_dance_cd", {duration = self.cd})
    end
end

function modifier_item_act2_slark:TriggerShadowDance()
    if not IsServer() then return end
    local caster = self.parent
    local ability = self.ability
    
    -- 保存当前攻击状态
    local current_target = caster:GetAggroTarget()
    local was_attacking = caster:IsAttacking()
    
    caster:Purge(false, true, false, true, false)
    
    caster:AddNewModifier(caster, ability, "modifier_item_act2_slark_shadow_dance", {
        duration = self.duration,
        outgoing_bonus = self.outgoing1,
        was_attacking = was_attacking,
        target_entindex = current_target and current_target:GetEntityIndex() or -1
    })
end

-----
modifier_item_act2_slark_shadow_dance_cd = advanced_modifier({})

function modifier_item_act2_slark_shadow_dance_cd:IsHidden() return true end
function modifier_item_act2_slark_shadow_dance_cd:IsDebuff() return false end
function modifier_item_act2_slark_shadow_dance_cd:IsPurgable() return false end
function modifier_item_act2_slark_shadow_dance_cd:RemoveOnDeath() return false end
function modifier_item_act2_slark_shadow_dance_cd:GetTexture() return "item_act2_slark" end

-----
modifier_item_act2_slark_shadow_dance = advanced_modifier({})

function modifier_item_act2_slark_shadow_dance:IsHidden() return false end
function modifier_item_act2_slark_shadow_dance:IsDebuff() return false end
function modifier_item_act2_slark_shadow_dance:IsPurgable() return false end
function modifier_item_act2_slark_shadow_dance:GetTexture() return "item_act2_slark" end
function modifier_item_act2_slark_shadow_dance:GetPriority() return 10 end

function modifier_item_act2_slark_shadow_dance:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_SILENCED] = false,
        [MODIFIER_STATE_STUNNED] = false,
    }
end
function modifier_item_act2_slark_shadow_dance:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end
function modifier_item_act2_slark_shadow_dance:GetModifierInvisibilityLevel()
    return 1
end
function modifier_item_act2_slark_shadow_dance:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_act2_slark_shadow_dance:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

function modifier_item_act2_slark_shadow_dance:AdvancedGetModifierConstantHealthRegenPercentage()
    if not self:GetAbility() then return end
    return self.maxhp_regen
end

function modifier_item_act2_slark_shadow_dance:OnCreated(params)
    self.ability = self:GetAbility()
    self.maxhp_regen = self.ability:GetSpecialValueFor("maxhp_regen")*self.ability:GetCurrentCharges()
    if IsServer() then
        self:SetStackCount(params.outgoing_bonus)
        
        -- 恢复攻击状态
        if params.was_attacking and params.target_entindex ~= -1 then
            local target = EntIndexToHScript(params.target_entindex)
            if target and target:IsAlive() then
                self:GetParent():MoveToTargetToAttack(target)
            end
        end
    
        -- 创建阴影之舞特效
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(particle, false, false, -1, false, false)
    end
end

-----
modifier_item_act2_slark_shadow_dance_active = advanced_modifier({})

function modifier_item_act2_slark_shadow_dance_active:IsHidden() return false end
function modifier_item_act2_slark_shadow_dance_active:IsDebuff() return false end
function modifier_item_act2_slark_shadow_dance_active:IsPurgable() return false end
function modifier_item_act2_slark_shadow_dance_active:GetTexture() return "item_act2_slark" end
function modifier_item_act2_slark_shadow_dance_active:OnCreated(params)
    self.ability = self:GetAbility()
    self.maxhp_regen = self.ability:GetSpecialValueFor("maxhp_regen")*self.ability:GetCurrentCharges()
    if IsServer() then
        self:SetStackCount(params.outgoing_bonus)
        
        -- 恢复攻击状态
        if params.was_attacking and params.target_entindex ~= -1 then
            local target = EntIndexToHScript(params.target_entindex)
            if target and target:IsAlive() then
                self:GetParent():MoveToTargetToAttack(target)
            end
        end
    
    
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 3, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 4, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        self:AddParticle(particle, false, false, -1, false, false)
        
        -- -- 创建进入隐身特效
        -- local enter_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance_dummy.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        -- ParticleManager:SetParticleControlEnt(enter_particle, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
        -- ParticleManager:ReleaseParticleIndex(enter_particle)
    end
end

function modifier_item_act2_slark_shadow_dance_active:CheckState()
    return {
        [MODIFIER_STATE_INVISIBLE] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

function modifier_item_act2_slark_shadow_dance_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end

function modifier_item_act2_slark_shadow_dance_active:GetModifierInvisibilityLevel()
    return 1
end

function modifier_item_act2_slark_shadow_dance_active:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
    }
end

function modifier_item_act2_slark_shadow_dance_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not self:GetAbility() then return end
    local parent = self:GetParent()
    local target = keys.target
    if not target then return end
    
    local distance = (parent:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
    local min_distance = 50
    local max_distance = 600
    
    if distance <= min_distance then
        return self:GetStackCount()
    elseif distance >= max_distance then
        return 0
    else
        local ratio = 1 - (distance - min_distance) / (max_distance - min_distance)
        return self:GetStackCount()* ratio
    end
end

function modifier_item_act2_slark_shadow_dance_active:AdvancedGetModifierConstantHealthRegenPercentage()
    if not self:GetAbility() then return end
    return self.maxhp_regen
end