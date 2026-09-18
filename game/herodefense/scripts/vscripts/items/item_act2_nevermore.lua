LinkLuaModifier("modifier_item_act2_nevermore", "items/item_act2_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_nevermore_field", "items/item_act2_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_nevermore_shadowraze", "items/item_act2_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_nevermore_field_debuff", "items/item_act2_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act2_nevermore_shadowraze_cd", "items/item_act2_nevermore.lua", LUA_MODIFIER_MOTION_NONE)
item_act2_nevermore = class({})

function item_act2_nevermore:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context)
end

function item_act2_nevermore:GetIntrinsicModifierName()
    return "modifier_item_act2_nevermore"
end
function item_act2_nevermore:Spawn()
    if IsServer() then
		self:SetCurrentCharges(1)
	end
end
function item_act2_nevermore:GetBehavior()
    if self:GetCurrentCharges() >= self:GetSpecialValueFor("check2") then
       return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
    end
    return self.BaseClass.GetBehavior(self)
end

function item_act2_nevermore:OnSpellStart()
    local caster = self:GetCaster()
    local duration2 = self:GetSpecialValueFor("duration2")
    caster:AddNewModifier(caster, self, "modifier_item_act2_nevermore_field", {duration = duration2})
end
----
modifier_item_act2_nevermore = advanced_modifier({})

function modifier_item_act2_nevermore:IsHidden() return true end
function modifier_item_act2_nevermore:IsDebuff() return false end
function modifier_item_act2_nevermore:IsPurgable() return false end
function modifier_item_act2_nevermore:RemoveOnDeath() return false end

function modifier_item_act2_nevermore:OnCreated()
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    -- 基础参数
    self.need = self.ability:GetSpecialValueFor("need")
    self.get = self.ability:GetSpecialValueFor("get")
    self.cd = self.ability:GetSpecialValueFor("cd")
    self.line = self.ability:GetSpecialValueFor("line")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.check1 = self.ability:GetSpecialValueFor("check1")
    self.bonus1 = self.ability:GetSpecialValueFor("bonus1")*0.01
    self.radius1 = self.ability:GetSpecialValueFor("radius1")
    self.damage1 = self.ability:GetSpecialValueFor("damage1")*0.01
    self:SetStackCount(0)
    if Game_State:IsInChaoticEra() then
        self.need = self.need*0.5
    end

    -- 同一个modifier下的damagetable要在oncreate的时候就创立，随后进行补充以节省性能
    if IsServer() then
        self.damagetable = {
            --victim = unit,
            attacker = self.parent,
            --damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            ability = self.ability,
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
        }
    end
end

function modifier_item_act2_nevermore:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_DEATH = {nil, nil},
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(), nil},
    }
end

function modifier_item_act2_nevermore:OnDeath(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if (not attacker) or (attacker:GetPlayerOwnerID() ~= self.parent:GetPlayerOwnerID()) then return end
    if not IsEnemy(unit, self.parent) then return end

    --如果击杀的单位名正确直接加点数，否则加进度
    if unit:GetUnitName() == "npc_monster_challenge_001" then
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

function modifier_item_act2_nevermore:All_GainCharge()
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

function modifier_item_act2_nevermore:Check_GainCharge()
    if not IsServer() then return end
    local heroes = GetAllRealHeroes()
    for _, hero in pairs(heroes) do
        local ability = 
        hero:FindItemInInventory("item_act2_nevermore")

        if ability then
            print("ITEM FOUND")
            local current_charges = ability:GetCurrentCharges()
            ability:SetCurrentCharges(math.min(current_charges + self.get, 100))
        end
    end
end

function modifier_item_act2_nevermore:OnTakeDamage(params)
    if not IsServer() then return end
    local unit = params.unit
    local attacker = params.attacker
    if attacker ~= self.parent then return end
    if not IsEnemy(unit, self.parent) then return end
    if params.inflictor == self.ability then return end
    
    local cd = attacker:HasModifier("modifier_item_act2_nevermore_shadowraze_cd")
    if cd then return end
    if not attacker:IsAlive() then return end
    
    local armor_threshold = self.ability:GetCurrentCharges() * self.line
    if unit:GetPhysicalArmorValue(false) < armor_threshold then
        self:TriggerShadowraze(unit:GetAbsOrigin(),1)
        attacker:AddNewModifier(attacker, self.ability,"modifier_item_act2_nevermore_shadowraze_cd",{duration = self.cd})
    end
end
--触发要单独写一个函数
function modifier_item_act2_nevermore:TriggerShadowraze(position, damage_index)
    if not IsServer() then return end
    if not position then return end
    
    local damage_index = damage_index or 1
    local caster = self.parent
    local ability = self.ability
    local radius = self.radius
    local damage = ability:GetCurrentCharges() * caster:HDGetPrimaryStatValue() * self.damage * damage_index
    local outgoing_reduction = self.outgoing
    local duration = self.duration

    -- 创建影压特效
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, position)
    ParticleManager:ReleaseParticleIndex(particle)

    -- 创建影压音效
    EmitGlobalSound("Hero_Nevermore.Shadowraze")
    
    if ability:GetCurrentCharges() >= self.check1 then
        damage = damage*(1+self.bonus1)
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
        self.damagetable.victim = unit
        self.damagetable.damage = damage
        ApplyDamage(self.damagetable)
        
        if unit:IsAlive() then
            unit:AddNewModifier(caster, ability, "modifier_item_act2_nevermore_shadowraze", 
            {
                duration = duration,
                outgoing_reduction = outgoing_reduction
            })
        end
    end

    if ability:GetCurrentCharges() >= self.check1 then
        local radius1 = self.radius1
        local random_angle = RandomFloat(0, 360)
        local random_distance = RandomFloat(0, radius1)
        local random_position = position + Vector(math.cos(math.rad(random_angle)), math.sin(math.rad(random_angle)), 0) * random_distance
        
        self:TriggerShadowrazeCheck1(random_position, self.damage1)
    end
