Primary_bash_of_the_deep = Primary_bash_of_the_deep or  class({})
LinkLuaModifier( "modifier_Primary_bash_of_the_deep", "skills/Primary_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_bash_of_the_deep_debuff", "skills/Primary_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_bash_of_the_deep_check", "skills/Primary_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )

function Primary_bash_of_the_deep:GetIntrinsicModifierName()
	return "modifier_Primary_bash_of_the_deep"
end
------------------------------------------------------
modifier_Primary_bash_of_the_deep = advanced_modifier({})

function modifier_Primary_bash_of_the_deep:IsHidden()	return self:GetStackCount()<1 end
function modifier_Primary_bash_of_the_deep:IsPurgable()	return false end
function modifier_Primary_bash_of_the_deep:IsPurgeException() return false end
function modifier_Primary_bash_of_the_deep:RemoveOnDeath() return false end


function modifier_Primary_bash_of_the_deep:OnCreated( kv )
	self.count = self:GetAbility():GetSpecialValueFor( "count" )
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	self.record = {}
end

function modifier_Primary_bash_of_the_deep:OnRefresh( kv )
	self.count = self:GetAbility():GetSpecialValueFor( "count" )
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
end

function modifier_Primary_bash_of_the_deep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	}
	return funcs
end

function modifier_Primary_bash_of_the_deep:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
	return funcs
end

function modifier_Primary_bash_of_the_deep:GetModifierPreAttack_BonusDamagePostCrit( keys )
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

function modifier_Primary_bash_of_the_deep:OnAttackLanded(keys)
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

			local check = keys.target:FindModifierByName("modifier_Primary_bash_of_the_deep_check")

			if not check then
				-- 未被施加印记
				local duration = self:GetAbility():GetSpecialValueFor("duration")
				self:PlayEffects(keys.target, duration)
				keys.target:AddNewModifier(self:GetParent(), ability, "modifier_Primary_bash_of_the_deep_check", {stack = 1})

			else
				-- 被施加印记，但印记不大最大数目
				if check and check:GetStackCount() < self.max then
					local duration = self:GetAbility():GetSpecialValueFor("duration")
					self:PlayEffects(keys.target, duration)
					keys.target:AddNewModifier(self:GetParent(), ability, "modifier_Primary_bash_of_the_deep_check", {stack = 1})
				end
				-- 被施加印记，且处于最大值了
				if check and check:GetStackCount() >= self.max then
					return
				end
			end
		end
	end
end

function modifier_Primary_bash_of_the_deep:PlayEffects(target,duration)
	target:HDAddNewBadModifier(self:GetParent(), self:GetAbility(), "modifier_Primary_bash_of_the_deep_debuff", {duration = duration}, nil, 0.6, 0.8)--攻击者，来源，modifier，table，nil，负面影响，抗性影响
	EmitSoundOn( "Hero_Slardar.Bash", target )
end

------------------------------------------------------------
modifier_Primary_bash_of_the_deep_debuff = advanced_modifier({})
function modifier_Primary_bash_of_the_deep_debuff:IsHidden()	return false end
function modifier_Primary_bash_of_the_deep_debuff:IsDebuff()	return true end
function modifier_Primary_bash_of_the_deep_debuff:IsPurgable()	return false end
function modifier_Primary_bash_of_the_deep_debuff:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true,
	}
end

------------------------------------------------------------
modifier_Primary_bash_of_the_deep_check = advanced_modifier({})
function modifier_Primary_bash_of_the_deep_check:IsHidden()	return false end
function modifier_Primary_bash_of_the_deep_check:IsDebuff()	return true end
function modifier_Primary_bash_of_the_deep_check:IsPurgable()	return false end

function modifier_Primary_bash_of_the_deep_check:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	if IsServer() then
		self.stack = self.stack or 0
		self.stack = self.stack + keys.stack
		self:SetStackCount(self.stack)
	end
end

function modifier_Primary_bash_of_the_deep_check:OnRefresh(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	if IsServer() then
		self.stack = self.stack or 0
		self.stack = self.stack + keys.stack
		self:SetStackCount(self.stack)
		if self:GetStackCount() >= self.max and self:GetRemainingTime() < 0 then
			self:SetDuration(self.max_time, true)
		end
	end
end