LinkLuaModifier( "modifier_chaotic_element_ice", "chaotic_spell/class_9/chaotic_element_ice.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_element_ice = class({})

function chaotic_element_ice:GetIntrinsicModifierName()
	return "modifier_chaotic_element_ice"
end
---------------------------------------------------------------------


modifier_chaotic_element_ice = advanced_modifier({})
function modifier_chaotic_element_ice:IsHidden() return true end
function modifier_chaotic_element_ice:IsPurgable() return false end
function modifier_chaotic_element_ice:OnCreated(params)
	self.outgoing_ice = self:GetAbility():GetSpecialValueFor("outgoing_ice")
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_cds = self:GetAbility():GetSpecialValueFor("bonus_cds")*0.01

	self.type = self:GetAbility():GetRuneType()
	self.rune_1_incoming = self:GetAbility():GetSpecialValueFor("rune_1_incoming")
	self.rune_1_mana = self:GetAbility():GetSpecialValueFor("rune_1_mana")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_chaotic_element_ice:OnIntervalThink()
    local hero = self:GetParent()
    
    for i=0, 11 do
		local Ability = hero:GetAbilityByIndex(i)
		if Ability ~= nil and (not Ability:IsCooldownReady()) and Ability:IsRefreshable() then
			if Ability ~= self:GetAbility()	then
				local new_cooldown = math.max(Ability:GetCooldownTimeRemaining() - self.bonus_cds,0)
				Ability:EndCooldown()
				Ability:StartCooldown(new_cooldown)
			end
		end
	end

	if self.type == 1 then
		self:SetStackCount(GetIceSpellCount(hero))
	end
end

function modifier_chaotic_element_ice:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
	if self:GetAbility():GetRuneType() == 1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
		table.insert(funcs,advanced_MODIFIER_PROPERTY_MANA_BONUS)
	end
	return funcs
end


function modifier_chaotic_element_ice:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	if not IsServer() then return end
	if not IsIceDamage(keys) then return end
	return self.outgoing_ice
end
function modifier_chaotic_element_ice:AdvancedGetModifierConstantManaRegen()
	return self.bonus_mana_regen
end
function modifier_chaotic_element_ice:Advanced_GetModifierPhysicalArmorBonus()
	return self.bonus_armor
end
--rune1
function modifier_chaotic_element_ice:AdvancedGetModifierManaBonus()
	return self:GetStackCount()*self.rune_1_mana
end
function modifier_chaotic_element_ice:Advanced_GetModifierIncomingDamage_Percentage()
	return -self:GetStackCount()*self.rune_1_incoming
end