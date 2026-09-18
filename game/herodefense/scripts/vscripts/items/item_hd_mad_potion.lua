
LinkLuaModifier("modifier_item_hd_mad_potion_active", "items/item_hd_mad_potion", LUA_MODIFIER_MOTION_NONE)


item_hd_mad_potion = class({})

--------------------------------------------------------------------------------

-- function item_hd_mad_potion:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_mad_potion:OnSpellStart()
	if IsServer() then
		-- local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.MaskOfMadness.Activate", 0, 0.5, 0 )
		
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_mad_potion_active", {})

		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_mad_potion_active = advanced_modifier({})

function modifier_item_hd_mad_potion_active:IsDebuff() return false end
function modifier_item_hd_mad_potion_active:IsHidden() return false end
function modifier_item_hd_mad_potion_active:IsPurgable() return false end
function modifier_item_hd_mad_potion_active:GetTexture()return "item_mad_potion" end
function modifier_item_hd_mad_potion_active:RemoveOnDeath() return false end


function modifier_item_hd_mad_potion_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end


function modifier_item_hd_mad_potion_active:GetModifierAttackSpeedBonus_Constant() 	return 60 end



function modifier_item_hd_mad_potion_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_CastPoint
    }
end
function modifier_item_hd_mad_potion_active:Advanced_GetModifierPhysicalArmorBonus()
    return -15
end
function modifier_item_hd_mad_potion_active:Advanced_GetModifier_CastPoint() return 20 end


