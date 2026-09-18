--特效优化 √
Advanced_bash_of_the_deep = Advanced_bash_of_the_deep or  class({})
LinkLuaModifier( "modifier_Advanced_bash_of_the_deep", "skills/Advanced_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_bash_of_the_deep_debuff", "skills/Advanced_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_bash_of_the_deep_check", "skills/Advanced_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )

function Advanced_bash_of_the_deep:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
end

function Advanced_bash_of_the_deep:CheckKV(key)
	local table = {
		superhit = 20,
		bonus_superhit = 0.02,
		burstdamage = 0.1
	}
	local value = table[key] or -1
	return value
end

function Advanced_bash_of_the_deep:UnlockFirstCore(key)
	return false
end
function Advanced_bash_of_the_deep:UnlockSecondCore(key)
	return false
end
function Advanced_bash_of_the_deep:UnlockThirdCore(key)
	self:GetCaster():AddItemByName("item_hd_the_trident_of_the_sunken_treasure_house")
	return true
end

function Advanced_bash_of_the_deep:GetIntrinsicModifierName()
	return "modifier_Advanced_bash_of_the_deep"
end

------------------------------------------
modifier_Advanced_bash_of_the_deep = advanced_modifier({})

function modifier_Advanced_bash_of_the_deep:IsHidden()	return self:GetStackCount()<1 end
function modifier_Advanced_bash_of_the_deep:IsPurgable()	return false end
function modifier_Advanced_bash_of_the_deep:IsPurgeException() return false end
function modifier_Advanced_bash_of_the_deep:RemoveOnDeath() return false end


function modifier_Advanced_bash_of_the_deep:OnCreated( kv )
	self.count = self:GetAbility():GetSpecialValueFor( "count" )
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	self.burstdamage = self:GetAbility():GetSpecialValueFor( "burstdamage" )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.level = self:GetAbility():GetSpecialValueFor( "advanced_level" )
	self.record = {}
end

function modifier_Advanced_bash_of_the_deep:OnRefresh( kv )
	self.count = self:GetAbility():GetSpecialValueFor( "count" )
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	self.burstdamage = self:GetAbility():GetSpecialValueFor( "burstdamage" )
	self.str = self:GetAbility():GetSpecialValueFor( "str" )
	self.level = self:GetAbility():GetSpecialValueFor( "advanced_level" )
end

function modifier_Advanced_bash_of_the_deep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	}
	return funcs
end

function modifier_Advanced_bash_of_the_deep:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
	return funcs
end

function modifier_Advanced_bash_of_the_deep:GetModifierPreAttack_BonusDamagePostCrit( keys )
	if IsServer() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		if self:GetParent():PassivesDisabled() then
			return 
		end
		if self:GetParent():IsInSpecialAttack() then
			return 
		end

		self:SetStackCount(math.min(self:GetStackCount()+1, self.count))
		if self:GetStackCount()>=self.count then
			self.record[keys.record] = true
			self:SetStackCount(0)
			local superhit = self:GetAbility():GetSpecialValueFor("superhit")+ self:GetAbility():GetSpecialValueFor("bonus_superhit")*self:GetCaster():GetAverageTrueAttackDamage(nil)
			return superhit
		end
	end
end

function modifier_Advanced_bash_of_the_deep:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if self.record[keys.record] then
			local ability = self:GetAbility()
			if not ability or ability:IsNull() then
				return
			end
			if self:GetParent():PassivesDisabled() then
				return 
			end
			if self:GetParent():IsInSpecialAttack() then
				return 
			end
			if not keys.target or keys.target:IsNull() then
				return
			end

			local check = keys.target:FindModifierByName("modifier_Advanced_bash_of_the_deep_check")

			if not check then
				-- 未被施加印记
				local duration = self:GetAbility():GetSpecialValueFor("duration")
				self:PlayEffects(keys.target, duration)
				keys.target:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_bash_of_the_deep_check", {stack = 1})

			else
				-- 被施加印记，但印记不大最大数目
				if check and check:GetStackCount() < self.max then
					local duration = self:GetAbility():GetSpecialValueFor("duration")
					self:PlayEffects(keys.target, duration)
					keys.target:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_bash_of_the_deep_check", {stack = 1})

					if check:GetStackCount() == self.max then
						self:PlayBurstEffects(keys.target)
					end
				end
				-- 被施加印记，且处于最大值了
				if check and check:GetStackCount() >= self.max then
					return
				end
			end
		end
	end
