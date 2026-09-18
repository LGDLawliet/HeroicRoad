--特效优化 √
Advanced_Chaos_Meteor = class({})
LinkLuaModifier( "modifier_Advanced_Chaos_Meteor_thinker", "skills/Advanced_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chaos_Meteor_debuff", "skills/Advanced_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chaos_Meteor_thinker2", "skills/Advanced_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_Chaos_Meteor_debuff2", "skills/Advanced_Chaos_Meteor", LUA_MODIFIER_MOTION_NONE )
require("internal/timers")


function Advanced_Chaos_Meteor:UnlockFirstCore(key)
	return true
end
function Advanced_Chaos_Meteor:UnlockSecondCore(key)
	return true
end
function Advanced_Chaos_Meteor:UnlockThirdCore(key)
	return true
end

function Advanced_Chaos_Meteor:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function Advanced_Chaos_Meteor:GetChannelAnimation() 
	return ACT_DOTA_GENERIC_CHANNEL_1
end

function Advanced_Chaos_Meteor:GetChannelTime()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==1 then
		return 15
	end
	return 0
end

function Advanced_Chaos_Meteor:GetCooldown(level)

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==1 then
		return 1.5
	end
	return self.BaseClass.GetCooldown(self,level)
end


function Advanced_Chaos_Meteor:GetBehavior()

	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName().."_unlock"
	local coreUnlockKV = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key)

	if coreUnlockKV and coreUnlockKV.coreUnlock ==1 then
		return DOTA_ABILITY_BEHAVIOR_POINT +DOTA_ABILITY_BEHAVIOR_AOE +DOTA_ABILITY_BEHAVIOR_CHANNELLED
	end
	return self.BaseClass.GetBehavior(self)
end



function Advanced_Chaos_Meteor:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if point==caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end
	if self.unlock1 then
		self.timer = 0
		self.point = point
	end

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Advanced_Chaos_Meteor_thinker", -- modifier name
		{}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

function Advanced_Chaos_Meteor:CheckKV(key)
	local table = {
		damage=8,
		bonus_damage=0.08,
		tick_damage=3,
		bonus_tick_damage = 0.01,

	}
	local value = table[key] or -1
	return value

end

function Advanced_Chaos_Meteor:OnChannelThink( flInterval )
	if IsServer() then
		if not self.unlock1 then
			return
		end
		self.timer = self.timer + flInterval
		if self.timer>=0.7 then
			self.timer = self.timer -0.7
			local caster = self:GetCaster()
			local point = self.point + Vector(RandomInt(-400, 400),RandomInt(-400, 400),0)
			if point==caster:GetAbsOrigin() then
				point = point + caster:GetForwardVector()
			end
			CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_Advanced_Chaos_Meteor_thinker", -- modifier name
				{}, -- kv
				point,
				caster:GetTeamNumber(),
				false
			)
		end
	end
end

-------------------------------------------------------------------------------

-- function Advanced_Chaos_Meteor:OnChannelFinish( bInterrupted )
-- 	if IsServer() then
-- 		if not self.unlock3 then
-- 			return
-- 		end
-- 		ParticleManager:DestroyParticle( self.nBeamFX, true )

-- 		self:GetCaster():StopSound("Boss_Tinker.Laser.Loop")
-- 		self:GetCaster():FadeGesture( ACT_DOTA_CAST_ABILITY_3 )

-- 	end
-- end



modifier_Advanced_Chaos_Meteor_thinker = class({})

function modifier_Advanced_Chaos_Meteor_thinker:IsHidden()	return true end


