item_hd_dingzhi_shitking_effects = class({})
LinkLuaModifier( "modifier_item_hd_dingzhi_shitking_effects", "player_artifact/item_hd_dingzhi_shitking_effects", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_dingzhi_shitking_effects_phantom", "player_artifact/item_hd_dingzhi_shitking_effects", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_dingzhi_shitking_effects_phantom_metor", "player_artifact/item_hd_dingzhi_shitking_effects", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_hd_dingzhi_shitking_effects_cd", "player_artifact/item_hd_dingzhi_shitking_effects", LUA_MODIFIER_MOTION_NONE )
function item_hd_dingzhi_shitking_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_dingzhi_shitking_effects"
end

function item_hd_dingzhi_shitking_effects:Precache( context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", context )
	PrecacheResource( "particle", "particles/econ/items/wraith_king/wraith_king_arcana/wk_arc_weapon_blur_attack2_reverse.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf", context )
	PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_meteor_swarm/hit_effect/effect.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", context )
end

function item_hd_dingzhi_shitking_effects:GetArtifactSpecialList()
    local list = {}
    list["76561198340659423"] = true
    return list
end
function item_hd_dingzhi_shitking_effects:GetArtifactSpecialListLevelRequireReduction__Pct()
    return 10
end
function item_hd_dingzhi_shitking_effects:GetArtifactSpecialListLevelRequireReduction__Con()
    return 3
end

modifier_item_hd_dingzhi_shitking_effects = advanced_modifier({})

function modifier_item_hd_dingzhi_shitking_effects:IsHidden()	return true end
function modifier_item_hd_dingzhi_shitking_effects:IsDebuff()	return false end
function modifier_item_hd_dingzhi_shitking_effects:IsPurgable()	return false end
function modifier_item_hd_dingzhi_shitking_effects:IsPurgeException() return false end
function modifier_item_hd_dingzhi_shitking_effects:RemoveOnDeath() return false end
function modifier_item_hd_dingzhi_shitking_effects:GetTexture() return "item_artifact_76" end

function modifier_item_hd_dingzhi_shitking_effects:OnCreated(keys)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.armor = self.ability:GetArtifactSpecialValueFor("armor")

    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.attack_need = self.ability:GetArtifactSpecialValueFor("attack_need")
    self.attack_damage = self.ability:GetArtifactSpecialValueFor("attack_damage")
    self.armor_1 = self.ability:GetArtifactSpecialValueFor("armor_1")
    self.status_1 = self.ability:GetArtifactSpecialValueFor("status_1")
    self.count_2 = self.ability:GetArtifactSpecialValueFor("count_2")
    self.burning_2 = self.ability:GetArtifactSpecialValueFor("burning_2")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.metor_need = self.ability:GetArtifactSpecialValueFor("metor_need")
    self.damage_7 = self.ability:GetArtifactSpecialValueFor("damage_7")
    self.bonus_10 = self.ability:GetArtifactSpecialValueFor("bonus_10")*0.01
    self.bonus_max_10 = self.ability:GetArtifactSpecialValueFor("bonus_max_10")*0.01

    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_dingzhi_shitking_effects")

    if IsServer() then
        local level = 12
        local casterID = tostring(PlayerResource:GetSteamID(self.caster:GetPlayerOwnerID()))
        if casterID == "76561198340659423" then
            level = 8 
        end
        if self.caster:GetLevel() < level then
            return
        end
		local pos = self.caster:GetOrigin() 
		self.unit  = CreateUnitByName("npc_hd_doom_dummy", pos, true, self.caster, self.caster, self.caster:GetTeamNumber())
		self.unit:SetOrigin(pos)
		self.unit:SetForwardVector(self.caster:GetForwardVector())
		self.unit:SetParent(self.caster,nil)
		self.unit:AddNewModifier(self.caster, self.ability, "modifier_item_hd_dingzhi_shitking_effects_phantom", {})
	end
end

function modifier_item_hd_dingzhi_shitking_effects:OnRefresh(keys)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

    self.armor = self.ability:GetArtifactSpecialValueFor("armor")

    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.attack_need = self.ability:GetArtifactSpecialValueFor("attack_need")
    self.attack_damage = self.ability:GetArtifactSpecialValueFor("attack_damage")
    self.armor_1 = self.ability:GetArtifactSpecialValueFor("armor_1")
    self.status_1 = self.ability:GetArtifactSpecialValueFor("status_1")
    self.count_2 = self.ability:GetArtifactSpecialValueFor("count_2")
    self.burning_2 = self.ability:GetArtifactSpecialValueFor("burning_2")
    self.incoming_4 = self.ability:GetArtifactSpecialValueFor("incoming_4")
    self.metor_need = self.ability:GetArtifactSpecialValueFor("metor_need")
    self.damage_7 = self.ability:GetArtifactSpecialValueFor("damage_7")
    self.bonus_10 = self.ability:GetArtifactSpecialValueFor("bonus_10")*0.01
    self.bonus_max_10 = self.ability:GetArtifactSpecialValueFor("bonus_max_10")*0.01

    self.level = GetArtifactLevel(self:GetCaster():GetPlayerOwnerID(),"item_hd_dingzhi_shitking_effects")

    if IsServer() then
        local level = 12
        local casterID = tostring(PlayerResource:GetSteamID(self.caster:GetPlayerOwnerID()))
        if casterID == "76561198340659423" then
            level = 8 
        end
        if self.caster:GetLevel() < level then
            return
        end
        if not self.unit then
            local pos = self.caster:GetOrigin()
            self.unit  = CreateUnitByName("npc_hd_doom_dummy", pos, true, self.caster, self.caster, self.caster:GetTeamNumber())
            self.unit:SetOrigin(pos)
            self.unit:SetForwardVector(self.caster:GetForwardVector())
            self.unit:SetParent(self.caster,nil)
            self.unit:AddNewModifier(self.caster, self.ability, "modifier_item_hd_dingzhi_shitking_effects_phantom", {})
        end
	end
end

function modifier_item_hd_dingzhi_shitking_effects:OnDestroy()
    if IsServer() then
        if self.unit then
            self.unit:RemoveSelf()
        end
    end
end

function modifier_item_hd_dingzhi_shitking_effects:ADDeclareFunctions()
	local funcs = {
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED ={self:GetParent(), nil},
        advanced_MODIFIER_PROPERTY_StatusResistance,
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
	return funcs
end

function modifier_item_hd_dingzhi_shitking_effects:GetPhantom()
	return self.unit
end

function modifier_item_hd_dingzhi_shitking_effects:Advanced_GetModifierPhysicalArmorBonusPercentage(keys)
    if self.level >= 10 and self.caster:GetLevel() >= 16 then
        return self.armor + self.armor_1
    end
	return self.armor
end

function modifier_item_hd_dingzhi_shitking_effects:Advanced_GetModifier_StatusResistance(keys)
    if self.level >= 10 and self.caster:GetLevel() >= 16 then
        return self.status_1
    end
	return 0
end

function modifier_item_hd_dingzhi_shitking_effects:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if self.level >= 40 and not self.caster:IsMoving() then
        return -self.incoming_4
    end
	return 0
end

function modifier_item_hd_dingzhi_shitking_effects:OnAttackLanded(keys)
    if not IsServer() then return end
    local attacker = keys.attacker
    if attacker ~= self:GetParent() then return end
    if not self.unit then return end
    local modifier = self.unit:FindModifierByName("modifier_item_hd_dingzhi_shitking_effects_phantom")
    if not modifier then return end
    if attacker:IsInSpecialAttack() then return end

    self.attack_count = self.attack_count or 0
    self.attack_count = self.attack_count + 1
    if attacker:HasModifier("modifier_item_hd_dingzhi_shitking_effects_cd") then return end
    attacker:AddNewModifier(attacker, self.ability, "modifier_item_hd_dingzhi_shitking_effects_cd", {duration = 0.75})
   

    if self.attack_count >= self.attack_need then
        self.attack_count = self.attack_count - self.attack_need
         self.doom_attack_count = self.doom_attack_count or 0
        self.doom_attack_count = self.doom_attack_count + 1

        local attack_keys = {
            total_damage = self.attack_damage * attacker:GetAverageTrueAttackDamage(nil),
        }
        
        if self.level >= 20 and attacker:GetLevel() >= 20 then
            attack_keys.count_2 = self.count_2
            attack_keys.burning_2 = self.burning_2 * attacker:GetAverageTrueAttackDamage(nil)
        end

        if self.level >= 30 and attacker:GetLevel() >= 24 then
            attack_keys.endburning = true
        end

        if self.level >= 70 and attacker:GetLevel() >= 30 then
            if self.doom_attack_count >= self.metor_need then
                self.doom_attack_count = self.doom_attack_count - self.metor_need
                attack_keys.metor_damage = self.damage_7 * attacker:GetAverageTrueAttackDamage(nil)
            end
        end

        if self.level >= 100 then
            local armor_to_dmg = math.min(attacker:GetPhysicalArmorValue(false)*self.bonus_10, self.bonus_max_10)
            attack_keys.total_damage = attack_keys.total_damage*(1+armor_to_dmg)
            if attack_keys.burning_2 then
                attack_keys.burning_2 = attack_keys.burning_2*(1+armor_to_dmg)
            end
            if attack_keys.metor_damage then
                attack_keys.metor_damage = attack_keys.metor_damage*(1+armor_to_dmg)
            end
        end
        modifier:Base_attack(attack_keys)
    end
end
---
modifier_item_hd_dingzhi_shitking_effects_cd = modifier_item_hd_dingzhi_shitking_effects_cd or class({})
function modifier_item_hd_dingzhi_shitking_effects_cd:IsHidden()	return true end
function modifier_item_hd_dingzhi_shitking_effects_cd:IsPurgable()	return false end
function modifier_item_hd_dingzhi_shitking_effects_cd:IsPurgeException()	return false end
---
modifier_item_hd_dingzhi_shitking_effects_phantom = modifier_item_hd_dingzhi_shitking_effects_phantom or class({})
function modifier_item_hd_dingzhi_shitking_effects_phantom:IsHidden()	return true end
function modifier_item_hd_dingzhi_shitking_effects_phantom:IsDebuff()	return false end
function modifier_item_hd_dingzhi_shitking_effects_phantom:IsPurgable()	return false end
function modifier_item_hd_dingzhi_shitking_effects_phantom:IsPurgeException()	return false end
function modifier_item_hd_dingzhi_shitking_effects_phantom:GetStatusEffectName() return "particles/rebuild/spell/reincarnation/unlock3/status_effect_sk.vpcf" end
function modifier_item_hd_dingzhi_shitking_effects_phantom:OnCreated(keys)
    self.caster = self:GetCaster()
    self.parent = self:GetParent()
    self.ability = self:GetAbility()

	if IsServer() then
		self:GetParent():SetHullRadius(0)
		self.nFXIndex = ParticleManager:CreateParticle( "particles/rebuild/spell/reincarnation/unlock3_ambient/effect_style_ambient.vpcf", PATTACH_POINT_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_l_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_eye_r_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_core_fx", self:GetParent():GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 5, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_head_fx", self:GetParent():GetAbsOrigin(), true )
		self.type = 0

		self:AddParticle( self.nFXIndex, false, false, -1, true, false )
        self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
		self:StartIntervalThink(1)
	end
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:OnIntervalThink()
	self:GetParent():SetHealth(self:GetParent():GetMaxHealth())
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:OnDestroy()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/econ/events/nexon_hero_compendium_2014/blink_dagger_start_nexon_hero_cp_2014.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex( pfx )
		UTIL_Remove(self:GetParent())
	end
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:Base_attack(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    local pos = caster:GetOrigin()

    parent:StartGestureWithPlaybackRate(ACT_DOTA_ATTACK,1.7)
	parent:EmitSound("Hero_SkeletonKing.PreAttack")

    local units = FindUnitsInLine(
    caster:GetTeamNumber(), 
    pos, pos+caster:GetForwardVector()*700,
    nil, 
    350,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE
    )
    
    caster:GameTimer(0.35, function ()
        if #units>0 and IsValid(ability) then
            local damageTable = {
                attacker = caster,
                damage = keys.total_damage/#units,
                damage_type = DAMAGE_TYPE_PHYSICAL,
                damage_flags = DOTA_DAMAGE_FLAG_NONE,
                ability = ability,
            }
            for _, unit in ipairs(units) do
                damageTable.victim = unit
                ApplyDamage(damageTable)

                if unit:IsAlive() and keys.endburning == true then
                    unit:ActiveBurning(caster, ability, 1, 0)
                    local burning = unit:FindModifierByName("modifier_hd_burning")
                    if burning then
                        burning:Destroy()
                    end
                end
            end

            for i, unit in pairs(units) do
                if keys.count_2 then
                    self:BurningRay(unit, keys.burning_2)
                    if i >= keys.count_2 then break end
                end
            end
        end

        if keys.metor_damage then
            parent:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3,1.7)
            CreateModifierThinker(
                caster, -- player source
                ability, -- ability source
                "modifier_item_hd_dingzhi_shitking_effects_phantom_metor", -- modifier name
                {index = 1, damage = keys.metor_damage}, -- kv
                pos + caster:GetForwardVector()*350,
                caster:GetTeamNumber(),
                false
            )
        end
        parent:EmitSound("Hero_SkeletonKing.Attack")
    end)
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:BurningRay(target, burning)
    if not target or not target:IsAlive() then return end
	EmitSoundOn("chaotic_ray_of_sickness_target", target) 
	local head_particle = ParticleManager:CreateParticle("particles/rebuild/chaotic_spell/chaotic_scorching_ray/effect_cast/ffect.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:SetParticleControlEnt(head_particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_attack1", self.parent:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(head_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(head_particle)

    if not burning or burning<=0 then return end
	target:Burning(self.caster, self.ability, burning)
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL
	}
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:GetVisualZDelta( params )
	return -150
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:GetOverrideAnimation(params)
	return ACT_DOTA_CAPTURE
end

function modifier_item_hd_dingzhi_shitking_effects_phantom:GetModifierInvisibilityLevel()return 1 end



----------------------------------------------------------------------------------------------------------------
modifier_item_hd_dingzhi_shitking_effects_phantom_metor = class({})

function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:IsHidden()	return true end
function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:OnCreated( kv )
	if IsServer() then

		local ability = self:GetAbility()
		self.caster_origin = self:GetCaster():GetOrigin()
		self.parent_origin = self:GetParent():GetOrigin()
		self.direction = self.parent_origin - self.caster_origin
		self.direction.z = 0
		self.direction = self.direction:Normalized()

		-- 落地时间
		self.delay = 1.3
		self.radius = 500
		self.interval = 0.3
        self.damage = kv.damage
        self.index = kv.index
		-- variables
		self.fallen = false
		self.effect_unit = {}
		self.effect_unit2 = {}
		self:StartIntervalThink( self.delay )

		self:PlayEffects1()
	end
end

function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:OnDestroy( kv )
    if IsServer() then
        local sound_loop = "Hero_Invoker.ChaosMeteor.Loop"
        local sound_stop = "Hero_Invoker.ChaosMeteor.Destroy"
        StopSoundOn( sound_loop, self:GetParent() )
        EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), sound_stop, self:GetCaster() )
        UTIL_Remove(self:GetParent())
    end
end

function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:OnIntervalThink()
	if not self.fallen then
		-- meatball has fallen
		self.fallen = true
		self:StartIntervalThink( self.interval )
		self:Burn()
		self:PlayEffects2()
	end
end

-- 陨石落地，撞击瞬间
function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:Burn()
	if not IsServer() then return end
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
	local damage = self.damage
	local damageTable = {
		-- victim = target,
		damage = damage,
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = ability,
		hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE,
	}
	

	for _,enemy in pairs(enemies) do
		if not self.effect_unit[enemy] then
			self.effect_unit[enemy] =true
			damageTable.victim = enemy
			ApplyDamage( damageTable )
		end
	end
end

function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:PlayEffects1()
	local particle_cast = "particles/rebuild/spell/chaos_meteor/chaos_meteor_fly.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Cast"
	local height = 1000
	local height_target = -0

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent_origin + Vector( 0, 0, height ) )
	ParticleManager:SetParticleControl( effect_cast, 1, self.parent_origin + Vector( 0, 0, height_target) )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( self.delay+0.1, 0, 0 ) )
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 0, self.radius*1/275, 0 ) )
	ParticleManager:SetParticleShouldCheckFoW(effect_cast, false)
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOnLocationWithCaster( self.caster_origin, sound_impact, self:GetCaster() )
end

function modifier_item_hd_dingzhi_shitking_effects_phantom_metor:PlayEffects2()
	if not IsServer() then return end
	ScreenShake( self:GetParent():GetOrigin(), 100.0, 100.0, 0.5, 700.0, 0, true )
	local particle_cast = "particles/rebuild/items/song_of_ice_and_fire/fire.vpcf"
	local sound_impact = "Hero_Invoker.ChaosMeteor.Impact"

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

    -- local pfx_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", PATTACH_WORLDORIGIN, nil)
	-- ParticleManager:SetParticleControl(pfx_aoe, 0, self:GetParent():GetAbsOrigin())
	-- ParticleManager:SetParticleControl(pfx_aoe, 1, Vector(2*self.radius,2*self.radius,2*self.radius))
	-- ParticleManager:SetParticleShouldCheckFoW(pfx_aoe, false)
	-- ParticleManager:ReleaseParticleIndex(pfx_aoe)


	EmitSoundOnLocationWithCaster( self.parent_origin, sound_impact, self:GetCaster() )

end



