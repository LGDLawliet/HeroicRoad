




LinkLuaModifier("modifier_chaotic_false_promise_timer", "chaotic_spell/class_8/chaotic_false_promise", LUA_MODIFIER_MOTION_NONE)

chaotic_false_promise	= chaotic_false_promise or class({})

function chaotic_false_promise:IsRefreshable() return false end

function chaotic_false_promise:OnSpellStart()
	local target = self:GetCursorTarget()

	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")

	target:AddNewModifier(self:GetCaster(), self, "modifier_chaotic_false_promise_timer", {duration = self:GetSpecialValueFor("duration")})
	self:StartCooldown(self:GetSpecialValueFor("cd"))
end

--------------------

modifier_chaotic_false_promise_timer = advanced_modifier({})

function modifier_chaotic_false_promise_timer:GetPriority()	return MODIFIER_PRIORITY_ULTRA + 10 end
function modifier_chaotic_false_promise_timer:IsPurgable()	return false end
function modifier_chaotic_false_promise_timer:GetEffectName()	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf" end

function modifier_chaotic_false_promise_timer:OnCreated()
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)
	
	self.heal_counter = 0
	self.damage_counter	= 0

	self.damage_instances = {}
	self.instance_counter = 1
	self.nowhp = self:GetParent():GetHealth()

	self.take_index = self:GetAbility():GetSpecialValueFor("take_index")*0.01
	self.line = self:GetAbility():GetSpecialValueFor("line")*0.01
	self.heal_index = self:GetAbility():GetSpecialValueFor("heal_index")*0.01
	self.hp_min = self:GetAbility():GetSpecialValueFor("hp_min")*0.01
end

function modifier_chaotic_false_promise_timer:OnRefresh()
	if not IsServer() then return end
	if not self:GetAbility() then self:Destroy() return end
	
	self.heal_counter = self.heal_counter or 0
	self.damage_counter	= self.damage_counter or 0
	
	self.damage_instances = self.damage_instances or {}
	self.instance_counter = self.instance_counter or 1
	self.nowhp = self:GetParent():GetHealth()

	self.take_index = self:GetAbility():GetSpecialValueFor("take_index")*0.01
	self.line = self:GetAbility():GetSpecialValueFor("line")*0.01
	self.heal_index = self:GetAbility():GetSpecialValueFor("heal_index")*0.01
	self.hp_min = self:GetAbility():GetSpecialValueFor("hp_min")*0.01
end

function modifier_chaotic_false_promise_timer:OnDestroy()
	if not IsServer() then return end
	
	if self.damage_counter < self.heal_counter then
		-- 治疗
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")
		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
		
		local end_heal = (self.heal_counter - self.damage_counter)*self.end_heal_index
		self:GetParent():Heal(end_heal, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), end_heal, nil)

	else
		-- 伤害
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")
		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
	
		local end_take = (self.damage_counter - self.heal_counter)*self.end_take_index
		self.damage_table = {
			victim			= self:GetParent(),
			damage			= end_take,
			damage_type		= DAMAGE_TYPE_PURE,
			damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
			attacker		= self:GetParent(),
			ability			= nil,
			hd_flags        = HD_DAMAGE_FLAG_NO_SPELL_CRIT + HD_DAMAGE_FLAG_NO_DAMAGE_AMPLIFY
		}

		self.line = self.line or 2
		self.hp_min = self.hp_min or 0.2
		
		if end_take <= self:GetParent():GetMaxHealth()*self.line then
			self.damage_table.damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NON_LETHAL
			ApplyDamage(self.damage_table)
			if self:GetParent():GetHealthPercent() <= self.hp_min then
				self:GetParent():SetHealth(self:GetParent():GetMaxHealth()*self.hp_min)
			end
		else
			self.damage_table.damage_flags	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS
			ApplyDamage(self.damage_table)
		end	
	end
	
	if self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:SafeDestroy()
	end
end

function modifier_chaotic_false_promise_timer:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end

function modifier_chaotic_false_promise_timer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end

function modifier_chaotic_false_promise_timer:GetDisableHealing(keys)
	return 1
end
function modifier_chaotic_false_promise_timer:GetMinHealth(keys)
	return self.nowhp
end

function modifier_chaotic_false_promise_timer:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return -100
	end

	if keys.attacker and self:GetRemainingTime() >= 0 then
		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)
	
		self.damage_counter = self.damage_counter + (keys.damage*self.take_index)
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
	
	return -100
end

function modifier_chaotic_false_promise_timer:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain*self.heal_index)
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

