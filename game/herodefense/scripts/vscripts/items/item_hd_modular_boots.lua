item_hd_modular_boots = class({})
-- LinkLuaModifier("modifier_item_hd_modular_boots_arua", "items/item_hd_modular_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_boots_arua_effect", "items/item_hd_modular_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_modular_boots", "items/item_hd_modular_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_boots_buff", "items/item_hd_modular_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_modular_boots_debuff", "items/item_hd_modular_boots", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_modular_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_modular_boots"
end





function item_hd_modular_boots:Precache( context )
	PrecacheResource( "particle", "models/items/razor/razor_arcana/debut/particles/razor_arcana_debut_strike_top_sword.vpcf", context )
	-- PrecacheResource( "particle", "particles/units/heroes/hero_omniknight/omniknight_purification_hit.vpcf", context )
end



modifier_item_hd_modular_boots = modifier_item_hd_modular_boots or class({})

function modifier_item_hd_modular_boots:IsDebuff() return false end
function modifier_item_hd_modular_boots:IsHidden() return true end
function modifier_item_hd_modular_boots:IsPurgable() return false end
function modifier_item_hd_modular_boots:OnCreated(keys)
    -- local parent = self:GetParent()

	local ability = self:GetAbility()
	-- self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_move_speed =ability:GetSpecialValueFor( "bonus_move_speed" ) 
	-- if IsServer() then
	-- 	self:StartIntervalThink(0.5)
	-- end
end

function modifier_item_hd_modular_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT

	}
end


function modifier_item_hd_modular_boots:GetModifierMoveSpeedBonus_Constant() return self.bonus_move_speed end
function modifier_item_hd_modular_boots:CheckState()
	if not self:GetParent():IsRealHero() then
		return 
	end
	local state = {
		-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSLOWABLE] = true,
	}

	return state
	

end


