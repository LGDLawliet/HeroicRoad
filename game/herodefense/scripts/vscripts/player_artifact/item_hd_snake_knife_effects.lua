item_hd_snake_knife_effects = class({})

LinkLuaModifier("modifier_item_hd_snake_knife_effects", "player_artifact/item_hd_snake_knife_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_snake_knife_effects_debuff", "player_artifact/item_hd_snake_knife_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_snake_knife_effects_cd", "player_artifact/item_hd_snake_knife_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_snake_knife_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_snake_knife_effects"
end

function item_hd_snake_knife_effects:Precache( context )

    PrecacheResource("particle", "particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_projectile.vpcf", context)
    PrecacheResource("particle", "particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_crimson_proj_projectile_return.vpcf", context)
end
-----------------------------------------------------------------
modifier_item_hd_snake_knife_effects = advanced_modifier({})

function modifier_item_hd_snake_knife_effects:IsDebuff() return false end
function modifier_item_hd_snake_knife_effects:IsHidden() return true end
function modifier_item_hd_snake_knife_effects:IsPurgable() return false end

function modifier_item_hd_snake_knife_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    
    self.bonus_outgoing_add = self.ability:GetArtifactSpecialValueFor("bonus_outgoing_add")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")
    self.poison_hp_1 = self.ability:GetArtifactSpecialValueFor("poison_hp_1")*0.01
    self.max_3 = self.ability:GetArtifactSpecialValueFor("max_3")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")

    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.stack = self.ability:GetArtifactSpecialValueFor("spell_amp_down")
    self.mana = self.ability:GetArtifactSpecialValueFor("mana_2")*0.01
    self.gold_min = self.ability:GetArtifactSpecialValueFor("gold_min_3")
    self.gold_max = self.ability:GetArtifactSpecialValueFor("gold_max_3")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_snake_knife_effects")
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7")
    if self.level >= 20 then
        self.stack = self.ability:GetArtifactSpecialValueFor("spell_amp_down_2")
    end
    if self.level >= 70 then
        self.cd = self.cd_7
    end
    if IsServer() then
        self:StartIntervalThink(self.interval_4)
    end
end

function modifier_item_hd_snake_knife_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    
    self.bonus_outgoing_add = self.ability:GetArtifactSpecialValueFor("bonus_outgoing_add")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.max = self.ability:GetArtifactSpecialValueFor("max")
    self.cd = self.ability:GetArtifactSpecialValueFor("cd")
    self.poison_hp_1 = self.ability:GetArtifactSpecialValueFor("poison_hp_1")*0.01
    self.max_3 = self.ability:GetArtifactSpecialValueFor("max_3")
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")

    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.stack = self.ability:GetArtifactSpecialValueFor("spell_amp_down")
    self.mana = self.ability:GetArtifactSpecialValueFor("mana_2")*0.01
    self.gold_min = self.ability:GetArtifactSpecialValueFor("gold_min_3")
    self.gold_max = self.ability:GetArtifactSpecialValueFor("gold_max_3")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_snake_knife_effects")
    self.cd_7 = self.ability:GetArtifactSpecialValueFor("cd_7")
    if self.level >= 20 then
        self.stack = self.ability:GetArtifactSpecialValueFor("spell_amp_down_2")
    end
    if self.level >= 70 then
        self.cd = self.cd_7
    end
end

function modifier_item_hd_snake_knife_effects:OnIntervalThink()
    if not self:GetParent():IsAlive() then return end
    local level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_snake_knife_effects")
    if level < 40 then return end
    if not self.ability then return end

    local attacker = self:GetParent()
    local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for i, enemy in ipairs(enemies) do
        self:Snake(enemy)

        if i >= self.max then break end
    end

    local heroes = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
    for i, hero in ipairs(heroes) do
        self:SnakeAlly(hero)

        if i >= self.max_3+1 then break end
    end
end

function modifier_item_hd_snake_knife_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil}
    }
end

function modifier_item_hd_snake_knife_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.bonus_outgoing_add
end

