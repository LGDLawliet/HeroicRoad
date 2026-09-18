--特效优化 √
Advanced_dragon_slave = class({})

LinkLuaModifier("modifier_Advanced_dragon_slave_move", "skills/Advanced_dragon_slave", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_Advanced_dragon_slave_unlock1", "skills/Advanced_dragon_slave", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Advanced_dragon_slave_unlock3_thinker", "skills/Advanced_dragon_slave", LUA_MODIFIER_MOTION_NONE )
function Advanced_dragon_slave:UnlockFirstCore(key)
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_Advanced_dragon_slave_unlock1",{} )
	return true
end
function Advanced_dragon_slave:UnlockSecondCore(key)
	return true
end
function Advanced_dragon_slave:UnlockThirdCore(key)
	self.thinker = {}
	return true
end

function Advanced_dragon_slave:CheckKV(key)
	local table = {

		damage =15,
		bonus_damage = 0.1,

	}
	local value = table[key] or -1
	return value

end


function Advanced_dragon_slave:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/dragon_slave/unlock3/effect_lock_upheaval_hellborn.vpcf", context )
end










function Advanced_dragon_slave:GetCastRange()
	-- local caster =self:GetCaster()
	--该技能需要从网表拿等级数据 自定义变量拿不到该值
	local NetTable_key = tostring(self:GetCaster():GetPlayerOwnerID()).."_"..self:GetAbilityName()
	local advanced_level = CustomNetTables:GetTableValue( "playerSpellLevelInfo", NetTable_key).level
	if advanced_level>=20 then
		return math.max(self:GetSpecialValueFor("range")+400+self:GetCaster():GetCastRangeBonus(),100)
	end

	return self:GetSpecialValueFor("range")

end

function Advanced_dragon_slave:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	if self.unlock3 then
		local thinker =CreateModifierThinker(
			caster,
			self,
			"modifier_Advanced_dragon_slave_unlock3_thinker",
			{
				-1,
			},
			caster:GetAbsOrigin(),
			caster:GetTeamNumber(),
			false
		)
		local modifier = thinker:FindModifierByName("modifier_Advanced_dragon_slave_unlock3_thinker")
		table.insert(self.thinker,modifier)
		if #self.thinker>8 then
			for i = 1, 8, 1 do
				if self.thinker[i] and not self.thinker[i]:IsNull() then
					self.thinker[i]:Destroy()
					table.remove(self.thinker,i)
					break
				end
			end
		end

	end

	if target then
		point = target:GetOrigin()
	end
	if point == caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end
	if not self.ProjectileTable then
		self.ProjectileTable = {}
	end
	-- load data
	local projectile_name = "particles/rebuild/spell/dragon_slave/new_dragon_slave_headflame.vpcf"
	local projectile_distance = math.max(self:GetSpecialValueFor( "range" )+caster:GetCastRangeBonus(),100)
	if self.advanced_level>=20 then
		projectile_distance = math.max(projectile_distance+400+caster:GetCastRangeBonus(),100)
	end
	local projectile_speed = 1000
	local projectile_start_radius = 100
	local projectile_end_radius = 350
	if self.unlock2 then
		projectile_speed = 100
	end

	-- get direction
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	local particle = ProjectileManager:CreateLinearProjectile(info)
	self.ProjectileTable[particle] = {
		bonus_index = 1,
		split = true,
		move_dis = 0,
		current_pos = ProjectileManager:GetLinearProjectileLocation( particle ),
	}
	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
end

