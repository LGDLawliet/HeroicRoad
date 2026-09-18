item_set_tree_armor = class({})
LinkLuaModifier("modifier_item_set_tree_armor", "items/item_set_tree_armor", LUA_MODIFIER_MOTION_NONE)

function item_set_tree_armor:GetIntrinsicModifierName()
	return "modifier_item_set_tree_armor"
end


modifier_item_set_tree_armor = advanced_modifier({})

function modifier_item_set_tree_armor:IsDebuff() return false end
function modifier_item_set_tree_armor:IsHidden() return true end
function modifier_item_set_tree_armor:IsPurgable() return false end

function modifier_item_set_tree_armor:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
    self.day_hp_regen_pct = self.ability:GetSpecialValueFor("day_hp_regen_pct")
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_item_set_tree_armor:OnIntervalThink()
    local time = GameRules:GetTimeOfDay()
	if time>=0.25 and time <=0.75 then
        self:SetStackCount(1)
    else
        self:SetStackCount(0)
    end
end

function modifier_item_set_tree_armor:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
    }
end

function modifier_item_set_tree_armor:Advanced_GetModifierPhysicalArmorBonus()return self.bonus_armor end
function modifier_item_set_tree_armor:AdvancedGetModifierHealthBonus()	return self.bonus_hp end

function modifier_item_set_tree_armor:AdvancedGetModifierConstantHealthRegenPercentage()  
    return self.day_hp_regen_pct * self:GetStackCount()
end
