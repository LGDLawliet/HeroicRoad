item_hd_pnxwing_effects = class({})
LinkLuaModifier("modifier_item_hd_pnxwing_effects", "player_artifact/item_hd_pnxwing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pnxwing_effects_fire", "player_artifact/item_hd_pnxwing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pnxwing_effects_fire_lv20", "player_artifact/item_hd_pnxwing_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_pnxwing_effects_fire_lv40", "player_artifact/item_hd_pnxwing_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_pnxwing_effects:GetIntrinsicModifierName()
	return "modifier_item_hd_pnxwing_effects"
end
function item_hd_pnxwing_effects:Precache( context )
	PrecacheResource( "particle", "particles/econ/items/dragon_knight/dk_2022_immortal/dk_2022_immortal_dragon_tail_dragon.vpcf", context )
    PrecacheResource( "particle", "particles/rebuild/talent/phoenix_talent_3/supernovaecon/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf", context )
    PrecacheResource( "particle", "particles/indicator/new_custom_indicator_range_2.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf", context )
    PrecacheResource( "particle", "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf", context )
end
-------------------------------------------------------------------
modifier_item_hd_pnxwing_effects = advanced_modifier({})

function modifier_item_hd_pnxwing_effects:IsDebuff() return true end
function modifier_item_hd_pnxwing_effects:IsHidden() return false end
function modifier_item_hd_pnxwing_effects:IsPurgable() return false end
function modifier_item_hd_pnxwing_effects:RemoveOnDeath() return false end
function modifier_item_hd_pnxwing_effects:GetTexture() return "item_artifact_6" end

function modifier_item_hd_pnxwing_effects:OnCreated(keys)
    self.ability = self:GetAbility()
    self.bonus_outgoing_mult = self.ability:GetArtifactSpecialValueFor("bonus_outgoing_mult")
    self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost")*0.01
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_pnxwing_effects")
    self.heal_3 = 0

    if self.level >= 10 then
        self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing_1")
    end
    if self.level >= 30 then
        self.heal_3 = self.ability:GetArtifactSpecialValueFor("heal_3")*0.01
        self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost_3")*0.01
    end
    if IsServer() then 
        self:StartIntervalThink(1)
    end
end

function modifier_item_hd_pnxwing_effects:OnRefresh(keys)
    self.bonus_outgoing_mult = self.ability:GetArtifactSpecialValueFor("bonus_outgoing_mult")
    self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost")*0.01
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.line = self.ability:GetArtifactSpecialValueFor("line")
    self.duration = self.ability:GetArtifactSpecialValueFor("duration")
    self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing")
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_pnxwing_effects")

    self.heal_3 = 0
    if self.level >= 10 then
        self.outgoing = self.ability:GetArtifactSpecialValueFor("outgoing_1")
    end
    if self.level >= 30 then
        self.heal_3 = self.ability:GetArtifactSpecialValueFor("heal_3")*0.01
        self.hp_cost = self.ability:GetArtifactSpecialValueFor("hp_cost_3")*0.01
    end
end

function modifier_item_hd_pnxwing_effects:OnIntervalThink()
    self:BonusFire()
    self.outgoing_final = ((1+self.bonus_outgoing_mult*0.01)*(1+self:GetStackCount()*self.outgoing*0.01)-1)*100
    if self:GetStackCount() >= self.line  then
        if self:GetParent():GetLevel() < 36 then
            self:SetStackCount(0)
        else
 
            local modifier = self:GetParent():FindModifierByName("modifier_item_hd_pnxwing_effects_fire")
            if modifier then
                return 
            else
                local sound_cast = "Ability.LightStrikeArray"
	            EmitSoundOnLocationWithCaster( self:GetCaster():GetAbsOrigin(), sound_cast, self:GetCaster() )
                self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_hd_pnxwing_effects_fire", {duration = self.duration})
            end
        end
    end
    
end

function modifier_item_hd_pnxwing_effects:BonusFire()
    self:GetParent():ModifyHealth(self:GetParent():GetHealth()*(1-self.hp_cost), self:GetAbility(), false, 0)
    self:SetStackCount(math.min(self:GetStackCount() + 1, self.line))
    local particle_aoe_fx = ParticleManager:CreateParticle("particles/econ/items/dragon_knight/dk_2022_immortal/dk_2022_immortal_dragon_tail_dragon.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
    ParticleManager:SetParticleControl(particle_aoe_fx, 2, self:GetParent():GetAbsOrigin()+Vector(0,0,150))
    ParticleManager:ReleaseParticleIndex(particle_aoe_fx) 
end

function modifier_item_hd_pnxwing_effects:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_TAKEDAMAGE = {nil,self:GetParent()}
    }
end

function modifier_item_hd_pnxwing_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if self:GetParent():GetLevel() < 36 then
       return  math.min(self.outgoing_final*0.5,40)
    end
    return  math.min(self.outgoing_final,40)
end

function modifier_item_hd_pnxwing_effects:OnTakeDamage(keys)
    if not IsServer() then return end
    if keys.unit ~= self:GetParent() then return end
    if keys.damage <= 0 then return end
    if self.level < 30 then return end
    
    local heal = (self:GetParent():GetMaxHealth() - self:GetParent():GetHealth())*self.heal_3
    if heal <= 0 then return end
    self:GetParent():Heal(heal,self:GetAbility())
end
-------------------------------------------------------------------
modifier_item_hd_pnxwing_effects_fire = advanced_modifier({})

function modifier_item_hd_pnxwing_effects_fire:IsDebuff() return true end
function modifier_item_hd_pnxwing_effects_fire:IsHidden() return false end
function modifier_item_hd_pnxwing_effects_fire:IsPurgable() return false end
function modifier_item_hd_pnxwing_effects_fire:GetTexture() return "item_artifact_6" end
function modifier_item_hd_pnxwing_effects_fire:GetEffectName() return "particles/rebuild/talent/phoenix_talent_3/supernovaecon/items/ember_spirit/ember_ti9/ember_ti9_flameguard.vpcf" end
function modifier_item_hd_pnxwing_effects_fire:GetEffectAttachType() return PATTACH_CENTER_FOLLOW end 
function modifier_item_hd_pnxwing_effects_fire:OnCreated()
    self.ability = self:GetAbility()
    if not self.ability then self:Destroy() end
    
    self.damage = self.ability:GetArtifactSpecialValueFor("damage")
    self.index_max = self.ability:GetArtifactSpecialValueFor("index_max")*0.01 -1 
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_pnxwing_effects")
    self.heal_1 = self.ability:GetArtifactSpecialValueFor("heal_1")*0.01
    self.damage_hp_2 = self.ability:GetArtifactSpecialValueFor("damage_hp_2")*0.01
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.fire_index_4 = self.ability:GetArtifactSpecialValueFor("fire_index_4")*0.01
    self:FireWarning()
    self:FireWarning_2(30)
    self:FireWarning_3(-30)
end

function modifier_item_hd_pnxwing_effects_fire:OnDestroy()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    if self:GetParent():GetLevel() >= 36 then
        self:FireBrust()
        self:FireBrust_2(30)
        self:FireBrust_3(-30)
    end
    local modifier = self:GetParent():FindModifierByName("modifier_item_hd_pnxwing_effects")
    if modifier then 
        modifier:SetStackCount(0)
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireWarning(anglechange)
    if IsServer() then
        local angle = anglechange or 0

        local caster = self:GetCaster()
	    local caster_pos = caster:GetAbsOrigin()
	    local point = caster_pos
	    if point == caster_pos then
		    point = point + self:GetCaster():GetForwardVector()
	    end

        point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	    local norm = (point - caster_pos):Normalized()
	    point.z = point.z +64
	    local target_point = caster:GetAbsOrigin() + norm * 2000
	    target_point.z = target_point.z+64

        self.fx = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_2.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl(self.fx, 0, self:GetCaster():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.fx, 2, Vector(2.4,0,0))
	    ParticleManager:SetParticleControl(self.fx, 1, target_point)
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireWarning_2(anglechange)
    if IsServer() then
        local angle = anglechange or 0

        local caster = self:GetCaster()
	    local caster_pos = caster:GetAbsOrigin()
	    local point = caster_pos
	    if point == caster_pos then
		    point = point + self:GetCaster():GetForwardVector()
	    end

        point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	    local norm = (point - caster_pos):Normalized()
	    point.z = point.z +64
	    local target_point = caster:GetAbsOrigin() + norm * 2000
	    target_point.z = target_point.z+64

        self.fx2 = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_2.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl(self.fx2, 0, self:GetCaster():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.fx2, 2, Vector(2.4,0,0))
	    ParticleManager:SetParticleControl(self.fx2, 1, target_point)
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireWarning_3(anglechange)
    if IsServer() then
        local angle = anglechange or 0

        local caster = self:GetCaster()
	    local caster_pos = caster:GetAbsOrigin()
	    local point = caster_pos
	    if point == caster_pos then
		    point = point + self:GetCaster():GetForwardVector()
	    end

        point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	    local norm = (point - caster_pos):Normalized()
	    point.z = point.z +64
	    local target_point = caster:GetAbsOrigin() + norm * 2000
	    target_point.z = target_point.z+64

        self.fx3 = ParticleManager:CreateParticle("particles/indicator/new_custom_indicator_range_2.vpcf", PATTACH_WORLDORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl(self.fx3, 0, self:GetCaster():GetAbsOrigin())
	    ParticleManager:SetParticleControl(self.fx3, 2, Vector(2.4,0,0))
	    ParticleManager:SetParticleControl(self.fx3, 1, target_point)
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireBrust(anglechange)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local angle = anglechange or 0
    local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local point = caster_pos
	if point == caster_pos then
		point = point + self:GetCaster():GetForwardVector()
	end

    point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	local norm = (point - caster_pos):Normalized()
	point.z = point.z +64
	local target_point = caster:GetAbsOrigin() + norm * 2000
	target_point.z = target_point.z+64

    if self.fx then
        ParticleManager:DestroyParticle(self.fx, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	    ParticleManager:ReleaseParticleIndex(self.fx)
    end

    local particle_caster_ground = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
    for i = 0, 8, 1 do
        local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
        local sound_cast = "Ability.LightStrikeArray"

        local target_point = caster_pos + norm * i*200
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
	    EmitSoundOnLocationWithCaster( target_point, sound_cast, self:GetCaster() )
    end

    local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_pos, caster_pos + norm * 2000, nil, 400,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    
    local damage = caster:HDGetPrimaryStatValue()*self.damage
    local losthp_pct = (caster:GetMaxHealth()-caster:GetHealth())/caster:GetMaxHealth()
    local index = (1+losthp_pct*self.index_max)

    if self.level >= 20 then
        damage = damage + caster:GetMaxHealth()*self.damage_hp_2 
        if caster:GetHealthPercent() <= 50 then
            self.disheal = true
        else
            self.disheal = nil
        end
    end

    for _, enemy in pairs(tTargets) do

        local real_damage = damage*index
        local damageTable = {
                            victim = enemy,
                            attacker = caster,
                            damage = real_damage,
                            damage_type = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = self:GetAbility(), --Optional.
                            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
                            }
        ApplyDamage(damageTable)
        if self.disheal then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv20",{duration = self.duration_2}) 
        end
        if self.level >= 40 then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv40",{damage = real_damage*self.fire_index_4}) 
        end
    end

    if self.level >= 10 then
        self:GetParent():Heal((caster:GetMaxHealth()-caster:GetHealth())*self.heal_1, self:GetAbility())
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireBrust_2(anglechange)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local angle = anglechange or 0
    local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local point = caster_pos
	if point == caster_pos then
		point = point + self:GetCaster():GetForwardVector()
	end

    point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	local norm = (point - caster_pos):Normalized()
	point.z = point.z +64
	local target_point = caster:GetAbsOrigin() + norm * 2000
	target_point.z = target_point.z+64

    if self.fx then
        ParticleManager:DestroyParticle(self.fx2, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	    ParticleManager:ReleaseParticleIndex(self.fx2)
    end

    local particle_caster_ground = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
    for i = 0, 8, 1 do
        local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
        local sound_cast = "Ability.LightStrikeArray"

        local target_point = caster_pos + norm * i*200
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
	    EmitSoundOnLocationWithCaster( target_point, sound_cast, self:GetCaster() )
    end

    local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_pos, caster_pos + norm * 2000, nil, 400,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    
    local damage = caster:HDGetPrimaryStatValue()*self.damage
    local losthp_pct = (caster:GetMaxHealth()-caster:GetHealth())/caster:GetMaxHealth()
    local index = (1+losthp_pct*self.index_max)

    if self.level >= 20 then
        damage = damage + caster:GetMaxHealth()*self.damage_hp_2 
        if caster:GetHealthPercent() <= 50 then
            self.disheal = true
        else
            self.disheal = nil
        end
    end

    for _, enemy in pairs(tTargets) do

        local real_damage = damage*index
        local damageTable = {
                            victim = enemy,
                            attacker = caster,
                            damage = real_damage,
                            damage_type = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = self:GetAbility(), --Optional.
                            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
                            }
        ApplyDamage(damageTable)
        if self.disheal then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv20",{duration = self.duration_2}) 
        end
        if self.level >= 40 then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv40",{damage = real_damage*self.fire_index_4}) 
        end
    end

    if self.level >= 10 then
        self:GetParent():Heal((caster:GetMaxHealth()-caster:GetHealth())*self.heal_1, self:GetAbility())
    end
end

function modifier_item_hd_pnxwing_effects_fire:FireBrust_3(anglechange)
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local angle = anglechange or 0
    local caster = self:GetCaster()
	local caster_pos = caster:GetAbsOrigin()
	local point = caster_pos
	if point == caster_pos then
		point = point + self:GetCaster():GetForwardVector()
	end

    point = RotatePosition(caster_pos, QAngle(0, angle, 0), point)--三叉位置调整
	local norm = (point - caster_pos):Normalized()
	point.z = point.z +64
	local target_point = caster:GetAbsOrigin() + norm * 2000
	target_point.z = target_point.z+64

    if self.fx then
        ParticleManager:DestroyParticle(self.fx3, true ) --注意这里原版写了false 会延迟一小会儿销毁特效 
	    ParticleManager:ReleaseParticleIndex(self.fx3)
    end

    local particle_caster_ground = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
    for i = 0, 8, 1 do
        local particle_caster_ground_fx = ParticleManager:CreateParticle(particle_caster_ground, PATTACH_WORLDORIGIN, caster)
        local sound_cast = "Ability.LightStrikeArray"

        local target_point = caster_pos + norm * i*200
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 0, target_point)
        ParticleManager:SetParticleControl(particle_caster_ground_fx, 1, Vector(400, 1, 1))
        ParticleManager:ReleaseParticleIndex(particle_caster_ground_fx)
	    EmitSoundOnLocationWithCaster( target_point, sound_cast, self:GetCaster() )
    end

    local tTargets = FindUnitsInLine(caster:GetTeamNumber(), caster_pos, caster_pos + norm * 2000, nil, 400,
    DOTA_UNIT_TARGET_TEAM_ENEMY,
    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)

    
    local damage = caster:HDGetPrimaryStatValue()*self.damage
    local losthp_pct = (caster:GetMaxHealth()-caster:GetHealth())/caster:GetMaxHealth()
    local index = (1+losthp_pct*self.index_max)

    if self.level >= 20 then
        damage = damage + caster:GetMaxHealth()*self.damage_hp_2 
        if caster:GetHealthPercent() <= 50 then
            self.disheal = true
        else
            self.disheal = nil
        end
    end

    for _, enemy in pairs(tTargets) do

        local real_damage = damage*index
        local damageTable = {
                            victim = enemy,
                            attacker = caster,
                            damage = real_damage,
                            damage_type = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = self:GetAbility(), --Optional.
                            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
                            }
        ApplyDamage(damageTable)
        if self.disheal then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv20",{duration = self.duration_2}) 
        end
        if self.level >= 40 then
           enemy:AddNewModifier(caster,self:GetAbility(),"modifier_item_hd_pnxwing_effects_fire_lv40",{damage = real_damage*self.fire_index_4}) 
        end
    end

    if self.level >= 10 then
        self:GetParent():Heal((caster:GetMaxHealth()-caster:GetHealth())*self.heal_1, self:GetAbility())
    end
end


function modifier_item_hd_pnxwing_effects_fire:CheckState()
    return{
        [MODIFIER_STATE_ROOTED] = true,
    }
end
function modifier_item_hd_pnxwing_effects_fire:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_PROPERTY_DISABLE_TURNING
    }
end
function modifier_item_hd_pnxwing_effects_fire:GetMinHealth()
    return 1
end
function modifier_item_hd_pnxwing_effects_fire:GetModifierDisableTurning()
    return 1
end


-------------------------------------------------------------------
modifier_item_hd_pnxwing_effects_fire_lv20 = advanced_modifier({})

function modifier_item_hd_pnxwing_effects_fire_lv20:IsDebuff() return true end
function modifier_item_hd_pnxwing_effects_fire_lv20:IsHidden() return true end
function modifier_item_hd_pnxwing_effects_fire_lv20:IsPurgable() return false end
function modifier_item_hd_pnxwing_effects_fire_lv20:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_DISABLE_HEALING
    }
end
function modifier_item_hd_pnxwing_effects_fire_lv20:GetDisableHealing()
    return 1
end
-------------------------------------------------------------------
modifier_item_hd_pnxwing_effects_fire_lv40 = advanced_modifier({})

function modifier_item_hd_pnxwing_effects_fire_lv40:IsDebuff() return true end
function modifier_item_hd_pnxwing_effects_fire_lv40:IsHidden() return false end
function modifier_item_hd_pnxwing_effects_fire_lv40:IsPurgable() return false end
function modifier_item_hd_pnxwing_effects_fire_lv40:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end
function modifier_item_hd_pnxwing_effects_fire_lv40:GetEffectName() return "particles/econ/items/huskar/huskar_2021_immortal/huskar_2021_immortal_burning_spear_debuff.vpcf" end
function modifier_item_hd_pnxwing_effects_fire_lv40:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end
function modifier_item_hd_pnxwing_effects_fire_lv40:GetTexture() return "item_artifact_6" end
function modifier_item_hd_pnxwing_effects_fire_lv40:OnCreated(keys)
    self.incoming_7 = self:GetAbility():GetArtifactSpecialValueFor("incoming_7")
    if IsServer() then
        self.damage = keys.damage or 0
        self:SetStackCount(self.damage)
        self:StartIntervalThink(1)
    end
end
function modifier_item_hd_pnxwing_effects_fire_lv40:OnIntervalThink()
    if not self:GetAbility() then self:Destory() return end
    local damageTable = {
                            victim = self:GetParent(),
                            attacker = self:GetCaster(),
                            damage = self:GetStackCount(),
                            damage_type = DAMAGE_TYPE_PURE,
                            damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
                            ability = nil, --Optional.
                            hd_flags = HD_DAMAGE_FLAG_FIRE_DAMAGE
                            }
    ApplyDamage(damageTable)
end
function modifier_item_hd_pnxwing_effects_fire_lv40:DeclareFunctions()
    return{
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_pnxwing_effects_fire_lv40:OnTooltip()
    return self:GetStackCount()
end
function modifier_item_hd_pnxwing_effects_fire_lv40:ADDeclareFunctions()
    return{
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_item_hd_pnxwing_effects_fire_lv40:Advanced_GetModifierIncomingDamage_Percentage()
    if not self:GetAbility() then self:Destory() return end
    return self.incoming_7
end