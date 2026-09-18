-- 重做完成
item_hd_darkcube_effects = class({})
LinkLuaModifier("modifier_item_hd_darkcube_effects", "player_artifact/item_hd_darkcube_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_darkcube_effects_attack", "player_artifact/item_hd_darkcube_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_darkcube_effects_ice_knife_debuff", "player_artifact/item_hd_darkcube_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_darkcube_effects_ice_storm_debuff", "player_artifact/item_hd_darkcube_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_darkcube_effects_fire_strike", "player_artifact/item_hd_darkcube_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_darkcube_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_darkcube_effects"
end
function item_hd_darkcube_effects:Precache( context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/creeps_spell_flame_of_the_splitter/hit_effect/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_lightning_bolt/hit_effect/effect.vpcf", context )

    PrecacheResource( "particle", "particles/rebuid/chaotic_spell/chaotic_ice_storm/cast_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_hit.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_lina/lina_spell_light_strike_array_ray_team.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_hit/effect.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_ring/effect.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_chain_lightning/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", context )
end

modifier_item_hd_darkcube_effects = advanced_modifier({})

function modifier_item_hd_darkcube_effects:IsDebuff()			return false end
function modifier_item_hd_darkcube_effects:IsHidden() 			return true end
function modifier_item_hd_darkcube_effects:IsPurgable() 		    return false end
function modifier_item_hd_darkcube_effects:IsPurgeException() return false end
function modifier_item_hd_darkcube_effects:RemoveOnDeath() return false end
function modifier_item_hd_darkcube_effects:AllowIllusionDuplicate() return false end


function modifier_item_hd_darkcube_effects:OnCreated( kv )
	if not self:GetParent():IsRealHero() then
		return
	end
	self.parent = self:GetParent()
    self.ability = self:GetAbility()
    self.bonus_cast_range = self.ability:GetArtifactSpecialValueFor("bonus_cast_range")

	self.cast_range_2 = self.ability:GetArtifactSpecialValueFor("cast_range_2")
	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_darkcube_effects")

	if self.level >= 20 then
		self.bonus_cast_range = self.bonus_cast_range + self.cast_range_2
	end
    -- 环绕位置和半径
	self.zero = Vector(0,0,0)
	self.revolution = 2.5
	self.rotate_radius = 180

	if not IsServer() then return end

	self.interval = 0.03
	self.base_facing = Vector(0,1,0)
	self.relative_pos = Vector( -self.rotate_radius, 0, 100 )
	self.rotate_delta = 360/self.revolution * self.interval

	self.position = self.parent:GetOrigin() + self.relative_pos
	self.rotation = 0
	self.facing = self.base_facing

	-- 召唤魔方
	self.wisp = CreateUnitByName(
		"npc_dota_darkcube",
		self.position,
		true,
		self.parent,
		self.parent:GetOwner(),
		self.parent:GetTeamNumber()
	)
	self.wisp:SetForwardVector( self.facing )

	-- 魔方原理
	self.modifier = self.wisp:AddNewModifier(
		self:GetCaster(),
		self:GetAbility(),
		"modifier_item_hd_darkcube_effects_attack",
		{level = self.level}
	)

	self:StartIntervalThink( self.interval )
end

function modifier_item_hd_darkcube_effects:OnRefresh()
	self.bonus_cast_range = self.ability:GetArtifactSpecialValueFor("bonus_cast_range")

	self.cast_range_2 = self.ability:GetArtifactSpecialValueFor("cast_range_2")
	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_darkcube_effects")

	if self.level >= 20 then
		self.bonus_cast_range = self.bonus_cast_range + self.cast_range_2
	end
end

function modifier_item_hd_darkcube_effects:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self.wisp )
end

function modifier_item_hd_darkcube_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
    }
end

function modifier_item_hd_darkcube_effects:Advanced_GetModifierCastRangeBonusStacking()
    return self.bonus_cast_range
end

function modifier_item_hd_darkcube_effects:OnIntervalThink()
    -- 用于纠正位置的think
	self.rotation = self.rotation + self.rotate_delta
	local origin = self.parent:GetOrigin()
	self.position = RotatePosition( origin, QAngle( 0, -self.rotation, 0 ), origin + self.relative_pos )
	self.facing = RotatePosition( self.zero, QAngle( 0, -self.rotation, 0 ), self.base_facing )

	self.wisp:SetOrigin( self.position )
	self.wisp:SetForwardVector( self.facing )
