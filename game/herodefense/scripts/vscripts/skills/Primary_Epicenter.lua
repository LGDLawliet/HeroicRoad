
Primary_Epicenter = class({})

LinkLuaModifier("modifier_Primary_Epicenter", "skills/Primary_Epicenter", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Primary_Epicenter_2", "skills/Primary_Epicenter", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Primary_Epicenter_slow", "skills/Primary_Epicenter", LUA_MODIFIER_MOTION_NONE)



function Primary_Epicenter:IsHiddenWhenStolen() 		return false end
function Primary_Epicenter:IsRefreshable() 			return true end
function Primary_Epicenter:IsStealable() 				return true end
function Primary_Epicenter:IsNetherWardStealable()	return true end
function Primary_Epicenter:GetChannelAnimation() return ACT_DOTA_CAST_ABILITY_4 end


function Primary_Epicenter:OnSpellStart()
	local caster = self:GetCaster()
	caster:EmitSound("Ability.SandKing_Epicenter.spell")
	self.max_stack = self:GetSpecialValueFor("max_pulses")
	self.think_time = self:GetChannelTime() / self.max_stack --每次叠加一层的时间
	self.buff = caster:AddNewModifier(caster, self, "modifier_Primary_Epicenter", {})
	if self.buff then
		self.buff:IncrementStackCount()
	end
	self.totaltime = 0
	self.think = 0
	---interval 0.8 1.8
end

function Primary_Epicenter:OnChannelThink(time)
	
	self.totaltime = self.totaltime + time  --总时间
	self.think = self.think + time   --当前累加
	for i=1, 4 do
		if self.totaltime <= i and i <= self.totaltime + time then
			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster())
			ParticleManager:SetParticleControl(pfx, 0, self:GetCaster():GetAbsOrigin())
			ParticleManager:SetParticleControl(pfx, 1, Vector(275 + i*100,1,1))
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end

	if not self.buff or self.buff:IsNull() then
		return
	end
	--当前累加小于间隔  间隔小于
	if self.think >= self.think_time and self.totaltime<(self.max_stack*self.think_time) then
	-- if self.think <= self.think_time and self.think_time <= self.think + time then
		self.buff:SetStackCount(math.min(self.buff:GetStackCount() + 1, self.max_stack))
		self.think = 0
	end
end

function Primary_Epicenter:OnChannelFinish(b)
	if not self.buff or self.buff:IsNull() then
		return
	end
	local interval = self:GetSpecialValueFor("pulse_duration") / self.buff:GetStackCount()
	if self.buff:GetStackCount() == 0 then
		interval = 0.1
	end
	self.buff:StartIntervalThink(interval)
	self:GetCaster():EmitSound("Ability.SandKing_Epicenter")
	
	
end

function Primary_Epicenter:SandKingEffect()
	local caster = self:GetCaster()
	local modifier = caster:FindModifierByName("modifier_Primary_Epicenter_2")
	if modifier then
		modifier:SetStackCount(modifier:GetStackCount()+1)
	else
		self.buff2 = caster:AddNewModifier(caster, self, "modifier_Primary_Epicenter_2", {})
		if self.buff2 and not self.buff2:IsNull() then
			self.buff2:StartIntervalThink(0)
		end
	end
end




modifier_Primary_Epicenter = class({})

function modifier_Primary_Epicenter:IsDebuff()			return false end
function modifier_Primary_Epicenter:IsHidden() 		return false end
function modifier_Primary_Epicenter:IsPurgable() 		return false end
function modifier_Primary_Epicenter:IsPurgeException() return false end
function modifier_Primary_Epicenter:RemoveOnDeath() 	return false end
function modifier_Primary_Epicenter:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
-- function modifier_Primary_Epicenter:OnCreated(table)
-- 	if IsServer() then
-- 		self:IncrementStackCount()
-- 	end