function modifier_Advanced_Chaos_Meteor_thinker:OnCreated( kv )
	if IsServer() then
		-- references
		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		self.radius = ability:GetSpecialValueFor("radius")
		
		
		local chance = 35
		if ability.advanced_level>=5 then
			chance = 50
		
		end
		if self:GetCaster():GetRandomEffect(chance,INT_TYPE,1) >=RandomInt(1, 100) then
			self.radius = self.radius *2
		end



		if ability.advanced_level>=15 and not ability.unlock1 and not ability.unlock3  then
			local count = 2
			local split_radius = 300
			local max_delay = 0.5
			if ability.advanced_level>=20 then
				count = 4
			end
			if ability.unlock2 then
				count = count +10
				split_radius = 800
				max_delay = 1.5
			end
			for i = 1, count, 1 do
				local caster = self:GetCaster()
				local pos = self:GetParent():GetAbsOrigin()
				local caster_Pos = caster:GetAbsOrigin()
				local radius = self.radius *0.5
				Timers(RandomFloat(0.1, max_delay), function()
					local point = pos + Vector(RandomInt(-split_radius, split_radius),RandomInt(-split_radius, split_radius),0)
					local caster_pos = caster_Pos + Vector(RandomInt(-split_radius, split_radius),RandomInt(-split_radius, split_radius),0)
					if point==caster_pos then
						point = point + caster:GetForwardVector()
					end
					CreateModifierThinker(
					caster, -- player source
					ability, -- ability source
					"modifier_Advanced_Chaos_Meteor_thinker2", -- modifier name
					{caster_pos_x = caster_pos.x,caster_pos_y = caster_pos.y,caster_pos_z=caster_pos.z,radius=radius}, -- kv
					point ,
					caster:GetTeamNumber(),
					false)
				end)
			end
			
		end
		self.distance = ability:GetSpecialValueFor("distance")
		self.speed = 200
	
		
		self.interval = 0.3

		self.move_distance = 0
		self.need_distance = 300
		self.pos = self:GetParent():GetAbsOrigin()
		self.explosion_damageIndex = 0.5

		self.damage_index = 1
		-- variables
		self.fallen = false
		self.damageTable = {
			-- victim = target,
			damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false),
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}
		if ability.unlock1 then
			local index = RandomFloat(0.3,1.1)
			self.damage_index  = index
			self.radius = self.radius *index
			self.damageTable.damage = self.damageTable.damage *index
		end
		if ability.unlock3 then
			self.radius = self.radius *2
			self.damage_index  = 5
			self.damageTable.damage = self.damageTable.damage * 5
		end
		self.explosion_radius = self.radius
		if ability.advanced_level>=10 then
			self.explosion_radius = self.explosion_radius*1.5
		end

		self.effect_unit = {}


		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end



function modifier_Advanced_Chaos_Meteor_thinker:OnDestroy( kv )
	if IsServer() then
		-- add vision
	
		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Chaos_Meteor_thinker:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		-- move & damages
		self:Move_Burn()
	end
	local pos = self:GetParent():GetAbsOrigin()
	local dis = CalculateDistance(self.pos,pos)
	self.pos = pos
	self.move_distance = self.move_distance + dis
	if self.move_distance>=self.need_distance then
		self.move_distance = self.move_distance  - self.need_distance
		self:Explosion()
	end


end

function modifier_Advanced_Chaos_Meteor_thinker:Burn()
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
	
	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Chaos_Meteor_debuff", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
		end
	


	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_Advanced_Chaos_Meteor_thinker:Move_Burn()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()
	if not parent or not self:GetAbility() then
		self:SafeDestroy()
		return
	end

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:SafeDestroy()
		return
	end
end



function modifier_Advanced_Chaos_Meteor_thinker:Explosion()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()
	if not parent or not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(nFXIndex, 0, parent:GetOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.explosion_radius*1.5,0,0))
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitSoundOn( "Hero_Leshrac.Lightning_Storm", parent )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damageTable = {
		-- victim = target,
		damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)*self.explosion_damageIndex,
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	damageTable.damage = damageTable.damage * self.damage_index 
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	


	end

end
function modifier_Advanced_Chaos_Meteor_thinker:PlayEffects1()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_Advanced_Chaos_Meteor_thinker:PlayEffects2()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor_move/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end










modifier_Advanced_Chaos_Meteor_debuff = class({})

function modifier_Advanced_Chaos_Meteor_debuff:IsDebuff()			return true end
function modifier_Advanced_Chaos_Meteor_debuff:IsHidden() 			return false end
function modifier_Advanced_Chaos_Meteor_debuff:IsPurgable() 			return true end
function modifier_Advanced_Chaos_Meteor_debuff:IsPurgeException() 	return true end
function modifier_Advanced_Chaos_Meteor_debuff:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_Advanced_Chaos_Meteor_debuff:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Advanced_Chaos_Meteor_debuff:OnCreated()
	if IsServer() then

		self.dmg = self:GetAbility():GetSpecialValueFor("tick_damage") +self:GetAbility():GetSpecialValueFor("bonus_tick_damage")*self:GetCaster():GetIntellect(false)
		self:StartIntervalThink(1)

	end
end


function modifier_Advanced_Chaos_Meteor_debuff:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	if self:GetParent():IsMagicImmune() then
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dmg,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
end













modifier_Advanced_Chaos_Meteor_thinker2 = class({})

function modifier_Advanced_Chaos_Meteor_thinker2:IsHidden()	return true end