end

function modifier_Advanced_bash_of_the_deep:PlayEffects(target,duration)
	local nega = 0.6
	local status = 0.8
	if self.level >= 10 then
		status = 0.4
		if self.level >= 20 then
			status = 0.3
		end
	end
	target:HDAddNewBadModifier(self:GetParent(), self:GetAbility(), "modifier_Advanced_bash_of_the_deep_debuff", {duration = duration}, nil, nega, status)--攻击者，来源，modifier，table，nil，负面影响，抗性影响
	EmitSoundOn( "Hero_Slardar.Bash", target )
end

function modifier_Advanced_bash_of_the_deep:PlayBurstEffects(target)
	EmitSoundOn("Hero_Slardar.Slithereen_Crush",target)	

	local particle_cast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_cast_fx, 1, Vector(200,0,0))
	ParticleManager:ReleaseParticleIndex(particle_cast_fx)


	local particle_cast_fx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle_cast_fx2, 0, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_cast_fx2)

	local damageTable = {
		attacker = self:GetCaster(),
		victim = target,
		damage = self:GetCaster():GetAverageTrueAttackDamage(nil)* self.burstdamage + self:GetCaster():GetStrength()* self.str,
		damage_type =  self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, 
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		ability = self:GetAbility(),
	}
	if self.level >= 5 and target:GetHealthPercent() >= 70 then
		damageTable.damage = damageTable.damage*1.7
	end
	ApplyDamage(damageTable)
end

------------------------------------------------------------
modifier_Advanced_bash_of_the_deep_debuff = advanced_modifier({})
function modifier_Advanced_bash_of_the_deep_debuff:IsHidden()	return false end
function modifier_Advanced_bash_of_the_deep_debuff:IsDebuff()	return true end
function modifier_Advanced_bash_of_the_deep_debuff:IsPurgable()	return false end

function modifier_Advanced_bash_of_the_deep_debuff:OnCreated()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 15 then
		self.armor = 15
	end
end

function modifier_Advanced_bash_of_the_deep_debuff:OnRefresh()
	if not self:GetAbility() then self:Destroy() return end
	self.armor = self:GetAbility():GetSpecialValueFor("armor")
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 15 then
		self.armor = 15
	end
end

function modifier_Advanced_bash_of_the_deep_debuff:ADDeclareFunctions()
	local funcs = {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 15 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_CRITICALSTRIKE_DAMAGE_TARGET)
	end
	return funcs
end

function modifier_Advanced_bash_of_the_deep_debuff:Advanced_GetModifierPhysicalArmorBonus()
	if not self:GetAbility() then self:Destroy() return end
	return -self.armor
end

function modifier_Advanced_bash_of_the_deep_debuff:Advanced_GetModifierCriticalStrikeDamageTarget(keys)
	return 15
end

function modifier_Advanced_bash_of_the_deep_debuff:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true,
	}
end

------------------------------------------------------------
modifier_Advanced_bash_of_the_deep_check = advanced_modifier({})
function modifier_Advanced_bash_of_the_deep_check:IsHidden()	return false end
function modifier_Advanced_bash_of_the_deep_check:IsDebuff()	return true end
function modifier_Advanced_bash_of_the_deep_check:IsPurgable()	return false end

function modifier_Advanced_bash_of_the_deep_check:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
		self.max_time = self.max_time - 2
	end
	if IsServer() then
		self.stack = self.stack or 0
		self.stack = self.stack + keys.stack
		self:SetStackCount(self.stack)
	end
end

function modifier_Advanced_bash_of_the_deep_check:OnRefresh(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	if self:GetAbility():GetSpecialValueFor("advanced_level") >= 20 then
		self.max_time = self.max_time - 2
	end
	if IsServer() then
		self.stack = self.stack or 0
		self.stack = self.stack + keys.stack
		self:SetStackCount(self.stack)
		if self:GetStackCount() >= self.max and self:GetRemainingTime() < 0 then
			self:SetDuration(self.max_time, true)
		end
	end
end