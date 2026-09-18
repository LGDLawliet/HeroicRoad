item_hd_ice_bite_effects = class({})
LinkLuaModifier("modifier_item_hd_ice_bite_effects", "player_artifact/item_hd_ice_bite_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_bite_effects_lv10", "player_artifact/item_hd_ice_bite_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_bite_effects_lv20", "player_artifact/item_hd_ice_bite_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_bite_effects_lv40", "player_artifact/item_hd_ice_bite_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_ice_bite_effects_lv70", "player_artifact/item_hd_ice_bite_effects.lua", LUA_MODIFIER_MOTION_NONE)
function item_hd_ice_bite_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_ice_bite_effects"
end

function item_hd_ice_bite_effects:Precache(context)
    PrecacheResource("particle", "particles/rebuild/artifact/ice_bite/effect.vpcf", context)
    PrecacheResource("particle", "particles/rebuild/artifact/ice_bite/hiteffect.vpcf", context)
end

modifier_item_hd_ice_bite_effects = advanced_modifier({})

function modifier_item_hd_ice_bite_effects:IsDebuff() return false end
function modifier_item_hd_ice_bite_effects:IsHidden() return true end
function modifier_item_hd_ice_bite_effects:IsPurgable() return false end
function modifier_item_hd_ice_bite_effects:RemoveOnDeath() return false end
function modifier_item_hd_ice_bite_effects:GetTexture() return "item_artifact_4" end
function modifier_item_hd_ice_bite_effects:DestroyOnExpire() return false end

function modifier_item_hd_ice_bite_effects:OnCreated()
    self.ability = self:GetAbility()
    self.damage_pct = self.ability:GetArtifactSpecialValueFor("damage_pct")
    self.armor_pct = self.ability:GetArtifactSpecialValueFor("armor_pct")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.speed_limit = self.ability:GetArtifactSpecialValueFor("speed_limit")*0.01
    self.mult = self.ability:GetArtifactSpecialValueFor("mult")-100
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_ice_bite_effects")
    
    -- Additional effects
    self.speed_down_1 = self.ability:GetArtifactSpecialValueFor("speed_down_1")
    self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.mult_3 = self.ability:GetArtifactSpecialValueFor("mult_3")-100
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    if self.level >= 30 then
       self.mult = self.mult_3
    end
    if self.level >= 100 then
        self.speed_limit = self.ability:GetArtifactSpecialValueFor("speed_limit_100")*0.01
    end
    self.mult_10 = self.ability:GetArtifactSpecialValueFor("mult_10")-100
    if IsServer() then
        self:StartIntervalThink(self.interval_4)
    end
end

function modifier_item_hd_ice_bite_effects:OnRefresh()
    self.ability = self:GetAbility()
    self.damage_pct = self.ability:GetArtifactSpecialValueFor("damage_pct")
    self.armor_pct = self.ability:GetArtifactSpecialValueFor("armor_pct")
    self.chance = self.ability:GetArtifactSpecialValueFor("chance")
    self.speed_limit = self.ability:GetArtifactSpecialValueFor("speed_limit")*0.01
    self.mult = self.ability:GetArtifactSpecialValueFor("mult")-100
    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(), "item_hd_ice_bite_effects")
    
    -- Additional effects
    self.speed_down_1 = self.ability:GetArtifactSpecialValueFor("speed_down_1")
    self.duration_1 = self.ability:GetArtifactSpecialValueFor("duration_1")
    self.duration_2 = self.ability:GetArtifactSpecialValueFor("duration_2")
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.mult_3 = self.ability:GetArtifactSpecialValueFor("mult_3")-100
    self.interval_4 = self.ability:GetArtifactSpecialValueFor("interval_4")
    self.radius_4 = self.ability:GetArtifactSpecialValueFor("radius_4")
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
    self.duration_7 = self.ability:GetArtifactSpecialValueFor("duration_7")
    
    if self.level >= 30 then
       self.mult = self.mult_3
    end
    if self.level >= 100 then
        self.speed_limit = self.ability:GetArtifactSpecialValueFor("speed_limit_100")*0.01
    end
    self.mult_10 = self.ability:GetArtifactSpecialValueFor("mult_10")-100
