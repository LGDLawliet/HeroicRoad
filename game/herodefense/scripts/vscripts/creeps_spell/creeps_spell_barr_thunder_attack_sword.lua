LinkLuaModifier("modifier_creeps_spell_barr_thunder_attack_sword_buff", "creeps_spell/creeps_spell_barr_thunder_attack_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creeps_spell_barr_thunder_attack_sword_active", "creeps_spell/creeps_spell_barr_thunder_attack_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_creeps_spell_barr_thunder_attack_sword_motion", "creeps_spell/creeps_spell_barr_thunder_attack_sword", LUA_MODIFIER_MOTION_HORIZONTAL )

LinkLuaModifier("modifier_creeps_spell_barr_thunder_debuff", "creeps_spell/creeps_spell_barr_thunder_attack", LUA_MODIFIER_MOTION_NONE)


-- LinkLuaModifier("modifier_creeps_spell_barr_thunder_attack_sword_buff", "creeps_spell/creeps_spell_barr_thunder_attack_sword", LUA_MODIFIER_MOTION_NONE)

creeps_spell_barr_thunder_attack_sword = class({})



function creeps_spell_barr_thunder_attack_sword:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_barr_thunder_attack_sword/sword_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_barr_thunder_attack_sword/effect_charge/effect_charge_active.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_body_buff/effect.vpcf", context )



	
	
end




function creeps_spell_barr_thunder_attack_sword:OnSpellStart()

	local caster = self:GetCaster()
	caster:EmitSound("Hero_TemplarAssassin.Trap.Explode")
	local pos = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	caster:StartGestureWithPlaybackRate(ACT_DOTA_SPAWN,1)
	caster:AddNewModifier(caster, self, "modifier_creeps_spell_barr_thunder_attack_sword_buff", {duration =duration})
	local caster = self:GetCaster()
	local particle_cast = "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_buff/effect.vpcf"
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "" , caster:GetOrigin(), true )
	DestroyParticleByDelay(pfx,1)

	

	
	



end




modifier_creeps_spell_barr_thunder_attack_sword_buff = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_attack_sword_buff:IsHidden() return true end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:IsPurgable() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:IsPurgeException() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:RemoveOnDeath() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:GetPriority() return 1000 end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:OnCreated()
	if IsServer() then
		self.facing = self:GetParent():GetForwardVector()
		self:StartIntervalThink(0.8)
	end
end
function modifier_creeps_spell_barr_thunder_attack_sword_buff:OnIntervalThink()
	if not self.frozen then
		self.frozen = true
		if not self.nFXIndex then
			local parent = self:GetParent()
			-- parent:EmitSound("Hero_TemplarAssassin.Attack")
			parent:EmitSound("lighting_sword_active")
	

			self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/creeps_spell_barr_thunder_attack_sword/sword_effect/effect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, parent, PATTACH_POINT_FOLLOW, "attach_attack3", parent:GetAbsOrigin(), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack3", parent:GetAbsOrigin(), true )
			self:AddParticle( self.nFXIndex, false, false, -1, true, false )
			-- print("self.facing=",self.facing)
			-- local new_facing = RotatePosition(Vector(0, 0, 0), QAngle( 0, 0 , -180 ), self.facing )
			-- local new_facing = self.facing +Vector(0,0,-1)
			-- print("new_facing=",new_facing)
			-- parent:SetForwardVector(new_facing)
			local modifier = parent:AddNewModifier(parent, self:GetAbility(), "modifier_creeps_spell_barr_thunder_attack_sword_active", {duration =duration})
			if modifier then
				modifier:InitFacting(self.facing)
			end
		end
		self:StartIntervalThink(-1)
	end

end

function modifier_creeps_spell_barr_thunder_attack_sword_buff:OnDestroy()
	if IsServer() then
		local parent = self:GetParent()
		parent:SetForwardVector(self.facing)
	end
end



function modifier_creeps_spell_barr_thunder_attack_sword_buff:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true
	}
	if self.frozen then
		state[MODIFIER_STATE_FROZEN] = true
	end
	return state
end




modifier_creeps_spell_barr_thunder_attack_sword_active = advanced_modifier({})

function modifier_creeps_spell_barr_thunder_attack_sword_active:IsHidden() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_active:IsPurgable() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_active:IsDebuff() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_active:IsPurgeException() return false end
function modifier_creeps_spell_barr_thunder_attack_sword_active:RemoveOnDeath() return false end

function modifier_creeps_spell_barr_thunder_attack_sword_active:InitFacting(facing)
	self.facing =facing
end