end

------------------------------------------------------------------------------------
modifier_item_hd_darkcube_effects_attack = advanced_modifier({})


function modifier_item_hd_darkcube_effects_attack:IsHidden()	return true end
function modifier_item_hd_darkcube_effects_attack:IsDebuff()	return false end
function modifier_item_hd_darkcube_effects_attack:IsStunDebuff()	return false end
function modifier_item_hd_darkcube_effects_attack:IsPurgable()	return false end

function modifier_item_hd_darkcube_effects_attack:OnCreated()
    self.ability = self:GetAbility()
	self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.interval = self.ability:GetArtifactSpecialValueFor("interval")
	self.cast_range_2 = self.ability:GetArtifactSpecialValueFor("cast_range_2")
	self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
	self.interval_1 = self.ability:GetArtifactSpecialValueFor("interval_1")
	self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")

	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_darkcube_effects")

	if self.level >= 10 then
		self.interval = self.interval_1
		if self.level >= 30 then
			self.interval = self.interval_3
		end
		if self.level >= 40 then

		end
	end

    self:SetStackCount(0)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end

function modifier_item_hd_darkcube_effects_attack:OnRefresh()
    self.ability = self:GetAbility()
	self.ability = self:GetAbility()
	self.radius = self.ability:GetArtifactSpecialValueFor("radius")
	self.interval = self.ability:GetArtifactSpecialValueFor("interval")
	self.cast_range_2 = self.ability:GetArtifactSpecialValueFor("cast_range_2")
	self.chance_2 = self.ability:GetArtifactSpecialValueFor("chance_2")
	self.interval_1 = self.ability:GetArtifactSpecialValueFor("interval_1")
	self.interval_3 = self.ability:GetArtifactSpecialValueFor("interval_3")

	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_darkcube_effects")

	if self.level >= 10 then
		self.interval = self.interval_1
		if self.level >= 20 then
			self.radius = self.radius + self.cast_range_2
		end
		if self.level >= 30 then
			self.interval = self.interval_3
		end
		if self.level >= 40 then

		end
	end
end


function modifier_item_hd_darkcube_effects_attack:OnIntervalThink()
	if not self:GetCaster():IsAlive() then
		return
	end

    local interval = self.interval
    self:SetStackCount(self:GetStackCount()+1)

    if self:GetStackCount() >= interval then
		local random = math.random
		if self.level >= 20 then
			local element_heart = self:GetCaster():FindModifierByName("modifier_item_hd_element_heart_effects")
			if element_heart then
				if self.chance_2 >= random(1,100) then
					self:GetCaster():AddNewModifier(self:GetCaster(), element_heart:GetAbility(), "modifier_item_hd_element_heart_effects_active", {stack = element_heart.outgoing, duration = element_heart.duration})
				end
			end
		end
        self:SetStackCount(0)
        local type = random(1,3)

        if self.level >= 40 and self:GetCaster():GetLevel() >= 30 then
            type = random(4,6)
        end

        if type == 1 then
            self:Iceknife()
        end
        if type == 2 then
            self:Firerazor()
        end
        if type == 3 then
            self:Lightningline()
        end
        if type == 4 then
            self:Icestorm()
        end
        if type == 5 then
            self:Firestrike()
        end
        if type == 6 then
            self:Chainlightning()
        end
    end
end

