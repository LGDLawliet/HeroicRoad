
Primary_Soul_Link = class({})


LinkLuaModifier("modifier_Primary_Soul_Link", "skills/Primary_Soul_Link", LUA_MODIFIER_MOTION_NONE)

function Primary_Soul_Link:GetIntrinsicModifierName() return "modifier_Primary_Soul_Link" end
function Primary_Soul_Link:IsHiddenWhenStolen() 		return false end
function Primary_Soul_Link:IsRefreshable() 			return true  end
function Primary_Soul_Link:IsStealable() 			return true  end
function Primary_Soul_Link:IsNetherWardStealable()	return true end



modifier_Primary_Soul_Link= advanced_modifier({})

function modifier_Primary_Soul_Link:IsDebuff()			return false end
function modifier_Primary_Soul_Link:IsHidden() 			return true end
function modifier_Primary_Soul_Link:IsPurgable() 		return false end
function modifier_Primary_Soul_Link:IsPurgeException() 	return false end

function modifier_Primary_Soul_Link:OnCreated(keys)
    self.ability = self:GetAbility()
end


-- -- advanced_modifier
function modifier_Primary_Soul_Link:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_Summon_Intensity,
    }
end
function modifier_Primary_Soul_Link:Advanced_GetModifier_Summon_Intensity(keys)
	
	return self.ability:GetSpecialValueFor("bonus_summon_intensity")
end

