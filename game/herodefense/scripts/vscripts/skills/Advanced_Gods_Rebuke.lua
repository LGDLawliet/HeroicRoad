--特效优化 √
Advanced_Gods_Rebuke = class({})
LinkLuaModifier( "modifier_Advanced_Gods_Rebuke", "skills/Advanced_Gods_Rebuke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imgeneric_knockback_lua", "modifier/modifier_imgeneric_knockback_lua", LUA_MODIFIER_MOTION_BOTH )



LinkLuaModifier( "modifier_Advanced_Gods_Rebuke_debuff_block_disable", "skills/Advanced_Gods_Rebuke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Gods_Rebuke_debuff_stone", "skills/Advanced_Gods_Rebuke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_Advanced_Gods_Rebuke_unlock3_effect", "skills/Advanced_Gods_Rebuke", LUA_MODIFIER_MOTION_NONE)

require('internal/timers')   --计时器功能
function Advanced_Gods_Rebuke:UnlockFirstCore(key)
	return true
end
function Advanced_Gods_Rebuke:UnlockSecondCore(key)
	return true
end
function Advanced_Gods_Rebuke:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_Gods_Rebuke_unlock3_effect", {})
	return true
end

function Advanced_Gods_Rebuke:GetBehavior()

	if self:GetUnlock(3)==3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
	return self.BaseClass.GetBehavior(self)
end

