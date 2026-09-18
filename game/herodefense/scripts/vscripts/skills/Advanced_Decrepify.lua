--特效优化 √
Advanced_Decrepify = class({})

LinkLuaModifier("modifier_Advanced_Decrepify_ally", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_enemy", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_ally_bonus", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_enemy_stack", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_aura", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_aura_effect", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Decrepify_unlock3", "skills/Advanced_Decrepify", LUA_MODIFIER_MOTION_NONE)
function Advanced_Decrepify:CheckKV(key)
	local table = {

		magic_resistance_reduce = 1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Decrepify:UnlockFirstCore(key)
	return true
end
function Advanced_Decrepify:UnlockSecondCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_aura",{})
	return true
end
function Advanced_Decrepify:UnlockThirdCore(key)
	local caster = self:GetCaster()

	if caster:GetUnitName()~="npc_dota_hero_pugna"  or not  caster:HasAbility("heroTalent_npc_dota_hero_pugna") then
		self.CoreUnlock = false
		self.unlock3 = false
		SendCustomErrorToPlayer(caster:GetPlayerOwnerID(),"dota_hud_Cant_UNLOCK","General.Cancel")
		return false
	end
	caster:AddNewModifier(caster,self,"modifier_Advanced_Decrepify_unlock3",{})
	return true
end
function Advanced_Decrepify:IsHiddenWhenStolen() 		return false end
function Advanced_Decrepify:IsRefreshable() 			return true end
function Advanced_Decrepify:IsStealable() 			return true end
function Advanced_Decrepify:IsNetherWardStealable()	return true end
function Advanced_Decrepify:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE+DOTA_ABILITY_BEHAVIOR_AURA
		end
		
	end

	return self.BaseClass.GetBehavior(self)

end
function Advanced_Decrepify:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()


	if IsEnemy(caster, target) then
		---------------------------------------------------
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 
		self:GetSpecialValueFor("radius"),
		 DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		 local bonus_armor_target = caster
		for _, unit in pairs(units) do
			if unit:GetPhysicalArmorValue(false) > bonus_armor_target:GetPhysicalArmorValue(false) then
				bonus_armor_target = unit
			end
		end
		--获取最高护甲的友军英雄
		local ent = bonus_armor_target:entindex()
		if self.unlock1 then
			target:AddNewModifier(caster, self, "modifier_Advanced_Decrepify_enemy", {target = ent})
		
		else
			local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.5)
			local StatusResistance = target:GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
			target:AddNewModifier(caster, self, "modifier_Advanced_Decrepify_enemy", {duration = self:GetSpecialValueFor("duration_basic")*StatusResistance,target = ent})
		
		end
		------------------------------------------------------
	else 
		target:AddNewModifier(caster, self, "modifier_Advanced_Decrepify_ally", {duration = self:GetSpecialValueFor("duration_basic")})
	end
	
	target:EmitSound("Hero_Pugna.Decrepify")
end

modifier_Advanced_Decrepify_ally = class({})

function modifier_Advanced_Decrepify_ally:IsDebuff()			return false end
function modifier_Advanced_Decrepify_ally:IsHidden() 			return false end
function modifier_Advanced_Decrepify_ally:IsPurgable() 			return true end
function modifier_Advanced_Decrepify_ally:IsPurgeException() 	return true end
function modifier_Advanced_Decrepify_ally:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Advanced_Decrepify_ally:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Decrepify_ally:OnCreated(keys)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	self.magic_resistance = 0
	--LV20解锁归位+
	if self.advanced_level>=20 then
		self.magic_resistance = self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")+self.advanced_level
	end
	if IsServer() then
		self:StartIntervalThink(0.1)   
	end
	

end
function modifier_Advanced_Decrepify_ally:CheckState() 
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true, 
	}
	if self.advanced_level>=15 then
		state = {
			[MODIFIER_STATE_ATTACK_IMMUNE] = true, 
		}
	end
	return state 
