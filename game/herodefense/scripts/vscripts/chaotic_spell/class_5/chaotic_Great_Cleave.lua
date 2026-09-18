chaotic_Great_Cleave = class({})
LinkLuaModifier("modifier_chaotic_Great_Cleave_buff", "chaotic_spell/class_5/chaotic_Great_Cleave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_Great_Cleave_passive", "chaotic_spell/class_5/chaotic_Great_Cleave", LUA_MODIFIER_MOTION_NONE)

function chaotic_Great_Cleave:GetIntrinsicModifierName() return "modifier_chaotic_Great_Cleave_passive" end

function chaotic_Great_Cleave:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_chaotic_Great_Cleave_buff", {duration = self:GetSpecialValueFor("duration")})
end
--------------------------
modifier_chaotic_Great_Cleave_passive = advanced_modifier({})

function modifier_chaotic_Great_Cleave_passive:IsDebuff()			return false end
function modifier_chaotic_Great_Cleave_passive:IsHidden() 			return true end
function modifier_chaotic_Great_Cleave_passive:IsPurgable() 		return false end
function modifier_chaotic_Great_Cleave_passive:IsPurgeException() 	return false end
function modifier_chaotic_Great_Cleave_passive:DestroyOnExpire() 	return false end

function modifier_chaotic_Great_Cleave_passive:OnCreated()
	self.bonus_attack_melee = self:GetAbility():GetSpecialValueFor("bonus_attack_melee")
	self.bonus_armor_melee = self:GetAbility():GetSpecialValueFor("bonus_armor_melee")
	self.cleave_pct = self:GetAbility():GetSpecialValueFor("cleave_pct")*0.01

	self.rune_1_speed = self:GetAbility():GetSpecialValueFor("rune_1_speed")
	self.rune_1_attack = self:GetAbility():GetSpecialValueFor("rune_1_attack")
	self.rune_2_duration = self:GetAbility():GetSpecialValueFor("rune_2_duration")
	self.rune_2_duration_max = self:GetAbility():GetSpecialValueFor("rune_2_duration_max")
	self.rune_3_steal = self:GetAbility():GetSpecialValueFor("rune_3_steal")
	self.rune_3_armor = self:GetAbility():GetSpecialValueFor("rune_3_armor")*0.01

	self.type = self:GetAbility():GetRuneType()
	if self.type == 3 then
		self.bonus_armor_melee = self.bonus_armor_melee * (1-self.rune_3_armor)
	end
end

function modifier_chaotic_Great_Cleave_passive:ADDeclareFunctions() 
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	if self.type == 1 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE)	
		table.insert(funcs,advanced_MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE)
	end
	if self.type == 3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_LifeSteal_AttackDamage)	
	end
	return funcs
end

function modifier_chaotic_Great_Cleave_passive:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	if self:GetParent():IsRangedAttacker() then return end
	return self.bonus_attack_melee
end

function modifier_chaotic_Great_Cleave_passive:Advanced_GetModifierPhysicalArmorBonus()
	if self:GetParent():IsRangedAttacker() then return end
	return self.bonus_armor_melee
end

function modifier_chaotic_Great_Cleave_passive:Advanced_GetModifierDamageOutgoing_Percentage()
	if self:GetParent():IsRangedAttacker() then return end
	return self.rune_1_attack
end

function modifier_chaotic_Great_Cleave_passive:Advanced_GetModifierAttackSpeedPercentage()
	if self:GetParent():IsRangedAttacker() then return end
	return -self.rune_1_speed
end

function modifier_chaotic_Great_Cleave_passive:Advanced_GetModifier_LifeSteal_AttackDamage()
	if self:GetParent():IsRangedAttacker() then return end
	return self.rune_3_steal
end


function modifier_chaotic_Great_Cleave_passive:OnAttackLanded(keys)
	if not IsServer() then
		return
	end
	local caster =  self:GetCaster()
	local ability = self:GetAbility()
	if keys.attacker:IsDisableCleave() then
		return
	end
	if keys.attacker:IsRangedAttacker()	then
		return
	end
	if keys.attacker:IsInSpecialAttack() then
		return 
	end

	if keys.attacker ~= caster or keys.target:IsBuilding() or keys.target:IsOther() or not keys.target:IsAlive() then
		return
	end

	local dmg = keys.damage * self.cleave_pct
		local pfx = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
		DoIMBACleaveAttack(caster, keys.target, ability, dmg, 
			50,
			575, 
			550, pfx)
			
end

--------------------------
modifier_chaotic_Great_Cleave_buff = advanced_modifier({})

function modifier_chaotic_Great_Cleave_buff:IsDebuff()			return false end
function modifier_chaotic_Great_Cleave_buff:IsHidden() 			return false end
function modifier_chaotic_Great_Cleave_buff:IsPurgable() 		return false end
function modifier_chaotic_Great_Cleave_buff:IsPurgeException() 	return false end

function modifier_chaotic_Great_Cleave_buff:OnCreated()
	if not self:GetAbility() then return end
	self.bonus_attack_melee = self:GetAbility():GetSpecialValueFor("bonus_attack_melee")
	self.bonus_armor_melee = self:GetAbility():GetSpecialValueFor("bonus_armor_melee")
	self.rune_2_duration = self:GetAbility():GetSpecialValueFor("rune_2_duration")
	self.rune_2_duration_max = self:GetAbility():GetSpecialValueFor("rune_2_duration_max")
	self.active_index = self:GetAbility():GetSpecialValueFor("active_index")*0.01
	if self:GetAbility():GetRuneType() == 2 then
		self.type2 = true
	end
end

function modifier_chaotic_Great_Cleave_buff:ADDeclareFunctions() 
	local funcs =  {
		advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	if self.type2 then
		funcs["MODIFIER_EVENT_ON_CRITICAL_STRIKE_TRIGGER"] = {self:GetParent(),nil}
	end
	return funcs
end

function modifier_chaotic_Great_Cleave_buff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
	if not self:GetAbility() then return end
	if self:GetParent():IsRangedAttacker() then return end
	return self.bonus_attack_melee*self.active_index
end

function modifier_chaotic_Great_Cleave_buff:Advanced_GetModifierPhysicalArmorBonus()
	if self:GetParent():IsRangedAttacker() then return end
	if not self:GetAbility() then return end
	return self.bonus_armor_melee*self.active_index
end

function modifier_chaotic_Great_Cleave_buff:AdvancedOnCriticalStrikeTrigger(keys)
	if IsServer() then
		if keys.attacker==self:GetParent() then
			local time = math.min(self:GetRemainingTime()+self.rune_2_duration , self.rune_2_duration_max)
			self:SetDuration(time, true)
		end
	end
end