LinkLuaModifier( "modifier_chaotic_warlord_fever", "chaotic_spell/class_3/chaotic_warlord_fever.lua", LUA_MODIFIER_MOTION_NONE )

chaotic_warlord_fever = class({})

function chaotic_warlord_fever:GetIntrinsicModifierName()
	return "modifier_chaotic_warlord_fever"
end
------------------
modifier_chaotic_warlord_fever = advanced_modifier({})
function modifier_chaotic_warlord_fever:IsHidden() 	return false end
function modifier_chaotic_warlord_fever:IsPurgable() 		    return false end
function modifier_chaotic_warlord_fever:IsPurgeException() return false end
function modifier_chaotic_warlord_fever:RemoveOnDeath() return false end

function modifier_chaotic_warlord_fever:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self.stack_multiplier = self.ability:GetSpecialValueFor("attack_speed")
	self.max_stacks = self.ability:GetSpecialValueFor("count_max")
	self.count_loss = self.ability:GetSpecialValueFor("count_loss")
	self.type = self.ability:GetRuneType()
	self.rune_1_chance = self.ability:GetSpecialValueFor("rune_1_chance")
	self.rune_1_armor = self.ability:GetSpecialValueFor("rune_1_armor")
	self.currentTarget = {}
	self:SetStackCount(0)
end
function modifier_chaotic_warlord_fever:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_chaotic_warlord_fever:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH = {self:GetParent(),nil},
		MODIFIER_EVENT_ON_ATTACK = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_chaotic_warlord_fever:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()*self.stack_multiplier
end
function modifier_chaotic_warlord_fever:Advanced_GetModifierPhysicalArmorBonus()
	if self.type == 1 and self:GetStackCount() >= self.max_stacks-1 then
		return self.rune_1_armor
	end
	return 
end
function modifier_chaotic_warlord_fever:OnAttack(keys)
	if not IsServer() then return end
	local attacker = keys.attacker
	local now_target = keys.target
	if attacker ~= self.parent then return end
	if attacker:IsInSpecialAttack() then return end

	if self.currentTarget == now_target then
		self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stacks))
	else
		if self.type == 1 then
			local random = math.random
			if self.rune_1_chance >= random(1,100) then
				return 
			else
				self:SetStackCount(math.max(self:GetStackCount()-self.count_loss,0))
			end
		else
			self:SetStackCount(math.max(self:GetStackCount()-self.count_loss,0))
		end
		self.currentTarget = now_target
		self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stacks))
	end
end


