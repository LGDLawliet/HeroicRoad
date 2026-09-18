--特效优化 √

Advanced_Time_Drain = class({})
LinkLuaModifier( "modifier_Advanced_Time_Drain", "skills/Advanced_Time_Drain", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Time_Drain_time_controler", "skills/Advanced_Time_Drain", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Time_Drain_unlock3", "skills/Advanced_Time_Drain", LUA_MODIFIER_MOTION_NONE )
require('internal/timers')   --计时器功能

-----------------------------------------------------------------------------------------

function Advanced_Time_Drain:CheckKV(key)
	local table = {
		chance=0.8,



	}
	local value = table[key] or -1
	return value

end
function Advanced_Time_Drain:GetIntrinsicModifierName()
	return "modifier_Advanced_Time_Drain"
end
function Advanced_Time_Drain:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock1",{})
	return true
end
function Advanced_Time_Drain:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_magic_blessing_unlock2",{})
	return true
end
function Advanced_Time_Drain:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Time_Drain_unlock3",{})
	return true
end
-- function Advanced_Time_Drain:GetCooldown(iLevel)
-- 	return 1.5 /self:GetCaster():GetCooldownReduction()
-- end
function Advanced_Time_Drain:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/time_drain/unlock1/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/time_drain/unlock3/effect.vpcf", context )
end

function Advanced_Time_Drain:GetBehavior()

	if self:GetCaster():HasModifier("modifier_Advanced_Time_Drain_unlock3") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Time_Drain:IsRefreshable() return false end

function Advanced_Time_Drain:CastFilterResult( vLoc )
	-- check nohammer
	if IsServer() then
		
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Time_Drain_unlock3")
		if modifier then
			local time = modifier:GetRemainingTime()
			if time>=0 then
				return UF_FAIL_CUSTOM
			else
				return UF_SUCCESS
			end
		end

	

		return UF_FAIL_CUSTOM
	end
	
end

function Advanced_Time_Drain:GetCustomCastError( vLoc )
	-- check nohammer
	if IsServer() then

		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Time_Drain_unlock3")
		if modifier then
			local time = modifier:GetRemainingTime()
			if time>=0 then
				return "dota_hub_cooldown"
			else
				return ""
			end
		end

		return ""
	end

end
function Advanced_Time_Drain:OnSpellStart()
	local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Time_Drain_unlock3")
	if modifier then
		modifier:ReturnBack()
	end
end


modifier_Advanced_Time_Drain = class({})

-----------------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:IsHidden()
	return false
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:IsPurgable() 		return false end
function modifier_Advanced_Time_Drain:IsPurgeException() 	return false end
function modifier_Advanced_Time_Drain:RemoveOnDeath()  return false end
function modifier_Advanced_Time_Drain:DestroyOnExpire()	return false end

--------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:OnCreated( kv )
	if IsClient() then
		return
	end
	self.advanced_level = 1
	self.interval = 1
	self:StartIntervalThink(1)
	self.time = GameRules:GetGameTime()
end

-----------------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
-----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------

function modifier_Advanced_Time_Drain:OnAttackLanded( params )
	local Attacker = params.attacker
	local Target = params.target
	if not IsServer() then
		return
	end
	if self:GetParent():PassivesDisabled() then
		return
	end

	--自己是攻击者
	local chance = self:GetAbility():GetSpecialValueFor( "chance" )
	if Attacker == self:GetParent() then
		if chance >= RandomInt(0,100)  then
			if self:GetRemainingTime()>0 then
				return
			end
			self.cooldown_reduction = self:GetAbility():GetSpecialValueFor( "cooldown_reduction" )
			--LV20解锁真视界
			if self.advanced_level>=20 then
				self.cooldown_reduction = self.cooldown_reduction+1
			end
			self.healthRegen_index = self:GetAbility():GetSpecialValueFor( "healthRegen_index" )
			local HealthRegen_damage = self.healthRegen_index * Target:GetHealthRegen() 
			if HealthRegen_damage < 0 then
				HealthRegen_damage = HealthRegen_damage * -1 
			end
	
			local damagetable =
			{
				victim = Target,
				attacker = Attacker,
				damage = HealthRegen_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = self:GetAbility(),
			}
			--ApplyDamage( damagetable )	
			--LV15解锁汲取
			if self.advanced_level>=15 then
				-- Attacker:SetHealth(Attacker:GetHealth()+HealthRegen_damage)
				Attacker:ModifyHealth(Attacker:GetHealth()+HealthRegen_damage,self:GetAbility(),false,0)
			end

			local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_borrowed_time_end.vpcf", PATTACH_ROOTBONE_FOLLOW, Attacker)

			local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_weaver/weaver_timelapse_b.vpcf", PATTACH_ROOTBONE_FOLLOW, Target)
			--后期需调整
			for i=0, self:GetParent():GetAbilityCount() - 1 do
				local Ability = self:GetParent():GetAbilityByIndex(i)
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and Ability:GetAbilityType() ~= 1  and not Ability:IsCooldownReady() then
					local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduction
					self.cooldown_reduction = self.cooldown_reduction *0.8
					Ability:EndCooldown()
					if newCooldown>=0 then
						Ability:StartCooldown(newCooldown)
					end
				end
			end

			for i=0, 9 do
				local Ability = self:GetParent():GetItemInSlot(i)
				if Ability ~= nil and Ability:IsRefreshable() and Ability ~= self:GetAbility()  and not Ability:IsCooldownReady() then
					local newCooldown = Ability:GetCooldownTimeRemaining() - self.cooldown_reduction
					self.cooldown_reduction = self.cooldown_reduction *0.8
					Ability:EndCooldown()
					if newCooldown>=0 then
						Ability:StartCooldown(newCooldown)
					end
				end
			end
			ParticleManager:ReleaseParticleIndex(particle1)
			ParticleManager:ReleaseParticleIndex(particle2)
			EmitSoundOn( "Hero_FacelessVoid.TimeWalk", self:GetCaster())
			-- self:GetAbility():UseResources(false, false, true)
			self:SetDuration(1.5, true)
			--self:GetAbility():CastAbility()
		end
		
	end

	--自己是被攻击者
	local time_controler_chance = 10
	--LV5解锁时间管理大师+
	if self.advanced_level>=5 then
		time_controler_chance = 15
	end
	if Target==self:GetParent() and time_controler_chance>=RandomInt(1, 100)  then
		if not Target:HasModifier("modifier_Advanced_Time_Drain_time_controler") then
			EmitSoundOn( "Hero_FacelessVoid.TimeWalk", Target)
			Target:AddNewModifier(Target, self:GetAbility(), "modifier_Advanced_Time_Drain_time_controler", {duration = 0.1})
		end
	end

