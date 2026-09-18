item_set_mbone_sword = class({})
LinkLuaModifier("modifier_item_set_mbone_sword", "items/item_set_mbone_sword", LUA_MODIFIER_MOTION_NONE)

function item_set_mbone_sword:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf", context )
    PrecacheResource( "particle", "particles/ui/tips/muerta_death_reckoning_flames_green.vpcf", context )
end
function item_set_mbone_sword:GetIntrinsicModifierName()
	return "modifier_item_set_mbone_sword"
end


modifier_item_set_mbone_sword = advanced_modifier({})

function modifier_item_set_mbone_sword:IsDebuff() return false end
function modifier_item_set_mbone_sword:IsHidden() return true end
function modifier_item_set_mbone_sword:IsPurgable() return false end

function modifier_item_set_mbone_sword:OnCreated(keys)
    self.ability = self:GetAbility()

	self.bonus_attack = self.ability:GetSpecialValueFor("bonus_attack")
	self.attack_speed_down = self.ability:GetSpecialValueFor("attack_speed_down")
    self.chance = self.ability:GetSpecialValueFor("chance")
    self.cleave_index = self.ability:GetSpecialValueFor("cleave_index")
end 


function modifier_item_set_mbone_sword:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end

function modifier_item_set_mbone_sword:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end
function modifier_item_set_mbone_sword:Advanced_GetModifierPreAttack_BonusDamage()return self.bonus_attack end
function modifier_item_set_mbone_sword:GetModifierAttackSpeedBonus_Constant()	
    return -self.attack_speed_down

end

function modifier_item_set_mbone_sword:OnAttackLanded(keys)  
    if not IsServer() then
        return
    end
    if keys.attacker ~= self:GetParent() then
        return
    end

    local random = math.random
    local ability = self:GetAbility()
    local caster = self:GetParent()
    if self.chance >= random(1,100) then
        local dmg = keys.damage *ability:GetSpecialValueFor("cleave_index")*0.01
		local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
		DoIMBACleaveAttack(caster, keys.target, ability, dmg, 50,575, 550, pfx)
    end
end
