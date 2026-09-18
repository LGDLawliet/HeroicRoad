LinkLuaModifier("modifier_item_act2_leshrac", "items/item_act2_leshrac.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_leshrac_torment", "items/item_act2_leshrac.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_leshrac_torment_cd", "items/item_act2_leshrac.lua", LUA_MODIFIER_MOTION_NONE)

item_act2_leshrac = class({})
function item_act2_leshrac:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", context)
end
function item_act2_leshrac:GetIntrinsicModifierName()
    return "modifier_item_act2_leshrac"
end
function item_act2_leshrac:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
----
modifier_item_act2_leshrac = advanced_modifier({})

function modifier_item_act2_leshrac:IsHidden() return true end
function modifier_item_act2_leshrac:IsDebuff() return false end
function modifier_item_act2_leshrac:IsPurgable() return false end
function modifier_item_act2_leshrac:RemoveOnDeath() return false end

function modifier_item_act2_leshrac:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.incoming = self.ability:GetSpecialValueFor("incoming")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.index1 = self.ability:GetSpecialValueFor("index1")*0.01
    self.check2 = self.ability:GetSpecialValueFor("check2")
    self.radius2 = self.ability:GetSpecialValueFor("radius2")
    self.mp_regen2 = self.ability:GetSpecialValueFor("mp_regen2")
    self:SetStackCount(0)
    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
    end

end

function modifier_item_act2_leshrac:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
    }
end

function modifier_item_act2_leshrac:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID() then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_009" then
        self:Check_GainCharge()
    else
        self:SetStackCount(self:GetStackCount()+1)
    end
    --进度满足，点数+1
    if self:GetStackCount() >= self.need then
        self:All_GainCharge()
        self:SetStackCount(0)
    end

    -- 触发折磨扩散
    if attacker ~= self.parent then return end
    local cd = attacker:HasModifier("modifier_item_act2_leshrac_torment_cd")
    if cd then return end
    
    self:TriggerTorment(unit:GetAbsOrigin())
    attacker:AddNewModifier(attacker, self.ability, "modifier_item_act2_leshrac_torment_cd", {duration = self.cd})
end

function modifier_item_act2_leshrac:All_GainCharge()
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

function modifier_item_act2_leshrac:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_leshrac")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_leshrac:OnTakeDamage(params)
    if not IsServer() then return end
    if self.ability:GetCurrentCharges() < self.check1 then return end
    
    local unit = params.unit
    local attacker = params.attacker
    if attacker ~= self.parent then return end
    if not IsEnemy(unit, self.parent) then return end
    if IsPoisonDamage(params) then return end
    if params.inflictor and params.inflictor == self.ability then return end
    if not params.target then
        params.target = unit
    end
    if unit:HasModifier("modifier_item_act2_leshrac_torment") then
        local damageindex_add = GetTotalDamageOutgoing(attacker,params) or 0
        local damageindex_mult = GetOutgoingDamagePercentFinal(attacker, params) or 1
        local final_index = (1+damageindex_add*0.01)*damageindex_mult*0.01
        local damage = params.damage * self.index1 / final_index
        unit:Poison(self.parent, self.ability, damage)
    end
end

function modifier_item_act2_leshrac:TriggerTorment(position)
    if not IsServer() then return end
    if not position then return end
    
    local caster = self.parent
    local ability = self.ability
    local radius = self.radius
    local incoming = ability:GetCurrentCharges() * self.incoming
    local duration = self.duration
    if ability:GetCurrentCharges() >= self.check1 then
        duration = -1
    end

    local units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        position,
        nil,
        radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    
    for _, unit in pairs(units) do
        -- 创建脉冲新星特效
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_pulse_nova.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
        ParticleManager:SetParticleControl(particle, 0, unit:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, Vector(1, 0, 0)) -- 设置脉冲范围
        ParticleManager:ReleaseParticleIndex(particle)

        local modifier = unit:FindModifierByName("modifier_item_act2_leshrac_torment")
        if modifier then
            if modifier:GetStackCount() > incoming then
                return
            elseif modifier:GetStackCount() <= incoming then
                unit:AddNewModifier(caster, ability, "modifier_item_act2_leshrac_torment", 
                {
                    duration = duration,
                    incoming = incoming
                })
            end
        else
            unit:AddNewModifier(caster, ability, "modifier_item_act2_leshrac_torment", 
            {
                duration = duration,
                incoming = incoming
            })
        end
    end
end

-----
modifier_item_act2_leshrac_torment_cd = advanced_modifier({})

function modifier_item_act2_leshrac_torment_cd:IsHidden() return true end
function modifier_item_act2_leshrac_torment_cd:IsDebuff() return false end
function modifier_item_act2_leshrac_torment_cd:IsPurgable() return false end
function modifier_item_act2_leshrac_torment_cd:RemoveOnDeath() return false end
function modifier_item_act2_leshrac_torment_cd:GetTexture() return "item_act2_leshrac" end

-----
modifier_item_act2_leshrac_torment = advanced_modifier({})

function modifier_item_act2_leshrac_torment:IsHidden() return false end
function modifier_item_act2_leshrac_torment:IsDebuff() return true end
function modifier_item_act2_leshrac_torment:IsPurgable() return false end
function modifier_item_act2_leshrac_torment:GetTexture() return "item_act2_leshrac" end

function modifier_item_act2_leshrac_torment:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_item_act2_leshrac_torment:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then return end
    return self:GetStackCount()
end

function modifier_item_act2_leshrac_torment:OnCreated(params)
    if IsServer() then
        self:SetStackCount(params.incoming)
    end
end

function modifier_item_act2_leshrac_torment:OnDestroy()
    if not IsServer() then return end
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if not parent or not caster or not ability then return end
    if ability:GetCurrentCharges() < ability:GetSpecialValueFor("check2") then return end
    
    local radius2 = ability:GetSpecialValueFor("radius2")
    local mp_regen2 = ability:GetSpecialValueFor("mp_regen2")*0.01
    
    if (parent:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() <= radius2 then
        local mana_regen = ability:GetCurrentCharges() * mp_regen2 * caster:GetMaxMana()
        caster:GiveMana(mana_regen)
    end
end 