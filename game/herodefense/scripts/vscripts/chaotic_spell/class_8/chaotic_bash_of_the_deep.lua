chaotic_bash_of_the_deep = chaotic_bash_of_the_deep or  class({})
LinkLuaModifier( "modifier_chaotic_bash_of_the_deep", "chaotic_spell/class_8/chaotic_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_bash_of_the_deep_debuff", "chaotic_spell/class_8/chaotic_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_bash_of_the_deep_check", "chaotic_spell/class_8/chaotic_bash_of_the_deep", LUA_MODIFIER_MOTION_NONE )

function chaotic_bash_of_the_deep:GetIntrinsicModifierName()
	return "modifier_chaotic_bash_of_the_deep"
end

function chaotic_bash_of_the_deep:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_slardar/slardar_crush_entity.vpcf", context )
end
------------------------------------------------------
modifier_chaotic_bash_of_the_deep = advanced_modifier({})

function modifier_chaotic_bash_of_the_deep:IsHidden()	return self:GetStackCount()<1 end
function modifier_chaotic_bash_of_the_deep:IsPurgable()	return false end
function modifier_chaotic_bash_of_the_deep:IsPurgeException() return false end
function modifier_chaotic_bash_of_the_deep:RemoveOnDeath() return false end


function modifier_chaotic_bash_of_the_deep:OnCreated( kv )
    self.ability = self:GetAbility()
	self.count = self.ability:GetSpecialValueFor( "count" )
	self.max = self.ability:GetSpecialValueFor( "max" )
	self.max_time = self.ability:GetSpecialValueFor( "max_time" )
    self.superhit = self.ability:GetSpecialValueFor( "superhit" )
	self.bonus_superhit = self.ability:GetSpecialValueFor( "bonus_superhit" )
	self.rune_1_burstdamage = self.ability:GetSpecialValueFor( "rune_1_burstdamage" )
	self.record = {}
    self.type = self.ability:GetRuneType()
end

function modifier_chaotic_bash_of_the_deep:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT
	}
	return funcs
end

function modifier_chaotic_bash_of_the_deep:ADDeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
	}
	return funcs
end

function modifier_chaotic_bash_of_the_deep:GetModifierPreAttack_BonusDamagePostCrit( keys )
	if IsServer() then
        local caster = self:GetCaster()
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end


		self:SetStackCount(math.min(self:GetStackCount()+1, self.count))

		if self:GetStackCount()>=self.count then
			self.record[keys.record] = true
			self:SetStackCount(0)
			local superhit = self.superhit+ self.bonus_superhit*caster:GetAverageTrueAttackDamage(nil)
			return superhit
		end
	end
end

function modifier_chaotic_bash_of_the_deep:OnAttackLanded(keys)
	if not IsServer() then return end

	if keys.attacker == self:GetParent() then	
		if self.record[keys.record] then
			local ability = self:GetAbility()
			if not ability or ability:IsNull() then
				return
			end

			if not keys.target or keys.target:IsNull() then
				return
			end

			local check = keys.target:FindModifierByName("modifier_chaotic_bash_of_the_deep_check")

			if not check then
				-- 未被施加印记
				local duration = self:GetAbility():GetSpecialValueFor("duration")
				self:PlayEffects(keys.target, duration)
				keys.target:AddNewModifier(self:GetParent(), ability, "modifier_chaotic_bash_of_the_deep_check", {stack = 1})

			else
				-- 被施加印记，但印记不大最大数目
				if check and check:GetStackCount() < self.max then
					local duration = self:GetAbility():GetSpecialValueFor("duration")
					self:PlayEffects(keys.target, duration)
					keys.target:AddNewModifier(self:GetParent(), ability, "modifier_chaotic_bash_of_the_deep_check", {stack = 1})


					if check:GetStackCount() == self.max and self.type == 1 then
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

function modifier_chaotic_bash_of_the_deep:PlayEffects(target,duration)
	target:HDAddNewBadModifier(self:GetParent(), self:GetAbility(), "modifier_chaotic_bash_of_the_deep_debuff", {duration = duration}, nil, 0.6, 0.8)--攻击者，来源，modifier，table，nil，负面影响，抗性影响
	EmitSoundOn( "Hero_Slardar.Bash", target )
end

function modifier_chaotic_bash_of_the_deep:PlayBurstEffects(target)
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
		damage = self:GetCaster():GetAverageTrueAttackDamage(nil)* self.rune_1_burstdamage,
		damage_type =  self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, 
		hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
		ability = self:GetAbility(),
	}
	ApplyDamage(damageTable)
end

------------------------------------------------------------
modifier_chaotic_bash_of_the_deep_debuff = advanced_modifier({})
function modifier_chaotic_bash_of_the_deep_debuff:IsHidden()	return false end
function modifier_chaotic_bash_of_the_deep_debuff:IsDebuff()	return true end
function modifier_chaotic_bash_of_the_deep_debuff:IsPurgable()	return false end
function modifier_chaotic_bash_of_the_deep_debuff:CheckState()
	return{
		[MODIFIER_STATE_STUNNED] = true,
	}
end

------------------------------------------------------------
modifier_chaotic_bash_of_the_deep_check = advanced_modifier({})
function modifier_chaotic_bash_of_the_deep_check:IsHidden()	return false end
function modifier_chaotic_bash_of_the_deep_check:IsDebuff()	return true end
function modifier_chaotic_bash_of_the_deep_check:IsPurgable()	return false end

function modifier_chaotic_bash_of_the_deep_check:OnCreated(keys)
	if not self:GetAbility() then self:Destroy() return end
	
	self.max = self:GetAbility():GetSpecialValueFor( "max" )
	self.max_time = self:GetAbility():GetSpecialValueFor( "max_time" )
	if IsServer() then
		self.stack = self.stack or 0
		self.stack = self.stack + keys.stack
		self:SetStackCount(self.stack)
	end
end

function modifier_chaotic_bash_of_the_deep_check:OnRefresh(keys)
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