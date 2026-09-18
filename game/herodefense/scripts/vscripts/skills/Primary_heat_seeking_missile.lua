
Primary_heat_seeking_missile = Primary_heat_seeking_missile or class({})


function Primary_heat_seeking_missile:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_tinker/tinker_missile.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", context )

end
function Primary_heat_seeking_missile:GetCastRange()
	return self:GetSpecialValueFor("radius")		 
end



function Primary_heat_seeking_missile:CastFilterResult()
	-- check nohammer
	if IsClient() then
		return
	end
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)

	if #units==0 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function Primary_heat_seeking_missile:GetCustomCastError()
	if IsClient() then
		return
	end

	return "#DOTA_CUSTOM_CAST_DENY_NO_TARGET"
end

function Primary_heat_seeking_missile:OnSpellStart(scepter)
	local caster = self:GetCaster()


	local radius = self:GetSpecialValueFor("radius")
	local count = self:GetSpecialValueFor("count")
	local speed = self:GetSpecialValueFor("speed")
	local damage = self:GetSpecialValueFor("basic_damage") + self:GetSpecialValueFor("bonus_damage") * caster:GetIntellect(false)
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius,
	DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)


	local info = 
	{
		-- Target = target,
		Source = caster,
		Ability = self,	
		EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
		-- iMoveSpeed = speed + RandomInt(-200, 200),
		vSourceLoc = caster:GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {damage = damage}   --额外的数据
	}
	local current_count = 0
	for _, unit in ipairs(units) do
		info.Target = unit
		info.iMoveSpeed = speed + RandomInt(-200, 200)
		ProjectileManager:CreateTrackingProjectile(info)
		current_count = current_count + 1
		if current_count>=count then
			break
		end
	end
	

	caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")
end

function Primary_heat_seeking_missile:OnProjectileHit_ExtraData(target, location, keys)
	if not target then
		return
	end

	target:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
	
	if not target:IsMagicImmune() then
		local particle_cast = "particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf"
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt(effect_cast,0,target,PATTACH_POINT_FOLLOW,"attach_hitloc",target:GetOrigin(),true )
		DestroyParticleByDelay(effect_cast,3)
		local damageTable = {
			victim = target,
			attacker = self:GetCaster(),
			damage = keys.damage,
			damage_type = self:GetAbilityDamageType(),
			ability = self, --Optional.
		}
		ApplyDamage(damageTable)
	end
end
