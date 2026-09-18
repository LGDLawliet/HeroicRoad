Advanced_Starbreaker = class({})
--特效优化 √
LinkLuaModifier( "modifier_Advanced_Starbreaker", "skills/Advanced_Starbreaker", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_dawnbreaker_starbreaker_buff", "skills/Advanced_Starbreaker", LUA_MODIFIER_MOTION_HORIZONTAL )

LinkLuaModifier( "modifier_generic_stunned_lua", "modifier/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--星体破坏
LinkLuaModifier("modifier_dawnbreaker_starbreaker_debuff", "skills/Advanced_Starbreaker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_Advanced_Starbreaker_unlock3", "skills/Advanced_Starbreaker", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Init Abilities

function Advanced_Starbreaker:CheckKV(key)
	local table = {
		swipe_radius=5,
		swipe_attack=10,
		smash_attack=20,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Starbreaker:Spawn()
	if not IsServer() then return end
end

function Advanced_Starbreaker:UnlockFirstCore(key)
	return true
end
function Advanced_Starbreaker:UnlockSecondCore(key)
	return true
end
function Advanced_Starbreaker:UnlockThirdCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster,self,"modifier_Advanced_Starbreaker_unlock3",{})
	return true
end




--------------------------------------------------------------------------------
-- Custom Indicator
--创造
--也许你查看这个技能的代码是为了看如何产生一个指示器特效
--说明将从本行开始
--由于特效需要利用modifier产生 所以首先我们需要创建modifier  跳转到下面的函数继续阅读
function Advanced_Starbreaker:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end

----当modifier被创建后 OnCreated()会将父类（本技能）的custom_indicator设置为该状态
--本函数得以进行  确认到custom_indicator存在后，当你点开施法后 该函数会调用modifier的Register( vLoc )功能，传入当前鼠标的位置 跳转到modifier的Register( vLoc )继续阅读
--值得一提的是 这个函数当你按下技能后会不断调用（应该是每帧一次）你可以把下面的print函数打开自己查看
--所以Register( vLoc )函数会不断调用
function Advanced_Starbreaker:CastFilterResultLocation( vLoc )
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



-- function Advanced_Starbreaker:GetCustomCastErrorLocation( vLoc )
-- 	-- check nohammer
-- 	if IsServer() then
-- 		local caster = self:GetCaster()
-- 		if caster:IsRooted() then
-- 			return "dota_hud_rooted" 
-- 		end

-- 		return ""
-- 	end

-- end

--指示器，一个圆
--从modifier传来指令 现在终于开始创建特效了 回想一下Register( vLoc )函数 你会发现由于init变成true了 所以只会执行一次
--返回Register( vLoc )函数继续阅读
function Advanced_Starbreaker:CreateCustomIndicator()
	-- local particle_cast = "particles/units/heroes/hero_dawnbreaker/hero_dawnbreaker_combo_strike_range_finder_aoe.vpcf"
	local particle_cast = "particles/new_effect/indicator/indicator_range_finder_aoe.vpcf"
	
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

--这里会是指示器的更新 还是一样 loc是你的鼠标位置 根据你鼠标的位置与你角色的位置两个作弊计算矢量坐标 当然你得把z变成0 不然它会是向上的
--接下来计算距离 这个需要获取你技能的kv 具体如何计算看自己 这个技能由于有移动速度与作用范围等等变量 自行参考即可
--最后更新一下特效的控制点就完成了 好了 返回Register( vLoc )函数继续阅读
function Advanced_Starbreaker:UpdateCustomIndicator( loc )
	local advanced_level = self:GetSpecialValueFor("advanced_level")


	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local radius = (self:GetSpecialValueFor( "swipe_radius" ) +5*advanced_level)*0.6
	-- print(radius)
	local speed = self:GetSpecialValueFor( "movement_speed" )
	local duration = self:GetSpecialValueFor( "duration" )
	local delta = self:GetSpecialValueFor( "smash_distance_from_hero" )
	local distance = speed * duration + delta
	
	-- get direction
	local direction = loc - origin
	direction.z = 0
	direction = direction:Normalized()

	ParticleManager:SetParticleControl( self.effect_cast, 0, origin )
	ParticleManager:SetParticleControl( self.effect_cast, 1, origin + direction*distance )
	ParticleManager:SetParticleControl( self.effect_cast, 2, Vector( radius, radius, radius) )
end

function Advanced_Starbreaker:DestroyCustomIndicator()

	ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

--------------------------------------------------------------------------------
-- Ability Cast Filter
--当没有锤子的时候不能释放 当然 由于我们是自定义技能 并不需要这个东西 注释掉
-- function Advanced_Starbreaker:GetCustomCastErrorLocation( vLoc )
-- 	-- check nohammer
-- 	if self:GetCaster():HasModifier( "modifier_dawnbreaker_celestial_hammer_lua_nohammer" ) then
-- 		return "#dota_hud_error_nohammer"
-- 	end

-- 	return ""
-- end

function Advanced_Starbreaker:CheckKV(key)
	local table = {
		swipe_radius = 5,
		swipe_attack = 10,
		smash_attack = 20,
	}
	local value = table[key] or -1
	return value

end

function Advanced_Starbreaker:OnSpellStart()

	-- unit identifier
	local caster = self:GetCaster()

	-- print("当前技能佩戴的特效")
	-- local type = particleManager:GetSpellParticle(caster:GetPlayerID(),self:GetAbilityName())
	-- print(type)



	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- get direction
	local direction = point-caster:GetOrigin()
	if direction:Length2D()<1 then
		direction = caster:GetForwardVector()
	else
		direction.z = 0
		direction = direction:Normalized()
	end

	if self.unlock1 then
		duration = 10
	end
	caster:AddNewModifier(caster, self, "modifier_Advanced_Starbreaker",{
		duration = duration,
		x = direction.x,
		y = direction.y,} 
	)
	caster:AddNewModifier(caster, self, "modifier_dawnbreaker_starbreaker_buff", {duration = 3,} )
	if self.unlock2 then
		local allies = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetOrigin(),nil,	400,DOTA_UNIT_TARGET_TEAM_FRIENDLY,	DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,0,FIND_CLOSEST,false)
		for _, unit in ipairs(allies) do
			unit:AddNewModifier(caster, self, "modifier_Advanced_Starbreaker",{
				duration = duration,
				x = direction.x,
				y = direction.y,} 
			)

		end
		
	end

	--高阶额外技能特效解锁LV5 振荡回响
	if self.advanced_level>=5 then
		local allies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		600,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO,	-- int, type filter
		0,	-- int, flag filter
		FIND_CLOSEST,	-- int, order filter
		false	-- bool, can grow cache
		)
		--由于最近的肯定是自己 那么就给第二个单位添加上即可
		if #allies>=2 then
			allies[2]:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_dawnbreaker_starbreaker_buff", -- modifier name
				{
					duration = 3,
				} -- kv
			)
		end
		
	end
	

