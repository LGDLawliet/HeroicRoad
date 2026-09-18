--特效优化 √




LinkLuaModifier("modifier_Advanced_false_promise_timer", "skills/Advanced_false_promise", LUA_MODIFIER_MOTION_NONE)

Advanced_false_promise	= Advanced_false_promise or class({})


function Advanced_false_promise:CheckKV(key)
	local table = {


		duration = 0.3,


	}
	local value = table[key] or -1
	return value

end

function Advanced_false_promise:Precache( context )
	PrecacheResource( "particle", "particles/econ/events/ti10/hero_levelup_ti10_godray.vpcf", context )

	

end

function Advanced_false_promise:UnlockFirstCore(key)
	return true
end
function Advanced_false_promise:UnlockSecondCore(key)
	return true
end
function Advanced_false_promise:UnlockThirdCore(key)
	return true
end

function Advanced_false_promise:IsRefreshable() return false end

function Advanced_false_promise:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	target:EmitSound("Hero_Oracle.FalsePromise.Target")
	self.false_promise_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(self.false_promise_cast_particle, 2, caster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(self.false_promise_cast_particle)
	
	self.false_promise_target_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast_enemy.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:ReleaseParticleIndex(self.false_promise_target_particle)
	
	caster:EmitSound("Hero_Oracle.FalsePromise.Cast")
	
	target:Purge(false, true, false, true, true)
	local duration = self:GetSpecialValueFor("duration")

	target:AddNewModifier(caster, self, "modifier_Advanced_false_promise_timer", {duration = duration})

	if self.unlock1 then
		local modifier = target:FindModifierByName("modifier_item_hd_risk_dice_active_2")
		if modifier then
			local max = 120
			target:EmitSound("compendium_levelup")
			local stack = modifier:GetStackCount()
			local modifier2 = target:FindModifierByName("modifier_item_hd_risk_dice_active")
			if modifier2 then
				stack = math.min(stack,max)
				if modifier2:GetStackCount()>stack then
					--do nothing
				else
					modifier2:SetStackCount(stack)
				end
				modifier:SafeDestroy()
			else
				local newModifier = target:AddNewModifier(target, self, "modifier_item_hd_risk_dice_active", {})
				modifier:SafeDestroy()
				newModifier:SetStackCount(math.min(max,stack))
			end
		
			local particle = ParticleManager:CreateParticle("particles/econ/events/ti10/hero_levelup_ti10_godray.vpcf", PATTACH_POINT_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
		end
	end

end



modifier_Advanced_false_promise_timer	= modifier_Advanced_false_promise_timer or advanced_modifier({})

function modifier_Advanced_false_promise_timer:GetPriority()	return MODIFIER_PRIORITY_ULTRA end
function modifier_Advanced_false_promise_timer:IsPurgable()	return false end
function modifier_Advanced_false_promise_timer:GetEffectName()	return "particles/units/heroes/hero_oracle/oracle_false_promise.vpcf" end

function modifier_Advanced_false_promise_timer:OnCreated()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_damage = 0
	--LV15解锁命运之剑
	if self.advanced_level>=15 then
		self.bonus_damage = 50
	end

	if not IsServer() then return end
	
	self.overhead_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_indicator.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	self:AddParticle(self.overhead_particle, false, false, -1, true, true)
	-- self.advanced_level = self:GetAbility().advanced_level
	-- I think it's okay to just have a tracked number for heals, but damage needs to also track the attacker so you can properly attribute a kill
	self.heal_counter		= 0
	
	self.damage_instances	= {}
	self.instance_counter	= 1
	self.damage_counter		= 0
	self.damage_counter_total		= 0
	self.heal_gain = 2.5
	self.damage_reduce = 0.15
	--LV5解锁命运协调+
	if self.advanced_level>=5 then
		self.heal_gain = 3.5
	end
	--LV10解锁命运之盾+
	if self.advanced_level>=10 then
		self.damage_reduce  = 0.08
	end

	self.take_damage_index = 1
	--LV20解锁命运之盔
	if self.advanced_level>=20 then
		self.take_damage_index = 0.5
	end

	self:StartIntervalThink(1)



end

function modifier_Advanced_false_promise_timer:OnRefresh()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.bonus_damage = 0
	--LV15解锁命运之剑
	if self.advanced_level>=15 then
		self.bonus_damage = 50
	end
	if not IsServer() then return end
	
	self.heal_counter = self.heal_counter or 0

	self.damage_instances	= self.damage_instances or {}
	self.instance_counter	= self.instance_counter or 1
	self.damage_counter		= self.damage_counter or 0
	self.damage_counter_total		= 	self.damage_counter_total or 0 
	

	--LV5解锁命运协调+
	if self.advanced_level>=5 then
		self.heal_gain = 3.5
	end
	--LV10解锁命运之盾+
	if self.advanced_level>=10 then
		self.damage_reduce  = 0.22
	end

	
	self.take_damage_index = 1
	--LV20解锁命运之盔
	if self.advanced_level>=20 then
		self.take_damage_index = 0.5
	end
end

function modifier_Advanced_false_promise_timer:OnIntervalThink()
	if not IsServer() then return end
	local different = self.damage_counter - self.heal_counter
	if different>0 then
		different = different*self.damage_reduce
		self.damage_counter = self.damage_counter -different
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end



end



function modifier_Advanced_false_promise_timer:OnDestroy()
	if not IsServer() then return end

	local ability = self:GetAbility()
	if not ability then
		return
	end
	local causeDamage = true
	
	if ability.unlock2 and self.damage_counter_total>0 then
		local caster = self:GetCaster()
		local damage = self.damage_counter_total *2
		local pos = self:GetParent():GetAbsOrigin()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		 DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #units>0 then
			damage = math.min(damage / #units,caster:GetMaxMana()*10)
			-- print("damage="..damage)
			local damage_table = {
				-- victim			= self:GetParent(),
				damage			= damage,
				damage_type		= DAMAGE_TYPE_MAGICAL,
				damage_flags	= DOTA_DAMAGE_FLAG_NONE,
				attacker		=caster,
				ability			= ability
			}
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/false_promise/damage_caculate/arcana/earthshaker_arcana_totem_cast_ti6_combined_v2.vpcf", PATTACH_WORLDORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, pos)
			ParticleManager:ReleaseParticleIndex( effect_cast )
			for _, unit in ipairs(units) do
				damage_table.victim = unit
				local layterDamage = ApplyDamage(damage_table)
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,unit, layterDamage, nil)
				if not unit:IsAlive() then
					causeDamage = false
				end
			end
		end
	end



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
	

		if causeDamage then
			self.damage_table = {
				victim			= self:GetParent(),
				damage			= self.damage_counter - self.heal_counter,
				damage_type		= DAMAGE_TYPE_PURE,
				damage_flags	= DOTA_DAMAGE_FLAG_NONE,
				attacker		= self:GetParent(),
				ability			= ability
			}
			ApplyDamage(self.damage_table)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.damage_counter, nil)
		end
	
	
	end
	



end

function modifier_Advanced_false_promise_timer:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_HEAL_RECEIVED,
		MODIFIER_PROPERTY_DISABLE_HEALING,
		-- MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		
	}
