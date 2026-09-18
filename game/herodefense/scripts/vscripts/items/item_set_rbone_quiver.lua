item_set_rbone_quiver = class({})
LinkLuaModifier("modifier_item_set_rbone_quiver", "items/item_set_rbone_quiver", LUA_MODIFIER_MOTION_NONE)


function item_set_rbone_quiver:GetIntrinsicModifierName()
	return "modifier_item_set_rbone_quiver"
end


modifier_item_set_rbone_quiver = advanced_modifier({})

function modifier_item_set_rbone_quiver:IsDebuff() return false end
function modifier_item_set_rbone_quiver:IsHidden() return true end
function modifier_item_set_rbone_quiver:IsPurgable() return false end

function modifier_item_set_rbone_quiver:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_project_speed = self.ability:GetSpecialValueFor("bonus_project_speed")
end

function modifier_item_set_rbone_quiver:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
    }
end
function modifier_item_set_rbone_quiver:GetModifierAttackSpeedBonus_Constant()return self.bonus_attack_speed end
function modifier_item_set_rbone_quiver:GetModifierProjectileSpeedBonus()	
    if self:GetParent():IsRangedAttacker() then 
        return self.bonus_project_speed 
    end
    return 0 
end