function modifier_creeps_spell_barr_thunder_attack_sword_active:OnCreated(keys)
	if IsServer() then
		local heroes = GetAllRealHeroes()
		heroes = randomTable(heroes,#heroes)
		
		self.pathPoint = {}
		local currentPoint = self:GetParent():GetAbsOrigin()
		local width = self:GetAbility():GetSpecialValueFor("width")
        for _, unit in pairs(heroes) do
			local pos = unit:GetAbsOrigin() + unit:GetForwardVector()*150

			local particle_cast = "particles/indicator/range_finder_fade/effect.vpcf"
			local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( pfx, 0, currentPoint )
			ParticleManager:SetParticleControl( pfx, 1, pos )
			ParticleManager:SetParticleControl( pfx,60, Vector(width,0,0) )
			ParticleManager:SetParticleShouldCheckFoW(pfx, false)
			local data = {
				startPos = currentPoint,
				endPos = pos,
				particleIndex = pfx,
				
			}
			
			currentPoint = pos
			table.insert(self.pathPoint,data)
        end
		self:StartIntervalThink(1)

	end

end

function modifier_creeps_spell_barr_thunder_attack_sword_active:OnIntervalThink()
	-- self:StartIntervalThink(0.03)
	-- if self:GetParent():HasModifier("modifier_creeps_spell_barr_thunder_attack_sword_motion") then
	-- 	return
	-- end
	if #self.pathPoint<=0 then
		self:Destroy()
		return
	end
	local caster = self:GetCaster()
	local particle_cast = "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect_body_buff/effect.vpcf"
	local pfx = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc" , caster:GetOrigin(), true )
	DestroyParticleByDelay(pfx,1)



	self:StartIntervalThink(-1)
	local targetPos = self.pathPoint[1].endPos
	ParticleManager:DestroyParticle(self.pathPoint[1].particleIndex,true)
	self:GetParent():SetForwardVector( CalculateDirection(self.pathPoint[1].endPos,self.pathPoint[1].startPos) +Vector(0,0,-1.5) )


	table.remove(self.pathPoint,1)
	-- print("#self.pathPoint=",#self.pathPoint)


	local modifier = caster:AddNewModifier(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_creeps_spell_barr_thunder_attack_sword_motion", -- modifier name
		{
			duration = 3,
		} -- kv
	)
	if modifier then
		modifier:InitEffect(targetPos,self.facing)
	end

	
end


function modifier_creeps_spell_barr_thunder_attack_sword_active:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_creeps_spell_barr_thunder_attack_sword_buff")
	end
end






modifier_creeps_spell_barr_thunder_attack_sword_motion = class({})


function modifier_creeps_spell_barr_thunder_attack_sword_motion:IsHidden()	return true end
function modifier_creeps_spell_barr_thunder_attack_sword_motion:IsDebuff()	return false end
function modifier_creeps_spell_barr_thunder_attack_sword_motion:IsStunDebuff()	return false end
function modifier_creeps_spell_barr_thunder_attack_sword_motion:IsPurgable()	return false end
function modifier_creeps_spell_barr_thunder_attack_sword_motion:InitEffect(targetPos,facing)
	if not IsServer() then return end

	local parent = self:GetParent()
	parent:EmitSound("lighting_sword_move")
	self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/creeps_spell_barr_thunder_attack_sword/effect_charge/effect_charge_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true )

	self.nFXIndex2 = ParticleManager:CreateParticle( "particles/rebuild/spell/creeps_spell_barr_thunder_attack_sword/effect_charge/effect_charge_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent )
	ParticleManager:SetParticleControlEnt( self.nFXIndex2, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( self.nFXIndex2, 3, parent, PATTACH_POINT_FOLLOW, "attach_attack2", parent:GetAbsOrigin(), true )

	self.immunity_damage_index = self:GetAbility():GetSpecialValueFor("immunity_damage_index")*0.01
	self.lightning_bonus_damage = self:GetAbility():GetSpecialValueFor("lightning_bonus_damage")

	

	-- references
	self.damage = self:GetAbility():GetSpecialValueFor( "base_damage" ) + self:GetCaster():GetAverageTrueAttackDamage(nil)*self:GetAbility():GetSpecialValueFor( "bonus_damage" )
	self.speed = 15000

	self.radius = self:GetAbility():GetSpecialValueFor( "width" )
	self.point = targetPos
	self.facing = facing

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	-- ApplyDamage(damageTable)

	-- init
	self.proximity = 300
	self.caught_enemies = {}
	self.caught_target_count = 0

	-- start motion controller
	if not self:ApplyHorizontalMotionController() then
		self:Destroy()
	end
end




function modifier_creeps_spell_barr_thunder_attack_sword_motion:OnDestroy()
	if not IsServer() then return end
	if self.nFXIndex2 then
		ParticleManager:DestroyParticle(self.nFXIndex2,false)
	end
	if self.nFXIndex then
		ParticleManager:DestroyParticle(self.nFXIndex,false)
	end
	local modifier = self:GetParent():FindModifierByName("modifier_creeps_spell_barr_thunder_attack_sword_active")
	if modifier then
		modifier:OnIntervalThink()
	end
	-- print("destroy")
end

-------------------------------------------------------------SetParticleControl-------------------
-- Status Effects
function modifier_creeps_spell_barr_thunder_attack_sword_motion:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_creeps_spell_barr_thunder_attack_sword_motion:UpdateHorizontalMotion( me, dt )
	local caster = self:GetCaster()
	local origin = me:GetOrigin()
	local direction = (self.point-origin)
	direction.z = 0
	direction = direction:Normalized()

	-- set origin
	local target = origin + direction * self.speed * dt
	me:SetOrigin( target )
	-- me:SetForwardVector(self.facing)

	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		origin,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- check if already hit
		if not self.caught_enemies[enemy] then
			enemy:EmitSound("lighting_sword_damage")
			self.caught_enemies[enemy] = true
			self.caught_target_count =  self.caught_target_count +1
			-- damage
			self.damageTable.victim = enemy
			if enemy:IsMagicImmune() then
				self.damageTable.damage = self.damage * self.immunity_damage_index
			else
				self.damageTable.damage = self.damage
			end
			ApplyDamage( self.damageTable )
			if IsValid(enemy) and enemy:IsAlive() then
				--enemy:AddNewModifier(enemy, self:GetAbility(), "modifier_creeps_spell_barr_thunder_debuff", {duration =-1,stack=self.lightning_bonus_damage})
				enemy:Elecshocking(caster, self:GetAbility(), self.lightning_bonus_damage)
			end
		end
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

function modifier_creeps_spell_barr_thunder_attack_sword_motion:OnHorizontalMotionInterrupted()
	-- destroy
	self:GetParent():RemoveHorizontalMotionController( self )
	self:Destroy()
end