end
-- function modifier_Advanced_false_promise_timer:GetModifierTotalDamageOutgoing_Percentage()
-- 	return self.bonus_damage
-- end
function modifier_Advanced_false_promise_timer:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return -100
	end
	if keys.attacker and self:GetRemainingTime() >= 0 then
		if  keys.damage<=0 then
			return
		end
		self.damage_counter_total = self.damage_counter_total + keys.damage
		self.attacked_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_attacked.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(self.attacked_particle)
	

		self.damage_counter = self.damage_counter + keys.damage*self.take_damage_index

		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
	

	return -100
end

function modifier_Advanced_false_promise_timer:OnHealReceived(keys)
	if keys.unit == self:GetParent() and self:GetRemainingTime() >= 0 then
		self.heal_counter = self.heal_counter + (keys.gain *self.heal_gain)
		
		ParticleManager:SetParticleControl(self.overhead_particle, 1, Vector(self.damage_counter - self.heal_counter, 0, 0))
		ParticleManager:SetParticleControl(self.overhead_particle, 2, Vector(self.heal_counter - self.damage_counter, 0, 0))
		
		self:SetStackCount(math.abs(self.damage_counter - self.heal_counter))
	end
end

function modifier_Advanced_false_promise_timer:GetDisableHealing(keys)
	return 1
end




-- advanced_modifier
function modifier_Advanced_false_promise_timer:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		
    }
	if self:GetAbility():GetUnlock(3)==3 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_RandomEffectGain)
	end
	return funcs

end
function modifier_Advanced_false_promise_timer:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.bonus_damage
end



function modifier_Advanced_false_promise_timer:Advanced_GetModifier_RandomEffectGain(keys)
	return 40
end



