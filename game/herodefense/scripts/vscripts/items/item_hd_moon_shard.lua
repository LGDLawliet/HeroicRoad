
LinkLuaModifier("modifier_item_hd_moon_shard", "items/item_hd_moon_shard", LUA_MODIFIER_MOTION_NONE)


item_hd_moon_shard = class({})

--------------------------------------------------------------------------------

-- function item_hd_moon_shard:GetBehavior()
-- 	return DOTA_ABILITY_BEHAVIOR_IMMEDIATE
-- end

--------------------------------------------------------------------------------

function item_hd_moon_shard:OnSpellStart()
	if IsServer() then
		local mana_restore_pct = self:GetSpecialValueFor( "mana_restore_pct" )
		self:GetCaster():EmitSoundParams( "DOTA_Item.Force_Boots.Cast", 0, 0.5, 0 )

		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_hd_moon_shard", {})
		self:SpendCharge(0)
	end
end

--------------------------------------------------------------------------------


modifier_item_hd_moon_shard = class({})

function modifier_item_hd_moon_shard:IsDebuff() return false end
function modifier_item_hd_moon_shard:IsHidden() return false end
function modifier_item_hd_moon_shard:IsPurgable() return false end
function modifier_item_hd_moon_shard:RemoveOnDeath() return false end
function modifier_item_hd_moon_shard:GetTexture()return "item_moon_shard" end



function modifier_item_hd_moon_shard:DeclareFunctions()
    return 
    {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
}
end

function modifier_item_hd_moon_shard:GetModifierAttackSpeedBonus_Constant() return  60 end


