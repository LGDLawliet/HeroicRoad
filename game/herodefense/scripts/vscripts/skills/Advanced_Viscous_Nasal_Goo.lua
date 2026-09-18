
Advanced_Viscous_Nasal_Goo = class({})


LinkLuaModifier("modifier_advanced_goo_stack", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_advanced_goo_stack2", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_advanced_goo_stack3", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)


LinkLuaModifier("modifier_Advanced_Viscous_Nasal_Goo_unlock1", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Viscous_Nasal_Goo_unlock2", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Viscous_Nasal_Goo_unlock3", "skills/Advanced_Viscous_Nasal_Goo", LUA_MODIFIER_MOTION_NONE)
function Advanced_Viscous_Nasal_Goo:CheckKV(key)
	local table = {
		base_armor=0.1,
		armor_per_stack=0.04,
		base_move_slow=2,
		move_slow_per_stack=0.4,
	}
	local value = table[key] or -1
	return value

end
function Advanced_Viscous_Nasal_Goo:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock1",{})
	return true
end
function Advanced_Viscous_Nasal_Goo:UnlockSecondCore(key)
	local caster = self:GetCaster()
	self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Viscous_Nasal_Goo:UnlockThirdCore(key)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock3",{})
	return true

end
function Advanced_Viscous_Nasal_Goo:GetBehavior()


	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_AURA+DOTA_ABILITY_BEHAVIOR_PASSIVE
		end
	end
	return self.BaseClass.GetBehavior(self)
	
end

function Advanced_Viscous_Nasal_Goo:IsHiddenWhenStolen() 		return false end
function Advanced_Viscous_Nasal_Goo:IsRefreshable() 			return true  end
function Advanced_Viscous_Nasal_Goo:IsStealable() 			return true  end
function Advanced_Viscous_Nasal_Goo:IsNetherWardStealable()	return true end
function Advanced_Viscous_Nasal_Goo:GetAOERadius()
	return self:GetSpecialValueFor("radius")	 
end


function Advanced_Viscous_Nasal_Goo:GetCastRange(location,target)
	local caster = self:GetCaster()
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return 1000- caster:GetCastRangeBonus()
		end
		if coreUnlockKV.coreUnlock ==3 then
			return 1000- caster:GetCastRangeBonus()
		end
	end
	return self.BaseClass.GetCastRange(self,location,target)
end


function Advanced_Viscous_Nasal_Goo:OnSpellStart(origin,caster_ball)
	local caster = self:GetCaster()
	EmitSoundOn("Hero_Bristleback.ViscousGoo.Cast", caster)
	local radius = self:GetSpecialValueFor("radius")
	local target = self:GetCursorTarget()
	local pos = target:GetAbsOrigin()	
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), pos, nil, radius,
	 DOTA_UNIT_TARGET_TEAM_ENEMY,
	  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	local effect_number = 5
	--LV5解锁愤怒列+
	if self.advanced_level>=5 then
		effect_number = 7
	end
	for i,enemy in pairs(enemies) do
		self:start(enemy,caster)
		if i>effect_number then
			break
		end
	end
end

function Advanced_Viscous_Nasal_Goo:start(target, caster)
		local info1 = 
			{
				Target = target,
				Source = caster,
				Ability = self,	
				EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
				iMoveSpeed = 1000,
				vSourceLoc= caster:GetAbsOrigin(),
				bDrawsOnMinimap = false,
				bDodgeable = true,
				bIsAttack = false,
				bVisibleToEnemies = true,
				bReplaceExisting = false,
				bProvidesVision = false,	
				ExtraData = {hit = 1}   --额外的数据
			}
		if target ~= nil then
			ProjectileManager:CreateTrackingProjectile(info1)
		end        
end
function Advanced_Viscous_Nasal_Goo:start2(target, caster ,pfx)
	local info1 = 
		{
			Target = target,
			Source = caster,
			Ability = self,	
			EffectName = "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc= caster:GetAbsOrigin(),
			bDrawsOnMinimap = false,
			bDodgeable = true,
			bIsAttack = false,
			bVisibleToEnemies = true,
			bReplaceExisting = false,
			bProvidesVision = false,	
			-- ExtraData = {hit = 0}   --额外的数据
		}
	if target ~= nil then
		ProjectileManager:CreateTrackingProjectile(info1)
	end        
end

