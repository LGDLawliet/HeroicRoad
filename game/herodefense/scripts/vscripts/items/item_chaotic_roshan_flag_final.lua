item_chaotic_roshan_flag_final = class({})
LinkLuaModifier("modifier_item_chaotic_roshan_flag_final", "items/item_chaotic_roshan_flag_final", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_final_buff", "items/item_chaotic_roshan_flag_final", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_roshan_flag_final_summon", "items/item_chaotic_roshan_flag_final", LUA_MODIFIER_MOTION_NONE)
function item_chaotic_roshan_flag_final:GetIntrinsicModifierName()
    return "modifier_item_chaotic_roshan_flag_final"
end
function item_chaotic_roshan_flag_final:GetCastRange()
    return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end
---------------------------------
modifier_item_chaotic_roshan_flag_final = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_final:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_final:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_final:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_final:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_positive_amp = self.ability:GetSpecialValueFor("bonus_positive_amp")
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
    self.armor = self.ability:GetSpecialValueFor("armor")*0.01
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.index = self.ability:GetSpecialValueFor("index")*0.01
    self.buff_duration = 3.5  -- 略长于更新间隔，确保效果连续
    
    if IsServer() then
        self:StartIntervalThink(3.0)
        self:OnIntervalThink()  -- 立即执行一次
    end
end

function modifier_item_chaotic_roshan_flag_final:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_DurationGain,
        MODIFIER_EVENT_ON_SUMMON = { self:GetParent(), nil },
    }
end

function modifier_item_chaotic_roshan_flag_final:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -self.outgoing
end
function modifier_item_chaotic_roshan_flag_final:Advanced_GetModifier_DurationGain()
    return self.bonus_positive_amp
end
function modifier_item_chaotic_roshan_flag_final:AdvancedOnSummon(keys)
    if not IsServer() then return end
    if keys.unit ~= self.parent then return end
    if not IsValid(keys.target) then return end
    keys.target:AddNewModifier(self.parent, self.ability, "modifier_item_chaotic_roshan_flag_final_summon", {})
end

function modifier_item_chaotic_roshan_flag_final:OnIntervalThink()
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
        local modifier = ally:FindModifierByName("modifier_item_chaotic_roshan_flag_final_buff")
        if modifier then
            modifier:Destroy()
        end
        local damage_bonus = self.caster:HDGetPrimaryStatValue() * self.index
        local current_armor = ally:GetPhysicalArmorValue(false)
        local armor = current_armor*self.armor
        
        ally:AddNewModifier(self.caster,self.ability,"modifier_item_chaotic_roshan_flag_final_buff",{duration = self.buff_duration,armor = armor,damage_bonus = damage_bonus})
    end
end

---------------------------------
modifier_item_chaotic_roshan_flag_final_summon = advanced_modifier({})    

function modifier_item_chaotic_roshan_flag_final_summon:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_final_summon:IsHidden() return true end
function modifier_item_chaotic_roshan_flag_final_summon:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_final_summon:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()

    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_roshan_flag_final_summon:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_item_chaotic_roshan_flag_final_summon:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then self:Destroy() return end
    return -self.outgoing
end
---------------------------------
modifier_item_chaotic_roshan_flag_final_buff = advanced_modifier({})
function modifier_item_chaotic_roshan_flag_final_buff:IsDebuff() return false end
function modifier_item_chaotic_roshan_flag_final_buff:IsHidden() return false end
function modifier_item_chaotic_roshan_flag_final_buff:IsPurgable() return false end

function modifier_item_chaotic_roshan_flag_final_buff:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.mp_regen = self.ability:GetSpecialValueFor("mp_regen")*0.01
    self.cd = self.ability:GetSpecialValueFor("cd")
    if IsServer() then
        self.armor = keys.armor
        self.damage_bonus = keys.damage_bonus
        self:SetHasCustomTransmitterData( true )-- 同步cy
    end
end

function modifier_item_chaotic_roshan_flag_final_buff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP,
    }
end
function modifier_item_chaotic_roshan_flag_final_buff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 4 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierPhysicalArmorBonus()
	end
    if self._tooltip == 2 then
		return  self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
	end
    if self._tooltip == 3 then
		return  self:AdvancedGetModifierConstantManaRegen()
	end
    if self._tooltip == 4 then
		return  self:Advanced_GetModifierCooldownReduction()
	end
end

function modifier_item_chaotic_roshan_flag_final_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_COOLDOWN_REDUCTION,
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
end

function modifier_item_chaotic_roshan_flag_final_buff:Advanced_GetModifierCooldownReduction()
    if not self:GetAbility() then self:Destroy() return end
    return self.cd
end
function modifier_item_chaotic_roshan_flag_final_buff:AdvancedGetModifierConstantManaRegen()
    if not self:GetAbility() then self:Destroy() return end
    local regen = (self.parent:GetMaxMana() - self.parent:GetMana())*self.mp_regen
    return regen
end
function modifier_item_chaotic_roshan_flag_final_buff:Advanced_GetModifierPhysicalArmorBonus()
    if not self:GetAbility() then self:Destroy() return end
    return self.armor
end
function modifier_item_chaotic_roshan_flag_final_buff:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.damage_bonus
end


function modifier_item_chaotic_roshan_flag_final_buff:AddCustomTransmitterData( )
	return
	{
		armor = self.armor,
		damage_bonus = self.damage_bonus,
	}
end

function modifier_item_chaotic_roshan_flag_final_buff:HandleCustomTransmitterData( data )
	self.armor = data.armor
	self.damage_bonus = data.damage_bonus

end
