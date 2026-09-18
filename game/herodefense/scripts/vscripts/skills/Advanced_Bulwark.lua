--特效优化 √
--------------------------------------------------------------------------------
Advanced_Bulwark = Advanced_Bulwark or class({})
LinkLuaModifier( "modifier_Advanced_Bulwark", "skills/Advanced_Bulwark", LUA_MODIFIER_MOTION_NONE )	
LinkLuaModifier( "modifier_Advanced_Bulwark_mars_talent", "skills/Advanced_Bulwark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Bulwark_guilt", "skills/Advanced_Bulwark", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_Bulwark_unlock1", "skills/Advanced_Bulwark", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_steady", "skills/Middle_Bulwark", LUA_MODIFIER_MOTION_NONE )

function Advanced_Bulwark:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Bulwark_unlock1",{})
	return true
end
function Advanced_Bulwark:UnlockSecondCore(key)
	return true
end
function Advanced_Bulwark:UnlockThirdCore(key)
	return true
end

function Advanced_Bulwark:GetIntrinsicModifierName()
	return "modifier_Advanced_Bulwark"
end
function Advanced_Bulwark:CheckKV(key)
	local table = {
		physical_damage_reduction = 0.5,
		physical_damage_reduction_side = 0.3,
		forward_angle = 1,
		side_angle = 2,
	}
	if self:GetCaster():HasModifier("modifier_Advanced_Bulwark_unlock1") then
		table.physical_damage_reduction = 1
		table.forward_angle = 10.8
	end
	local value = table[key] or -1
	return value

end



function Advanced_Bulwark:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/bulwark/unlock1/effect.vpcf", context )
end




function Advanced_Bulwark:OnProjectileHit_ExtraData( target, location, ExtraData )	--必须在技能主题里检测投掷物击中，修饰器中检测不到
	if not target then return end

	--if self.projdamage then print(self.projdamage .. "") end	--测试用，刚移植进英霸发现伤害又失效，最后发现是伤害表不完整，少了伤害类型（奇怪自己单机试的时候怎么可以）

	local damage = self.projdamage
	--LV10解锁流转+
	if self.advanced_level>=10 and self:GetCaster():GetRandomEffect(50,INT_TYPE,1) >=RandomInt(1, 100) then
		damage = damage *2
	end

	local damage = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,	--修饰器中创建了projdamage这个key，本来想用extradata.damage但是发现传递不过来
		ability = self,
		damage_type = DAMAGE_TYPE_PHYSICAL,
	}
	ApplyDamage( damage )

end


function Advanced_Bulwark:GetBehavior()
	if self:GetCaster():HasModifier("modifier_heroTalent_npc_dota_hero_mars_2") then
		return DOTA_ABILITY_BEHAVIOR_TOGGLE
	end
	return self.BaseClass.GetBehavior(self)
end


function Advanced_Bulwark:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function Advanced_Bulwark:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function Advanced_Bulwark:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then

		
	
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_Advanced_Bulwark_mars_talent", {})
	else


		self:GetCaster():RemoveModifierByNameAndCaster("modifier_Advanced_Bulwark_mars_talent", self:GetCaster())
	end
	
end






--------------------------------------------------------------------------------
modifier_Advanced_Bulwark = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Bulwark:IsHidden()return false end
function modifier_Advanced_Bulwark:IsDebuff()return false end
function modifier_Advanced_Bulwark:IsStunDebuff()return false end
function modifier_Advanced_Bulwark:IsPurgable() 		return false end
function modifier_Advanced_Bulwark:IsPurgeException() 	return false end
function modifier_Advanced_Bulwark:RemoveOnDeath()  return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Bulwark:OnCreated( kv )
	-- references
	self.advanced_level = self:GetAbility().advanced_level
	self.reduction_front = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = self:GetAbility():GetSpecialValueFor( "forward_angle" )/2
	self.angle_side = self:GetAbility():GetSpecialValueFor( "side_angle" )/2
	self.bangbangchance = self:GetAbility():GetSpecialValueFor("bangbangchance")
	self.hp_accumul = self:GetAbility():GetSpecialValueFor("hp_accumul")
	self.mul_index = self:GetAbility():GetSpecialValueFor("mul_index")
	if IsServer() then
		self.parent = self:GetParent()
		if self.parent:GetUnitName()=="npc_dota_hero_mars" then
			self.mars = true
		end
	end
