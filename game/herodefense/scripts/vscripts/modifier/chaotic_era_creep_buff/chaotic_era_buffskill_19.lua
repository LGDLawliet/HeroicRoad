chaotic_era_buffskill_19 = class({})

LinkLuaModifier("modifier_chaotic_era_buffskill_19", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_19", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaotic_era_buffskill_19_active", "modifier/chaotic_era_creep_buff/chaotic_era_buffskill_19", LUA_MODIFIER_MOTION_NONE)

function chaotic_era_buffskill_19:GetIntrinsicModifierName()
	return "modifier_chaotic_era_buffskill_19"
end
-----------------------------------------------------------------------
modifier_chaotic_era_buffskill_19 = advanced_modifier({})

function modifier_chaotic_era_buffskill_19:IsHidden() return false end
function modifier_chaotic_era_buffskill_19:IsPurgable() return false end
function modifier_chaotic_era_buffskill_19:IsDebuff() return false end

function modifier_chaotic_era_buffskill_19:ADDeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},                       --受到伤害事件
	}
end


function modifier_chaotic_era_buffskill_19:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit

		if unit~=self:GetParent() then	return end
		local ability = self:GetAbility()

		if unit:GetHealth()<=0 and ability:IsCooldownReady() then
			unit:SetHealth(1)
			unit:AddNewModifier(unit, ability, "modifier_chaotic_era_buffskill_19_active", {})
			unit:SetHealth(unit:GetMaxHealth())
			unit.reincarnation_soul_survival_coooldown = true
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
			ability:UseResources(true, true, true, true)
		end
		
    end 
end
------------------------------------------------------------------

modifier_chaotic_era_buffskill_19_active = advanced_modifier({})

function modifier_chaotic_era_buffskill_19_active:IsDebuff() return false end
function modifier_chaotic_era_buffskill_19_active:IsHidden() return false end
function modifier_chaotic_era_buffskill_19_active:IsPurgable() return false end
function modifier_chaotic_era_buffskill_19_active:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_chaotic_era_buffskill_19_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_chaotic_era_buffskill_19_active:KillPre()
	self:SafeDestroy()
	return
end
function modifier_chaotic_era_buffskill_19_active:OnCreated()
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("attack_speed")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_chaotic_era_buffskill_19_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
	}
end
function modifier_chaotic_era_buffskill_19_active:ADDeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_chaotic_era_buffskill_19_active:OnIntervalThink(keys)
	local hp_cost = self:GetParent():GetMaxHealth()*0.1

	self.damageTable = {
		victim = self:GetParent(),
		damage = hp_cost,
		damage_type = DAMAGE_TYPE_PURE,
		attacker = self:GetParent(),
		ability = self:GetAbility(),
		damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL,
		hd_flags = HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY,
	}
	ApplyDamage(self.damageTable)
end

function modifier_chaotic_era_buffskill_19_active:GetModifierAttackSpeedBonus_Constant() 
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	return self.bonus_attack_speed 
end

function modifier_chaotic_era_buffskill_19_active:Advanced_GetModifierIncomingDamage_Percentage() 
	if self:GetParent():PassivesDisabled() then
		return 0
	end
	return -60 
end
