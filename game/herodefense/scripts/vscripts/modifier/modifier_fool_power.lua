--傻子的力量
--------------------------------------------------------------------------------
modifier_fool_power = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_fool_power:IsHidden()return false end
function modifier_fool_power:IsDebuff()return false end
function modifier_fool_power:IsStunDebuff()return false end
function modifier_fool_power:IsPurgable()return false end
function modifier_fool_power:GetTexture() return "snapfire_gobble_up" end
function modifier_fool_power:IsPurgeException() 	return false end
function modifier_fool_power:RemoveOnDeath() return false end

function modifier_fool_power:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	
		

	}
end



function modifier_fool_power:GetModifierBonusStats_Strength()	return 15 end
function modifier_fool_power:GetModifierBonusStats_Intellect()	return 15 end
function modifier_fool_power:GetModifierBonusStats_Agility()	return 15 end
function modifier_fool_power:Advanced_GetModifierSpellAmplifyBonus()   return 20 end
function modifier_fool_power:GetModifierMagicalResistanceBonus() return 15 end

function modifier_fool_power:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end