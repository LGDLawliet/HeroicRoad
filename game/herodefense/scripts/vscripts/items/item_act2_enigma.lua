LinkLuaModifier("modifier_item_act2_enigma", "items/item_act2_enigma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_enigma_eidolon", "items/item_act2_enigma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_enigma_crazy", "items/item_act2_enigma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_enigma_crazy_during", "items/item_act2_enigma.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_enigma_bottle_cd", "items/item_act2_enigma.lua", LUA_MODIFIER_MOTION_NONE)
item_act2_enigma = class({})

function item_act2_enigma:GetIntrinsicModifierName()
    return "modifier_item_act2_enigma"
end
function item_act2_enigma:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
function item_act2_enigma:GetBehavior()
    if self:GetCurrentCharges() >= self:GetSpecialValueFor("check2") then
       return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
    end
    return self.BaseClass.GetBehavior(self)
end

function item_act2_enigma:OnSpellStart()
    local caster = self:GetCaster()
    local duration2 = self:GetSpecialValueFor("duration2")
    local outgoing2 = self:GetSpecialValueFor("outgoing2")
    local unit_pos = caster:GetAbsOrigin() + caster:GetForwardVector()*200

    caster:AddNewModifier(caster, self, "modifier_item_act2_enigma_crazy_during", {duration = duration2})
    local modifier = caster:FindModifierByName("modifier_item_act2_enigma")
    if modifier then
        for i = 0, modifier.max+modifier.num1 - 1 do
            modifier:SummonEidolon()
        end
    end
    local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        FIND_UNITS_EVERYWHERE,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        FIND_ANY_ORDER,
        false
    )
    
    for _, unit in pairs(units) do
        if unit:GetUnitName() == "npc_act2_enigma" and unit:GetPlayerOwnerID() == caster:GetPlayerOwnerID() then
            FindClearSpaceForUnit(unit, unit_pos, true)
            caster:EmitSound("Hero_Enigma.Demonic_Conversion")
            unit:AddNewModifier(caster, self, "modifier_item_act2_enigma_crazy",{duration = duration2, outgoing2 = outgoing2})
        end
    end
end

----
modifier_item_act2_enigma = advanced_modifier({})

function modifier_item_act2_enigma:IsHidden() return true end
function modifier_item_act2_enigma:IsDebuff() return false end
function modifier_item_act2_enigma:IsPurgable() return false end
function modifier_item_act2_enigma:RemoveOnDeath() return false end

function modifier_item_act2_enigma:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.max = self.ability:GetSpecialValueFor("max")
    self.index = self.ability:GetSpecialValueFor("index") * 0.01
    self.stack = self.ability:GetSpecialValueFor("stack")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.bonus1 = self.ability:GetSpecialValueFor("bonus1")*0.01
    self.num1 = self.ability:GetSpecialValueFor("num1")
    self:SetStackCount(0)
    self.eidolon_attack_count = 0

    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
    end
end

function modifier_item_act2_enigma:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = {self:GetParent(), nil},
    }
end

function modifier_item_act2_enigma:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if (not attacker) or (attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID()) then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_003" and not unit:HasModifier("modifier_enigma_challenge_split_buff") then
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

function modifier_item_act2_enigma:All_GainCharge()
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

function modifier_item_act2_enigma:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_enigma")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_enigma:OnAbilityFullyCast(params)
    if not IsServer() then return end
    if params.unit ~= self.parent then return end
    if params.ability:GetName() ~= "item_new_bottle" then return end
    
    local cd = self.parent:HasModifier("modifier_item_act2_enigma_bottle_cd") or self.parent:HasModifier("modifier_item_act2_enigma_crazy_during")
    if cd then return end
    
    self:SummonEidolon()
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act2_enigma_bottle_cd", {duration = 0.2})
end

