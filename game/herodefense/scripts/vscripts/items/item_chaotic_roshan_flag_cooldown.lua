item_chaotic_roshan_flag_cooldown = class({})
LinkLuaModifier("modifier_item_chaotic_roshan_flag_cooldown", "items/item_chaotic_roshan_flag_cooldown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_cooldown_buff", "items/item_chaotic_roshan_flag_cooldown", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_cooldown_summon", "items/item_chaotic_roshan_flag_cooldown", LUA_MODIFIER_MOTION_NONE)
function item_chaotic_roshan_flag_cooldown:GetIntrinsicModifierName()
    return "modifier_item_chaotic_roshan_flag_cooldown"
end
function item_chaotic_roshan_flag_cooldown:GetCastRange()
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
---------------------------------
modifier_item_chaotic_roshan_flag_cooldown = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_cooldown:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_cooldown:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_cooldown:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_cooldown:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_positive_amp = self.ability:GetSpecialValueFor("bonus_positive_amp")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.buff_duration = 1.5 -- 略长于更新间隔，确保效果连续
    
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()  -- 立即执行一次
    end
end

function modifier_item_chaotic_roshan_flag_cooldown:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_DurationGain,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_roshan_flag_cooldown:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self.outgoing
end
function modifier_item_chaotic_roshan_flag_cooldown:Advanced_GetModifier_DurationGain()
    return self.bonus_positive_amp
end
function modifier_item_chaotic_roshan_flag_cooldown:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_roshan_flag_cooldown_summon", {})
end

function modifier_item_chaotic_roshan_flag_cooldown:OnIntervalThink()
    if not IsServer() then return end
    -- 抓取周围友军单位
    local allies = FindUnitsInRadius(
        self.parent:GetTeamNumber(),
        self.parent:GetAbsOrigin(),
        nil,
        self.radius,
        DOTA_UNIT_TARGET_TEAM_FRIENDLY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_INVULNERABLE,
        0,
        false
    )
    
    -- 为每个单位添加或刷新buff
    for _, ally in pairs(allies) do
        local final_modifier = ally:FindModifierByName("modifier_item_chaotic_roshan_flag_final_buff")
        if not final_modifier then
            local modifier = ally:FindModifierByName("modifier_item_chaotic_roshan_flag_cooldown_buff")
            if modifier then
                modifier:ForceRefresh()
                modifier:SetDuration(self.buff_duration,true)
            else
                ally:AddNewModifier(self.caster,self.ability,"modifier_item_chaotic_roshan_flag_cooldown_buff",{duration = self.buff_duration})
            end
        end
    end
end

---------------------------------
modifier_item_chaotic_roshan_flag_cooldown_summon = advanced_modifier({})    

function modifier_item_chaotic_roshan_flag_cooldown_summon:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_cooldown_summon:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_cooldown_summon:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_cooldown_summon:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_roshan_flag_cooldown_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_item_chaotic_roshan_flag_cooldown_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then self:Destroy() return end
    return -self.outgoing
end
---------------------------------
modifier_item_chaotic_roshan_flag_cooldown_buff = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_cooldown_buff:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_cooldown_buff:IsHidden() return false end
function modifier_item_chaotic_roshan_flag_cooldown_buff:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_cooldown_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.mp_regen = self.ability:GetSpecialValueFor("mp_regen")*0.01
    self.cd = self.ability:GetSpecialValueFor("cd")
end

function modifier_item_chaotic_roshan_flag_cooldown_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_chaotic_roshan_flag_cooldown_buff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return  self:AdvancedGetModifierConstantManaRegen()
	end
	if self._tooltip == 2 then
		return  self:Advanced_GetModifierCooldownReduction()
	end
end

function modifier_item_chaotic_roshan_flag_cooldown_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_roshan_flag_cooldown_buff:Advanced_GetModifierCooldownReduction()
    if not self:GetAbility() then self:Destroy() return end
    return self.cd
end
function modifier_item_chaotic_roshan_flag_cooldown_buff:AdvancedGetModifierConstantManaRegen()
    if not self:GetAbility() then self:Destroy() return end
    local regen = (self.parent:GetMaxMana() - self.parent:GetMana())*self.mp_regen
    return regen
end
