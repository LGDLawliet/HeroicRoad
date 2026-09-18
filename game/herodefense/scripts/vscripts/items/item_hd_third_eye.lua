LinkLuaModifier("modifier_item_hd_third_eye", "items/item_hd_third_eye", LUA_MODIFIER_MOTION_NONE)
item_hd_third_eye = class({})

function item_hd_third_eye:GetIntrinsicModifierName()
    return "modifier_item_hd_third_eye"
end

---------------------------------------------------------------------
modifier_item_hd_third_eye = advanced_modifier({})

function modifier_item_hd_third_eye:IsHidden()return false end
function modifier_item_hd_third_eye:IsPurgable()return false end

function modifier_item_hd_third_eye:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    
    -- 初始化属性状态数组，1表示正常值，2表示翻倍，0.5表示减半
    self.attribute_multipliers = {
        full_damage = 1,
        spell_amp = 1,
        summon_intensity = 1,
        profic = 1
    }
    
    if self.ability then
        self.summon_intensity = self.ability:GetSpecialValueFor("summon_intensity")
        self.profic = self.ability:GetSpecialValueFor("profic")
        self.full_damage = self.ability:GetSpecialValueFor("full_damage")
        self.spell_amp = self.ability:GetSpecialValueFor("spell_amp")
        self.interval = self.ability:GetSpecialValueFor("interval")
        
        if IsServer() then
            self:StartIntervalThink(self.interval)
            self:SetHasCustomTransmitterData(true)
        end
    end
end
function modifier_item_hd_third_eye:AddCustomTransmitterData( )
    if not self.attribute_multipliers then return {} end
    
    return
    {
        full_damage_multiplier = self.attribute_multipliers.full_damage,
        spell_amp_multiplier = self.attribute_multipliers.spell_amp,
        summon_intensity_multiplier = self.attribute_multipliers.summon_intensity,
        profic_multiplier = self.attribute_multipliers.profic,
    }
end

function modifier_item_hd_third_eye:HandleCustomTransmitterData( data )
    if not self.attribute_multipliers then 
        self.attribute_multipliers = {
            full_damage = 1,
            spell_amp = 1,
            summon_intensity = 1,
            profic = 1
        }
    end
    
    self.attribute_multipliers.full_damage = data.full_damage_multiplier or 1
    self.attribute_multipliers.spell_amp = data.spell_amp_multiplier or 1
    self.attribute_multipliers.summon_intensity = data.summon_intensity_multiplier or 1
    self.attribute_multipliers.profic = data.profic_multiplier or 1
end
function modifier_item_hd_third_eye:OnIntervalThink()
    if IsServer() then
        -- 获取所有属性名称
        local attributes = {"full_damage", "spell_amp", "summon_intensity", "profic"}
        
        -- 先将所有属性重置为默认值
        for _, attr in ipairs(attributes) do
            self.attribute_multipliers[attr] = 1
        end
        
        -- 随机选择一个属性进行翻倍
        local double_index = RandomInt(1, #attributes)
        local double_attribute = attributes[double_index]
        
        -- 从剩余属性中随机选择一个进行减半
        local remaining_attributes = {}
        for i, attr in ipairs(attributes) do
            if i ~= double_index then
                table.insert(remaining_attributes, attr)
            end
        end
        
        local half_index = RandomInt(1, #remaining_attributes)
        local half_attribute = remaining_attributes[half_index]
        
        -- 应用变化
        self.attribute_multipliers[double_attribute] = 2
        self.attribute_multipliers[half_attribute] = 0.5
        
        -- 触发网络同步
        self:SendBuffRefreshToClients()
    end
end
function modifier_item_hd_third_eye:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_third_eye:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN
    }
end

function modifier_item_hd_third_eye:Advanced_GetModifierDamageOutgoing_Percentage()
    if not self.attribute_multipliers then return 0 end
    return self.full_damage * self.attribute_multipliers.full_damage
end
function modifier_item_hd_third_eye:Advanced_GetModifierSpellAmplifyBonus()
    if not self.attribute_multipliers then return 0 end
    return  self.spell_amp * self.attribute_multipliers.spell_amp
end
function modifier_item_hd_third_eye:Advanced_GetModifier_Summon_Intensity()
    if not self.attribute_multipliers then return 0 end
    return self.summon_intensity * self.attribute_multipliers.summon_intensity
end
function modifier_item_hd_third_eye:Advanced_GetModifier_TalentEffectGain()
    if not self.attribute_multipliers then return 0 end
    return self.profic * self.attribute_multipliers.profic
end
function modifier_item_hd_third_eye:OnTooltip()
    if not self.attribute_multipliers then return 0 end
    
    self._tooltip = (self._tooltip or 0) % 4 + 1
    if self._tooltip == 1 then
        return self:Advanced_GetModifier_TalentEffectGain()
    elseif self._tooltip == 2 then
        return self:Advanced_GetModifierDamageOutgoing_Percentage()
    elseif self._tooltip == 3 then
        return self:Advanced_GetModifierSpellAmplifyBonus()
    elseif self._tooltip == 4 then
        return self:Advanced_GetModifier_Summon_Intensity()
    end
end


