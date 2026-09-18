LinkLuaModifier( "modifier_creeps_spell_Golem_punch", "creeps_spell/creeps_spell_Golem_punch", LUA_MODIFIER_MOTION_NONE )


creeps_spell_Golem_punch = class({})

function creeps_spell_Golem_punch:GetIntrinsicModifierName() return "modifier_creeps_spell_Golem_punch" end

modifier_creeps_spell_Golem_punch = advanced_modifier({})

function modifier_creeps_spell_Golem_punch:IsDebuff()			return false end
function modifier_creeps_spell_Golem_punch:IsHidden() 		return true end
function modifier_creeps_spell_Golem_punch:IsPermanent() 		return true end
function modifier_creeps_spell_Golem_punch:IsPurgable() 		return false end
function modifier_creeps_spell_Golem_punch:IsPurgeException() return false end

function modifier_creeps_spell_Golem_punch:OnAttackLanded(keys)
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
	local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor("cleave_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for i, enemy in pairs(enemies) do
		if enemy ~= target then
			local damageTable = {
								victim = enemy,
								attacker = self:GetParent(),
								damage = cleave_damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL, --Optional.
								ability = nil, --Optional.
								hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
								}
			ApplyDamage(damageTable)
		end
		
		if i >= self:GetAbility():GetSpecialValueFor("max") then
			break
		end
	end
end

function modifier_creeps_spell_Golem_punch:ADDeclareFunctions()
    return 
    {
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
    }
end
function modifier_creeps_spell_Golem_punch:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end
function modifier_creeps_spell_Golem_punch:GetModifierAttackSpeedPercentage()
	return -self:GetAbility():GetSpecialValueFor("attack_speed_down")
end
