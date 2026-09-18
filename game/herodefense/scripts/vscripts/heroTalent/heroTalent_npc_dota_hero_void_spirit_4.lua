heroTalent_npc_dota_hero_void_spirit_4 = class({})
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_void_spirit_4", "heroTalent/heroTalent_npc_dota_hero_void_spirit_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_remnant_thinker", "heroTalent/heroTalent_npc_dota_hero_void_spirit_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff", "heroTalent/heroTalent_npc_dota_hero_void_spirit_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker", "heroTalent/heroTalent_npc_dota_hero_void_spirit_4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff", "heroTalent/heroTalent_npc_dota_hero_void_spirit_4", LUA_MODIFIER_MOTION_NONE )
function heroTalent_npc_dota_hero_void_spirit_4:Precache( context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_thinker.vpcf", context )
end

function heroTalent_npc_dota_hero_void_spirit_4:GetIntrinsicModifierName()
    return "modifier_heroTalent_npc_dota_hero_void_spirit_4"
end

-- 判断是否是排行榜难度
function heroTalent_npc_dota_hero_void_spirit_4:IsRangedMode()
	if not IsServer() then
		return
	end
	if  _G.GAME_CHANLLENGE_Contest_Type == 1 or _G.GAME_CHANLLENGE_Contest_Type == 2 then
		return true
	end
	return false
end

-- =========================================
--              残阴部分
-- =========================================
function heroTalent_npc_dota_hero_void_spirit_4:Spawn()
    if IsServer() then
        self.remnants = {}
    end
end

function heroTalent_npc_dota_hero_void_spirit_4:CreateRemnant()
    local caster = self:GetCaster()
    local origin_point = caster:GetAbsOrigin() 
    
    local random_angle = RandomFloat(0, 2 * math.pi)
    local distance = 600 

    


    local offset1 = Vector(
        distance * math.cos(random_angle),
        distance * math.sin(random_angle),
        0
    )
    local pos1 = GetClearSpaceForUnit(caster, origin_point + offset1)
    local dir = CalculateDirection(caster, pos1)
    self:CreateRemnantToPosition({
        start_pos = pos1,
        end_pos = origin_point + distance * dir
    })

    if caster:GetIntellect(false) >= self:GetSpecialValueFor("line3") then
        local pos2 = GetClearSpaceForUnit(caster, origin_point - offset1)
        self:CreateRemnantToPosition({
            start_pos = pos2,
            end_pos = origin_point - distance * dir
        })
    end
end

--start_pos必填
--end_pos必填
--duration_pct 百位数 可选，默认100
function heroTalent_npc_dota_hero_void_spirit_4:CreateRemnantToPosition(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local start_pos = keys.start_pos
    local end_pos = keys.end_pos
    local duration_pct = keys.duration_pct or 100

    local direction = CalculateDirection(end_pos, start_pos)

    local thinker_unit = CreateModifierThinker(
        caster,
        self,
        "modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker",
        {
            dir_x = direction.x,
            dir_y = direction.y,
            dir_z = direction.z,
            duration_index = duration_pct*0.01,
        },
        start_pos,
        caster:GetTeamNumber(),
        false
    )
    if not self.remnants then self.remnants = {} end


    local max_count = self:GetSpecialValueFor("max_count")

    self:RemoveInvalidRemnants()

    while #self.remnants >= max_count do
        local old_unit = self.remnants[1]
        table.remove(self.remnants, 1)
        if old_unit and not old_unit:IsNull() then
            local mod = old_unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker")
            if mod then
                mod:Destroy()
            else
                UTIL_Remove(old_unit)
            end
        end
    end
    if thinker_unit and not thinker_unit:IsNull() then
        table.insert(self.remnants, thinker_unit)
    end

    caster:EmitSound("Hero_VoidSpirit.AetherRemnant.Cast")
end

function heroTalent_npc_dota_hero_void_spirit_4:RemoveInvalidRemnants()
    if not self.remnants then return end
    
    for i = #self.remnants, 1, -1 do
        local unit = self.remnants[i]
        if not unit or unit:IsNull() or not IsValidEntity(unit) then
            table.remove(self.remnants, i)
        end
    end
end
-- =========================================
--              太虚之径部分
-- =========================================
function heroTalent_npc_dota_hero_void_spirit_4:GetCastRange(vLocation, hTarget)
    if IsServer() then
        return 999999
    end
    local max_range = self:GetSpecialValueFor("max_travel_distance") - self:GetCaster():GetCastRangeBonus()
    return max_range
end

function heroTalent_npc_dota_hero_void_spirit_4:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition() 

    self.callback_damage = 100
    if self:IsRangedMode() then
        self.callback_damage = 25
    end

    self.talentgain = self:GetTalentGain(1)*100 -100

    local keys = {
        end_pos = point,
        attacker = caster, 
    }
    self:CastEffectToPosition(keys)

    if self.remnants and #self.remnants > 0 and caster:GetAgility() >= self:GetSpecialValueFor("line2") then
        local default_move = caster:FindAbilityByName("Default_Move")
        if default_move then
            default_move:EndCooldown()
        end
        self:RemoveInvalidRemnants()
        local hit_ledger = {} 

        for i = #self.remnants, 1, -1 do
            local unit = self.remnants[i]
            if unit then
                local modifier = unit:FindModifierByName("modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker")
                if modifier and modifier.state == 3 then
                    local keys = {
                        attacker = unit,
                        start_pos = unit:GetAbsOrigin(),
                        end_pos = point,
                        is_remnant = 1,
                        collector = hit_ledger,
                        is_callback = 1,
                    }
                    self:CastEffectToPosition(keys)
                    modifier:Destroy()
                end
            end
        end


        for enemy, count in pairs(hit_ledger) do
            if IsValidEntity(enemy) and enemy:IsAlive() then
                local total_damage_pct = self.callback_damage * count
                
                self:ApplyEffect({
                    target = enemy,
                    attacker = caster,
                    damage_pct = total_damage_pct,
                })
            end
        end
    end

end

--attacker，可选，默认caster
--start_pos，可选，默认casterorigin
--end_pos，必填
--is_remnant 1/0 可选，默认0，用于解除最大距离限制
--is_callback 1/0 可选，默认0，用于判断是否为紫猫主动释放引发的回响，这个调到1代表着残影的最终位置必须是紫猫的位置
--damage_pct，百位数，选填，默认100，影响攻击和印记两个伤害
--collector，表，选填，默认nil，用于收集命中敌人，格式为{enemy_handle = hit_count}
function heroTalent_npc_dota_hero_void_spirit_4:CastEffectToPosition(keys)
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local end_pos = keys.end_pos
    local attacker = keys.attacker or caster
    local origin = attacker:GetAbsOrigin()
    local start_pos = keys.start_pos or origin
    local is_remnant = keys.is_remnant or 0
    local is_callback = keys.is_callback or 0
    local damage_pct = keys.damage_pct or 100
    local collector = keys.collector
    
    local min_dist = self:GetSpecialValueFor("min_travel_distance")
    local max_dist = self:GetSpecialValueFor("max_travel_distance")

    local distance = CalculateDistance(end_pos, start_pos)
    local direction = CalculateDirection(end_pos, start_pos)
    local dist = distance
    local target
    
    if is_remnant == 0 then
        dist = math.max(math.min(max_dist, distance), min_dist)
        caster:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    end
    
    if is_callback == 0 then
        --自己，或者残影出去的逻辑，这里因为残阴是没有原地指向性施法的，所以给开到无线距离是不会出现位置错位的
        target = GetGroundPosition(start_pos + direction * dist, nil)        
    else
        --响应的太虚，这里因为解除了距离限制，所以如果你鼠标点的很远他就会出现人没过去残阴过去了的怪情况，这里必须要锁最终位置就是紫猫的位置
        target = caster:GetAbsOrigin()
    end
    FindClearSpaceForUnit(attacker, target, true)
    self:PlayTeleportEffect(start_pos, target)
   

    local width = self:GetSpecialValueFor("width")
    local enemies = FindUnitsInLine(
        attacker:GetTeamNumber(),
        start_pos,
        target,
        nil,
        width,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE
    )

    for _, enemy in pairs(enemies) do
        if collector then
            if not collector[enemy] then collector[enemy] = 0 end
            collector[enemy] = collector[enemy] + 1
        else
            local keys = {
                target = enemy,
                attacker = attacker,
                damage_pct = damage_pct,
            }
            self:ApplyEffect(keys)
        end
    end
end

--target，必填
--attacker，可选，默认caster
--allow_mark，1/0，选填，默认施加印记
--damage_pct，百位数，选填，默认100，影响攻击和印记两个伤害
function heroTalent_npc_dota_hero_void_spirit_4:ApplyEffect(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = keys.target
    local attacker = keys.attacker or caster
    local allow_mark = keys.allow_mark or 1
    local damage_pct = keys.damage_pct or 100

    if allow_mark == 1 then
        self:ApplyMark({
            target = target,
            damage_pct = damage_pct,
        })
    end
end

--target,必填
--damage_pct，百位数，选填，默认100，影响印记伤害
function heroTalent_npc_dota_hero_void_spirit_4:ApplyMark(keys)
    if not IsServer() then return end
    local caster = self:GetCaster()
    local target = keys.target
    local delay = self:GetSpecialValueFor("pop_damage_delay")
    local damage_pct = keys.damage_pct or 100
    

    target:AddNewModifier(caster, self, "modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff", {
        damage_pct = damage_pct,
        duration = delay,
    })

    self:PlayImpactEffect(target)
end


function heroTalent_npc_dota_hero_void_spirit_4:PlayTeleportEffect(origin, target)
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf",
        PATTACH_WORLDORIGIN,
        self:GetCaster()
    )
    ParticleManager:SetParticleControl(particle, 0, origin)
    ParticleManager:SetParticleControl(particle, 1, target)
    ParticleManager:ReleaseParticleIndex(particle)
    
    EmitSoundOnLocationWithCaster(origin, "Hero_VoidSpirit.AstralStep.Start", self:GetCaster())
    EmitSoundOnLocationWithCaster(target, "Hero_VoidSpirit.AstralStep.End", self:GetCaster())
end

function heroTalent_npc_dota_hero_void_spirit_4:PlayImpactEffect(target)
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        target
    )
    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(particle)
end
------------------------
modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff = modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:OnCreated(kv)
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    
    if IsServer() then
        self.pop_damage = ability:GetSpecialValueFor("pop_damage") * kv.damage_pct *0.01 * ability:GetTalentGain(0.3) * caster:HDGetPrimaryStatValue()
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:OnDestroy()
    if not IsServer() then return end
    
    local caster = self:GetCaster()
    local target = self:GetParent()
    local ability = self:GetAbility()

    local damagetable = {
        victim = target,
        attacker = caster,
        damage = self.pop_damage,
        damage_type = ability:GetAbilityDamageType(),
        ability = ability,
        hd_flags = HD_DAMAGE_FLAG_DARK_DAMAGE
    }

    target:ApplyMergeDamage(damagetable)
    self:PlayExplosionEffect()
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:GetEffectName()
    return "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:GetStatusEffectName()
    return "particles/status_fx/status_effect_void_spirit_astral_step_debuff.vpcf"
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:StatusEffectPriority()
    return MODIFIER_PRIORITY_NORMAL
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_debuff:PlayExplosionEffect()
    local particle = ParticleManager:CreateParticle(
        "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg.vpcf",
        PATTACH_ABSORIGIN_FOLLOW,
        self:GetParent()
    )
    ParticleManager:ReleaseParticleIndex(particle)
    
    EmitSoundOnLocationWithCaster(self:GetParent():GetAbsOrigin(), "Hero_VoidSpirit.AstralStep.MarkExplosion", self:GetCaster())
end


----------------残阴modifier-------------------
modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker = modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:IsHidden() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:IsPurgable() return false end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:OnCreated(kv)
    local ability = self:GetAbility()
    local parent = self:GetParent()
    local caster = self:GetCaster()

    self.think_interval = 0.1
    self.activation_delay = 0.2
    self.projectile_speed = 1500
    self.remnant_watch_radius = 200
    self.remnant_watch_distance = ability:GetSpecialValueFor("radius")*ability:GetTalentGain(0.3)

    self.watch_path_vision_radius = self.remnant_watch_distance
    self.duration = ability:GetSpecialValueFor("duration")

    if IsServer() then
        self.duration = self.duration * kv.duration_index
        self:SetDuration(self.duration, true)

        self.damage_pct = 40
        self.origin = parent:GetAbsOrigin()
        self.direction = Vector(kv.dir_x, kv.dir_y, kv.dir_z)
        self.target_point = self.origin + self.direction * self.remnant_watch_distance

        self.state = 1

        print(caster:GetStrength(),ability:GetSpecialValueFor("line1"))
        if caster:GetStrength() >= ability:GetSpecialValueFor("line1") then
            print("line1")
            ability:CastEffectToPosition({
                attacker = parent,
                end_pos = self.origin,
                start_pos = caster:GetAbsOrigin(),
                is_remnant = 1,
                damage_pct = self.damage_pct,
            })
            self:StartIntervalThink(0.1)
        else
            local run_distance = (self.origin - caster:GetAbsOrigin()):Length2D()
            local run_delay = run_distance / self.projectile_speed
 
            self:StartIntervalThink(run_delay)
            self:PlayRunEffect()
        end

        parent:EmitSound("Hero_VoidSpirit.AetherRemnant")
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:OnIntervalThink()
    if not IsServer() then return end
    local caster = self:GetCaster()
    local ability = self:GetAbility()
    local parent = self:GetParent()

    if self.state == 1 then
        self.state = 2
        self:StartIntervalThink(self.activation_delay)
        self:PlayActivationEffect()
    elseif self.state == 2 then
        self.state = 3
        self:StartIntervalThink(self.think_interval)
        self:PlayWatchEffect()

        local parent = self:GetParent()
        parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
    elseif self.state == 3 then
        self:WatchLogic()
        self:StartIntervalThink(2)
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:WatchLogic()
    local parent = self:GetParent()
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    AddFOWViewer(parent:GetTeamNumber(), self.origin, self.watch_path_vision_radius, 2, true)
    AddFOWViewer(parent:GetTeamNumber(), self.origin + self.direction * self.remnant_watch_distance / 2, self.watch_path_vision_radius, 2, true)
    AddFOWViewer(parent:GetTeamNumber(), self.target_point, self.watch_path_vision_radius, 2, true)

    local enemies = FindUnitsInLine(
        caster:GetTeamNumber(),
        self.origin,
        self.target_point,
        nil,
        self.remnant_watch_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE
    )
    if #enemies <= 0 then return end

    for _, enemy in pairs(enemies) do
        enemy:AddNewModifier(caster, ability, "modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff", {
            duration = 2,
            origin_x = self.origin.x,
            origin_y = self.origin.y,
            origin_z = self.origin.z,
        })
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:OnDestroy()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local parent = self:GetParent()
    local ability = self:GetAbility()
    parent:StopSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")
    parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Destroy")
    if self.effect_cast then
        ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
    end

    if ability and ability.remnants then
        for i = #ability.remnants, 1, -1 do
            if ability.remnants[i] == parent then
                table.remove(ability.remnants, i)
                break
            end
        end
    end

    UTIL_Remove(parent)

end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:PlayRunEffect()
    if not IsServer() then return end

    local caster = self:GetCaster()
    local direction = (self.origin - caster:GetAbsOrigin()):Normalized()

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, direction * self.projectile_speed)
    ParticleManager:SetParticleControlForward(particle, 0, -direction)
    ParticleManager:SetParticleShouldCheckFoW(particle, false)

    self.effect_cast = particle
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:PlayActivationEffect()
    if not IsServer() then return end

    if self.effect_cast then
        ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
    end

    local parent = self:GetParent()
    local caster = self:GetCaster()

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pre.vpcf", PATTACH_CUSTOMORIGIN, parent)
    ParticleManager:SetParticleControl(particle, 0, self.origin)
    ParticleManager:SetParticleControlForward(particle, 0, self.direction)

    self.effect_cast = particle
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:PlayWatchEffect()
    if not IsServer() then return end

    if self.effect_cast then
        ParticleManager:DestroyParticle(self.effect_cast, false)
        ParticleManager:ReleaseParticleIndex(self.effect_cast)
    end

    local parent = self:GetParent()
    local caster = self:GetCaster()

    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf", PATTACH_CUSTOMORIGIN, parent)
    ParticleManager:SetParticleControl(particle, 0, self.origin)
    ParticleManager:SetParticleControl(particle, 1, self.target_point)
    ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
    ParticleManager:SetParticleControlForward(particle, 0, self.direction)
    ParticleManager:SetParticleControlForward(particle, 2, self.direction)

    self.effect_cast = particle
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:RefreshRemnant(new_position, new_direction)
    if not IsServer() then return end
    local parent = self:GetParent()
    if new_position then
        parent:SetAbsOrigin(new_position)
        self.origin = new_position
    else
        self.origin = parent:GetAbsOrigin()
    end
    if new_direction then
        self.direction = new_direction:Normalized()
        parent:SetForwardVector(self.direction)
    end

    self.target_point = self.origin + self.direction * self.remnant_watch_distance
    if self.state == 3 then
        self:PlayWatchEffect()
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker:CheckState()
    local funcs = {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        
    }
    return funcs