end
--触发要单独写一个函数，这个是镜像函数，为了防止死循环
function modifier_item_act2_nevermore:TriggerShadowrazeCheck1(position, damage_index)
    if not IsServer() then return end
    if not position then return end
    
    local damage_index = damage_index or 1
    local caster = self.parent
    local ability = self.ability
    local radius = self.radius
    local damage = ability:GetCurrentCharges() * caster:HDGetPrimaryStatValue() * self.damage * damage_index * (1+self.bonus1)
    local outgoing_reduction = self.outgoing
    local duration = self.duration

    -- 创建影压特效
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_WORLDORIGIN, nil)
    ParticleManager:SetParticleControl(particle, 0, position)
    ParticleManager:ReleaseParticleIndex(particle)
    EmitGlobalSound("Hero_Nevermore.Shadowraze")

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
        self.damagetable.victim = unit
        self.damagetable.damage = damage
        ApplyDamage(self.damagetable)
        
        if unit:IsAlive() then
            unit:AddNewModifier(caster, ability, "modifier_item_act2_nevermore_shadowraze", 
            {
                duration = duration,
                outgoing_reduction = outgoing_reduction
            })
        end
    end
end
-----
modifier_item_act2_nevermore_shadowraze_cd = advanced_modifier({})

function modifier_item_act2_nevermore_shadowraze_cd:IsHidden() return true end
function modifier_item_act2_nevermore_shadowraze_cd:IsDebuff() return false end
function modifier_item_act2_nevermore_shadowraze_cd:IsPurgable() return false end
function modifier_item_act2_nevermore_shadowraze_cd:RemoveOnDeath() return false end
function modifier_item_act2_nevermore_shadowraze_cd:GetTexture() return "item_act2_nevermore" end
-----
modifier_item_act2_nevermore_shadowraze = advanced_modifier({})

function modifier_item_act2_nevermore_shadowraze:IsHidden() return false end
function modifier_item_act2_nevermore_shadowraze:IsDebuff() return true end
function modifier_item_act2_nevermore_shadowraze:IsPurgable() return false end
function modifier_item_act2_nevermore_shadowraze:GetTexture() return "item_act2_nevermore" end

function modifier_item_act2_nevermore_shadowraze:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

function modifier_item_act2_nevermore_shadowraze:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return -self:GetStackCount()
end

function modifier_item_act2_nevermore_shadowraze:OnCreated(params)
    if IsServer() then
        self:SetStackCount(params.outgoing_reduction)
    end
end
-----
modifier_item_act2_nevermore_field = advanced_modifier({})

function modifier_item_act2_nevermore_field:IsHidden() return false end
function modifier_item_act2_nevermore_field:IsDebuff() return false end
function modifier_item_act2_nevermore_field:IsPurgable() return false end
function modifier_item_act2_nevermore_field:GetTexture() return "item_act2_nevermore" end

function modifier_item_act2_nevermore_field:OnCreated(params)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.interval2 = self.ability:GetSpecialValueFor("interval2")
    self.radius2 = self.ability:GetSpecialValueFor("radius2")
    
    if not IsServer() then return end
    self:StartIntervalThink(self.interval2)
end

function modifier_item_act2_nevermore_field:OnIntervalThink()
    if not self:GetAbility() then return end
    
    local highest_hp_unit = FindStrongestEnemyInRangeAndPosition( self.caster, self.caster:GetAbsOrigin(), self.radius2, FIND_ANY_ORDER )
    if highest_hp_unit then
        highest_hp_unit:AddNewModifier(self.caster, self.ability, "modifier_item_act2_nevermore_field_debuff", {duration = self.interval2})
        local modifier = self.caster:FindModifierByName("modifier_item_act2_nevermore")
        modifier:TriggerShadowraze(highest_hp_unit:GetAbsOrigin(),1)
    end
end

-----
modifier_item_act2_nevermore_field_debuff = advanced_modifier({})

function modifier_item_act2_nevermore_field_debuff:IsHidden() return false end
function modifier_item_act2_nevermore_field_debuff:IsDebuff() return true end
function modifier_item_act2_nevermore_field_debuff:IsPurgable() return false end

function modifier_item_act2_nevermore_field_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_item_act2_nevermore_field_debuff:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then return end
    return -self:GetStackCount()
end

function modifier_item_act2_nevermore_field_debuff:OnCreated(params)
    self.ability = self:GetAbility()
    self.armor2 = self.ability:GetSpecialValueFor("armor2")
    self:SetStackCount(self.armor2*self.ability:GetCurrentCharges())
end