
LinkLuaModifier("modifier_item_hd_royal_jelly2", "items/item_hd_royal_jelly2", LUA_MODIFIER_MOTION_NONE)


item_hd_royal_jelly2 = class({})

--------------------------------------------------------------------------------

-- function item_hd_royal_jelly2:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_royal_jelly2:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Mango.Activate", 0, 0.5, 0 )
		local nTeamNumber = self:GetCaster():GetTeamNumber()
		local Heroes = GetAllRealHeroes()
		for _,Hero in pairs ( Heroes ) do
			if Hero ~= nil and Hero:IsRealHero() and Hero:GetTeamNumber() == nTeamNumber then
				Hero:AddNewModifier(self:GetCaster(), self, "modifier_item_hd_royal_jelly2", {})
			
			end
		end
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_royal_jelly2 = advanced_modifier({})

function modifier_item_hd_royal_jelly2:IsDebuff() return false end
function modifier_item_hd_royal_jelly2:IsHidden() return false end
function modifier_item_hd_royal_jelly2:IsPurgable() return false end
function modifier_item_hd_royal_jelly2:IsPurgeException() return false end
function modifier_item_hd_royal_jelly2:GetTexture()return "item_royal_jelly2" end
function modifier_item_hd_royal_jelly2:RemoveOnDeath() return false end
function modifier_item_hd_royal_jelly2:OnCreated()
	if IsServer() then
		self:SetStackCount(1)
	end
end
function modifier_item_hd_royal_jelly2:OnRefresh()
	if IsServer() then
		self:IncrementStackCount()
	end
end



function modifier_item_hd_royal_jelly2:AdvancedGetModifierConstantHealthRegen()return self:GetStackCount() end
function modifier_item_hd_royal_jelly2:AdvancedGetModifierConstantManaRegen()return self:GetStackCount() end

function modifier_item_hd_royal_jelly2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT

    }
end
