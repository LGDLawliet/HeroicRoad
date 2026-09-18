--特效优化 √
Advanced_Battle_Hunger = class({})

LinkLuaModifier("modifier_Advanced_Battle_Hunger_caster", "skills/Advanced_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Battle_Hunger_enemy", "skills/Advanced_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Battle_Hunger_str_gain", "skills/Advanced_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Battle_Hunger_unlock3", "skills/Advanced_Battle_Hunger", LUA_MODIFIER_MOTION_NONE)
function Advanced_Battle_Hunger:CheckKV(key)
	local table = {
		damage = 3,
		extra_damage = 0.1,
		duration = 0.5,
		speed_bonus = 0.25,



	}
	local value = table[key] or -1
	return value

end

function Advanced_Battle_Hunger:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Battle_Hunger_unlock3",{})
	return true
end
function Advanced_Battle_Hunger:UnlockSecondCore(key)
	self.CoreUnlock = false
	return true
end
function Advanced_Battle_Hunger:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Battle_Hunger_unlock3",{})
	return true
end
function Advanced_Battle_Hunger:GetAOERadius()
	return 500
end

function Advanced_Battle_Hunger:GetBehavior()

	-- local advanced_level = self:GetSpecialValueFor("advanced_level")
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	

	-- if self:GetUnlock(2)==2 then
	-- 	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
	-- end
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_AOE
		end
		
	end

	return self.BaseClass.GetBehavior(self)

end
function Advanced_Battle_Hunger:IsHiddenWhenStolen() 		return false end
function Advanced_Battle_Hunger:IsRefreshable() 			return true end
function Advanced_Battle_Hunger:IsStealable() 				return true end
function Advanced_Battle_Hunger:IsNetherWardStealable() 	return true end

function Advanced_Battle_Hunger:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_2)
	return true
end

function Advanced_Battle_Hunger:OnAbilityPhaseInterrupted() self:GetCaster():RemoveGesture(ACT_DOTA_OVERRIDE_ABILITY_2) end

function Advanced_Battle_Hunger:GetIntrinsicModifierName() return "modifier_Advanced_Battle_Hunger_caster" end

function Advanced_Battle_Hunger:OnSpellStart()
	local target = self:GetCursorTarget()
	if target:TriggerStandardTargetSpell(self) then
		return
	end
	local caster = self:GetCaster()


	local duration = self:GetSpecialValueFor("duration")  --基础持续时间
	if self.unlock2 then
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for i, unit in ipairs(enemies) do

			unit:AddNewModifier(caster, self, "modifier_Advanced_Battle_Hunger_enemy", {duration=duration})
			unit:EmitSound("Hero_Axe.Battle_Hunger")
			if i>=5 then
				return
			end
		end
		return
	end

	target:AddNewModifier(caster, self, "modifier_Advanced_Battle_Hunger_enemy", {duration=duration})
	target:EmitSound("Hero_Axe.Battle_Hunger")
end



function Advanced_Battle_Hunger:AddDebuff(target)
	local caster = self:GetCaster()
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
	local duration = self:GetSpecialValueFor("duration")  --基础持续时间
	local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
	target:AddNewModifier(caster, self, "modifier_Advanced_Battle_Hunger_enemy", {duration=duration*StatusResistance})
	target:EmitSound("Hero_Axe.Battle_Hunger")
end


modifier_Advanced_Battle_Hunger_caster =advanced_modifier({})

function modifier_Advanced_Battle_Hunger_caster:IsDebuff()				return false end
function modifier_Advanced_Battle_Hunger_caster:IsPurgable() 			return false end
function modifier_Advanced_Battle_Hunger_caster:IsPurgeException() 		return false end
function modifier_Advanced_Battle_Hunger_caster:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_Advanced_Battle_Hunger_caster:OnCreated()
	self.parent = self:GetParent()
	self.regen = self:GetAbility():GetSpecialValueFor("regen")*0.01
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("outgoing")
	self.advanced_level = 1
	self:StartIntervalThink(2)
end

function modifier_Advanced_Battle_Hunger_caster:OnIntervalThink()
	local level = self:GetAbility():GetSpecialValueFor("advanced_level")
	if level>=5 then
		self.regen = 0.025
		if level>=10 then
			self.bonus_damage = 6
			self:StartIntervalThink(-1)
		end
	end
