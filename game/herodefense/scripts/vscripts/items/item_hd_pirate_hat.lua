item_hd_pirate_hat = class({})
-- LinkLuaModifier("modifier_item_hd_pirate_hat_arua", "items/item_hd_pirate_hat", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_pirate_hat_arua_effect", "items/item_hd_pirate_hat", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pirate_hat", "items/item_hd_pirate_hat", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_pirate_hat:GetIntrinsicModifierName()
	return "modifier_item_hd_pirate_hat"
end





modifier_item_hd_pirate_hat = advanced_modifier({})

function modifier_item_hd_pirate_hat:IsDebuff() return false end
function modifier_item_hd_pirate_hat:IsHidden() return true end
function modifier_item_hd_pirate_hat:IsPurgable() return false end


function modifier_item_hd_pirate_hat:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	self.bonus_attack_speed = self.ability:GetSpecialValueFor("bonus_attack_speed")
	


    if IsServer() then
		self:StartIntervalThink(0.2)
	end
end
function modifier_item_hd_pirate_hat:OnIntervalThink()
	if IsServer() then

	  local gain = self:GetCaster():GetGold()/1000
	  gain = gain - gain%1
	  self:SetStackCount(gain)

	end
end



function modifier_item_hd_pirate_hat:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		
	}
end

function modifier_item_hd_pirate_hat:GetModifierAttackSpeedBonus_Constant() 	return self.bonus_attack_speed end



function modifier_item_hd_pirate_hat:Advanced_GetModifierIncomingDamage_Percentage(keys)	return self:GetStackCount() end
-- function modifier_item_hd_pirate_hat:GetModifierTotalDamageOutgoing_Percentage(keys)	return self:GetStackCount()*2 end



-- advanced_modifier
function modifier_item_hd_pirate_hat:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end
function modifier_item_hd_pirate_hat:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self:GetStackCount()*2
end


