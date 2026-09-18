--特效优化 √

Advanced_Focus_Fire = class({})
LinkLuaModifier( "modifier_Advanced_Focus_Fire", "skills/Advanced_Focus_Fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Focus_effect", "skills/Advanced_Focus_Fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Focus_Fire_unlock1", "skills/Advanced_Focus_Fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Focus_Fire_unlock3_active", "skills/Advanced_Focus_Fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Focus_Fire_debuff", "skills/Advanced_Focus_Fire", LUA_MODIFIER_MOTION_NONE )
function Advanced_Focus_Fire:CheckKV(key)
	local table = {


		attack_speed = 8,
		focusfire_damage_reduction =1,


	}
	local value = table[key] or -1
	return value

end
function Advanced_Focus_Fire:GetCastRange(vLocation, hTarget)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return 99999
		end	
	end
	return self:GetCaster():Script_GetAttackRange()
end
function Advanced_Focus_Fire:GetCooldown(iLevel)
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==2 then
			return 15
		end	
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end
function Advanced_Focus_Fire:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Focus_Fire_unlock1",{})
	return true
end
function Advanced_Focus_Fire:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- self.modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Viscous_Nasal_Goo_unlock2",{})
	return true
end
function Advanced_Focus_Fire:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Blade_Fury_unlock3",{})
	return true

end

function Advanced_Focus_Fire:GetBehavior()

	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)
	
	if coreUnlockKV then
		if coreUnlockKV.coreUnlock ==1 then
			return DOTA_ABILITY_BEHAVIOR_PASSIVE
		end	
		if coreUnlockKV.coreUnlock ==3 then
			return DOTA_ABILITY_BEHAVIOR_TOGGLE
		end	
	end
	return self.BaseClass.GetBehavior(self)
end




function Advanced_Focus_Fire:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then

		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Focus_Fire_unlock3_active", {})
	else


		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Focus_Fire_unlock3_active", self:GetCaster())
	end
	
end






function Advanced_Focus_Fire:OnSpellStart()


	local target = self:GetCursorTarget()
	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end  --触发林肯
	-- this version of Focus Fire allows multiple target
	-- check existing modifiers
	self:FocusTarget(target)
	

end


function Advanced_Focus_Fire:FocusTarget(target)
	local caster = self:GetCaster()
	local modifiers = caster:FindAllModifiersByName( "modifier_Advanced_Focus_Fire" )
	for _,modifier in pairs(modifiers) do
		modifier:SafeDestroy()
	end
	modifiers = caster:FindAllModifiersByName( "modifier_Advanced_Focus_effect" )
	for _,modifier in pairs(modifiers) do
		modifier:SafeDestroy()
	end

	local ent = target:entindex()
	-- add modifier to new targets

	local ModifierStatusGain = caster:GetModifierDurationGainIndex(0.5)
	caster:AddNewModifier(caster, self, "modifier_Advanced_Focus_effect", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain,target = ent,})

	caster:AddNewModifier(caster, self, "modifier_Advanced_Focus_Fire", {duration = self:GetSpecialValueFor("duration")*ModifierStatusGain,target = ent,})
	
	-- Play effects
	local sound_cast = "Ability.Focusfire"
	EmitSoundOn( sound_cast, caster )
end

function Advanced_Focus_Fire:OnProjectileHit_ExtraData(target, location, kv)
	-- print("1")
	if target~=nil then
		local caster = self:GetCaster()
		local modifier_keys = {
			duration = 0.1,
			iSpecialAttack = 1,
			iDisableApplyModifier = 0,
			iDisableCleave =1,
			iDisableSplit = 1,
	
		}
		local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
		caster:PerformAttack(target, false, true, true, true, false, false, true)
		if IsValid(attackEffectRecord) then
			attackEffectRecord:Destroy()
		end

	end
	-- return true
end