end

function modifier_Advanced_Bulwark:OnRefresh( kv )
	-- references
	self.advanced_level = self:GetAbility().advanced_level
	-- print(self.advanced_level)
	self.reduction_front =-self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" ) 
	self.reduction_side = -self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = (self:GetAbility():GetSpecialValueFor( "forward_angle" ))/2
	self.angle_side = (self:GetAbility():GetSpecialValueFor( "side_angle" ))/2
	self.bangbangchance = self:GetAbility():GetSpecialValueFor("bangbangchance")
	self.hp_accumul = self:GetAbility():GetSpecialValueFor("hp_accumul")
	self.mul_index = self:GetAbility():GetSpecialValueFor("mul_index")
end

function modifier_Advanced_Bulwark:OnRemoved()
end

function modifier_Advanced_Bulwark:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Bulwark:DeclareFunctions()
	local funcs = {
		-- MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

-- function modifier_Advanced_Bulwark:GetModifierPhysical_ConstantBlock( keys )
-- 	-- cancel if from ability
-- 	if keys.inflictor then return 0 end

-- 	-- cancel if break
-- 	if keys.target:PassivesDisabled() then return 0 end

-- 	-- get data
-- 	local parent = keys.target
-- 	local attacker = keys.attacker
-- 	local reduction = 0
-- 	--数值不一样就去更新一下数值
-- 	if self.advanced_level~=self:GetAbility().advanced_level then
-- 		self:OnRefresh()
-- 	end

-- 	-- Check target position
-- 	local facing_direction = parent:GetAnglesAsVector().y
-- 	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
-- 	local attacker_direction = VectorToAngles( attacker_vector ).y
-- 	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

-- 	local double_chance = 40
-- 	--LV5解锁赫菲斯托斯之福佑+
-- 	if self.advanced_level>=5 then
-- 		double_chance = 60
-- 	end

-- 	local side_angle = self.angle_side
-- 	if self.advanced_level>=15 and parent:GetHealthPercent()<=40 then
-- 		side_angle = 360
-- 	end

-- 	-- calculate damage reduction
-- 	--正面
-- 	if angle_diff < self.angle_front then
		
-- 		reduction = self.reduction_front
-- 		if self:GetCaster():GetRandomEffect(double_chance,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( true)

-- 		--lV20解锁赎罪
-- 		if self.advanced_level>=20 then
-- 			attacker:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Bulwark_guilt", {duration = 10})
-- 		end

-- 	--侧面
-- 	elseif angle_diff < side_angle then
-- 		reduction = self.reduction_side
-- 		if double_chance>=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( false)
-- 	end

-- 	return reduction*keys.damage/100
-- end
--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_Bulwark:PlayEffects( front )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"

	if not front then
		particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		sound_cast = "Hero_Mars.Shield.BlockSmall"
	end
	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	if self.mars then
		self.parent:StartGestureWithPlaybackRate(ACT_DOTA_OVERRIDE_ABILITY_2, 1.5)
	end
end


-- function modifier_Advanced_Bulwark:ADDeclareFunctions()
-- 	return {
-- 		MODIFIER_SPECIAL_CALCULATE_TOTAL_CONSTANT_BLOCK_HIGHT_LEVEL
-- 	}
-- end
-- function modifier_Advanced_Bulwark:AdvancedGetModifierTotal_ConstantBlock_HightLevel(keys)
-- 	if IsClient() then
-- 		return 0
-- 	end
-- 	if keys.block_disabled then
--         return 0 
--     end
-- 	if keys.inflictor then return 0 end
-- 	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
-- 		return 0
-- 	end

-- 	-- cancel if break
-- 	if keys.target:PassivesDisabled() then return 0 end

-- 	-- get data
-- 	local parent = keys.target
-- 	local attacker = keys.attacker
-- 	local reduction = 0
-- 	--数值不一样就去更新一下数值
-- 	if self.advanced_level~=self:GetAbility().advanced_level then
-- 		self:OnRefresh()
-- 	end

-- 	-- Check target position
-- 	local facing_direction = parent:GetAnglesAsVector().y
-- 	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
-- 	local attacker_direction = VectorToAngles( attacker_vector ).y
-- 	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

-- 	local double_chance = 40
-- 	--LV5解锁赫菲斯托斯之福佑+
-- 	if self.advanced_level>=5 then
-- 		double_chance = 60
-- 	end

-- 	local side_angle = self.angle_side
-- 	if self.advanced_level>=15 and parent:GetHealthPercent()<=40 then
-- 		side_angle = 360
-- 	end

-- 	-- calculate damage reduction
-- 	--正面
-- 	if angle_diff < self.angle_front then
		
-- 		reduction = self.reduction_front
-- 		if self:GetCaster():GetRandomEffect(double_chance,INT_TYPE,1) >=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( true)

-- 		--lV20解锁赎罪
-- 		if self.advanced_level>=20 then
-- 			attacker:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Bulwark_guilt", {duration = 10})
-- 		end

-- 	--侧面
-- 	elseif angle_diff < side_angle then
-- 		reduction = self.reduction_side
-- 		if double_chance>=RandomInt(1, 100) then
-- 			reduction = reduction * 2
-- 		end
-- 		self:PlayEffects( false)
-- 	end

-- 	return reduction*keys.damage/100
-- end

function modifier_Advanced_Bulwark:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
					advanced_MODIFIER_PROPERTY_FALSE_DEATH_MUL_EFFECT,}
	return funcs
end
function modifier_Advanced_Bulwark:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return 0
	end
	if keys.inflictor then return 0 end
	if keys.damage_type~=DAMAGE_TYPE_PHYSICAL  then
		return 0
	end

	-- cancel if break
	if keys.target:PassivesDisabled() then return 0 end

	-- get data
	local parent = keys.target
	local attacker = keys.attacker
	local reduction = 0
	--数值不一样就去更新一下数值
	if self.advanced_level~=self:GetAbility().advanced_level then
		self:OnRefresh()
	end

	-- Check target position
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	local double_chance = 40
	--LV5解锁赫菲斯托斯之福佑+
	if self.advanced_level>=5 then
		double_chance = 60
	end

	local side_angle = self.angle_side
	if self.advanced_level>=15 and parent:GetHealthPercent()<=40 then
		side_angle = 360
	end

	-- calculate damage reduction
	--正面
	if angle_diff < self.angle_front then
		
		reduction = self.reduction_front
		if double_chance >=RandomInt(1, 100) then
			reduction = reduction * 2
		end
		self:PlayEffects( true)

		--lV20解锁赎罪
		if self.advanced_level>=20 then
			attacker:AddNewModifier(parent, self:GetAbility(), "modifier_Advanced_Bulwark_guilt", {duration = 10})
		end

	--侧面
	elseif angle_diff < side_angle then
		reduction = self.reduction_side
		if double_chance>=RandomInt(1, 100) then
			reduction = reduction * 2
		end
		self:PlayEffects( false)
	end

	--同普通部分
	local ability = self:GetAbility()
	local hp_need = self:GetParent():GetMaxHealth()*self.hp_accumul/100
	ability.damage = keys.damage*reduction/100*(-1) + (ability.damage or 0)
	print("check damage:",ability.damage,",hp_need:",hp_need,",cdcheck:",self.DeathAgainCD)
	self.DeathAgainCD = self.DeathAgainCD or false
	if ability.damage >= hp_need and (self.DeathAgainCD == false) then 
		ability.damage = 0
		local table = {
			mulEffect = true,
			multiTrigger = true,
			unit = self:GetParent(),
			modifier = self,
			ability = self:GetAbility()
		}
		FireDeathAgainEvent(table)
		self.DeathAgainCD = true
		Timers:CreateTimer(3,function()
			self.DeathAgainCD = false
		end)	
		--print("正常触发")
		if self:GetParent():HasModifier("modifier_steady") then
			local modifier_origin =  self:GetParent():FindModifierByName("modifier_steady")
			modifier_origin:SetStackCount(min(modifier_origin:GetStackCount()+1, 15))
		else
			local modifier_origin = self:GetParent():AddNewModifier(self:GetParent(),self:GetAbility(),"modifier_steady",{duration = -1})
			modifier_origin:SetStackCount(1)
		end
		
	end
	return math.max(reduction,-99)
end


function modifier_Advanced_Bulwark:Advanced_GetFalseDeathMulEffect( keys )
	if self.mul_index then
		return self.mul_index
	end
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations


function modifier_Advanced_Bulwark:OnAttackLanded( keys )
    if not IsServer() then return end
    if keys.target~=self:GetCaster() then return end  --如果被打的不是本人
    if keys.inflictor then return end --如果是技能造成的攻击
    if self:GetCaster():PassivesDisabled() then return end  --如果被破坏
	local parent = keys.target
	local attacker = keys.attacker
	local ability = self:GetAbility()
	if ability.unlock2  then
		local Advanced_Gods_Rebuke = parent:FindAbilityByName("Advanced_Gods_Rebuke")
		if ability:IsCooldownReady() and  Advanced_Gods_Rebuke and parent:GetRandomEffect(10,INT_TYPE,1)>=RandomInt(1, 100) then
			local pos = attacker:GetAbsOrigin()
			if pos==parent:GetAbsOrigin() then
				pos = pos + parent:GetForwardVector()
			end
			parent:SetCursorPosition(pos)
            Advanced_Gods_Rebuke:OnSpellStart()
			ability:StartCooldown(2)

		end
	end


	if not keys.ranged_attack then return end	--如果不是远程攻击

	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	if not (angle_diff < self.angle_front*2) then return end	--不是正面攻击
	if self:GetCaster():GetRandomEffect(self.bangbangchance,INT_TYPE,1) >=RandomInt(1,100) then return end	
	

	local projname = keys.attacker:GetRangedProjectileName()
	ability.projdamage = keys.damage	

	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE 用了everywhere就是全图单位
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter 或者从远到近，或者随机单位
		false	-- bool, can grow cache
	)
	if #enemies<1 then return end	
									
	self.bangtarget = enemies[1]

	local info =
	{
		Target = self.bangtarget,
		Source = self:GetParent(),
		Ability =ability,
		EffectName = projname,
		iMoveSpeed = 2000,
		vSourceLoc = self:GetParent():GetAbsOrigin(),
		bDrawsOnMinimap = false,
		bDodgeable = true,
		bIsAttack = true,
		bVisibleToEnemies = true,
		bReplaceExisting = false,
		flExpireTime = GameRules:GetGameTime() + 10,
		bProvidesVision = false,
	}

	ProjectileManager:CreateTrackingProjectile(info)

