LinkLuaModifier( "modifier_chaotic_guardian_block", "chaotic_spell/class_1/chaotic_guardian_block.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_guardian_block_disarm", "chaotic_spell/class_1/chaotic_guardian_block.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_qi", "chaotic_spell/class_1/chaotic_flurry_of_blows.lua", LUA_MODIFIER_MOTION_NONE )

--Abilities
if chaotic_guardian_block == nil then
	chaotic_guardian_block = class({})
end
function chaotic_guardian_block:GetIntrinsicModifierName()
	return "modifier_chaotic_guardian_block"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chaotic_guardian_block == nil then
	modifier_chaotic_guardian_block = class({})
end
function modifier_chaotic_guardian_block:OnCreated(params)
	if IsServer() then
		self.damage_blocked = self:GetAbility():GetSpecialValueFor("damage_blocked")
		self.disarm_duration = self:GetAbility():GetSpecialValueFor("disarm_duration")
		self.blocked_get_qi = self:GetAbility():GetSpecialValueFor("blocked_get_qi")
		self.blocked_mul_qi = self:GetAbility():GetSpecialValueFor("blocked_mul_qi")
		self.blocked_get_qi_max = self:GetAbility():GetSpecialValueFor("blocked_get_qi_max")
		self.block_mul_chance = self:GetAbility():GetSpecialValueFor("block_mul_chance")
	end
end
function modifier_chaotic_guardian_block:OnRefresh(params)
	if IsServer() then
		self.damage_blocked = self:GetAbility():GetSpecialValueFor("damage_blocked")*self:GetParent():GetStrength()
		self.disarm_duration = self:GetAbility():GetSpecialValueFor("disarm_duration")
		self.blocked_get_qi = self:GetAbility():GetSpecialValueFor("blocked_get_qi")
		self.blocked_mul_qi = self:GetAbility():GetSpecialValueFor("blocked_mul_qi")
		self.blocked_get_qi_max = self:GetAbility():GetSpecialValueFor("blocked_get_qi_max")
		self.block_mul_chance = self:GetAbility():GetSpecialValueFor("block_mul_chance")
	end
end
function modifier_chaotic_guardian_block:OnDestroy()	

end
function modifier_chaotic_guardian_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end

function modifier_chaotic_guardian_block:GetModifierTotal_ConstantBlock(params)
	if self:GetParent():HasModifier("modifier_chaotic_qi") then
		local modifier_chaotic_qi = self:GetParent():FindModifierByName("modifier_chaotic_qi")
		modifier_chaotic_qi:SetStackCount(modifier_chaotic_qi:GetStackCount() + self.blocked_get_qi)
		if modifier_chaotic_qi:GetStackCount() > self.blocked_mul_qi and math.random(1, 100) <= self.block_mul_chance then
			self.block_mul = 2
			modifier_chaotic_qi:SetStackCount(modifier_chaotic_qi:GetStackCount() + self.blocked_get_qi_max)
		else
			self.block_mul = 1
		end
	else
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_qi", {stacks = 1})
		self.block_mul = 1
	end
	if params.damage > (self.damage_blocked * self.block_mul) and self:GetAbility():GetCooldownTimeRemaining() <= 0 then
		local addCoolDownTime =  (params.damage - self.damage_blocked * self.block_mul) * self.disarm_duration
		self:GetAbility():StartCooldown(addCoolDownTime)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_guardian_block_disarm", {duration = addCoolDownTime})
	end
	
	if self:GetAbility():GetCooldownTimeRemaining() > 0 then
		return 0
	end
	return params.damage
end
---------------------------------------------------------------------
if modifier_chaotic_guardian_block_disarm == nil then
	modifier_chaotic_guardian_block_disarm = class({})
end

function modifier_chaotic_guardian_block_disarm:IsDebuff()
	return true
end

function modifier_chaotic_guardian_block_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end