modifier_Advanced_Focus_Fire = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Focus_Fire:IsDebuff()			return false end
function modifier_Advanced_Focus_Fire:IsHidden() 			return false end
function modifier_Advanced_Focus_Fire:IsPurgable() 			return false end
function modifier_Advanced_Focus_Fire:IsPurgeException() 	return false end
-- function modifier_Advanced_Focus_Fire:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Focus_Fire:OnCreated( kv )
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level

	self.bonus = self:GetAbility():GetSpecialValueFor( "attack_speed" )
	local reduce =self:GetAbility():GetSpecialValueFor( "focusfire_damage_reduction" )
	--LV20解锁两极反转
	if self.advanced_level>=20 then
		reduce = 125
	end
	self.reduction = reduce-100


	self.bonus_attack_range = 0
	if self.advanced_level>=15 and self:GetParent():IsRangedAttacker() then
		self.bonus_attack_range = 600
	end
	if self:GetAbility():GetUnlock(3)==3 then
		self.bonus_attack_range = 1200
	end
	if self:GetAbility():GetUnlock(2)==2 then
		self.bonus_attack_range = 99999
	end


	if not IsServer() then return end
	self.follow = true
	self.attacking = true
	-- references	

	self.target = EntIndexToHScript( kv.target )  


	-- end
	self:StartIntervalThink( 0 )
	self:OnIntervalThink()
end


function modifier_Advanced_Focus_Fire:OnRemoved() end
function modifier_Advanced_Focus_Fire:OnDestroy() end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Focus_Fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end
function modifier_Advanced_Focus_Fire:ADDeclareFunctions()
	return {advanced_MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,}
end
function modifier_Advanced_Focus_Fire:Advanced_GetModifierAttackRangeBonus() 
	if IsServer() then 
		local aggro = self:GetParent():GetAggroTarget()
		if aggro and aggro~=self.target then return end
	end
	return self.bonus_attack_range
end



function modifier_Advanced_Focus_Fire:GetModifierAttackSpeedBonus_Constant()	
	if IsServer() then 
		local aggro = self:GetParent():GetAggroTarget()
		if aggro and aggro~=self.target then return end
	end
	return self.bonus 
end
function modifier_Advanced_Focus_Fire:GetModifierDamageOutgoing_Percentage()
	if not IsServer() then return end
	local aggro = self:GetParent():GetAggroTarget()
	if aggro and aggro~=self.target then return end

	return self.reduction
end
--------------------------------------------------------------------


-------------------------------------------------------------------