function modifier_item_hd_darkcube_effects_attack:Iceknife()
    -- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = self.radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end

	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)
    -- 声音特效
	caster:EmitSound("chaotic_ice_knife_cast")  
    -- 冰刃术弹道无法实现，因此通过距离和弹道速度拟似实现
    local time = CalculateDistance(target,self:GetParent())/3000
    parent:GameTimer(time,function ()
        if not target then
		    return
	    end

	    local caster = self:GetCaster()
	    target:EmitSound("chaotic_ice_knife_hit")
	    local gain = self:GetAbility():GetEffectGain()

	    local damageTable = {
		    attacker	= caster,
		    victim = target,
		    damage		= (400 + 4*caster:HDGetPrimaryStatValue())*gain*lvl_index,
		    damage_type	= DAMAGE_TYPE_MAGICAL,
		    ability		= self:GetAbility(),
            hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
	    }
		if self.level >= 30 then
			damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE 
		end
	    ApplyDamage(damageTable)

	    local duration = 3*caster:GetModifierStatusNegativeGainIndex(1)
	    damageTable.damage = (200 + 3*caster:HDGetPrimaryStatValue())*gain

	    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	    for _, unit in ipairs(enemies) do
		    damageTable.victim = unit
		    ApplyDamage(damageTable)
		    if IsValid(unit) and unit:IsAlive() then
                local caster = self:GetCaster()
	            local StatusResistance = target:GetHDStatusResistanceIndex()
	            target:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_darkcube_effects_ice_knife_debuff", {duration = duration*StatusResistance})
		    end
	    end      
    end)

	local info = 
	{
		Target = target,
		Source = self:GetParent(),
		Ability = self:GetAbility(),	
		EffectName = "particles/rebuild/chaotic_spell/chaotic_ice_knife/effect_projecile/effect.vpcf",
		iMoveSpeed = 3000,
		vSourceLoc = self:GetParent():GetAbsOrigin(),
		bDrawsOnMinimap = false,  --？？
		bDodgeable = true,   --可躲闪
		bIsAttack = false,   --攻击效果
		bVisibleToEnemies = true,  --对敌人可视
		bReplaceExisting = false, --替换现有的
		flExpireTime = GameRules:GetGameTime() + 10, --存在时间
		bProvidesVision = false, --提供视野
		ExtraData = {}   --额外的数据
	}
	ProjectileManager:CreateTrackingProjectile(info)
    local time = CalculateDistance(target,self:GetParent())
end


