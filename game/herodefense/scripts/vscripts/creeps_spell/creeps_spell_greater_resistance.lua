LinkLuaModifier("modifier_creeps_spell_barr_thunder_passive", "creeps_spell/creeps_spell_greater_resistance", LUA_MODIFIER_MOTION_NONE)


creeps_spell_greater_resistance = class({})

function creeps_spell_greater_resistance:GetIntrinsicModifierName() return "modifier_creeps_spell_barr_thunder_passive" end








modifier_creeps_spell_barr_thunder_passive = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_passive:IsHidden() return true end
function modifier_creeps_spell_barr_thunder_passive:IsPurgable() return false end
function modifier_creeps_spell_barr_thunder_passive:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_passive:IsPurgeException() return false end
function modifier_creeps_spell_barr_thunder_passive:RemoveOnDeath() return false end
function modifier_creeps_spell_barr_thunder_passive:GetPriority() return 500 end
function modifier_creeps_spell_barr_thunder_passive:OnCreated(table)
	if IsServer() then
		local heroes = GetAllRealHeroes()

		self.players_num = #heroes or 1
		self:SetStackCount(self.players_num)
		if not self:GetParent():HasAbility("chaotic_era_buffskill_2") then
			local ability = self:GetParent():AddAbility("chaotic_era_buffskill_2")--闪避
			ability:SetLevel(1)
		end
		if not self:GetParent():HasAbility("chaotic_era_buffskill_8") then
			local ability = self:GetParent():AddAbility("chaotic_era_buffskill_8")--反冲
			ability:SetLevel(1)
		end
		if not self:GetParent():HasAbility("chaotic_era_buffskill_3") then
			local ability = self:GetParent():AddAbility("chaotic_era_buffskill_3")--对魔力
			ability:SetLevel(1)
		end
	end
end
function modifier_creeps_spell_barr_thunder_passive:ADDeclareFunctions()
	return{
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
end
function modifier_creeps_spell_barr_thunder_passive:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end
function modifier_creeps_spell_barr_thunder_passive:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -math.min((self:GetStackCount()-1)*22.5, 99)
end
function modifier_creeps_spell_barr_thunder_passive:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return math.min((self:GetStackCount()-1)*10, 99)
end
function modifier_creeps_spell_barr_thunder_passive:Advanced_GetModifierPhysicalArmorBonusPercentage(keys)
	return (self:GetStackCount()-1)*6
end
function modifier_creeps_spell_barr_thunder_passive:AdvancedGetModifierConstantHealthRegenPercentage(keys)
	return 0.5
end
function modifier_creeps_spell_barr_thunder_passive:GetModifierMagicalResistanceBonus(keys)
	return (self:GetStackCount()-1)*8
end
function modifier_creeps_spell_barr_thunder_passive:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_PASSIVES_DISABLED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_MUTED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
	return state
end


