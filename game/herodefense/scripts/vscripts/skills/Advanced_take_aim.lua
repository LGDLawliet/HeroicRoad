Advanced_take_aim = class({})
-- LinkLuaModifier("modifier_Advanced_take_aim_arua", "skills/Advanced_take_aim", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_take_aim_arua_effect", "skills/Advanced_take_aim", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_take_aim", "skills/Advanced_take_aim", LUA_MODIFIER_MOTION_NONE)


-- Item Passive
-- require('internal/timers')   --计时器功能

function Advanced_take_aim:CheckKV(key)
	local table = {
		bonus_attack_range=5,


	}
	local value = table[key] or -1
	return value

end

function Advanced_take_aim:UnlockFirstCore(key)
	return true
end
function Advanced_take_aim:UnlockSecondCore(key)

	return true
end
function Advanced_take_aim:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_laguna_blade_passive",{})
	return true
end


function Advanced_take_aim:GetIntrinsicModifierName()
	return "modifier_Advanced_take_aim"
end

function Advanced_take_aim:GetCooldown(iLevel)
	local advanced_level =self:GetSpecialValueFor("advanced_level")
	--LV20解锁狙击
	if advanced_level>=20 then
		if self:GetUnlock(1)==1 then
			return 0.24
		end
		return 0.5
	end
end


modifier_Advanced_take_aim = advanced_modifier({})

function modifier_Advanced_take_aim:IsDebuff() return false end
function modifier_Advanced_take_aim:IsHidden() return false end
function modifier_Advanced_take_aim:IsPurgable() 		return false end
function modifier_Advanced_take_aim:IsPurgeException() 	return false end
function modifier_Advanced_take_aim:RemoveOnDeath()  return false end
function modifier_Advanced_take_aim:CheckState()
	local state = {}

	local chance = self:GetAbility():GetSpecialValueFor("no_avoid")
	--LV10解锁集中+
	if self.advanced_level>=10 then
		chance = 99
	end
	if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) and self:GetCaster():IsRangedAttacker() then   --几率穿刺（无视闪避）
		state = {[MODIFIER_STATE_CANNOT_MISS] = true}
	end

	return state
end


function modifier_Advanced_take_aim:OnCreated(keys)


	local ability = self:GetAbility()

	self.advanced_level = 1
	self.zen_syuu_tyuu = false
	self:StartIntervalThink(1)
	self.damage = ability:GetSpecialValueFor("bonus_damage")
	if IsServer() then
		self.timer = GameRules:GetGameTime()
	end


end
function modifier_Advanced_take_aim:OnIntervalThink()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
end
function modifier_Advanced_take_aim:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK,
	
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL,

	}
end
function modifier_Advanced_take_aim:GetModifierPreAttack_BonusDamage() 
	return 30 * self:GetStackCount()
end
function modifier_Advanced_take_aim:Advanced_GetModifierAttackRangeBonus()
	if  self:GetCaster():IsRangedAttacker() then
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus_attack_range")
		--LV20解锁狙击
		if IsServer()and  self.advanced_level>=20 and self:GetAbility():IsCooldownReady() then
			if self:GetAbility().unlock1 then
				return self.bonus+2000
			end
			return self.bonus+1000
		end
		return self.bonus
	else
		return  0 
	end
end
function modifier_Advanced_take_aim:GetModifierBonusStats_Strength()	return self.zen_syuu_tyuu and 30 or 0 end
function modifier_Advanced_take_aim:GetModifierBonusStats_Intellect()	return self.zen_syuu_tyuu and 30 or 0 end
function modifier_Advanced_take_aim:GetModifierBonusStats_Agility()	return self.zen_syuu_tyuu and 30 or 0 end
-- function modifier_Advanced_take_aim:GetModifierTotalDamageOutgoing_Percentage()	return self.zen_syuu_tyuu and 10 or 0 end
function modifier_Advanced_take_aim:OnAttack(keys)
	

		if keys.attacker == self:GetParent()then
			local ability = self:GetAbility()
			if IsServer() then
				if ability.advanced_level>=20 and ability:IsCooldownReady() then

					if ability.unlock1 and self:GetStackCount()>=20 then
						ability:StartCooldown(0.12)
					else
						ability:UseResources(true, true, true, true)
						if ability.unlock3 and self.timer <= GameRules:GetGameTime() then
							if IsEnemy(keys.target,keys.attacker) and keys.target~=self.nowtarget  then
								local ability = keys.attacker:FindAbilityByName("Advanced_assassinate")
								if ability then
									keys.attacker:SetCursorCastTarget(keys.target)
									ability:OnSpellStart()
								end
								self.timer = GameRules:GetGameTime() +1.5
							end
						
						end
					end
				
				end
	
				-- 专注
				local max = 5
				if ability.advanced_level>=5 then
					max = 10
				end
				if ability.unlock2 then
					max = 50
				end
				if self.nowtarget and keys.target==self.nowtarget  then
					if self:GetStackCount()<max then
						self:IncrementStackCount()
					end
					--LV5解锁专注+
					if self:GetStackCount()<max and self.advanced_level>=5 then
						self:IncrementStackCount()
					end
	
				else
					self.nowtarget=keys.target
					self:SetStackCount(math.max(self:GetStackCount()-2,0))
	
				end
	
				--LV15解锁全集中
				if self.advanced_level>=15 and self:GetStackCount()>=20 then
					self.zen_syuu_tyuu = true
				else
					self.zen_syuu_tyuu = false
				end
	
			-- else
			-- 	print("check")
			-- 	if ability:GetSpecialValueFor("advanced_level")>=15 and self:GetStackCount()>=20 then
			-- 		print("ok")
			-- 		self.zen_syuu_tyuu = true
			-- 	else
			-- 		self.zen_syuu_tyuu = false
			-- 	end
			end
			
			

		end
	
end


function modifier_Advanced_take_aim:GetModifierProcAttack_BonusDamage_Physical( params )
	if IsServer() then
		-- get target
		local target = params.target if target==nil then target = params.unit end
		if not self:GetAbility().unlock2 then
			return
		end
		if target:GetTeamNumber()==self:GetParent():GetTeamNumber() then
			return 0
		end
		if not self:GetParent():IsRealHero() then
			return false
		end

		local stack = self:GetStackCount()
		
		local bonus_damage = self:GetCaster():GetDamageMax()*(stack*0.01)

		return bonus_damage
	end
end

-- advanced_modifier
function modifier_Advanced_take_aim:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
    }

	return funcs

end
--标记 最终伤害加成
function modifier_Advanced_take_aim:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return  self.zen_syuu_tyuu and 10 or 0
end

