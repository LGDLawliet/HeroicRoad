Advanced_timber_chain = class({})

require("internal/timers")
LinkLuaModifier( "modifier_Advanced_timber_chain", "skills/Advanced_timber_chain", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Advanced_timber_chain_unlock2_active", "skills/Advanced_timber_chain", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_Advanced_timber_chain_unlock3_debuff", "skills/Advanced_timber_chain", LUA_MODIFIER_MOTION_HORIZONTAL )

function Advanced_timber_chain:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/timber_chain/timber_chain.vpcf", context )

end
function Advanced_timber_chain:CheckKVFixedOverride(key)
	if key=="AbilityCharges" then
		if self:GetSpecialValueFor("advanced_level")>=10 then
			if self:GetUnlock(1)==1 then
				return 10
			end
			return 6
		end
	end
	if key=="AbilityChargeRestoreTime" then
		if self:GetUnlock(1)==1 then
			return 2
		end
	end

	return -999999

end
function Advanced_timber_chain:CheckKV(key)
	local table = {
		range=40,
		damage=10,
		bonus_damage=0.08,
	}
	local value = table[key] or -1
	return value

end
function Advanced_timber_chain:IsEnableDefulatIndicator()
	return false
end

function Advanced_timber_chain:OnAbilitySelectStart(caster)
	-- print("1")
	local level = self:GetSpecialValueFor("advanced_level")
	-- print("level="..level)
	if level>=20 then
		self.particle = ParticleManager:CreateParticle("particles/ui_mouseactions/custom_range_finder_2/effect_aoe.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.particle,1,self:GetCaster(),PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true)
		ParticleManager:SetParticleControlEnt(self.particle,2,self:GetCaster(),PATTACH_POINT_FOLLOW,nil,Vector(0,0,0),true)
		ParticleManager:SetParticleControl( self.particle, 3, Vector(2000,2000,2000))
		ParticleManager:SetParticleControl( self.particle, 4, Vector(64,245,0))
	end

end

-- function Advanced_timber_chain:OnAbilitySelecting(caster,location)
-- 	-- ParticleManager:SetParticleControl(self.particle,0,location)
-- end

function Advanced_timber_chain:OnAbilitySelectEnd(caster)
	if self.particle then
		ParticleManager:DestroyParticle(self.particle,true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
	
end

function Advanced_timber_chain:CastFilterResultTarget(target)
	-- check nohammer
	if IsClient() then
		return
	end
	if target==self:GetCaster() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end
function Advanced_timber_chain:GetCustomCastErrorTarget(target)
	if IsClient() then
		return
	end
	return "#Spells_CustomCastError_NOT_SELF"
end
function Advanced_timber_chain:GetCastRange(vLocation, hTarget)
	-- if IsServer() then return 900000 end
	local range = self:GetSpecialValueFor( "range" )
	if self:GetSpecialValueFor("advanced_level")>=5 then
		range = range + 800
	end
	return range
end

function Advanced_timber_chain:GetCastPoint()
	if self:GetSpecialValueFor("advanced_level")>=5 then
		return 0
	end
	return self.BaseClass.GetCastPoint(self)
end

function Advanced_timber_chain:GetBehavior()

	local advanced_level = self:GetSpecialValueFor("advanced_level")

	if advanced_level>=20 then
		if self:GetUnlock(2)==2 then
			return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES + DOTA_ABILITY_BEHAVIOR_AUTOCAST
		end
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	else 
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IGNORE_BACKSWING + DOTA_ABILITY_BEHAVIOR_ROOT_DISABLES
	end
end
function Advanced_timber_chain:UnlockFirstCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_hyakkiyakou_unlock1",{})
	
	return true
end
function Advanced_timber_chain:UnlockSecondCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end
function Advanced_timber_chain:UnlockThirdCore(key)
	-- local caster = self:GetCaster()
	-- local modifier = caster:AddNewModifier(caster,self,"modifier_Advanced_Thunderstrike_unlock2",{})
	
	return true
end


function Advanced_timber_chain:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = caster:GetCursorCastTarget()
	local point
	local ground_target = false
	local use_sky_effect = false
	if not target then
		point =self:GetCursorPosition()
		local caster_loc = caster:GetOrigin()
		if caster_loc==point then
			point = point + caster:GetForwardVector()
		end
		local dis = CalculateDistance(point,caster_loc)
		dis = math.min(dis,2000)
		local direction 	= (point - caster_loc):Normalized()
		point = caster_loc  + direction * dis
		ground_target = true	
		if self.unlock1 then
			point = point + Vector(0,0,2000)
			ground_target = false
			use_sky_effect = true
			-- particles/rebuild/spell/timber_chain/timber_chain.vpcf
		end
	else
		point =target:GetOrigin()
	end
	-- load data
	local projectile_speed = 3000
	if caster:HasAbility("heroTalent_npc_dota_hero_shredder_2") then
		projectile_speed = projectile_speed * 1.5
	end
	local projectile_distance =math.max( self:GetSpecialValueFor( "range" ) + caster:GetCastRangeBonus(),100)
	if self.advanced_level>=5 then
		projectile_distance = projectile_distance + 800
	end
	local projectile_radius = self:GetSpecialValueFor( "radius" )
	local projectile_direction = point-caster:GetOrigin()
	projectile_direction.z = 0
	projectile_direction = projectile_direction:Normalized()
	local vision = 100

	local effect = self:PlayEffects(caster, caster:GetOrigin() + projectile_direction * projectile_distance, projectile_speed, projectile_distance/projectile_speed,use_sky_effect )

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    EffectName = "",
	    fDistance = projectile_distance,
	    fStartRadius = projectile_radius,
	    fEndRadius = projectile_radius,
		vVelocity = projectile_direction * projectile_speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		fExpireTime = GameRules:GetGameTime() + 10.0,
		
		bProvidesVision = true,
		iVisionRadius = vision,
		iVisionTeamNumber = caster:GetTeamNumber(),
	}

	-- register projectile
	local projectile = ProjectileManager:CreateLinearProjectile(info)
	local ExtraData = {
		unit = caster,
		effect = effect,
		ground_target = ground_target,
		use_sky_effect =use_sky_effect,
		-- target = target,
	}
	if target then
		ExtraData.target = target
		if self.unlock2 and self:GetAutoCastState() and IsEnemy(target,caster) then
			ExtraData.unlock2 = true
		end
	else
		ExtraData.target_pos = point
	end
	self.projectiles[ projectile ] = ExtraData
end
function Advanced_timber_chain:Spawn()
	self.projectiles = {}
end


function Advanced_timber_chain:OnProjectileThinkHandle( handle )
	-- get data
	local ExtraData = self.projectiles[ handle ]
	local location = ProjectileManager:GetLinearProjectileLocation( handle )

	-- search for tree
	local point 
	if ExtraData.target then
		point = ExtraData.target:GetOrigin()
	else
		point = ExtraData.target_pos
	end
	

	if CalculateDistance(point,location)<=250 then
		-- local point = target:GetOrigin()
		if ExtraData.unlock2 then
			-- modifier_Advanced_timber_chain_unlock2_active
			ExtraData.target:AddNewModifier(
				self:GetCaster(), -- player source
				self, -- ability source
				"modifier_Advanced_timber_chain_unlock2_active", -- modifier name
				{
					duration = 4.5,
				} 
			)
			self:ModifyEffects2( self:GetCaster(),ExtraData.effect, point )
			ParticleManager:DestroyParticle(ExtraData.effect,false)
			ProjectileManager:DestroyLinearProjectile( handle )
			self.projectiles[ handle ] = nil
			return
		end

		local ability = self:GetCaster():FindAbilityByName("heroTalent_npc_dota_hero_shredder_2")
		if ability and ability:GetAutoCastState() and ExtraData.target then
			self:ModifyEffectsTalent(ExtraData.effect,ExtraData.target)
			ProjectileManager:DestroyLinearProjectile( handle )
			self.projectiles[ handle ] = nil

			-- add vision
			AddFOWViewer( self:GetCaster():GetTeamNumber(), point, 400, 1, true )
			point = self:GetCaster():GetOrigin()
			ExtraData.target:AddNewModifier(
					self:GetCaster(), -- player source
					self, -- ability source
					"modifier_Advanced_timber_chain", -- modifier name
					{
						duration = 3,
						point_x = point.x,
						point_y = point.y,
						point_Z = point.z,
						effect = ExtraData.effect,
						ground_target = ExtraData.ground_target and 1 or 0
					} -- kv
			)

			return
		end



		-- snag
		-- 
		local caster = self:GetCaster()
		if ExtraData.unit==caster then
			FindClearSpaceForUnit(caster, caster:GetOrigin(), true )
			if  ExtraData.ground_target then
				-- 如果超出了距离则设置重新设置目标点
				local dis = CalculateDistance(point,caster:GetOrigin())
				dis = math.min(dis,2000)
				local direction 	= (point - caster:GetOrigin()):Normalized()
				point = caster:GetOrigin()  + direction * dis
			end
		end


		ExtraData.unit:AddNewModifier(
			self:GetCaster(), -- player source
			self, -- ability source
			"modifier_Advanced_timber_chain", -- modifier name
			{
				duration = duration,
				point_x = point.x,
				point_y = point.y,
				point_Z = point.z,
				effect = ExtraData.effect,
				ground_target = ExtraData.ground_target and 1 or 0
			} -- kv
		)

		-- modify effects
		self:ModifyEffects2( ExtraData.unit,ExtraData.effect, point )

		-- destroy projectile
		ProjectileManager:DestroyLinearProjectile( handle )
		self.projectiles[ handle ] = nil

		-- add vision
		AddFOWViewer( self:GetCaster():GetTeamNumber(), point, 400, 1, true )
	end
end

function Advanced_timber_chain:OnProjectileHitHandle( target, location, handle )
	local ExtraData = self.projectiles[ handle ]
	if not ExtraData then return end

	self:ModifyEffects1( ExtraData.unit,ExtraData.effect )
	self.projectiles[ handle ] = nil
end

function Advanced_timber_chain:PlayEffects( unit,point, speed, duration,use_sky_effect )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timberchain.vpcf"
	if use_sky_effect then
		particle_cast = "particles/rebuild/spell/timber_chain/timber_chain.vpcf"
	end
	local sound_cast = "Hero_Shredder.TimberChain.Cast"
	if use_sky_effect then
		point = point + Vector(0,0,2000)
	end

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, unit )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		unit,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, point )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( speed, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( duration*2 + 0.3, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast,unit)

	return effect_cast
end

function Advanced_timber_chain:ModifyEffects1(unit, effect )
	-- retract
	ParticleManager:SetParticleControlEnt(
		effect,
		1,
		unit,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	EmitSoundOn( sound_cast, unit )
end

function Advanced_timber_chain:ModifyEffects2(unit, effect, point )
	-- set particle location
	ParticleManager:SetParticleControl( effect, 1, point )

	-- increase effect duration
	ParticleManager:SetParticleControl( effect, 3, Vector( 64, 0, 0 ) )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	local sound_target = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, unit )
	EmitSoundOnLocationWithCaster( point, sound_target,unit )
end





function Advanced_timber_chain:ModifyEffectsTalent(effect,target)
	ParticleManager:SetParticleControlEnt(
		effect,
		1,
		target,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	local sound_cast = "Hero_Shredder.TimberChain.Retract"
	local sound_target = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOnLocationWithCaster( target:GetOrigin(), sound_target, self:GetCaster() )
end







modifier_Advanced_timber_chain = advanced_modifier({})


function modifier_Advanced_timber_chain:IsHidden()	return true end
function modifier_Advanced_timber_chain:IsDebuff()	return false end
function modifier_Advanced_timber_chain:IsStunDebuff()	return false end
function modifier_Advanced_timber_chain:IsPurgable()	return false end
-- function modifier_Advanced_timber_chain:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_timber_chain:OnCreated( kv )
	if not IsServer() then return end

	-- references

	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():HDGetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.speed = 3000
	if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_shredder_2") then
		self.speed = self.speed * 1.5
		damage = damage  *1.5
	end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect
	if kv.ground_target==1 then
		self.speed = self.speed *0.7
	end
	if self:GetAbility().unlock3 then
		self.unlock3 = true
	end

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- init
	self.proximity = 80
	self.caught_enemies = {}
	self.caught_target_count = 0

	-- start motion controller
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end

function modifier_Advanced_timber_chain:OnRefresh( kv )
	if not IsServer() then return end
	local old_effect = self.effect

	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetCaster():HDGetPrimaryStatValue()*self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.speed = 3000
	if self:GetCaster():HasAbility("heroTalent_npc_dota_hero_shredder_2") then
		self.speed = self.speed * 1.5
		damage = damage * 1.5
	end
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.point = Vector( kv.point_x, kv.point_y, kv.point_z )
	self.effect = kv.effect
	if kv.ground_target==1 then
		self.speed = self.speed *0.7
	end
	-- update damage
	self.damageTable.damage = damage

	-- init
	self.caught_enemies = {}
	self.caught_target_count = 0
	-- destroy previous effect
	ParticleManager:DestroyParticle( old_effect, false )
	ParticleManager:ReleaseParticleIndex( old_effect )
end

function modifier_Advanced_timber_chain:OnRemoved()
end

function modifier_Advanced_timber_chain:OnDestroy()
	if not IsServer() then return end

	-- remove effect
	ParticleManager:DestroyParticle( self.effect, false )
	ParticleManager:ReleaseParticleIndex( self.effect )

	-- play sound
	local sound_cast = "Hero_Shredder.TimberChain.Impact"
	EmitSoundOn( sound_cast, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_Advanced_timber_chain:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_Advanced_timber_chain:UpdateHorizontalMotion( me, dt )
	local origin = me:GetOrigin()
	local caster = self:GetCaster()
	local direction = (self.point-origin)
	direction.z = 0
	direction = direction:Normalized()
	local ability = self:GetAbility()

	-- set origin
	local target = origin + direction * self.speed * dt
	-- print(self.speed)
	me:SetOrigin( target )

	if self.caught_target_count<=10 or self.unlock3 then
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			origin,	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)
	
		for _,enemy in pairs(enemies) do
			-- check if already hit
			if not self.caught_enemies[enemy] then
				self.caught_enemies[enemy] = true
				self.caught_target_count =  self.caught_target_count +1
				-- damage
				self.damageTable.victim = enemy
				ApplyDamage( self.damageTable )
				if self.unlock3 and enemy:IsAlive() then
					enemy:AddNewModifier(
						caster, -- player source
						ability, -- ability source
						"modifier_Advanced_timber_chain_unlock3_debuff", -- modifier name
						{

						} 
					)
				end
	
				-- play effects
				self:PlayEffects( enemy )
			end
		end
	end


	-- destroy if stunned
	if me:IsStunned() then
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

	-- destroy if reached target
	if (self.point-origin):Length2D()<self.proximity then
		-- destroy tree
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 20, true )

		-- set position
		self:GetParent():SetOrigin( self.point )

		-- destroy
		me:RemoveHorizontalMotionController( self )
		self:Destroy()
	end

end

function modifier_Advanced_timber_chain:OnHorizontalMotionInterrupted()
	-- destroy
	self:GetParent():RemoveHorizontalMotionController( self )
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_Advanced_timber_chain:PlayEffects( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_shredder/shredder_timber_dmg.vpcf"
	local sound_cast = "Hero_Shredder.TimberChain.Damage"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end




function modifier_Advanced_timber_chain:Advanced_GetModifierIncomingDamage_Percentage()return -60 end




function modifier_Advanced_timber_chain:ADDeclareFunctions()
	local funcs	=	{	
				
	}
	if self:GetAbility():GetSpecialValueFor("advanced_level")>=15 then
		table.insert(funcs,advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE)
	end
	return funcs
end



modifier_Advanced_timber_chain_unlock2_active = class({})


function modifier_Advanced_timber_chain_unlock2_active:IsHidden()	return true end
function modifier_Advanced_timber_chain_unlock2_active:IsDebuff()	return false end
function modifier_Advanced_timber_chain_unlock2_active:IsStunDebuff()	return false end
function modifier_Advanced_timber_chain_unlock2_active:IsPurgable()	return false end
function modifier_Advanced_timber_chain_unlock2_active:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.3)
	end
end

function modifier_Advanced_timber_chain_unlock2_active:OnIntervalThink()
	self:StartIntervalThink(2)
	local parent = self:GetParent()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		2000,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		FIND_FARTHEST,	-- int, order filter
		false	-- bool, can grow cache
	)
	for _, unit in ipairs(enemies) do
		if unit~=parent then
			local point = unit:GetOrigin()
			local projectile_speed = 3000
			local projectile_distance = ability:GetSpecialValueFor( "range" )
			local projectile_radius = ability:GetSpecialValueFor( "radius" )
			local projectile_direction = point-parent:GetOrigin()
			projectile_direction.z = 0
			projectile_direction = projectile_direction:Normalized()
			local vision = 100

			local effect = ability:PlayEffects(parent, parent:GetOrigin() + projectile_direction * projectile_distance, projectile_speed, projectile_distance/projectile_speed,false )

			-- create projectile
			local info = {
				Source = parent,
				Ability = ability,
				vSpawnOrigin = parent:GetAbsOrigin(),
				
				bDeleteOnHit = false,
				
				EffectName = "",
				fDistance = projectile_distance,
				fStartRadius = projectile_radius,
				fEndRadius = projectile_radius,
				vVelocity = projectile_direction * projectile_speed,
			
				bHasFrontalCone = false,
				bReplaceExisting = false,
				fExpireTime = GameRules:GetGameTime() + 10.0,
				
				bProvidesVision = true,
				iVisionRadius = vision,
				iVisionTeamNumber = caster:GetTeamNumber(),
			}

			-- register projectile
			local projectile = ProjectileManager:CreateLinearProjectile(info)
			local ExtraData = {
				unit = parent,
				effect = effect,
				ground_target = false,
				use_sky_effect =false,
				target = unit,
			}
			ability.projectiles[ projectile ] = ExtraData
			break
		end
	end