function modifier_Advanced_Focus_Fire:OnOrder( params )   --停止攻击
	if not IsServer() then return end
	if params.unit~=self:GetParent() then return end

	-- if ordered to attack target, move to target instead
	if params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET and params.target==self.target then
		-- chase instead
		self.follow = true
	else
		self.follow = false
	end

	-- specific order to stop autoattack
	if params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET and params.target~=self.target then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_HOLD_POSITION then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_CONTINUE then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_STOP then
		self.attacking = false
	elseif params.order_type==DOTA_UNIT_ORDER_MOVE_TO_DIRECTION then
		self.attacking = false
	-- other order resumes attack
	else
		if self:GetParent():IsDisarmed() or self:GetParent():IsStunned() or self:GetParent():IsFrozen() or self:GetParent():IsHexed() or self:GetParent():IsOutOfGame() or self:GetParent():IsInvulnerable() then
			self.attacking = false
		else
			self.attacking = true
		end
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Focus_Fire:OnIntervalThink()
	if not IsServer() then return end


	if self.target:IsNull() or not self.target:IsAlive() then
		-- if dead and not respawn, just stop
		self:StartIntervalThink(-1)
		return
	end

	-- check target within range
	local distance = (self.target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()
	-- local range = self:GetParent():Script_GetAttackRange(  ) + self.bonus_attack_range
	local range = self:GetParent():Script_GetAttackRange(  )
	--这是个全图射程，以后可以激活
	-- if IsServer() and self:GetParent():HasAbility("pathfinder_special_windranger_focusfire_global") then   
	-- 	range = range / 100 * self:GetParent():FindAbilityByName("pathfinder_special_windranger_focusfire_global"):GetSpecialValueFor("range_mult")
	-- end
	self.inRange = distance<=range
	if self.inRange and self.attacking and self.target:IsAlive() then
		-- if self.follow then
		-- 	-- TODO: not immediately follow target
		-- 	self:GetParent():MoveToNPC( self.target )
		-- end

		-- bombard target, but respect attack speed cooldown
		self:GetParent():PerformAttack(
			self.target,
			true,
			true,
			false,
			false,
			true,
			false,
			false
		)
		
	end
end


function modifier_Advanced_Focus_Fire:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.target ~=self.target then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local chance = ability:GetSpecialValueFor( "chance" )
	local reduce_duration = ability:GetSpecialValueFor( "reduce_duration" )

	--攻速验证
	-- self.time_now = GameRules:GetGameTime()
	-- if self:GetStackCount() <= 0 then
	-- 	self.time_0 = GameRules:GetGameTime()
	-- end
	-- self:SetStackCount(self:GetStackCount()+1)
	-- if self.time_now - self.time_0 >= 1 then
	-- 	print("已经过去一秒，实际攻击次数为"..self:GetStackCount())
	-- 	self:SetStackCount(0)
	-- end
	--LV10解锁箭神+--修正：11%→30%
	if self.advanced_level>=10 then
		chance = 60
	end
	---------------------------------原触发强力击效果已移除-----------------------------------
	--if chance > RandomInt(1, 100) then
	--	local caster = keys.attacker 
	--	local casterpos = caster:GetAbsOrigin()
	--	local pos = keys.target:GetAbsOrigin()
	--	 预防目标位置等于自身位置导致的bug
	--	if pos == casterpos then
	--		pos = casterpos + self:GetCaster():GetForwardVector()
	--	end
	--	
	--	local dir=TG_Direction(pos,casterpos)
	--	dir.z=0
	--	caster:EmitSound("Ability.Powershot")
	--	local projectileTable =
	--	{
	--	EffectName ="particles/econ/items/windrunner/windrunner_ti6/windrunner_spell_powershot_ti6.vpcf",
	--	Ability = self:GetAbility(),
	--	vSpawnOrigin =casterpos,
	--	vVelocity =dir*1000,
	--	fDistance =1500,
	--	fStartRadius = self:GetAbility():GetSpecialValueFor( "radius" ),
	--	fEndRadius = self:GetAbility():GetSpecialValueFor( "radius" ),
	--	Source = keys.attacker,
	--	-- bDeleteOnHit = true,
	--	bHasFrontalCone = false,
	--	bReplaceExisting = false,
	--	iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	--	iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	--	iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	--	}
	--    ProjectileManager:CreateLinearProjectile( projectileTable )
	--end
	---------------------------------原触发强力击效果已移除-----------------------------------
	---------------------------------新增：全方位创伤-----------------------------------
	if chance > RandomInt(1,100)	then
		keys.target:AddNewModifier(caster, ability, "modifier_Advanced_Focus_Fire_debuff", {duration = reduce_duration})
	end
	---------------------------------新增：全方位创伤-----------------------------------
end
--------------------------------------------------------------------------------

modifier_Advanced_Focus_effect = class({})


-- Classifications
function modifier_Advanced_Focus_effect:IsDebuff()			return false end
function modifier_Advanced_Focus_effect:IsHidden() 			return true end
function modifier_Advanced_Focus_effect:IsPurgable() 			return false end
function modifier_Advanced_Focus_effect:IsPurgeException() 	return false end

function modifier_Advanced_Focus_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,}
end

function modifier_Advanced_Focus_effect:OnCreated( kv )
	if IsServer() then
		if kv.target==nil then
			self:SafeDestroy()
			return
		end
		self.target = EntIndexToHScript( kv.target )  
	end
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbility():GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level


	self.bonus_speed = self:GetAbility():GetSpecialValueFor( "bonus_speed" )
	--LV5解锁会神+
	if advanced_level>=5 then
		self.bonus_speed = 8
	end
	
end

function modifier_Advanced_Focus_effect:OnAttackLanded(keys)
		if not IsServer()  or self:GetParent():IsIllusion()  or keys.target ~= self.target then
			return
		end
		if keys.attacker == self:GetParent() then
			self:IncrementStackCount()
		end
end
	



function modifier_Advanced_Focus_effect:GetModifierAttackSpeedBonus_Constant()	
	if IsServer() then 
		local aggro = self:GetParent():GetAggroTarget()
		if aggro and aggro~=self.target then return end
	end
	return self:GetStackCount() * self.bonus_speed
end






modifier_Advanced_Focus_Fire_unlock1 = class({})

function modifier_Advanced_Focus_Fire_unlock1:IsDebuff()			return false end
function modifier_Advanced_Focus_Fire_unlock1:IsHidden() 			return true end
function modifier_Advanced_Focus_Fire_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Focus_Fire_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Focus_Fire_unlock1:RemoveOnDeath() return false end


function modifier_Advanced_Focus_Fire_unlock1:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_Advanced_Focus_Fire_unlock1:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	local caster = self:GetParent()
	if 	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET  then
		if not IsEnemy(caster,params.target) then
			return
		end
		self:GetAbility():FocusTarget(params.target)
	end
end







modifier_Advanced_Focus_Fire_unlock3_active					= class({})

