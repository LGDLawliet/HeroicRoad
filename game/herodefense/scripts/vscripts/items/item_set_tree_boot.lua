item_set_tree_boot = class({})
LinkLuaModifier("modifier_item_set_tree_boot", "items/item_set_tree_boot", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_set_tree_boot_active", "items/item_set_tree_boot", LUA_MODIFIER_MOTION_NONE)

function item_set_tree_boot:GetIntrinsicModifierName()
	return "modifier_item_set_tree_boot"
end
function item_set_tree_boot:Precache( context )
	PrecacheResource( "particle", "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", context )
end

modifier_item_set_tree_boot = advanced_modifier({})

function modifier_item_set_tree_boot:IsDebuff() return false end
function modifier_item_set_tree_boot:IsHidden() return true end
function modifier_item_set_tree_boot:IsPurgable() return false end

function modifier_item_set_tree_boot:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_hp = self.ability:GetSpecialValueFor("bonus_hp")
	self.day_hp_pct = self.ability:GetSpecialValueFor("day_hp_pct")
    self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
    local parent = self:GetParent()
    self.attach_particle = ParticleManager:CreateParticle( "particles/econ/courier/courier_greevil_green/courier_greevil_green_ambient_3.vpcf", PATTACH_ABSORIGIN_FOLLOW,parent )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    ParticleManager:SetParticleControlEnt( self.attach_particle, 1, parent, PATTACH_POINT_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true )
    self:AddParticle( self.attach_particle, false, false, -1, true, false )
end
function modifier_item_set_tree_boot:OnDestroy(keys)
    if self.attach_particle then
        ParticleManager:DestroyParticle(self.attach_particle, true)
    end
end
function modifier_item_set_tree_boot:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
    }
end
function modifier_item_set_tree_boot:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
    }
end

function modifier_item_set_tree_boot:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end
function modifier_item_set_tree_boot:AdvancedGetModifierHealthBonus()	return self.bonus_hp end
function modifier_item_set_tree_boot:AdvancedGetModifierExtraHealthPercentage()  
    local time = GameRules:GetTimeOfDay()
	if time>=0.25 and time <=0.75 then
        return self.day_hp_pct
    end
    return 0
end


-------------------------
modifier_item_set_tree_boot_active = class({})
function modifier_item_set_tree_boot_active:IsDebuff() return false end
function modifier_item_set_tree_boot_active:IsHidden() return true end
function modifier_item_set_tree_boot_active:IsPurgable() return false end