end


-----------
modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff = modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:IsDebuff() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:IsPurgable() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:IsPurgeException() return true end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:OnCreated(kv)  
    self.mrs_down = self:GetAbility():GetSpecialValueFor("mrs_down")
    if IsServer() then
        self:AddStackDuration(1, self:GetDuration())
    end
end
function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:OnRefresh(kv)  
    self.mrs_down = self:GetAbility():GetSpecialValueFor("mrs_down")
    if IsServer() then
        self:AddStackDuration(1, self:GetDuration())
    end
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:GetModifierMagicalResistanceBonus()
    return -self.mrs_down*self:GetStackCount()
end


function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:OnTooltip()
    return self:GetModifierMagicalResistanceBonus()
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4_thinker_debuff:CheckState()
    return {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end


-----------
modifier_heroTalent_npc_dota_hero_void_spirit_4 = modifier_heroTalent_npc_dota_hero_void_spirit_4 or advanced_modifier({})

function modifier_heroTalent_npc_dota_hero_void_spirit_4:IsHidden() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4:IsDebuff() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4:IsPurgable() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4:IsPurgeException() return false end
function modifier_heroTalent_npc_dota_hero_void_spirit_4:OnCreated(kv)  
    self.ability = self:GetAbility()
    self.bonus = 1 + self.ability:GetSpecialValueFor("legend_bonus")*0.01
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_heroTalent_npc_dota_hero_void_spirit_4:OnTooltip()
    self.talent_gain = self.ability:GetTalentGain(0.3)
    self.damage_t = self:GetAbility():GetSpecialValueFor("pop_damage")*self.talent_gain
    self.radius_t = self:GetAbility():GetSpecialValueFor("radius")*self.talent_gain

	self._tooltip = (self._tooltip or 0) % 2 + 1
    if self._tooltip == 1 then
        return self.damage_t
    elseif self._tooltip == 2 then
        return self.radius_t
    end
end