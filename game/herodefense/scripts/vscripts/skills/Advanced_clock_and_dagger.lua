
LinkLuaModifier("modifier_Advanced_clock_and_dagger", "skills/Advanced_clock_and_dagger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_clock_and_dagger_delay", "skills/Advanced_clock_and_dagger", LUA_MODIFIER_MOTION_NONE)
Advanced_clock_and_dagger		= Advanced_clock_and_dagger or class({})
require("internal/timers")
--特效优化 √
function Advanced_clock_and_dagger:GetIntrinsicModifierName()
	return "modifier_Advanced_clock_and_dagger"
end
function Advanced_clock_and_dagger:CheckKV(key)
	local table = {
		backstab_damage_per_agility =0.05,

	}
	local value = table[key] or -1
	return value


end

function Advanced_clock_and_dagger:UnlockFirstCore(key)
	-- if self:GetCaster():GetUnitName()~="npc_dota_hero_rubick" then
	-- 	self.CoreUnlock = false
	-- 	self.unlock1 = false
	-- 	SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
	-- 	return false
	-- end
	return true
end
function Advanced_clock_and_dagger:UnlockSecondCore(key)
	return true
end
function Advanced_clock_and_dagger:UnlockThirdCore(key)
	if not self:GetCaster():HasAbility("heroTalent_npc_dota_hero_riki") then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(self:GetCaster():GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	return true
end


modifier_Advanced_clock_and_dagger	= modifier_Advanced_clock_and_dagger or class({})

function modifier_Advanced_clock_and_dagger:DestroyOnExpire()	return false end
function modifier_Advanced_clock_and_dagger:IsPurgable()		return false end
function modifier_Advanced_clock_and_dagger:IsPurgeException() return false end
function modifier_Advanced_clock_and_dagger:RemoveOnDeath()	return false end

function modifier_Advanced_clock_and_dagger:IsHidden()			return false end
function modifier_Advanced_clock_and_dagger:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end
function modifier_Advanced_clock_and_dagger:OnIntervalThink()
	if self:GetAbility():GetAutoCastState() then
		self:GetAbility():StartCooldown(10)
	end
end


function modifier_Advanced_clock_and_dagger:CheckState()
	if IsClient() then
		return
	end
	local ability = self:GetAbility()
	if ability:IsCooldownReady() and not self:GetParent():PassivesDisabled()  then
		if not ability.unlock1 then
			return {
				[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
			}
		end
		
	end
	return
end

function modifier_Advanced_clock_and_dagger:DeclareFunctions()
	return {

		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		

	}
end



function modifier_Advanced_clock_and_dagger:GetModifierPreAttack_BonusDamage(keys)
	if IsClient() then
		return
	end
	if keys.attacker == self:GetParent() and keys.target then	
		if self:GetParent():IsRangedAttacker() or self:GetParent():PassivesDisabled() or keys.target:IsBuilding() or  keys.target:IsOther() then
			self:SetStackCount(0)
			self.bBackstab = false
			return
		end
		local ability = self:GetAbility()
		if self.unlock3_attack then
			self.bBackstab = true
			local stack = self:GetStackCount()
			local index = stack*0.05+1
			local bonus_damage = self:GetParent():GetAgility() * (ability:GetSpecialValueFor("backstab_damage_per_agility")*index)
			if stack>=15 and self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
				bonus_damage = bonus_damage * 2
			end
			return bonus_damage
		end
		-- print("angle".. math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(self:GetParent():GetForwardVector()).y)))
		-- print("angle2..".. math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(CalculateDirection(keys.target:GetAbsOrigin(),self:GetParent():GetAbsOrigin())).y)))
		if ability.unlock1 or  math.abs(AngleDiff(VectorToAngles(keys.target:GetForwardVector()).y, VectorToAngles(CalculateDirection(keys.target:GetAbsOrigin(),self:GetParent():GetAbsOrigin())).y)) <= ability:GetSpecialValueFor("back_angle")*0.5 then

			self.bBackstab = true
			if ability.unlock2 then
				self:SetStackCount(math.min(self:GetStackCount()+1,100))
			else
				self:SetStackCount(math.min(self:GetStackCount()+1,30))
			end
			
			if ability.unlock3 and 15>=RandomInt(1, 100) then
				self:ApplyUnlock3Attack(keys.target)
			end
			
			if not self:GetParent():IsIllusion() then
				local stack = self:GetStackCount()
				local index = stack*0.05+1
				local bonus_damage = self:GetParent():GetAgility() * (ability:GetSpecialValueFor("backstab_damage_per_agility")*index)
				if ability.advanced_level>=5 and stack>=15 and self:GetCaster():GetRandomEffect(20,INT_TYPE,1) >=RandomInt(1, 100) then
					bonus_damage = bonus_damage * 2
				end
				return bonus_damage
			end
		else
			if ability:GetAutoCastState() then
				if ability.unlock2 then
					self:SetStackCount(math.floor(self:GetStackCount()*0.7))
				else
					self:SetStackCount(0)
				end
				
				self.bBackstab = false
				local index = 0.3
				if ability.advanced_level>=10 then
					index = 0.5
				end
				return self:GetParent():GetAgility() * (ability:GetSpecialValueFor("backstab_damage_per_agility")*index)
			end
			if ability.unlock2 then
				self:SetStackCount(math.floor(self:GetStackCount()*0.7))
			else
				self:SetStackCount(0)
			end
			self.bBackstab = false
		end
	end
