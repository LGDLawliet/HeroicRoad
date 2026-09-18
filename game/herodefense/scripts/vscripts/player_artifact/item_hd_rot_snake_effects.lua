-- 重做完成
item_hd_rot_snake_effects = class({})
LinkLuaModifier("modifier_item_hd_rot_snake_effects", "player_artifact/item_hd_rot_snake_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rot_snake_effects_debuff", "player_artifact/item_hd_rot_snake_effects.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_hd_rot_snake_effects_buff", "player_artifact/item_hd_rot_snake_effects.lua", LUA_MODIFIER_MOTION_NONE)

function item_hd_rot_snake_effects:GetIntrinsicModifierName()
    return "modifier_item_hd_rot_snake_effects"
end

function item_hd_rot_snake_effects:Precache(context)
    PrecacheResource("particle", "particles/units/heroes/hero_venomancer/venomancer_poison_debuff.vpcf", context)
end

modifier_item_hd_rot_snake_effects = advanced_modifier({})

function modifier_item_hd_rot_snake_effects:IsDebuff() return false end
function modifier_item_hd_rot_snake_effects:IsHidden() return false end
function modifier_item_hd_rot_snake_effects:IsPurgable() return false end
function modifier_item_hd_rot_snake_effects:GetTexture() return "item_artifact_65" end
function modifier_item_hd_rot_snake_effects:OnCreated()

    self.ability = self:GetAbility()
    self.health_pct = self.ability:GetArtifactSpecialValueFor("health_pct")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.down_2 = self.ability:GetArtifactSpecialValueFor("down_2")
    self.poison_3 = self.ability:GetArtifactSpecialValueFor("poison_3")
    self.poison_maxhp_4 = self.ability:GetArtifactSpecialValueFor("poison_maxhp_4")*0.01
    self.poison_hp_4 = self.ability:GetArtifactSpecialValueFor("poison_hp_4")*0.01
    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.radius_10 = self.ability:GetArtifactSpecialValueFor("radius_10")
    self.down_10 = self.ability:GetArtifactSpecialValueFor("down_10")

    self.incoming_other = self.incoming
    self.incoming_self = self.incoming

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_rot_snake_effects")

    if self.level >= 10 then
        self.incoming_other = self.incoming_1
        self.incoming_self = self.incoming_1*0.5
    end
    if self.level >= 100 then
        self.radius = self.radius_10
        self.down_2 = self.down_10
    end

    if IsServer() then
        self:StartIntervalThink(self.interval)
    end
end

function modifier_item_hd_rot_snake_effects:OnRefresh()

    self.ability = self:GetAbility()
    self.health_pct = self.ability:GetArtifactSpecialValueFor("health_pct")
    self.interval = self.ability:GetArtifactSpecialValueFor("interval")
    self.radius = self.ability:GetArtifactSpecialValueFor("radius")
    self.incoming = self.ability:GetArtifactSpecialValueFor("incoming")
    self.incoming_1 = self.ability:GetArtifactSpecialValueFor("incoming_1")
    self.down_2 = self.ability:GetArtifactSpecialValueFor("down_2")
    self.poison_3 = self.ability:GetArtifactSpecialValueFor("poison_3")
    self.poison_maxhp_4 = self.ability:GetArtifactSpecialValueFor("poison_maxhp_4")*0.01
    self.poison_hp_4 = self.ability:GetArtifactSpecialValueFor("poison_hp_4")*0.01
    self.atb = self.ability:GetArtifactSpecialValueFor("atb")
    self.radius_10 = self.ability:GetArtifactSpecialValueFor("radius_10")
    self.down_10 = self.ability:GetArtifactSpecialValueFor("down_10")
    self.incoming_other = self.incoming
    self.incoming_self = self.incoming

    self.level = GetArtifactLevel(self:GetParent():GetPlayerOwnerID(),"item_hd_rot_snake_effects")

    if self.level >= 10 then
        self.incoming_other = self.incoming_1
        self.incoming_self = self.incoming_1*0.5
    end
    if self.level >= 100 then
        self.radius = self.radius_10
        self.down_2 = self.down_10
    end
end
function modifier_item_hd_rot_snake_effects:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end
function modifier_item_hd_rot_snake_effects:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        advanced_MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        advanced_MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE_MUL,
        advanced_MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
    }
end
function modifier_item_hd_rot_snake_effects:OnTooltip()
    return self.atb *self:GetStackCount()
end
function modifier_item_hd_rot_snake_effects:Advanced_GetModifierBonusStats_Strength()
    return self.atb *self:GetStackCount()
end
function modifier_item_hd_rot_snake_effects:Advanced_GetModifierBonusStats_Agility()
    return self.atb *self:GetStackCount()
end
function modifier_item_hd_rot_snake_effects:Advanced_GetModifierBonusStats_Intellect()
    return self.atb *self:GetStackCount()