end

function Advanced_Starbreaker:TalentEffect(target)
	local caster = self:GetCaster()
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Starbreaker", -- modifier name
		{
			duration = 0.01,
		}
	)
	if modifier then
		modifier:InitTalent(target)
	end
end

--------------------------------------------------------------------------------
modifier_Advanced_Starbreaker = modifier_Advanced_Starbreaker or class({})

require("internal/timers")

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_Starbreaker:IsHidden()return true end
function modifier_Advanced_Starbreaker:IsDebuff()return false end
function modifier_Advanced_Starbreaker:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Advanced_Starbreaker:OnCreated( kv )
	self.parent = self:GetParent()
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()

	self.damage_mul = self.ability:GetSpecialValueFor("damage_mul")-100


	if not IsServer() then return end
		-- references
		self.swipe_radius = self.ability:GetSpecialValueFor( "swipe_radius" ) 
		self.swipe_attack = self.ability:GetSpecialValueFor( "swipe_attack" ) 
		-- self.swipe_duration = self:GetAbility():GetSpecialValueFor( "sweep_stun_duration" )

		self.smash_radius = self.ability:GetSpecialValueFor( "swipe_radius" )
		self.smash_attack = self.ability:GetSpecialValueFor( "smash_attack" )
		self.smash_duration = self.ability:GetSpecialValueFor( "smash_stun_duration" )
		self.smash_distance = self.ability:GetSpecialValueFor( "smash_distance_from_hero" )

		self.selfstun = self.ability:GetSpecialValueFor( "self_stun_duration" )
		self.need = self.ability:GetSpecialValueFor( "attacks_change_bonus_index" )
		self.max = self.ability:GetSpecialValueFor( "max" )

		if self.parent:HasAbility("heroTalent_npc_dota_hero_dawnbreaker_2") then
			self.smash_attack = self.smash_attack*1.3
			self.swipe_attack = self.swipe_attack*1.3
			self.dawn_talent  = true
			local nFXIndex = ParticleManager:CreateParticle( "particles/items_fx/black_king_bar_avatar.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.caster )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.caster, PATTACH_POINT_FOLLOW, nil, self.caster:GetAbsOrigin(), true )
			self:AddParticle( nFXIndex, false, false, -1, true, false )
		end
		self.order = false
		self.advanced_level = self.ability.advanced_level
		


		self.speed = self.ability:GetSpecialValueFor( "movement_speed" )

		self.tree_radius = 100
		self.arc_height = 90
		self.arc_duration = 0.4
		
		self.base_attacks = self.ability:GetSpecialValueFor( "total_attacks" )
		if self.advanced_level >= 10 then
			self.base_attacks = 5
			self.need = 110
		end
		local bonus_attacks = self.caster:GetBaseDamageMax()/self.need
		self.attacks = math.min(self.base_attacks + (bonus_attacks-bonus_attacks%1), self.base_attacks+self.max)

		if self.ability.unlock1 then
			self.attacks = 30
		end
		if self.dawn_talent then
			self.attacks = self.attacks + 1
		end

		if not kv.x then
			self.forward = self:GetCaster():GetForwardVector()
			self.bonus = 0
			self.ctr = 0
			self.animation_rate = 1
			return
		end
		self.forward = Vector( kv.x, kv.y, 0 )
		self.bonus = 0
		self.ctr = 0
		local interval = self:GetDuration()/(self.attacks-1)-FrameTime()
		self.animation_rate = self:GetDuration()/interval

		-- apply forward motion
		self:ApplyHorizontalMotionController()

		-- Start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()
end

function modifier_Advanced_Starbreaker:OnRefresh( kv )
end

function modifier_Advanced_Starbreaker:OnRemoved()
end

function modifier_Advanced_Starbreaker:OnDestroy()
	if not IsServer() then return end
	self:GetParent():RemoveHorizontalMotionController( self )
	self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)  --淡入移除动作
	self:GetParent():FadeGesture(ACT_DOTA_CAST_ABILITY_1)
