item_hd_travel_boots_lv2 = class({})

LinkLuaModifier("modifier_item_hd_travel_boots_lv2", "items/item_hd_travel_boots_lv2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_travel_boots_lv2_active", "items/item_hd_travel_boots_lv2", LUA_MODIFIER_MOTION_NONE)

function item_hd_travel_boots_lv2:GetIntrinsicModifierName()
	return "modifier_item_hd_travel_boots_lv2"
end








modifier_item_hd_travel_boots_lv2 = advanced_modifier({})

function modifier_item_hd_travel_boots_lv2:IsDebuff() return false end
function modifier_item_hd_travel_boots_lv2:IsHidden() return true end
function modifier_item_hd_travel_boots_lv2:IsPurgable() return false end


function modifier_item_hd_travel_boots_lv2:OnCreated(keys)
    self.ability = self:GetAbility()
	
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_travel_boots_lv2_arua", {})
		self:StartIntervalThink(0.1)


	end

end
function modifier_item_hd_travel_boots_lv2:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then
		local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
		self.modifier =self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_travel_boots_lv2_active", {duration= 0.5*ModifierStatusGain})
		self:GetAbility():UseResources(true, true, true,true)
	end
end


function modifier_item_hd_travel_boots_lv2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度

	}
end


function modifier_item_hd_travel_boots_lv2:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

-- advanced_modifier
function modifier_item_hd_travel_boots_lv2:ADDeclareFunctions()
    return 
    {
		advanced_MODIFIER_PROPERTY_DEFAULT_MOVE_CAST_RANGE
    }
end
function modifier_item_hd_travel_boots_lv2:Advanced_GetModifier_DefaultMoveCastRange(keys)
	return 300
end



modifier_item_hd_travel_boots_lv2_active = class({})

function modifier_item_hd_travel_boots_lv2_active:IsDebuff() return false end
function modifier_item_hd_travel_boots_lv2_active:IsHidden() return false end
function modifier_item_hd_travel_boots_lv2_active:IsPurgable() return true end
function modifier_item_hd_travel_boots_lv2_active:GetTexture()return "item_travel_boots_2" end
function modifier_item_hd_travel_boots_lv2_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_travel_boots_lv2_active:GetEffectName() 	  return "particles/econ/events/spring_2021/phase_boots_spring_2021.vpcf" end
function modifier_item_hd_travel_boots_lv2_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end
function modifier_item_hd_travel_boots_lv2_active:GetModifierIgnoreMovespeedLimit()             return   1  end
function modifier_item_hd_travel_boots_lv2_active:GetModifierMoveSpeedBonus_Constant()return 1000 end