end

function modifier_item_hd_ice_bite_effects:OnDestroy()
    if IsServer() then
        if self.effect then
            DestroyParticleByDelay(self.effect, 0.8)
        end
    end
end

function modifier_item_hd_ice_bite_effects:OnIntervalThink()
    if self.level >= 40 then
        self:ApplyWindPressure()
    end
end

function modifier_item_hd_ice_bite_effects:ApplyWindPressure()
    if not IsServer() then return end
    local parent = self:GetParent()
    local pos = parent:GetAbsOrigin()
    
    self:Lv40Effects()
    local modifier_keys = {
				duration = 0.1,
				iSpecialAttack = 1,
				iDisableApplyModifier = 0,
				iDisableCleave =1,
				iDisableSplit = 1,
	}
	local attackEffectRecord = parent:AddAttackEffectModifier(self.ability,modifier_keys)

    local units = FindUnitsInRadius(parent:GetTeamNumber(), pos, nil, self.radius_4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, unit in ipairs(units) do
        parent:PerformAttack(unit, false, true, true, true, false, false, false)--目标，法球，攻击特效，跳过攻击冷却，无视视野，使用弹道和弹速，虚假攻击(false)，永不丢失
        if unit:IsAlive() and self.level >= 40 then
            unit:AddNewModifier(parent, self.ability, "modifier_item_hd_ice_bite_effects_lv40", {duration = self.interval_4})
        end
    end

    if IsValid(attackEffectRecord) then
		attackEffectRecord:Destroy()
	end
end

function modifier_item_hd_ice_bite_effects:Lv40Effects()
    local parent = self:GetParent()
	local particle_cast = "particles/rebuild/artifact/ice_bite/effect.vpcf"

	self.effect = ParticleManager:CreateParticle( particle_cast, PATTACH_CENTER_FOLLOW, parent )
	ParticleManager:SetParticleControl( self.effect, 5, Vector( self.radius_4, 0, 0 ) )
    DestroyParticleByDelay(self.effect, 0.3)
end

function modifier_item_hd_ice_bite_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        MODIFIER_EVENT_ON_ATTACK_LANDED = {self:GetParent(),nil},
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_PERCENTAGE,
    }
end
function modifier_item_hd_ice_bite_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_ABSOLUTE_MAX,
    }
end

function modifier_item_hd_ice_bite_effects:GetModifierAttackSpeedAbsoluteMax()
    return self.speed_limit
end

function modifier_item_hd_ice_bite_effects:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return self.damage_pct
end

function modifier_item_hd_ice_bite_effects:Advanced_GetModifierPhysicalArmorBonusPercentage()
    return self.armor_pct
end

function modifier_item_hd_ice_bite_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    if keys.damage_category ~= DOTA_DAMAGE_CATEGORY_ATTACK then return end
    
    local target = keys.target
    local parent = self:GetParent()
    local random = math.random
    local chance = self.chance

    if chance >= random(1,100) then
        self:HitEffect(target)
        target:AddNewModifier(parent, self.ability, "modifier_item_hd_ice_bite_effects_lv10",{duration = self.duration_1})
        if self.level >= 70 then
            local duration = self.duration_7*target:GetHDStatusResistanceIndex(1.1)
            target:AddNewModifier(parent, self.ability, "modifier_item_hd_ice_bite_effects_lv70",{duration = duration})
        end
        if self.level >= 100 and target:HasModifier("modifier_hd_freezing") then
            return self.mult_10
        end
        return self.mult
    end
    return 0
end

function modifier_item_hd_ice_bite_effects:HitEffect( target )
	local particle_cast = "particles/rebuild/artifact/ice_bite/hiteffect.vpcf"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end

