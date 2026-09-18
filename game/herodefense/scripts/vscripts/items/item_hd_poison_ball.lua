LinkLuaModifier( "modifier_item_hd_poison_ball", "items/item_hd_poison_ball.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_poison_ball_active", "items/item_hd_poison_ball.lua", LUA_MODIFIER_MOTION_NONE )


--Abilities
if item_hd_poison_ball == nil then
	item_hd_poison_ball = class({})
end

function item_hd_poison_ball:GetIntrinsicModifierName()
	return "modifier_item_hd_poison_ball"
end

function item_hd_poison_ball:GetCastRange()
	return self:GetSpecialValueFor("radius")-self:GetCaster():GetCastRangeBonus()
end

---------------------------------------------------------------------
--Modifiers
modifier_item_hd_poison_ball = advanced_modifier({})
function modifier_item_hd_poison_ball:IsDebuff() return false end
function modifier_item_hd_poison_ball:IsHidden() return false end
function modifier_item_hd_poison_ball:IsPurgable() return false end

function modifier_item_hd_poison_ball:OnCreated(params)
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
	self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
	self.bonus_magic_res = self:GetAbility():GetSpecialValueFor("bonus_magic_res")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_item_hd_poison_ball:OnIntervalThink()
	local units = FindUnitsInRadius(self.caster:GetTeamNumber(),self.caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	self.poison_unit = 0
	for _,unit in pairs(units) do
		local poison = unit:FindModifierByName("modifier_hd_poison")
		if poison then
			self.poison_unit = self.poison_unit + 1
		end
	end

	if self.poison_unit ~= nil then
		self:SetStackCount(math.max(self.poison_unit,0))
	end
end

function modifier_item_hd_poison_ball:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil}
	}
end

function modifier_item_hd_poison_ball:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_hd_poison_ball:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor*self:GetStackCount()
end
function modifier_item_hd_poison_ball:GetModifierMagicalResistanceBonus()
	return self.bonus_magic_res
end
function modifier_item_hd_poison_ball:AdvancedGetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_hd_poison_ball:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	keys.target:Poison(keys.attacker, self:GetAbility(), 1)
end