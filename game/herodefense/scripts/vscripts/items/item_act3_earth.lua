LinkLuaModifier("modifier_item_act3_earth", "items/item_act3_earth.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_act3_earth_3", "items/item_act3_earth.lua", LUA_MODIFIER_MOTION_NONE)
item_act3_earth = class({})

function item_act3_earth:Spawn()
    if IsServer() then
        self:SetCurrentCharges(0)
        if IsInToolsMode() then
            self:SetCurrentCharges(90)
        end
    end
end

function item_act3_earth:GetIntrinsicModifierName()
    return "modifier_item_act3_earth"
end

-- 主修饰器
modifier_item_act3_earth = advanced_modifier({})

function modifier_item_act3_earth:IsHidden() return self.ability:GetCurrentCharges() < self.check4 end
function modifier_item_act3_earth:IsDebuff() return false end
function modifier_item_act3_earth:IsPurgable() return false end
function modifier_item_act3_earth:RemoveOnDeath() return false end

function modifier_item_act3_earth:OnCreated()
    
        self.ability = self:GetAbility()
        self.parent = self:GetParent()
        
        -- 基础参数
        self.point_armor = self.ability:GetSpecialValueFor("point_armor")
        self.need = self.ability:GetSpecialValueFor("need")
        self.armor_1 = self.ability:GetSpecialValueFor("armor_1")
        self.magicres_1 = self.ability:GetSpecialValueFor("magicres_1")
        self.check2 = self.ability:GetSpecialValueFor("check2")
        self.chance_2 = self.ability:GetSpecialValueFor("chance_2")
        self.crit_2 = self.ability:GetSpecialValueFor("crit_2")-100
        self.check3 = self.ability:GetSpecialValueFor("check3")
        self.duration_3 = self.ability:GetSpecialValueFor("duration_3")
        self.check4 = self.ability:GetSpecialValueFor("check4")
        self.outgoing_4 = self.ability:GetSpecialValueFor("outgoing_4")
        self.incoming_4 = self.ability:GetSpecialValueFor("incoming_4")
    if IsServer() then
        -- 计数器
        self.attack_count = 0
        
        -- 记录每个攻击者的信息
        self.attacker_info = {}
    end
end
function modifier_item_act3_earth:ADDeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK = {nil, self:GetParent()},
        MODIFIER_EVENT_ON_ATTACK_LANDED = {nil, self:GetParent()},
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_act3_earth:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_TOOLTIP,
    }
    return funcs
end

function modifier_item_act3_earth:OnAttack(event)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    
    local attacker = event.attacker
    local target = event.target
    if not attacker or not target then return end

    -- %check3%灵能点被动：坚钢之土
    if self.ability:GetCurrentCharges() >= self.check3 then
        -- 检查是否是该攻击者的首次攻击
        if not self.attacker_info[attacker:entindex()] then
            -- 记录攻击者信息
            self.attacker_info[attacker:entindex()] = true
            attacker:AddNewModifier(self.parent, self.ability, "modifier_item_act3_earth_3", {duration = self.duration_3})
        end
    end
end

function modifier_item_act3_earth:OnAttackLanded(event)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    
    local attacker = event.attacker
    local target = event.target
    if not attacker or not target then return end

    if target == self.parent and attacker ~= self.parent then
        self.attack_count = self.attack_count + 1
        
        -- 检查是否达到触发条件
        if self.attack_count >= self.need then
            self.attack_count = 0
            -- 增加灵能点
            self.ability:SetCurrentCharges(math.max(math.min(self.ability:GetCurrentCharges()+1, GetWave()*5), 1))
        end
    end
end

function modifier_item_act3_earth:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    -- %check2%灵能点被动：沉重之土
    if self.ability:GetCurrentCharges() >= self.check2 then
        if self.chance_2 >= math.random(1,100) then
            return self.crit_2
        end
    end
end

function modifier_item_act3_earth:Advanced_GetModifierPhysicalArmorBonus()
    -- 地灵之祝：每英雄等级提供护甲
    return self.parent:GetLevel() * self.armor_1 + self.ability:GetCurrentCharges() * self.point_armor
end

function modifier_item_act3_earth:GetModifierMagicalResistanceBonus()
    -- 地灵之祝：每英雄等级提供魔法抗性
    return self.parent:GetLevel() * self.magicres_1
end

function modifier_item_act3_earth:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    -- %check4%灵能点被动：泰坦之赐 - 伤害增加
    if self.ability:GetCurrentCharges() >= self.check4 then
        local outgoing = math.min(self.parent:GetPhysicalArmorValue(false) * self.outgoing_4, 50)
        return outgoing
    end
    return 0
end

function modifier_item_act3_earth:Advanced_GetModifierIncomingDamage_Percentage()
    -- %check4%灵能点被动：泰坦之赐 - 伤害减免
    if self.ability:GetCurrentCharges() >= self.check4 then
        local reduction = math.min(self.parent:GetPhysicalArmorValue(false) * self.incoming_4, 30)
        return -reduction
    end
end

function modifier_item_act3_earth:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierIncomingDamage_Percentage()
    end
end

-- %check3%灵能点被动：坚钢之土
modifier_item_act3_earth_3 = advanced_modifier({})

function modifier_item_act3_earth_3:IsHidden() return false end
function modifier_item_act3_earth_3:IsDebuff() return true end
function modifier_item_act3_earth_3:IsPurgable() return false end
function modifier_item_act3_earth_3:RemoveOnDeath() return false end
function modifier_item_act3_earth_3:GetTexture() return "item_act3_earth" end

function modifier_item_act3_earth_3:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
    }
    return state
end

function modifier_item_act3_earth_3:ADDeclareFunctions()
    local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
    return funcs
end

function modifier_item_act3_earth_3:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    return -200
end