end




modifier_Advanced_Bulwark_guilt = advanced_modifier({})

function modifier_Advanced_Bulwark_guilt:IsDebuff() return true end
function modifier_Advanced_Bulwark_guilt:IsHidden() return false end
function modifier_Advanced_Bulwark_guilt:IsPurgable() return false end
function modifier_Advanced_Bulwark_guilt:OnCreated(keys)
	if IsServer() then
		self.bonus = 0.6
		self.max = 50
		self:IncrementStackCount()
	end
end
function modifier_Advanced_Bulwark_guilt:OnRefresh(keys)
	if IsServer() then

		if self:GetAbility().unlock3 then
			self.max = 300
			self.bonus = 1

			self:SetStackCount(math.min(self:GetStackCount()+2,self.max))
		else
			self:SetStackCount(math.min(self:GetStackCount()+1,self.max))
		end
	
		
	end
end

function modifier_Advanced_Bulwark_guilt:GetModifierIncomingDamage_Percentage(keys)
	if IsClient() then
		return
	end
	local stack = self:GetStackCount()
	if stack>50 then
		return stack
	end
	if keys.attacker:HasAbility("Advanced_Bulwark") then
		local level = keys.attacker:FindAbilityByName("Advanced_Bulwark"):GetSpecialValueFor("advanced_level")
		if level>=20 then
			return self.bonus*self:GetStackCount()
		end
	end
	return 0 
