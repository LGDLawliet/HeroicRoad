Middle_mystic_flare =  Middle_mystic_flare or class({})
LinkLuaModifier( "modifier_Middle_mystic_flare_thinker", "skills/Middle_mystic_flare", LUA_MODIFIER_MOTION_NONE )




function Middle_mystic_flare:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/mystic_flare/main_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf", context )
end

function Middle_mystic_flare:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function Middle_mystic_flare:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )
	-- local radius = self:GetSpecialValueFor( "radius" )

	-- create thinker
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_Middle_mystic_flare_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	-- play effects
	local sound_cast = "Hero_SkywrathMage.MysticFlare.Cast"
	EmitSoundOn( sound_cast, caster )

	-- -- scepter effect
	-- if caster:HasScepter() then
	-- 	local scepter_radius = self:GetSpecialValueFor( "scepter_radius" )
		
	-- 	-- find nearby enemies
	-- 	local enemies = FindUnitsInRadius(
	-- 		caster:GetTeamNumber(),	-- int, your team number
	-- 		point,	-- point, center point
	-- 		nil,	-- handle, cacheUnit. (not known)
	-- 		scepter_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
	-- 		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
	-- 		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
	-- 		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
	-- 		0,	-- int, order filter
	-- 		false	-- bool, can grow cache
	-- 	)

	-- 	local target = nil
	-- 	local creep = nil
	-- 	-- prioritize hero
	-- 	for _,enemy in pairs(enemies) do
	-- 		-- only enemies outside cast aoe
	-- 		if (enemy:GetOrigin()-point):Length2D()>radius then
	-- 			if enemy:IsHero() then
	-- 				target = enemy
	-- 				break
	-- 			elseif not creep then
	-- 				-- store first found creep
	-- 				creep = enemy
	-- 			end
	-- 		end
	-- 	end
	-- 	-- no secondary hero found, find creep
	-- 	if not target then
	-- 		target = creep
	-- 	end

	-- 	if target then
	-- 		-- create thinker
	-- 		CreateModifierThinker(
	-- 			caster, -- player source
	-- 			self, -- ability source
	-- 			"modifier_Middle_mystic_flare_thinker", -- modifier name
	-- 			{ duration = duration }, -- kv
	-- 			target:GetOrigin(),
	-- 			caster:GetTeamNumber(),
	-- 			false
	-- 		)
	-- 	end
	-- end
end








modifier_Middle_mystic_flare_thinker = modifier_Middle_mystic_flare_thinker or  class({})

--------------------------------------------------------------------------------
-- Initializations
function modifier_Middle_mystic_flare_thinker:OnCreated( keys )
	-- references
	local interval = self:GetAbility():GetSpecialValueFor( "damage_interval" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + self:GetAbility():GetSpecialValueFor( "bonus_damage" )*self:GetCaster():GetIntellect(false)
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if IsServer() then
		-- precache damage
		self.damage = self.damage*interval/keys.duration
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			-- damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			-- damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( interval )
		self:OnIntervalThink()

		-- play effects
		self:PlayEffects( self.radius, keys.duration, interval )
	end
end


function modifier_Middle_mystic_flare_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_Middle_mystic_flare_thinker:OnIntervalThink()
	local pos = self:GetParent():GetOrigin()
	local range = self.radius*0.7
	self:PlayEffectsHit( pos + Vector(RandomInt(-range, range),RandomInt(-range, range),0) )

	local caster = self:GetCaster()
	-- find heroes
	local units = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		pos,
		nil,	
		self.radius,	
		DOTA_UNIT_TARGET_TEAM_ENEMY,	
		DOTA_UNIT_TARGET_HERO +DOTA_UNIT_TARGET_BASIC,	
		0,	
		0,	
		false	
	)

	
	local count = #units
	if count<1 then return end
	count = math.min(count,3)
	local chance = 45
	if caster:GetRandomEffect(chance,INT_TYPE,1)  > RandomInt(1, 100) then
		self.damageTable.damage = self.damage
	else
		self.damageTable.damage = self.damage/count
	end
	
	for i,unit in pairs(units) do
		self.damageTable.victim = unit
		ApplyDamage( self.damageTable )
		if i>=count then
			break			
		end
	end
end


function modifier_Middle_mystic_flare_thinker:PlayEffects( radius, duration, interval )

	local particle_cast = "particles/rebuild/spell/mystic_flare/main_effect/effect.vpcf"
	local sound_cast = "Hero_SkywrathMage.MysticFlare"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, duration, interval ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end




function modifier_Middle_mystic_flare_thinker:PlayEffectsHit( pos )

	local particle_cast = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_mystic_flare_ambient_hit.vpcf"
	local sound_cast = "Hero_ElderTitan.AncestralSpirit.Damage"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, pos )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end








