--特效优化 √
Advanced_overcharge = class({})
-- LinkLuaModifier("modifier_Advanced_overcharge_arua", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_arua_effect", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_overcharge_active", "skills/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_active", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_effect", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_effect2", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_active_standby", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_debuff", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)
-- LinkLuaModifier("modifier_Advanced_overcharge_thinker", "items/Advanced_overcharge", LUA_MODIFIER_MOTION_NONE)

function Advanced_overcharge:CheckKV(key)
	local table = {

	


		bonus_attack_speed = 4,
		bonus_HPRegenAmplify_Percentage = 0.01,




	}
	local value = table[key] or -1
	return value

end

function Advanced_overcharge:UnlockFirstCore(key)
    -- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
function Advanced_overcharge:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_overcharge:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_Blood_Sacrifice_unlock3",{})
	return true
end
function Advanced_overcharge:Spawn()
	-- self.modifier_table ={}
end
function Advanced_overcharge:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		
		
	end


	return self.BaseClass.GetBehavior(self)
	
end

function Advanced_overcharge:OnSpellStart()

	local caster    =   self:GetCaster()
	local gain = caster:GetModifierDurationGainIndex(1)
	local duration = self:GetSpecialValueFor("duration")*gain
	if self.unlock1 then
		duration = duration * 1.5
		self:EndCooldown()
	end
	local modifier = caster:FindModifierByName("modifier_Advanced_overcharge_active")
	if modifier then
		modifier:SafeDestroy()
	end
	
	if self.unlock3 then
		local heroes = GetAllRealHeroes()
        for _, unit in pairs(heroes) do
			local modifier = unit:FindModifierByNameAndCaster("modifier_Advanced_overcharge_active",caster)
			if modifier then
				modifier:SafeDestroy()
			end
        end
		-- for _, mod in ipairs(self.modifier_table) do
		-- 	if not mod:IsNull() then
		-- 		mod:SafeDestroy()
		-- 	end
		-- end
		self.modifier_table = {}
		duration = -1
		local modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration =duration})
		-- table.insert(self.modifier_table,modifier)
		-- self.modifier_table
	else
		local modifier = caster:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration = duration})
	end
	--------------------随机选取一个友军施加状态
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
	   DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	--LV15解锁广域强化
	if self.advanced_level>=15 and not self.unlock3 then
		for _, unit in pairs(units) do
			if unit~=caster then
	
				local modifier = unit:FindModifierByName("modifier_Advanced_overcharge_active")
				if modifier then
					modifier:SafeDestroy()
				end
				local modifier = unit:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration = duration})
			end
			end

		if #units>=2 then
			return
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
		for _, unit in pairs(units) do
			local buffs = unit:FindAllModifiersByName("modifier_Advanced_overcharge_active")
			if  #buffs == 0 then
				unit:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration = duration})
				return
			end
		end
	else
		--未达到15级
		for _, unit in pairs(units) do
			if not unit:HasModifier("modifier_Advanced_overcharge_active") then
				local modifier = unit:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration = duration})
				-- if self.unlock3 then
				-- 	table.insert(self.modifier_table,modifier)
				-- end
				return
			end
		end
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil,  1000,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)  
			
		for _, unit in pairs(units) do
			local buffs = unit:FindAllModifiersByName("modifier_Advanced_overcharge_active")
			if  #buffs == 0 then

				unit:AddNewModifier(caster, self, "modifier_Advanced_overcharge_active", {duration = duration})
				return
			end
		end
	end

end



function Advanced_overcharge:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	local caster = self:GetCaster()
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
	caster:PerformAttack(target, false, true, true, false, false, false, true)
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

end






modifier_Advanced_overcharge_active = advanced_modifier({})

function modifier_Advanced_overcharge_active:IsDebuff() return false end
function modifier_Advanced_overcharge_active:IsHidden() return false end
function modifier_Advanced_overcharge_active:IsPurgable() return false end
function modifier_Advanced_overcharge_active:IsPurgeException() 
	if self:GetUnlock(3)==3 then
		return false
	end
	return true 
end
function modifier_Advanced_overcharge_active:RemoveOnDeath() 
	if self:GetUnlock(3)==3 then
		return false
	end
	return true 
end


function modifier_Advanced_overcharge_active:OnCreated(keys)


	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
 
	self.overcharge_pfx 		= ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_overcharge.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	self.bonus_attack_speed = ability:GetSpecialValueFor("bonus_attack_speed")
	self.bonus_HPRegenAmplify_Percentage = ability:GetSpecialValueFor("bonus_HPRegenAmplify_Percentage")
	self.bonus_str = 0
    self.bonus_agi = 0
	self.bonus_int = 0
	self.bonus_str_lv20 = 0
	self.bonus_agi_lv20 = 0
	self.bonus_int_lv20 = 0
	local bonus_index = 0.2
	self.Manacost = 25
	self.SpellAmplify = 20
	--LV5解锁能量提升+
	if advanced_level>=5 then
		bonus_index = 0.3
	end
	--LV10解锁能量引导+
	if advanced_level>=10 then
		self.Manacost = self.Manacost *1.5
		self.SpellAmplify = self.SpellAmplify *1.5
	end



	local parent = self:GetParent()
	if parent:IsRealHero() then
		self.bonus_str = parent:GetStrength()*bonus_index
		self.bonus_agi = parent:GetAgility()*bonus_index
		self.bonus_int = parent:GetIntellect(false)*bonus_index
		--LV20解锁能力超提升
		if advanced_level>=20 and caster~=parent then
			self.bonus_str_lv20 = caster:GetStrength()*0.3
			self.bonus_agi_lv20 = caster:GetAgility()*0.3
			self.bonus_int_lv20 = caster:GetIntellect(false)*0.3
		end
	end
	if IsServer() then
		self:StartIntervalThink(1)
		self:GetParent():EmitSound("Hero_Wisp.Overcharge")
		self.time = GameRules:GetGameTime()
		self:SetStackCount(0)
		if ability:GetAutoCastState() then
			self:SetStackCount(3)
			ability:SetActivated(false)
		end
	end
