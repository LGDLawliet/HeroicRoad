item_hd_ex_machina = class({})
-- LinkLuaModifier("modifier_item_hd_ex_machina_arua", "items/item_hd_ex_machina", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_item_hd_ex_machina_arua_effect", "items/item_hd_ex_machina", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ex_machina", "items/item_hd_ex_machina", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能
function item_hd_ex_machina:GetIntrinsicModifierName()
	return "modifier_item_hd_ex_machina"
end






modifier_item_hd_ex_machina = advanced_modifier({})

function modifier_item_hd_ex_machina:IsDebuff() return false end
function modifier_item_hd_ex_machina:IsHidden() return true end
function modifier_item_hd_ex_machina:IsPurgable() return false end
function modifier_item_hd_ex_machina:OnCreated(keys)
    self.ability = self:GetAbility()

 
    local parent = self:GetParent()

	
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")

	


    if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_item_hd_ex_machina:OnIntervalThink()
	if IsServer() then
		for i=0, self:GetCaster():GetAbilityCount() - 1 do
			local Ability = self:GetCaster():GetAbilityByIndex(i)
			if Ability ~= nil and Ability ~= self  and Ability:GetAbilityType() ~= 1 and not Ability:IsCooldownReady() then
				local time = 0.4
				if not Ability:IsRefreshable() then
					time = 0.2
				end
				local newCooldown = Ability:GetCooldownTimeRemaining() - time
				Ability:EndCooldown()
				Ability:StartCooldown(newCooldown)
				break
			end
		end
	end
end



function modifier_item_hd_ex_machina:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_item_hd_ex_machina:Advanced_GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end