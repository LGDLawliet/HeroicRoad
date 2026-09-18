item_chaotic_element_stone = class({})
LinkLuaModifier("modifier_item_chaotic_element_stone", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_element_stone_active1", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_element_stone_active2", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_element_stone_active3", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_element_stone_active4", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_chaotic_element_stone_active5", "items/item_chaotic_element_stone", LUA_MODIFIER_MOTION_NONE)
function item_chaotic_element_stone:GetIntrinsicModifierName()
    return "modifier_item_chaotic_element_stone"
end
---------------------------------
modifier_item_chaotic_element_stone = advanced_modifier({})
function modifier_item_chaotic_element_stone:IsDebuff() return false end
function modifier_item_chaotic_element_stone:IsHidden() return true end
function modifier_item_chaotic_element_stone:IsPurgable() return false end

function modifier_item_chaotic_element_stone:OnCreated(keys)
    self.ability = self:GetAbility()
    self.parent = self:GetParent()
    self.caster = self:GetCaster()
    self.bonus_outgoing_add = self.ability:GetSpecialValueFor("bonus_outgoing_add")
    self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
        self.buff_table = {
            "modifier_item_chaotic_element_stone_active1",
            "modifier_item_chaotic_element_stone_active2",
            "modifier_item_chaotic_element_stone_active3",
            "modifier_item_chaotic_element_stone_active4",
            "modifier_item_chaotic_element_stone_active5",
        }
    end
end

function modifier_item_chaotic_element_stone:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_item_chaotic_element_stone:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    return self.bonus_outgoing_add
end

function modifier_item_chaotic_element_stone:OnTakeDamage(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local unit = keys.unit
    if attacker ~= self.parent then return end

    if IsFireDamage(keys) then
        local modifier = attacker:FindModifierByName(self.buff_table[1])
        if not modifier then
           modifier = attacker:AddNewModifier(self.caster,self.ability,self.buff_table[1],{duration = self.duration})
        else
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration, true)
        end
    end
    if IsIceDamage(keys) then
        local modifier = attacker:FindModifierByName(self.buff_table[2])
        if not modifier then
           modifier = attacker:AddNewModifier(self.caster,self.ability,self.buff_table[2],{duration = self.duration})
        else
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration, true)
        end
    end
    if IsLightningDamage(keys) then
        local modifier = attacker:FindModifierByName(self.buff_table[3])
        if not modifier then
           modifier = attacker:AddNewModifier(self.caster,self.ability,self.buff_table[3],{duration = self.duration})
        else
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration, true)
        end
    end
    if IsHolyDamage(keys) then
        local modifier = attacker:FindModifierByName(self.buff_table[4])
        if not modifier then
           modifier = attacker:AddNewModifier(self.caster,self.ability,self.buff_table[4],{duration = self.duration})
        else
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration, true)
        end
    end
    if IsDarkDamage(keys) then
        local modifier = attacker:FindModifierByName(self.buff_table[5])
        if not modifier then
           modifier = attacker:AddNewModifier(self.caster,self.ability,self.buff_table[5],{duration = self.duration})
        else
            modifier:ForceRefresh()
            modifier:SetDuration(self.duration, true)
        end
    end
end


---------------------------------
modifier_item_chaotic_element_stone_active1 = advanced_modifier({})
function modifier_item_chaotic_element_stone_active1:IsDebuff() return false end
function modifier_item_chaotic_element_stone_active1:IsHidden() return false end
function modifier_item_chaotic_element_stone_active1:IsPurgable() return false end
function modifier_item_chaotic_element_stone_active1:GetTexture() return "item_chaotic_element_stone1" end
function modifier_item_chaotic_element_stone_active1:OnCreated(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_element_stone_active1:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_chaotic_element_stone_active1:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end
---------------------------------
modifier_item_chaotic_element_stone_active2 = advanced_modifier({})
function modifier_item_chaotic_element_stone_active2:IsDebuff() return false end
function modifier_item_chaotic_element_stone_active2:IsHidden() return false end
function modifier_item_chaotic_element_stone_active2:IsPurgable() return false end
function modifier_item_chaotic_element_stone_active2:GetTexture() return "item_chaotic_element_stone2" end
function modifier_item_chaotic_element_stone_active2:OnCreated(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_element_stone_active2:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_chaotic_element_stone_active2:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end
---------------------------------
modifier_item_chaotic_element_stone_active3 = advanced_modifier({})
function modifier_item_chaotic_element_stone_active3:IsDebuff() return false end
function modifier_item_chaotic_element_stone_active3:IsHidden() return false end
function modifier_item_chaotic_element_stone_active3:IsPurgable() return false end
function modifier_item_chaotic_element_stone_active3:GetTexture() return "item_chaotic_element_stone3" end
function modifier_item_chaotic_element_stone_active3:OnCreated(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_element_stone_active3:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_chaotic_element_stone_active3:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end
---------------------------------
modifier_item_chaotic_element_stone_active4 = advanced_modifier({})
function modifier_item_chaotic_element_stone_active4:IsDebuff() return false end
function modifier_item_chaotic_element_stone_active4:IsHidden() return false end
function modifier_item_chaotic_element_stone_active4:IsPurgable() return false end
function modifier_item_chaotic_element_stone_active4:GetTexture() return "item_chaotic_element_stone4" end
function modifier_item_chaotic_element_stone_active4:OnCreated(keys)
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_element_stone_active4:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_chaotic_element_stone_active4:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end
---------------------------------
modifier_item_chaotic_element_stone_active5 = advanced_modifier({})
function modifier_item_chaotic_element_stone_active5:IsDebuff() return false end
function modifier_item_chaotic_element_stone_active5:IsHidden() return false end
function modifier_item_chaotic_element_stone_active5:IsPurgable() return false end
function modifier_item_chaotic_element_stone_active5:GetTexture() return "item_chaotic_element_stone5" end
function modifier_item_chaotic_element_stone_active5:OnCreated(keys)    
    self.ability = self:GetAbility()
    self.outgoing = self.ability:GetSpecialValueFor("outgoing")
end

function modifier_item_chaotic_element_stone_active5:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_chaotic_element_stone_active5:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    if not self:GetAbility() then self:Destroy() return end
    return self.outgoing
end