end
function modifier_Advanced_clock_and_dagger:ApplyUnlock3Attack(target)
	local caster = self:GetCaster()
	if caster==target then
		return
	end
	Timers:CreateTimer(0.1, function()
		if not self or self:IsNull() then
			return
		end
		if not target or target:IsNull() or not target:IsAlive() then
			return
		end
		self.unlock3_attack = true
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 0,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		caster:PerformAttack(target, false, true, true, false, true, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		self.unlock3_attack = false
	end)
	Timers:CreateTimer(0.2, function()
		if not self or self:IsNull() then
			return
		end
		if not target or target:IsNull() or not target:IsAlive() then
			return
		end
		self.unlock3_attack = true
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =0,
			iDisableSplit = 0,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
		caster:PerformAttack(target, false, true, true, false, true, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end
		self.unlock3_attack = false
	end)
end
function modifier_Advanced_clock_and_dagger:OnAttackLanded(keys)
	if IsClient() then
		return
	end
	if keys.attacker == self:GetParent() then
		if self.bBackstab then
			keys.target:EmitSound("Hero_Riki.Backstab")
			
			self.backstab_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_riki/riki_backstab.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)
			ParticleManager:SetParticleControlEnt(self.backstab_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(self.backstab_particle)
		end
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		if ability.advanced_level>=15 then
			if ability.advanced_level>=20 then
				caster:AddNewModifier(caster, ability, "modifier_Advanced_clock_and_dagger_delay", {duration=2}) 
			else
				
				local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, 
				DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for _, unit in ipairs(units) do
					if unit~=caster then
						return
					end
				end
				ability:StartCooldown(ability:GetSpecialValueFor("delay"))
			end
			
		else
			ability:StartCooldown(ability:GetSpecialValueFor("delay"))
		end
		
	
	end
end

modifier_Advanced_clock_and_dagger_delay	= modifier_Advanced_clock_and_dagger_delay or class({})

-- function modifier_Advanced_clock_and_dagger_delay:DestroyOnExpire()	return false end
function modifier_Advanced_clock_and_dagger_delay:IsPurgable()		return false end
function modifier_Advanced_clock_and_dagger_delay:IsPurgeException() return false end
function modifier_Advanced_clock_and_dagger_delay:RemoveOnDeath()	return false end
function modifier_Advanced_clock_and_dagger_delay:OnDestroy(keys)
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 400, 
		DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		for _, unit in ipairs(units) do
			if unit~=caster then
				return
			end
		end
		ability:StartCooldown(ability:GetSpecialValueFor("delay"))
	end
end