item_hd_lesser_crit = class({})

LinkLuaModifier("modifier_item_hd_lesser_crit", "items/item_hd_lesser_crit", LUA_MODIFIER_MOTION_NONE)

function item_hd_lesser_crit:GetIntrinsicModifierName()
	return "modifier_item_hd_lesser_crit"
end


modifier_item_hd_lesser_crit = advanced_modifier({})

function modifier_item_hd_lesser_crit:IsDebuff() return false end
function modifier_item_hd_lesser_crit:IsHidden() return true end
function modifier_item_hd_lesser_crit:IsPurgable() return false end


function modifier_item_hd_lesser_crit:OnCreated(keys)
    self.ability = self:GetAbility()
    local parent = self:GetParent()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.crit_chance = self.ability:GetSpecialValueFor( "blade_dance_crit_chance" )
	self.crit_mult = self.ability:GetSpecialValueFor( "blade_dance_crit_mult" )
	self.armor_useless = self.ability:GetSpecialValueFor( "armor_useless" )
end

function modifier_item_hd_lesser_crit:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
    }
end
function modifier_item_hd_lesser_crit:Advanced_GetModifierCriticalStrike(keys)
	if IsServer()  then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if self.crit_chance >=RandomInt(1, 100) then
			return self.crit_mult
		end
	end
end
function modifier_item_hd_lesser_crit:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_lesser_crit:Advanced_GetModifierAttackArmor_Ignore() return self.armor_useless end