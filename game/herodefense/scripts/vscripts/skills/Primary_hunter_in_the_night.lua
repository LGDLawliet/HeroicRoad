Primary_hunter_in_the_night = class({})

LinkLuaModifier("modifier_Primary_hunter_in_the_night", "skills/Primary_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_hunter_in_the_night_debuff", "skills/Primary_hunter_in_the_night", LUA_MODIFIER_MOTION_NONE)

function Primary_hunter_in_the_night:GetIntrinsicModifierName() return "modifier_Primary_hunter_in_the_night" end


modifier_Primary_hunter_in_the_night= advanced_modifier({})

function modifier_Primary_hunter_in_the_night:IsDebuff()			return false end
function modifier_Primary_hunter_in_the_night:IsHidden() 			return true end
function modifier_Primary_hunter_in_the_night:IsPurgable() 		return false end
function modifier_Primary_hunter_in_the_night:IsPurgeException() 	return false end

function modifier_Primary_hunter_in_the_night:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	self:StartIntervalThink(1)
end


function modifier_Primary_hunter_in_the_night:OnIntervalThink()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_move_speed = self:GetAbility():GetSpecialValueFor("bonus_move_speed")
	if not IsServer() then
		return
	end
	local caster = self:GetParent()

	-- 黑夜白天判断
	if not self:GetParent():IsInNightTime() then
		self:SetStackCount(0)
	else
		self:SetStackCount(1)
	end
	if self:GetParent():HasModifier("modifier_heroTalent_npc_dota_hero_night_stalker_2") then
		self:SetStackCount(1)
	end
end

function modifier_Primary_hunter_in_the_night:DeclareFunctions() 
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	} 
end

function modifier_Primary_hunter_in_the_night:GetModifierMoveSpeedBonus_Percentage() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_move_speed") or 0 end
function modifier_Primary_hunter_in_the_night:GetModifierAttackSpeedBonus_Constant() return self:GetStackCount()==1 and self:GetAbility():GetSpecialValueFor("bonus_attack_speed") or 0 end

