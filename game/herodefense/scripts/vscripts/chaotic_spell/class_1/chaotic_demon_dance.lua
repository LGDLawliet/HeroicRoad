--鬼人乱舞
LinkLuaModifier("modifier_chaotic_demon_dance", "chaotic_spell/class_1/chaotic_demon_dance.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_hd_backstab", "chaotic_spell/class_1/chaotic_stealth.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_demon_dance = class({})

function chaotic_demon_dance:OnSpellStart()
    local caster = self:GetCaster()
    local duration = self:GetSpecialValueFor("duration")
    local count = self:GetSpecialValueFor("count")
    print("duration", duration, "....count", count)
    -- Apply the modifier to the caster
    caster:AddNewModifier(caster, self, "modifier_chaotic_demon_dance", {duration = duration, count = count})
end


---@type CDOTA_Modifier_Lua
modifier_chaotic_demon_dance = class({})

function modifier_chaotic_demon_dance:IsHidden() return false end
function modifier_chaotic_demon_dance:IsDebuff() return false end
function modifier_chaotic_demon_dance:IsPurgable() return false end

function modifier_chaotic_demon_dance:OnCreated(kv)
    self.count = self:GetAbility():GetSpecialValueFor("count")
    if IsServer() then
        self:StartIntervalThink(1.0)
    end
end

function modifier_chaotic_demon_dance:CheckState()
    local state = {
        [MODIFIER_STATE_ROOTED] = true,
    }
    return state
end

function modifier_chaotic_demon_dance:OnIntervalThink()
    if IsServer() then
        local caster = self:GetCaster()
        local enemies = FindUnitsInRadius(
            caster:GetTeamNumber(),
            caster:GetAbsOrigin(),
            nil,
            self:GetAbility():GetSpecialValueFor("radius"),
            DOTA_UNIT_TARGET_TEAM_ENEMY,
            DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            DOTA_UNIT_TARGET_FLAG_NONE,
            FIND_ANY_ORDER,
            false
        )
        print("#enemies", #enemies)
        for i = 1, math.min(#enemies, self.count) do
            print("enemies:"..i, enemies[i])
            caster:PerformAttack(enemies[i], true, true, true, true, false, false, true)
            local modifier = caster:FindModifierByName("modifier_hd_backstab")
            if not modifier then  -- 检查是否存在
                modifier = caster:AddNewModifier(caster, self:GetAbility(), "modifier_hd_backstab", {duration = -1})
            end
            if modifier:IsBackstab(caster, enemies[i], 135) or math.random(1, 100) <= 25 then
                modifier:IncreaseStackCount()
            end
        end
    end
    return 1.0
end

function modifier_chaotic_demon_dance:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end

function modifier_chaotic_demon_dance:OnTooltip()
    return self.count
end