end

function modifier_Advanced_Time_Drain:OnIntervalThink()
	local ability = self:GetAbility()
	self.advanced_level  = ability.advanced_level
	local parent = self:GetParent()

	if parent:PassivesDisabled() then
		return
	end
	if parent:IsAlive() then
		
		if ability.unlock1 then
			local count = RandomInt(1, 5)
			local time = 0.2
			if parent:GetRandomEffect(5,INT_TYPE,1)>= RandomInt(1, 100) then
				count = 20 
				time = 0.5
			end
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
			parent:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, unit in ipairs (enemies) do
				for i = 1, count, 1 do
					Timers:CreateTimer(RandomFloat(0.01, time), function()
						local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/time_drain/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
						ParticleManager:SetParticleControlEnt( nFXIndex, 0,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt( nFXIndex,1,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt( nFXIndex,4,unit, PATTACH_POINT_FOLLOW, nil,unit:GetAbsOrigin(), true )
						ParticleManager:SetParticleControlEnt(nFXIndex, 2, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", parent:GetAbsOrigin(), true)
						ParticleManager:ReleaseParticleIndex(nFXIndex)
						parent:EmitSound("Hero_FacelessVoid.TimeLockImpact")
						local modifier_keys = {
							duration = 0.1,
							iSpecialAttack = 1,
							iDisableApplyModifier = 0,
							iDisableCleave =0,
							iDisableSplit = 0,
					
						}
				
						local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
						parent:PerformAttack(unit, false, true, true, true, false, false, true)--对一单位执行攻击。
						if IsValid(attackEffectRecord) then
							attackEffectRecord:Destroy()
						end
					end)
	
				
				end
				break
			end
			
		else
			local enemies = FindUnitsInRadius(parent:GetTeamNumber(),
			parent:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
			for _, unit in ipairs (enemies) do
				local modifier_keys = {
					duration = 0.1,
					iSpecialAttack = 1,
					iDisableApplyModifier = 0,
					iDisableCleave =0,
					iDisableSplit = 0,
			
				}
		
				local attackEffectRecord = parent:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
				parent:PerformAttack(unit, false, true, true, true, false, false, true)--对一单位执行攻击。
				if IsValid(attackEffectRecord) then
					attackEffectRecord:Destroy()
				end
				if ability.unlock2 and GameRules:GetGameTime()>=self.time and parent:GetRandomEffect(10,INT_TYPE,1)>= RandomInt(1, 100)  then
					self.time = GameRules:GetGameTime() +5
					local ability = parent:FindAbilityByName("Advanced_Chronosphere")
					if ability then
						parent:EmitSound("Hero_FacelessVoid.Chronosphere")
						ability:CreateChronosphere(parent, unit:GetOrigin(), 1000, 2, 1)
					end
				end
				break
			end
		end
		

	end

	--LV10解锁替身+
	if self.interval ~=0.75 and self.advanced_level>=10 then
		self.interval = 0.75
		self:StartIntervalThink(0.75)
	end

end

modifier_Advanced_Time_Drain_time_controler = advanced_modifier({})  

function modifier_Advanced_Time_Drain_time_controler:IsDebuff()			return false end
function modifier_Advanced_Time_Drain_time_controler:IsHidden() 			return true end
function modifier_Advanced_Time_Drain_time_controler:IsPurgable() 		return false end
function modifier_Advanced_Time_Drain_time_controler:IsPurgeException() 	return false end
-- function modifier_Advanced_Time_Drain_time_controler:CheckState() return {[MODIFIER_STATE_INVULNERABLE] = true, [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Advanced_Time_Drain_time_controler:CheckState() return { [MODIFIER_STATE_NO_HEALTH_BAR] = true} end
function modifier_Advanced_Time_Drain_time_controler:Advanced_GetModifierIncomingDamage_Percentage(keys)
	return -100
end

function modifier_Advanced_Time_Drain_time_controler:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end







modifier_Advanced_Time_Drain_unlock3 = class({})


function modifier_Advanced_Time_Drain_unlock3:IsHidden()	return false end
function modifier_Advanced_Time_Drain_unlock3:IsDebuff()	return false end
function modifier_Advanced_Time_Drain_unlock3:IsStunDebuff()	return false end
function modifier_Advanced_Time_Drain_unlock3:RemoveOnDeath()	return false end
function modifier_Advanced_Time_Drain_unlock3:DestroyOnExpire()	return false end
function modifier_Advanced_Time_Drain_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Time_Drain_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Time_Drain_unlock3:OnCreated(keys)
	if IsServer() then
		self.data = {
			health = {},
			mana = {},
			ability = {}
		}

		self:StartIntervalThink(0.1)
	end
end
function modifier_Advanced_Time_Drain_unlock3:OnIntervalThink()
	local parent = self:GetParent()
	
	local health = parent:GetHealth()
	local mana = parent:GetMana()
	table.insert(self.data.health,health)
	table.insert(self.data.mana,mana)
	self:CheckLong(self.data.health)
	self:CheckLong(self.data.mana)
	local abilityTable = self.data.ability
	for i=0, self:GetParent():GetAbilityCount() - 1 do
		local Ability = self:GetParent():GetAbilityByIndex(i)
		if Ability ~= nil then
			local cooldown = Ability:GetCooldownTimeRemaining()
			local abilityName = Ability:GetAbilityName()
			if not abilityTable[abilityName] then
				abilityTable[abilityName] = {}
			end
			table.insert(abilityTable[abilityName],cooldown)
			self:CheckLong(abilityTable[abilityName])
			
		end
	end
	for i=0, 9 do
		local Ability = self:GetParent():GetItemInSlot(i)
		if Ability ~= nil then
			local cooldown = Ability:GetCooldownTimeRemaining()
			local abilityName = Ability:GetAbilityName()
			if not abilityTable[abilityName] then
				abilityTable[abilityName] = {}
			end
			table.insert(abilityTable[abilityName],cooldown)
			self:CheckLong(abilityTable[abilityName])
		end
	end
end
function modifier_Advanced_Time_Drain_unlock3:CheckLong(target)
	if #target>=50 then
		table.remove(target,1)
	end
end

function modifier_Advanced_Time_Drain_unlock3:ReturnBack()

	local parent = self:GetParent()
	local ability = self:GetAbility()
	parent:ModifyHealth(self.data.health[1], ability, false, 0)
	parent:SetMana(self.data.mana[1])
	local abilityTable = self.data.ability
	for i=0, self:GetParent():GetAbilityCount() - 1 do
		local Ability = self:GetParent():GetAbilityByIndex(i)
		if Ability ~= nil then
			-- local cooldown = Ability:GetCooldownTimeRemaining()
			local abilityName = Ability:GetAbilityName()
			if abilityTable[abilityName] then
				local LstCooldownTime = abilityTable[abilityName][1]
				-- if LstCooldownTime<cooldown then
					Ability:EndCooldown()
					Ability:StartCooldown(LstCooldownTime)
				-- end
			end
		end
	end
	for i=0, 9 do
		local Ability = self:GetParent():GetItemInSlot(i)
		if Ability ~= nil then
			-- local cooldown = Ability:GetCooldownTimeRemaining()
			local abilityName = Ability:GetAbilityName()
			if abilityTable[abilityName] then
				local LstCooldownTime = abilityTable[abilityName][1]
				-- if LstCooldownTime<cooldown then
					Ability:EndCooldown()
					Ability:StartCooldown(LstCooldownTime)
				-- end
			end
		end
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/time_drain/unlock3/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt( nFXIndex, 0,parent, PATTACH_POINT_FOLLOW, "attach_hitloc",parent:GetAbsOrigin(), true )
	-- ParticleManager:SetParticleControlEnt( nFXIndex,1,parent, PATTACH_POINT_FOLLOW, "attach_hitloc",parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt(nFXIndex, 2, parent, PATTACH_CUSTOMORIGIN, "attach_hitloc", parent:GetAbsOrigin(), true)
	-- ParticleManager:SetParticleControl(nFXIndex, 2, Vector(1,0,0))
	ParticleManager:ReleaseParticleIndex(nFXIndex)
	parent:EmitSound("Hero_Weaver.TimeLapse")
	self:SetDuration(120, true)

end