end

function modifier_Advanced_Battle_Hunger_caster:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
}
end

function modifier_Advanced_Battle_Hunger_caster:GetModifierMoveSpeedBonus_Constant() return (self:GetStackCount() * (self:GetAbility():GetSpecialValueFor("speed_bonus"))) end
function modifier_Advanced_Battle_Hunger_caster:AdvancedGetModifierConstantHealthRegen() 
	local losthp = self.parent:GetMaxHealth() - self.parent:GetHealth()
	return (self:GetStackCount() * losthp*self.regen)
end

function modifier_Advanced_Battle_Hunger_caster:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
    }
end
function modifier_Advanced_Battle_Hunger_caster:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return (self:GetStackCount() * self.bonus_damage) 
end





modifier_Advanced_Battle_Hunger_enemy = class({})

function modifier_Advanced_Battle_Hunger_enemy:IsDebuff()				return true end
function modifier_Advanced_Battle_Hunger_enemy:IsPurgable() 			return false end
function modifier_Advanced_Battle_Hunger_enemy:IsPurgeException() 		return true end
function modifier_Advanced_Battle_Hunger_enemy:IsHidden()				return false end
function modifier_Advanced_Battle_Hunger_enemy:GetEffectName() return "particles/units/heroes/hero_axe/axe_battle_hunger.vpcf" end
function modifier_Advanced_Battle_Hunger_enemy:GetEffectAttachType() return PATTACH_OVERHEAD_FOLLOW end
function modifier_Advanced_Battle_Hunger_enemy:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_Battle_Hunger_enemy:ShouldUseOverheadOffset() return true end
function modifier_Advanced_Battle_Hunger_enemy:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_EVENT_ON_DEATH,
} end
function modifier_Advanced_Battle_Hunger_enemy:GetModifierMoveSpeedBonus_Constant() return (0-(self:GetAbility():GetSpecialValueFor("speed_bonus")+0.25*self.advanced_level)) end

function modifier_Advanced_Battle_Hunger_enemy:OnDeath(keys)
	if not IsServer() then
		return
	end
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	--LV20解锁释然
	if self.advanced_level>=20  then	
		if not ability:IsCooldownReady() then
			local newcooldown = ability:GetCooldownTimeRemaining() - 1
			ability:EndCooldown()
			ability:StartCooldown(newcooldown)
		end
	end
	
end

function modifier_Advanced_Battle_Hunger_enemy:OnCreated()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if not IsServer() then
		return 
	end
	-- self.advanced_level = self:GetAbility().advanced_level
	-- self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
	self.dmg = self:GetAbility():GetSpecialValueFor("damage") + self:GetCaster():GetMaxHealth() * ((self:GetAbility():GetSpecialValueFor("extra_damage") )/ 100)
	if self:GetCaster():HasModifier("modifier_Advanced_Battle_Hunger_caster") then
		self:GetCaster():FindModifierByName("modifier_Advanced_Battle_Hunger_caster"):IncrementStackCount()
	end
	self.str_gain = 0
	self:StartIntervalThink(1.0)
	if self:GetAbility().unlock3 then
		self.modifier = self:GetCaster():FindModifierByName("modifier_Advanced_Battle_Hunger_unlock3")
	end
end

-- function modifier_Advanced_Battle_Hunger_enemy:OnRefresh()
-- 	if IsServer() then
-- 		self:SetStackCount(self:GetAbility():GetSpecialValueFor("kill_need"))
-- 	end
-- end

function modifier_Advanced_Battle_Hunger_enemy:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		return
	end
	local parent = self:GetParent()
	if IsNearEnemyFountain(parent:GetAbsOrigin(), caster:GetTeamNumber(), 1100) then
		self:SafeDestroy()
	end
	
	local damageTable = {
							victim = parent,
							attacker =caster,
							damage = self.dmg,
							damage_type = ability:GetAbilityDamageType(),
							damage_flags = DOTA_DAMAGE_FLAG_PROPERTY_FIRE, --Optional.
							ability = ability, --Optional.
							hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
							}
	parent:ApplyMergeDamage(damageTable)
	--LV15解锁愈战愈勇
	if self.advanced_level>=15 then
		caster:AddNewModifier(caster, ability, "modifier_Advanced_Battle_Hunger_str_gain", {duration=10})
		self.str_gain = self.str_gain + 1
	end

	if ability.unlock1 then
		local ability_Advanced_Culling_Blade = caster:FindAbilityByName("Advanced_Culling_Blade")
		if ability_Advanced_Culling_Blade then
			ability_Advanced_Culling_Blade:Battle_Hunger_unlock1_Try(parent)
		end
	end
	if self.modifier then
		self.modifier:SetStackCount(self.modifier:GetStackCount()+2)
	end
