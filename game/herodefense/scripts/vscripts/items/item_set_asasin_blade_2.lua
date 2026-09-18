item_set_asasin_blade_2 = class({})
LinkLuaModifier("modifier_item_set_asasin_blade_2", "items/item_set_asasin_blade_2", LUA_MODIFIER_MOTION_NONE)

function item_set_asasin_blade_2:GetIntrinsicModifierName()
	return "modifier_item_set_asasin_blade_2"
end


modifier_item_set_asasin_blade_2 = advanced_modifier({})

function modifier_item_set_asasin_blade_2:IsDebuff() return false end
function modifier_item_set_asasin_blade_2:IsHidden() return true end
function modifier_item_set_asasin_blade_2:IsPurgable() return false end

function modifier_item_set_asasin_blade_2:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
    self.evasion = self.ability:GetSpecialValueFor("evasion")
    self.radius = self.ability:GetSpecialValueFor("radius")
    self.active_evasion = self.ability:GetSpecialValueFor("active_evasion")
    self:SetStackCount(0)
    if IsServer() then
        self:StartIntervalThink(0.5)
    end
end

function modifier_item_set_asasin_blade_2:OnIntervalThink()
    local parent = self:GetParent()
    if not parent:HasModifier("modifier_item_set_asasin_blade") then
        self:SetStackCount(0)
        return
    end

    local enemies = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #enemies > 0 then
        self:SetStackCount(self.evasion)
    else
        self:SetStackCount(self.active_evasion)
    end
end

function modifier_item_set_asasin_blade_2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end
function modifier_item_set_asasin_blade_2:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end

function modifier_item_set_asasin_blade_2:Advanced_GetModifierPreAttack_BonusDamage()return self.bonus_attack end
function modifier_item_set_asasin_blade_2:GetModifierAttackSpeedBonus_Constant()	return self.bonus_attack_speed end

function modifier_item_set_asasin_blade_2:GetModifierEvasion_Constant()  
    return self:GetStackCount()
end
