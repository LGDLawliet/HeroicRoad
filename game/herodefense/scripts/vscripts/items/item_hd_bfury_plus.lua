
LinkLuaModifier("modifier_item_hd_bfury_plus", "items/item_hd_bfury_plus", LUA_MODIFIER_MOTION_NONE)
require("internal/timers")
item_hd_bfury_plus = class({})

function item_hd_bfury_plus:GetIntrinsicModifierName() return "modifier_item_hd_bfury_plus" end

modifier_item_hd_bfury_plus = advanced_modifier({})

function modifier_item_hd_bfury_plus:IsDebuff()			return false end
function modifier_item_hd_bfury_plus:IsHidden() 		return true end
function modifier_item_hd_bfury_plus:IsPermanent() 		return true end
function modifier_item_hd_bfury_plus:IsPurgable() 		return false end
function modifier_item_hd_bfury_plus:IsPurgeException() return false end
function modifier_item_hd_bfury_plus:RemoveOnDeath()		return self:GetParent():IsIllusion() end

function modifier_item_hd_bfury_plus:Advanced_GetModifierPreAttack_BonusDamage() return self:GetAbility():GetSpecialValueFor("bonus_damage") end
function modifier_item_hd_bfury_plus:Advanced_GetModifierAttackArmor_Ignore() return self:GetAbility():GetSpecialValueFor("no_armor") end
function modifier_item_hd_bfury_plus:OnAttackLanded(keys)
	if not IsServer() then
		return
	end

	if keys.attacker ~= self:GetParent() or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end

	if self:GetParent():IsDisableCleave() then
		return
	end

	local cleave_pct = self:GetAbility():GetSpecialValueFor("cleave_damage")
	local cleave_damage = keys.damage * (cleave_pct / 100)
	if self:GetParent():IsIllusion() then
		cleave_damage = 0
	end
	local target = keys.target
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("cleave_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
								ability = nil, --Optional.
								}
			ApplyDamage(damageTable)
		end
	end
end

function modifier_item_hd_bfury_plus:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_ARMOR_IGNORE,
    }
end