end
function modifier_Advanced_overcharge_active:OnIntervalThink()
	if IsServer() then
		if not self:GetAbility() then
			self:SafeDestroy()
		end
	end
end

function modifier_Advanced_overcharge_active:OnDestroy(keys)
    ParticleManager:DestroyParticle(self.overcharge_pfx, false)
	if IsServer() then
		if self:GetCaster()==self:GetParent() then
			local ability = self:GetAbility()
			if not ability:IsActivated() then
				ability:SetActivated(true)
				ability:StartCooldown(ability:GetCooldown(ability:GetLevel())* self:GetParent():GetCooldownReduction()*3)
			end
		end
		self:GetParent():StopSound("Hero_Wisp.Overcharge")
	end

end
function modifier_Advanced_overcharge_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,       --攻击速度
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,            --技能魔法消耗
	}
	if self:GetAbility():GetUnlock(1)==1 then
		table.insert(funcs,MODIFIER_EVENT_ON_ATTACK_LANDED)
	end
	return funcs
end


function modifier_Advanced_overcharge_active:AdvancedGetModifierConstantHealthRegenPercentage()
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.bonus_HPRegenAmplify_Percentage *stack
	end 
	return self.bonus_HPRegenAmplify_Percentage 
end

function modifier_Advanced_overcharge_active:GetModifierAttackSpeedBonus_Constant() 
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.bonus_attack_speed *stack
	end 	
	return self.bonus_attack_speed 
end

function modifier_Advanced_overcharge_active:GetModifierBonusStats_Strength()	
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.bonus_str *stack+self.bonus_str_lv20
	end
	return self.bonus_str +self.bonus_str_lv20
end
function modifier_Advanced_overcharge_active:GetModifierBonusStats_Intellect()	
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.bonus_int *stack+self.bonus_int_lv20
	end 
	return self.bonus_int +self.bonus_int_lv20
end
function modifier_Advanced_overcharge_active:GetModifierBonusStats_Agility()	
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.bonus_agi *stack+self.bonus_agi_lv20
	end 
	return self.bonus_agi +self.bonus_agi_lv20
end
function modifier_Advanced_overcharge_active:GetModifierPercentageManacost()	
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.Manacost *stack
	end 
	return self.Manacost 
end
function modifier_Advanced_overcharge_active:Advanced_GetModifierSpellAmplifyBonus()	
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.SpellAmplify *stack
	end 
	return self.SpellAmplify 
end


function modifier_Advanced_overcharge_active:OnAttackLanded(keys)
	if IsServer() then

		local parent = self:GetParent()
		if keys.attacker == parent then
			local caster = self:GetCaster()
			if caster~=parent and GameRules:GetGameTime()>=self.time  then

				self.time  = GameRules:GetGameTime() + 1/caster:GetAttacksPerSecond(false)
				if caster:IsRangedAttacker() then
					local info = 
					{
						Target = keys.target,
						Source = caster,
						Ability = self:GetAbility(),	
						EffectName = caster:GetRangedProjectileName(),
						iMoveSpeed = caster:GetProjectileSpeed(),
						-- sourceloc = pos,
						-- caster:GetProjectileSpeed()
						-- vSourceLoc = pos,
						bDrawsOnMinimap = false,  --？？
						bDodgeable = true,   --可躲闪
						bIsAttack = false,   --攻击效果
						bVisibleToEnemies = true,  --对敌人可视
						bReplaceExisting = false, --替换现有的
						flExpireTime = GameRules:GetGameTime() + 10, --存在时间
						bProvidesVision = false, --提供视野
						ExtraData = {}   --额外的数据
					}
					ProjectileManager:CreateTrackingProjectile(info)
				else
					local modifier_keys = {
						duration = 0.1,
						iSpecialAttack = 1,
						iDisableApplyModifier = 0,
						iDisableCleave =1,
						iDisableSplit = 1,
				
					}
					local attackEffectRecord = caster:AddAttackEffectModifier( self,modifier_keys)
					caster:PerformAttack(keys.target, false, true, true, false, false, false, true)
					if IsValid(attackEffectRecord) then
						attackEffectRecord:Destroy()
					end
				end
			end

		end
	end
end


function modifier_Advanced_overcharge_active:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		advanced_MODIFIER_PROPERTY_SPELL_AMPLIFY_BONUS,


    }
end
