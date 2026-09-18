Primary_aftershock = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "skills/Primary_aftershock", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_Primary_aftershock", "skills/Primary_aftershock", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function Primary_aftershock:GetIntrinsicModifierName()
	return "modifier_Primary_aftershock"
end
function Primary_aftershock:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("radius")
end

modifier_Primary_aftershock = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_Primary_aftershock:IsHidden()	return true end
function modifier_Primary_aftershock:IsPurgable() 		return false end
function modifier_Primary_aftershock:IsPurgeException() 	return false end
function modifier_Primary_aftershock:RemoveOnDeath()  return false end

--------------------------------------------------------------------------------
-- Initializations
-- function modifier_Primary_aftershock:OnCreated( kv )
-- 	-- references


-- 	if IsServer() then

-- 	end
-- end



function modifier_Primary_aftershock:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_Primary_aftershock:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function modifier_Primary_aftershock:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() or params.ability:IsItem() then return end

		local cooldown = params.ability:GetCooldown(params.ability:GetLevel())
		if cooldown <= 1 then
			return
		end
		local index= math.min(1,cooldown/10)
		local caster = self:GetCaster()
		local particle_cast = "particles/units/heroes/hero_earthshaker/earthshaker_aftershock.vpcf"

		if caster:HasModifier("modifier_heroTalent_npc_dota_hero_earthshaker_2") then
			particle_cast = "particles/rebuild/spell/after_shock/talent2/effect.vpcf"
			caster:EmitSound("Hero_EarthShaker.BlinkLayer")
			if cooldown>=2 then
				index = 1
			end
		end

		-- Find enemies in radius
		local ability = self:GetAbility()

		local radius = ability:GetSpecialValueFor("radius")
		local damage = ability:GetSpecialValueFor("damage")+caster:GetStrength()*ability:GetSpecialValueFor("bonus_damage")
		local duration = ability:GetSpecialValueFor("duration")*index
		damage =damage *index
		local enemies = FindUnitsInRadius(
			caster:GetTeamNumber(),	-- int, your team number
			caster:GetOrigin(),	-- point, center point
			nil,	-- handle, cacheUnit. (not known)
			radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
			DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
			0,	-- int, flag filter
			0,	-- int, order filter
			false	-- bool, can grow cache
		)

		local damagetable= {
			attacker = caster,
			damage = damage,
			damage_type = ability:GetAbilityDamageType(),
			ability = ability,
			}
		-- apply stun and damage
		local ModifierStatusNegativeGain = caster:GetModifierStatusNegativeGainIndex(1)
		
		for _,enemy in pairs(enemies) do
			local StatusResistance = enemy:GetHDStatusResistanceIndex(1)*ModifierStatusNegativeGain
			enemy:AddNewModifier(caster,ability,"modifier_stunned",{ duration = duration*StatusResistance })

			damagetable.victim = enemy
			ApplyDamage(damagetable)
		end




		-- Create Particle
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
end

