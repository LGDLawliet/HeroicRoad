item_hd_enchanted_quiver = class({})

LinkLuaModifier("modifier_item_hd_enchanted_quiver", "items/item_hd_enchanted_quiver", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_enchanted_quiver_already", "items/item_hd_enchanted_quiver", LUA_MODIFIER_MOTION_NONE)

function item_hd_enchanted_quiver:GetIntrinsicModifierName()
	return "modifier_item_hd_enchanted_quiver"
end


modifier_item_hd_enchanted_quiver = advanced_modifier({})

function modifier_item_hd_enchanted_quiver:IsDebuff() return false end
function modifier_item_hd_enchanted_quiver:IsHidden() return true end
function modifier_item_hd_enchanted_quiver:IsPurgable() return false end

function modifier_item_hd_enchanted_quiver:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS,
	}
end

function modifier_item_hd_enchanted_quiver:GetModifierAttackSpeedBonus_Constant() return self:GetAbility():GetSpecialValueFor("bonus_attack_speed") end
function modifier_item_hd_enchanted_quiver:GetModifierProjectileSpeedBonus() return self:GetAbility():GetSpecialValueFor("bonus_project_speed") end

function modifier_item_hd_enchanted_quiver:ADDeclareFunctions()
    return 
    {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
    }
end
function modifier_item_hd_enchanted_quiver:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if not keys.attacker==self:GetParent() then
		return
	end
	local modifier = keys.target:FindModifierByNameAndCaster("modifier_item_hd_enchanted_quiver_already", keys.attacker)
	if modifier then
		return
	end
	local damageTable = {
		victim = keys.target,
		attacker = keys.attacker,
		damage = keys.target:GetHealth()*self:GetAbility():GetSpecialValueFor("hp_damage")*0.01,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(),
		damage_flag = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	}
	if damageTable.damage > 9999 then
		damageTable.damage = 9999
	end
	if damageTable.damage < 300 then
		damageTable.damage = 300
	end
	ApplyDamage(damageTable)
	keys.target:AddNewModifier(keys.attacker, self:GetAbility(), "modifier_item_hd_enchanted_quiver_already", {duration = 5})
end



modifier_item_hd_enchanted_quiver_already = advanced_modifier({})

function modifier_item_hd_enchanted_quiver_already:IsDebuff() return false end
function modifier_item_hd_enchanted_quiver_already:IsHidden() return true end
function modifier_item_hd_enchanted_quiver_already:IsPurgable() return false end
function modifier_item_hd_enchanted_quiver_already:RemoveOnDeath() return false end