function modifier_item_hd_ice_bite_effects:OnAttackLanded(params)
    if not IsServer() then return end
    local attacker = params.attacker
    local parent = self:GetParent()
    local target = params.target

    if attacker ~= parent then return end
    if not target or not target:IsAlive() then return end
    if attacker:IsInSpecialAttack() then return end

    if self.level >= 20 then
        parent:AddNewModifier(parent, self.ability, "modifier_item_hd_ice_bite_effects_lv20", {duration = self.duration_2, target_entindex = target:GetEntityIndex()})
    end
end

--
modifier_item_hd_ice_bite_effects_lv10 = advanced_modifier({})

function modifier_item_hd_ice_bite_effects_lv10:IsDebuff() return true end
function modifier_item_hd_ice_bite_effects_lv10:IsHidden() return false end
function modifier_item_hd_ice_bite_effects_lv10:IsPurgable() return true end
function modifier_item_hd_ice_bite_effects_lv10:GetTexture() return "item_artifact_4" end

function modifier_item_hd_ice_bite_effects_lv10:OnCreated()
    self.ability = self:GetAbility()
    self.speed_down_1 = self.ability:GetArtifactSpecialValueFor("speed_down_1")
end

function modifier_item_hd_ice_bite_effects_lv10:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
    }
end

function modifier_item_hd_ice_bite_effects_lv10:GetModifierAttackSpeedBonus_Constant()
    if not self:GetAbility() then self:Destroy() return end
    return -self.speed_down_1
end

--
modifier_item_hd_ice_bite_effects_lv20 = advanced_modifier({})

function modifier_item_hd_ice_bite_effects_lv20:IsDebuff() return false end
function modifier_item_hd_ice_bite_effects_lv20:IsHidden() return true end
function modifier_item_hd_ice_bite_effects_lv20:IsPurgable() return false end
function modifier_item_hd_ice_bite_effects_lv20:GetTexture() return "item_artifact_4" end

function modifier_item_hd_ice_bite_effects_lv20:OnCreated(params)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.target_entindex = params.target_entindex
end

function modifier_item_hd_ice_bite_effects_lv20:OnRefresh(params)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.incoming_2 = self.ability:GetArtifactSpecialValueFor("incoming_2")
    self.target_entindex = params.target_entindex
end

function modifier_item_hd_ice_bite_effects_lv20:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_hd_ice_bite_effects_lv20:Advanced_GetModifierIncomingDamage_Percentage(keys)
    if not IsServer() then return end
    if not self:GetAbility() then self:Destroy() return end
    
    local attacker = keys.attacker
    if not attacker then return end
    
    -- 检查伤害来源是否是目标单位
    if attacker:GetEntityIndex() == self.target_entindex then
        return 0
    end
    print("并非此来源伤害，正确减免")
    return -self.incoming_2
end

--
modifier_item_hd_ice_bite_effects_lv40 = advanced_modifier({})

function modifier_item_hd_ice_bite_effects_lv40:IsDebuff() return true end
function modifier_item_hd_ice_bite_effects_lv40:IsHidden() return false end
function modifier_item_hd_ice_bite_effects_lv40:IsPurgable() return true end
function modifier_item_hd_ice_bite_effects_lv40:GetTexture() return "item_artifact_4" end

function modifier_item_hd_ice_bite_effects_lv40:OnCreated()
    self.ability = self:GetAbility()
    self.outgoing_4 = self.ability:GetArtifactSpecialValueFor("outgoing_4")
end

function modifier_item_hd_ice_bite_effects_lv40:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
    }
end

function modifier_item_hd_ice_bite_effects_lv40:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul()
    if not self:GetAbility() then self:Destroy() return end
    return -self.outgoing_4
end 

--
modifier_item_hd_ice_bite_effects_lv70 = advanced_modifier({})

function modifier_item_hd_ice_bite_effects_lv70:IsDebuff() return true end
function modifier_item_hd_ice_bite_effects_lv70:IsHidden() return false end
function modifier_item_hd_ice_bite_effects_lv70:IsPurgable() return false end
function modifier_item_hd_ice_bite_effects_lv70:GetTexture() return "item_artifact_4" end

function modifier_item_hd_ice_bite_effects_lv70:CheckState()
    return{
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
end
