LinkLuaModifier("modifier_creeps_spell_Static_Link_buff", "creeps_spell/creeps_spell_Static_Link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Static_Link_debuff", "creeps_spell/creeps_spell_Static_Link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Static_Link_attack_target", "creeps_spell/creeps_spell_Static_Link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Static_Link_attack", "creeps_spell/creeps_spell_Static_Link.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_Static_Link", "creeps_spell/creeps_spell_Static_Link.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if creeps_spell_Static_Link == nil then
	creeps_spell_Static_Link = class({})
end
function creeps_spell_Static_Link:GetCastRange(vLocation, hTarget)
	return self.BaseClass.GetCastRange(self, vLocation, hTarget)+self:GetSpecialValueFor("cast_range")
end
function creeps_spell_Static_Link:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local ModifierStatusNegativeGain = hCaster:GetModifierStatusNegativeGainIndex(0.5)
	local StatusResistance = hTarget:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	local fDrainLength = self:GetSpecialValueFor("drain_duration")*StatusResistance
	if hTarget:TriggerSpellAbsorb(self) then
		return
	end
	hCaster:EmitSound("Ability.static.start")

	hCaster:AddNewModifier(hCaster, self, "modifier_creeps_spell_Static_Link",{duration=fDrainLength,hTargetEntIndex=hTarget:entindex()})--挂自己身上用于停止loop声音
	-- hTarget:AddNewModifier(hCaster, self, "modifier_creeps_spell_Static_Link_attack_target",{duration=fDrainLength}) --攻击独立modifier计算会导致链接断开延迟时间不一致

	hCaster:AddNewModifier(hCaster, self, "modifier_creeps_spell_Static_Link_buff", {hTargetEntIndex=hTarget:entindex()})--抽完攻击力继续持续20s
	hTarget:AddNewModifier(hCaster, self, "modifier_creeps_spell_Static_Link_debuff",nil)--抽完攻击力继续持续20s
end

-----------------------------------------------------------------
--用于攻击目标
if modifier_creeps_spell_Static_Link_attack_target==nil then
	modifier_creeps_spell_Static_Link_attack_target=class({})
end
function modifier_creeps_spell_Static_Link_attack_target:IsHidden()return false end
function modifier_creeps_spell_Static_Link_attack_target:IsPurgable()return false end
function modifier_creeps_spell_Static_Link_attack_target:IsPurgeException()return false end
function modifier_creeps_spell_Static_Link_attack_target:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1/self:GetCaster():GetAttacksPerSecond(false))
	end
end
function modifier_creeps_spell_Static_Link_attack_target:OnIntervalThink()
	if IsServer() then
		if not IsValid(self:GetCaster()) or not self:GetCaster():IsAlive() or  
		CalculateDistance(self:GetParent(),self:GetCaster())>
		self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())+self:GetAbility():GetSpecialValueFor("drain_range_buffer") then
			self:SafeDestroy()
			return
		end
		-- self:GetCaster():Attack(self:GetParent(),ATTACK_STATE_SKIPCOOLDOWN)
		local iParticleID=ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link_hit.vpcf",PATTACH_POINT_FOLLOW , self:GetCaster())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_static", self:GetCaster():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_3)
		self:StartIntervalThink(1/self:GetCaster():GetAttacksPerSecond(false))
	end
end
function modifier_creeps_spell_Static_Link_attack_target:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_creeps_spell_Static_Link_attack_target:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
-------------------------------------------------
if modifier_creeps_spell_Static_Link == nil then
	modifier_creeps_spell_Static_Link = class({})
end
function modifier_creeps_spell_Static_Link:IsHidden()return true end
function modifier_creeps_spell_Static_Link:IsDebuff()return false end
function modifier_creeps_spell_Static_Link:IsPurgable()return false end
function modifier_creeps_spell_Static_Link:IsPurgeException()return false end
function modifier_creeps_spell_Static_Link:OnCreated(params)
	if IsServer() then
		local ability = self:GetAbility()
		self.fDrainDuration = ability:GetSpecialValueFor("drain_duration")
		self.fDrainRate =ability:GetSpecialValueFor("drain_rate")
		self.hTarget=EntIndexToHScript(params.hTargetEntIndex)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link.vpcf", PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		self:StartIntervalThink(0.25)
	end
