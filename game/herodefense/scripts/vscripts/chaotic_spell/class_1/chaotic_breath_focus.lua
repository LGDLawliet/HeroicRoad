chaotic_breath_focus = chaotic_breath_focus or class({})

LinkLuaModifier("modifier_chaotic_breath_focus", "chaotic_spell/class_1/chaotic_breath_focus", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_breath_focus_rune_3", "chaotic_spell/class_1/chaotic_breath_focus", LUA_MODIFIER_MOTION_NONE)

function chaotic_breath_focus:GetIntrinsicModifierName()
	return "modifier_chaotic_breath_focus"
end
----------------------------------------------------------------------------------------------------------
modifier_chaotic_breath_focus = modifier_chaotic_breath_focus or advanced_modifier({})

function modifier_chaotic_breath_focus:IsDebuff() return false end
function modifier_chaotic_breath_focus:IsPurgable()	return false end
function modifier_chaotic_breath_focus:RemoveOnDeath() return false end
function modifier_chaotic_breath_focus:IsPurgeException() return false end
function modifier_chaotic_breath_focus:IsHidden() return false end
function modifier_chaotic_breath_focus:OnCreated(keys)
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	self.hide_cooldown = self:GetAbility():GetSpecialValueFor("hide_cooldown")
	if self:GetAbility():GetRuneType()==1 then
		self.damage_reduction = self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")
		self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow") +  self:GetAbility():GetSpecialValueFor("rune_1_move_down")
	end
	if IsServer() and self:GetAbility():GetRuneType()==3 then
		self.rune_3_bonus_damage = self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage")
		self.rune_3_bonus_damage_max = self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage_max")
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_breath_focus:OnRefresh(keys)
	self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	self.hide_cooldown = self:GetAbility():GetSpecialValueFor("hide_cooldown")
	if self:GetAbility():GetRuneType()==1 then
		self.damage_reduction = self:GetAbility():GetSpecialValueFor("rune_1_bonus_damage")
		self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow") +  self:GetAbility():GetSpecialValueFor("rune_1_move_down")
		self.rune_3_bonus_damage = self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage")
		self.rune_3_bonus_damage_max = self:GetAbility():GetSpecialValueFor("rune_3_bonus_damage_max")
	end
end

function modifier_chaotic_breath_focus:OnIntervalThink()
	if IsServer() and self:GetAbility():IsCooldownReady() then
		self:SetStackCount(math.min((self:GetStackCount() + self.rune_3_bonus_damage),self.rune_3_bonus_damage_max))
	end
end


function modifier_chaotic_breath_focus:CheckState()
	if IsServer() and self:GetAbility():IsCooldownReady() then
		return {
			[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		}
	end
	return
end

function modifier_chaotic_breath_focus:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
	return funcs
end


function modifier_chaotic_breath_focus:GetModifierMoveSpeedBonus_Constant()
	return -self.move_slow
end

function modifier_chaotic_breath_focus:AdvancedGetModifierConstantManaRegen()	
	return self.mana_regen
end

function modifier_chaotic_breath_focus:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
	local final_damage = -self.damage_reduction
	if self:GetAbility():GetRuneType()==3 then
		final_damage = final_damage + self:GetStackCount()
	end
	return final_damage
end


function modifier_chaotic_breath_focus:ADDeclareFunctions()
    local funcs = 
    {
		advanced_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST = { self:GetParent(),nil },
		MODIFIER_EVENT_ON_TAKEDAMAGE = { self:GetParent(),nil },
    }

	return funcs
end


function modifier_chaotic_breath_focus:OnAbilityFullyCast(keys)
	if keys.unit ~= self:GetParent() then 
		return 
	end
	local mana_cast = keys.ability:GetManaCost(keys.ability:GetLevel())
	if mana_cast < 1 then
		return
	end
	if keys.ability:GetCooldown(keys.ability:GetLevel())<0.5 then
		return
	end
	if self:GetAbility():GetRuneType()==2 then
		return
	end
	self:GetAbility():StartCooldown(self.hide_cooldown)
end

function modifier_chaotic_breath_focus:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.attacker ~= self:GetParent() then
		return
	end
	if keys.unit:GetTeamNumber() == self:GetParent():GetTeamNumber() then
		return
	end
	if self:GetAbility():GetRuneType()==3 then
		local time = self:GetAbility():GetSpecialValueFor("rune_3_break_time")
		keys.unit:GameTimer(time,function ()
			if self:GetAbility() then
				self:GetAbility():StartCooldown(self.hide_cooldown)
				self:SetStackCount(0)
			end
			
		end)
	end
end