end
function modifier_Advanced_Starbreaker:InitTalent(target)
	self:Smash(target:GetOrigin())
	self:SafeDestroy()
end
--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_Starbreaker:GetOverrideAnimationRate()
	return self.animation_rate
end

function modifier_Advanced_Starbreaker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_SUPPRESS_CLEAVE,  --抑制分裂攻击
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}

	return funcs
end

function modifier_Advanced_Starbreaker:GetModifierDamageOutgoing_Percentage()
	if IsServer() then
		return self.damage_mul
	end
end





function modifier_Advanced_Starbreaker:OnOrder(keys)
	if not IsServer() then return end

	if keys.unit == self:GetParent() then

		if self:GetAbility().unlock1 then
			if keys.order_type==DOTA_UNIT_ORDER_HOLD_POSITION and not self.order   then
				self.order = true
				self.ctr =self.attacks
				self:Smash()
				self:SetDuration(0.0, true)

			end
		end

	


	end
end


--
function modifier_Advanced_Starbreaker:GetModifierPreAttack_BonusDamage()
	if not IsServer() then return 0 end

	return self.bonus
end

function modifier_Advanced_Starbreaker:GetSuppressCleave()
	return 1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_Starbreaker:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MUTED] = true,
		-- [MODIFIER_STATE_COMMAND_RESTRICTED] = true,  --忽略指令
	}
	if self.dawn_talent then
		state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	end


	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Starbreaker:OnIntervalThink()
	if not self:GetAbility()then
		self:SafeDestroy()
		return
	end
	if self.parent:IsStunned() then
		self:SafeDestroy()
		return
	end
	self.ctr = self.ctr + 1

	local random = math.random
	if self.ctr>=self.attacks then
		self:Smash()
	else
		--LV20解锁星连击
		if self.advanced_level>=20 and 22 >= random(1,100) then
			self:Swipe()
			if not self.ability:IsCooldownReady() then
				local newcooldown = self.ability:GetCooldownTimeRemaining() - 0.75
				self.ability:EndCooldown()
				self.ability:StartCooldown(newcooldown)
			end
		end
		self:Swipe()
	end
end