end


function modifier_Advanced_Bulwark_guilt:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end




modifier_Advanced_Bulwark_unlock1 = class({})

function modifier_Advanced_Bulwark_unlock1:IsDebuff()			return false end
function modifier_Advanced_Bulwark_unlock1:IsHidden() 			return true end
function modifier_Advanced_Bulwark_unlock1:IsPurgable() 		return false end
function modifier_Advanced_Bulwark_unlock1:IsPurgeException() 	return false end
function modifier_Advanced_Bulwark_unlock1:RemoveOnDeath() return false end
function modifier_Advanced_Bulwark_unlock1:OnCreated(keys)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end

function modifier_Advanced_Bulwark_unlock1:OnIntervalThink()
	local effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/bulwark/unlock1/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
















--------------------------------------------------------------------------------
modifier_Advanced_Bulwark_mars_talent = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Bulwark_mars_talent:IsHidden()return true end
function modifier_Advanced_Bulwark_mars_talent:IsDebuff()return false end
function modifier_Advanced_Bulwark_mars_talent:IsStunDebuff()return false end
function modifier_Advanced_Bulwark_mars_talent:IsPurgable() 		return false end
function modifier_Advanced_Bulwark_mars_talent:IsPurgeException() 	return false end
function modifier_Advanced_Bulwark_mars_talent:RemoveOnDeath()  return false end
function modifier_Advanced_Bulwark_mars_talent:OnRemoved()
end