end
function modifier_creeps_spell_Static_Link:OnIntervalThink()
	if IsServer() then
		if not IsValid(self.hTarget) or not self.hTarget:IsAlive() or 
		CalculateDistance(self.hTarget,self:GetCaster())>
		self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())+self:GetAbility():GetSpecialValueFor("drain_range_buffer") then
			self:SafeDestroy()
		end
		if not self:GetCaster():IsAlive() then
			self:SafeDestroy()
		end
	end
end
function modifier_creeps_spell_Static_Link:OnRefresh(params)
	self:OnCreated()
end
-- function modifier_creeps_spell_Static_Link:CheckState()
-- 	return {
-- 		[MODIFIER_STATE_DISARMED]=true,
-- 	}
-- end
function modifier_creeps_spell_Static_Link:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_creeps_spell_Static_Link:OnDestroy()
	if IsServer() then
		self:GetCaster():EmitSound("Ability.static.end")
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------
--吸收攻击力BUFF
if modifier_creeps_spell_Static_Link_buff == nil then
	modifier_creeps_spell_Static_Link_buff = class({})
end
function modifier_creeps_spell_Static_Link_buff:IsHidden()return false end
function modifier_creeps_spell_Static_Link_buff:IsDebuff()return false end
function modifier_creeps_spell_Static_Link_buff:IsPurgable() return false end
function modifier_creeps_spell_Static_Link_buff:IsPurgeException()return false end
function modifier_creeps_spell_Static_Link_buff:OnCreated(params)
	if IsServer() then
		local ability = self:GetAbility()
		self.fDrainLength = ability:GetSpecialValueFor("drain_duration")
		self.fDrainDuration = ability:GetSpecialValueFor("buff_duration")
		self.fDrainRate = ability:GetSpecialValueFor("bonus_damage")
		self.fDrainRate_attribute = ability:GetSpecialValueFor("bonus_attribute")
		self.flimit = ability:GetSpecialValueFor("limit")
		self.iCumulativeTime = 0
		self.iCumulativeDamage = 0
		self.hTarget=EntIndexToHScript(params.hTargetEntIndex)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_static_link_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, nil, PATTACH_POINT_FOLLOW, "attach_static",self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(50,0,0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		self:StartIntervalThink(0.25)
	end
end
function modifier_creeps_spell_Static_Link_buff:OnIntervalThink()
	if IsServer() then
		if  not IsValid(self.hTarget) or not self.hTarget:IsAlive() or self.iCumulativeTime == self.fDrainLength or CalculateDistance(self.hTarget,self:GetCaster())>self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())+self:GetAbility():GetSpecialValueFor("drain_range_buffer") then
			self:LinkEnd()
		else
			self.iCumulativeDamage = self.iCumulativeDamage + self.fDrainRate * 0.25
			self.iCumulativeTime = self.iCumulativeTime + 0.25
			self:SetDuration(self.fDrainDuration, true)
			self:SetStackCount(math.floor(self.iCumulativeDamage))
		end
	end
end
function modifier_creeps_spell_Static_Link_buff:OnRefresh(params)
	self:OnCreated()
