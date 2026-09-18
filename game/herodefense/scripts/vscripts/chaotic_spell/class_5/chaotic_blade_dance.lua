chaotic_blade_dance = class({})
LinkLuaModifier( "modifier_chaotic_blade_dance", "chaotic_spell/class_5/chaotic_blade_dance", LUA_MODIFIER_MOTION_NONE )

function chaotic_blade_dance:GetIntrinsicModifierName()
	return "modifier_chaotic_blade_dance"
end

-----------------------------------
modifier_chaotic_blade_dance = advanced_modifier({})


function modifier_chaotic_blade_dance:IsHidden() return true end
function modifier_chaotic_blade_dance:IsPurgable() 		return false end
function modifier_chaotic_blade_dance:IsPurgeException() 	return false end
function modifier_chaotic_blade_dance:RemoveOnDeath()  return false end

function modifier_chaotic_blade_dance:OnCreated( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.bonus_attack_melee = self:GetAbility():GetSpecialValueFor( "bonus_attack_melee" )
	self.type = self:GetAbility():GetRuneType()
	self.rune_1_no_armor = self:GetAbility():GetSpecialValueFor( "rune_1_no_armor" )
	self.rune_2_chance = self:GetAbility():GetSpecialValueFor( "rune_2_chance" )
	self.rune_2_mult = self:GetAbility():GetSpecialValueFor( "rune_2_mult" )
	self.rune_3_outgoing = self:GetAbility():GetSpecialValueFor( "rune_3_outgoing" )
end

function modifier_chaotic_blade_dance:OnRefresh( kv )
	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_mult = self:GetAbility():GetSpecialValueFor( "crit_mult" )
	self.bonus_attack_melee = self:GetAbility():GetSpecialValueFor( "bonus_attack_melee" )
	self.rune_1_no_armor = self:GetAbility():GetSpecialValueFor( "rune_1_no_armor" )
	self.rune_2_chance = self:GetAbility():GetSpecialValueFor( "rune_2_chance" )
	self.rune_2_mult = self:GetAbility():GetSpecialValueFor( "rune_2_mult" )
	self.rune_3_outgoing = self:GetAbility():GetSpecialValueFor( "rune_3_outgoing" )
end

function modifier_chaotic_blade_dance:ADDeclareFunctions()
    local funcs = 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
	if self.type == 1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_ARMOR_IGNORE)
	end
	if self.type == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE)
	end
	return funcs
end

function modifier_chaotic_blade_dance:Advanced_GetModifierCriticalStrike(keys)
	if IsServer() and (not self:GetParent():PassivesDisabled()) then
		if keys.target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return
		end
		if keys.attacker ~= self:GetParent() then
			return
		end

		local pct = self.crit_chance
		local random = math.random
		if pct >= random(1,100) then
			EmitSoundOn( "Hero_Juggernaut.BladeDance", keys.target )
			self.record = keys.record
			if self.type == 2 and self.rune_2_chance >= random(1,100) and not keys.target:IsChaoticEraElite() then 
				return self.crit_mult*self.rune_2_mult
			else
				return self.crit_mult
			end
		end
	end
end

function modifier_chaotic_blade_dance:Advanced_GetModifierPreAttack_BonusDamage()
	if not self:GetParent():IsRangedAttacker() then
		return self.bonus_attack_melee
	end
	return 0 
end

function modifier_chaotic_blade_dance:Advanced_GetModifierAttackArmor_Ignore()
	return self.rune_1_no_armor
end

function modifier_chaotic_blade_dance:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	if IsServer() then
		if keys.damage_category == DOTA_DAMAGE_CATEGORY_ATTACK then
			return self.rune_3_outgoing
		end
	end
	return
end