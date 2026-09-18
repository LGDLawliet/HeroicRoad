creeps_spell_razor_plasma_field =  creeps_spell_razor_plasma_field or class({})


LinkLuaModifier( "modifier_creeps_spell_razor_plasma_field_debuff", "creeps_spell/creeps_spell_razor_plasma_field", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creeps_spell_razor_plasma_field", "creeps_spell/creeps_spell_razor_plasma_field", LUA_MODIFIER_MOTION_NONE )


function creeps_spell_razor_plasma_field:Precache( context )

	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )

	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_static_link_hit.vpcf", context )

	
	
end


function creeps_spell_razor_plasma_field:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	local speed = self:GetSpecialValueFor( "speed" )

	-- play effects
	local effect = self:PlayEffects( radius, speed )

	-- create ring
	local pulse = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_creeps_spell_razor_plasma_field", -- modifier name
		{
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} -- kv
	)
	pulse:SetCallback( function( enemy )
		self:OnHit( enemy )
	end)

	pulse:SetEndCallback( function()
		if caster:IsNull() then
			return
		end
		ParticleManager:SetParticleControl( effect, 1, Vector( speed, radius, -1 ) )
		local retract
		if not caster:IsAlive() then
			
			-- local thinker = CreateModifierThinker(
			-- 	caster,
			-- 	self, 
			-- 	"modifier_creeps_spell_razor_plasma_field",
			-- 	{
			-- 		start_radius = radius,
			-- 		end_radius = 0,
			-- 		speed = speed,
			-- 		target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			-- 		target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			-- 	}, -- kv
			-- 	caster:GetOrigin(),
			-- 	caster:GetTeamNumber(),
			-- 	false
			-- )
			-- retract = thinker:FindModifierByName( "modifier_creeps_spell_razor_plasma_field" )
			ParticleManager:DestroyParticle( effect, false )
			ParticleManager:ReleaseParticleIndex( effect )
			return
		else
			retract = caster:AddNewModifier(
				caster, 
				self, 
				"modifier_creeps_spell_razor_plasma_field",
				{
					start_radius = radius,
					end_radius = 0,
					speed = speed,
					target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				} -- kv
			)
		end
		retract:SetCallback( function( enemy )
			self:OnHit( enemy )
		end)

		retract:SetEndCallback( function()
			-- destroy particle
			ParticleManager:DestroyParticle( effect, false )
			ParticleManager:ReleaseParticleIndex( effect )
		end)
	end)
end

function creeps_spell_razor_plasma_field:OnHit( enemy )
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	local damage_min = self:GetSpecialValueFor( "damage_min" ) * caster:GetDamageMax()
	local damage_max = self:GetSpecialValueFor( "damage_max" ) * caster:GetDamageMax()
	local slow_min = self:GetSpecialValueFor( "slow_min" )
	local slow_max = self:GetSpecialValueFor( "slow_max" )
	local duration = self:GetSpecialValueFor( "slow_duration" )

	-- calculate damage & slow
	local distance = (enemy:GetOrigin()-caster:GetOrigin()):Length2D()
	local pct = distance/radius
	pct = math.min(pct,1)
	local damage = damage_min + (damage_max-damage_min)*pct
	local slow = slow_min + (slow_max-slow_min)*pct

	-- apply damage
	local damageTable = {
		victim = enemy,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self,
	}
	ApplyDamage(damageTable)
	self:PlayEffects2(enemy)

	enemy:AddNewModifier(caster, self, "modifier_creeps_spell_razor_plasma_field_debuff", {duration = duration*enemy:GetHDStatusResistanceIndex(),slow = slow,} )


	local sound_cast = "Ability.PlasmaFieldImpact"
	EmitSoundOn( sound_cast, enemy )
end


function creeps_spell_razor_plasma_field:PlayEffects( radius, speed )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	local sound_cast = "Ability.PlasmaField"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )

	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end


function creeps_spell_razor_plasma_field:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_static_link_hit.vpcf"
	
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt( effect_cast, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetCaster():GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( effect_cast, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex(effect_cast)

end











modifier_creeps_spell_razor_plasma_field_debuff = modifier_creeps_spell_razor_plasma_field_debuff or class({})
function modifier_creeps_spell_razor_plasma_field_debuff:IsHidden()	return false end
function modifier_creeps_spell_razor_plasma_field_debuff:IsDebuff()	return true end
function modifier_creeps_spell_razor_plasma_field_debuff:IsPurgable()	return true end
function modifier_creeps_spell_razor_plasma_field_debuff:OnCreated( keys )
	if not IsServer() then return end
	self.slow = keys.slow
	self:SetStackCount( self.slow )
end

function modifier_creeps_spell_razor_plasma_field_debuff:OnRefresh( keys )
	if not IsServer() then return end
	self.slow = math.max(keys.slow,self.slow)
	self:SetStackCount( self.slow )
end

function modifier_creeps_spell_razor_plasma_field_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_creeps_spell_razor_plasma_field_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self:GetStackCount()
end











modifier_creeps_spell_razor_plasma_field = class({})

function modifier_creeps_spell_razor_plasma_field:IsHidden()	return true end
function modifier_creeps_spell_razor_plasma_field:IsDebuff()	return false end
function modifier_creeps_spell_razor_plasma_field:IsStunDebuff()	return false end
function modifier_creeps_spell_razor_plasma_field:IsPurgable()	return false end
function modifier_creeps_spell_razor_plasma_field:RemoveOnDeath()	return false end
function modifier_creeps_spell_razor_plasma_field:GetAttributes()	return MODIFIER_ATTRIBUTE_MULTIPLE end

--------------------------------------------------------------------------------
-- Initializations
function modifier_creeps_spell_razor_plasma_field:OnCreated( kv )

	if not IsServer() then return end

	self.start_radius = kv.start_radius or 0
	self.end_radius = kv.end_radius or 0
	self.width = kv.width or 100
	self.speed = kv.speed or 0
	self.outward = self.end_radius>=self.start_radius
	if not self.outward then
		self.speed = -self.speed
	end

	self.target_team = kv.target_team or 0
	self.target_type = kv.target_type or 0
	self.target_flags = kv.target_flags or 0

	self.IsCircle = kv.IsCircle or 1

	self.targets = {}
end
function modifier_creeps_spell_razor_plasma_field:OnDestroy()
	if self.EndCallback then
		self.EndCallback()
	end
	if not IsServer() then return end
	if self:GetParent():GetClassname()=="npc_dota_thinker" then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_creeps_spell_razor_plasma_field:SetCallback( callback )
	self.Callback = callback
	self:StartIntervalThink( 0.03 )
	self:OnIntervalThink()
end

function modifier_creeps_spell_razor_plasma_field:SetEndCallback( callback )
	self.EndCallback = callback
end

function modifier_creeps_spell_razor_plasma_field:OnIntervalThink()
	local radius = self.start_radius + self.speed * self:GetElapsedTime()
	if not self.outward and radius<self.end_radius then
		self:Destroy()
		return
	elseif self.outward and radius>self.end_radius then
		self:Destroy()
		return
	end

	local targets = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	
		self:GetParent():GetOrigin(),	
		nil,	
		radius,	
		self.target_team,	
		self.target_type,
		self.target_flags,
		0,	
		false	
	)

	for _,target in pairs(targets) do
		if not self.targets[target] then
			if (not self.IsCircle) or (target:GetOrigin()-self:GetParent():GetOrigin()):Length2D()>(radius-self.width) then
				self.targets[target] = true
				self.Callback( target )
			end
		end

	end
end