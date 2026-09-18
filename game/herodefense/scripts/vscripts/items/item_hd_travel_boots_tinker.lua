LinkLuaModifier("modifier_item_hd_travel_boots_tinker", "items/item_hd_travel_boots_tinker", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_travel_boots_tinker_buff", "items/item_hd_travel_boots_tinker", LUA_MODIFIER_MOTION_NONE)
item_hd_travel_boots_tinker = class({})

function item_hd_travel_boots_tinker:GetIntrinsicModifierName()
    return "modifier_item_hd_travel_boots_tinker"
end

---------------------------------------------------------------------
modifier_item_hd_travel_boots_tinker = advanced_modifier({})

function modifier_item_hd_travel_boots_tinker:IsHidden()return true end
function modifier_item_hd_travel_boots_tinker:IsPurgable()return false end

function modifier_item_hd_travel_boots_tinker:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.chance = self.ability:GetSpecialValueFor("chance")
	self.outgoing  = self.ability:GetSpecialValueFor("outgoing")
	self.move_speed  = self.ability:GetSpecialValueFor("move_speed")
	self.evasion  = self.ability:GetSpecialValueFor("evasion")
end
function modifier_item_hd_travel_boots_tinker:CheckState()
	return{
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_item_hd_travel_boots_tinker:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
    }
end

function modifier_item_hd_travel_boots_tinker:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL
    }
end
function modifier_item_hd_travel_boots_tinker:GetModifierMoveSpeedBonus_Constant()
    return self.move_speed
end
function modifier_item_hd_travel_boots_tinker:GetModifierEvasion_Constant()
    return self.evasion
end
function modifier_item_hd_travel_boots_tinker:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end
function modifier_item_hd_travel_boots_tinker:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if self.parent:IsMoving() then
		if self.chance >= math.random(1,100) then
			return self.outgoing
		end
	end
	return 0
end
--
-- modifier_item_hd_travel_boots_tinker_buff = advanced_modifier({})

-- function modifier_item_hd_travel_boots_tinker_buff:IsHidden()return false end
-- function modifier_item_hd_travel_boots_tinker_buff:IsPurgable()return false end

-- function modifier_item_hd_travel_boots_tinker_buff:OnCreated()
--     self.parent = self:GetParent()
--     self.ability = self:GetAbility()
--     self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
-- end

-- -- function modifier_item_hd_travel_boots_tinker:DeclareFunctions()
-- --     return{
-- --         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
-- --     }
-- -- end

-- function modifier_item_hd_travel_boots_tinker_buff:ADDeclareFunctions()
--     return {
--         advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
--     }
-- end

-- function modifier_item_hd_travel_boots_tinker_buff:Advanced_GetModifier_TalentEffectGain()
-- 	if not self:GetAbility() then self:Destroy() return end
--     return self.bonus_profic
-- end


