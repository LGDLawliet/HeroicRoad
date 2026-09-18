LinkLuaModifier( "modifier_chaotic_qi_burst", "chaotic_spell/class_3/chaotic_qi_burst.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if chaotic_qi_burst == nil then
	chaotic_qi_burst = class({})
end

function chaotic_qi_burst:OnSpellStart()
	local caster = self:GetCaster()
	local qi_points = caster:FindModifierByName("modifier_chaotic_qi")
	if not qi_points then
		qi_points = 1
	else
		qi_points = qi_points:GetStackCount()
	end
	local damage_per_qi = self:GetSpecialValueFor("damage_per_qi")
	local stun_duration = self:GetSpecialValueFor("stun_duration")

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		self:GetSpecialValueFor("radius"),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	for _, enemy in pairs(enemies) do
		local damage = qi_points * damage_per_qi
		ApplyDamage({
			victim = enemy,
			attacker = caster,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		})
		enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
	end

	caster:RemoveModifierByName("modifier_chaotic_qi")
end

---------------------------------------------------------------------
--Modifiers
if modifier_chaotic_qi_burst == nil then
	modifier_chaotic_qi_burst = class({})
end

function modifier_chaotic_qi_burst:IsHidden()
	return true
end

function modifier_chaotic_qi_burst:IsPurgable()
	return false
end

function modifier_chaotic_qi_burst:RemoveOnDeath()
	return false
end