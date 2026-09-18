LinkLuaModifier( "modifier_chaotic_summon_master", "chaotic_spell/class_8/chaotic_summon_master.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_summon_master_active", "chaotic_spell/class_8/chaotic_summon_master.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_summon_master_active_rune_1", "chaotic_spell/class_8/chaotic_summon_master.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_summon_master = class({})

function chaotic_summon_master:GetIntrinsicModifierName()
	return "modifier_chaotic_summon_master"
end
---------------------------------------------------------------------
modifier_chaotic_summon_master = advanced_modifier({})
function modifier_chaotic_summon_master:IsHidden() return true end
function modifier_chaotic_summon_master:IsPurgable() return false end
function modifier_chaotic_summon_master:OnCreated(params)
	self.bonus_summon = self:GetAbility():GetSpecialValueFor("bonus_summon")
	self.summon_time_down = self:GetAbility():GetSpecialValueFor("summon_time_down")
	self.bonus_summon_angry = self:GetAbility():GetSpecialValueFor("bonus_summon_angry")

	self.ability = self:GetAbility()
	self.type = self:GetAbility():GetRuneType()


end

function modifier_chaotic_summon_master:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_Summon_Intensity,
		advanced_MODIFIER_PROPERTY_SummonTime_Intensity,
	}
	return funcs
end


function modifier_chaotic_summon_master:OnSummonUnit(keys)
	if IsServer() then
		local unit = keys.target
		if self:GetParent():PassivesDisabled() then
			return
		end
		
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		self.bonus_summon_angry = self:GetAbility():GetSpecialValueFor("bonus_summon_angry")

		if self.type == 1 then
			local random = math.random
			self.chance = self.ability:GetSpecialValueFor("rune_1_chance")
			if self.chance >= random(1,100) then
				self.bonus_summon_angry = self.bonus_summon_angry* (1+self.ability:GetSpecialValueFor("rune_1_index")*0.01)
				unit:AddNewModifier(caster, ability, "modifier_chaotic_summon_master_active_rune_1", {stack = self.ability:GetSpecialValueFor("rune_1_armor")})
			end
		end
		unit:AddNewModifier(caster, ability, "modifier_chaotic_summon_master_active", {stack = self.bonus_summon_angry})
    end
end

function modifier_chaotic_summon_master:Advanced_GetModifier_Summon_Intensity(keys)
	return self.bonus_summon
end
function modifier_chaotic_summon_master:Advanced_GetModifier_SummonTime_Intensity()
	return -self.summon_time_down
end

---------------------------------------------------------------------
modifier_chaotic_summon_master_active = advanced_modifier({})
function modifier_chaotic_summon_master_active:IsHidden() return false end
function modifier_chaotic_summon_master_active:IsPurgable() return false end
function modifier_chaotic_summon_master_active:IsDebuff() return false end
function modifier_chaotic_summon_master_active:OnCreated(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.stack = keys.stack or 0
    self:SetStackCount(self.stack)
end
function modifier_chaotic_summon_master_active:OnRefresh(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.stack = keys.stack or 0
    self:SetStackCount(self.stack)
end
function modifier_chaotic_summon_master_active:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
	}
	return funcs
end
function modifier_chaotic_summon_master_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_SCALE,
	}
	return funcs
end
function modifier_chaotic_summon_master_active:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not self:GetAbility() then return end
    return self:GetStackCount()
end
function modifier_chaotic_summon_master_active:GetModelScale()
    return 40
end
---------------------------------------------------------------------
modifier_chaotic_summon_master_active_rune_1 = advanced_modifier({})
function modifier_chaotic_summon_master_active_rune_1:IsHidden() return true end
function modifier_chaotic_summon_master_active_rune_1:IsPurgable() return false end
function modifier_chaotic_summon_master_active_rune_1:IsDebuff() return true end
function modifier_chaotic_summon_master_active_rune_1:OnCreated(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.stack = keys.stack or 0
    self:SetStackCount(self.stack)
end
function modifier_chaotic_summon_master_active_rune_1:OnRefresh(keys)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    self.stack = keys.stack or 0
    self:SetStackCount(self.stack)
end
function modifier_chaotic_summon_master_active_rune_1:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_chaotic_summon_master_active_rune_1:Advanced_GetModifierPhysicalArmorBonusPercentage(keys)
    if not self:GetAbility() then return end
    return -self:GetStackCount()
end
