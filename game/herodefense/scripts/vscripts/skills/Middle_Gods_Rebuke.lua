
--------------------------------------------------------------------------------
Middle_Gods_Rebuke = class({})
LinkLuaModifier( "modifier_Middle_Gods_Rebuke", "skills/Middle_Gods_Rebuke", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_imgeneric_knockback_lua", "modifier/modifier_imgeneric_knockback_lua", LUA_MODIFIER_MOTION_BOTH )




function Middle_Gods_Rebuke:IsHiddenWhenStolen()return false end
function Middle_Gods_Rebuke:IsStealable()return true end
function Middle_Gods_Rebuke:IsNetherWardStealable()return false end
function Middle_Gods_Rebuke:IsRefreshable()return true end
function Middle_Gods_Rebuke:GetCastRange()
	if IsServer() then
		return 30000
	end
	if IsClient() then
		return self:GetSpecialValueFor( "radius" ) - self:GetCaster():GetCastRangeBonus()  --这个技能不吃施法距离加成
	end
end

function Middle_Gods_Rebuke:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_mars/mars_shield_bash.vpcf", context )
end


--------------------------------------------------------------------------------
--指示器参考上界重锤
function Middle_Gods_Rebuke:GetIntrinsicModifierName()
	return "modifier_generic_custom_indicator"
end


function Middle_Gods_Rebuke:CastFilterResultLocation( vLoc )
	if IsClient() then
		if self.custom_indicator then
			-- register cursor position
			self.custom_indicator:Register( vLoc )
			-- print("diao yong")
		end
	end


	if not IsServer() then return end

	return UF_SUCCESS
end


function Middle_Gods_Rebuke:CreateCustomIndicator()
	local particle_cast = "particles/ui_mouseactions/custom_range_finder_cone_dual.vpcf"
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	self.effect_cast2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_dawnbreaker/hero_dawnbreaker_combo_strike_range_finder_aoe_a.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
end

function Middle_Gods_Rebuke:UpdateCustomIndicator( loc )
	-- get data
	local origin = self:GetCaster():GetAbsOrigin()
	local radius = self:GetSpecialValueFor( "radius" )+20

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

function Middle_Gods_Rebuke:DestroyCustomIndicator()
	-- print("xiao hui")

	ParticleManager:DestroyParticle( self.effect_cast, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
	ParticleManager:DestroyParticle( self.effect_cast2, true ) 
	
	ParticleManager:ReleaseParticleIndex( self.effect_cast2 )
	end


--------------------------------------------------------------------------------
-- Ability Start
function Middle_Gods_Rebuke:OnSpellStart()
	-- unit identifier

	if not self:GetAutoCastState() then	--无自动施法开始////////////////////////////////

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	self.ppoint = point

	-- load data
	local chance = self:GetSpecialValueFor("chance")
	if caster:GetHealthPercent() <= self:GetSpecialValueFor("line") then
		chance = 100
	end
	local radius = self:GetSpecialValueFor("radius") 
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

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
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
		"modifier_Middle_Gods_Rebuke", -- modifier name
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


			caught = true
			-- play effects
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
	return end 

end

--------------------------------------------------------------------------------
-- Play Effects
function Middle_Gods_Rebuke:PlayEffects1( caught, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_bash.vpcf"	--"particles/econ/items/mars/mars_fall20_immortal_shield/mars_fall20_immortal_shield_bash.vpcf"
	local sound_cast = "Hero_Mars.Shield.Cast"
	if not caught then
		sound_cast = "Hero_Mars.Shield.Cast.Small"
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetCaster():GetOrigin() )
	--ParticleManager:SetParticleControl( effect_cast, 1, Vector(1000,1000,1000) )CP1可以调整大小
	--ParticleManager:SetParticleControl( effect_cast, 60, Vector(0,0,205) )CP60调整颜色
	--ParticleManager:SetParticleControl( effect_cast, 61, Vector(1,0,0) )CP61X轴颜色开关
	ParticleManager:SetParticleControlForward( effect_cast, 0, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end

function Middle_Gods_Rebuke:PlayEffects2( target, origin, direction )
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


function Middle_Gods_Rebuke:TalentEffect(pos)

	local caster = self:GetCaster()
	local point = pos
	self.ppoint = point

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local angle = self:GetSpecialValueFor("angle")/2	--概率环形盾击
	local duration = self:GetSpecialValueFor("knockback_duration")
	local distance = self:GetSpecialValueFor("knockback_distance")
	-- find units
	local modifier_keys = {
		duration = 0.1,
		iSpecialAttack = 1,
		iDisableApplyModifier = 0,
		iDisableCleave =1,
		iDisableSplit = 1,

	}

	local attackEffectRecord = caster:AddAttackEffectModifier(self,modifier_keys)
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
		"modifier_Middle_Gods_Rebuke", -- modifier name
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


			caught = true
			-- play effects
			self:PlayEffects2( enemy, origin, cast_direction )
				caster:PerformAttack(
					enemy,
					true,
					true,
					true,
					true,
					false,  --不使用弹道
					false,
					true
				)


		end
	end
	if buff then
		buff:SafeDestroy() --移除加成
	end

	if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end

	self:PlayEffects1( caught, (point-origin):Normalized() )
	

end





--------------------------------------------------------------------------------
modifier_Middle_Gods_Rebuke = advanced_modifier({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Middle_Gods_Rebuke:IsHidden()return true end
function modifier_Middle_Gods_Rebuke:IsDebuff()return false end
function modifier_Middle_Gods_Rebuke:IsPurgable()return false end

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_Gods_Rebuke:OnCreated( kv )


	self.bonus_crit = self:GetAbility():GetSpecialValueFor( "bonus_damage" )

	
end



function modifier_Middle_Gods_Rebuke:Advanced_GetModifierCriticalStrike( keys )
	return self.bonus_crit
end

function modifier_Middle_Gods_Rebuke:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_CRITICALSTRIKE,
    }
end