function modifier_Advanced_Starbreaker:Swipe()
	if self.dawn_talent then
		self:Smash()
		return
	end
	self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_1)
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.swipe_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = self.parent:AddAttackEffectModifier( self:GetAbility(),modifier_keys)
	for _,enemy in pairs(enemies) do
		-- attack
		self.bonus = self.swipe_attack --额外伤害
		
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )
		--Level15解锁星体破坏 破坏被动
		if self.advanced_level>=15 then
			enemy:AddNewModifier(
				self.parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_dawnbreaker_starbreaker_debuff", -- modifier name
				{ duration = 2 } -- kv
			)
		end

	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity" )
		local mod2 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity_buff" )

		if mod2 then
			mod2:SafeDestroy()
		elseif mod1 then
			mod1:Increment()
		end
	end

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end

function modifier_Advanced_Starbreaker:Smash(location)
	self:GetParent():StartGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
	local center = self.parent:GetOrigin() + self.forward*self.smash_distance
	if location then
		center = location
	end
	-- local has_crit_before = self.parent:HasModifier("modifier_Advanced_Luminosity_lua_buff")

	local search_radius = self.smash_radius

	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		center,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		search_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = self.parent:AddAttackEffectModifier( self:GetAbility(),modifier_keys)
	local ModifierStatusNegativeGain = self.parent:GetModifierStatusNegativeGainIndex(0.5)
	for _,enemy in pairs(enemies) do
		-- attack
		self.bonus = self.smash_attack
		self.parent:PerformAttack( enemy, true, true, true, true, false, false, true )

		-- stun
		if not enemy:IsMagicImmune() then
			local StatusResistance = enemy:GetHDStatusResistanceIndex(0.7) *ModifierStatusNegativeGain
			enemy:AddNewModifier(
				self.parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_stunned", -- modifier name
				{ duration = self.smash_duration * StatusResistance } -- kv
			)



			--敌人浮空 
			enemy:AddNewModifier(
				self.parent, -- player source
				self:GetAbility(), -- ability source
				"modifier_generic_arc_lua", -- modifier name
				{
					duration = self.arc_duration,   --浮空时间 这里是0.4秒
					height = self.arc_height,       --浮空高度 这里是90
					activity = ACT_DOTA_FLAIL,      --复写的动作
				} -- kv
			)

			--Level15解锁星体破坏 破坏被动
			if self.advanced_level>=15 then
				enemy:AddNewModifier(
					self.parent, -- player source
					self:GetAbility(), -- ability source
					"modifier_dawnbreaker_starbreaker_debuff", -- modifier name
					{ duration = 2 } -- kv
				)
			end

		end
	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	-- self stun5
	-- self.parent:AddNewModifier(
	-- 	self.parent, -- player source
	-- 	self:GetAbility(), -- ability source
	-- 	"modifier_stunned", -- modifier name
	-- 	{ duration = self.selfstun } -- kv
	-- )

	-- increment luminosity stack
	if #enemies>0 then
		local mod1 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity" )
		local mod2 = self.parent:FindModifierByName( "modifier_Advanced_Luminosity_buff" )

		if mod2 then
			mod2:SafeDestroy()
		elseif mod1 then
			mod1:Increment()
		end
	end
	self:PlayEffects3( center )
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Advanced_Starbreaker:UpdateHorizontalMotion( me, dt )
	-- get forward pos
	local pos = me:GetOrigin() + self.forward * self.speed * dt

	-- if not traversable, stop
	if not GridNav:IsTraversable( pos ) then return end

	-- destroy trees
	GridNav:DestroyTreesAroundPoint( me:GetOrigin(), self.tree_radius, true )

	pos = GetGroundPosition( pos, me )
	me:SetOrigin( pos )
end

function modifier_Advanced_Starbreaker:OnHorizontalMotionInterrupted()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_Starbreaker:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	DestroyParticleByDelay(effect_cast,3)
	
end

function modifier_Advanced_Starbreaker:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Fire_Wreath.Sweep"

	-- Get Data
	local forward = RotatePosition( Vector(0,0,0), QAngle( 0, -120, 0 ), self.forward )

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, forward )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	DestroyParticleByDelay(effect_cast,3)
	EmitSoundOn( sound_cast, self.parent )
end