function modifier_item_hd_darkcube_effects_attack:Firerazor()
	-- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = self.radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end
	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)

	caster:EmitSound("chaotic_scorching_ray_cast")  
    -- 灼热射线本体
	local count = 4
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	
    EmitSoundOn("chaotic_ray_of_sickness_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)

	local damage = 200 + 2*self:GetCaster():HDGetPrimaryStatValue()
	local burning = 2*self:GetCaster():HDGetPrimaryStatValue()
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage*self:GetAbility():GetEffectGain()*lvl_index,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	if self.level >= 30 then
		damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE
	end
	ApplyDamage(damageTable)
	if target:IsAlive() then
		target:Burning(self:GetCaster(), self:GetAbility(), burning)
	end

	caster:GameTimer(0.1, function()
		if IsValid(self) then
			local target = enemies[RandomInt(1, #enemies)]
			if not (IsValid(target)  and target:IsAlive() )  then
				for index, unit in ipairs(enemies) do
					if IsValid(unit) and  unit:IsAlive() then
						target = unit
						break
					end
				end
			end
			if IsValid(target) and target:IsAlive() then
				count = count - 1

                EmitSoundOn("chaotic_ray_of_sickness_target", target) 
                local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
                ParticleManager:SetParticleControlEnt(head_particle, 0, parent, PATTACH_POINT_FOLLOW, "attach_attack1", parent:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(head_particle)

                local damage = 200 + 2*self:GetCaster():HDGetPrimaryStatValue()
				local burning = 2*self:GetCaster():HDGetPrimaryStatValue()
                local damageTable = {
                    victim = target,
                    attacker = self:GetCaster(),
                    damage = damage*self:GetAbility():GetEffectGain(),
                    damage_type = DAMAGE_TYPE_MAGICAL,
                    ability = self:GetAbility(), --Optional.
                    hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
                }
				if self.level >= 30 then
					damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE
				end
                target:ApplyMergeDamage(damageTable)
				if target:IsAlive() then
					target:Burning(self:GetCaster(), self:GetAbility(), burning)
				end
				
				if count>=1 then
					return 0.1
				end
			end

		end
	end)
end


function modifier_item_hd_darkcube_effects_attack:Lightningline()
    -- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = self.radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end
	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)

	local pos = target:GetAbsOrigin()
	local caster_loc = parent:GetAbsOrigin()
	if pos==caster_loc then
		pos = pos +parent:GetForwardVector()
	end
	local direction 	= (pos - caster_loc):Normalized()
	direction.z = 0
	local distance = 2500

	local target_pos = caster_loc + direction* distance
	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/lightning_bolt/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, parent )
	ParticleManager:SetParticleControlEnt( pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
	ParticleManager:SetParticleShouldCheckFoW(pfx,false)
	ParticleManager:SetParticleControl( pfx, 2, target_pos + Vector(0,0,64)  )
	ParticleManager:SetParticleControlForward(pfx, 0, direction)  --方向
	ParticleManager:ReleaseParticleIndex(pfx)
	caster:EmitSound("chaotic_lightning_bolt_cast")

	local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_loc, target_pos,nil, 300,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

	local damageTable = {
		attacker	= self:GetCaster(),
		-- victim = target,
		damage		= (700 + caster:HDGetPrimaryStatValue()*5)*self:GetAbility():GetEffectGain()*lvl_index,
		damage_type	= DAMAGE_TYPE_MAGICAL,
		ability		= self:GetAbility(),
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	if self.level >= 30 then
		damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE 
	end

	local line_dir = target_pos - caster_loc --线的向量

	for i, unit in pairs(tTargets) do

		local unit_pos = unit:GetAbsOrigin()
		-- 计算从 caster_loc 到 unit_pos 的向量
		local caster_to_unit = unit_pos - caster_loc
		-- 计算投影长度
		local dot_product = caster_to_unit.x * line_dir.x + caster_to_unit.y * line_dir.y + caster_to_unit.z * line_dir.z
		local projection_length = dot_product / (line_dir.x^2 + line_dir.y^2 + line_dir.z^2)
		local intersection_point = Vector(caster_loc.x + projection_length * line_dir.x,caster_loc.y + projection_length * line_dir.y,caster_loc.z + 128)
		for i = 1, 2, 1 do
			local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_lightning_bolt/hit_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( pfx, 0, intersection_point+ RandomVector(25)  )
			ParticleManager:SetParticleControl( pfx, 1, unit_pos + RandomVector(50)  )
			ParticleManager:ReleaseParticleIndex(pfx)
		end

		unit:EmitSound("Hero_Zuus.StaticField")
		damageTable.victim = unit
		ApplyDamage(damageTable)
	end
end


function modifier_item_hd_darkcube_effects_attack:Icestorm()
    -- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = self.radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end
	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)


	caster:EmitSound("chaotic_ice_storm_cast")  
	local caster_pos = parent:GetAbsOrigin()
	local target_pos = target:GetAbsOrigin()
    local delay = 0.1

	EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_cast", caster)
	local dir = CalculateDirection(target_pos,caster_pos)
	if caster_pos==target_pos then
		dir = caster:GetForwardVector()
	end

	local effect_gain= self:GetAbility():GetEffectGain()
	local radius = 500
	local count = 8

	parent:GameTimer(delay, function()
		if not IsValid(self) then
			return
		end
		local speed = 3000

		for i = 1, 6, 1 do
			local end_pos = target_pos + Vector(RandomInt(-radius, radius),RandomInt(-radius, radius),0)
			end_pos = GetGroundPosition( end_pos, nil )
			local spawn_pos = end_pos - dir *350 + Vector(0,0,1500 + RandomInt(-300, 1200)) 
	
			local effect_cast = ParticleManager:CreateParticle( "particles/rebuid/chaotic_spell/chaotic_ice_storm/cast_effect/effect.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( effect_cast, 0, spawn_pos )
			ParticleManager:SetParticleControl( effect_cast, 1, end_pos )
			ParticleManager:SetParticleControl( effect_cast, 2, Vector(speed,0,0) )
			local delay = CalculateDistance3D(spawn_pos, end_pos)/speed+0.03
			ParticleManager:SetParticleControl( effect_cast, 4, Vector(delay,0,0) )
			ParticleManager:ReleaseParticleIndex(effect_cast)
			speed = speed +500
		end
		count = count - 1
		EmitSoundOnLocationWithCaster(target_pos, "chaotic_ice_storm_target", caster)
		if count<=0 then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target_pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

			local damageTable = {
				attacker	= self:GetCaster(),
				-- victim = target,
				damage		= (800 + caster:HDGetPrimaryStatValue()*10)*effect_gain*lvl_index,
				damage_type	= DAMAGE_TYPE_MAGICAL,
				ability		= self:GetAbility(),
                hd_flags = HD_DAMAGE_FLAG_ICE_DAMAGE,
			}
			if self.level >= 30 then
				damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE 
			end

			local duration = 4*  caster:GetModifierStatusNegativeGainIndex(1)
		
			for _, unit in ipairs(enemies) do
				local effect_cast1 = ParticleManager:CreateParticle( "particles/econ/items/timbersaw/timbersaw_ti9/timbersaw_ti9_chakram_hit.vpcf", PATTACH_CUSTOMORIGIN, target )
	            ParticleManager:SetParticleControlEnt( effect_cast1, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
				damageTable.victim = unit
				ApplyDamage(damageTable)
				if IsValid(unit) and unit:IsAlive() then
					local StatusResistance = target:GetHDStatusResistanceIndex()
	                target:AddNewModifier(caster, self:GetAbility(), "modifier_item_hd_darkcube_effects_ice_storm_debuff", {duration = duration*StatusResistance})
				end
			end
			return nil
		end

		return 0.03
	end)
end


function modifier_item_hd_darkcube_effects_attack:Firestrike()
    -- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()

    local radius = self.radius
    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end

	local point = target:GetAbsOrigin()
	local duration = 0.1

	CreateModifierThinker(
		caster, -- player source
		self:GetAbility(), -- ability source
		"modifier_item_hd_darkcube_effects_fire_strike", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end


function modifier_item_hd_darkcube_effects_attack:Chainlightning()
    -- 判定范围，找到最近的敌人
    local target
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local radius = self.radius

    local enemies = FindUnitsInRadius(caster:GetTeamNumber(), parent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
    for _ , enemy in pairs(enemies) do
        target = enemy
        break
    end
    if not target then return end
	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)


	caster:EmitSound("chaotic_lightning_bolt_cast")

	local damageTable = {
		attacker	= self:GetCaster(),
		victim = target,
		damage		= (2400 + caster:HDGetPrimaryStatValue()*23)*lvl_index,
		damage_type	= DAMAGE_TYPE_MAGICAL,
		ability		= self:GetAbility(),
		hd_flags = HD_DAMAGE_FLAG_LIGHTING_DAMAGE,
	}
	if self.level >= 30 then
		damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE 
	end

	local pfx = ParticleManager:CreateParticle( "particles/rebuild/chaotic_spell/chaotic_chain_lightning/cast_effect/thundergods_wrath_start_bolt_parent.vpcf", PATTACH_CUSTOMORIGIN, parent )
	ParticleManager:SetParticleControlEnt( pfx, 1, parent, PATTACH_POINT_FOLLOW, "attach_attack1" ,Vector(0,0,0), true )
	ParticleManager:SetParticleControlEnt( pfx, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc" ,Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex(pfx)

	local gain = self:GetAbility():GetEffectGain()
	damageTable.damage = damageTable.damage * gain
	local pos = target:GetAbsOrigin()
	ApplyDamage(damageTable)
	if not target:IsAlive() then
		damageTable.damage = damageTable.damage * 2.25
	end

	local count = 8
	caster:GameTimer(0.1, function()
		if IsValid(self) then
			local enemies = FindUnitsInRadius(caster:GetTeamNumber(), pos, nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _, unit in ipairs(enemies) do
				if unit~=target and IsValid(unit) and unit:IsAlive() then
					count = count - 1
					damageTable.victim = unit
					self:PlayEffectlightning(target,unit)
					ApplyDamage(damageTable)
					if count<=0 then
						break
					end
				end
			end
		end
	end)
end

function modifier_item_hd_darkcube_effects_attack:PlayEffectlightning(source,target)
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/spell/dragons_lightning/dragons_lightning_lightning_head.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(head_particle, 1, source, PATTACH_POINT_FOLLOW, "attach_attack1", Vector(0,0,0), true)
	ParticleManager:SetParticleControlEnt(head_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(head_particle, 61, Vector(1, 5, 0))
	ParticleManager:ReleaseParticleIndex(head_particle)
	target:EmitSound("chaotic_chain_lightning_target")
end


function modifier_item_hd_darkcube_effects_attack:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end


function modifier_item_hd_darkcube_effects_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end

function modifier_item_hd_darkcube_effects_attack:GetOverrideAnimation(params)
	if self:GetStackCount()==0 then
		return ACT_DOTA_IDLE
	end
	return ACT_DOTA_CAST_ABILITY_5
end






-- 冰刃术debuff
modifier_item_hd_darkcube_effects_ice_knife_debuff = advanced_modifier({})

function modifier_item_hd_darkcube_effects_ice_knife_debuff:IsHidden() 			return true end
function modifier_item_hd_darkcube_effects_ice_knife_debuff:IsPurgable() 			return false end
function modifier_item_hd_darkcube_effects_ice_knife_debuff:IsPurgeException() 	return false end
function modifier_item_hd_darkcube_effects_ice_knife_debuff:IsDebuff() return true end


function modifier_item_hd_darkcube_effects_ice_knife_debuff:OnCreated(keys)
	self.move_speed_reduction = -50*self:GetAbility():GetEffectGain()
end


function modifier_item_hd_darkcube_effects_ice_knife_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
	}
end
function modifier_item_hd_darkcube_effects_ice_knife_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end


-- 冰风暴debuff
modifier_item_hd_darkcube_effects_ice_storm_debuff = advanced_modifier({})

function modifier_item_hd_darkcube_effects_ice_storm_debuff:IsHidden() 			return true end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:IsPurgable() 			return false end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:IsPurgeException() 	return false end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:IsDebuff() return true end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:OnCreated(keys)
	self.move_speed_reduction = -100
	self.attack_slow = -20
	if IsServer() then
		
	end
end

function modifier_item_hd_darkcube_effects_ice_storm_debuff:DeclareFunctions()
    return 
    {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,         --移动速度
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:GetModifierMoveSpeedBonus_Constant() return   self.move_speed_reduction end
function modifier_item_hd_darkcube_effects_ice_storm_debuff:GetModifierAttackSpeedBonus_Constant() return   self.attack_slow end

-- 焰击术
modifier_item_hd_darkcube_effects_fire_strike = class({})

function modifier_item_hd_darkcube_effects_fire_strike:IsHidden()	return true end
function modifier_item_hd_darkcube_effects_fire_strike:IsPurgable()	return false end

function modifier_item_hd_darkcube_effects_fire_strike:OnCreated( kv )
	if not IsServer() then return end
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local lvl_index = math.min(math.max(1+((caster:GetLevel()-25)/25), 0.2), 1.3)

	local bonusIndex = 3*math.floor(self:GetCaster():GetMana()/1000)
	bonusIndex= math.min(bonusIndex,30)
	self.damage = (1200 +  (6+bonusIndex)*self:GetCaster():HDGetPrimaryStatValue())*2*lvl_index
	self.radius = 400
end


function modifier_item_hd_darkcube_effects_fire_strike:OnDestroy()
	if not IsServer() then return end
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
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability, --Optional.
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE,
	}
	self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_darkcube_effects")
	if self.level >= 30 then
		damageTable.hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE + HD_DAMAGE_FLAG_FIRE_DAMAGE + HD_DAMAGE_FLAG_ICE_DAMAGE + HD_DAMAGE_FLAG_LIGHTING_DAMAGE + HD_DAMAGE_FLAG_HOLY_DAMAGE 
	end

	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES ,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	for _,enemy in pairs(enemies) do
		-- 弱驱散
		enemy:Purge(true, false, false, false, false)
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
	end

	self:PlayEffects2()
	UTIL_Remove( self:GetParent() )
end


function modifier_item_hd_darkcube_effects_fire_strike:PlayEffects2()
	-- Get Resources
	local particle_cast = "particles/rebuild/chaotic_spell/chaotic_flame_strike/effect_hit/effect.vpcf"
	local sound_cast = "Ability.LightStrikeArray"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_cast, self:GetCaster() )
end