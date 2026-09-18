
LinkLuaModifier("modifier_item_hd_introduction_of_arcane", "items/item_hd_introduction_of_arcane", LUA_MODIFIER_MOTION_NONE)


item_hd_introduction_of_arcane = class({})

--------------------------------------------------------------------------------

-- function item_hd_introduction_of_arcane:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_introduction_of_arcane:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_introduction_of_arcane", {index = 1})
		if self:GetCaster():HasModifier("modifier_Advanced_ancient_seal_unlock1") and 35>=RandomInt(1, 100) then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_introduction_of_arcane", {index = 1})
		end
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_introduction_of_arcane = advanced_modifier({})

function modifier_item_hd_introduction_of_arcane:IsDebuff() return false end
function modifier_item_hd_introduction_of_arcane:IsHidden() return false end
function modifier_item_hd_introduction_of_arcane:IsPurgable() return false end
function modifier_item_hd_introduction_of_arcane:IsPurgeException() return false end
function modifier_item_hd_introduction_of_arcane:GetTexture()return "item_introduction_of_arcane" end
function modifier_item_hd_introduction_of_arcane:RemoveOnDeath() return false end
function modifier_item_hd_introduction_of_arcane:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.index)
	end
end
function modifier_item_hd_introduction_of_arcane:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(keys.index+self:GetStackCount())
	end
end

function modifier_item_hd_introduction_of_arcane:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS
    }
end
function modifier_item_hd_introduction_of_arcane:Advanced_GetModifierSpellAmplifyBonus() return  self:GetStackCount()*4 end
