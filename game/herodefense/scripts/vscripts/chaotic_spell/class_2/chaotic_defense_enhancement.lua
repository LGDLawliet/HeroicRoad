chaotic_defense_enhancement = class({})
LinkLuaModifier("modifier_chaotic_defense_enhancement", "chaotic_spell/class_2/chaotic_defense_enhancement", LUA_MODIFIER_MOTION_NONE)

function chaotic_defense_enhancement:GetIntrinsicModifierName() return "modifier_chaotic_defense_enhancement" end


modifier_chaotic_defense_enhancement = advanced_modifier({})

function modifier_chaotic_defense_enhancement:IsDebuff()			return false end
function modifier_chaotic_defense_enhancement:IsHidden() 		return true end
function modifier_chaotic_defense_enhancement:IsPurgable() 		return false end
function modifier_chaotic_defense_enhancement:IsPurgeException() return false end

function modifier_chaotic_defense_enhancement:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
    }
end

function modifier_chaotic_defense_enhancement:OnCreated()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.armor = self.ability:GetSpecialValueFor("armor")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")
	if self.ability:GetRuneType()==2 then
		self.armor = self.armor - self.ability:GetSpecialValueFor("rune_2_armor")
		self.attack_slow = self.attack_slow * (1-self.ability:GetSpecialValueFor("rune_2_speed_down")*0.01)
	end
	if self.ability:GetRuneType()==3 then
		self.armor = self.armor + self.ability:GetSpecialValueFor("rune_3_armor")
		self.attack_slow = self.attack_slow * (1+self.ability:GetSpecialValueFor("rune_3_speed_down")*0.01)
	end
end

function modifier_chaotic_defense_enhancement:OnRefresh() 
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.armor = self.ability:GetSpecialValueFor("armor")
	self.bonus_armor = self.ability:GetSpecialValueFor("bonus_armor")
	self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")
	if self.ability:GetRuneType()==2 then
		self.armor = self.armor - self.ability:GetSpecialValueFor("rune_2_armor")
		self.attack_slow = self.attack_slow * (1-self.ability:GetSpecialValueFor("rune_2_speed_down")*0.01)
	end
	if self.ability:GetRuneType()==3 then
		self.armor = self.armor + self.ability:GetSpecialValueFor("rune_3_armor")
		self.attack_slow = self.attack_slow * (1+self.ability:GetSpecialValueFor("rune_3_speed_down")*0.01)
	end
end

function modifier_chaotic_defense_enhancement:Advanced_GetModifierPhysicalArmorBonus() 
	if self.parent:PassivesDisabled() then
		return 0
	end
	if self.ability:GetRuneType()==1 and not self.parent:IsMoving() then
		return self.armor + self.ability:GetSpecialValueFor("rune_1_armor")
	end
	return self.armor
end

function modifier_chaotic_defense_enhancement:Advanced_GetModifierPhysicalArmorBonusPercentage() 
	if self.parent:PassivesDisabled() then
		return 0
	end
	return self.bonus_armor
end

function modifier_chaotic_defense_enhancement:Advanced_GetModifierAttackSpeedPercentage() 
	if self.parent:PassivesDisabled() then
		return 0
	end
	return -self.attack_slow
end
