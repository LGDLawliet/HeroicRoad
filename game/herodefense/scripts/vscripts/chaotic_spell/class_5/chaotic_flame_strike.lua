
chaotic_flame_strike = class({})

LinkLuaModifier( "modifier_chaotic_flame_strike", "chaotic_spell/class_5/chaotic_flame_strike", LUA_MODIFIER_MOTION_NONE )


function chaotic_flame_strike:GetAOERadius()
	local radius = self:GetSpecialValueFor( "radius" )
	if self:GetRuneType() == 2 then
		radius = radius*(1-self:GetSpecialValueFor("rune_2_radius")*0.01)
	end
	return radius
end

function chaotic_flame_strike:GetBehavior()
	if self:GetRuneType()==1 then
		return DOTA_ABILITY_BEHAVIOR_POINT + DOTA_ABILITY_BEHAVIOR_AOE + DOTA_ABILITY_BEHAVIOR_AUTOCAST
	end
	return self.BaseClass.GetBehavior(self)
end



function chaotic_flame_strike:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor("delay")
    if self:GetRuneType() == 1 and self:GetAutoCastState() then
        duration = self:GetSpecialValueFor("rune_1_delay")
    end

    -- 创建原始thinker
    CreateModifierThinker(
        caster,
        self,
        "modifier_chaotic_flame_strike",
        { duration = duration },
        point,
        caster:GetTeamNumber(),
        false
    )

    -- 检查是否为rune2
    if self:GetRuneType() == 2 then
        local radius = self:GetSpecialValueFor("radius")*(1-self:GetSpecialValueFor("rune_2_radius")*0.01)
        -- 随机一个方向
        local angle = RandomFloat(0, 2 * math.pi)
        local dir = Vector(math.cos(angle), math.sin(angle), 0)
        -- 计算新点
        local offset = dir * radius * 2-1
        local point1 = point + offset
        local point2 = point - offset

        -- 创建两个新的thinker
        CreateModifierThinker(
            caster,
            self,
            "modifier_chaotic_flame_strike",
            { duration = duration },
            point1,
            caster:GetTeamNumber(),
            false
        )
        CreateModifierThinker(
            caster,
            self,
            "modifier_chaotic_flame_strike",
            { duration = duration },
            point2,
            caster:GetTeamNumber(),
            false
        )
    end
end


function chaotic_flame_strike:Precache( context )
	PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_hit/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_ring/effect.vpcf", context )
end



modifier_chaotic_flame_strike = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_chaotic_flame_strike:IsHidden()	return true end
function modifier_chaotic_flame_strike:IsPurgable()	return false end


function modifier_chaotic_flame_strike:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()

	-- self.stun = ability:GetSpecialValueFor( "duration" )
	local bonusIndex = ability:GetSpecialValueFor( "mana_as_bonus_damage" )*math.floor(self:GetCaster():GetMana()/1000)
	bonusIndex= math.min(bonusIndex,ability:GetSpecialValueFor("max_mana_as_bonus_damage"))
	self.damage = ability:GetSpecialValueFor( "damage" ) +  (ability:GetSpecialValueFor( "bonus_damage" )+bonusIndex)*self:GetCaster():HDGetPrimaryStatValue()

	if ability:GetRuneType()==1 and ability:GetAutoCastState() then
		self.damage = self.damage *( ability:GetSpecialValueFor("rune_1_bonus")*0.01+1)*ability:GetEffectGain()
	end

	self.radius = ability:GetSpecialValueFor( "radius" )
	if ability:GetRuneType() == 2 then
		self.rune_2_radius = ability:GetSpecialValueFor("rune_2_radius")
		self.radius = self.radius*(1-self.rune_2_radius*0.01)
	end
	self.rune_3_index = ability:GetSpecialValueFor("rune_3_index")*0.01
	-- self:PlayEffects1()
	if self:GetRemainingTime()>=1 then
		local particle_cast = "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_ring/effect.vpcf"
		self.effect_ring = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( self.effect_ring, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.effect_ring, 10, Vector( self.radius, 1, 1 ) )

		self:AddParticle(self.effect_ring, false, false, -1, false, false)
		
		
	end
end


function modifier_chaotic_flame_strike:OnDestroy()
	if not IsServer() then return end
	-- destroy trees
	
	local ability = self:GetAbility()
	if not ability then
		UTIL_Remove( self:GetParent() )
		return
	end

	local caster = self:GetCaster()

	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = self.damage,
		damage_type = ability:GetAbilityDamageType(),
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE+HD_DAMAGE_FLAG_HOLY_DAMAGE,
		
	}

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	
	for _,enemy in pairs(enemies) do
		-- 弱驱散
		enemy:Purge(true, false, false, false, false)
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		if ability:GetRuneType()==3 then
			local modifier = enemy:FindModifierByName("modifier_hd_burning")
			if modifier then
				ApplyBurningDamage(caster, ability, enemy, modifier:GetStackCount()*self.rune_3_index)
			end
		end
	end

	-- play effects
	self:PlayEffects2()

	if self.effect_ring then
		ParticleManager:DestroyParticle(self.effect_ring,true)
	end
	-- remove thinker
	UTIL_Remove( self:GetParent() )
end


function modifier_chaotic_flame_strike:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_hit/effect.vpcf"
	local sound_cast = "Ability.LightStrikeArray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end