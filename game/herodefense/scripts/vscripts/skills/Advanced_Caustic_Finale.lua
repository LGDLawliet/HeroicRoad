
Advanced_Caustic_Finale = class({})
--特效优化 √
LinkLuaModifier("modifier_Advanced_Caustic_Finale_passive", "skills/Advanced_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Caustic_Finale", "skills/Advanced_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Caustic_Finale_slow", "skills/Advanced_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Caustic_Finale_unlock2_passive", "skills/Advanced_Caustic_Finale", LUA_MODIFIER_MOTION_NONE)

function Advanced_Caustic_Finale:GetIntrinsicModifierName() return "modifier_Advanced_Caustic_Finale_passive" end

function Advanced_Caustic_Finale:UnlockFirstCore(key)
	return true
end
function Advanced_Caustic_Finale:UnlockSecondCore(key)
	return true
end
function Advanced_Caustic_Finale:UnlockThirdCore(key)
	return true
end
function Advanced_Caustic_Finale:CheckKV(key)
	local table = {
		damage = 4,
		bonus_damage = 0.4,
	}
	local value = table[key] or -1
	return value

end
---------------------------------------
modifier_Advanced_Caustic_Finale_passive = advanced_modifier({})

function modifier_Advanced_Caustic_Finale_passive:IsDebuff()			return false end
function modifier_Advanced_Caustic_Finale_passive:IsHidden() 			return true end
function modifier_Advanced_Caustic_Finale_passive:IsPurgable() 			return false end
function modifier_Advanced_Caustic_Finale_passive:IsPurgeException() 	return false end
function modifier_Advanced_Caustic_Finale_passive:RemoveOnDeath() 	return false end

function modifier_Advanced_Caustic_Finale_passive:ADDeclareFunctions()
	return {
	MODIFIER_EVENT_ON_TAKEDAMAGE = {self:GetParent(),nil},
	advanced_MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_Advanced_Caustic_Finale_passive:OnCreated(table)
	self.each_cd = self:GetAbility():GetSpecialValueFor("each_cd")
	self.cd_line = self:GetAbility():GetSpecialValueFor("cd_line")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
	self:SetStackCount(0)
end

function modifier_Advanced_Caustic_Finale_passive:AdvancedGetModifierHealthBonus()
	return math.min(self:GetStackCount(),2000)
end

function modifier_Advanced_Caustic_Finale_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.damage <= 0 then
		return
	end
	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end

	if not self:GetParent():IsIllusion() and not self:GetParent():PassivesDisabled() and keys.attacker == self:GetParent()
	 and not keys.unit:IsBuilding() and not keys.unit:IsOther() and not keys.unit:IsCourier() and
	  not keys.unit:IsMagicImmune() and IsEnemy(keys.attacker, keys.unit) then
	
		local increase = self.each_cd
		local ability =self:GetAbility()
		if not ability.unlock3 then
			if keys.unit:HasModifier("modifier_Advanced_Caustic_Finale") then
				return
			end
		else
			local modifier = keys.unit:FindAllModifiersByName("modifier_Advanced_Caustic_Finale")
			if #modifier>=4 then
				return
			end
		end

		local duration = self.duration
		if keys.inflictor and keys.inflictor== ability then --伤害来源不能是自己
			if ability.unlock1 then
				increase = increase *0.5
				duration = 15
			else
				return
			end
		end
		if  keys.inflictor and  keys.inflictor:GetName()=="Advanced_Burrow_Strike" and keys.inflictor.unlock3 then
			increase = 0.35
		end
		local cooldown = ability:GetCooldownTimeRemaining()
		if cooldown >= self.cd_line then
			return
		end
		if keys.unit:GetHealth()>0 then
			ability:StartCooldown(cooldown+increase)
			keys.unit:AddNewModifier(self:GetParent(), ability, "modifier_Advanced_Caustic_Finale", {duration = duration})
			keys.unit:AddNewModifier(self:GetParent(), ability, "modifier_stunned", {duration = self.stun_duration})
			--新LV15荒漠之咬+
			if self:GetAbility().advanced_level >= 15 then
				local lost_hp = self:GetCaster():GetMaxHealth() - self:GetCaster():GetHealth()
				self:GetCaster():Heal(0.03*lost_hp,self:GetAbility())
			end
		end
		return
	end
end

function modifier_Advanced_Caustic_Finale_passive:OnSummonUnit(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock2 then
			local unit = keys.target
			local caster = self:GetCaster()
			if caster:PassivesDisabled() then
				return
			end
			unit:AddNewModifier(caster, ability, "modifier_Advanced_Caustic_Finale_unlock2_passive", {})
		end	
	end
end

-------------------------------------------------------------------------------------------
modifier_Advanced_Caustic_Finale = advanced_modifier({})

function modifier_Advanced_Caustic_Finale:IsDebuff()			return true end
function modifier_Advanced_Caustic_Finale:IsHidden() 			return false end
function modifier_Advanced_Caustic_Finale:IsPurgable() 			return false end
function modifier_Advanced_Caustic_Finale:IsPurgeException() 	return false end
function modifier_Advanced_Caustic_Finale:GetEffectName() return "particles/units/heroes/hero_sandking/sandking_caustic_finale_debuff.vpcf" end
function modifier_Advanced_Caustic_Finale:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Caustic_Finale:GetAttributes() 
	if IsServer() and self:GetAbility().unlock3 then
		return MODIFIER_ATTRIBUTE_MULTIPLE 
	end
	
end

function modifier_Advanced_Caustic_Finale:OnCreated(keys)
	self.level = self:GetAbility():GetSpecialValueFor("advanced_level")
		if IsServer() then
		self.radius = self:GetAbility():GetSpecialValueFor("radius")
		self.attack_down = self:GetAbility():GetSpecialValueFor("attack_down")*0.01 * self:GetParent():GetBaseDamageMax()
		self:StartIntervalThink(1)
	end
end

function modifier_Advanced_Caustic_Finale:OnIntervalThink()
	local poison = self:GetAbility():GetSpecialValueFor("poison")*self:GetCaster():GetMaxHealth()*0.01
	self:GetParent():Poison(self:GetCaster(),self:GetAbility(),poison)
end

function modifier_Advanced_Caustic_Finale:ADDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH = {nil,self:GetParent()},
		advanced_MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		
	}
end

function modifier_Advanced_Caustic_Finale:Advanced_GetModifierBaseAttack_BonusDamage()
	return -self.attack_down
end


function modifier_Advanced_Caustic_Finale:OnDeath(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if not ability or ability:IsNull() then
			return
		end
		local parent = self:GetParent()
		local level = self:GetAbility().advanced_level
		parent:EmitSound("Ability.SandKing_CausticFinale")
		local damage = self:GetAbility():GetSpecialValueFor("damage") + self:GetAbility():GetSpecialValueFor("bonus_damage")*self:GetCaster():GetMaxHealth()*0.01
		local radius = self.radius
		if ability.unlock3 then
			damage = damage *1.5
			radius = radius *1.5
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), parent:GetAbsOrigin(), nil, (radius), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		self.middle_index = self:GetAbility():GetSpecialValueFor("middle_index")*0.01

		--新LV5即刻腐坏+
		if ability.advanced_level >= 5 then
			self.middle_index = 0.3
		end
		if not ability:GetAutoCastState() then
			for _, enemy in pairs(enemies) do
				local damageTable = {
								victim = enemy,
								attacker = self:GetCaster(),
								damage = damage,
								damage_type = self:GetAbility():GetAbilityDamageType(),
								damage_flags = DOTA_DAMAGE_FLAG_REFLECTION, --Optional.
								ability = self:GetAbility(), --Optional.
								}
				ApplyDamage(damageTable)
			end
		else
			for _, enemy in pairs(enemies) do
				enemy:Poison(self:GetCaster(),self:GetAbility(),damage*self.middle_index)
			end
		end
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_caustic_finale_explode.vpcf", PATTACH_ABSORIGIN, parent)
		ParticleManager:ReleaseParticleIndex(pfx)
		--新LV20食腐
		if self:GetAbility().advanced_level >= 20 then

			local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Caustic_Finale_passive")
			if modifier then
				modifier:SetStackCount(math.min(modifier:GetStackCount()+6,2000))
			end
		end
	end
end









modifier_Advanced_Caustic_Finale_slow = class({})

function modifier_Advanced_Caustic_Finale_slow:IsDebuff()			return true end
function modifier_Advanced_Caustic_Finale_slow:IsHidden() 			return false end
function modifier_Advanced_Caustic_Finale_slow:IsPurgable() 		return true end
function modifier_Advanced_Caustic_Finale_slow:IsPurgeException() 	return true end
function modifier_Advanced_Caustic_Finale_slow:DeclareFunctions() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Caustic_Finale_slow:GetModifierMoveSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("ms_slow")) end








