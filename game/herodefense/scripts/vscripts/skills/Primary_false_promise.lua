




LinkLuaModifier("modifier_Primary_false_promise_timer", "skills/Primary_false_promise", LUA_MODIFIER_MOTION_NONE)

Primary_false_promise	= Primary_false_promise or class({})

function Primary_false_promise:IsRefreshable() return false end

function Primary_false_promise:OnSpellStart()
	local target = self:GetCursorTarget()
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, self:GetCaster():GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	
	self:GetCaster():EmitSound("Hero_Oracle.FalsePromise.Cast")
	
	target:Purge(false, true, false, true, true)
	
	target:AddNewModifier(self:GetCaster(), self, "modifier_Primary_false_promise_timer", {duration = self:GetSpecialValueFor("duration")})

end



modifier_Primary_false_promise_timer	= modifier_Primary_false_promise_timer or advanced_modifier({})

function modifier_Primary_false_promise_timer:GetPriority()	return MODIFIER_PRIORITY_ULTRA end
function modifier_Primary_false_promise_timer:IsPurgable()	return false end
function modifier_Primary_false_promise_timer:GetEffectName()	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf" end

function modifier_Primary_false_promise_timer:OnCreated()
	if not IsServer() then return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)
	
	-- I think it's okay to just have a tracked number for heals, but damage needs to also track the attacker so you can properly attribute a kill
	self.heal_counter		= 0
	
	self.damage_instances	= {}
	self.instance_counter	= 1
	self.damage_counter		= 0
	

end

function modifier_Primary_false_promise_timer:OnRefresh()
	if not IsServer() then return end
	
	self.heal_counter = self.heal_counter or 0

	self.damage_instances	= self.damage_instances or {}
	self.instance_counter	= self.instance_counter or 1
	self.damage_counter		= self.damage_counter or 0


end



function modifier_Primary_false_promise_timer:OnDestroy()
	if not IsServer() then return end
	

	
	if self.damage_counter < self.heal_counter then
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Healed")


		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
		
		self:GetParent():Heal(self.heal_counter - self.damage_counter, self:GetCaster())
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self.heal_counter - self.damage_counter, nil)

	else
		self:GetParent():EmitSound("Hero_Oracle.FalsePromise.Damaged")

		self.end_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_dmg.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.end_particle)
	
	
		self.damage_table = {
			victim			= self:GetParent(),
			damage			= self.damage_counter - self.heal_counter,
			damage_type		= DAMAGE_TYPE_PURE,
			damage_flags	= DOTA_DAMAGE_FLAG_NONE,
			attacker		= self:GetParent(),
			ability			= self:GetAbility()
		}
		ApplyDamage(self.damage_table)
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)
	end
	
	if self.invis_modifier and not self.invis_modifier:IsNull() then
		self.invis_modifier:SafeDestroy()
	end

end

function modifier_Primary_false_promise_timer:DeclareFunctions()
	return {
		
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		
	}
end

function modifier_Primary_false_promise_timer:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return -100
	end
	if keys.attacker and self:GetRemainingTime() >= 0 then
		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)
	

		self.damage_counter = self.damage_counter + keys.damage

		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
	

	return -100
end

function modifier_Primary_false_promise_timer:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain * 1.5)
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

function modifier_Primary_false_promise_timer:GetDisableHealing(keys)
	return 1
end


function modifier_Primary_false_promise_timer:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end
