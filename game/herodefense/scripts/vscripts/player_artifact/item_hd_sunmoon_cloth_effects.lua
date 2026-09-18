-- 重做完成
item_hd_sunmoon_cloth_effects = class({})
LinkLuaModifier("modifier_item_hd_sunmoon_cloth_effects", "player_artifact/item_hd_sunmoon_cloth_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sunmoon_cloth_effects_lv20", "player_artifact/item_hd_sunmoon_cloth_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_sunmoon_cloth_effects_lv70", "player_artifact/item_hd_sunmoon_cloth_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_sunmoon_cloth_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_sunmoon_cloth_effects"
end

modifier_item_hd_sunmoon_cloth_effects = advanced_modifier({})

function modifier_item_hd_sunmoon_cloth_effects:IsDebuff() return false end
function modifier_item_hd_sunmoon_cloth_effects:IsHidden() return false end
function modifier_item_hd_sunmoon_cloth_effects:IsPurgable() return false end
function modifier_item_hd_sunmoon_cloth_effects:RemoveOnDeath() return false end
function modifier_item_hd_sunmoon_cloth_effects:GetTexture() return "item_artifact_26" end
function modifier_item_hd_sunmoon_cloth_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    
    self.bonus_mana_regen = self.ability:GetArtifactSpecialValueFor("bonus_mana_regen")
    self.mp_index = self.ability:GetArtifactSpecialValueFor("mp_index")*0.01
    self.time = self.ability:GetArtifactSpecialValueFor("time")
    self.time_3 = self.ability:GetArtifactSpecialValueFor("time_3")
    self.mp_index_1 = self.ability:GetArtifactSpecialValueFor("mp_index_1")*0.01
    self.mp_index = self.ability:GetArtifactSpecialValueFor("mp_index")*0.01
    self.recharge_4 = self.ability:GetArtifactSpecialValueFor("recharge_4")*0.01
    self.line_7 = self.ability:GetArtifactSpecialValueFor("line_7")*0.01
    self.time_10 = self.ability:GetArtifactSpecialValueFor("time_10")
    self.int_10 = self.ability:GetArtifactSpecialValueFor("int_10")
    self.level = GetArtifactLevel(self.parent:GetPlayerOwnerID(),"item_hd_sunmoon_cloth_effects")

    if self.level >= 10 then
        self.mp_index = self.mp_index_1
    end
    if self.level >= 30 then
        self.time = self.time_3 
    end
    if self.level >= 100 then
        self.time = self.time_10
    end

    local shield_max = self.parent:GetMaxMana()* self.mp_index + (self.level>=100 and self.int_10*self.parent:GetIntellect(false) or 0)
    self.recharge = 0
    
    if IsServer() then
        self:StartIntervalThink(1)
        self:OnIntervalThink()
        self:SetStackCount(shield_max)
    end
end

function modifier_item_hd_sunmoon_cloth_effects:OnRefresh(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    
    self.bonus_mana_regen = self.ability:GetArtifactSpecialValueFor("bonus_mana_regen")
    self.mp_index = self.ability:GetArtifactSpecialValueFor("mp_index")*0.01
    self.time = self.ability:GetArtifactSpecialValueFor("time")
    self.time_3 = self.ability:GetArtifactSpecialValueFor("time_3")
    self.mp_index_1 = self.ability:GetArtifactSpecialValueFor("mp_index_1")*0.01
    self.mp_index = self.ability:GetArtifactSpecialValueFor("mp_index")*0.01
    self.recharge_4 = self.ability:GetArtifactSpecialValueFor("recharge_4")*0.01
    self.line_7 = self.ability:GetArtifactSpecialValueFor("line_7")*0.01
    self.time_10 = self.ability:GetArtifactSpecialValueFor("time_10")
    self.int_10 = self.ability:GetArtifactSpecialValueFor("int_10")
    self.level = GetArtifactLevel(self.parent:GetPlayerOwnerID(),"item_hd_sunmoon_cloth_effects")

    if self.level >= 10 then
        self.mp_index = self.mp_index_1
    end
    if self.level >= 30 then
       self.time = self.time_3 
    end
    if self.level >= 100 then
        self.time = self.time_10
    end
end

function modifier_item_hd_sunmoon_cloth_effects:OnIntervalThink()
    local mp_index = self.mp_index
    local time = self.time --开始恢复所需的时间

    local shield_max = self.parent:GetMaxMana()*mp_index + (self.level>=100 and self.int_10*self.parent:GetIntellect(false) or 0) --最大盾值
    self.recharge = math.min((self.recharge + 1),time) --距离上一次受击的时间，oncreate的时候置0了，ontakedamage也会置0

    if self.recharge >= time then --不受击时间满足，开始持续恢复
        self:SetStackCount(math.min((self:GetStackCount()+shield_max*0.3),shield_max)) --这里是回复速度，需要自己设定。这边设定每秒回复30%
    end
    if self.level >= 20 then
        if self:GetStackCount() >= shield_max then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_hd_sunmoon_cloth_effects_lv20", {duration = 1.5}) --增伤效果
        end
    end
    if self.level >= 70 then
        if self:GetStackCount() >= self.parent:GetMaxMana()*self.line_7 then
            self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_hd_sunmoon_cloth_effects_lv70", {duration = 1.5}) --增伤效果
        end
    end
end

function modifier_item_hd_sunmoon_cloth_effects:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},
        MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK = {nil, self:GetParent()},
        MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
    }
    return funcs