function Advanced_Viscous_Nasal_Goo:OnProjectileHit_ExtraData(target, pos,keys)
	local caster = self:GetCaster()
	if not target then
		return
	end
	if target:TriggerSpellAbsorb(self) then
		return
	end 
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.35)

	local modifier = caster:FindModifierByName("modifier_Advanced_Viscous_Nasal_Goo_unlock2")
	local index = 0.35
	if modifier then
		local stack = modifier:GetStackCount()
		if stack>=20 then
			index = 0
		end
	end
	local StatusResistance =  target:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
	if keys.hit then
		target:AddNewModifier(caster,self,"modifier_advanced_goo_stack",{duration = self:GetSpecialValueFor("duration")*StatusResistance})
	else

		target:AddNewModifier(caster,self,"modifier_advanced_goo_stack2",{duration = self:GetSpecialValueFor("duration")*StatusResistance})
		--LV20解锁交叉感染 
		if self.advanced_level>=20 and target:HasModifier("modifier_advanced_goo_stack") and self:GetCaster():GetRandomEffect(10,INT_TYPE,1) >=RandomInt(1, 100) then
			target:AddNewModifier(caster,self,"modifier_advanced_goo_stack3",{})
		end
	end
	if self.modifier then
		self.modifier:AddStack()
	end
end


	
--鼻涕叠加
modifier_advanced_goo_stack=advanced_modifier({})
function modifier_advanced_goo_stack:IsHidden() return false end
function modifier_advanced_goo_stack:IsPurgable() return not self.UnPurge end
function modifier_advanced_goo_stack:IsPurgeException() return not self.UnPurge end
function modifier_advanced_goo_stack:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end
function modifier_advanced_goo_stack:GetStatusEffectName()
	return "particles/status_fx/status_effect_goo.vpcf"
end
function modifier_advanced_goo_stack:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
} 
end

function modifier_advanced_goo_stack:Advanced_GetModifierPhysicalArmorBonus() return self.base_armor + self:GetStackCount()*self.stack_armor end
function modifier_advanced_goo_stack:GetModifierMoveSpeedBonus_Constant() return self.base_slow + self:GetStackCount()*self.stack_slow end
function modifier_advanced_goo_stack:GetModifierMagicalResistanceBonus() return self:GetStackCount()*self.magiac_reduce end


function modifier_advanced_goo_stack:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")

	self.base_armor = -self:GetAbility():GetSpecialValueFor("base_armor")
	self.stack_armor = -self:GetAbility():GetSpecialValueFor("armor_per_stack")
	self.base_slow = -self:GetAbility():GetSpecialValueFor("base_move_slow")
	self.stack_slow = -self:GetAbility():GetSpecialValueFor("move_slow_per_stack")
	self.bonus_status_resistance = 0
	if IsServer() then
		self:SetStackCount(1)
		self:StartIntervalThink(RandomInt(3, 5))
		local modifier = caster:FindModifierByName("modifier_Advanced_Viscous_Nasal_Goo_unlock2")
		if modifier then
			local stack = modifier:GetStackCount()
			if stack>=20 then
				self.UnPurge = true
			end
			self.base_armor = self.base_armor -stack
		end
		if ability.unlock3 then
			self:SetStackCount(10)
		end
	end
	self.magiac_reduce = 0
	--LV15解锁重感冒
	if self.advanced_level>=15 then
		self.magiac_reduce = -2
		self.bonus_status_resistance = -2
	end
end
function modifier_advanced_goo_stack:OnRefresh()
	if IsServer() then
		local limit = self:GetAbility():GetSpecialValueFor("stack_limit")
		if self:GetAbility().unlock1 then
			limit = math.max(limit,20)
		end
		self:SetStackCount( math.min( self:GetStackCount() + 1, limit)) 
	end
end



function modifier_advanced_goo_stack:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		if not ability then
			return
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 500,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	   if #enemies>1 then
		ability:start2(enemies[2],self:GetParent())
	   end
	end
end

function modifier_advanced_goo_stack:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance
    }
end
function modifier_advanced_goo_stack:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance*self:GetStackCount()
end



--鼻涕叠加
modifier_advanced_goo_stack2=advanced_modifier({})
function modifier_advanced_goo_stack2:IsHidden() return false end
function modifier_advanced_goo_stack2:IsPurgable() return not self.UnPurge end
function modifier_advanced_goo_stack2:IsPurgeException() return not self.UnPurge end
function modifier_advanced_goo_stack2:GetEffectName()
	return "particles/units/heroes/hero_bristleback/bristleback_viscous_nasal_goo_debuff.vpcf"
end
function modifier_advanced_goo_stack2:GetStatusEffectName()
	return "particles/status_fx/status_effect_goo.vpcf"
end
function modifier_advanced_goo_stack2:DeclareFunctions() return {
	MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
} 
end

function modifier_advanced_goo_stack2:Advanced_GetModifierPhysicalArmorBonus() return self.base_armor + self:GetStackCount()*self.stack_armor end
function modifier_advanced_goo_stack2:GetModifierMoveSpeedBonus_Constant() return self.base_slow + self:GetStackCount()*self.stack_slow end
function modifier_advanced_goo_stack2:GetModifierMagicalResistanceBonus() return self:GetStackCount()*self.magiac_reduce end