function modifier_Advanced_Chaos_Meteor_thinker2:OnCreated( kv )
	if IsServer() then
		-- references
		local ability = self:GetAbility()
		self.caster_origin = Vector(kv.caster_pos_x,kv.caster_pos_y,kv.caster_pos_z)
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		self.delay = 1.3
		self.radius = kv.radius
		self.explosion_radius = self.radius*1.5
		
	

		self.distance = ability:GetSpecialValueFor("distance")
		self.speed = 200
	
		
		self.interval = 0.3

		self.move_distance = 0
		self.need_distance = 300
		self.pos = self:GetParent():GetAbsOrigin()
		self.explosion_damageIndex = 0.25


		-- variables
		self.fallen = false
		self.damageTable = {
			-- victim = target,
			damage = (ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false))*0.5,
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = ability, --Optional.
			hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
		}

		self.effect_unit = {}


		-- Start interval
		self:StartIntervalThink( self.delay )

		-- play effects
		self:PlayEffects1()
	end
end



function modifier_Advanced_Chaos_Meteor_thinker2:OnDestroy( kv )
	if IsServer() then
		-- add vision
	
		-- stop effects
		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Advanced_Chaos_Meteor_thinker2:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
	else
		-- move & damages
		self:Move_Burn()
	end
	local pos = self:GetParent():GetAbsOrigin()
	local dis = CalculateDistance(self.pos,pos)
	self.pos = pos
	self.move_distance = self.move_distance + dis
	if self.move_distance>=self.need_distance then
		self.move_distance = self.move_distance  - self.need_distance
		self:Explosion()
	end


end

function modifier_Advanced_Chaos_Meteor_thinker2:Burn()
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()
	-- find enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(0.6)
	
	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			self.damageTable.victim = enemy
			ApplyDamage( self.damageTable )
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster, self:GetAbility(), "modifier_Advanced_Chaos_Meteor_debuff2", {duration = self:GetAbility():GetSpecialValueFor("duration")*StatusResistance})
		end
	


	end
end

--------------------------------------------------------------------------------
-- Motion effects
function modifier_Advanced_Chaos_Meteor_thinker2:Move_Burn()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()
	if not parent or not self:GetAbility() then
		self:SafeDestroy()
		return
	end

	-- set position
	local target = self.direction*self.speed*self.interval
	parent:SetOrigin( parent:GetOrigin() + target )

	-- Burn
	self:Burn()
	
	-- check distance for next step
	if (parent:GetOrigin() - self.parent_origin + target):Length2D()>self.distance then
		self:SafeDestroy()
		return
	end
end



function modifier_Advanced_Chaos_Meteor_thinker2:Explosion()
	if not self:GetCaster() then
		return
	end
	local parent = self:GetParent()
	if not parent or not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/void_spirit_void_bubble_explosion_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(nFXIndex, 0, parent:GetOrigin())
	ParticleManager:SetParticleControl(nFXIndex, 1, Vector(self.explosion_radius*1.5,0,0))
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	EmitSoundOn( "Hero_Leshrac.Lightning_Storm", parent )
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	local damageTable = {
		-- victim = target,
		damage = ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false)*self.explosion_damageIndex,
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	


	end

end
function modifier_Advanced_Chaos_Meteor_thinker2:PlayEffects1()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"

	-- Get Data
	local height = 1000
	local height_target = -0

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )

	ParticleManager:SetParticleControl( effect_cast, 0, self.caster_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_Advanced_Chaos_Meteor_thinker2:PlayEffects2()
	if not self:GetCaster() then
		return
	end
	-- Get Resources
	local particle_cast = "particles/rebuild/spell/chaos_meteor_move/invoker_chaos_meteor.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin )
	ParticleManager:SetParticleControlForward( effect_cast, 0, self.direction )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- -- buff particle
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Create Sound
	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )
	EmitSoundOn( sound_loop, self:GetParent() )
end






modifier_Advanced_Chaos_Meteor_debuff2 = class({})

function modifier_Advanced_Chaos_Meteor_debuff2:IsDebuff()			return true end
function modifier_Advanced_Chaos_Meteor_debuff2:IsHidden() 			return false end
function modifier_Advanced_Chaos_Meteor_debuff2:IsPurgable() 			return true end
function modifier_Advanced_Chaos_Meteor_debuff2:IsPurgeException() 	return true end
function modifier_Advanced_Chaos_Meteor_debuff2:GetEffectName()
	return "particles/units/heroes/hero_invoker/invoker_chaos_meteor_burn_debuff.vpcf"
end

function modifier_Advanced_Chaos_Meteor_debuff2:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end


function modifier_Advanced_Chaos_Meteor_debuff2:OnCreated()
	if IsServer() then

		self.dmg = self:GetAbility():GetSpecialValueFor("tick_damage") +self:GetAbility():GetSpecialValueFor("bonus_tick_damage")*self:GetCaster():GetIntellect(false)
		self:StartIntervalThink(1)

	end
end


function modifier_Advanced_Chaos_Meteor_debuff2:OnIntervalThink()
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end
	if self:GetParent():IsMagicImmune() then
		return
	end
	local damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = self.dmg*0.5,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage(damageTable)
end

