item_hd_phase_boots = class({})
-- LinkLuaModifier("modifier_item_hd_phase_boots_arua", "items/item_hd_phase_boots", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_phase_boots_arua_effect", "items/item_hd_phase_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phase_boots", "items/item_hd_phase_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_phase_boots_active", "items/item_hd_phase_boots", LUA_MODIFIER_MOTION_NONE)

-- Item Passive
function item_hd_phase_boots:GetIntrinsicModifierName()
	return "modifier_item_hd_phase_boots"
end




modifier_item_hd_phase_boots = advanced_modifier({})

function modifier_item_hd_phase_boots:IsDebuff() return false end
function modifier_item_hd_phase_boots:IsHidden() return true end
function modifier_item_hd_phase_boots:IsPurgable() return false end
-- function modifier_item_hd_phase_boots:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end



function modifier_item_hd_phase_boots:OnCreated(keys)
    self.ability = self:GetAbility()
	self.bonus_move = self.ability:GetSpecialValueFor("bonus_move")
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.duration = self.ability:GetSpecialValueFor("duration")
    if IsServer() then
		-- self.modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_item_hd_phase_boots_arua", {})
		self:StartIntervalThink(0.1)

	end

end
function modifier_item_hd_phase_boots:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then
		
		ProjectileManager:ProjectileDodge(self:GetParent()) --弹道躲闪
		local ModifierStatusGain = self:GetParent():GetModifierDurationGainIndex(1)
		self.modifier =self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_hd_phase_boots_active", {duration= self.duration*ModifierStatusGain})
		self:GetAbility():UseResources(true, true, true,true)
	end
end



function modifier_item_hd_phase_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,       --移动速度
	}
end


function modifier_item_hd_phase_boots:GetModifierMoveSpeedBonus_Constant()return self.bonus_move end

function modifier_item_hd_phase_boots:Advanced_GetModifierPreAttack_BonusDamage() return self.bonus_damage end
function modifier_item_hd_phase_boots:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,    
    }
end
function modifier_item_hd_phase_boots:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end



modifier_item_hd_phase_boots_active = class({})

function modifier_item_hd_phase_boots_active:IsDebuff() return false end
function modifier_item_hd_phase_boots_active:IsHidden() return false end
function modifier_item_hd_phase_boots_active:IsPurgable() return true end
function modifier_item_hd_phase_boots_active:GetTexture()return "item_phase_boots" end
function modifier_item_hd_phase_boots_active:GetEffectAttachType() 	    return PATTACH_CENTER_FOLLOW end
function modifier_item_hd_phase_boots_active:GetEffectName() 	  return "particles/econ/events/ti9/phase_boots_ti9.vpcf" end
function modifier_item_hd_phase_boots_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,     --移动速度百分比
	}
end
function modifier_item_hd_phase_boots_active:GetModifierMoveSpeedBonus_Percentage()return self:GetAbility():GetSpecialValueFor("active_move") end
function modifier_item_hd_phase_boots_active:CheckState() return {[MODIFIER_STATE_NO_UNIT_COLLISION] = true} end