end











modifier_Advanced_timber_chain_unlock3_debuff = modifier_Advanced_timber_chain_unlock3_debuff or advanced_modifier({})

function modifier_Advanced_timber_chain_unlock3_debuff:IsDebuff()return true end
function modifier_Advanced_timber_chain_unlock3_debuff:IsPurgable()return false end
function modifier_Advanced_timber_chain_unlock3_debuff:IsPurgeException() return false end
function modifier_Advanced_timber_chain_unlock3_debuff:OnCreated()
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_Advanced_timber_chain_unlock3_debuff:OnIntervalThink()
	if self:GetStackCount()<=35 then
		self:IncrementStackCount()
	else
		self:StartIntervalThink(-1)
	end
end
function modifier_Advanced_timber_chain_unlock3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,         --魔法抗性
	}
end



function modifier_Advanced_timber_chain_unlock3_debuff:GetModifierMagicalResistanceBonus() return -self:GetStackCount()  end



function modifier_Advanced_timber_chain_unlock3_debuff:OnTooltip()
    return self:Advanced_GetModifierPhysicalArmorBonus()
end

-- advanced_modifier

function modifier_Advanced_timber_chain_unlock3_debuff:ADDeclareFunctions()
    return 
    {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end
function modifier_Advanced_timber_chain_unlock3_debuff:Advanced_GetModifierPhysicalArmorBonus()
    return -self:GetStackCount() 
end