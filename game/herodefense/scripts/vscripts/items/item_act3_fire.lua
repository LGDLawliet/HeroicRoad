
LinkLuaModifier("modifier_item_act3_fire", "items/item_act3_fire.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_fire_charge_cd", "items/item_act3_fire.lua", LUA_MODIFIER_MOTION_NONE)

item_act3_fire = class({})

function item_act3_fire:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", context)
end

function item_act3_fire:Spawn()
    if IsServer() then
        self:SetCurrentCharges(0)
        if IsInToolsMode() then
            self:SetCurrentCharges(90)
        end
    end
end

function item_act3_fire:GetIntrinsicModifierName()
    return "modifier_item_act3_fire"
end

-- 主修饰器
modifier_item_act3_fire = advanced_modifier({})

function modifier_item_act3_fire:IsHidden() return true end
function modifier_item_act3_fire:IsDebuff() return false end
function modifier_item_act3_fire:IsPurgable() return false end
function modifier_item_act3_fire:RemoveOnDeath() return false end

function modifier_item_act3_fire:OnCreated()
    
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        
        -- 基础参数
        self.point_damage = self.ability:GetSpecialValueFor("point_damage")
        self.need = self.ability:GetSpecialValueFor("need")
        self.check2 = self.ability:GetSpecialValueFor("check2")
        self.cooldown_2 = self.ability:GetSpecialValueFor("cooldown_2")
        self.outgoing_2 = self.ability:GetSpecialValueFor("outgoing_2")
        self.check3 = self.ability:GetSpecialValueFor("check3")
        self.hpdamage_3 = self.ability:GetSpecialValueFor("hpdamage_3")*0.01
        self.check4 = self.ability:GetSpecialValueFor("check4")
        self.attack_4 = self.ability:GetSpecialValueFor("attack_4")
        self.spell_4 = self.ability:GetSpecialValueFor("spell_4")
        self.summon_4 = self.ability:GetSpecialValueFor("summon_4")
        self.interval_4 = self.ability:GetSpecialValueFor("interval_4")
        self.radius_4 = self.ability:GetSpecialValueFor("radius_4")
        
        -- 炎爆术参数

        self.damage_radius = 320
        self.damage_atk_index = 1.1
        self.damage_atb_index = 5
        self.base_damage = 100
        self.bonus_damage_pct = 0.03
        self.cd = 3.5
    if IsServer() then 
        self.event_number = 0
        -- 自动触发技能
        self:StartIntervalThink(self.interval_4)
    end
end

function modifier_item_act3_fire:OnIntervalThink()
    if not IsServer() then return end
    if not self.ability or not self.parent:IsAlive() then return end
    
    -- %check4%灵能点被动：伊芙利特之赐
    if self.ability:GetCurrentCharges() >= self.check4 then
        local random_num = 1
        local random = math.random
        for i = 1, random_num do
            local angle = math.random() * 2 * math.pi
            local distance = random(1, self.radius_4/2)
            local offset = Vector(math.cos(angle) * distance, math.sin(angle) * distance, 0)
            local random_pos = self.parent:GetAbsOrigin() + offset
                    
            -- 确保位置在地面上
            random_pos = GetGroundPosition(random_pos, nil)
            self:FireExplosion(random_pos)
        end
    end
end

function modifier_item_act3_fire:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_item_act3_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.ability:GetSpecialValueFor("point_damage")*self.ability:GetCurrentCharges()
end

function modifier_item_act3_fire:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(event)
    if not IsServer() then return end
    if not self.ability then return end
    local unit = event.target
    if not self.parent:IsAlive() then return end 
    local outgoing = 0
    if not self.parent:HasModifier("modifier_item_act3_fire_charge_cd") and event.inflictor ~= self.ability then
        local flags = event.damage_flags
        if  bit.band( flags, DOTA_DAMAGE_FLAG_REFLECTION ) ~= DOTA_DAMAGE_FLAG_REFLECTION and 
            bit.band( flags, DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT  ) ~= DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT and
            bit.band( flags, DOTA_DAMAGE_FLAG_HPLOSS   ) ~= DOTA_DAMAGE_FLAG_HPLOSS   then  
            self:FireExplosion(unit:GetAbsOrigin())
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_act3_fire_charge_cd", {duration = self.cd})
        end
    end
    if self.ability:GetCurrentCharges() >= self.check2 then
        outgoing = self.outgoing_2
    end
    return outgoing
