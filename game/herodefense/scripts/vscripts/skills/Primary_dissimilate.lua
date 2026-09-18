Primary_dissimilate = class({})
LinkLuaModifier( "modifier_Primary_dissimilate", "skills/Primary_dissimilate", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start
function Primary_dissimilate:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = 1.3

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_Primary_dissimilate", -- modifier name
		{ duration = duration } -- kv
	)

	-- Play sound
	local sound_cast = "Hero_VoidSpirit.Dissimilate.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
function Primary_dissimilate:GetCooldown(iLevel)
	return self.BaseClass.GetCooldown(self,iLevel)/(math.max(self:GetCaster():GetCooldownReduction(),0.001))
end



modifier_Primary_dissimilate = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_dissimilate:IsHidden()	return false end
function modifier_Primary_dissimilate:IsDebuff()	return false end
function modifier_Primary_dissimilate:IsPurgable()	return false end

function modifier_Primary_dissimilate:OnCreated( kv )

	self.ability = self:GetAbility()
	self.portals = 6  --每层的数量
	self.angle = 60
	self.radius = self.ability:GetSpecialValueFor("radius")
	self.distance = self.ability:GetSpecialValueFor("distance")
	self.target_radius = self.ability:GetSpecialValueFor("radius")

	if not IsServer() then return end

	self.damage = self.ability:GetSpecialValueFor("damage")+self.ability:GetSpecialValueFor("damage_index")*self:GetCaster():GetIntellect(false)
	local origin = self:GetParent():GetOrigin()
	local direction = self:GetParent():GetForwardVector()
	local zero = Vector(0,0,0)
	self.selected = 1

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

	self.damageTable = {
		attacker = self:GetCaster(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self, --Optional.
	}

	self:GetParent():AddNoDraw()
end

function modifier_Primary_dissimilate:OnRefresh( kv )
	
end

function modifier_Primary_dissimilate:OnRemoved()
end

function modifier_Primary_dissimilate:OnDestroy()
	if not IsServer() then return end

	local point = self.points[self.selected]


	FindClearSpaceForUnit( self:GetParent(), point, true )


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

	-- nodraw
	self:GetParent():RemoveNoDraw()

	-- play effects
	self:PlayEffects2( point, #enemies )
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_dissimilate:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,

		MODIFIER_PROPERTY_MOVESPEED_LIMIT,
	}

	return funcs
end

function modifier_Primary_dissimilate:OnOrder( params )
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

function modifier_Primary_dissimilate:GetModifierMoveSpeed_Limit()
	return 0.1
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Primary_dissimilate:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Helper
function modifier_Primary_dissimilate:SetValidTarget( location )
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

	-- select
	local old_select = self.selected
	self.selected = max_point

	-- change effects
	self:ChangeEffects( old_select, self.selected )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Primary_dissimilate:PlayEffects1( point, main )
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

function modifier_Primary_dissimilate:ChangeEffects( old, new )
	ParticleManager:SetParticleControl( self.effects[old], 2, Vector( 0, 0, 0 ) )
	ParticleManager:SetParticleControl( self.effects[new], 2, Vector( 1, 0, 0 ) )
end

function modifier_Primary_dissimilate:PlayEffects2( point, hit )
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