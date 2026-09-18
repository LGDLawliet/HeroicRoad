LinkLuaModifier("modifier_item_hd_disperser", "items/item_hd_disperser", LUA_MODIFIER_MOTION_NONE)

item_hd_disperser = class({})

function item_hd_disperser:GetIntrinsicModifierName()
    return "modifier_item_hd_disperser"
end

---------------------------------------------------------------------
modifier_item_hd_disperser = advanced_modifier({})

function modifier_item_hd_disperser:IsHidden()return false end
function modifier_item_hd_disperser:IsPurgable()return false end

function modifier_item_hd_disperser:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.line = self.ability:GetSpecialValueFor("line")
    self.profic = self.ability:GetSpecialValueFor("profic")
    self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
    self.attack = self.ability:GetSpecialValueFor("attack")
    self.lifesteal_gain = self.ability:GetSpecialValueFor("lifesteal_gain")
    self.count = self.ability:GetSpecialValueFor("count")
    self.hp_cost = self.ability:GetSpecialValueFor("hp_cost")*0.01
    self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
    self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
    self.duration = self.ability:GetSpecialValueFor("duration")

    self.check = 0
    self:SetStackCount(0)
end
function modifier_item_hd_disperser:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_disperser:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifier_TalentEffectGain()
	elseif self._tooltip == 2 then
        return self:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	end
end
function modifier_item_hd_disperser:ADDeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_LifeSteal_Intensity,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE
    }
end
function modifier_item_hd_disperser:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    local target = keys.target
    if attacker ~= self.parent then return end

    if not attacker:IsInSpecialAttack() and target:IsAlive() then
        self.check = self.check + 1
        if self.check >= self.count then
            self.check = 0
            --target:Purge(true, false, false, false, false)
        end
    end
    if attacker:GetHealthPercent() >= self.line then
        attacker:ModifyHealth(attacker:GetHealth()-attacker:GetMaxHealth()*self.hp_cost, self.ability, false, 0)
        self:SetStackCount(self:GetStackCount() + 1)
        
        -- 使用弱引用来避免循环引用问题
        local modifier_handle = self
        attacker:GameTimer(self.duration, function()
            -- 更安全的检查方式
            if modifier_handle and modifier_handle:IsNull() == false then
                local current_stacks = modifier_handle:GetStackCount()
                if current_stacks > 0 then
                    modifier_handle:SetStackCount(current_stacks - 1)
                end
            end
        end)
    end
end
function modifier_item_hd_disperser:Advanced_GetModifier_TalentEffectGain()
    return self.profic + self.bonus_profic *self:GetStackCount()
end
function modifier_item_hd_disperser:Advanced_GetModifierAttackSpeedPercentage()
    return self.attack
end
function modifier_item_hd_disperser:Advanced_GetModifier_LifeSteal_Intensity()
    return -self.lifesteal_gain
end
function modifier_item_hd_disperser:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return self.bonus_damage *self:GetStackCount()
end