end

function modifier_Advanced_Battle_Hunger_enemy:OnDestroy()
	if not IsServer() then
		return 
	end
	local caster = self:GetCaster()
	if caster:HasModifier("modifier_Advanced_Battle_Hunger_caster") then
		caster:FindModifierByName("modifier_Advanced_Battle_Hunger_caster"):DecrementStackCount()
	end
	if caster:HasModifier("modifier_Advanced_Battle_Hunger_str_gain") then
		local modifier = caster:FindModifierByName("modifier_Advanced_Battle_Hunger_str_gain")
		modifier:SetStackCount(modifier:GetStackCount()-self.str_gain)
	end
end









modifier_Advanced_Battle_Hunger_str_gain =class({})

function modifier_Advanced_Battle_Hunger_str_gain:IsDebuff()				return false end
function modifier_Advanced_Battle_Hunger_str_gain:IsPurgable() 			return false end
function modifier_Advanced_Battle_Hunger_str_gain:IsPurgeException() 		return false end
function modifier_Advanced_Battle_Hunger_str_gain:IsHidden()
	if self:GetStackCount() > 0 then
		return false
	end
	return true
end

function modifier_Advanced_Battle_Hunger_str_gain:OnCreated()

	if IsServer() then
		self:IncrementStackCount()
		
	end
end

function modifier_Advanced_Battle_Hunger_str_gain:OnRefresh()

	if IsServer() then
		self:IncrementStackCount()
		
	end
end
function modifier_Advanced_Battle_Hunger_str_gain:DeclareFunctions()
	return {MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
}
end

function modifier_Advanced_Battle_Hunger_str_gain:GetModifierBonusStats_Strength() return (self:GetStackCount()*1) end





modifier_Advanced_Battle_Hunger_unlock3 =advanced_modifier({})

function modifier_Advanced_Battle_Hunger_unlock3:IsDebuff()				return false end
function modifier_Advanced_Battle_Hunger_unlock3:IsPurgable() 			return false end
function modifier_Advanced_Battle_Hunger_unlock3:IsPurgeException() 		return false end
function modifier_Advanced_Battle_Hunger_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Battle_Hunger_unlock3:OnCreated(keys)
	self.bonus = 0
	-- if IsServer() then
		self:StartIntervalThink(1)

	-- end
end
function modifier_Advanced_Battle_Hunger_unlock3:OnIntervalThink()
	local stack = self:GetStackCount()
	if IsServer() then
		self:SetStackCount(stack-math.floor(stack*0.03+2))
	end
	
	stack = self:GetStackCount()
	-- print("stack=="..stack)
	if stack>=700 then
		self.bonus = 240
	elseif stack>=500 then
		self.bonus = 170
	elseif stack>=400 then
		self.bonus = 120
	elseif stack>=300 then
		self.bonus = 80
	elseif stack>=200 then
		self.bonus = 50
	elseif stack>=100 then
		self.bonus = 20
	end
	-- print("self.bonus="..self.bonus)
end


-- function modifier_Advanced_Battle_Hunger_unlock3:DeclareFunctions()
-- 	return {

-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,   --所有伤害加成
		
		

-- 	}
-- end


-- function modifier_Advanced_Battle_Hunger_unlock3:GetModifierTotalDamageOutgoing_Percentage(keys)	
-- 	-- if IsServer() then
-- 	-- 	print("go?"..self.bonus)
-- 	-- end

-- 	return self.bonus
-- end


-- advanced_modifier
function modifier_Advanced_Battle_Hunger_unlock3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }
end
function modifier_Advanced_Battle_Hunger_unlock3:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	return self.bonus
end
