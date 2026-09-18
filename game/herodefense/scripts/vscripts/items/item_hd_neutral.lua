
LinkLuaModifier("modifier_item_hd_neutral", "items/item_hd_neutral", LUA_MODIFIER_MOTION_NONE)


item_hd_neutral = class({})

--------------------------------------------------------------------------------

-- function item_hd_neutral:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_neutral:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		local nTeamNumber = self:GetCaster():GetTeamNumber()
		local Heroes =GetAllRealHeroes()

		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == nTeamNumber then
				Hero:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_neutral", {index = 1})
			
			end
		end

		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_neutral = advanced_modifier({})

function modifier_item_hd_neutral:IsDebuff() return false end
function modifier_item_hd_neutral:IsHidden() return false end
function modifier_item_hd_neutral:IsPurgable() return false end
function modifier_item_hd_neutral:GetTexture()return "item_neutral" end
function modifier_item_hd_neutral:RemoveOnDeath() return false end
function modifier_item_hd_neutral:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)

	end
end
function modifier_item_hd_neutral:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.index+self:GetStackCount())
	end
end





-- advanced_modifier
function modifier_item_hd_neutral:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEAL_Receive_AMP_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_neutral:Advanced_GetModifierHealReceiveAMP_Percentage(keys)
	return 8*self:GetStackCount()
end