function modifier_Advanced_Starbreaker:PlayEffects3( center )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_smash.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Fire_Wreath.Smash"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, center )
	DestroyParticleByDelay(effect_cast,8)
	EmitSoundOn( sound_cast, self.parent )	
	self:GetParent():StartGestureFadeWithSequenceSettings(ACT_DOTA_CAST_ABILITY_1_END)

	-- local nFXIndex = ParticleManager:CreateParticle( "particles/creatures/ogre/ogre_melee_smash.vpcf", PATTACH_WORLDORIGIN, self:GetParent() )
	-- ParticleManager:SetParticleControl( nFXIndex, 0, center )
	-- ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.smash_radius, self.smash_radius, self.smash_radius ) )
	-- ParticleManager:ReleaseParticleIndex( nFXIndex )

end



modifier_dawnbreaker_starbreaker_buff = advanced_modifier({})
function modifier_dawnbreaker_starbreaker_buff:IsHidden()return false end
function modifier_dawnbreaker_starbreaker_buff:IsDebuff()return false end
function modifier_dawnbreaker_starbreaker_buff:IsPurgable()return false end
function modifier_dawnbreaker_starbreaker_buff:OnCreated()
	self.incoming = self:GetAbility():GetSpecialValueFor("incoming")
end

function modifier_dawnbreaker_starbreaker_buff:Advanced_GetModifierIncomingDamage_Percentage()
	if not self:GetAbility() then return end
	return -self.incoming
end

function modifier_dawnbreaker_starbreaker_buff:ADDeclareFunctions()
	local funcs = {advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE}
	return funcs
end












modifier_dawnbreaker_starbreaker_debuff = class({})

function modifier_dawnbreaker_starbreaker_debuff:IsDebuff()				return true end
function modifier_dawnbreaker_starbreaker_debuff:IsHidden() 			return false end
function modifier_dawnbreaker_starbreaker_debuff:IsPurgable() 			return false end
function modifier_dawnbreaker_starbreaker_debuff:IsPurgeException() 	return true end
function modifier_dawnbreaker_starbreaker_debuff:CheckState()
	local state = {
		[MODIFIER_STATE_PASSIVES_DISABLED] = true
	}

	return state
end





modifier_Advanced_Starbreaker_unlock3 = class({})

function modifier_Advanced_Starbreaker_unlock3:IsDebuff()			return false end
function modifier_Advanced_Starbreaker_unlock3:IsHidden() 			return true end
function modifier_Advanced_Starbreaker_unlock3:IsPurgable() 		return false end
function modifier_Advanced_Starbreaker_unlock3:IsPurgeException() 	return false end
function modifier_Advanced_Starbreaker_unlock3:RemoveOnDeath() return false end

function modifier_Advanced_Starbreaker_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end
function modifier_Advanced_Starbreaker_unlock3:OnAttackLanded( params )
	if IsServer() then
		if params.attacker~=self:GetParent() then
			return
		end
		local caster = self:GetParent()
		if caster:IsInSpecialAttack() then
			return
		end
		if not caster:IsApplyModifier() then
			return
		end
		if 15 >= math.random(1,100) then

			self:Swipe()
		end

	end
end

function modifier_Advanced_Starbreaker_unlock3:Swipe()
	-- find enemies
	local caster = self:GetParent()
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	
		caster:GetOrigin(),	
		nil,	
		self:GetAbility():GetSpecialValueFor( "swipe_radius" ) ,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}
	local attackEffectRecord = caster:AddAttackEffectModifier(self:GetAbility(),modifier_keys)
	
	for _,enemy in pairs(enemies) do
		caster:PerformAttack( enemy, true, true, true, true, false, false, true )
		enemy:AddNewModifier(
				caster, -- player source
				self:GetAbility(), -- ability source
				"modifier_dawnbreaker_starbreaker_debuff", -- modifier name
				{ duration = 2 }
		)


	end
	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
	-- increment luminosity stack
	if #enemies>0 then
		local mod1 = caster:FindModifierByName( "modifier_Advanced_Luminosity" )
		local mod2 = caster:FindModifierByName( "modifier_Advanced_Luminosity_buff" )

		if mod2 then
			mod2:SafeDestroy()
		elseif mod1 then
			mod1:Increment()
		end
	end

	-- play effects
	self:PlayEffects1()
	self:PlayEffects2()
end
function modifier_Advanced_Starbreaker_unlock3:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep_cast.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	
end

function modifier_Advanced_Starbreaker_unlock3:PlayEffects2()

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_fire_wreath_sweep.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Fire_Wreath.Sweep"
	local caster = self:GetCaster()

	local forward = RotatePosition( Vector(0,0,0), QAngle( 0, -120, 0 ), caster:GetForwardVector() )
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 0, forward )

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
end