end
function modifier_creeps_spell_Static_Link_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end
------三围
function  modifier_creeps_spell_Static_Link_buff:GetModifierBonusStats_Agility() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return (self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
function  modifier_creeps_spell_Static_Link_buff:GetModifierBonusStats_Intellect() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return (self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
function  modifier_creeps_spell_Static_Link_buff:GetModifierBonusStats_Strength() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return (self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
	

function modifier_creeps_spell_Static_Link_buff:GetModifierPreAttack_BonusDamage()return self:GetStackCount()end
function modifier_creeps_spell_Static_Link_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_creeps_spell_Static_Link_buff:LinkEnd()
	if IsServer() then
		self:SetDuration(self.fDrainDuration, true)
		self:StartIntervalThink(-1)
	end
end
function modifier_creeps_spell_Static_Link_buff:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------
--被吸收攻击力
if modifier_creeps_spell_Static_Link_debuff == nil then
	modifier_creeps_spell_Static_Link_debuff = class({})
end
function modifier_creeps_spell_Static_Link_debuff:IsHidden()return false end
function modifier_creeps_spell_Static_Link_debuff:IsDebuff()return true end
function modifier_creeps_spell_Static_Link_debuff:IsPurgable()return false end
function modifier_creeps_spell_Static_Link_debuff:IsPurgeException()return false end
function modifier_creeps_spell_Static_Link_debuff:OnCreated(params)
	local ability = self:GetAbility()
	self.fDrainLength = ability:GetSpecialValueFor("drain_duration")
	self.fDrainDuration = ability:GetSpecialValueFor("buff_duration")
	self.fDrainRate = ability:GetSpecialValueFor("bonus_damage")
	self.fDrainRate_attribute = ability:GetSpecialValueFor("bonus_attribute")
	self.flimit = ability:GetSpecialValueFor("limit")
	self.iCumulativeTime = 0
	self.iCumulativeDamage = 0
	if IsServer() then
		self:StartIntervalThink(0.25)
	end
end
function modifier_creeps_spell_Static_Link_debuff:OnIntervalThink()
	if IsServer() then
		if not IsValid(self:GetCaster())  then
			self:SafeDestroy()
			return
		end

		if  not IsValid(self:GetParent()) or not self:GetParent():IsAlive() or not self:GetAbility() or
		 self.iCumulativeTime == self.fDrainLength or 
		 CalculateDistance(self:GetParent(),self:GetCaster())>
		 self:GetAbility():GetCastRange(self:GetCaster():GetAbsOrigin(),self:GetCaster())+self:GetAbility():GetSpecialValueFor("drain_range_buffer") then
			self:LinkEnd()
		else
			self.iCumulativeDamage = self.iCumulativeDamage + self.fDrainRate * 0.25
			self.iCumulativeTime = self.iCumulativeTime + 0.25
			self:SetDuration(self.fDrainDuration, true)
			self:SetStackCount(math.floor(self.iCumulativeDamage))
		end
	end
end
function modifier_creeps_spell_Static_Link_debuff:OnRefresh(params)
	self:OnCreated()
end
function modifier_creeps_spell_Static_Link_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS, MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end
function modifier_creeps_spell_Static_Link_debuff:CheckState()
	return{
		[MODIFIER_STATE_PROVIDES_VISION]=true,
	}
end
function modifier_creeps_spell_Static_Link_debuff:GetModifierPreAttack_BonusDamage()return -self:GetStackCount()end
function modifier_creeps_spell_Static_Link_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_creeps_spell_Static_Link_debuff:GetEffectName()
	return "particles/units/heroes/hero_razor/razor_static_link_debuff.vpcf"
end
function modifier_creeps_spell_Static_Link_debuff:LinkEnd()
	if IsServer() then
		self:SetDuration(self.fDrainDuration, true)
		self:StartIntervalThink(-1)
	end
end
function modifier_creeps_spell_Static_Link_debuff:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end

function  modifier_creeps_spell_Static_Link_debuff:GetModifierBonusStats_Agility() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return -(self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
function  modifier_creeps_spell_Static_Link_debuff:GetModifierBonusStats_Intellect() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return -(self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
function  modifier_creeps_spell_Static_Link_debuff:GetModifierBonusStats_Strength() 
	if self:GetStackCount()/self.fDrainRate > self.flimit then
		return -(self:GetStackCount()/self.fDrainRate-self.flimit)*self.fDrainRate_attribute
	else
	return 0 end end
	