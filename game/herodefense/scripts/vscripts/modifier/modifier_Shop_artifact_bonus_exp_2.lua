modifier_Shop_artifact_bonus_exp_2 = advanced_modifier({})

function modifier_Shop_artifact_bonus_exp_2:IsDebuff() return false end
function modifier_Shop_artifact_bonus_exp_2:IsHidden() return true end
function modifier_Shop_artifact_bonus_exp_2:IsPurgable() return false end
function modifier_Shop_artifact_bonus_exp_2:RemoveOnDeath() return false end
function modifier_Shop_artifact_bonus_exp_2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_Chaotic_Era_Item_GenerateCount,
    }
end

function modifier_Shop_artifact_bonus_exp_2:Advanced_GetChaotic_Era_Item_GenerateCount()
	return 1
end