--------------------------------------------------------------------------------
-- Projectile
function Advanced_dragon_slave:OnProjectileHitHandle( target, location, projectile )
	if not target then return end

	local damage = (self:GetSpecialValueFor("damage")+self:GetSpecialValueFor("bonus_damage")*self:GetCaster():GetIntellect(false))*self.ProjectileTable[projectile].bonus_index
	if not self.ProjectileTable[projectile].split then
		damage = damage*0.3
	end
	if self.unlock1 then
		local modifier = self:GetCaster():FindModifierByName("modifier_Advanced_dragon_slave_unlock1")
		if modifier then
			damage = damage * (modifier:GetStackCount()*0.2+1)
		end
	end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	ApplyDamage( damageTable )

	if self.advanced_level>=5 then
		self.ProjectileTable[projectile].bonus_index = self.ProjectileTable[projectile].bonus_index +0.06
	else
		self.ProjectileTable[projectile].bonus_index = self.ProjectileTable[projectile].bonus_index +0.04
	end

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()
	if self.advanced_level>=15 and self.ProjectileTable[projectile].split then
		target:AddNewModifier(self:GetCaster(), self, "modifier_Advanced_dragon_slave_move", {duration=0.5,directionx =direction.x,directiony=direction.y}) 
	end
	-- play effects
	self:PlayEffects( target, direction )
end

function Advanced_dragon_slave:OnProjectileThinkHandle( iProjectileHandle ) 
	-- init for the first time
	if not self.ProjectileTable[iProjectileHandle] then
		return
	end
	

	local data = self.ProjectileTable[iProjectileHandle]
	if not data.split then  --不可分裂的子火焰
		return
	end
	local caster = self:GetCaster()
	local location = ProjectileManager:GetLinearProjectileLocation( iProjectileHandle )
	local dis = CalculateDistance(data.current_pos,location)
	data.current_pos = location
	data.move_dis = data.move_dis+ dis
	local projectile_distance = math.max(self:GetSpecialValueFor( "range" )+caster:GetCastRangeBonus(),100)
	if self.advanced_level>=20 then
		projectile_distance = math.max(projectile_distance+400+caster:GetCastRangeBonus(),100)
	end
	local projectile_speed = 1000
	local projectile_start_radius = 100
	local projectile_end_radius = 350
	if self.advanced_level>=10 then
		projectile_distance = projectile_distance*1.5
		projectile_start_radius =projectile_start_radius*1.5
		projectile_end_radius = projectile_end_radius*1.5
	end
	local need_dis = 200
	if self.unlock2 then
		need_dis = need_dis *0.3
	end 
	if data.move_dis>=need_dis then --触发次级火焰
		data.move_dis = data.move_dis-need_dis
		local new_pos = location+ Vector(RandomInt(-100, 100),RandomInt(-100, 100),0)
		local direction = new_pos-location
		direction.z = 0
		local projectile_direction = direction:Normalized()
		if self.unlock2 then
			projectile_direction = ProjectileManager:GetLinearProjectileVelocity( iProjectileHandle )
			projectile_direction.z = 0
			projectile_direction = projectile_direction:Normalized()
		end
		local info = {
			Source = caster,
			Ability = self,
			vSpawnOrigin =location,
			
			bDeleteOnHit = false,
			
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			
			EffectName = "particles/rebuild/spell/dragon_slave/new_dragon_slave_headflame.vpcf",
			fDistance = projectile_distance,
			fStartRadius = projectile_start_radius,
			fEndRadius = projectile_end_radius,
			vVelocity = projectile_direction * projectile_speed,
	
			bProvidesVision = false,
		}
		local particle = ProjectileManager:CreateLinearProjectile(info)
		local sound_cast = "Hero_Lina.DragonSlave"
		EmitSoundOn( sound_cast, self:GetCaster() )
		self.ProjectileTable[particle] = {
			bonus_index = 1,
			split = false,
		}
	end

end

--------------------------------------------------------------------------------
function Advanced_dragon_slave:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end










modifier_Advanced_dragon_slave_move = class({})

function modifier_Advanced_dragon_slave_move:IsDebuff()			return false end
function modifier_Advanced_dragon_slave_move:IsHidden() 			return true end
function modifier_Advanced_dragon_slave_move:IsPurgable() 		return false end
function modifier_Advanced_dragon_slave_move:IsPurgeException() 	return false end
function modifier_Advanced_dragon_slave_move:IsMotionController() return true end
function modifier_Advanced_dragon_slave_move:GetMotionControllerPriority() return DOTA_MOTION_CONTROLLER_PRIORITY_HIGH end
function modifier_Advanced_dragon_slave_move:CheckState() local state = {[MODIFIER_STATE_STUNNED] = true,  } return state end
function modifier_Advanced_dragon_slave_move:OnCreated(keys)
    if IsServer() then
        self.direction = Vector(0,0,0)
		self.direction.x= keys.directionx
		self.direction.y = keys.directiony
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 1000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end
function modifier_Advanced_dragon_slave_move:OnRefresh(keys)
    if IsServer() then
        self.direction = keys.direction
		--self.direction = StringToVector(keys.key_drection)
		self.speed = 1000
		self:StartIntervalThink(FrameTime())   --FrameTime()获取上一帧在服务器上花费的时间
	end
