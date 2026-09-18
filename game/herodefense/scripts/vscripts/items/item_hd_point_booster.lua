LinkLuaModifier("modifier_item_hd_point_booster", "items/item_hd_point_booster", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_point_booster_buff", "items/item_hd_point_booster", LUA_MODIFIER_MOTION_NONE)
item_hd_point_booster = class({})

function item_hd_point_booster:GetIntrinsicModifierName()
    return "modifier_item_hd_point_booster"
end

---------------------------------------------------------------------
modifier_item_hd_point_booster = advanced_modifier({})

function modifier_item_hd_point_booster:IsHidden()return true end
function modifier_item_hd_point_booster:IsPurgable()return false end

function modifier_item_hd_point_booster:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")*0.01
	self.regen  = self.ability:GetSpecialValueFor("regen")*0.01
    self.interval = self.ability:GetSpecialValueFor("interval")
    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end
function modifier_item_hd_point_booster:OnIntervalThink()
    local heal = self.parent:GetMaxHealth()*self.regen
    self.parent:Heal(heal, self.ability)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self.parent, heal, nil)
    local mana = self.parent:GetMaxMana()*self.mana_regen
    self.parent:GiveMana(mana)
    SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_ADD, self.parent, mana, nil)
end
-- function modifier_item_hd_point_booster:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
--     }
-- end

function modifier_item_hd_point_booster:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
    }
end

function modifier_item_hd_point_booster:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end

--
-- modifier_item_hd_point_booster_buff = advanced_modifier({})

-- function modifier_item_hd_point_booster_buff:IsHidden()return false end
-- function modifier_item_hd_point_booster_buff:IsPurgable()return false end

-- function modifier_item_hd_point_booster_buff:OnCreated()
--     self.parent = self:GetParent()
--     self.ability = self:GetAbility()
--     self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
-- end

-- -- function modifier_item_hd_point_booster:DeclareFunctions()
-- --     return{
-- --         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
-- --     }
-- -- end

-- function modifier_item_hd_point_booster_buff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
--     }
-- end

-- function modifier_item_hd_point_booster_buff:Advanced_GetModifier_TalentEffectGain()
-- 	if not self:GetAbility() then self:Destroy() return end
--     return self.bonus_profic
-- end


