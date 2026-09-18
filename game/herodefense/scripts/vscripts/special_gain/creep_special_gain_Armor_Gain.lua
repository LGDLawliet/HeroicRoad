creep_special_gain_Armor_Gain = class({})

LinkLuaModifier("modifier_creep_special_gain_Armor_Gain", "special_gain/creep_special_gain_Armor_Gain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_Armor_Gain_cd", "special_gain/creep_special_gain_Armor_Gain", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_Armor_Gain:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_Armor_Gain"
end
----------------------------------------------------------------------------
modifier_creep_special_gain_Armor_Gain = advanced_modifier({})

function modifier_creep_special_gain_Armor_Gain:IsDebuff() return false end
function modifier_creep_special_gain_Armor_Gain:IsHidden() return false end
function modifier_creep_special_gain_Armor_Gain:IsPurgable() return false end
function modifier_creep_special_gain_Armor_Gain:GetEffectName() return "particles/econ/events/ti7/golden_treasure_ti7_ambient.vpcf" end
function modifier_creep_special_gain_Armor_Gain:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end


function modifier_creep_special_gain_Armor_Gain:OnCreated(keys)
    self.ability = self:GetAbility()
    self.incoming_down = self.ability:GetSpecialValueFor("incoming_down")
    self.break_incoming_up = self.ability:GetSpecialValueFor("break_incoming_up")
end

function modifier_creep_special_gain_Armor_Gain:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_creep_special_gain_Armor_Gain:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then
        return
    end
    if keys.target ~= self:GetParent() then
        return
    end
    if keys.damage_type ~= DAMAGE_TYPE_PHYSICAL then
        return 
    end
    if keys.target:PassivesDisabled() then
        return self.break_incoming_up
    else
        return -self.incoming_down
    end
    return 0
end