end

function modifier_item_act3_fire:Advanced_GetModifierDamageOutgoing_Percentage()
    -- %check4%灵能点被动：伊芙利特之赐
    if self.ability:GetCurrentCharges() >= self.check4 then
        return self.attack_4
    end
    return 0
end

function modifier_item_act3_fire:Advanced_GetModifierSpellAmplifyBonus()
    -- %check4%灵能点被动：伊芙利特之赐
    if self.ability:GetCurrentCharges() >= self.check4 then
        return self.spell_4
    end
    return 0
end

function modifier_item_act3_fire:advanced_MODIFIER_PROPERTY_Summon_Intensity()
    -- %check4%灵能点被动：伊芙利特之赐
    if self.ability:GetCurrentCharges() >= self.check4 then
        return self.summon_4
    end
    return 0
end

function modifier_item_act3_fire:Advanced_GetModifierCooldownReduction()
    -- %check2%灵能点被动：爆燃之火
    if self.ability:GetCurrentCharges() >= self.check2 then
        return -self.cooldown_2
    end
    return 0
end

function modifier_item_act3_fire:GrowEvent()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.ability:SetCurrentCharges(math.max(math.min(self.ability:GetCurrentCharges()+1, GetWave()*5), 1))
end

function modifier_item_act3_fire:FireExplosion(location)
    if not IsServer() then return end
    if not self.ability then return end
    if not self.parent:IsAlive() then return end 
    if not location then return end
    
    self.event_number = self.event_number + 1
    if self.event_number >= self.need then
        self.event_number = 0
        self:GrowEvent()
    end

    local caster = self.parent
    local adaptdamagetable = GetAdaptDamage(caster:GetAverageTrueAttackDamage(nil), self.damage_atk_index, caster:HDGetPrimaryStatValue(), self.damage_atb_index)
    local damage = (self.base_damage + adaptdamagetable.damage) * (1+self.ability:GetCurrentCharges()*self.bonus_damage_pct)
    local damage_type = adaptdamagetable.type
    
    -- 创建炎爆术特效
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf"
	local sound_cast = "Ability.LightStrikeArray"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, location )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( location, sound_cast, caster ) 
    
    -- 查找范围内的敌人
    local enemies = FindUnitsInRadius(
        caster:GetTeamNumber(),
        location,
        nil,
        self.damage_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )
    local damage_table = {
            --victim = enemy,
            attacker = caster,
            damage = damage,
            damage_type = damage_type,
            ability = self.ability,
            damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_NO_DIRECTOR_EVENT,
            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
    }
    
    -- 对敌人造成伤害
    for _, enemy in ipairs(enemies) do
        damage_table.victim = enemy
        -- %check3%灵能点被动：破灭之火
        if self.ability:GetCurrentCharges() >= self.check3 then
            local hp_damage = math.min(enemy:GetHealth() * self.hpdamage_3, 50000)
            damage_table.damage = damage_table.damage + hp_damage
        end
        
        ApplyDamage(damage_table)
    end
end

-----
modifier_item_act3_fire_charge_cd = advanced_modifier({})

function modifier_item_act3_fire_charge_cd:IsHidden() return true end
function modifier_item_act3_fire_charge_cd:IsDebuff() return false end
function modifier_item_act3_fire_charge_cd:IsPurgable() return false end
function modifier_item_act3_fire_charge_cd:RemoveOnDeath() return false end
function modifier_item_act3_fire_charge_cd:GetTexture() return "item_act3_fire" end