function modifier_item_act2_enigma:SummonEidolon()
    if not IsServer() then return end

    local caster = self.parent
    local ability = self.ability
    local charges = ability:GetCurrentCharges()
    
    local health = caster:GetMaxHealth() * self.index * charges +50
    local damage = caster:GetAttackDamage() * self.index * charges +20
    if Game_State:IsInChaoticEra() then
        health = caster:GetMaxHealth() * self.index * charges +300
        damage = math.min(caster:GetAverageTrueAttackDamage(nil),caster:GetAttackDamage()*5) * self.index * charges +100
        print("谜团乱纪元模式启动")
    end
    local armor = caster:GetPhysicalArmorValue(false) * 0.2
    local life_duration = -1
    local unit_pos = caster:GetAbsOrigin() + caster:GetForwardVector()*200


    local count = self.max
    if charges >= self.check1 then
        health = health * (1+self.bonus1)
        damage = damage * (1+self.bonus1)
        count = count + self.num1
    end
    if not self.summon_table then
        self.summon_table = {}
    end
    UpdateSummonMaxCount(self.summon_table,count)
    local eidolon = caster:SummonUnit("npc_act2_enigma", life_duration, unit_pos, caster:GetForwardVector(), ability, 0, health, nil, damage, armor, 1, 0)
    if eidolon then
        eidolon:AddNewModifier(caster, ability, "modifier_item_act2_enigma_eidolon", {})
        table.insert(self.summon_table,eidolon)

        eidolon:EmitSound("Hero_Enigma.Demonic_Conversion")
    end
end

function modifier_item_act2_enigma:OnEidolonAttack()
    self.eidolon_attack_count = self.eidolon_attack_count + 1
    if self.eidolon_attack_count >= self.stack then
        local bottle = self.parent:FindItemInInventory("item_new_bottle")
        if bottle then
            if bottle:GetCurrentCharges() < bottle.max_charge then
                bottle:SetCurrentCharges(bottle:GetCurrentCharges()+1)
                self.eidolon_attack_count = 0
            end
        end
    end
end

-----
modifier_item_act2_enigma_eidolon = advanced_modifier({})

function modifier_item_act2_enigma_eidolon:IsHidden() return true end
function modifier_item_act2_enigma_eidolon:IsDebuff() return false end
function modifier_item_act2_enigma_eidolon:IsPurgable() return false end
function modifier_item_act2_enigma_eidolon:RemoveOnDeath() return true end

function modifier_item_act2_enigma_eidolon:OnCreated()
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
end

function modifier_item_act2_enigma_eidolon:ADDeclareFunctions()
    return {

        MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil}
    }
end

function modifier_item_act2_enigma_eidolon:OnAttack(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    
    local attacker = keys.attacker
    if attacker ~= self.parent then return end
    
    local modifier = self.caster:FindModifierByName("modifier_item_act2_enigma")
    if modifier then
        modifier:OnEidolonAttack()
    end
end
-----
modifier_item_act2_enigma_crazy_during = advanced_modifier({})

function modifier_item_act2_enigma_crazy_during:IsHidden() return false end
function modifier_item_act2_enigma_crazy_during:IsDebuff() return false end
function modifier_item_act2_enigma_crazy_during:IsPurgable() return false end
function modifier_item_act2_enigma_crazy_during:GetTexture() return "item_act2_enigma" end
-----
modifier_item_act2_enigma_crazy = advanced_modifier({})

function modifier_item_act2_enigma_crazy:IsHidden() return false end
function modifier_item_act2_enigma_crazy:IsDebuff() return false end
function modifier_item_act2_enigma_crazy:IsPurgable() return false end
function modifier_item_act2_enigma_crazy:GetTexture() return "item_act2_enigma" end

function modifier_item_act2_enigma_crazy:OnCreated(keys)
    if not IsServer() then return end
    
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self:SetStackCount(keys.outgoing2)
    self:StartIntervalThink(self:GetDuration())
end
function modifier_item_act2_enigma_crazy:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	    advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_act2_enigma_crazy:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end
function modifier_item_act2_enigma_crazy:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then return end
    return -self:GetStackCount()
end

function modifier_item_act2_enigma_crazy:OnIntervalThink()
    if not IsServer() then return end
    local modifier = self.caster:FindModifierByName("modifier_item_act2_enigma")
    if modifier then
        for i = 1, modifier.max + modifier.num1 do
            modifier:SummonEidolon()
        end
    end
    self:Destroy()
end

function modifier_item_act2_enigma_crazy:OnDestroy()
    if IsServer() then
        if self.parent:IsAlive() then
            self.parent:Kill(self.ability, self.caster)
        end
    end
end
-----
modifier_item_act2_enigma_bottle_cd = advanced_modifier({})

function modifier_item_act2_enigma_bottle_cd:IsHidden() return true end
function modifier_item_act2_enigma_bottle_cd:IsDebuff() return false end
function modifier_item_act2_enigma_bottle_cd:IsPurgable() return false end
function modifier_item_act2_enigma_bottle_cd:RemoveOnDeath() return false end
function modifier_item_act2_enigma_bottle_cd:GetTexture() return "item_act2_enigma" end 