function modifier_Advanced_Focus_Fire_unlock3_active:IsDebuff()			return false end
function modifier_Advanced_Focus_Fire_unlock3_active:IsHidden() 			return true end
function modifier_Advanced_Focus_Fire_unlock3_active:IsPurgable() 		return false end
function modifier_Advanced_Focus_Fire_unlock3_active:IsPurgeException() 	return false end
function modifier_Advanced_Focus_Fire_unlock3_active:OnCreated()
	if IsServer() then

		self:StartIntervalThink(0.2)
	end
end
function modifier_Advanced_Focus_Fire_unlock3_active:GetPriority() return 500 end
function modifier_Advanced_Focus_Fire_unlock3_active:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		-- [MODIFIER_STATE_DISARMED] = true
	}


	return state
end
function modifier_Advanced_Focus_Fire_unlock3_active:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
	}
	return funcs
end
function modifier_Advanced_Focus_Fire_unlock3_active:OnOrder( params )
	if params.unit~=self:GetParent() then return end
	local caster = self:GetParent()
	if 	params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET  then
		if not IsEnemy(caster,params.target) then
			return
		end
		self.target = params.target
		self:GetAbility():FocusTarget(params.target)
	end
end

function modifier_Advanced_Focus_Fire_unlock3_active:OnIntervalThink()
	local caster = self:GetCaster()
	self.range = self:GetParent():Script_GetAttackRange(  ) +1200
	if self.target and not self.target:IsNull()  and self.target:IsAlive() and self:CheckDistance(self.target) then
		-- 这个单位仍然是一个有效的目标
		caster:SetAttacking(self.target)
		local modifier = caster:FindModifierByName("modifier_Advanced_Focus_Fire")
		if modifier then
			return
		else
			self:GetAbility():FocusTarget(self.target)
		end
		
	end
	-- 重新获取单位
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.range,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _, unit in ipairs(units) do
		if not unit:IsAttackImmune() then
			self.target = unit
			self:GetAbility():FocusTarget(self.target)
			break
		end
	end

end
function modifier_Advanced_Focus_Fire_unlock3_active:OnDestroy()
	if IsServer() then
		local caster = self:GetCaster()
		local modifiers = caster:FindAllModifiersByName( "modifier_Advanced_Focus_Fire" )
		for _,modifier in pairs(modifiers) do
			modifier:SafeDestroy()
		end
		modifiers = caster:FindAllModifiersByName( "modifier_Advanced_Focus_effect" )
		for _,modifier in pairs(modifiers) do
			modifier:SafeDestroy()
		end
	end

end
function modifier_Advanced_Focus_Fire_unlock3_active:CheckDistance(target)

	local dis = CalculateDistance(target,self:GetCaster())
	if self.range>=dis then
		return true
	end
	return false
end
---------------------------------新增：全方位创伤-----------------------------------
modifier_Advanced_Focus_Fire_debuff = advanced_modifier({})

function modifier_Advanced_Focus_Fire_debuff:IsDebuff()			return true end
function modifier_Advanced_Focus_Fire_debuff:IsHidden() 			return false end
function modifier_Advanced_Focus_Fire_debuff:IsPurgable() 		return false end
function modifier_Advanced_Focus_Fire_debuff:IsPurgeException() 	return false end
function modifier_Advanced_Focus_Fire_debuff:OnCreated(keys)
	self.armor_reduce = self:GetAbility():GetSpecialValueFor("armor_reduce")
	self.magic_resist_reduce = self:GetAbility():GetSpecialValueFor("magic_resist_reduce")
	self.move_reduce = self:GetAbility():GetSpecialValueFor("move_reduce")
	self:SetStackCount(1)
end

function modifier_Advanced_Focus_Fire_debuff:OnRefresh(keys)
	self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	self:SetStackCount(math.min(self:GetStackCount()+1,self.max_stacks))
end

function modifier_Advanced_Focus_Fire_debuff:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		
	}
end

function modifier_Advanced_Focus_Fire_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		
	}
end

function modifier_Advanced_Focus_Fire_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount()*self.armor_reduce
end

function modifier_Advanced_Focus_Fire_debuff:GetModifierMagicalResistanceBonus()
	return	-self:GetStackCount()*self.magic_resist_reduce
end

function modifier_Advanced_Focus_Fire_debuff:GetModifierMoveSpeedBonus_Constant()
	return	-self:GetStackCount()*self.move_reduce
end