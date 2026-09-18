
--------------------------------------------------------------------------------
modifier_Trine = advanced_modifier({})

function modifier_Trine:IsHidden()return false end
function modifier_Trine:IsDebuff()return false end
function modifier_Trine:IsStunDebuff()return false end
function modifier_Trine:IsPurgable()return false end
function modifier_Trine:GetTexture() return "phantom_lancer_sunwarrior_juxtapose" end
function modifier_Trine:IsPurgeException() 	return false end
function modifier_Trine:RemoveOnDeath() return false end

function modifier_Trine:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
		

	}
end



function modifier_Trine:GetModifierBonusStats_Strength()	return 15 end
function modifier_Trine:GetModifierBonusStats_Intellect()	return 15 end
function modifier_Trine:GetModifierBonusStats_Agility()	return 15 end
function modifier_Trine:Advanced_GetModifierSpellAmplifyBonus()   return 20 end
function modifier_Trine:GetModifierMagicalResistanceBonus() return 15 end
function modifier_Trine:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end