function modifier_item_hd_snake_knife_effects:OnDeath(keys)
    if not IsServer() then return end
    if not self.ability then return end
    if self.level < 70 and keys.attacker ~= self:GetParent() then return end
    if self:GetParent():HasModifier("modifier_item_hd_snake_knife_effects_cd") then return end

    local attacker = self:GetParent()
    if not attacker:IsAlive() then return end
    local enemies = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    for i, enemy in ipairs(enemies) do
        self:Snake(enemy)

        if i >= self.max then break end
    end

    if self.level >= 30 then
        local heroes = FindUnitsInRadius(attacker:GetTeamNumber(), attacker:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
        for i, hero in ipairs(heroes) do
            self:SnakeAlly(hero)
    
            if i >= self.max_3+1 then break end
        end
    end
    attacker:AddNewModifier(attacker,self.ability,"modifier_item_hd_snake_knife_effects_cd",{duration = self.cd})
end

function modifier_item_hd_snake_knife_effects:Snake(target)
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local target = target
    if not target or not target:IsAlive() then return end
    
    local speed = 900
    local duration = self.duration
    local stack = self.stack
    local mana = self.mana

    -- 施放灵蛇冲击
    local snake_projectile = {
        Target = target,
        Source = caster,
        Ability = self.ability,
        EffectName = "particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_projectile.vpcf", -- 美杜莎的秘术异蛇特效
        iMoveSpeed = speed,
        bDodgeable = false,
        bProvidesVision = true,
        iVisionRadius = 100,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(snake_projectile)

    -- 处理命中效果
    local distance = CalculateDistance(caster,target)
    local delay = distance / speed

    caster:GameTimer(delay,function ()
        if not self then return end
        if not target or not target:IsAlive() then return end

        target:AddNewModifier(caster, self.ability, "modifier_item_hd_snake_knife_effects_debuff", {duration = duration,stack = stack})

        
        if self.level >= 10 then
            local params = {
                attacker = caster,
                target = target,
            }

            local damageindex_add = GetTotalDamageOutgoing(caster,params) or 0
            local damageindex_mult = GetOutgoingDamagePercentFinal(caster, params) or 1
            local final_index = (1+damageindex_add*0.01)*damageindex_mult*0.01
            local final_poison = math.min(target:GetMaxHealth()*self.poison_hp_1/final_index, 50000)
            target:Poison(caster,self.ability,final_poison)
        end
        if self.level >= 20 then
           caster:GiveMana(caster:GetMaxMana()*mana) 
        end
    end)

end   

function modifier_item_hd_snake_knife_effects:SnakeAlly(target)
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local target = target
    if not target or not target:IsAlive() then return end
    
    local speed = 900
    local gold_min = self.gold_min
    local gold_max = self.gold_max
    local random = math.random

    -- 施放灵蛇冲击
    local snake_projectile = {
        Target = target,
        Source = caster,
        Ability = self.ability,
        EffectName = "particles/econ/items/medusa/medusa_ti10_immortal_tail/medusa_ti10_crimson_proj_projectile_return.vpcf", -- 美杜莎的秘术异蛇特效
        iMoveSpeed = speed,
        bDodgeable = false,
        bProvidesVision = true,
        iVisionRadius = 100,
        iVisionTeamNumber = caster:GetTeamNumber(),
    }
    ProjectileManager:CreateTrackingProjectile(snake_projectile)

    -- 处理命中效果
    local distance = CalculateDistance(caster,target)
    local delay = distance / speed

    caster:GameTimer(delay,function ()
        if not self then return end
        if not target or not target:IsAlive() then return end
        local gold = random(gold_min,gold_max)
        target:ModifyGoldFiltered(gold,true,DOTA_ModifyGold_CreepKill)  --金币奖励
        SendOverheadEventMessage(nil, OVERHEAD_ALERT_GOLD  ,target, gold, nil)
    end)

end
-------------------------------------------------------------------------
modifier_item_hd_snake_knife_effects_debuff = advanced_modifier({})

function modifier_item_hd_snake_knife_effects_debuff:IsDebuff() return true end
function modifier_item_hd_snake_knife_effects_debuff:IsHidden() return false end
function modifier_item_hd_snake_knife_effects_debuff:IsPurgable() return false end
function modifier_item_hd_snake_knife_effects_debuff:GetTexture() return "item_artifact_43" end
function modifier_item_hd_snake_knife_effects_debuff:OnCreated(keys)
    if IsServer() then
        self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
    end
end

function modifier_item_hd_snake_knife_effects_debuff:OnRefresh(keys)
    if IsServer() then
        self.stack = keys.stack or 0
        self:SetStackCount(self.stack)
    end
end

function modifier_item_hd_snake_knife_effects_debuff:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_snake_knife_effects_debuff:Advanced_GetModifierSpellAmplifyBonus()   return -self:GetStackCount() end
-----------------------------------------------------------------
modifier_item_hd_snake_knife_effects_cd = advanced_modifier({})

function modifier_item_hd_snake_knife_effects_cd:IsDebuff() return true end
function modifier_item_hd_snake_knife_effects_cd:IsHidden() return true end
function modifier_item_hd_snake_knife_effects_cd:IsPurgable() return false end