function modifier_advanced_goo_stack2:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	self.advanced_level = self:GetAbility():GetSpecialValueFor("advanced_level")
	local index = 0.5
	--LV10解锁病毒+
	if self.advanced_level>=10 then
		index = 0.75
	end

	self.base_armor =( -self:GetAbility():GetSpecialValueFor("base_armor"))*index
	self.stack_armor = (-self:GetAbility():GetSpecialValueFor("armor_per_stack"))*index
	self.base_slow = (-self:GetAbility():GetSpecialValueFor("base_move_slow"))*index
	self.stack_slow = (-self:GetAbility():GetSpecialValueFor("move_slow_per_stack"))*index
	if IsServer() then
		self:SetStackCount(1)
		local modifier = caster:FindModifierByName("modifier_Advanced_Viscous_Nasal_Goo_unlock2")
		

		if modifier then
			local stack = modifier:GetStackCount()
			if stack>=20 then
				self.UnPurge = true
			end
			self.base_armor = self.base_armor -stack*0.5
		end

	end
	self.magiac_reduce = 0
	--LV15解锁重感冒
	if self.advanced_level>=15 then
		self.magiac_reduce = -1
		self.bonus_status_resistance = -1
	end
end
function modifier_advanced_goo_stack2:OnRefresh()
	if IsServer() then
		local limit = self:GetAbility():GetSpecialValueFor("stack_limit")
		if self:GetAbility().unlock1 then
			limit = math.max(limit,20)
		end
		self:SetStackCount( math.min( self:GetStackCount() + 1, limit)) 

	end

end



function modifier_advanced_goo_stack2:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		advanced_MODIFIER_PROPERTY_StatusResistance,
    }
end

function modifier_advanced_goo_stack2:Advanced_GetModifier_StatusResistance(keys)
	return self.bonus_status_resistance*self:GetStackCount()
end




modifier_advanced_goo_stack3=advanced_modifier({})
function modifier_advanced_goo_stack3:IsHidden() return false end
function modifier_advanced_goo_stack3:IsPurgable() return false end

function modifier_advanced_goo_stack3:DeclareFunctions() return {
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
} 
end

function modifier_advanced_goo_stack3:Advanced_GetModifierPhysicalArmorBonus() return -self:GetStackCount() end
function modifier_advanced_goo_stack3:GetModifierMagicalResistanceBonus() return -2*self:GetStackCount() end



function modifier_advanced_goo_stack3:OnCreated()

	if IsServer() then
		self:SetStackCount(1)
	end
	
end
function modifier_advanced_goo_stack3:OnRefresh()
	if IsServer() then
		self:SetStackCount( math.min( self:GetStackCount() + 1, 20)) 
	end
end



function modifier_advanced_goo_stack3:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end



modifier_Advanced_Viscous_Nasal_Goo_unlock1 = class({})

function modifier_Advanced_Viscous_Nasal_Goo_unlock1:IsDebuff()			return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:IsHidden() 			return true end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Viscous_Nasal_Goo_unlock1:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_Advanced_Viscous_Nasal_Goo_unlock1:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability:IsCooldownReady() then
		return
	end
	local caster = self:GetCaster()
	if caster:IsSilenced() or not caster:IsAlive() then
		return
	end
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if #units<=0 then
		return
	end
	local effect_number = 7
	for i,enemy in pairs(units) do
		ability:start(enemy,caster)
		if i>effect_number then
			break
		end
	end
	ability:UseResources(true, true, true, true)
	local warpath = caster:FindAbilityByName("Advanced_Warpath")
	if warpath then
		warpath:AddStack(caster)
	end
end


modifier_Advanced_Viscous_Nasal_Goo_unlock2 = class({})

function modifier_Advanced_Viscous_Nasal_Goo_unlock2:IsDebuff()			return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:IsHidden() 			return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:IsPurgable() 		return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:IsPurgeException() 	return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:RemoveOnDeath() return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Viscous_Nasal_Goo_unlock2:OnCreated()
	if IsServer() then
		self.count = 0
	end
end

function modifier_Advanced_Viscous_Nasal_Goo_unlock2:AddStack()
	self.count = self.count +1
	if self.count>=100 then
		self.count = self.count -100
		self:IncrementStackCount()
	end
end




modifier_Advanced_Viscous_Nasal_Goo_unlock3 = class({})

function modifier_Advanced_Viscous_Nasal_Goo_unlock3:IsDebuff()			return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:IsHidden() 			return true end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:RemoveOnDeath() return false end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Viscous_Nasal_Goo_unlock3:GetModifierAura()	return "modifier_advanced_goo_stack" end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:GetAuraRadius()	return 1000  end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Viscous_Nasal_Goo_unlock3:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end