function Advanced_Gods_Rebuke:CheckKV(key)
	local table = {

		bonus_damage = 8,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Gods_Rebuke:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", context )

	PrecacheResource( "particle", "particles/indicator/range_finder_aoe.vpcf", context )

	
end
function Advanced_Gods_Rebuke:GetCooldown(iLevel)
	if self:GetUnlock(3)==3 then
		return 3
	end
	return self.BaseClass.GetCooldown(self,iLevel)
end


function Advanced_Gods_Rebuke:IsHiddenWhenStolen()return false end
function Advanced_Gods_Rebuke:IsStealable()return true end
function Advanced_Gods_Rebuke:IsNetherWardStealable()return false end
function Advanced_Gods_Rebuke:IsRefreshable()return true end
function Advanced_Gods_Rebuke:GetCastRange()
	if IsServer() then
		return 30000
	end
	if IsClient() then
		local radius = self:GetSpecialValueFor( "radius" ) - self:GetCaster():GetCastRangeBonus()
		if self:GetUnlock(2)==2 then
			radius = radius +200
		end
		return radius  --这个技能不吃施法距离加成
	end
 end
--------------------------------------------------------------------------------
-- Custom Indicator
--创造
--也许你查看这个技能的代码是为了看如何产生一个指示器特效
--说明将从本行开始
--由于特效需要利用modifier产生 所以首先我们需要创建modifier  跳转到下面的函数继续阅读
function Advanced_Gods_Rebuke:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end


----当modifier被创建后 OnCreated()会将父类（本技能）的custom_indicator设置为该状态
--本函数得以进行  确认到custom_indicator存在后，当你点开施法后 该函数会调用modifier的Register( vLoc )功能，传入当前鼠标的位置 跳转到modifier的Register( vLoc )继续阅读
--值得一提的是 这个函数当你按下技能后会不断调用（应该是每帧一次）你可以把下面的print函数打开自己查看
--所以Register( vLoc )函数会不断调用
function Advanced_Gods_Rebuke:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
			-- print("diao yong")
		end
	end

	-- check nohammer
	--这个是判断是不是锤子丢出去的 这个技能里不需要 注释掉了
	-- if self:GetCaster():HasModifier( "modifier_dawnbreaker_celestial_hammer_lua_nohammer" ) then
	-- 	return UF_FAIL_CUSTOM
	-- end

	if not IsServer() then return end

	return UF_SUCCESS
end

--指示器，一个圆
--从modifier传来指令 现在终于开始创建特效了 回想一下Register( vLoc )函数 你会发现由于init变成true了 所以只会执行一次
--返回Register( vLoc )函数继续阅读
function Advanced_Gods_Rebuke:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone_dual.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self.effect_cast2 = ParticleManager:CreateParticle( "particles/indicator/range_finder_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

--这里会是指示器的更新 还是一样 loc是你的鼠标位置 根据你鼠标的位置与你角色的位置两个作弊计算矢量坐标 当然你得把z变成0 不然它会是向上的
--接下来计算距离 这个需要获取你技能的kv 具体如何计算看自己 这个技能由于有移动速度与作用范围等等变量 自行参考即可
--最后更新一下特效的控制点就完成了 好了 返回Register( vLoc )函数继续阅读
function Advanced_Gods_Rebuke:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local radius = self:GetCastRange()+20

	-- local distance = 300

	-- local direction = loc - origin
	-- direction.z = 0
	-- direction = direction:Normalized()
	local newpos1 = RotatePosition(origin, QAngle(0, 60, 0), loc)
	local pfxdirection1 = (newpos1-origin):Normalized()
	local newpos2 = RotatePosition(origin, QAngle(0, -60, 0), loc)
	local pfxdirection2 = (newpos2-origin):Normalized()

	-- ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin)
	ParticleManager:SetParticleControl( self.effect_cast, 7, origin+ pfxdirection1*radius)
	ParticleManager:SetParticleControl( self.effect_cast, 8, origin+ pfxdirection2*radius)
	ParticleManager:SetParticleControl( self.effect_cast, 3, Vector(50,50,0))

	ParticleManager:SetParticleControl( self.effect_cast2, 1, origin)
	ParticleManager:SetParticleControl( self.effect_cast2, 3, Vector(radius,0,0))
end

function Advanced_Gods_Rebuke:DestroyCustomIndicator()
	-- print("xiao hui")

	ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	ParticleManager:DestroyParticle( self.effect_cast2, true ) 
	
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
end


--------------------------------------------------------------------------------
-- Ability Start
function Advanced_Gods_Rebuke:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()


	-- load data
	local radius = self:GetSpecialValueFor( "radius" ) - self:GetCaster():GetCastRangeBonus()
		if self:GetUnlock(2)==2 then
			radius = radius +200
		end
	local radius = radius
	local chance = self:GetSpecialValueFor("chance")
	if caster:GetHealthPercent() <= self:GetSpecialValueFor("line") then
		chance = 100
	end
	--LV5触发两面开盾+
	if self.advanced_level>=5 then
		chance = 100
	end
	local angle = chance >= math.random(1,100) and 180 or self:GetSpecialValueFor("angle")/2	--概率环形盾击
	local is360 = false

	if angle == 180 then is360 = true end	--是否触发环形特效
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord =caster:AddAttackEffectModifier(self,modifier_keys)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- 添加加成modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Gods_Rebuke", -- modifier name
		{  } -- kv
	)

	-- 角度计算
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()

		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

		if angle_diff<=angle then

			--击退
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_imgeneric_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)

			--添加负面状态
			--LV15解锁粉碎击 
			if self.advanced_level>=15 then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_Gods_Rebuke_debuff_block_disable", -- modifier name
					{ duration =5 } -- kv
				)
			end
			--LV20解锁石化
			if self.advanced_level>=20 then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_Gods_Rebuke_debuff_stone", -- modifier name
					{ duration =1 } -- kv
				)
			end
	


			caught = true
			-- 攻击
			self:PlayEffects2( enemy, origin, cast_direction )
				caster:PerformAttack(
					enemy,
					true,
					true,
					true,
					true,
					false,
					false,
					true
				)


		end
	end
	buff:SafeDestroy() --移除加成
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	self:PlayEffects1( caught, (point-origin):Normalized() )
	local pfxdirection = (point-origin):Normalized()
	if is360 then	--触发环形特效
		local newpos1 = RotatePosition(origin, QAngle(0, 120, 0), point)
		local pfxdirection1 = (newpos1-origin):Normalized()
		self:PlayEffects1( caught, pfxdirection1 )
		local newpos2 = RotatePosition(origin, QAngle(0, 120, 0), newpos1)
		local pfxdirection2 = (newpos2-origin):Normalized()
		self:PlayEffects1( caught, pfxdirection2 )
	end

	if self.unlock1 then
		local pos = origin+caster:GetForwardVector()*150
		Timers:CreateTimer(0.25, function()
			self:Unlock1(0, cast_direction,pos)
		end)
		
	end

end

--------------------------------------------------------------------------------
-- Play Effects
function Advanced_Gods_Rebuke:PlayEffects1( caught, direction,pos )
	-- Get Resources


	
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"	--"particles/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf"
	if self.unlock2 then
		particle_cast = "particles/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf"
	end
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	local loc = pos or  self:GetCaster():GetOrigin()
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	--ParticleManager:SetParticleControl( effect_cast, 1, Vector(1000,1000,1000) )CP1可以调整大小
	--ParticleManager:SetParticleControl( effect_cast, 60, Vector(0,0,205) )CP60调整颜色
	--ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )CP61X轴颜色开关
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( loc, sound_cast, self:GetCaster() )
end

