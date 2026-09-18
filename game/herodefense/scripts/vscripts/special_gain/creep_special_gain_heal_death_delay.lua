creep_special_gain_heal_death_delay = class({})

LinkLuaModifier("modifier_creep_special_gain_heal_death_delay", "special_gain/creep_special_gain_heal_death_delay", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creep_special_gain_heal_death_delay_active", "special_gain/creep_special_gain_heal_death_delay", LUA_MODIFIER_MOTION_NONE)

function creep_special_gain_heal_death_delay:GetIntrinsicModifierName()
	return "modifier_creep_special_gain_heal_death_delay"
end
-----------------------------------------------------------------------
modifier_creep_special_gain_heal_death_delay = advanced_modifier({})

function modifier_creep_special_gain_heal_death_delay:IsHidden() return false end
function modifier_creep_special_gain_heal_death_delay:IsPurgable() return false end
function modifier_creep_special_gain_heal_death_delay:IsDebuff() return false end

function modifier_creep_special_gain_heal_death_delay:ADDeclareFunctions()
	return {

		MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()},                       --受到伤害事件
	}
end


function modifier_creep_special_gain_heal_death_delay:OnTakeDamage(keys)
	if IsServer() then   
		local unit = keys.unit

		if unit~=self:GetParent() then	return end
		local ability = self:GetAbility()
		-- if keys.damage>=unit:GetHealth() and self:GetAbility():IsCooldownReady() then
		--腐尸毒新LV10
		local modifier_sp = unit:FindModifierByName("modifier_Advanced_Caustic_Finale")
		if modifier_sp and modifier_sp:GetAbility().advanced_level >= 10 then
			return
		end
		if unit:GetHealth()<=0 and ability:IsCooldownReady() then
			
			unit:SetHealth(1)
			unit:AddNewModifier(unit, ability, "modifier_creep_special_gain_heal_death_delay_active", {duration = ability:GetSpecialValueFor("duration")})
			unit:SetHealth(unit:GetMaxHealth())
			unit.reincarnation_soul_survival_coooldown = true
			unit:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
			ability:UseResources(true, true, true, true)
		end
		
    end 
end
------------------------------------------------------------------

modifier_creep_special_gain_heal_death_delay_active = advanced_modifier({})

function modifier_creep_special_gain_heal_death_delay_active:IsDebuff() return false end
function modifier_creep_special_gain_heal_death_delay_active:IsHidden() return false end
function modifier_creep_special_gain_heal_death_delay_active:IsPurgable() return false end
function modifier_creep_special_gain_heal_death_delay_active:GetEffectName() return "particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf" end
function modifier_creep_special_gain_heal_death_delay_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_creep_special_gain_heal_death_delay_active:KillPre()
	self:SafeDestroy()
	return
end
function modifier_creep_special_gain_heal_death_delay_active:OnCreated()
	self.bonus_move = self:GetAbility():GetSpecialValueFor("bonus_move")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.death_hp_down = self:GetAbility():GetSpecialValueFor("death_hp_down")
	self.bonus_hp_max = self:GetAbility():GetSpecialValueFor("bonus_hp_max")
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_creep_special_gain_heal_death_delay_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,       --移动速度百分比
	}
end
function modifier_creep_special_gain_heal_death_delay_active:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}
end

function modifier_creep_special_gain_heal_death_delay_active:OnIntervalThink(keys)
	local hp_cost = self:GetParent():GetMaxHealth()*self.death_hp_down*0.01

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
   	--self:GetParent():ModifyHealth(math.max(self:GetParent():GetHealth() - hp_cost,0),self:GetAbility(), true, DOTA_DAMAGE_FLAG_HPLOSS)
end

function modifier_creep_special_gain_heal_death_delay_active:OnDestroy(keys)
    if IsServer() then  
		if self:GetParent():IsAlive() then
			--TrueKill(self:GetParent(),self:GetParent(),self:GetAbility())

			self:GetParent():Kill(nil,nil)
		end
    end 
end


function modifier_creep_special_gain_heal_death_delay_active:GetModifierAttackSpeedBonus_Constant() return self.bonus_attack_speed end
function modifier_creep_special_gain_heal_death_delay_active:GetModifierMoveSpeedBonus_Percentage()	return self.bonus_move end
function modifier_creep_special_gain_heal_death_delay_active:AdvancedGetModifierExtraHealthPercentage() return self.bonus_hp_max end