-- end
function modifier_Primary_Epicenter:OnIntervalThink()
	if not IsServer() then return end
	local caster =self:GetCaster()
	EpicenterTriggerAfterShock(caster)  --触发余震逻辑
	caster:EmitSound("Hero_Sandking.EpiPulse")
	self.radius = self.radius or self:GetAbility():GetSpecialValueFor('base_radius')
	self:DecrementStackCount()
	local pfx = ParticleManager:CreateParticle("particles/new_effect/new_effect/newr_epicenter_wave.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1, Vector(self.radius+1000,1,1))
	ParticleManager:ReleaseParticleIndex(pfx)
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(self.radius+650,1,1))
	ParticleManager:ReleaseParticleIndex(pfx2)
	local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue()
	
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local duration =self:GetAbility():GetSpecialValueFor("slow_duration")
	for i, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Primary_Epicenter_slow", {duration = duration*StatusResistance})
		if i>=10 then
			break
		end
	end
	-- if caster:HasAbility("imba_sandking_treacherous_sands") and caster:FindAbilityByName("imba_sandking_treacherous_sands"):GetToggleState() then
	-- 	local pull_radius = caster:HasScepter() and self:GetAbility():GetSpecialValueFor("pull_radius_scepter") or self:GetAbility():GetSpecialValueFor("pull_radius")
	-- 	local enemies_pull = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- 	for _, enemy in pairs(enemies_pull) do
	-- 		if (enemy:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() > self:GetAbility():GetSpecialValueFor("pull_strength") * 2.0 then
	-- 			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Primary_Epicenter_motion", {duration = 0.05})
	-- 		end
	-- 	end
	-- end
	-- self.radius = self.radius + self:GetAbility():GetSpecialValueFor("step_radius")
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end

function modifier_Primary_Epicenter:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Sandking.EpiPulse")
		self.radius = nil
	end
end




modifier_Primary_Epicenter_2 = class({})

function modifier_Primary_Epicenter_2:IsDebuff()			return false end
function modifier_Primary_Epicenter_2:IsHidden() 		return true end
function modifier_Primary_Epicenter_2:IsPurgable() 		return false end
function modifier_Primary_Epicenter_2:IsPurgeException() return false end
function modifier_Primary_Epicenter_2:RemoveOnDeath() 	return false end
function modifier_Primary_Epicenter_2:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_Primary_Epicenter_2:OnIntervalThink()
	if not IsServer() then return end
	local caster =self:GetCaster()
	EpicenterTriggerAfterShock(caster)  --触发余震逻辑
	caster:EmitSound("Hero_Sandking.EpiPulse")
	self.radius = self.radius or self:GetAbility():GetSpecialValueFor('base_radius')
	self:DecrementStackCount()
	local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx2, 1, Vector(400,1,1))
	ParticleManager:ReleaseParticleIndex(pfx2)
	local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*caster:HDGetPrimaryStatValue()
	damage = damage * 0.8
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
	local duration =self:GetAbility():GetSpecialValueFor("slow_duration")
	for i, enemy in pairs(enemies) do
		local damageTable = {
							victim = enemy,
							attacker = caster,
							damage = damage,
							damage_type = self:GetAbility():GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
							ability = self:GetAbility(), --Optional.
							}
		ApplyDamage(damageTable)
		local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
		enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Primary_Epicenter_slow", {duration = duration*StatusResistance})
		if i>=10 then
			break
		end
	end
	-- self.radius = self.radius + self:GetAbility():GetSpecialValueFor("step_radius")
	if self:GetStackCount() == 0 then
		self:SafeDestroy()
	end
end

function modifier_Primary_Epicenter_2:OnDestroy()
	if IsServer() then
		self:GetCaster():StopSound("Hero_Sandking.EpiPulse")
		self.radius = nil
	end
end










modifier_Primary_Epicenter_slow = class({})

function modifier_Primary_Epicenter_slow:IsDebuff()			return true end
function modifier_Primary_Epicenter_slow:IsHidden() 			return false end
function modifier_Primary_Epicenter_slow:IsPurgable() 			return true end
function modifier_Primary_Epicenter_slow:IsPurgeException() 	return true end
function modifier_Primary_Epicenter_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT} end
function modifier_Primary_Epicenter_slow:GetModifierMoveSpeedBonus_Constant() return self.m_slow end
function modifier_Primary_Epicenter_slow:GetModifierAttackSpeedBonus_Constant() return self.a_slow end


function modifier_Primary_Epicenter_slow:OnCreated()
	self.m_slow = - self:GetAbility():GetSpecialValueFor("slow_ms")
	self.a_slow = - self:GetAbility():GetSpecialValueFor("slow_as")
end
function modifier_Primary_Epicenter_slow:OnRefresh(table)
	self.m_slow = - self:GetAbility():GetSpecialValueFor("slow_ms")
	self.a_slow = - self:GetAbility():GetSpecialValueFor("slow_as")
end