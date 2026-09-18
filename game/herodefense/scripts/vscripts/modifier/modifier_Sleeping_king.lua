--肾虚之王·睡神
--减少10%的攻击速度与移动速度，但伤害增加15%
--------------------------------------------------------------------------------
modifier_Sleeping_king = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Sleeping_king:IsHidden()return false end
function modifier_Sleeping_king:IsDebuff()return false end
function modifier_Sleeping_king:IsStunDebuff()return false end
function modifier_Sleeping_king:IsPurgable()return false end
function modifier_Sleeping_king:GetTexture() return "bane/slumbering_terror/bane_nightmare" end
function modifier_Sleeping_king:IsPurgeException() 	return false end
function modifier_Sleeping_king:RemoveOnDeath() return false end

function modifier_Sleeping_king:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end



function modifier_Sleeping_king:Advanced_GetModifierAttackSpeedPercentage()	return -10 end
function modifier_Sleeping_king:GetModifierMoveSpeedBonus_Percentage()	return -10 end
-- function modifier_Sleeping_king:GetModifierTotalDamageOutgoing_Percentage()	return 15 end


-- advanced_modifier
function modifier_Sleeping_king:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end
function modifier_Sleeping_king:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return 15
end