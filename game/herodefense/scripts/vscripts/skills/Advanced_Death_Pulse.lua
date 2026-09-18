--特效优化 √
Advanced_Death_Pulse = Advanced_Death_Pulse or class({})
LinkLuaModifier("modifier_Advanced_Death_Pulse_unlock2", "skills/Advanced_Death_Pulse", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Death_Pulse_heal", "skills/Advanced_Death_Pulse", LUA_MODIFIER_MOTION_NONE)

function Advanced_Death_Pulse:GetCastRange(vLocation, hTarget)
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	return self:GetSpecialValueFor("radius") - self:GetCaster():GetCastRangeBonus()
end

require('internal/timers')   --计时器功能
function Advanced_Death_Pulse:CheckKV(key)
	local table = {
		damage = 10,
		bonus_damage = 0.1,
		poison_extra = 0.3,
	}
	local value = table[key] or -1
	return value
end

function Advanced_Death_Pulse:UnlockFirstCore(key)
	return true
end
function Advanced_Death_Pulse:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Death_Pulse_unlock2",{})
	return true
end
function Advanced_Death_Pulse:UnlockThirdCore(key)
	return true
end


function Advanced_Death_Pulse:OnSpellStart()
	if IsServer() then
		local caster = self:GetCaster()
		local caster_loc = caster:GetAbsOrigin()
		local level = self.advanced_level
		local radius = self:GetSpecialValueFor("radius")

		caster:EmitSound("Hero_Necrolyte.DeathPulse")


		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,enemy in pairs(enemies) do
			self:ReleaseProjectile(caster,enemy,1)
		end

		local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _,ally in pairs(allies) do
			self:ReleaseProjectile(caster,ally,0)
		end
		--新LV20，奥义3，概率多发
		if level>=20 then
			local chance = 30
			if self.unlock3 then
				chance  = 100
			end
			if chance>=RandomInt(1, 100) then
				caster:GameTimer(0.5,function()
					local enemies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, 2*radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					local allies = FindUnitsInRadius(caster:GetTeamNumber(), caster_loc, nil, 2*radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
					for _,enemy in pairs(enemies) do
						self:ReleaseProjectile(caster,enemy,1)
					end
					for _,ally in pairs(allies) do
						self:ReleaseProjectile(caster,ally,0)
					end

				end)
			end
			
		end
	end
end

function Advanced_Death_Pulse:ReleaseProjectile(srouce,target,state)
	local projectile =
		{
			Target = target,
			Source = srouce,
			Ability = self,
			EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_friend.vpcf",
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = self:GetSpecialValueFor("projectile_speed"),
			flExpireTime = GameRules:GetGameTime() + 60,
			--	iVisionRadius = vision_radius,
			--	iVisionTeamNumber = caster:GetTeamNumber(),
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
			ExtraData = {state =state}
	}
	ProjectileManager:CreateTrackingProjectile(projectile)
end


function Advanced_Death_Pulse:OnProjectileHit_ExtraData(target, vLocation, extraData)
	if IsServer() then
		local caster = self:GetCaster()
		if not target or target:IsNull() then
			return
		end
		if extraData.state ==1  then
			local damage = self:GetSpecialValueFor("damage")+caster:GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage"))
			local poison = target:FindModifierByName("modifier_hd_poison")
			self.index = 0
			if self.advanced_level >= 10 then
				self.index = 45
			end
			if poison then
				self.index = self:GetSpecialValueFor("poison_total")*0.01 *4.46--毒伤总系数446%，结算值54.7%时对准3跳伤害244%，结算值40.3%时对准2跳伤害180%
				damage = damage * (1+self:GetSpecialValueFor("poison_extra")*0.01)
				ApplyPoisonDamage(caster,self,target,poison:GetStackCount()*self.index)
				target:RemoveModifierByName("modifier_hd_poison")
			end
			ApplyDamage({attacker = caster, victim = target, ability = self, damage = damage, damage_type = self:GetAbilityDamageType()})
			if self.advanced_level >= 15 then
				local newCooldown = math.max(self:GetCooldownTimeRemaining() - 0.2,0)
				if not self:IsCooldownReady() then
					self:EndCooldown()
					self:StartCooldown(newCooldown)
				end
			end
	
			if self.unlock1 and target:IsAlive() then
				if caster:GetRandomEffect(15,INT_TYPE,1) >=RandomInt(1, 100) then
					local reapers_scythe = caster:FindAbilityByName("Advanced_Reapers_Scythe")
					if reapers_scythe then
						reapers_scythe:Release(target)
					end
				end
			end
			return
		end


		if extraData.state ==0  then
			local heal = (self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage"))) * (1+self:GetSpecialValueFor("middle_heal_up")*0.01)
			local poi = (self:GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetSpecialValueFor("bonus_damage"))) * (self:GetSpecialValueFor("middle_poison")*0.01)
			local healing = HealWithGain(heal,caster,target,self)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, target, healing, nil)
			target:Poison(caster,self, poi)
			if self.advanced_level >= 5 then
				target:AddNewModifier(caster,self,"modifier_Advanced_Death_Pulse_heal",{duration = 10})
			end
			if self.advanced_level >= 15 then
				local newCooldown = math.max(self:GetCooldownTimeRemaining() - 0.2,0)
				if not self:IsCooldownReady() then
					self:EndCooldown()
					self:StartCooldown(newCooldown)
				end
			end
		end
	end
end



function Advanced_Death_Pulse:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		
	end

	return self.BaseClass.GetBehavior(self)

end



modifier_Advanced_Death_Pulse_unlock2 = class({})

function modifier_Advanced_Death_Pulse_unlock2:IsDebuff()			return false end
function modifier_Advanced_Death_Pulse_unlock2:IsHidden() 			return true end
function modifier_Advanced_Death_Pulse_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Death_Pulse_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Death_Pulse_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Death_Pulse_unlock2:OnCreated(keys)
	if IsServer() then
		self.interval = 2.094395
		self.timer = GameRules:GetGameTime() + self.interval
		self:StartIntervalThink(FrameTime())
	end
end

-- function modifier_Advanced_Death_Pulse_unlock2:OnDestroy()
-- 	if IsServer() then
-- 		-- ParticleManager:DestroyParticle(self.nBeamFX, false)
-- 		-- ParticleManager:ReleaseParticleIndex(self.nBeamFX)
-- 	end
-- end


function modifier_Advanced_Death_Pulse_unlock2:OnIntervalThink()
	if GameRules:GetGameTime()>=self.timer then
		self.timer = GameRules:GetGameTime() + self.interval
		self:GetAbility():OnSpellStart()
		local poison = self:GetCaster():FindModifierByName("modifier_hd_poison")
		if poison then
			poison:SetStackCount(poison:GetStackCount()*0.1)
		end
	end

end


----
modifier_Advanced_Death_Pulse_heal = advanced_modifier({})

function modifier_Advanced_Death_Pulse_heal:IsDebuff()			return false end
function modifier_Advanced_Death_Pulse_heal:IsHidden() 			return true end
function modifier_Advanced_Death_Pulse_heal:IsPurgable() 		return false end
function modifier_Advanced_Death_Pulse_heal:IsPurgeException() 	return false end
function modifier_Advanced_Death_Pulse_heal:GetAttributes() 		return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Death_Pulse_heal:OnCreated(keys)
	self.heal = (self:GetAbility():GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetAbility():GetSpecialValueFor("bonus_damage")))*0.05
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_Death_Pulse_heal:OnIntervalThink()
	self.heal = (self:GetAbility():GetSpecialValueFor("damage")+self:GetCaster():GetIntellect(false)*(self:GetAbility():GetSpecialValueFor("bonus_damage")))*0.05
	local healing = HealWithGain(self.heal,self:GetCaster(),self:GetParent(),self:GetAbility())
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), healing, nil)
end