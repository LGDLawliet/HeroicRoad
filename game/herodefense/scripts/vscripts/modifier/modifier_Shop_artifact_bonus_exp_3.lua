modifier_Shop_artifact_bonus_exp_3 = advanced_modifier({})

function modifier_Shop_artifact_bonus_exp_3:IsDebuff() return false end
function modifier_Shop_artifact_bonus_exp_3:IsHidden() return true end
function modifier_Shop_artifact_bonus_exp_3:IsPurgable() return false end
function modifier_Shop_artifact_bonus_exp_3:RemoveOnDeath() return false end
function modifier_Shop_artifact_bonus_exp_3:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Item_GenerateCount,
        advanced_MODIFIER_PROPERTY_Chaotic_Era_Spell_GenerateCount
    }
end

function modifier_Shop_artifact_bonus_exp_3:Advanced_GetChaotic_Era_Item_GenerateCount()
	return 1
end
function modifier_Shop_artifact_bonus_exp_3:Advanced_GetChaotic_Era_Spell_GenerateCount()
	return 1
end