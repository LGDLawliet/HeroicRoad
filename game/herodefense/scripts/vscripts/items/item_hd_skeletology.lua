
LinkLuaModifier("modifier_item_hd_skeletology", "items/item_hd_skeletology", LUA_MODIFIER_MOTION_NONE)


item_hd_skeletology = class({})

--------------------------------------------------------------------------------

-- function item_hd_skeletology:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_skeletology:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_skeletology", {index = 1})
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_skeletology = advanced_modifier({})

function modifier_item_hd_skeletology:IsDebuff() return false end
function modifier_item_hd_skeletology:IsHidden() return false end
function modifier_item_hd_skeletology:IsPurgable() return false end
function modifier_item_hd_skeletology:GetTexture()return "item_skeletology" end
function modifier_item_hd_skeletology:RemoveOnDeath() return false end
function modifier_item_hd_skeletology:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_item_hd_skeletology:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.index+self:GetStackCount())
	end
end

function modifier_item_hd_skeletology:DeclareFunctions()
    return 
    {
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		-- MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
		MODIFIER_PROPERTY_TOOLTIP
}
end

-- function modifier_item_hd_skeletology:GetModifierTotalDamageOutgoing_Percentage()	return self:GetStackCount()*2 end
function modifier_item_hd_skeletology:OnTooltip()
	return self:Advanced_GetModifierTotalDamageOutgoing_Percentage()
end

function modifier_item_hd_skeletology:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_item_hd_skeletology:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
    return self:GetStackCount()*2
end

function modifier_item_hd_skeletology:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():IsRealHero() then
			local modifier = unit:AddNewModifier(self:GetParent(), nil, "modifier_item_hd_skeletology", {index = self:GetStackCount()})

		end
		
	
	end
end