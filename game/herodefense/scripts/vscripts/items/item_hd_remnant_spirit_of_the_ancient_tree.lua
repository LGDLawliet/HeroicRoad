item_hd_remnant_spirit_of_the_ancient_tree = class({})
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_arua", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_arua_effect", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_active", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_effect", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_effect2", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_active_standby", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_debuff", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_remnant_spirit_of_the_ancient_tree_thinker", "items/item_hd_remnant_spirit_of_the_ancient_tree", LUA_MODIFIER_MOTION_NONE)



-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_remnant_spirit_of_the_ancient_tree:GetIntrinsicModifierName()
	return "modifier_item_hd_remnant_spirit_of_the_ancient_tree"
end





modifier_item_hd_remnant_spirit_of_the_ancient_tree = advanced_modifier({})

function modifier_item_hd_remnant_spirit_of_the_ancient_tree:IsDebuff() return false end
function modifier_item_hd_remnant_spirit_of_the_ancient_tree:IsHidden() return true end
function modifier_item_hd_remnant_spirit_of_the_ancient_tree:IsPurgable() return false end



function modifier_item_hd_remnant_spirit_of_the_ancient_tree:OnCreated(keys)
    self.ability = self:GetAbility()

 
   
	self.bonus_str = self.ability:GetSpecialValueFor("bonus_str")
	self.bonus_health_regeneration = self.ability:GetSpecialValueFor("bonus_health_regeneration")
	

    if IsServer() then

		self:StartIntervalThink(1)

	end
end
function modifier_item_hd_remnant_spirit_of_the_ancient_tree:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(RandomInt(0,500))
	end
end



function modifier_item_hd_remnant_spirit_of_the_ancient_tree:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量

	}
end


function modifier_item_hd_remnant_spirit_of_the_ancient_tree:GetModifierBonusStats_Strength()	return self.bonus_str end
function modifier_item_hd_remnant_spirit_of_the_ancient_tree:AdvancedGetModifierConstantHealthRegen()	return self.bonus_health_regeneration end
function modifier_item_hd_remnant_spirit_of_the_ancient_tree:AdvancedGetModifierConstantHealthRegenPercentage() 	return self:GetStackCount()/100 -2 end


function modifier_item_hd_remnant_spirit_of_the_ancient_tree:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE


    }
end
