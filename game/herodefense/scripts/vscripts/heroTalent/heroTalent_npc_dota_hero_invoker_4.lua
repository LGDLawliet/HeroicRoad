LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_invoker_4", "heroTalent/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE )


heroTalent_npc_dota_hero_invoker_4 = class({})

-- 被动技能的基础属性
function heroTalent_npc_dota_hero_invoker_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_invoker_4_passive"
end

-- 创建被动基础modifier
LinkLuaModifier("modifier_heroTalent_npc_dota_hero_invoker_4_passive", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_heroTalent_npc_dota_hero_invoker_4_passive = class({})

function modifier_heroTalent_npc_dota_hero_invoker_4_passive:IsHidden()return true end
function modifier_heroTalent_npc_dota_hero_invoker_4_passive:IsPurgable()return false end

function modifier_heroTalent_npc_dota_hero_invoker_4_passive:OnCreated()
    self.fire_buff_duration = 5
    self.ice_buff_duration = 7
    self.lightning_buff_duration = 3
    self.fire_pure_damage_pct = 20
    self.ice_cdr_pct = 10
    self.lightning_amp_pct = 10
    self.tri_element_bonus_pct = 35
end

function modifier_heroTalent_npc_dota_hero_invoker_4_passive:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_heroTalent_npc_dota_hero_invoker_4_passive:OnTakeDamage(keys)
    if keys.attacker ~= self:GetParent() then return end
    
    local caster = self:GetParent()
    local target = keys.unit
    local damage = keys.damage
    local damage_type = keys.damage_type
    
    -- 检查伤害类型并应用相应buff
    if damage_type == DAMAGE_TYPE_MAGICAL then
        -- 火属性伤害
        if keys.damage_flags == DOTA_DAMAGE_FLAG_FIRE then
            self:ApplyFireBuff(caster)
        -- 冰属性伤害
        elseif keys.damage_flags == DOTA_DAMAGE_FLAG_COLD then
            self:ApplyIceBuff(caster)
        -- 雷属性伤害
        elseif keys.damage_flags == DOTA_DAMAGE_FLAG_LIGHTNING then
            self:ApplyLightningBuff(caster)
        end
    end
    
    -- 检查三元素buff是否同时存在
    self:CheckTriElementBonus(caster)
end

-- 火属性buff
function modifier_heroTalent_npc_dota_hero_invoker_4_passive:ApplyFireBuff(caster)
    caster:AddNewModifier(
        caster,
        self:GetAbility(),
        "modifier_invoker_fire_buff",
        {duration = self.fire_buff_duration}
    )
end

-- 冰属性buff
function modifier_heroTalent_npc_dota_hero_invoker_4_passive:ApplyIceBuff(caster)
    -- 检查7秒冷却
    if not caster:HasModifier("modifier_invoker_ice_buff_cooldown") then
        caster:AddNewModifier(
            caster,
            self:GetAbility(),
            "modifier_invoker_ice_buff",
            {duration = self.ice_buff_duration}
        )
        
        -- 添加冷却modifier
        caster:AddNewModifier(
            caster,
            self:GetAbility(),
            "modifier_invoker_ice_buff_cooldown",
            {duration = 7}
        )
        
        -- 减少所有技能CD 1秒
        for i = 0, caster:GetAbilityCount() - 1 do
            local ability = caster:GetAbilityByIndex(i)
            if ability and not ability:IsCooldownReady() then
                local remaining_cd = ability:GetCooldownTimeRemaining()
                ability:EndCooldown()
                ability:StartCooldown(math.max(0, remaining_cd - 1))
            end
        end
    end
end

-- 雷属性buff
function modifier_heroTalent_npc_dota_hero_invoker_4_passive:ApplyLightningBuff(caster)
    caster:AddNewModifier(
        caster,
        self:GetAbility(),
        "modifier_invoker_lightning_buff",
        {duration = self.lightning_buff_duration}
    )
end

-- 检查三元素buff
function modifier_heroTalent_npc_dota_hero_invoker_4_passive:CheckTriElementBonus(caster)
    local has_fire = caster:HasModifier("modifier_invoker_fire_buff")
    local has_ice = caster:HasModifier("modifier_invoker_ice_buff")
    local has_lightning = caster:HasModifier("modifier_invoker_lightning_buff")
    
    if has_fire and has_ice and has_lightning then
        if not caster:HasModifier("modifier_invoker_tri_element_bonus") then
            caster:AddNewModifier(
                caster,
                self:GetAbility(),
                "modifier_invoker_tri_element_bonus",
                {}
            )
        end
    else
        caster:RemoveModifierByName("modifier_invoker_tri_element_bonus")
    end
end

-- 火属性buff modifier
LinkLuaModifier("modifier_invoker_fire_buff", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_fire_buff = class({})

function modifier_invoker_fire_buff:IsHidden()
    return false
end

function modifier_invoker_fire_buff:IsPurgable()
    return true
end

function modifier_invoker_fire_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_invoker_fire_buff:OnTakeDamage(keys)
    if keys.attacker == self:GetParent() and keys.damage_type ~= DAMAGE_TYPE_PURE then
        local pure_damage = keys.damage * self:GetAbility().fire_pure_damage_pct / 100
        ApplyDamage({
            victim = keys.unit,
            attacker = keys.attacker,
            damage = pure_damage,
            damage_type = DAMAGE_TYPE_PURE
        })
    end
end

-- 冰属性buff modifier
LinkLuaModifier("modifier_invoker_ice_buff", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_ice_buff = class({})

function modifier_invoker_ice_buff:IsHidden()
    return false
end

function modifier_invoker_ice_buff:IsPurgable()
    return true
end

function modifier_invoker_ice_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
    }
end

function modifier_invoker_ice_buff:GetModifierPercentageCooldown()
    return self:GetAbility().ice_cdr_pct
end

-- 冰属性冷却modifier
LinkLuaModifier("modifier_invoker_ice_buff_cooldown", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_ice_buff_cooldown = class({})

function modifier_invoker_ice_buff_cooldown:IsHidden()
    return true
end

function modifier_invoker_ice_buff_cooldown:IsPurgable()
    return false
end

-- 雷属性buff modifier
LinkLuaModifier("modifier_invoker_lightning_buff", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_lightning_buff = class({})

function modifier_invoker_lightning_buff:IsHidden()
    return false
end

function modifier_invoker_lightning_buff:IsPurgable()
    return true
end

function modifier_invoker_lightning_buff:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_invoker_lightning_buff:OnTakeDamage(keys)
    if keys.attacker == self:GetParent() then
        keys.unit:AddNewModifier(
            self:GetParent(),
            self:GetAbility(),
            "modifier_invoker_lightning_vulnerability",
            {duration = 1}
        )
    end
end

-- 雷属性易伤modifier
LinkLuaModifier("modifier_invoker_lightning_vulnerability", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_lightning_vulnerability = class({})

function modifier_invoker_lightning_vulnerability:IsHidden()
    return false
end

function modifier_invoker_lightning_vulnerability:IsPurgable()
    return true
end

function modifier_invoker_lightning_vulnerability:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_invoker_lightning_vulnerability:GetModifierIncomingDamage_Percentage()
    return self:GetAbility().lightning_amp_pct
end

-- 三元素加成modifier
LinkLuaModifier("modifier_invoker_tri_element_bonus", "abilities/heroTalent_npc_dota_hero_invoker_4", LUA_MODIFIER_MOTION_NONE)
modifier_invoker_tri_element_bonus = class({})

function modifier_invoker_tri_element_bonus:IsHidden()
    return false
end

function modifier_invoker_tri_element_bonus:IsPurgable()
    return false
end

function modifier_invoker_tri_element_bonus:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
    }
end

function modifier_invoker_tri_element_bonus:GetModifierSpellAmplify_Percentage()
    return self:GetAbility().tri_element_bonus_pct
end