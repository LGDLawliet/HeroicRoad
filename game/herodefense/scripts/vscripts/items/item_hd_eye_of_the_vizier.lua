item_hd_eye_of_the_vizier = class({})

LinkLuaModifier("modifier_item_hd_eye_of_the_vizier", "items/item_hd_eye_of_the_vizier", LUA_MODIFIER_MOTION_NONE)


-- function item_hd_eye_of_the_vizier:Precache( context )
-- 	PrecacheResource( "particle", "particles/econ/items/ogre_magi/ogre_magi_jackpot/ogre_magi_jackpot_multicast.vpcf", context )
-- end

function item_hd_eye_of_the_vizier:GetIntrinsicModifierName()
	return "modifier_item_hd_eye_of_the_vizier"
end


modifier_item_hd_eye_of_the_vizier = advanced_modifier({})

function modifier_item_hd_eye_of_the_vizier:IsDebuff() return false end
function modifier_item_hd_eye_of_the_vizier:IsHidden() return true end
function modifier_item_hd_eye_of_the_vizier:IsPurgable() return false end
function modifier_item_hd_eye_of_the_vizier:IsPurgeException() return false end
function modifier_item_hd_eye_of_the_vizier:RemoveOnDeath() return false end

function modifier_item_hd_eye_of_the_vizier:OnCreated(keys)
	self.bonus_all_attribute = self:GetAbility():GetSpecialValueFor("bonus_int")
	self.bonus_cast_range = self:GetAbility():GetSpecialValueFor("bonus_cast_range")
	self:StartIntervalThink(1)

end

function modifier_item_hd_eye_of_the_vizier:DeclareFunctions()
	return {
	
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		-- MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_EXTRA_MANA_PERCENTAGE,

	}
end

function modifier_item_hd_eye_of_the_vizier:GetModifierBonusStats_Intellect()return self.bonus_all_attribute end
-- function modifier_item_hd_eye_of_the_vizier:GetModifierCastRangeBonusStacking()return self.bonus_cast_range end


function modifier_item_hd_eye_of_the_vizier:GetModifierExtraManaPercentage()return -20 end
function modifier_item_hd_eye_of_the_vizier:OnIntervalThink()
	local parent = self:GetParent()
	if (parent:GetMana()/parent:GetMaxMana())<=0.4 then
		self:SetStackCount(parent:GetIntellect(false)*0.1)
	else
		self:SetStackCount(0)
	end
end

function modifier_item_hd_eye_of_the_vizier:GetModifierConstantManaRegen()
	return self:GetStackCount()

end


-- advanced_modifier
function modifier_item_hd_eye_of_the_vizier:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
    }
end
function modifier_item_hd_eye_of_the_vizier:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self.bonus_cast_range 
end