modifier_Advanced_Caustic_Finale_unlock2_passive = class({})

function modifier_Advanced_Caustic_Finale_unlock2_passive:IsDebuff()			return false end
function modifier_Advanced_Caustic_Finale_unlock2_passive:IsHidden() 			return false end
function modifier_Advanced_Caustic_Finale_unlock2_passive:IsPurgable() 			return false end
function modifier_Advanced_Caustic_Finale_unlock2_passive:IsPurgeException() 	return false end
function modifier_Advanced_Caustic_Finale_unlock2_passive:DestroyOnExpire() 	return false end
function modifier_Advanced_Caustic_Finale_unlock2_passive:DeclareFunctions() return {MODIFIER_EVENT_ON_TAKEDAMAGE} end
function modifier_Advanced_Caustic_Finale_unlock2_passive:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.damage<50 then
		return
	end

	if bit.band( keys.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
		return 0
	end
	local parent = self:GetParent()
	if not parent:IsIllusion() and not parent:PassivesDisabled() and keys.attacker == parent
	and not keys.unit:IsBuilding() and not keys.unit:IsOther() and not keys.unit:IsCourier() and not keys.unit:HasModifier("modifier_Advanced_Caustic_Finale") and
	  not keys.unit:IsMagicImmune() and IsEnemy(keys.attacker, keys.unit) then
		if self:GetRemainingTime()<=0 then
			local ability =self:GetAbility()

			if keys.unit:GetHealth()>0 then
				self:SetDuration(3, true)
				keys.unit:AddNewModifier(self:GetCaster(), ability, "modifier_Advanced_Caustic_Finale", {duration = 3})
			
			end
		end

		
		-- self:GetAbility():UseResources(true, true, true,true)
		return
	end

end