end
function modifier_Advanced_Decrepify_ally:DeclareFunctions() return 
	{MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Decrepify_ally:GetAbsoluteNoDamagePhysical() return 1 end

function modifier_Advanced_Decrepify_ally:GetModifierMagicalResistanceBonus() return self.magic_resistance end



function modifier_Advanced_Decrepify_ally:OnIntervalThink()
	if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end
end


modifier_Advanced_Decrepify_enemy = class({})

function modifier_Advanced_Decrepify_enemy:IsDebuff()			return true end
function modifier_Advanced_Decrepify_enemy:IsHidden() 			return false end
function modifier_Advanced_Decrepify_enemy:IsPurgable()
	if self:GetAbility():GetUnlock(1)==1 then
		return false
	end	
	return true 
end
function modifier_Advanced_Decrepify_enemy:IsPurgeException() 	
	if self:GetAbility():GetUnlock(1)==1 then
		return false
	end	
	return true 
end
function modifier_Advanced_Decrepify_enemy:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Advanced_Decrepify_enemy:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Decrepify_enemy:CheckState() 
	if self:GetAbility():GetUnlock(1)==1 then
		return 
	end
	return {
		[MODIFIER_STATE_DISARMED] = true, 
		[MODIFIER_STATE_ATTACK_IMMUNE] = true, 
	} 
end
function modifier_Advanced_Decrepify_enemy:DeclareFunctions() return
	 {MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Decrepify_enemy:GetModifierMoveSpeedBonus_Constant() return (0 - self:GetAbility():GetSpecialValueFor("move_slow")) end
function modifier_Advanced_Decrepify_enemy:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Advanced_Decrepify_enemy:GetModifierMagicalResistanceBonus() 
	return self.magic_resistance_reduce * (1+self:GetStackCount()*0.1)
end


function modifier_Advanced_Decrepify_enemy:OnCreated(kv)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.magic_resistance_reduce = -self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")

	if IsServer() then
		self.target = EntIndexToHScript( kv.target )  
		self.bonus_duration = self:GetAbility():GetSpecialValueFor("duration_bonus")
		--LV10解锁灵魂置换+
		if self.advanced_level>=10 then
			self.bonus_duration = 10
		end
		if ability.unlock1 then
			self.unlock1 = true
		end
		self.target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Advanced_Decrepify_ally_bonus", {duration = self.bonus_duration})
		local interval = 0.5
		--LV5解锁极速衰老+
		if self.advanced_level>=5 then
			interval = 0.25
		end
		self:StartIntervalThink(interval)
	end
end

function modifier_Advanced_Decrepify_enemy:OnRefresh(keys)
	if IsServer() then
		local ability = self:GetAbility()
		if ability.unlock1 then
			self.unlock1 = true
		end
		if self.unlock1 then
			self:IncrementStackCount()
		end
	end
end

function modifier_Advanced_Decrepify_enemy:OnIntervalThink()
	if IsServer() then
		local ModifierStatusNegativeGain = self:GetCaster():GetModifierStatusNegativeGainIndex(0.5)
		local StatusResistance = self:GetParent():GetHDStatusResistanceIndex(0.5)*ModifierStatusNegativeGain
		local ModifierStatusNegativeGain =self:GetCaster():GetModifierDurationGainIndex(1)
		self.target:AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Advanced_Decrepify_ally_bonus", {duration = self.bonus_duration*ModifierStatusNegativeGain})
		local modifier = self:GetParent():FindModifierByName("modifier_Advanced_Decrepify_enemy_stack")
		if modifier then
			modifier:SetDuration(self:GetAbility():GetSpecialValueFor("duration_bonus")*StatusResistance, true)
			modifier:OnRefresh()
		else
			self:GetParent():AddNewModifier(self:GetAbility():GetCaster(), self:GetAbility(), "modifier_Advanced_Decrepify_enemy_stack", {duration = self:GetAbility():GetSpecialValueFor("duration_bonus")*StatusResistance})
	
		end

		if self:GetParent():IsMagicImmune() then self:SafeDestroy()	end
		
	end
end



modifier_Advanced_Decrepify_enemy_stack = class({})

function modifier_Advanced_Decrepify_enemy_stack:IsDebuff()			    return true end
function modifier_Advanced_Decrepify_enemy_stack:IsHidden() 			return false end
function modifier_Advanced_Decrepify_enemy_stack:IsPurgable() 		    return true end
function modifier_Advanced_Decrepify_enemy_stack:IsPurgeException() 	return true end
function modifier_Advanced_Decrepify_enemy_stack:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Decrepify_enemy_stack:GetModifierMagicalResistanceBonus() 
	return (0 - self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s")*self:GetStackCount()) 
end
function modifier_Advanced_Decrepify_enemy_stack:OnCreated(table)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Decrepify_enemy_stack:OnRefresh(table)
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s_max") then
			self:IncrementStackCount()
		end
	end
end



modifier_Advanced_Decrepify_ally_bonus = class({})

function modifier_Advanced_Decrepify_ally_bonus:IsDebuff()			    return false end
function modifier_Advanced_Decrepify_ally_bonus:IsHidden() 			    return false end
function modifier_Advanced_Decrepify_ally_bonus:IsPurgable() 		    return true end
function modifier_Advanced_Decrepify_ally_bonus:IsPurgeException()   	return true end
function modifier_Advanced_Decrepify_ally_bonus:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS} end
function modifier_Advanced_Decrepify_ally_bonus:GetModifierMagicalResistanceBonus() return (self:GetAbility():GetSpecialValueFor("magic_resistance_reduce") + self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s")*self:GetStackCount()) end
function modifier_Advanced_Decrepify_ally_bonus:OnCreated(table)
	if IsServer() then
		self:IncrementStackCount()
	end
end

function modifier_Advanced_Decrepify_ally_bonus:OnRefresh(table)
	if IsServer() then
		if self:GetStackCount() < self:GetAbility():GetSpecialValueFor("magic_resistance_reduce_per_0.5s_max") then
			self:IncrementStackCount()
		end
	end
end









modifier_Advanced_Decrepify_aura = class({})

function modifier_Advanced_Decrepify_aura:IsDebuff()			return false end
function modifier_Advanced_Decrepify_aura:IsHidden() 			return true end
function modifier_Advanced_Decrepify_aura:IsPurgable() 		return false end
function modifier_Advanced_Decrepify_aura:IsPurgeException() 	return false end
function modifier_Advanced_Decrepify_aura:RemoveOnDeath() return false end
function modifier_Advanced_Decrepify_aura:GetAttributes() return   MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end
function modifier_Advanced_Decrepify_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_Advanced_Decrepify_aura:GetModifierAura()	return "modifier_Advanced_Decrepify_aura_effect" end
function modifier_Advanced_Decrepify_aura:GetAuraRadius()	return 1300  end
function modifier_Advanced_Decrepify_aura:GetAuraSearchTeam()	return DOTA_UNIT_TARGET_TEAM_BOTH end
function modifier_Advanced_Decrepify_aura:GetAuraSearchType()	return DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC end
function modifier_Advanced_Decrepify_aura:GetAuraSearchFlags()	return DOTA_UNIT_TARGET_FLAG_NONE  end









modifier_Advanced_Decrepify_aura_effect = class({})

function modifier_Advanced_Decrepify_aura_effect:IsDebuff()			return self.magic_resistance_reduce<=0 end
function modifier_Advanced_Decrepify_aura_effect:IsHidden() 			return false end
function modifier_Advanced_Decrepify_aura_effect:IsPurgable()
	return true 
end
function modifier_Advanced_Decrepify_aura_effect:IsPurgeException() 	
	return true 
end
function modifier_Advanced_Decrepify_aura_effect:GetEffectName() return "particles/units/heroes/hero_pugna/pugna_decrepify.vpcf" end
function modifier_Advanced_Decrepify_aura_effect:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_Advanced_Decrepify_aura_effect:DeclareFunctions() return
	 {MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end
function modifier_Advanced_Decrepify_aura_effect:GetModifierMoveSpeedBonus_Constant() return self.move_slow end
function modifier_Advanced_Decrepify_aura_effect:GetAbsoluteNoDamagePhysical() return 1 end
function modifier_Advanced_Decrepify_aura_effect:GetModifierMagicalResistanceBonus() 
	local stack = self:GetStackCount()
	if stack>=1 then
		return self.magic_resistance_reduce * (1+self:GetStackCount()*0.1)
	end
	return self.magic_resistance_reduce
end


function modifier_Advanced_Decrepify_aura_effect:OnCreated(kv)
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local parent = self:GetParent()
	self.magic_resistance_reduce = self:GetAbility():GetSpecialValueFor("magic_resistance_reduce")
	self.move_slow = self:GetAbility():GetSpecialValueFor("move_slow")
	if caster:GetTeamNumber()~=parent:GetTeamNumber() then
		self.magic_resistance_reduce = -self.magic_resistance_reduce
		self.move_slow  = -self.move_slow 
		if IsServer() then
			self:StartIntervalThink(5)
			self:SetStackCount(1)
		
		end
	end

	-- if IsServer() then
	-- 	self:SetStackCount(1)
	-- end
end



function modifier_Advanced_Decrepify_aura_effect:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount()+1,20))
	end
end








modifier_Advanced_Decrepify_unlock3 = class({})

function modifier_Advanced_Decrepify_unlock3:IsDebuff()			return false end
function modifier_Advanced_Decrepify_unlock3:IsHidden() 			return true end
function modifier_Advanced_Decrepify_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Decrepify_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Decrepify_unlock3:RemoveOnDeath() return false end