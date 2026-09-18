
LinkLuaModifier("modifier_Primary_magic_blessing_meditate", "skills/Primary_magic_blessing", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_magic_blessing", "skills/Primary_magic_blessing", LUA_MODIFIER_MOTION_NONE)

Primary_magic_blessing							= class({})


function Primary_magic_blessing:GetIntrinsicModifierName()
	return "modifier_Primary_magic_blessing_meditate"
end


modifier_Primary_magic_blessing_meditate		= advanced_modifier({})

function modifier_Primary_magic_blessing_meditate:IsHidden()	return true end
function modifier_Primary_magic_blessing_meditate:IsPurgable() 		return false end
function modifier_Primary_magic_blessing_meditate:IsPurgeException() 	return false end
function modifier_Primary_magic_blessing_meditate:RemoveOnDeath()  return false end
function modifier_Primary_magic_blessing_meditate:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_Primary_magic_blessing_meditate:OnCreated(table)

	self.bonus_spell_damage_amplification = 0
	-- self.advanced_level = 1
	self:StartIntervalThink(1)
end
function modifier_Primary_magic_blessing_meditate:OnIntervalThink()
	local ability = self:GetAbility()
	self.bonus_spell_damage_amplification = ability:GetSpecialValueFor("bonus_spell_damage_amplification")
end

function modifier_Primary_magic_blessing_meditate:Advanced_GetModifierSpellAmplifyBonus()	return self:GetParent():PassivesDisabled() and 0 or  self.bonus_spell_damage_amplification end