function Advanced_Gods_Rebuke:PlayEffects2( target, origin, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash_crit.vpcf"
	local sound_cast = "Hero_Mars.Shield.Crit"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, target )
	ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetOrigin() )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function Advanced_Gods_Rebuke:Unlock1(count, direction,pos)
	count = count + 1
	if count<=7 then
		self:SingleSpellEffect( direction,pos )
		Timers:CreateTimer(0.25, function()
			self:Unlock1(count, direction,pos+direction*150)
		end)
	end

end
function Advanced_Gods_Rebuke:SingleSpellEffect( direction,pos )
	
	local caster = self:GetCaster()
	local radius = self:GetCastRange()
	local angle =self:GetSpecialValueFor("angle")/2	
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord =caster:AddAttackEffectModifier(self,modifier_keys)

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		pos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- 添加加成modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Gods_Rebuke", -- modifier name
		{  } -- kv
	)

	-- 角度计算
	local origin = pos
	local cast_direction = direction
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	local stone_duration = 1
	if self.unlock2 then
		stone_duration = 1.5
	end
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()

		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

		if angle_diff<=angle then

			--击退
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_imgeneric_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)

			enemy:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_Gods_Rebuke_debuff_block_disable", -- modifier name
				{ duration =5 } -- kv
			)
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_Gods_Rebuke_debuff_stone", -- modifier name
					{ duration = stone_duration } -- kv
			)
	


			caught = true
			-- 攻击
			self:PlayEffects2( enemy, origin, cast_direction )
			caster:PerformAttack(
				enemy,
				true,
				true,
				true,
				true,
				false,
				false,
				true
			)


		end
	end
	buff:SafeDestroy() --移除加成
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	self:PlayEffects1( caught, direction,pos )
end
function Advanced_Gods_Rebuke:TalentEffect(pos)
	local caster = self:GetCaster()
	local point = pos
	local radius = self:GetCastRange()
	local angle =self:GetSpecialValueFor("angle")/2	--概率环形盾击
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord =caster:AddAttackEffectModifier(self,modifier_keys)
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- 添加加成modifier
	local buff = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Gods_Rebuke", -- modifier name
		{  } -- kv
	)

	-- 角度计算
	local origin = caster:GetOrigin()
	local cast_direction = (point-origin):Normalized()
	local cast_angle = VectorToAngles( cast_direction ).y

	-- for each units
	local caught = false
	for _,enemy in pairs(enemies) do
		-- check within cast angle
		local enemy_direction = (enemy:GetOrigin() - origin):Normalized()

		local enemy_angle = VectorToAngles( enemy_direction ).y
		local angle_diff = math.abs( AngleDiff( cast_angle, enemy_angle ) )

		if angle_diff<=angle then

			--击退
			enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_imgeneric_knockback_lua", -- modifier name
					{
						duration = duration,
						distance = distance,
						height = 30,
						direction_x = enemy_direction.x,
						direction_y = enemy_direction.y,
					} -- kv
				)

			--添加负面状态
			--LV15解锁粉碎击 
			if self.advanced_level>=15 then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_Gods_Rebuke_debuff_block_disable", -- modifier name
					{ duration =5 } -- kv
				)
			end
			--LV20解锁石化
			if self.advanced_level>=20 then
				enemy:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_Gods_Rebuke_debuff_stone", -- modifier name
					{ duration =1 } -- kv
				)
			end
	


			caught = true
			-- 攻击
			self:PlayEffects2( enemy, origin, cast_direction )
				caster:PerformAttack(
					enemy,
					true,
					true,
					true,
					true,
					false,
					false,
					true
				)


		end
	end
	buff:SafeDestroy() --移除加成
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	self:PlayEffects1( caught, (point-origin):Normalized() )

end




