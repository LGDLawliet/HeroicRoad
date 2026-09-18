--特效优化 √
Advanced_Shallow_Grave = class({})

LinkLuaModifier("modifier_Advanced_Shallow_Grave", "skills/Advanced_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Shallow_Grave_bonus", "skills/Advanced_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Shallow_Grave_unlock2_bonus", "skills/Advanced_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Shallow_Grave_unlock3_delay", "skills/Advanced_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)

LinkLuaModifier("modifier_Advanced_Shallow_Grave_unlock3_bonus", "skills/Advanced_Shallow_Grave", LUA_MODIFIER_MOTION_NONE)
require('internal/timers')   --计时器功能

function Advanced_Shallow_Grave:CheckKV(key)
	local table = {
		duration=0.1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Shallow_Grave:UnlockFirstCore(key)
	return true
end
function Advanced_Shallow_Grave:UnlockSecondCore(key)

	return true
end
function Advanced_Shallow_Grave:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_laguna_blade_passive",{})
	return true
end

function Advanced_Shallow_Grave:IsHiddenWhenStolen() 	return false end
function Advanced_Shallow_Grave:IsRefreshable() 			return false  end
function Advanced_Shallow_Grave:IsStealable() 			return true  end
function Advanced_Shallow_Grave:IsNetherWardStealable()	return true end

function Advanced_Shallow_Grave:GetCastRange(vLocation, hTarget) return self:GetSpecialValueFor("cast_range") end
function Advanced_Shallow_Grave:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET+DOTA_ABILITY_BEHAVIOR_AOE
		end
		
	end
	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	
end
function Advanced_Shallow_Grave:GetAOERadius()
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return 500
		end
		
	end
	return 0
end

function Advanced_Shallow_Grave:GetCooldown(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	--LV20解锁快速冷却
	if advanced_level>=20 then
		return 30
	end
	return 45
end

function Advanced_Shallow_Grave:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	if self.unlock1 then
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
		local unit_table = {}
		local ex_count = 3
		table.insert(unit_table,caster)
		if caster~=target then
			table.insert(unit_table,target)
			ex_count = ex_count - 1
		end
		for _, unit in ipairs(units) do
			if not IsInTable(unit,unit_table) then
				table.insert(unit_table,unit)
				ex_count = ex_count - 1
			end
			if ex_count<=0 then
				break
			end
		end

		for _, unit in ipairs(unit_table) do
			unit:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave", {duration = duration})
			if unit~=caster then
				unit:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave_bonus", {duration = duration})
			end
		end

	else
		if self.unlock3 then
			duration = duration * 2
			local modifier = target:FindModifierByName("modifier_Advanced_Shallow_Grave")
			if modifier then
				modifier:SafeDestroy()
			end
		end
		target:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave", {duration = duration})
		if target ~= caster then
			target:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave_bonus", {duration = duration})
		end
		if self.unlock2 then
			target:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave_unlock2_bonus", {duration = duration+5})


			
		end
	end

	--群体效果
	-- local enemies = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("rd"), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- for _,target in pairs(enemies) do
	-- 	target:AddNewModifier(caster, self, "modifier_Advanced_Shallow_Grave", {duration = self:GetSpecialValueFor("duration")})
	-- end

end


function Advanced_Shallow_Grave:TriggerUnlock3(time,unit)
	if not unit.shadoow_grave_unlock3 then
		unit.shadoow_grave_unlock3  = 0
	end
	if unit.shadoow_grave_unlock3 >=20 then
		return
	end
	if  not Game_State:IsInBattle() then
		return
	end
	Timers:CreateTimer(time+0.1, function()
		if unit:IsAlive() then
			if unit.shadoow_grave_unlock3 >=20 then
				return
			end
			local gold = math.floor(unit:GetGold()/5000)
			if gold<=0 then
				return
			end
			local bonus = math.min(gold,10)
			unit.shadoow_grave_unlock3  = unit.shadoow_grave_unlock3  + 1
			unit:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Shallow_Grave_unlock3_bonus", {bonus = bonus})
			local pfx = ParticleManager:CreateParticle("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf", PATTACH_CUSTOMORIGIN, unit)
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
		end
	end)
	
end




modifier_Advanced_Shallow_Grave = class({})

function modifier_Advanced_Shallow_Grave:IsDebuff()				return false end
function modifier_Advanced_Shallow_Grave:IsHidden() 			return false end
function modifier_Advanced_Shallow_Grave:IsPurgable() 			return false end
function modifier_Advanced_Shallow_Grave:IsPurgeException() 	return false end
function modifier_Advanced_Shallow_Grave:GetEffectName() return "particles/econ/items/dazzle/dazzle_ti6/dazzle_ti6_shallow_grave.vpcf" end
function modifier_Advanced_Shallow_Grave:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_Advanced_Shallow_Grave:OnCreated()
	if IsServer() then
		EmitSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
		self.damage_change = self:GetAbility():GetSpecialValueFor("change_damage")
		self.radius = self:GetAbility():GetSpecialValueFor("damage_radius")
		--LV5解锁送葬+
		if self:GetAbility().advanced_level>=5 then
			self.radius = self.radius +200
			self.damage_change = 0.5
		end
		self.min_health = 1
		--LV15解锁能量维续
		if self:GetAbility().advanced_level>=15 then
			self.min_health = self:GetParent():GetMaxHealth()*0.15
		end

		self.cause_death = false
	end
end

function modifier_Advanced_Shallow_Grave:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_MIN_HEALTH,
	}

	return funcs
	
end
function modifier_Advanced_Shallow_Grave:GetMinHealth() return self.min_health end
function modifier_Advanced_Shallow_Grave:OnTakeDamage(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent() or (self:GetParent():GetHealth()-self.min_health)-keys.damage > 1 then
		return
	end

	local damage =(keys.damage-(self:GetParent():GetHealth()-self.min_health))  *self.damage_change
	damage = damage - damage%1
	self:SetStackCount(self:GetStackCount() + damage)

	if self:GetAbility().unlock3 then
		
		self.cause_death = true
	end
	--04_27 add by MysticBug
	-- if self:GetCaster():HasScepter() and self:GetStackCount() >= (self:GetCaster():GetMaxHealth()*2) then 
	-- 	self:Destroy()
	-- end
end

function modifier_Advanced_Shallow_Grave:OnDestroy()
	if IsServer() then
		StopSoundOn("Hero_Dazzle.Shallow_Grave", self:GetParent())
		-- self:GetParent():Heal(self:GetStackCount(), self:GetCaster())
		-- SendOverheadEventMessage(nil, OVERHEAD_ALERT_HEAL, self:GetParent(), self:GetStackCount(), nil)
		local caster = self:GetCaster()
		local unit = self:GetParent()
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(), unit:GetAbsOrigin(), nil, self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		if #enemies> 0 and self:GetStackCount() >= 1 then
			local pfx = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/econ/items/lanaya/lanaya_epit_trap/templar_assassin_epit_trap_explode.vpcf", caster), PATTACH_CUSTOMORIGIN, unit)
			ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:SetParticleControlEnt(pfx, 1, unit, PATTACH_CUSTOMORIGIN_FOLLOW, nil, unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(pfx)
			local damage = math.min(self:GetStackCount(),caster:GetMaxMana()*20)
			for _,target in pairs(enemies) do
				local damageTable = {
					attacker = caster,
					victim = target,
					damage = damage,
					damage_type = self:GetAbility():GetAbilityDamageType(),
					ability = self:GetAbility()
				}
				ApplyDamage(damageTable) 
			end
		end
		
		if self.cause_death then
			local parent = self:GetParent()
			local ability = self:GetAbility()
			parent:AddNewModifier(caster, ability, "modifier_Advanced_Shallow_Grave_unlock3_delay", {duration = 10})
			-- TrueKill(caster, parent, ability)
			Timers:CreateTimer(0.01, function()
				TrueKill(caster, parent, ability)
			end)
			
		end
	end
end


modifier_Advanced_Shallow_Grave_bonus = class({})

function modifier_Advanced_Shallow_Grave_bonus:IsDebuff()				return false end
function modifier_Advanced_Shallow_Grave_bonus:IsHidden() 			return false end
function modifier_Advanced_Shallow_Grave_bonus:IsPurgable() 			return false end
function modifier_Advanced_Shallow_Grave_bonus:IsPurgeException() 	return false end
function modifier_Advanced_Shallow_Grave_bonus:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Shallow_Grave_bonus:OnCreated()
	if IsServer() then
		self.caster = self:GetAbility():GetCaster()
		self.bonus = self:GetAbility():GetSpecialValueFor("bonus")
		--LV10解锁灵葬+
		if self:GetAbility().advanced_level>=10 then
			self.bonus = 0.5
		end
		self.bonusa = self.bonus* self.caster:GetAgility()
		self.bonusi = self.bonus*self.caster:GetIntellect(false)
		self.bonuss = self.bonus*self.caster:GetStrength()
	end
end


function modifier_Advanced_Shallow_Grave_bonus:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
end
function modifier_Advanced_Shallow_Grave_bonus:GetModifierBonusStats_Agility()   return self.bonusa end
function modifier_Advanced_Shallow_Grave_bonus:GetModifierBonusStats_Intellect() return self.bonusi end
function modifier_Advanced_Shallow_Grave_bonus:GetModifierBonusStats_Strength()  return self.bonuss end

function modifier_Advanced_Shallow_Grave_bonus:KillPre() self:Destroy() end  








modifier_Advanced_Shallow_Grave_unlock2_bonus = advanced_modifier({})

function modifier_Advanced_Shallow_Grave_unlock2_bonus:IsDebuff()				return false end
function modifier_Advanced_Shallow_Grave_unlock2_bonus:IsHidden() 			return false end
function modifier_Advanced_Shallow_Grave_unlock2_bonus:IsPurgable() 			return false end
function modifier_Advanced_Shallow_Grave_unlock2_bonus:IsPurgeException() 	return false end


-- function modifier_Advanced_Shallow_Grave_unlock2_bonus:DeclareFunctions()
-- 	local funcs = {
-- 		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
-- 	}
	
-- 	return funcs
	
-- end

-- function modifier_Advanced_Shallow_Grave_unlock2_bonus:GetModifierTotalDamageOutgoing_Percentage(keys)
-- 	local health_percent = (100-self:GetParent():GetHealthPercent())/10
-- 	health_percent = math.floor(health_percent)
-- 	return health_percent*20
-- end




-- advanced_modifier
function modifier_Advanced_Shallow_Grave_unlock2_bonus:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
    }

	return funcs

end
-- 标记 改为最终伤害
function modifier_Advanced_Shallow_Grave_unlock2_bonus:Advanced_GetModifierTotalDamageOutgoing_Percentage(keys)
	local health_percent = (100-self:GetParent():GetHealthPercent())/10
	health_percent = math.floor(health_percent)
	return health_percent*20
end





modifier_Advanced_Shallow_Grave_unlock3_delay = class({})

function modifier_Advanced_Shallow_Grave_unlock3_delay:IsDebuff()				return false end
function modifier_Advanced_Shallow_Grave_unlock3_delay:IsHidden() 			return false end
function modifier_Advanced_Shallow_Grave_unlock3_delay:IsPurgable() 			return false end
function modifier_Advanced_Shallow_Grave_unlock3_delay:IsPurgeException() 	return false end
function modifier_Advanced_Shallow_Grave_unlock3_delay:RemoveOnDeath() return false end











modifier_Advanced_Shallow_Grave_unlock3_bonus = class({})

function modifier_Advanced_Shallow_Grave_unlock3_bonus:IsDebuff()				return false end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:IsHidden() 			return false end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:IsPurgable() 			return false end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:IsPurgeException() 	return false end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:RemoveOnDeath() return false end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.bonus)
	end
end

function modifier_Advanced_Shallow_Grave_unlock3_bonus:OnRefresh(keys)
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+ keys.bonus)
	end
end


function modifier_Advanced_Shallow_Grave_unlock3_bonus:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,             --力量
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,            --智力
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,              --敏捷

		

	}
end


function modifier_Advanced_Shallow_Grave_unlock3_bonus:GetModifierBonusStats_Strength()	return self:GetStackCount() end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:GetModifierBonusStats_Intellect()	return self:GetStackCount() end
function modifier_Advanced_Shallow_Grave_unlock3_bonus:GetModifierBonusStats_Agility()	return self:GetStackCount() end
