end

function modifier_item_hd_sunmoon_cloth_effects:AdvancedGetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_item_hd_sunmoon_cloth_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.unit
    if attacker:GetTeamNumber() == self.parent:GetTeamNumber() then return end
    if target ~= self.parent then return end
    self.recharge = 0
end

function modifier_item_hd_sunmoon_cloth_effects:OnDeath(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if attacker ~= self.parent then return end
    if self.level< 40 then return end
    local shield_max = self.parent:GetMaxMana()*self.mp_index + (self.level>=100 and self.int_10*self.parent:GetIntellect(false) or 0)
    local lost_shield = math.max(shield_max - self:GetStackCount(),0)

    self:SetStackCount(math.min((self:GetStackCount()+lost_shield*self.recharge_4),shield_max))
end

function modifier_item_hd_sunmoon_cloth_effects:AdvancedGetModifierTotal_ConstantBlock(keys)
    if not IsServer() then return self:GetStackCount() end
    local stack = self:GetStackCount()
    if stack <= 0 then
        self:SafeDestroy()
        return 0
    end
    if keys.damage > self:GetStackCount() then
        self:SetStackCount(0)
    else
        local now_stack = self:GetStackCount() - math.floor(math.max(0, keys.damage))
        self:SetStackCount(math.floor(now_stack))
        stack = keys.damage
    end
    return stack
end

modifier_item_hd_sunmoon_cloth_effects_lv20 = advanced_modifier({})

function modifier_item_hd_sunmoon_cloth_effects_lv20:IsDebuff() return false end
function modifier_item_hd_sunmoon_cloth_effects_lv20:IsHidden() return true end
function modifier_item_hd_sunmoon_cloth_effects_lv20:IsPurgable() return false end
function modifier_item_hd_sunmoon_cloth_effects_lv20:GetTexture() return "item_artifact_26" end

function modifier_item_hd_sunmoon_cloth_effects_lv20:OnCreated()
    self.spell_amp = self:GetAbility():GetArtifactSpecialValueFor("spell_amp_2")
end
function modifier_item_hd_sunmoon_cloth_effects_lv20:OnRefresh()
    self.spell_amp = self:GetAbility():GetArtifactSpecialValueFor("spell_amp_2")
end

function modifier_item_hd_sunmoon_cloth_effects_lv20:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
    }
    return funcs
end

function modifier_item_hd_sunmoon_cloth_effects_lv20:Advanced_GetModifierSpellAmplifyBonus()
    if not self:GetAbility() then return end
    return self.spell_amp
end

modifier_item_hd_sunmoon_cloth_effects_lv70 = advanced_modifier({})

function modifier_item_hd_sunmoon_cloth_effects_lv70:IsDebuff() return false end
function modifier_item_hd_sunmoon_cloth_effects_lv70:IsHidden() return true end
function modifier_item_hd_sunmoon_cloth_effects_lv70:IsPurgable() return false end
function modifier_item_hd_sunmoon_cloth_effects_lv70:GetTexture() return "item_artifact_26" end

function modifier_item_hd_sunmoon_cloth_effects_lv70:OnCreated()
    self.ability = self:GetAbility()
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")
end
function modifier_item_hd_sunmoon_cloth_effects_lv70:OnRefresh()
    self.outgoing_7 = self.ability:GetArtifactSpecialValueFor("outgoing_7")
end

function modifier_item_hd_sunmoon_cloth_effects_lv70:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_hd_sunmoon_cloth_effects_lv70:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then return end
    return self.outgoing_7
end