--------------------------------------------------------------------------------
modifier_Advanced_Gods_Rebuke = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Gods_Rebuke:IsHidden()return true end
function modifier_Advanced_Gods_Rebuke:IsDebuff()return false end
function modifier_Advanced_Gods_Rebuke:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Gods_Rebuke:OnCreated( kv )
	-- references
	if IsServer() then
		local ability =self:GetAbility()
		local caster =self:GetCaster()
		self.str_crit = ability:GetSpecialValueFor("str_crit")
		self.bonus_crit = ability:GetSpecialValueFor( "bonus_damage" ) + self.str_crit*caster:GetStrength()
		--LV10解锁战神怒火+
		if ability.advanced_level>=10 then
			if caster:GetStrength()>=800 then
				self.bonus_crit=self.bonus_crit+200
			end
		end
	end
end
function modifier_Advanced_Gods_Rebuke:Advanced_GetModifierCriticalStrike( keys )
	return self.bonus_crit
end
function modifier_Advanced_Gods_Rebuke:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end


modifier_Advanced_Gods_Rebuke_debuff_block_disable = advanced_modifier({})

function modifier_Advanced_Gods_Rebuke_debuff_block_disable:IsDebuff() return true end
function modifier_Advanced_Gods_Rebuke_debuff_block_disable:IsHidden() return false end
function modifier_Advanced_Gods_Rebuke_debuff_block_disable:IsPurgable() return true end


-- function modifier_Advanced_Gods_Rebuke_debuff_block_disable:CheckState()
-- 	local state = {
-- 		[MODIFIER_STATE_BLOCK_DISABLED]=true,

-- 	}
	

-- 	return state
-- end

function modifier_Advanced_Gods_Rebuke_debuff_block_disable:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_TOTALBLOCK_CONSTANT_DISABLE,
	}
end


function modifier_Advanced_Gods_Rebuke_debuff_block_disable:Advanced_GetModifierTotalBlockConstantDisable(keys)
    return 1
end





--LV20
modifier_Advanced_Gods_Rebuke_debuff_stone = advanced_modifier({})

function modifier_Advanced_Gods_Rebuke_debuff_stone:IsDebuff() return true end
function modifier_Advanced_Gods_Rebuke_debuff_stone:IsHidden() return false end
function modifier_Advanced_Gods_Rebuke_debuff_stone:IsPurgable() return false end
function modifier_Advanced_Gods_Rebuke_debuff_stone:IsPurgeException() return true end
function modifier_Advanced_Gods_Rebuke_debuff_stone:OnCreated(keys)
	self.bonus = 20
	if self:GetAbility():GetUnlock(2)==2 then
		self.bonus = 200
	end
end

function modifier_Advanced_Gods_Rebuke_debuff_stone:GetStatusEffectName() return "particles/status_fx/status_effect_medusa_stone_gaze.vpcf" end
-- function modifier_Advanced_Gods_Rebuke_debuff_stone:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end


function modifier_Advanced_Gods_Rebuke_debuff_stone:ADDeclareFunctions()
	return {
		advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end


function modifier_Advanced_Gods_Rebuke_debuff_stone:Advanced_GetModifierIncomingDamage_Percentage(keys)
	if IsServer() then
		if keys.damage_type==DAMAGE_TYPE_PHYSICAL then
			return self.bonus 
		end
	end
	return 0
end

function modifier_Advanced_Gods_Rebuke_debuff_stone:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}
	

	return state
end






modifier_Advanced_Gods_Rebuke_unlock3_effect = class({})


function modifier_Advanced_Gods_Rebuke_unlock3_effect:IsHidden()	return true end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:IsDebuff()	return false end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:IsStunDebuff()	return false end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:RemoveOnDeath()	return false end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:DestroyOnExpire()	return false end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:IsPurgable() 		return false end
function modifier_Advanced_Gods_Rebuke_unlock3_effect:IsPurgeException() 	return false end

function modifier_Advanced_Gods_Rebuke_unlock3_effect:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
end



function modifier_Advanced_Gods_Rebuke_unlock3_effect:OnAttackLanded(keys)
	if not IsServer()  or self:GetParent():IsIllusion()  or keys.attacker ~=self:GetParent() then
		return
	end
	local ability = self:GetAbility()
	local caster = self:GetParent()
	if not caster:IsApplyModifier() or caster:IsInSpecialAttack()  then
		return
	end
	if not ability:IsCooldownReady() then
		return
	end
	if not keys.target or keys.target:IsNull() then
		return
	end
	if not keys.target:IsAlive() or keys.target:IsMagicImmune() then
		return
	end

	ability:UseResources(true, true, true, true)
	caster:SetCursorPosition(keys.target:GetAbsOrigin())

	ability:OnSpellStart()


	
end