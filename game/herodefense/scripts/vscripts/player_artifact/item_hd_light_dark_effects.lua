-- 重做完成
item_hd_light_dark_effects = class({})
LinkLuaModifier("modifier_item_hd_light_dark_effects", "player_artifact/item_hd_light_dark_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_light_dark_effects_debuff", "player_artifact/item_hd_light_dark_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_light_dark_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_light_dark_effects"
end

function item_hd_light_dark_effects:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", context )
end

modifier_item_hd_light_dark_effects = advanced_modifier({})

function modifier_item_hd_light_dark_effects:IsDebuff() return false end
function modifier_item_hd_light_dark_effects:IsHidden() return self.level < 40 end
function modifier_item_hd_light_dark_effects:IsPurgable() return false end
function modifier_item_hd_light_dark_effects:RemoveOnDeath() return false end
function modifier_item_hd_light_dark_effects:GetTexture() return "item_hd_artifact_66" end
function modifier_item_hd_light_dark_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.cost = self.ability:GetSpecialValueFor("cost")
    self.cost_get = self.ability:GetSpecialValueFor("cost_get")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.damage_dot = self.ability:GetSpecialValueFor("damage_dot")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.interval = self.ability:GetSpecialValueFor("interval")
    self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
    self.damage_1 = self.ability:GetSpecialValueFor("damage_1")
    self.damage_dot_2 = self.ability:GetSpecialValueFor("damage_dot_2")
    self.chance_3 = self.ability:GetSpecialValueFor("chance_3")
    self.radius_4 = self.ability:GetSpecialValueFor("radius_4")
    self.atb_4 = self.ability:GetSpecialValueFor("atb_4")
    self.chance_4 = self.ability:GetSpecialValueFor("chance_4")
    self.interval_7 = self.ability:GetSpecialValueFor("interval_7")
    self.damage_10 = self.ability:GetSpecialValueFor("damage_10")*0.01

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_light_dark_effects")

    if self.level >= 10 then
       self.damage = self.damage_1 
    end
    if self.level >= 20 then
       self.damage_dot = self.damage_dot_2 
    end

    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
    self.check_70 = 0
end

function modifier_item_hd_light_dark_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.caster = self:GetCaster()
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.cost = self.ability:GetSpecialValueFor("cost")
    self.cost_get = self.ability:GetSpecialValueFor("cost_get")
    self.damage = self.ability:GetSpecialValueFor("damage")
    self.damage_dot = self.ability:GetSpecialValueFor("damage_dot")
    self.duration = self.ability:GetSpecialValueFor("duration")
    self.interval = self.ability:GetSpecialValueFor("interval")
    self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")

    self.damage_1 = self.ability:GetSpecialValueFor("damage_1")
    self.damage_dot_2 = self.ability:GetSpecialValueFor("damage_dot_2")
    self.chance_3 = self.ability:GetSpecialValueFor("chance_3")
    self.radius_4 = self.ability:GetSpecialValueFor("radius_4")
    self.atb_4 = self.ability:GetSpecialValueFor("atb_4")
    self.chance_4 = self.ability:GetSpecialValueFor("chance_4")
    self.interval_7 = self.ability:GetSpecialValueFor("interval_7")
    self.damage_10 = self.ability:GetSpecialValueFor("damage_10")*0.01

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_light_dark_effects")

    if self.level >= 10 then
       self.damage = self.damage_1 
    end
    if self.level >= 20 then
       self.damage_dot = self.damage_dot_2 
    end
end

function modifier_item_hd_light_dark_effects:OnIntervalThink()
    if not IsServer() then return end
    if not self.caster:IsAlive() then return end
    
    if self.level >= 70 then
        self.check_70 = self.check_70 + self.interval
        if self.check_70 >= self.interval_7 then
           self.check_70 = 0
           self:SetStackCount(self:GetStackCount() + 1) 

           local enemies = FindUnitsInRadius(
            self.caster:GetTeamNumber(),
            self.caster:GetAbsOrigin(),
            nil,
            self.radius_4,
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_CLOSEST,
            false
            )
        
            for _,enemy in pairs(enemies) do
                self:ApplyLightDarkEffect(enemy)
            end
        end
    end
    
    local trigger_points = self.caster:GetModifierStackCount("modifier_hd_trigger", self.caster)
    if not trigger_points or trigger_points < self.cost then return end

    local enemies = FindUnitsInRadius(
        self.caster:GetTeamNumber(),
        self.caster:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
    )

    if self.level >= 40 and #GetAllRealHeroes() <= 1 then
        local random = math.random
        
        if self.chance_4 >= random(1,100) then
            if #enemies > 0 then
                for _,enemy in pairs(enemies) do
                    self:ApplyLightDarkEffect(enemy)  
                end
                self:SetStackCount(self:GetStackCount() + 1)
            end
        else
            if #enemies > 0 then
                self:ApplyLightDarkEffect(enemies[1])
                self.caster:SetModifierStackCount("modifier_hd_trigger", self.caster, trigger_points - self.cost)
            end
        end
    else
        if #enemies > 0 then
            self:ApplyLightDarkEffect(enemies[1])
            self.caster:SetModifierStackCount("modifier_hd_trigger", self.caster, trigger_points - self.cost)
        end
    end
end

function modifier_item_hd_light_dark_effects:ApplyLightDarkEffect(target)
    if not IsServer() then return end
    if (not target) or (not IsEnemy(self.caster, target)) then return end
    
    if not self.caster:IsAlive() then return end
    local primary_stat = self.caster:HDGetPrimaryStatValue()
    local damage = primary_stat * self.damage
    local dot_damage = primary_stat * self.damage_dot
    
    

    if self.level >= 100 then
        local all_damagetable = {
            victim = target,
            attacker = self.caster,
            damage = (damage + dot_damage)*self.damage_10,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE + HD_DAMAGE_FLAG_DOT,
        }
        target:ApplyMergeDamage(all_damagetable)

        local particle = ParticleManager:CreateParticle(
            "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf",
            PATTACH_ABSORIGIN_FOLLOW,
            target
        )
        ParticleManager:ReleaseParticleIndex(particle)
    else

        local light_damagetable = {
            victim = target,
            attacker = self.caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self.ability,
            damage_flags = DOTA_DAMAGE_FLAG_NONE,
            hd_flags = HD_DAMAGE_FLAG_HOLY_DAMAGE,
        }
        target:ApplyMergeDamage(light_damagetable)

        target:AddNewModifier(
        self.caster,
        self.ability,
        "modifier_item_hd_light_dark_effects_debuff",
        {
            duration = self.duration,
            dot_damage = dot_damage
        }
    )
    end
    
    -- Effects
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:ReleaseParticleIndex(particle)
    target:EmitSoundParams("Hero_Omniknight.Purification", 0, 0.3, 0)
end

function modifier_item_hd_light_dark_effects:ADDeclareFunctions()
    return{
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end

function modifier_item_hd_light_dark_effects:DeclareFunctions()
    return{
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_light_dark_effects:Advanced_GetModifierSpellAmplifyBonus()
    return self.spell_amp
end
function modifier_item_hd_light_dark_effects:Advanced_GetModifierBonusStats_Strength()
    return self.atb_4 *self:GetStackCount()
end
function modifier_item_hd_light_dark_effects:Advanced_GetModifierBonusStats_Agility()
    return self.atb_4 *self:GetStackCount()
end
function modifier_item_hd_light_dark_effects:Advanced_GetModifierBonusStats_Intellect()
    return self.atb_4 *self:GetStackCount()
end
function modifier_item_hd_light_dark_effects:OnTooltip()
    return self.atb_4 *self:GetStackCount()
end

function modifier_item_hd_light_dark_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    if keys.attacker ~= self.caster then return end
    local unit = keys.unit
    local ability = keys.inflictor
    
    if IsDarkDamage(keys) or IsHolyDamage(keys) then
        self.caster:AddNewModifier(self.caster, self.ability, "modifier_hd_trigger", {cost_get = self.cost_get})
    end

    if self.level >= 30 and ability and ability ~= self.ability then
        if not unit:IsAlive() then return end
        local random = math.random
        if self.chance_3 >= random(1,100) then
            self:ApplyLightDarkEffect(unit)
        end
    end
end

function modifier_item_hd_light_dark_effects:OnDeath(keys)
    if not IsServer() then return end
    if self.level < 40 then return end
    local unit = keys.unit
    if unit:IsRealHero() and not IsEnemy(self.caster, unit) then
       self:SetStackCount(self:GetStackCount() + 1) 

       local enemies = FindUnitsInRadius(
        unit:GetTeamNumber(),
        unit:GetAbsOrigin(),
        nil,
        self.radius_4,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST,
        false
        )
    
        for _,enemy in pairs(enemies) do
            self:ApplyLightDarkEffect(enemy)
        end
    end
end
------------
modifier_item_hd_light_dark_effects_debuff = advanced_modifier({})

function modifier_item_hd_light_dark_effects_debuff:IsDebuff() return true end
function modifier_item_hd_light_dark_effects_debuff:IsHidden() return false end
function modifier_item_hd_light_dark_effects_debuff:IsPurgable() return false end
function modifier_item_hd_light_dark_effects_debuff:GetTexture() return "item_hd_artifact_66" end
function modifier_item_hd_light_dark_effects_debuff:OnCreated(keys)
    if not IsServer() then return end
    
    self.dot_damage = self:GetStackCount() + math.floor(keys.dot_damage)
    self:SetStackCount(self.dot_damage)

    self.damagetable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = math.floor(self:GetStackCount()/self:GetRemainingTime()),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_DOT
    }
    self:StartIntervalThink(1.0)
end

function modifier_item_hd_light_dark_effects_debuff:OnRefresh(keys)
    if not IsServer() then return end
    
    self.dot_damage = self:GetStackCount() + math.floor(keys.dot_damage)
    self:SetStackCount(self.dot_damage)

    self.damagetable = {
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = math.floor(self:GetStackCount()/self:GetRemainingTime()),
        damage_type = DAMAGE_TYPE_MAGICAL,
        ability = self:GetAbility(),
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
    }
    self:StartIntervalThink(1.0)
end

function modifier_item_hd_light_dark_effects_debuff:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    
    local stack = self:GetStackCount()

    ApplyDamage(self.damagetable)
    self:SetStackCount(stack - self.damagetable.damage)
    
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetParent()
    )
    ParticleManager:ReleaseParticleIndex(particle)
end