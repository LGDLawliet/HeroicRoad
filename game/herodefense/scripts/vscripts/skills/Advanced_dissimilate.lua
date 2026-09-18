--特效优化 √
Advanced_dissimilate = class({})
LinkLuaModifier( "modifier_Advanced_dissimilate", "skills/Advanced_dissimilate", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_dissimilate_unlock3", "skills/Advanced_dissimilate", LUA_MODIFIER_MOTION_NONE )


function Advanced_dissimilate:CheckKV(key)
	local table = {

		damage =15,
		damage_index = 0.15,

	}
	local value = table[key] or -1
	return value

end

function Advanced_dissimilate:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- caster:AddNewModifier(caster,self,"modifier_Advanced_reactive_armor_unlock1",{})

	return true
end
function Advanced_dissimilate:UnlockSecondCore(key)
	return true
end
function Advanced_dissimilate:UnlockThirdCore(key)
	return true
end
function Advanced_dissimilate:IsRefreshable()
	if self.unlock1 then
		return false
	end
	return true
end



function Advanced_dissimilate:GetCooldown(iLevel)
	if self:GetUnlock(1)==1 then
		return 30 /(math.max(self:GetCaster():GetCooldownReduction(),0.001))
	end
	return self.BaseClass.GetCooldown(self,iLevel)/(math.max(self:GetCaster():GetCooldownReduction(),0.001))
end

function Advanced_dissimilate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = 1.3
	--LV5解锁多重维度+
	if  self.advanced_level>=5 then
		duration = 3
		--lv15解锁多重维度++
		if  self.advanced_level>=15 then
			duration = duration +1
			if self.unlock1 then
				duration = 10
			end
		end
	end
	local bonus = 0
	if self.unlock3 then
		local units = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			1000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_FRIENDLY,	-- int, team filter
			DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,unit in pairs(units) do
			if not unit:HasModifier("modifier_Advanced_dissimilate_unlock3") then
				unit:AddNewModifier(
					caster, -- player source
					self, -- ability source
					"modifier_Advanced_dissimilate_unlock3", -- modifier name
					{ duration = duration } -- kv
				)
				bonus = bonus +1
			end	
		end
		
	end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_dissimilate", -- modifier name
		{ duration = duration ,bonus=bonus} -- kv
	)

	-- Play sound
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )

end




modifier_Advanced_dissimilate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_dissimilate:IsHidden()	return false end
function modifier_Advanced_dissimilate:IsDebuff()	return false end
function modifier_Advanced_dissimilate:IsPurgable()	return false end

function modifier_Advanced_dissimilate:OnCreated( kv )

	local caster = self:GetCaster()
	self.ability = self:GetAbility()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..self.ability:GetAbilityName()
	self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	
	self.portals = 6  --每层的数量
	self.angle = 60
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.distance = self.ability:GetSpecialValueFor("distance")
	self.target_radius = self.ability:GetSpecialValueFor("radius")
	self.manaCost_reduce = 0

	self.selected_group = {}

	--LV15解锁多重维度++
	if self.advanced_level>=15 then
		self.portals = self.portals*1.5
		self.angle = 360/self.portals
		--LV20解锁异步化
		if self.advanced_level>=20 then
			self.manaCost_reduce = 70
		end
		
	end


	if not IsServer() then return end
	
	self:GetAbility():SetActivated(false)

	self.damage = self.ability:GetSpecialValueFor("damage")+(self.ability:GetSpecialValueFor("damage_index"))*self:GetCaster():GetIntellect(false)
	if kv.bonus>0 then
		-- print("self.damage="..self.damage)
		self.damage = self.damage * (1+kv.bonus*0.2)
		-- print("self.damage="..self.damage)
	end
	local origin = self:GetParent():GetOrigin()
	local direction = self:GetParent():GetForwardVector()
	local zero = Vector(0,0,0)
	self.selected = 1

	table.insert(self.selected_group,self.selected)

	self.points = {}
	self.effects = {}
	table.insert( self.points, origin )
	table.insert( self.effects, self:PlayEffects1( origin, true ) )

	for i=1,self.portals do
		local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )
		local point = GetGroundPosition( origin + new_direction * self.distance, nil )

		table.insert( self.points, point )
		table.insert( self.effects, self:PlayEffects1( point, false ) )
	end
	for i=1,self.portals do
		local new_direction = RotatePosition( zero, QAngle( 0, self.angle*i, 0 ), direction )
		local point = GetGroundPosition( origin + new_direction * self.distance*2, nil )

		table.insert( self.points, point )
		table.insert( self.effects, self:PlayEffects1( point, false ) )
	end
	self.unlock2_count = 0
	self.damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}

	self:GetParent():AddNoDraw()
end

function modifier_Advanced_dissimilate:OnRefresh( kv )
	
end

function modifier_Advanced_dissimilate:OnRemoved()
end

