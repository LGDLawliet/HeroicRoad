LinkLuaModifier("modifier_item_hd_occult_bracelet", "items/item_hd_occult_bracelet", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_occult_bracelet_buff", "items/item_hd_occult_bracelet", LUA_MODIFIER_MOTION_NONE)
item_hd_occult_bracelet = class({})

function item_hd_occult_bracelet:GetIntrinsicModifierName()
    return "modifier_item_hd_occult_bracelet"
end

---------------------------------------------------------------------
modifier_item_hd_occult_bracelet = advanced_modifier({})

function modifier_item_hd_occult_bracelet:IsHidden()return true end
function modifier_item_hd_occult_bracelet:IsPurgable()return false end

function modifier_item_hd_occult_bracelet:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.profic = self.ability:GetSpecialValueFor("profic")
	self.mana_regen = self.ability:GetSpecialValueFor("mana_regen")*0.01
	self.duration  = self.ability:GetSpecialValueFor("duration")
end

-- function modifier_item_hd_occult_bracelet:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
--     }
-- end

function modifier_item_hd_occult_bracelet:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil, self:GetParent()}
    }
end

function modifier_item_hd_occult_bracelet:Advanced_GetModifier_TalentEffectGain()
    return self.profic
end
function modifier_item_hd_occult_bracelet:OnTakeDamage(keys)
	if not IsServer() then return end
	local unit = keys.unit
	if unit ~= self.parent then return end

	local lost_mana = unit:GetMaxMana() - unit:GetMana()
	if lost_mana > 0 then
		unit:GiveMana(lost_mana * self.mana_regen)
	end

	local buff = unit:FindModifierByName("modifier_item_hd_occult_bracelet_buff")
	if buff then
		buff:ForceRefresh()
		buff:SetDuration(self.duration, true)
	else
		local newbuff = unit:AddNewModifier(unit, self.ability, "modifier_item_hd_occult_bracelet_buff", {duration = self.duration})
	end
end
--
modifier_item_hd_occult_bracelet_buff = advanced_modifier({})

function modifier_item_hd_occult_bracelet_buff:IsHidden()return false end
function modifier_item_hd_occult_bracelet_buff:IsPurgable()return false end

function modifier_item_hd_occult_bracelet_buff:OnCreated()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.bonus_profic = self.ability:GetSpecialValueFor("bonus_profic")
end

-- function modifier_item_hd_occult_bracelet:DeclareFunctions()
--     return{
--         MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
--     }
-- end

function modifier_item_hd_occult_bracelet_buff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TALENT_EFFECT_GAIN,
    }
end

function modifier_item_hd_occult_bracelet_buff:Advanced_GetModifier_TalentEffectGain()
	if not self:GetAbility() then self:Destroy() return end
    return self.bonus_profic
end


