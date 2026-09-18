
LinkLuaModifier("modifier_item_hd_advanced_mathematics", "items/item_hd_advanced_mathematics", LUA_MODIFIER_MOTION_NONE)


item_hd_advanced_mathematics = class({})

--------------------------------------------------------------------------------

-- function item_hd_advanced_mathematics:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_advanced_mathematics:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_advanced_mathematics", {index = 1})
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_advanced_mathematics = advanced_modifier({})

function modifier_item_hd_advanced_mathematics:IsDebuff() return false end
function modifier_item_hd_advanced_mathematics:IsHidden() return false end
function modifier_item_hd_advanced_mathematics:IsPurgable() return false end
function modifier_item_hd_advanced_mathematics:IsPurgeException() return false end
function modifier_item_hd_advanced_mathematics:GetTexture()return "item_advanced_mathematics" end
function modifier_item_hd_advanced_mathematics:RemoveOnDeath() return false end
function modifier_item_hd_advanced_mathematics:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_item_hd_advanced_mathematics:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.index+self:GetStackCount())
	end
end


function modifier_item_hd_advanced_mathematics:Advanced_GetModifierAttackRangeBonus() return  self:GetCaster():IsRangedAttacker() and self:GetStackCount()*20 or self:GetStackCount()*10 end

function modifier_item_hd_advanced_mathematics:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }
end
function modifier_item_hd_advanced_mathematics:Advanced_GetModifierCastRangeBonusStacking(keys)
	return self:GetStackCount()*20
end