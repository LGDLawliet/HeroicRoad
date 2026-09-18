creep_special_gain_insulator = class({})

LinkLuaModifier("modifier_creep_special_gain_insulator", "special_gain/creep_special_gain_insulator", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_insulator:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_insulator"
end
-----------
modifier_creep_special_gain_insulator = advanced_modifier({})

function modifier_creep_special_gain_insulator:IsDebuff() return false end
function modifier_creep_special_gain_insulator:IsHidden() return false end
function modifier_creep_special_gain_insulator:IsPurgable() return false end
function modifier_creep_special_gain_insulator:GetEffectName() return "particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_ti9_ambient.vpcf" end
function modifier_creep_special_gain_insulator:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_creep_special_gain_insulator:OnCreated(keys)
    self.ability = self:GetAbility()
    self.incoming_down = self.ability:GetSpecialValueFor("incoming_down")
    self.break_incoming_up = self.ability:GetSpecialValueFor("break_incoming_up")
end


function modifier_creep_special_gain_insulator:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_creep_special_gain_insulator:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then
        return
    end
    if keys.target ~= self:GetParent() then
        return
    end
    if keys.damage_type ~= DAMAGE_TYPE_MAGICAL then
        return 
    end
    if keys.target:PassivesDisabled() then
        return self.break_incoming_up
    else
        return -self.incoming_down
    end
	
    return 0
end

