item_hd_artifact_ironwood_tree = class({})

LinkLuaModifier("modifier_item_hd_artifact_ironwood_tree", "items/item_hd_artifact_ironwood_tree", LUA_MODIFIER_MOTION_NONE)



function item_hd_artifact_ironwood_tree:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_artifact_ironwood_tree", {index=1})
	self:SpendCharge(0)
end

modifier_item_hd_artifact_ironwood_tree = advanced_modifier({})

function modifier_item_hd_artifact_ironwood_tree:IsDebuff() return false end
function modifier_item_hd_artifact_ironwood_tree:IsHidden() return false end
function modifier_item_hd_artifact_ironwood_tree:IsPurgable() return false end
function modifier_item_hd_artifact_ironwood_tree:IsPurgeException() return false end
function modifier_item_hd_artifact_ironwood_tree:RemoveOnDeath() return false end
function modifier_item_hd_artifact_ironwood_tree:GetTexture() return "item_ironwood_tree" end
function modifier_item_hd_artifact_ironwood_tree:OnCreated(keys)
	self.bonus =   GetChaticEra_Artifact_Special("iron_tree_branches_guard","bonus_attribute")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_item_hd_artifact_ironwood_tree:OnRefresh(keys)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_item_hd_artifact_ironwood_tree:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
    }
end
function modifier_item_hd_artifact_ironwood_tree:Advanced_GetModifierBonusStats_Strength()	
	return self.bonus * self:GetStackCount()
end
function modifier_item_hd_artifact_ironwood_tree:Advanced_GetModifierBonusStats_Agility()	
	return self.bonus * self:GetStackCount()
end

function modifier_item_hd_artifact_ironwood_tree:Advanced_GetModifierBonusStats_Intellect()	
	return self.bonus * self:GetStackCount()
end



function modifier_item_hd_artifact_ironwood_tree:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_TOOLTIP,
	}
end



function modifier_item_hd_artifact_ironwood_tree:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 1 + 1
	if self._tooltip == 1 then
		return  self:Advanced_GetModifierBonusStats_Intellect()
	end
end
