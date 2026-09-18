
Primary_arcana = class({})
--LINK TO PARTICLE
function Primary_arcana:Precache( context )
    PrecacheResource( "particle", "particles/arcana_buff.vpcf", context )
end

function Primary_arcana:OnSpellStart()
    -- Ability properties
    local caster = self:GetCaster()
    local target = self:GetCursorTarget() 
    local sound_cast = "arcana_card_draw" --probably ogremagi multi cast? sounds/weapons/hero/ogre_magi/multicast01.vsnd   
    EmitSoundOn(sound_cast, caster)    

    local particle1 = ParticleManager:CreateParticle("particles/arcana_buff.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
    DestroyParticleByDelay(particle1,2.5)

    local ran = RandomInt(1, 8)
    --1 = high priestess (heal self)
    --2 = magician (int)
    --3 = strength (str)
    --4 = the hanged man (slow)
    --5 = chariot (MS)
    --6 = the lovers (heal, aoe)
    --7 =  wheel of fortune (gain gold)
    --8 = justice (set health to half, self)

    -- apply modifier 'ran'
    if ran == 1 then
        local newhealthamount = (caster:GetHealth() + (self:GetSpecialValueFor("heal") + caster:GetMaxHealth() * self:GetSpecialValueFor("heal_scale_max_health") / 100))
        if newhealthamount > caster:GetMaxHealth() then
            caster:SetHealth(caster:GetMaxHealth())
        else
            caster:SetHealth(newhealthamount)
        end
    elseif ran == 2 then
        target:AddNewModifier(caster, self, "modifier_arcana_magician", {duration = self:GetSpecialValueFor("buff_duration")})
    elseif ran == 3 then
        target:AddNewModifier(caster, self, "modifier_arcana_strength", {duration = self:GetSpecialValueFor("buff_duration")})
    elseif ran == 4 then
        target:AddNewModifier(caster, self, "modifier_arcana_hanged_man", {duration = self:GetSpecialValueFor("ms_duration")})
    elseif ran == 5 then
        target:AddNewModifier(caster, self, "modifier_arcana_chariot", {duration = self:GetSpecialValueFor("ms_duration")})
    elseif ran == 6 then
        local allies = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, self:GetSpecialValueFor("heal_aoe"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)

        for _, enemy in pairs(allies) do
            if IsValidEntity(enemy) and enemy:IsAlive() then
                local newhealthamount = (enemy:GetHealth() + (self:GetSpecialValueFor("heal") + enemy:GetMaxHealth() * self:GetSpecialValueFor("heal_scale_max_health") / 100))
                if newhealthamount > enemy:GetMaxHealth() then
                    enemy:SetHealth(enemy:GetMaxHealth())
                else
                    enemy:SetHealth(newhealthamount)
                end
            end
        end
    elseif ran == 7 then
        local playerID = caster:GetPlayerID() 
        local goldAmount = self:GetSpecialValueFor("gold_gained") 

        PlayerResource:ModifyGold(playerID, goldAmount, true, DOTA_ModifyGold_Unspecified)
    elseif ran == 8 then
        caster:SetHealth(caster:GetHealth() * self:GetSpecialValueFor("justice_health"))
    end
end

LinkLuaModifier("modifier_arcana_hanged_man", "Primary_arcana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcana_chariot", "Primary_arcana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcana_magician", "Primary_arcana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_arcana_strength", "Primary_arcana", LUA_MODIFIER_MOTION_NONE)

modifier_arcana_hanged_man = advanced_modifier({})
function modifier_arcana_hanged_man:IsDebuff()
    return true
end
function modifier_arcana_hanged_man:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function modifier_arcana_hanged_man:OnCreated(keys)
    local ability = self:GetAbility()

    if ability and not ability:IsNull() then
        self.duration = self:GetAbility():GetSpecialValueFor("ms_duration")
        self.slow = self:GetAbility():GetSpecialValueFor("slow")
    end
end

function modifier_arcana_hanged_man:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_arcana_hanged_man:GetDuration()
    return self.duration
end

modifier_arcana_chariot = advanced_modifier({})
function modifier_arcana_chariot:IsDebuff()
    return true
end
function modifier_arcana_chariot:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
    return funcs
end

function modifier_arcana_chariot:OnCreated(keys)
    local ability = self:GetAbility()

    if ability and not ability:IsNull() then
        self.duration = self:GetAbility():GetSpecialValueFor("ms_duration")
        self.slow = self:GetAbility():GetSpecialValueFor("ms_boost")
    end
end

function modifier_arcana_chariot:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_arcana_chariot:GetDuration()
    return self.duration
end

modifier_arcana_strength = advanced_modifier({})

function modifier_arcana_strength:OnCreated(keys)
    local ability = self:GetAbility()

    if ability and not ability:IsNull() then
        self.duration = self:GetAbility():GetSpecialValueFor("buff_duration")
        self.str_mult = self:GetAbility():GetSpecialValueFor("buff_strength_times_level")
    end
end

function modifier_arcana_strength:IsBuff()
    return true
end

function modifier_arcana_strength:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
    }
    return funcs
end

function modifier_arcana_strength:GetModifierBonusStats_Strength()
    return self.str_mult * self:GetParent():GetLevel()
end

function modifier_arcana_strength:GetDuration()
    return self.duration
end

modifier_arcana_magician = advanced_modifier({})

function modifier_arcana_magician:IsBuff()
    return true
end

function modifier_arcana_magician:OnCreated(keys)
    local ability = self:GetAbility()

    if ability and not ability:IsNull() then
        self.duration = self:GetAbility():GetSpecialValueFor("buff_duration")
        self.int_mult = self:GetAbility():GetSpecialValueFor("buff_int_times_level")
    end
end

function modifier_arcana_magician:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, -- Change to modify intellect bonus
    }
    return funcs
end

function modifier_arcana_magician:GetModifierBonusStats_Intellect() -- Change to get intellect bonus
    return self.int_mult * self:GetParent():GetLevel() -- Multiply intelligence multiplier with caster's level
end

function modifier_arcana_magician:GetDuration()
    return self.duration
end