function modifier_Advanced_dissimilate:OnDestroy()
	if not IsServer() then return end

	local point = self.points[self.selected]

	local ability = self:GetAbility()
	ability:SetActivated(true)
	FindClearSpaceForUnit( self:GetParent(), point, true )
	--LV10解锁同步异化
	if self.advanced_level>=10 then
		self.damageTable.damage = self.damage* (1+#self.selected_group*0.05)
	end
	local max_count = 3
	if ability.unlock2 then
		max_count = 6
		self.damageTable.damage = self.damageTable.damage * (math.min(15,1+self.unlock2_count*0.05))
	end
	for _, i in ipairs(self.selected_group) do
		local point = self.points[i]
		local enemies = FindUnitsInRadius(
			self:GetCaster():GetTeamNumber(),	-- int, your team number
			point,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
		for _,enemy in pairs(enemies) do
			-- apply damage
			self.damageTable.victim = enemy
			ApplyDamage(self.damageTable)		
		end
		self:PlayEffects2( point, #enemies )
		max_count = max_count - 1
		if max_count<=0 then
			break
		end
	end


	-- nodraw
	self:GetParent():RemoveNoDraw()

	-- play effects
	
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_dissimilate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,            --技能魔法消耗
	}

	return funcs
end
function modifier_Advanced_dissimilate:GetModifierPercentageManacostStacking()
	return self.manaCost_reduce
end

function modifier_Advanced_dissimilate:OnOrder( params )
	if params.unit~=self:GetParent() then return end

	-- right click, switch position
	if 	params.order_type==DOTA_UNIT_ORDER_MOVE_TO_POSITION then
		self:SetValidTarget( params.new_pos )
	elseif 
		params.order_type==DOTA_UNIT_ORDER_MOVE_TO_TARGET or
		params.order_type==DOTA_UNIT_ORDER_ATTACK_TARGET
	then
		self:SetValidTarget( params.target:GetOrigin() )
	end
end

function modifier_Advanced_dissimilate:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_dissimilate:CheckState()
	-- local caster = self:GetCaster()
	-- local ability = self:GetAbility()
	-- --该技能需要从网表拿等级数据 自定义变量拿不到该值
	-- local NetTable_key = tostring(caster:GetPlayerOwnerID()).."_"..ability:GetAbilityName()
	-- self.advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if IsClient() then
		return
	end
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	--LV5解锁多重维度
	if self.advanced_level>=5 then
		state = {
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}
		if self:GetAbility().unlock1 then
			state = {
				-- [MODIFIER_STATE_DISARMED] = true,
				[MODIFIER_STATE_OUT_OF_GAME] = true,
			}
		end
	end


	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_Advanced_dissimilate:SetValidTarget( location )
	-- find max
	local max_dist = (location-self.points[1]):Length2D()
	local max_point = 1
	for i,point in ipairs(self.points) do
		local dist = (location-point):Length2D()
		if dist<max_dist then
			max_dist = dist
			max_point = i
		end
	end

	if self.selected~= max_point then
		self.unlock2_count = self.unlock2_count + 1
	end
	-- select
	local old_select = self.selected
	self.selected = max_point
	table.insert(self.selected_group,self.selected)

	-- change effects
	self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_dissimilate:PlayEffects1( point, main )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_rebuild.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Portals"

	local radius = self.radius + 25

	local effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, 0, 1 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( self:GetRemainingTime(), 0, 0 ) )
	if main then
		ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ) )
	end

	local effect_cast2 = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetParent(), self:GetParent():GetOpposingTeamNumber() )
	ParticleManager:SetParticleControl( effect_cast2, 0, point )
	ParticleManager:SetParticleControl( effect_cast2, 1, Vector( radius, 0, 1 ) )
	ParticleManager:SetParticleControl( effect_cast2, 61, Vector( self:GetRemainingTime(), 0, 0 ) )

	self:AddParticle(effect_cast,false, false, -1,false, false)
	self:AddParticle(effect_cast2,false, false, -1, false,false )

	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )

	return effect_cast
end

function modifier_Advanced_dissimilate:ChangeEffects( old, new )
	ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_Advanced_dissimilate:PlayEffects2( point, hit )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf"
	local sound_cast = "Hero_VoidSpirit.Dissimilate.TeleportIn"
	local sound_hit = "Hero_VoidSpirit.Dissimilate.Stun"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, point )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.target_radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
	if hit>0 then
		EmitSoundOn( sound_hit, self:GetParent() )
	end
end







modifier_Advanced_dissimilate_unlock3 = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Advanced_dissimilate_unlock3:IsHidden()	return true end
function modifier_Advanced_dissimilate_unlock3:IsDebuff()	return false end
function modifier_Advanced_dissimilate_unlock3:IsPurgable()	return false end

function modifier_Advanced_dissimilate_unlock3:OnCreated( kv )


	if not IsServer() then return end
	


	self:GetParent():AddNoDraw()
end


function modifier_Advanced_dissimilate_unlock3:OnDestroy()
	if not IsServer() then return end

	self:GetParent():RemoveNoDraw()

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Advanced_dissimilate_unlock3:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_Advanced_dissimilate_unlock3:GetModifierMoveSpeed_Limit()
	return 0.1
end
--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_dissimilate_unlock3:CheckState()

	if IsClient() then
		return
	end
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}



	return state
end