end


function modifier_Advanced_dragon_slave_move:OnIntervalThink(keys)   
    if  IsServer() then
		if not self.direction then
			return
		end
		local me = self:GetParent()
		local dt = FrameTime()
		local new_pos = me:GetAbsOrigin() + self.direction * (self.speed / (1.0 / dt))  
		new_pos = GetGroundPosition(new_pos, nil)   
		me:SetOrigin(new_pos)  
		ResolveNPCPositions(new_pos, 70)
    end
end







modifier_Advanced_dragon_slave_unlock1 = class({})


function modifier_Advanced_dragon_slave_unlock1:IsHidden()	return false end
function modifier_Advanced_dragon_slave_unlock1:IsDebuff()	return false end
function modifier_Advanced_dragon_slave_unlock1:IsStunDebuff()	return false end
function modifier_Advanced_dragon_slave_unlock1:RemoveOnDeath()	return false end
function modifier_Advanced_dragon_slave_unlock1:DestroyOnExpire()	return false end
function modifier_Advanced_dragon_slave_unlock1:IsPurgable() 		return false end
function modifier_Advanced_dragon_slave_unlock1:IsPurgeException() 	return false end
-- function modifier_Advanced_dragon_slave_unlock1:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_Advanced_dragon_slave_unlock1:OnCreated(keys)
	if IsServer() then
		self.spell = self:GetAbility()
	end
end
function modifier_Advanced_dragon_slave_unlock1:DeclareFunctions() return {MODIFIER_EVENT_ON_ABILITY_FULLY_CAST} end
function modifier_Advanced_dragon_slave_unlock1:OnAbilityFullyCast(keys)
	if not IsServer() then
		return
	end
	if keys.unit ~= self:GetParent()  or self:GetParent():IsIllusion() then 
		return 
	end
	if keys.ability and string.find(keys.ability:GetAbilityName(), "item_") then 
		return 
	end
	if keys.ability==self:GetAbility() then
		self:SetStackCount(math.min(self:GetStackCount()+1,50))
	else
		self:SetStackCount(0)
	end

end







modifier_Advanced_dragon_slave_unlock3_thinker = class({})
function modifier_Advanced_dragon_slave_unlock3_thinker:OnCreated(params)
	if IsServer() then
		self.effect_cast = ParticleManager:CreateParticle( "particles/rebuild/spell/dragon_slave/unlock3/effect_lock_upheaval_hellborn.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControl( self.effect_cast, 0, self:GetParent():GetAbsOrigin()  )
		ParticleManager:SetParticleControl( self.effect_cast, 1, Vector(500,0,0) )
		self:StartIntervalThink(3)
	end
end
function modifier_Advanced_dragon_slave_unlock3_thinker:OnIntervalThink()
	local ability = self:GetAbility()
	if not ability then
		self:SafeDestroy()
		return
	end
	local caster = self:GetCaster()

	local units = FindUnitsInRadius(caster:GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+ DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	local damageTable = {
		-- victim = keys.attacker,
		attacker = caster,
		-- attacker = self.caster,
		damage =(ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*caster:GetIntellect(false)),
		damage_type = DAMAGE_TYPE_MAGICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE,
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	for i,unit in pairs(units) do
		damageTable.victim = unit
		ApplyDamage(damageTable)

	end
end
function modifier_Advanced_dragon_slave_unlock3_thinker:OnDestroy(params)
	if not IsServer() then
		return
	end
	ParticleManager:DestroyParticle(self.effect_cast,false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)
	if self:GetParent() then
		UTIL_Remove( self:GetParent() )
	end
end