function modifier_Advanced_Bulwark_mars_talent:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Bulwark_mars_talent:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}

	return funcs
end

function modifier_Advanced_Bulwark_mars_talent:GetModifierPhysical_ConstantBlock( keys )
	-- cancel if from ability
	if keys.inflictor then return 0 end
	-- cancel if break
	if keys.target:PassivesDisabled() then return 0 end
	local parent = keys.target
	local attacker = keys.attacker
	local facing_direction = parent:GetAnglesAsVector().y
	local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
	local attacker_direction = VectorToAngles( attacker_vector ).y
	local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ))

	-- calculate damage reduction
	if angle_diff < 37.5 then
		self:CheckTrigger()
	end

	return 0
end

function modifier_Advanced_Bulwark_mars_talent:CheckTrigger()

	if 18>=RandomInt(1, 100) then
		local ability = self:FindTalentAbility()
		if ability:IsCooldownReady() then
			local rebuke = self:FindGodsRebukeAbility()
			if rebuke then
				local caster = self:GetCaster()
				caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_4, 5)
				rebuke:TalentEffect(caster:GetOrigin()+caster:GetForwardVector()*100)
				ability:UseResources(true, true, true, true)
			end
		end
	end
end
function modifier_Advanced_Bulwark_mars_talent:FindTalentAbility()
	if self.talent then
		return self.talent
	end
	self.talent = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_mars_2")
	return self.talent
end
function modifier_Advanced_Bulwark_mars_talent:FindGodsRebukeAbility()
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else
		self.ability = self:GetCaster():FindAbilityByName("Advanced_Gods_Rebuke")
		if not self.ability then
			self.ability = self:GetCaster():FindAbilityByName("Middle_Gods_Rebuke")
			if not self.ability then
				self.ability = self:GetCaster():FindAbilityByName("Primary_Gods_Rebuke")
			end
		end
	end
	if self.ability and not self.ability:IsNull() then
		return self.ability
	else	
		return nil
	end
end

function modifier_Advanced_Bulwark_mars_talent:GetActivityTranslationModifiers()
	return "bulwark"
end

function modifier_Advanced_Bulwark_mars_talent:GetModifierDisableTurning()
	return 1
end
function modifier_Advanced_Bulwark_mars_talent:GetModifierIgnoreCastAngle()
    return 1
end

function modifier_Advanced_Bulwark_mars_talent:CheckState()
	local state = {[MODIFIER_STATE_DISARMED] = true}
	


	return state
end