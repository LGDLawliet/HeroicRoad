LinkLuaModifier( "modifier_chaotic_sky_fire", "chaotic_spell/class_super/chaotic_sky_fire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_sky_fire_thinker", "chaotic_spell/class_super/chaotic_sky_fire.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_chaotic_sky_fire_thinker_true", "chaotic_spell/class_super/chaotic_sky_fire.lua", LUA_MODIFIER_MOTION_NONE )
chaotic_sky_fire = class({})


require("internal.ui_event.boss_entry")
function chaotic_sky_fire:GetAOERadius()
	return self:GetSpecialValueFor("radius")*self:GetSpecialValueFor("index")*0.01
end
function chaotic_sky_fire:GetManaCost(iLevel)
    if self:GetRuneType()==3 then
        return 0
    end
	return self.BaseClass.GetManaCost(self,iLevel)
end
function chaotic_sky_fire:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/hit_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
end
function chaotic_sky_fire:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	if point == caster:GetAbsOrigin() then
		point = point + caster:GetForwardVector()
	end
	local mp_cost = caster:GetMana()
	caster:Script_ReduceMana(mp_cost, self)
	local mp_index = 1+ (math.floor(mp_cost/100)*self:GetSpecialValueFor("mp_index")*0.01)
	local index = self:GetSpecialValueFor("index")*0.01

	if self:GetRuneType() == 1 and not caster:HasAbility("chaotic_rune11_amn") then
		mp_index = mp_index*(1+self:GetSpecialValueFor("rune_1_index")*0.01)
	end

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_chaotic_sky_fire_thinker_true", -- modifier name
		{index = 1,mp_index = mp_index}, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)

	caster:GameTimer(0.5,function()
		CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_chaotic_sky_fire_thinker_true", -- modifier name
		{index = index,mp_index = mp_index}, -- kv
		point,
		caster:GetTeamNumber(),
		false
		)
	end)
end
----------------------------------------------------------------------------------------------------------------
modifier_chaotic_sky_fire_thinker_true = class({})

function modifier_chaotic_sky_fire_thinker_true:IsHidden()	return true end


function modifier_chaotic_sky_fire_thinker_true:OnCreated( kv )
	if IsServer() then

		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()
		self.index = kv.index or 1
		self.mp_index = kv.mp_index or 1
		-- 落地时间
		self.delay = 1.3
		self.radius = ability:GetSpecialValueFor("radius")
		self.interval = 0.3

		self.radius = self.radius*self.index

		-- variables
		self.fallen = false
		self.effect_unit = {}
		self.effect_unit2 = {}
		self:StartIntervalThink( self.delay )

		self:PlayEffects1()
	end
end

function modifier_chaotic_sky_fire_thinker_true:OnDestroy( kv )

		local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
		local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
		StopSoundOn( sound_loop, self:GetParent() )
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
		UTIL_Remove(self:GetParent())
end

function modifier_chaotic_sky_fire_thinker_true:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		
		self:PlayEffects2()
		self:GetCaster():GameTimer(0.7,function ()
			self:PlayEffects2()
			--print("执行特效")
			if self.index > 1 then
				self:BurnEnd()
				--print("执行伤害")
			end
		end)
	end
end

-- 陨石落地，撞击瞬间
function modifier_chaotic_sky_fire_thinker_true:Burn()
	if not IsServer() then return end
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end

	local caster = self:GetCaster()

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
	local damage = (ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():HDGetPrimaryStatValue())*self.index*self.mp_index
	local damageTable = {
		-- victim = target,
		damage = damage,
		attacker = self:GetCaster(),
		damage_type = ability:GetAbilityDamageType(),
		ability = ability,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	

	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			damageTable.victim = enemy
			if ability:GetRuneType() == 2 then
				local distance = CalculateDistance(self:GetParent(),enemy)
				local rune_2_index_max = ability:GetSpecialValueFor("rune_2_index_max")--150
				local damageindex = (rune_2_index_max - distance*ability:GetSpecialValueFor("rune_2_damage_down"))*0.01
				damageTable.damage = damage*damageindex
			end
			ApplyDamage( damageTable )
			--print("陨石伤害")
		end
	end
end

-- 陨石落地，撞击瞬间
function modifier_chaotic_sky_fire_thinker_true:BurnEnd()
	if not IsServer() then return end
	--print("Burnend触发1")
	if not self:GetCaster() then
		self:SafeDestroy()
		return
	end
	local ability = self:GetAbility()
	if not ability then
		return
	end
	--print("Burnend触发2")
	local caster = self:GetCaster()

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
	--print("Burnend触发3")
	local damage = (ability:GetSpecialValueFor("damage")+ability:GetSpecialValueFor("bonus_damage")*self:GetCaster():HDGetPrimaryStatValue())*self.index*self.mp_index*self:GetAbility():GetSpecialValueFor("damage_end")*0.01
	local damageTable = {
		-- victim = target,
		damage = damage,
		attacker = self:GetCaster(),
		damage_type = ability:GetAbilityDamageType(),
		ability = ability,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	--print("Burnend触发4")

	for _,enemy in pairs(enemies) do
		if not self.effect_unit2[enemy] then
			self.effect_unit2[enemy] =true
			damageTable.victim = enemy
			if ability:GetRuneType() == 2 then
				local distance = CalculateDistance(self:GetParent(),enemy)
				local rune_2_index_max = ability:GetSpecialValueFor("rune_2_index_max")--150
				local damageindex = (rune_2_index_max - distance*ability:GetSpecialValueFor("rune_2_damage_down"))*0.01
				damageTable.damage = damage*damageindex
			end
			ApplyDamage( damageTable )
			--print("Burnend伤害")
		end
	end
end

function modifier_chaotic_sky_fire_thinker_true:PlayEffects1()
	if not self:GetCaster() then
		return
	end

	local particle_cast = "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"
	local height = 1000
	local height_target = -0

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay+0.7, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1.5/275, 0 ) )
	ParticleManager:SetParticleShouldCheckFoW(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_chaotic_sky_fire_thinker_true:PlayEffects2()
	if not IsServer() then return end
	if not self:GetCaster() then
		return
	end
	if not self:GetAbility() then
		self:SafeDestroy()
		return
	end

	ScreenShake( self:GetParent():GetOrigin(), 100.0, 100.0, 1.5, 10000.0, 0, true )
	CameraShake(1.5,30)
	local particle_cast = "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"
	local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"

	local effect_fire = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(effect_fire, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(effect_fire, 1, Vector(self.radius,self.radius,self.radius))
	ParticleManager:SetParticleShouldCheckFoW(effect_fire, false)
	ParticleManager:ReleaseParticleIndex(effect_fire)
	
	
	local pfx_name = "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/hit_effect/effect.vpcf"
	local pfx = ParticleManager:CreateParticle(pfx_name, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pfx, 0,self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 1,Vector(self.radius,self.radius,self.radius))
	ParticleManager:SetParticleControl(pfx, 3,self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleShouldCheckFoW(pfx, false)
	ParticleManager:ReleaseParticleIndex(pfx)

    local pfx_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(pfx_aoe, 0, self:GetParent():GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx_aoe, 1, Vector(2*self.radius,2*self.radius,2*self.radius))
	ParticleManager:SetParticleShouldCheckFoW(pfx_aoe, false)
	ParticleManager:ReleaseParticleIndex(pfx_aoe)


	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )

end



