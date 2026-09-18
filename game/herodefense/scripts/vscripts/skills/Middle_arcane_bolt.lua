Middle_arcane_bolt = Middle_arcane_bolt or class({})

function Middle_arcane_bolt:Precache( context )
	-- PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf", context )

end

function Middle_arcane_bolt:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_skywrath_mage/skywrath_mage_arcane_bolt.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "bolt_speed" )
	local projectile_vision = 300
	local base_damage = self:GetSpecialValueFor( "damage" )
	local multiplier = self:GetSpecialValueFor( "bonus_damage" )

	-- calculate damage
	local damage = base_damage
	if caster:IsHero() then
		damage = damage + multiplier*caster:GetIntellect(false)
	end

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = false,                           -- Optional
	
		bVisibleToEnemies = true,                         -- Optional

		bProvidesVision = true,                           -- Optional
		iVisionRadius = projectile_vision,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional

		ExtraData = {
			damage = damage,
		}
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local radius = self:GetCastRange(caster:GetOrigin(), target) +  caster:GetCastRangeBonus() 
	radius = math.max(radius,100)
		
	-- find nearby enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)


	local count = 1
	for _,enemy in pairs(enemies) do
		if enemy~=target then
			info.Target = enemy
			ProjectileManager:CreateTrackingProjectile(info)
			count = count - 1
			if count<=0 then
				break
			end
		end
	end



	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function Middle_arcane_bolt:OnProjectileHit_ExtraData( target, location, extraData )
	if not target then return end	

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = extraData.damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- vision
	local vision = 350
	local duration = 3.53
	AddFOWViewer(
		self:GetCaster():GetTeamNumber(), --nTeamID
		target:GetOrigin(), --vLocation
		vision, --flRadius
		duration, --flDuration
		false --bObstructedVision
	)

	-- play effects
	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Impact"
	EmitSoundOn( sound_cast, target )

	local sound_cast = "Hero_SkywrathMage.ArcaneBolt.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end