end
function modifier_item_hd_rot_snake_effects:AdvancedGetModifierExtraHealthPercentage()
    return self.health_pct
end

function modifier_item_hd_rot_snake_effects:OnIntervalThink()
    if not IsServer() then return end
    if not self:GetAbility() then return end
    local team = DOTA_UNIT_TARGET_TEAM_BOTH
    if self.level >= 100 then
        team = DOTA_UNIT_TARGET_TEAM_ENEMY
    end
    local parent = self:GetParent()
    local units = FindUnitsInRadius(
        parent:GetTeamNumber(),
        parent:GetAbsOrigin(),
        nil,
        self.radius,
        team,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    self.debuff_table = {
        duration = self.interval,
        --incoming = 0,
        down = 0,
        poison_resist = 0,
    }

    if self.level >= 20 then
        self.debuff_table.down = self.down_2 
        if self.level >= 30 then
            self.debuff_table.poison_resist = self.poison_3
        end
    end

    local poison = math.max(parent:GetMaxHealth()*self.poison_maxhp_4, parent:GetHealth()*self.poison_hp_4)
    for _, unit in pairs(units) do

        if unit == parent then
            self.debuff_table.incoming = self.incoming_self
            if self.level >= 70 then
                self.debuff_table.incoming = 0
            end
        else
            self.debuff_table.incoming = self.incoming_other
        end

        unit:AddNewModifier(parent, self.ability, "modifier_item_hd_rot_snake_effects_debuff", self.debuff_table)
        if self.level >= 40 and poison > 0 then
            if self.level >= 70 then
                if IsEnemy(unit, parent) or unit == parent then
                    if unit == parent then
                        unit:Poison(parent, self.ability, poison*0.5) 
                    else
                        unit:Poison(parent, self.ability, poison) 
                    end
                end
            else
                unit:Poison(parent, self.ability, poison) 
            end
        end
    end
    self:SetStackCount(math.max(0,#units))
end

function modifier_item_hd_rot_snake_effects:Advanced_GetModifierTotalDamageOutgoing_Percentage_Mul(keys)
    if not IsServer() then return end
    local caster = keys.attacker
    local target = keys.target
    if not IsEnemy(target,caster) then return end
    if self.level < 30 then return end
    
    if target:HasModifier("modifier_hd_poison") then
        return self.poison_3
    end
    return 0
end
-------
modifier_item_hd_rot_snake_effects_debuff = advanced_modifier({})

function modifier_item_hd_rot_snake_effects_debuff:IsDebuff() return true end
function modifier_item_hd_rot_snake_effects_debuff:IsHidden() return false end
function modifier_item_hd_rot_snake_effects_debuff:IsPurgable() return false end
function modifier_item_hd_rot_snake_effects_debuff:GetTexture() return "item_artifact_65" end
function modifier_item_hd_rot_snake_effects_debuff:OnCreated(keys)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.incoming = keys.incoming or 0
    self.down = keys.down or 0
    self.poison_resist = keys.poison_resist or 0
    self:SetHasCustomTransmitterData( true )-- 同步cy
end
function modifier_item_hd_rot_snake_effects_debuff:OnRefresh(keys)
    if not IsServer() then return end
    self.ability = self:GetAbility()
    self.incoming = keys.incoming or 0
    self.down = keys.down or 0
    self.poison_resist = keys.poison_resist or 0
end

function modifier_item_hd_rot_snake_effects_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_hd_rot_snake_effects_debuff:ADDeclareFunctions()
    return {
        advanced_MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
        advanced_MODIFIER_PROPERTY_INCOMING_POISON_DAMAGE_PERCENTAGE,
    }
end

function modifier_item_hd_rot_snake_effects_debuff:Advanced_GetModifierIncomingDamage_Percentage()
    return self.incoming
end

function modifier_item_hd_rot_snake_effects_debuff:Advanced_GetModifierBaseDamageOutgoing_Percentage()
    return -self.down
end

function modifier_item_hd_rot_snake_effects_debuff:Advanced_GetModifierIncomingPoisonDamagePercentage()
    return self.poison_resist
end

function modifier_item_hd_rot_snake_effects_debuff:OnTooltip()
    self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self.incoming
    elseif self._tooltip == 2 then
        return self.down
    elseif self._tooltip == 3 then
        return self.poison_resist
	end
end

function modifier_item_hd_rot_snake_effects_debuff:AddCustomTransmitterData( )
	return
	{
        incoming = self.incoming,
        down = self.down,
        poison_resist = self.poison_resist,
	}
end

function modifier_item_hd_rot_snake_effects_debuff:HandleCustomTransmitterData( data )
    self.incoming = data.incoming
    self.down = data.down
    self.poison_resist = data.poison_resist
end